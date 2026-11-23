import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../../shared/utils/geo.dart';
import '../../farmer/domain/listing.dart';
import '../domain/trade_models.dart';

class TradeException implements Exception {
  TradeException(this.code);
  final String code; // not_available | qty_too_much | not_found
}

/// Offers, orders and notifications (Firestore).
class TradeRepository {
  TradeRepository(this._db);
  final FirebaseFirestore _db;

  static const offerValidity = Duration(hours: 24);
  static const platformFeePct = 1;
  static const firstOrderNo = 1048;

  CollectionReference<Map<String, dynamic>> get _offers =>
      _db.collection('offers');
  CollectionReference<Map<String, dynamic>> get _orders =>
      _db.collection('orders');
  CollectionReference<Map<String, dynamic>> _notifs(String uid) =>
      _db.collection('notifications').doc(uid).collection('items');

  // ---------------- notifications ----------------

  Future<void> notify({
    required String toUid,
    required String fromUid,
    required String type,
    Map<String, String> params = const {},
    String? link,
  }) => _notifs(toUid).add({
    'type': type,
    'params': params,
    'link': link,
    'fromUid': fromUid,
    'read': false,
    'createdAt': FieldValue.serverTimestamp(),
  });

  Stream<List<AppNotification>> watchNotifications(String uid) =>
      _notifs(uid)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .snapshots()
          .map((q) => [for (final d in q.docs) AppNotification.fromDoc(d)]);

  Future<void> markRead(String uid, String id) =>
      _notifs(uid).doc(id).update({'read': true});

  // ---------------- offers ----------------

  Future<String> createOffer({
    required AppUser buyer,
    required Listing listing,
    required num pricePerKg,
    required num quantityKg,
    required DateTime deliveryDate,
  }) async {
    final ref = _offers.doc();
    await ref.set({
      'listingId': listing.id,
      'farmerId': listing.farmerId,
      'farmerName': listing.farmerName,
      'buyerId': buyer.uid,
      'buyerName': buyer.name,
      'buyerPhotoUrl': buyer.photoUrl,
      'cropKey': listing.cropKey,
      'cropNameBn': listing.cropNameBn,
      'cropNameEn': listing.cropNameEn,
      'grade': listing.grade,
      'listingPhoto': listing.photo,
      'listingPrice': listing.pricePerKg,
      'pricePerKg': pricePerKg,
      'buyerPrice': pricePerKg,
      'quantityKg': quantityKg,
      'deliveryDate': Timestamp.fromDate(deliveryDate),
      'status': OfferStatus.pending.name,
      'lastBy': 'buyer',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(DateTime.now().add(offerValidity)),
    });
    await notify(
      toUid: listing.farmerId,
      fromUid: buyer.uid,
      type: 'offer_new',
      params: {
        'cropBn': listing.cropNameBn,
        'cropEn': listing.cropNameEn,
        'buyer': buyer.name,
        'price': '$pricePerKg',
        'qty': '$quantityKg',
      },
      link: 'offer:${ref.id}',
    );
    return ref.id;
  }

  Stream<Offer?> watchOffer(String id) => _offers
      .doc(id)
      .snapshots()
      .map((d) => d.exists ? Offer.fromDoc(d) : null);

  /// Farmer: offers on one listing.
  Stream<List<Offer>> watchOffersForListing(
    String farmerId,
    String listingId,
  ) => _offers
      .where('farmerId', isEqualTo: farmerId)
      .where('listingId', isEqualTo: listingId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((q) => [for (final d in q.docs) Offer.fromDoc(d)]);

  /// Farmer: all open offers (home card, counts).
  Stream<List<Offer>> watchFarmerOffers(String farmerId) => _offers
      .where('farmerId', isEqualTo: farmerId)
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots()
      .map((q) => [for (final d in q.docs) Offer.fromDoc(d)]);

  Stream<List<Offer>> watchBuyerOffers(String buyerId) => _offers
      .where('buyerId', isEqualTo: buyerId)
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots()
      .map((q) => [for (final d in q.docs) Offer.fromDoc(d)]);

  Future<void> acceptOffer(Offer o, {required String byUid}) async {
    await _offers.doc(o.id).update({
      'status': OfferStatus.accepted.name,
      'lastBy': byUid == o.farmerId ? 'farmer' : 'buyer',
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await notify(
      toUid: byUid == o.farmerId ? o.buyerId : o.farmerId,
      fromUid: byUid,
      type: 'offer_accepted',
      params: _offerParams(o),
      link: 'offer:${o.id}',
    );
  }

  Future<void> rejectOffer(Offer o, {required String byUid}) async {
    await _offers.doc(o.id).update({
      'status': OfferStatus.rejected.name,
      'lastBy': byUid == o.farmerId ? 'farmer' : 'buyer',
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await notify(
      toUid: byUid == o.farmerId ? o.buyerId : o.farmerId,
      fromUid: byUid,
      type: 'offer_rejected',
      params: _offerParams(o),
      link: 'offer:${o.id}',
    );
  }

  /// Buyer takes back an open offer (soft: status withdrawn); the farmer
  /// is told.
  Future<void> withdrawOffer(Offer o) async {
    await _offers.doc(o.id).update({
      'status': OfferStatus.withdrawn.name,
      'lastBy': 'buyer',
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await notify(
      toUid: o.farmerId,
      fromUid: o.buyerId,
      type: 'offer_withdrawn',
      params: _offerParams(o),
      link: 'offer:${o.id}',
    );
  }

  /// Farmer counters (status countered) or buyer answers (back to pending).
  Future<void> counterOffer(
    Offer o, {
    required String byUid,
    required num pricePerKg,
  }) async {
    final byFarmer = byUid == o.farmerId;
    await _offers.doc(o.id).update({
      'status': byFarmer
          ? OfferStatus.countered.name
          : OfferStatus.pending.name,
      'pricePerKg': pricePerKg,
      if (byFarmer) 'counterPrice': pricePerKg else 'buyerPrice': pricePerKg,
      'lastBy': byFarmer ? 'farmer' : 'buyer',
      'updatedAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(DateTime.now().add(offerValidity)),
    });
    await notify(
      toUid: byFarmer ? o.buyerId : o.farmerId,
      fromUid: byUid,
      type: byFarmer ? 'offer_counter' : 'offer_new',
      params: {
        ..._offerParams(o),
        'price': '$pricePerKg',
        'buyer': o.buyerName,
        'farmer': o.farmerName,
        'qty': '${o.quantityKg}',
      },
      link: 'offer:${o.id}',
    );
  }

  Map<String, String> _offerParams(Offer o) => {
    'cropBn': o.cropNameBn,
    'cropEn': o.cropNameEn,
    'price': '${o.pricePerKg}',
    'buyer': o.buyerName,
    'farmer': o.farmerName,
  };

  // ---------------- orders ----------------

  /// A running order (not delivered / completed / cancelled) on a listing:
  /// the farmer may not edit or withdraw it then.
  Future<bool> hasOpenOrder(String farmerUid, String listingId) async {
    final q = await _orders
        .where('farmerId', isEqualTo: farmerUid)
        .where('listingId', isEqualTo: listingId)
        .get();
    return q.docs.any((d) => TradeOrder.fromDoc(d).status.isOngoing);
  }

  /// Creates an order in one transaction: next order number, stock check,
  /// order doc, listing stock decrease. Payment is held (placeholder) before.
  Future<TradeOrder> placeOrder({
    required AppUser buyer,
    required Listing listing,
    Offer? offer,
    required num quantityKg,
    required num pricePerKg,
    required TransportMode mode,
    required num transportFare,
    required UserLocation dropoff,
    required String paymentRef,
  }) async {
    final counterRef = _db.collection('counters').doc('orders');
    final listingRef = _db.collection('listings').doc(listing.id);
    final orderRef = _orders.doc();
    final orderNo = await _db.runTransaction<String>((tx) async {
      final c = await tx.get(counterRef);
      final l = await tx.get(listingRef);
      if (!l.exists) throw TradeException('not_found');
      final lm = l.data()!;
      if (lm['status'] != ListingStatus.active.name) {
        throw TradeException('not_available');
      }
      final avail = lm['availableKg'] as num? ?? 0;
      if (quantityKg > avail) throw TradeException('qty_too_much');

      final next = (c.data()?['next'] as num?)?.toInt() ?? firstOrderNo;
      final no = 'KS-$next';
      final left = avail - quantityKg;

      tx.set(counterRef, {'next': next + 1});
      tx.update(listingRef, {
        'availableKg': left,
        if (left <= 0) 'status': ListingStatus.sold.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _writeOrder(
        tx,
        orderRef: orderRef,
        no: no,
        buyer: buyer,
        src: OrderSource.fromListing(listing),
        quantityKg: quantityKg,
        pricePerKg: pricePerKg,
        mode: mode,
        transportFare: transportFare,
        dropoff: dropoff,
        paymentRef: paymentRef,
        offerId: offer?.id,
      );
      return no;
    });

    if (offer != null) {
      await _offers.doc(offer.id).update({
        'orderId': orderRef.id,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await notify(
      toUid: listing.farmerId,
      fromUid: buyer.uid,
      type: 'order_new',
      params: {
        'no': orderNo,
        'buyer': buyer.name,
        'cropBn': listing.cropNameBn,
        'cropEn': listing.cropNameEn,
        'qty': '$quantityKg',
      },
      link: 'order:${orderRef.id}',
    );
    final placed = TradeOrder.fromDoc(await orderRef.get());
    if (mode == TransportMode.platform) {
      await alertReturnDrivers(placed, buyer.uid);
    }
    return placed;
  }

  /// 4-digit delivery code the buyer gives the driver.
  static String newOtp() => (1000 + Random.secure().nextInt(9000)).toString();

  /// Order doc + (platform truck) delivery "load" and the buyer-only OTP.
  /// Shared by listing orders (78) and demand orders (99).
  void _writeOrder(
    Transaction tx, {
    required DocumentReference<Map<String, dynamic>> orderRef,
    required String no,
    required AppUser buyer,
    required OrderSource src,
    required num quantityKg,
    required num pricePerKg,
    required TransportMode mode,
    required num transportFare,
    required UserLocation dropoff,
    required String paymentRef,
    String? offerId,
    String? poNo,
    String? otp,
  }) {
    final cropTotal = quantityKg * pricePerKg;
    final fee = (cropTotal * platformFeePct / 100).round();
    final now = FieldValue.serverTimestamp();
    tx.set(orderRef, {
      'orderNo': no,
      'listingId': src.listingId,
      'demandId': src.demandId,
      if (src.contractId != null) 'contractId': src.contractId,
      'poNo': ?poNo,
      'offerId': offerId,
      'farmerId': src.farmerId,
      'farmerName': src.farmerName,
      'buyerId': buyer.uid,
      'buyerName': buyer.name,
      'cropKey': src.cropKey,
      'cropNameBn': src.cropNameBn,
      'cropNameEn': src.cropNameEn,
      'grade': src.grade,
      'photo': src.photo,
      'quantityKg': quantityKg,
      'pricePerKg': pricePerKg,
      'cropTotal': cropTotal,
      'transportMode': mode.name,
      'transportFare': transportFare,
      'platformFee': fee,
      'total': cropTotal + transportFare + fee,
      'pickup': src.pickup.toMap(),
      'dropoff': dropoff.toMap(),
      'pickupDate': Timestamp.fromDate(src.pickupDate),
      'status': OrderStatus.confirmed.name,
      'paymentStatus': 'paid_placeholder',
      'paymentRef': paymentRef,
      'timeline': {'confirmed': now},
      'createdAt': now,
      'updatedAt': now,
    });
    if (mode != TransportMode.platform) return;
    final dRef = _db.collection('deliveries').doc(orderRef.id);
    tx.set(dRef, {
      'orderId': orderRef.id,
      'orderNo': no,
      'buyerId': buyer.uid,
      'buyerName': buyer.name,
      'farmerId': src.farmerId,
      'farmerName': src.farmerName,
      'cropKey': src.cropKey,
      'cropNameBn': src.cropNameBn,
      'cropNameEn': src.cropNameEn,
      'photo': src.photo,
      'weightKg': quantityKg,
      'pickup': src.pickup.toMap(),
      'dropoff': dropoff.toMap(),
      'pickupDate': Timestamp.fromDate(src.pickupDate),
      'suggestedFare': transportFare,
      'distanceKm': distanceKm(src.pickup.geo, dropoff.geo),
      'poNo': ?poNo,
      'status': 'open',
      'createdAt': now,
      'updatedAt': now,
    });
    // One code for every farm of a purchase order: the buyer gives it once.
    tx.set(dRef.collection('private').doc('otp'), {'code': otp ?? newOtp()});
  }

  /// Demand order (99): no listing stock; platform truck to the buyer's
  /// demand address. Payment is held (placeholder) before.
  Future<TradeOrder> placeDemandOrder({
    required AppUser buyer,
    required OrderSource src,
    required num quantityKg,
    required num pricePerKg,
    required UserLocation dropoff,
    required String paymentRef,
    String notifyType = 'commit_accepted',
    String? poNo,
    String? otp,
  }) async {
    final counterRef = _db.collection('counters').doc('orders');
    final orderRef = _orders.doc();
    final fare = estimateFare(distanceKm(src.pickup.geo, dropoff.geo));
    final no = await _db.runTransaction<String>((tx) async {
      final c = await tx.get(counterRef);
      final next = (c.data()?['next'] as num?)?.toInt() ?? firstOrderNo;
      tx.set(counterRef, {'next': next + 1});
      _writeOrder(
        tx,
        orderRef: orderRef,
        no: 'KS-$next',
        buyer: buyer,
        src: src,
        quantityKg: quantityKg,
        pricePerKg: pricePerKg,
        mode: TransportMode.platform,
        transportFare: fare,
        dropoff: dropoff,
        paymentRef: paymentRef,
        poNo: poNo,
        otp: otp,
      );
      return 'KS-$next';
    });
    await notify(
      toUid: src.farmerId,
      fromUid: buyer.uid,
      type: notifyType,
      params: {
        'no': no,
        'cropBn': src.cropNameBn,
        'cropEn': src.cropNameEn,
        'buyer': buyer.name,
        'qty': '$quantityKg',
      },
      link: 'order:${orderRef.id}',
    );
    final placed = TradeOrder.fromDoc(await orderRef.get());
    await alertReturnDrivers(placed, buyer.uid);
    return placed;
  }

  /// 176 "load alert": drivers whose saved return route (175) goes from
  /// this pickup district to this drop district hear about the new load.
  Future<void> alertReturnDrivers(TradeOrder o, String fromUid) async {
    final from = o.pickup.district, to = o.dropoff.district;
    if (from == null || to == null) return;
    try {
      final q = await _db
          .collection('users')
          .where('returnRoute.from', isEqualTo: from)
          .where('returnRoute.to', isEqualTo: to)
          .limit(20)
          .get();
      final today = DateTime.now().subtract(const Duration(days: 1));
      for (final d in q.docs) {
        final u = AppUser.fromDoc(d);
        final r = u.returnRoute;
        if (u.role != UserRole.transporter ||
            r == null ||
            r.date.isBefore(today) ||
            o.quantityKg > r.spaceKg) {
          continue;
        }
        await notify(
          toUid: u.uid,
          fromUid: fromUid,
          type: 'return_load',
          params: {
            'no': o.orderNo,
            'cropBn': o.cropNameBn,
            'cropEn': o.cropNameEn,
            'from': from,
            'to': to,
          },
          link: 'load:${o.id}',
        );
      }
    } catch (_) {
      // Alerts are a bonus; the order itself is already placed.
    }
  }

  /// 10% of a booked truck fare goes to the transporter on cancel (D5).
  static num cancelFee(TradeOrder o) =>
      o.transporterId == null ? 0 : (o.transportFare * 0.1).round();

  /// Buyer cancels before pickup (D5): order + load cancelled, stock back.
  /// Refund is recorded only (payment is a placeholder).
  /// [keepFare]: the buyer's inspector cancelled at the farm (91) — the
  /// truck already came, so its whole fare is kept.
  Future<void> cancelOrder(
    TradeOrder o,
    String byUid, {
    bool keepFare = false,
  }) async {
    final fee = keepFare ? o.transportFare : cancelFee(o);
    final listingRef = o.listingId.isEmpty
        ? null
        : _db.collection('listings').doc(o.listingId);
    final deliveryRef = _db.collection('deliveries').doc(o.id);
    // Read the listing first, outside the transaction: the buyer may read it
    // only while it is active or sold. Hidden / withdrawn stock is not put
    // back, and must not block the cancel.
    String? listingStatus;
    if (listingRef != null) {
      try {
        listingStatus = (await listingRef.get()).data()?['status'] as String?;
      } catch (_) {}
    }
    final restock = listingStatus == ListingStatus.active.name ||
        listingStatus == ListingStatus.sold.name;
    await _db.runTransaction((tx) async {
      final d = o.transportMode == TransportMode.platform
          ? await tx.get(deliveryRef)
          : null;
      final now = FieldValue.serverTimestamp();
      tx.update(_orders.doc(o.id), {
        'status': OrderStatus.cancelled.name,
        'timeline.cancelled': now,
        'refund': o.total - fee,
        'cancelFee': fee,
        'updatedAt': now,
      });
      if (restock) {
        tx.update(listingRef!, {
          'availableKg': FieldValue.increment(o.quantityKg),
          if (listingStatus == ListingStatus.sold.name)
            'status': ListingStatus.active.name,
          'lastCancelOrder': o.id,
          'updatedAt': now,
        });
      }
      if (d != null && d.exists) {
        tx.update(deliveryRef, {
          'status': 'cancelled',
          'timeline.cancelled': now,
          'updatedAt': now,
        });
      }
    });
    final params = {
      'no': o.orderNo,
      'cropBn': o.cropNameBn,
      'cropEn': o.cropNameEn,
    };
    await notify(
      toUid: o.farmerId,
      fromUid: byUid,
      type: 'order_cancelled',
      params: params,
      link: 'rescue:${o.id}',
    );
    if (o.transporterId != null) {
      await notify(
        toUid: o.transporterId!,
        fromUid: byUid,
        type: 'order_cancelled',
        params: params,
        link: 'job:${o.id}',
      );
    }
  }

  Stream<TradeOrder?> watchOrder(String id) => _orders
      .doc(id)
      .snapshots()
      .map((d) => d.exists ? TradeOrder.fromDoc(d) : null);

  Stream<List<TradeOrder>> watchOrdersFor(String field, String uid) => _orders
      .where(field, isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots()
      .map((q) => [for (final d in q.docs) TradeOrder.fromDoc(d)]);

  /// Admin A8: newest orders on the whole platform (read-only).
  Stream<List<TradeOrder>> watchAllOrders() => _orders
      .orderBy('createdAt', descending: true)
      .limit(300)
      .snapshots()
      .map((q) => [for (final d in q.docs) TradeOrder.fromDoc(d)]);

  /// Simple fare estimate until a transporter's offer is accepted (Part 6):
  /// ৳ 1,500 base + ৳ 20 per km (rounded to 100).
  static num estimateFare(double? km) {
    if (km == null) return 1500;
    final f = 1500 + km * 20;
    return (f / 100).round() * 100;
  }
}

final tradeRepositoryProvider = Provider<TradeRepository>(
  (ref) => TradeRepository(ref.watch(firestoreProvider)),
);

final offerProvider = StreamProvider.family<Offer?, String>(
  (ref, id) => ref.watch(tradeRepositoryProvider).watchOffer(id),
);

final listingOffersProvider = StreamProvider.family<List<Offer>, String>((
  ref,
  listingId,
) {
  final uid = ref.watch(currentUserProvider).value?.uid;
  if (uid == null) return Stream.value(const []);
  return ref
      .watch(tradeRepositoryProvider)
      .watchOffersForListing(uid, listingId);
});

final myOffersProvider = StreamProvider<List<Offer>>((ref) {
  final me = ref.watch(currentUserProvider).value;
  if (me == null) return Stream.value(const []);
  final repo = ref.watch(tradeRepositoryProvider);
  return me.role == UserRole.farmer
      ? repo.watchFarmerOffers(me.uid)
      : repo.watchBuyerOffers(me.uid);
});

final myOrdersProvider = StreamProvider<List<TradeOrder>>((ref) {
  final me = ref.watch(currentUserProvider).value;
  if (me == null) return Stream.value(const []);
  return ref
      .watch(tradeRepositoryProvider)
      .watchOrdersFor(
        me.role == UserRole.farmer ? 'farmerId' : 'buyerId',
        me.uid,
      );
});

final orderProvider = StreamProvider.family<TradeOrder?, String>(
  (ref, id) => ref.watch(tradeRepositoryProvider).watchOrder(id),
);

final myNotificationsProvider = StreamProvider<List<AppNotification>>((ref) {
  final uid = ref.watch(currentUserProvider).value?.uid;
  if (uid == null) return Stream.value(const []);
  return ref.watch(tradeRepositoryProvider).watchNotifications(uid);
});

/// What an order is made from: a listing (78) or a farmer's demand
/// commitment (99).
class OrderSource {
  const OrderSource({
    this.listingId = '',
    this.demandId,
    this.contractId,
    required this.farmerId,
    required this.farmerName,
    required this.cropKey,
    required this.cropNameBn,
    required this.cropNameEn,
    required this.grade,
    this.photo,
    required this.pickup,
    required this.pickupDate,
  });

  factory OrderSource.fromListing(Listing l) => OrderSource(
    listingId: l.id,
    farmerId: l.farmerId,
    farmerName: l.farmerName,
    cropKey: l.cropKey,
    cropNameBn: l.cropNameBn,
    cropNameEn: l.cropNameEn,
    grade: l.grade,
    photo: l.photo,
    pickup: l.pickup,
    pickupDate: l.availableFrom,
  );

  final String listingId;
  final String? demandId;
  final String? contractId;
  final String farmerId;
  final String farmerName;
  final String cropKey;
  final String cropNameBn;
  final String cropNameEn;
  final String grade;
  final String? photo;
  final UserLocation pickup;
  final DateTime pickupDate;
}
