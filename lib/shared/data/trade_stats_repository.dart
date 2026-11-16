import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/user_repository.dart';
import '../../features/auth/domain/app_user.dart';
import '../../features/trade/data/trade_repository.dart';
import '../../features/trade/domain/trade_models.dart';
import '../../features/transport/data/transport_repository.dart';
import '../../features/transport/domain/delivery.dart';

/// Public track record of a farmer or transporter (76, 80, 119/120).
///
/// Firestore: stats/{uid}/deals/{orderId} — one entry per finished deal,
/// written once by the person's own app; the rules check it against the
/// real order / delivery (status, on-time from stored timestamps, route).
/// stats/{uid}/complaints/{reportId} — one per trip-related report a
/// trade partner filed about them (created with the report).
class TradeStats {
  const TradeStats({
    required this.done,
    required this.onTime,
    required this.cancelled,
    required this.complaints,
    this.topFrom,
    this.topTo,
  });

  static const empty = TradeStats(
    done: 0,
    onTime: 0,
    cancelled: 0,
    complaints: 0,
  );

  final int done;
  final int onTime;
  final int cancelled;
  final int complaints;

  /// Most frequent route (district "bn|en" values), transporters only.
  final String? topFrom;
  final String? topTo;

  /// 0–100, null before the first finished deal.
  int? get onTimePct => done == 0 ? null : (onTime * 100 / done).round();
  int? get cancelPct => done + cancelled == 0
      ? null
      : (cancelled * 100 / (done + cancelled)).round();

  /// Complaints per finished deal, in % (one decimal).
  double? get complaintPct =>
      done == 0 ? null : (complaints * 1000 / done).round() / 10;
}

class TradeStatsRepository {
  TradeStatsRepository(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _deals(String uid) =>
      _db.collection('stats').doc(uid).collection('deals');
  CollectionReference<Map<String, dynamic>> complaints(String uid) =>
      _db.collection('stats').doc(uid).collection('complaints');

  /// Loading counts as on time up to the end of the pickup day (farmer).
  static bool farmerOnTime(TradeOrder o) {
    final loaded = o.timeline['pickedUp'];
    final day = o.pickupDate;
    if (loaded == null || day == null) return false;
    return !loaded.isAfter(day.add(const Duration(days: 1)));
  }

  /// Delivered within 1.5 × road time (+1 h) after loading (transporter).
  /// Same formula as firestore.rules.
  static int windowMinutes(Delivery d) =>
      ((d.distanceKm ?? 0) * 2.925).toInt() + 60;

  static bool transporterOnTime(Delivery d) {
    final up = d.timeline['pickedUp'];
    final down = d.timeline['delivered'];
    if (up == null || down == null) return false;
    return !down.isAfter(up.add(Duration(minutes: windowMinutes(d))));
  }

  Stream<TradeStats> watch(String uid) {
    final deals = _deals(uid).limit(500).snapshots();
    return deals.asyncMap((q) async {
      var done = 0, onTime = 0, cancelled = 0;
      final routes = <String, int>{};
      for (final d in q.docs) {
        final m = d.data();
        if (m['outcome'] == 'cancelled') {
          cancelled++;
          continue;
        }
        done++;
        if (m['onTime'] == true) onTime++;
        final from = m['from'] as String?, to = m['to'] as String?;
        if (from != null && to != null && from.isNotEmpty && to.isNotEmpty) {
          routes['$from\n$to'] = (routes['$from\n$to'] ?? 0) + 1;
        }
      }
      final c = await complaints(uid).count().get();
      String? top;
      for (final e in routes.entries) {
        if (top == null || e.value > routes[top]!) top = e.key;
      }
      return TradeStats(
        done: done,
        onTime: onTime,
        cancelled: cancelled,
        complaints: c.count ?? 0,
        topFrom: top?.split('\n').first,
        topTo: top?.split('\n').last,
      );
    });
  }

  Future<Set<String>> _known(String uid) async => {
    for (final d in (await _deals(uid).get()).docs) d.id,
  };

  /// Farmer: delivered / completed orders not yet in the record.
  Future<void> syncFarmer(String uid, List<TradeOrder> orders) async {
    final finished = orders.where(
      (o) =>
          o.farmerId == uid &&
          (o.status == OrderStatus.delivered ||
              o.status == OrderStatus.completed),
    );
    if (finished.isEmpty) return;
    final known = await _known(uid);
    for (final o in finished) {
      if (known.contains(o.id)) continue;
      await _create(uid, o.id, {
        'role': 'farmer',
        'outcome': 'done',
        'onTime': farmerOnTime(o),
        'from': o.pickup.district ?? '',
        'to': o.dropoff.district ?? '',
      });
    }
  }

  /// Transporter: delivered or cancelled trips not yet in the record.
  Future<void> syncTransporter(String uid, List<Delivery> trips) async {
    final finished = trips.where(
      (d) =>
          d.transporterId == uid &&
          (d.status == DeliveryStatus.delivered ||
              d.status == DeliveryStatus.cancelled),
    );
    if (finished.isEmpty) return;
    final known = await _known(uid);
    for (final d in finished) {
      if (known.contains(d.id)) continue;
      final done = d.status == DeliveryStatus.delivered;
      await _create(uid, d.id, {
        'role': 'transporter',
        'outcome': done ? 'done' : 'cancelled',
        'onTime': done && transporterOnTime(d),
        'from': d.pickup.district ?? '',
        'to': d.dropoff.district ?? '',
      });
    }
  }

  Future<void> _create(String uid, String id, Map<String, dynamic> m) async {
    try {
      await _deals(uid).doc(id).set({...m, 'at': FieldValue.serverTimestamp()});
    } catch (_) {
      // Old data the rules can't verify (e.g. missing timestamps): skip.
    }
  }
}

final tradeStatsRepositoryProvider = Provider<TradeStatsRepository>(
  (ref) => TradeStatsRepository(ref.watch(firestoreProvider)),
);

final tradeStatsProvider = StreamProvider.family<TradeStats, String>(
  (ref, uid) => ref.watch(tradeStatsRepositoryProvider).watch(uid),
);

/// Keeps the signed-in farmer's / transporter's record up to date.
/// Watched once from the app widget.
final tradeStatsSyncProvider = Provider<void>((ref) {
  final me = ref.watch(currentUserProvider).value;
  if (me == null) return;
  final repo = ref.read(tradeStatsRepositoryProvider);
  switch (me.role) {
    case UserRole.farmer:
      final orders = ref.watch(myOrdersProvider).value;
      if (orders != null) repo.syncFarmer(me.uid, orders);
    case UserRole.transporter:
      final trips = ref.watch(myDeliveriesProvider).value;
      if (trips != null) repo.syncTransporter(me.uid, trips);
    default:
      break;
  }
});
