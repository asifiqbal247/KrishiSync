import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/user_repository.dart';
import '../services/dam_price_service.dart';

/// A crop's market price per kg. Live from DAM (Department of Agricultural
/// Marketing, see [DamPriceService]) for the crops it reports; otherwise
/// Firestore marketPrices/{cropKey}, typed in by Admin (A5).
class MarketPrice {
  const MarketPrice({
    required this.cropKey,
    required this.price,
    required this.min,
    required this.max,
    required this.prevPrice,
    this.updatedAt,
    this.fromDam = false,
  });

  /// True when the price came live from DAM.
  final bool fromDam;

  final String cropKey;
  final num price;
  final num min;
  final num max;
  final num prevPrice;
  final DateTime? updatedAt;

  /// Percent change vs previous price, e.g. 12 or -8.
  int get changePct =>
      prevPrice == 0 ? 0 : (((price - prevPrice) / prevPrice) * 100).round();

  factory MarketPrice.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    final price = m['price'] as num? ?? 0;
    return MarketPrice(
      cropKey: d.id,
      price: price,
      min: m['min'] as num? ?? price,
      max: m['max'] as num? ?? price,
      prevPrice: m['prevPrice'] as num? ?? price,
      updatedAt: (m['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}

class MarketPriceRepository {
  MarketPriceRepository(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('marketPrices');

  Stream<List<MarketPrice>> watchAll() => _col
      .snapshots()
      .map((q) => [for (final d in q.docs) MarketPrice.fromDoc(d)]);

  Stream<MarketPrice?> watch(String cropKey) => _col
      .doc(cropKey)
      .snapshots()
      .map((d) => d.exists ? MarketPrice.fromDoc(d) : null);

  static String dayKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Admin only (enforced by rules). Saves the day's price in history;
  /// today's price also becomes the current price shown everywhere.
  Future<void> set(String cropKey,
      {required num price,
      required num min,
      required num max,
      required num prevPrice,
      DateTime? day,
      String cropBn = '',
      String cropEn = '',
      String fromUid = ''}) async {
    final d = day ?? DateTime.now();
    final now = DateTime.now();
    final isToday =
        d.year == now.year && d.month == now.month && d.day == now.day;
    final b = _db.batch();
    b.set(_col.doc(cropKey).collection('history').doc(dayKey(d)), {
      'price': price,
      'min': min,
      'max': max,
      'date': Timestamp.fromDate(DateTime(d.year, d.month, d.day)),
    });
    if (isToday) {
      b.set(_col.doc(cropKey), {
        'price': price,
        'min': min,
        'max': max,
        'prevPrice': prevPrice,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await b.commit();
    if (isToday && fromUid.isNotEmpty) {
      await _fireAlerts(cropKey, price, cropBn, cropEn, fromUid);
    }
  }

  // ---------------- price alerts (30) ----------------
  // priceAlerts/{uid}_{crop}: the user is told once when the admin's price
  // reaches the target (up for sellers, down for buyers), then it is removed.

  CollectionReference<Map<String, dynamic>> get _alerts =>
      _db.collection('priceAlerts');

  Stream<PriceAlert?> watchAlert(String uid, String cropKey) => _alerts
      .doc('${uid}_$cropKey')
      .snapshots()
      .map((d) => d.exists ? PriceAlert.fromDoc(d) : null);

  Future<void> setAlert(String uid, String cropKey,
          {required num target, required bool above}) =>
      _alerts.doc('${uid}_$cropKey').set({
        'uid': uid,
        'cropKey': cropKey,
        'target': target,
        'above': above,
        'createdAt': FieldValue.serverTimestamp(),
      });

  Future<void> removeAlert(String uid, String cropKey) =>
      _alerts.doc('${uid}_$cropKey').delete();

  Future<void> _fireAlerts(String cropKey, num price, String cropBn,
      String cropEn, String fromUid) async {
    final q = await _alerts.where('cropKey', isEqualTo: cropKey).get();
    final b = _db.batch();
    var any = false;
    for (final d in q.docs) {
      final a = PriceAlert.fromDoc(d);
      if (!(a.above ? price >= a.target : price <= a.target)) continue;
      any = true;
      b.set(_db.collection('notifications').doc(a.uid).collection('items').doc(), {
        'type': 'price_alert',
        'params': {
          'cropBn': cropBn,
          'cropEn': cropEn,
          'price': '$price',
          'target': '${a.target}',
        },
        'link': 'price:$cropKey',
        'fromUid': fromUid,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
      b.delete(d.reference);
    }
    if (any) await b.commit();
  }

  /// Last [days] days of history, oldest first.
  Stream<List<PricePoint>> watchHistory(String cropKey, int days) {
    final from = DateTime.now().subtract(Duration(days: days));
    return _col
        .doc(cropKey)
        .collection('history')
        .where('date',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(DateTime(from.year, from.month, from.day)))
        .orderBy('date')
        .snapshots()
        .map((q) => [
              for (final d in q.docs)
                PricePoint(
                  (d.data()['date'] as Timestamp).toDate(),
                  d.data()['price'] as num? ?? 0,
                ),
            ]);
  }
}

class PriceAlert {
  const PriceAlert(this.uid, this.cropKey, this.target, this.above);
  final String uid;
  final String cropKey;
  final num target;
  final bool above;

  factory PriceAlert.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    return PriceAlert(m['uid'] as String? ?? '', m['cropKey'] as String? ?? '',
        m['target'] as num? ?? 0, m['above'] as bool? ?? true);
  }
}

/// One day's price (Price Trend 30).
class PricePoint {
  const PricePoint(this.date, this.price);
  final DateTime date;
  final num price;
}

final marketPriceRepositoryProvider = Provider<MarketPriceRepository>(
    (ref) => MarketPriceRepository(ref.watch(firestoreProvider)));

final damPriceServiceProvider = Provider((ref) => DamPriceService());

/// How often the live DAM prices are fetched again.
const _damRefresh = Duration(minutes: 30);

/// Latest DAM prices: the newest day with data is "today", the day before
/// it with data gives the change. Empty when offline (admin prices used).
final damPricesProvider = FutureProvider<Map<String, MarketPrice>>((ref) async {
  final timer = Timer(_damRefresh, ref.invalidateSelf);
  ref.onDispose(timer.cancel);
  final dam = ref.watch(damPriceServiceProvider);
  final now = DateTime.now();
  final days = <Map<int, DamPrice>>[];
  for (var i = 0; i < DamPriceService.lookBackDays && days.length < 2; i++) {
    try {
      final d = await dam.day(now.subtract(Duration(days: i)));
      if (d.isNotEmpty) days.add(d);
    } catch (_) {
      if (i == 0) return const {}; // offline: don't wait on more requests
    }
  }
  return {
    for (final key in DamPriceService.commodities.keys)
      if (DamPriceService.pick(days.firstOrNull ?? const {}, key)
          case final cur?)
        key: MarketPrice(
          cropKey: key,
          price: cur.mid.round(),
          min: cur.min.round(),
          max: cur.max.round(),
          prevPrice: (days.length > 1
                      ? DamPriceService.pick(days[1], key)
                      : null)
                  ?.mid
                  .round() ??
              cur.mid.round(),
          updatedAt: cur.updatedAt,
          fromDam: true,
        ),
  };
});

/// All market prices: live DAM where available, admin prices otherwise.
final marketPricesProvider = StreamProvider<List<MarketPrice>>((ref) {
  final dam = ref.watch(damPricesProvider).value ?? const {};
  return ref.watch(marketPriceRepositoryProvider).watchAll().map(
        (admin) => {for (final p in admin) p.cropKey: p, ...dam}.values.toList(),
      );
});

final marketPriceProvider = Provider.family<AsyncValue<MarketPrice?>, String>(
  (ref, key) => ref
      .watch(marketPricesProvider)
      .whenData((all) => all.where((p) => p.cropKey == key).firstOrNull),
);

/// Price trend (30): one point per day. DAM crops use DAM's daily reports
/// (cached per day); others use the admin's Firestore history.
final priceHistoryProvider =
    StreamProvider.family<List<PricePoint>, (String, int)>((ref, k) {
  final (cropKey, days) = k;
  final repo = ref.watch(marketPriceRepositoryProvider);
  if (!DamPriceService.commodities.containsKey(cropKey)) {
    return repo.watchHistory(cropKey, days);
  }
  final dam = ref.watch(damPriceServiceProvider);
  final now = DateTime.now();
  Future<List<PricePoint>> load() async {
    final all = await Future.wait([
      for (var i = days; i >= 0; i--)
        () async {
          final d = now.subtract(Duration(days: i));
          try {
            final p = DamPriceService.pick(await dam.day(d), cropKey);
            return p == null
                ? null
                : PricePoint(DateTime(d.year, d.month, d.day), p.mid.round());
          } catch (_) {
            return null;
          }
        }(),
    ]);
    return all.whereType<PricePoint>().toList();
  }

  return Stream.fromFuture(load()).asyncExpand(
    (pts) => pts.isEmpty ? repo.watchHistory(cropKey, days) : Stream.value(pts),
  );
});

final priceAlertProvider =
    StreamProvider.family<PriceAlert?, String>((ref, cropKey) {
  final uid = ref.watch(currentUserProvider).value?.uid;
  if (uid == null) return Stream.value(null);
  return ref.watch(marketPriceRepositoryProvider).watchAlert(uid, cropKey);
});
