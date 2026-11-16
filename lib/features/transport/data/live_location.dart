import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../domain/delivery.dart';
import 'transport_repository.dart';

/// The truck's last known position for one trip.
/// Firestore: deliveries/{id}/live/pos — written by the assigned driver's
/// phone while the trip is assigned or on the way; read by the buyer,
/// farmer and driver (rules).
class LivePos {
  const LivePos(this.geo, this.at);
  final GeoPoint geo;
  final DateTime? at;
}

class LiveLocationRepository {
  LiveLocationRepository(this._db);
  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _pos(String deliveryId) =>
      _db.collection('deliveries').doc(deliveryId).collection('live').doc('pos');

  Stream<LivePos?> watch(String deliveryId) =>
      _pos(deliveryId).snapshots().map((d) {
        final g = d.data()?['geo'];
        if (g is! GeoPoint) return null;
        return LivePos(g, (d.data()?['at'] as Timestamp?)?.toDate());
      });

  Future<void> push(String deliveryId, double lat, double lng) =>
      _pos(deliveryId).set({
        'geo': GeoPoint(lat, lng),
        'at': FieldValue.serverTimestamp(),
      });
}

final liveLocationRepositoryProvider = Provider<LiveLocationRepository>(
    (ref) => LiveLocationRepository(ref.watch(firestoreProvider)));

final livePosProvider = StreamProvider.family<LivePos?, String>(
    (ref, id) => ref.watch(liveLocationRepositoryProvider).watch(id));

/// Straight-line distance in km.
double kmBetween(GeoPoint a, GeoPoint b) =>
    Geolocator.distanceBetween(a.latitude, a.longitude, b.latitude, b.longitude) /
    1000;

/// Share of the trip still left (0..1), from the truck's position:
/// straight-line truck→drop over pickup→drop. Used to scale road km and
/// road hours.
double? tripLeft(Delivery d, LivePos? live) {
  final a = d.pickup.geo;
  final b = d.dropoff.geo;
  if (live == null || a == null || b == null) return null;
  final whole = kmBetween(a, b);
  if (whole <= 0) return null;
  return min(1, kmBetween(live.geo, b) / whole);
}

/// Runs for a signed-in transporter: while any of their trips is assigned
/// or on the way and the app is open, the phone's position is sent to
/// those trips (at most every [_every], after moving [_moveM] metres).
/// Watched once from the app widget.
final liveTrackerProvider = Provider<void>((ref) {
  final me = ref.watch(currentUserProvider).value;
  if (me == null || me.role != UserRole.transporter) return;
  final active = [
    for (final d in ref.watch(myDeliveriesProvider).value ?? const <Delivery>[])
      if (d.transporterId == me.uid &&
          (d.status == DeliveryStatus.assigned ||
              d.status == DeliveryStatus.pickedUp))
        d.id,
  ];
  if (active.isEmpty) return;

  final repo = ref.read(liveLocationRepositoryProvider);
  StreamSubscription<Position>? sub;
  Timer? later;
  var stopped = false;
  DateTime? last;
  Position? latest;

  Future<void> flush() async {
    final p = latest;
    if (p == null || stopped) return;
    latest = null;
    last = DateTime.now();
    for (final id in active) {
      try {
        await repo.push(id, p.latitude, p.longitude);
      } catch (_) {
        // Offline or the trip just ended: the next fix tries again.
      }
    }
  }

  // Sends at most every [_every]; a newer fix inside that window waits and
  // is sent when the window ends (never dropped).
  void send(Position p) {
    latest = p;
    final since = last == null ? null : DateTime.now().difference(last!);
    if (since == null || since >= _every) {
      later?.cancel();
      flush();
    } else {
      later ??= Timer(_every - since, () {
        later = null;
        flush();
      });
    }
  }

  Future<void> start() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return;
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever ||
          stopped) {
        return;
      }
      // A cached fix only if it is fresh; an old one would show the truck
      // where the phone was hours ago.
      final first = await Geolocator.getLastKnownPosition();
      if (first != null &&
          DateTime.now().difference(first.timestamp) < _freshFix) {
        send(first);
      }
      if (stopped) return;
      sub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: _moveM,
        ),
      ).listen(send, onError: (_) {});
    } catch (_) {
      // No GPS on this device: tracking simply stays off.
    }
  }

  start();
  ref.onDispose(() {
    stopped = true;
    sub?.cancel();
    later?.cancel();
  });
});

const _every = Duration(seconds: 30);
const _freshFix = Duration(minutes: 5);
const _moveM = 50;
