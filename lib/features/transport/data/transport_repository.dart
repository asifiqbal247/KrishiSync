import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../trade/data/trade_repository.dart';
import '../../trade/domain/trade_models.dart';
import '../domain/delivery.dart';

class TransportException implements Exception {
  TransportException(this.code);
  final String code; // wrong_otp | not_open | failed
}

/// One star rating inside a [TransportRepository.submitReviews] call.
class ReviewInput {
  const ReviewInput({
    required this.toUid,
    required this.toRole,
    required this.stars,
    this.tags = const [],
  });
  final String toUid;
  final String toRole; // farmer | buyer | transporter
  final int stars;
  final List<String> tags;
}

/// Deliveries ("loads"), transporter bids, trip status and ratings.
/// Firestore rules check every step (see firestore.rules).
class TransportRepository {
  TransportRepository(this._db, this._trade);
  final FirebaseFirestore _db;
  final TradeRepository _trade;

  CollectionReference<Map<String, dynamic>> get _deliveries =>
      _db.collection('deliveries');
  CollectionReference<Map<String, dynamic>> _bids(String id) =>
      _deliveries.doc(id).collection('bids');
  DocumentReference<Map<String, dynamic>> _order(String id) =>
      _db.collection('orders').doc(id);

  List<Delivery> _list(QuerySnapshot<Map<String, dynamic>> q) =>
      [for (final d in q.docs) Delivery.fromDoc(d)];

  /// 194 Vehicle & Capacity → users/{uid}.vehicle.
  Future<void> saveVehicle(String uid, Vehicle v) =>
      _db.collection('users').doc(uid).update({
        'vehicle': v.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

  // ---------------- reading ----------------

  Stream<List<Delivery>> watchOpenLoads() => _deliveries
      .where('status', isEqualTo: DeliveryStatus.open.name)
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots()
      .map(_list);

  Stream<Delivery?> watchDelivery(String id) => _deliveries
      .doc(id)
      .snapshots()
      .map((d) => d.exists ? Delivery.fromDoc(d) : null);

  Stream<List<Delivery>> watchFor(String field, String uid) => _deliveries
      .where(field, isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots()
      .map(_list);

  Stream<List<Bid>> watchBids(String deliveryId) => _bids(deliveryId)
      .orderBy('fare')
      .snapshots()
      .map((q) => [for (final d in q.docs) Bid.fromDoc(d)]);

  /// Only the buyer can read this (rules).
  Stream<String?> watchOtp(String deliveryId) => _deliveries
      .doc(deliveryId)
      .collection('private')
      .doc('otp')
      .snapshots()
      .map((d) => d.data()?['code'] as String?);

  /// Buyer's optional delivery photo (110), kept with the private OTP.
  Future<void> saveReceiptPhoto(String deliveryId, String url) => _deliveries
      .doc(deliveryId)
      .collection('private')
      .doc('receipt')
      .set({'photoUrl': url, 'createdAt': FieldValue.serverTimestamp()});

  // ---------------- transporter: bid ----------------

  /// Accept at the suggested fare (144) or send an own fare (145).
  Future<void> placeBid(Delivery d, AppUser me, num fare) async {
    await _bids(d.id).doc(me.uid).set({
      'name': me.name,
      'photoUrl': me.photoUrl,
      'vehicle': me.vehicle?.toMap(),
      'ratingAvg': me.ratingAvg,
      'ratingCount': me.ratingCount,
      'fare': fare,
      'status': BidStatus.pending.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _trade.notify(
      toUid: d.buyerId,
      fromUid: me.uid,
      type: 'bid_new',
      params: {
        'no': d.orderNo,
        'name': me.name,
        'fare': '$fare',
      },
      link: 'book:${d.id}',
    );
  }

  // ---------------- buyer: book a bid (116) ----------------

  Future<void> book(Delivery d, Bid bid, TradeOrder order) async {
    final b = _db.batch();
    final now = FieldValue.serverTimestamp();
    b.update(_deliveries.doc(d.id), {
      'status': DeliveryStatus.assigned.name,
      'transporterId': bid.transporterId,
      'transporterName': bid.name,
      'transporterPhotoUrl': bid.photoUrl,
      'vehicle': bid.vehicle.toMap(),
      'fare': bid.fare,
      'timeline.assigned': now,
      'updatedAt': now,
    });
    b.update(_bids(d.id).doc(bid.transporterId),
        {'status': BidStatus.accepted.name});
    b.update(_order(order.id), {
      'status': OrderStatus.transportBooked.name,
      'transporterId': bid.transporterId,
      'transporterName': bid.name,
      'transportFare': bid.fare,
      'total': order.total - order.transportFare + bid.fare,
      'timeline.transportBooked': now,
      'updatedAt': now,
    });
    await b.commit();
    // A booking on the driver's saved way back opens 177 (return load
    // confirmed) instead of the plain job screen.
    var link = 'job:${d.id}';
    try {
      final r = AppUser.fromDoc(
              await _db.collection('users').doc(bid.transporterId).get())
          .returnRoute;
      if (r != null &&
          r.from == d.pickup.district &&
          r.to == d.dropoff.district) {
        link = 'return:${d.id}';
      }
    } catch (_) {}
    await _trade.notify(
      toUid: bid.transporterId,
      fromUid: d.buyerId,
      type: 'job_assigned',
      params: {'no': d.orderNo, 'cropBn': d.cropNameBn, 'cropEn': d.cropNameEn},
      link: link,
    );
    // 45: the farmer sees the truck and the loading code.
    await _trade.notify(
      toUid: d.farmerId,
      fromUid: d.buyerId,
      type: 'truck_booked',
      params: {'no': d.orderNo, 'name': bid.name},
      link: 'truck:${order.id}',
    );
  }

  // ---------------- loading code (45 / 162) ----------------

  DocumentReference<Map<String, dynamic>> _loadCode(String deliveryId) =>
      _deliveries.doc(deliveryId).collection('load').doc('code');

  /// Farmer's 4-digit loading code; made on first view. Only the farmer can
  /// read it (rules); the driver must type it to confirm the load.
  Stream<String?> watchLoadCode(String deliveryId) =>
      _loadCode(deliveryId).snapshots().map((d) => d.data()?['code'] as String?);

  Future<void> ensureLoadCode(String deliveryId) async {
    final ref = _loadCode(deliveryId);
    if ((await ref.get()).exists) return;
    final code = (1000 + Random.secure().nextInt(9000)).toString();
    await ref.set({'code': code});
  }

  // ---------------- extra weight (52 / 134) ----------------

  /// Scale shows more than ordered: ask the buyer first.
  Future<void> requestExtra(TradeOrder o, num weighedKg, String byUid) async {
    await _order(o.id).update({
      'extraKg': weighedKg - o.quantityKg,
      'extraStatus': 'pending',
      'extraAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await _trade.notify(
      toUid: o.buyerId,
      fromUid: byUid,
      type: 'extra_request',
      params: {
        'no': o.orderNo,
        'qty': '${weighedKg - o.quantityKg}',
        'cropBn': o.cropNameBn,
        'cropEn': o.cropNameEn,
      },
      link: 'extra:${o.id}',
    );
  }

  /// Buyer approves (pays the extra, placeholder) or keeps the ordered amount.
  Future<void> answerExtra(TradeOrder o, bool approve) async {
    await _order(o.id).update({
      'extraStatus': approve ? 'approved' : 'declined',
      'updatedAt': FieldValue.serverTimestamp(),
    });
    if (o.transporterId == null) return;
    await _trade.notify(
      toUid: o.transporterId!,
      fromUid: o.buyerId,
      type: approve ? 'extra_approved' : 'extra_declined',
      params: {'no': o.orderNo},
      link: 'job:${o.id}',
    );
  }

  /// Order amounts for [kg] at the order's price (fare stays the same).
  static Map<String, num> amountsFor(TradeOrder o, num kg) {
    final crop = kg * o.pricePerKg;
    final fee = (crop * TradeRepository.platformFeePct / 100).round();
    return {
      'quantityKg': kg,
      'cropTotal': crop,
      'platformFee': fee,
      'total': crop + o.transportFare + fee,
    };
  }

  // ---------------- transporter: trip ----------------

  /// 162: weighed and loaded at the farm with the farmer's code. Farmer is
  /// paid for the weighed amount; if less, the buyer gets the rest back.
  Future<void> markPickedUp(
    Delivery d,
    TradeOrder o,
    String byUid, {
    required num loadedKg,
    required String otp,
    List<String> photos = const [],
  }) async {
    final b = _db.batch();
    final now = FieldValue.serverTimestamp();
    b.update(_deliveries.doc(d.id), {
      'status': DeliveryStatus.pickedUp.name,
      'loadedKg': loadedKg,
      'loadOtpInput': otp,
      'loadPhotos': photos,
      'timeline.pickedUp': now,
      'updatedAt': now,
    });
    final amounts = amountsFor(o, loadedKg);
    b.update(_order(d.orderId), {
      'status': OrderStatus.pickedUp.name,
      'orderedKg': o.quantityKg,
      ...amounts,
      'weightRefund': loadedKg < o.quantityKg ? o.total - amounts['total']! : 0,
      'loadPhotos': photos,
      'timeline.pickedUp': now,
      'updatedAt': now,
    });
    try {
      await b.commit();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') throw TransportException('wrong_otp');
      rethrow;
    }
    final params = {'no': d.orderNo, 'cropBn': d.cropNameBn, 'cropEn': d.cropNameEn};
    final less = loadedKg < o.quantityKg;
    await _trade.notify(
        toUid: d.buyerId, fromUid: byUid,
        type: less ? 'weight_less' : 'trip_picked',
        params: params,
        link: less ? 'weight:${d.orderId}' : 'order:${d.orderId}');
    await _trade.notify(
        toUid: d.farmerId, fromUid: byUid, type: 'loaded_paid',
        params: params, link: 'loaded:${d.orderId}');
  }

  /// Proof of delivery (167). Rules compare [otp] with the buyer's code.
  Future<void> markDelivered(
    Delivery d,
    String byUid, {
    required String otp,
    required num deliveredKg,
    String? photoUrl,
  }) async {
    final b = _db.batch();
    final now = FieldValue.serverTimestamp();
    b.update(_deliveries.doc(d.id), {
      'status': DeliveryStatus.delivered.name,
      'otpInput': otp,
      'deliveredKg': deliveredKg,
      'proofPhotoUrl': photoUrl,
      'timeline.delivered': now,
      'updatedAt': now,
    });
    b.update(_order(d.orderId), {
      'status': OrderStatus.delivered.name,
      'timeline.delivered': now,
      'updatedAt': now,
    });
    try {
      await b.commit();
    } on FirebaseException catch (e) {
      // A wrong code fails the rules check.
      if (e.code == 'permission-denied') throw TransportException('wrong_otp');
      rethrow;
    }
    await _trade.notify(
      toUid: d.buyerId,
      fromUid: byUid,
      type: 'trip_delivered',
      params: {'no': d.orderNo, 'cropBn': d.cropNameBn, 'cropEn': d.cropNameEn},
      link: 'order:${d.orderId}',
    );
  }

  // ---------------- self transport ----------------

  /// Farmer handed the crop to the buyer's own vehicle.
  Future<void> farmerHandedOver(TradeOrder o) => _order(o.id).update({
        'status': OrderStatus.pickedUp.name,
        'timeline.pickedUp': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

  /// Buyer received the crop (self transport).
  Future<void> buyerReceived(TradeOrder o) => _order(o.id).update({
        'status': OrderStatus.delivered.name,
        'timeline.delivered': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

  // ---------------- ratings (111 / 169) ----------------

  static String reviewId(String orderId, String from, String to) =>
      '${orderId}_${from}_$to';

  Future<bool> hasReviewed(String orderId, String from, String to) async =>
      (await _db.collection('reviews').doc(reviewId(orderId, from, to)).get())
          .exists;

  /// Writes reviews + updates each person's average in one batch.
  /// Buyer: also completes the order. Transporter: marks the trip rated.
  Future<void> submitReviews({
    required String orderId,
    required String fromUid,
    required List<ReviewInput> reviews,
    String comment = '',
    bool completeOrder = false,
    String? ratedDeliveryId,
  }) async {
    final users = {
      for (final r in reviews)
        r.toUid: AppUser.fromDoc(await _db.collection('users').doc(r.toUid).get()),
    };
    final b = _db.batch();
    final now = FieldValue.serverTimestamp();
    for (final r in reviews) {
      final id = reviewId(orderId, fromUid, r.toUid);
      b.set(_db.collection('reviews').doc(id), {
        'orderId': orderId,
        'fromUid': fromUid,
        'toUid': r.toUid,
        'toRole': r.toRole,
        'stars': r.stars,
        'tags': r.tags,
        'comment': comment,
        'createdAt': now,
      });
      final u = users[r.toUid]!;
      final count = u.ratingCount + 1;
      final avg = (u.ratingAvg * u.ratingCount + r.stars) / count;
      b.update(_db.collection('users').doc(r.toUid), {
        'ratingAvg': double.parse(avg.toStringAsFixed(2)),
        'ratingCount': count,
        'lastReviewId': id,
      });
    }
    if (completeOrder) {
      b.update(_order(orderId), {
        'status': OrderStatus.completed.name,
        'timeline.completed': now,
        'updatedAt': now,
      });
    }
    if (ratedDeliveryId != null) {
      b.update(_deliveries.doc(ratedDeliveryId),
          {'transporterRated': true, 'updatedAt': now});
    }
    await b.commit();
  }
}

final transportRepositoryProvider = Provider<TransportRepository>((ref) =>
    TransportRepository(
        ref.watch(firestoreProvider), ref.watch(tradeRepositoryProvider)));

final openLoadsProvider = StreamProvider<List<Delivery>>(
    (ref) => ref.watch(transportRepositoryProvider).watchOpenLoads());

final deliveryProvider = StreamProvider.family<Delivery?, String>(
    (ref, id) => ref.watch(transportRepositoryProvider).watchDelivery(id));

final bidsProvider = StreamProvider.family<List<Bid>, String>(
    (ref, id) => ref.watch(transportRepositoryProvider).watchBids(id));

final deliveryOtpProvider = StreamProvider.family<String?, String>(
    (ref, id) => ref.watch(transportRepositoryProvider).watchOtp(id));

/// Transporter: my jobs. Buyer: my deliveries.
final myDeliveriesProvider = StreamProvider<List<Delivery>>((ref) {
  final me = ref.watch(currentUserProvider).value;
  if (me == null) return Stream.value(const []);
  return ref.watch(transportRepositoryProvider).watchFor(
      me.role == UserRole.transporter ? 'transporterId' : 'buyerId', me.uid);
});

final loadCodeProvider = StreamProvider.family<String?, String>(
    (ref, id) => ref.watch(transportRepositoryProvider).watchLoadCode(id));
