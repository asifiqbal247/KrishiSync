import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/domain/app_user.dart';

enum OfferStatus {
  pending,
  countered,
  accepted,
  rejected,
  withdrawn;

  static OfferStatus parse(String? v) =>
      values.firstWhere((s) => s.name == v, orElse: () => pending);

  bool get isOpen => this == pending || this == countered;
}

/// Firestore: offers/{id}. Buyer creates; farmer accepts / rejects / counters;
/// buyer answers a counter. `pricePerKg` is always the latest proposal.
class Offer {
  const Offer({
    required this.id,
    required this.listingId,
    required this.farmerId,
    required this.farmerName,
    required this.buyerId,
    required this.buyerName,
    this.buyerPhotoUrl,
    required this.cropKey,
    required this.cropNameBn,
    required this.cropNameEn,
    required this.grade,
    this.listingPhoto,
    required this.listingPrice,
    required this.pricePerKg,
    required this.quantityKg,
    this.deliveryDate,
    required this.status,
    required this.lastBy,
    this.buyerPrice,
    this.counterPrice,
    this.createdAt,
    this.expiresAt,
    this.orderId,
  });

  final String id;
  final String listingId;
  final String farmerId;
  final String farmerName;
  final String buyerId;
  final String buyerName;
  final String? buyerPhotoUrl;
  final String cropKey;
  final String cropNameBn;
  final String cropNameEn;
  final String grade;
  final String? listingPhoto;
  final num listingPrice;
  final num pricePerKg;
  final num quantityKg;
  final DateTime? deliveryDate;
  final OfferStatus status;
  final String lastBy; // 'buyer' | 'farmer'
  final num? buyerPrice;
  final num? counterPrice;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final String? orderId;

  String cropName(String lang) => lang == 'bn' ? cropNameBn : cropNameEn;
  num get total => pricePerKg * quantityKg;

  /// Buyer must act: farmer countered, or accepted and not ordered yet.
  bool get needsBuyer =>
      lastBy == 'farmer' &&
      (status == OfferStatus.countered ||
          (status == OfferStatus.accepted && orderId == null));

  factory Offer.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    DateTime? ts(String k) => (m[k] as Timestamp?)?.toDate();
    return Offer(
      id: d.id,
      listingId: m['listingId'] as String? ?? '',
      farmerId: m['farmerId'] as String? ?? '',
      farmerName: m['farmerName'] as String? ?? '',
      buyerId: m['buyerId'] as String? ?? '',
      buyerName: m['buyerName'] as String? ?? '',
      buyerPhotoUrl: m['buyerPhotoUrl'] as String?,
      cropKey: m['cropKey'] as String? ?? 'other',
      cropNameBn: m['cropNameBn'] as String? ?? '',
      cropNameEn: m['cropNameEn'] as String? ?? '',
      grade: m['grade'] as String? ?? 'A',
      listingPhoto: m['listingPhoto'] as String?,
      listingPrice: m['listingPrice'] as num? ?? 0,
      pricePerKg: m['pricePerKg'] as num? ?? 0,
      quantityKg: m['quantityKg'] as num? ?? 0,
      deliveryDate: ts('deliveryDate'),
      status: OfferStatus.parse(m['status'] as String?),
      lastBy: m['lastBy'] as String? ?? 'buyer',
      buyerPrice: m['buyerPrice'] as num?,
      counterPrice: m['counterPrice'] as num?,
      createdAt: ts('createdAt'),
      expiresAt: ts('expiresAt'),
      orderId: m['orderId'] as String?,
    );
  }
}

enum OrderStatus {
  confirmed,
  transportBooked,
  pickedUp,
  inTransit,
  delivered,
  completed,
  cancelled;

  static OrderStatus parse(String? v) =>
      values.firstWhere((s) => s.name == v, orElse: () => confirmed);

  bool get isOngoing =>
      this != completed && this != cancelled && this != delivered;
}

enum TransportMode { platform, self }

/// Firestore: orders/{id}. (Named TradeOrder: Firestore already has `Order`.)
class TradeOrder {
  const TradeOrder({
    required this.id,
    required this.orderNo,
    required this.listingId,
    this.offerId,
    required this.farmerId,
    required this.farmerName,
    required this.buyerId,
    required this.buyerName,
    required this.cropKey,
    required this.cropNameBn,
    required this.cropNameEn,
    required this.grade,
    this.photo,
    required this.quantityKg,
    required this.pricePerKg,
    required this.cropTotal,
    required this.transportMode,
    required this.transportFare,
    required this.platformFee,
    required this.total,
    required this.pickup,
    required this.dropoff,
    required this.status,
    required this.paymentStatus,
    required this.timeline,
    this.pickupDate,
    this.createdAt,
    this.transporterId,
    this.transporterName,
    this.paymentRef = '',
  });

  final String id;
  final String orderNo;
  final String listingId;
  final String? offerId;
  final String farmerId;
  final String farmerName;
  final String buyerId;
  final String buyerName;
  final String cropKey;
  final String cropNameBn;
  final String cropNameEn;
  final String grade;
  final String? photo;
  final num quantityKg;
  final num pricePerKg;
  final num cropTotal;
  final TransportMode transportMode;
  final num transportFare;
  final num platformFee;
  final num total;
  final UserLocation pickup;
  final UserLocation dropoff;
  final OrderStatus status;
  final String paymentStatus; // unpaid | paid_placeholder | released
  final Map<String, DateTime> timeline; // status name → time
  final DateTime? pickupDate;
  final DateTime? createdAt;
  final String? transporterId;
  final String? transporterName;

  /// "bank:…" / "bkash:…" from Safe Payment (82); placeholder reference.
  final String paymentRef;

  String cropName(String lang) => lang == 'bn' ? cropNameBn : cropNameEn;

  factory TradeOrder.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    final tl = <String, DateTime>{};
    (m['timeline'] as Map<String, dynamic>? ?? const {}).forEach((k, v) {
      if (v is Timestamp) tl[k] = v.toDate();
    });
    return TradeOrder(
      id: d.id,
      orderNo: m['orderNo'] as String? ?? '',
      listingId: m['listingId'] as String? ?? '',
      offerId: m['offerId'] as String?,
      farmerId: m['farmerId'] as String? ?? '',
      farmerName: m['farmerName'] as String? ?? '',
      buyerId: m['buyerId'] as String? ?? '',
      buyerName: m['buyerName'] as String? ?? '',
      cropKey: m['cropKey'] as String? ?? 'other',
      cropNameBn: m['cropNameBn'] as String? ?? '',
      cropNameEn: m['cropNameEn'] as String? ?? '',
      grade: m['grade'] as String? ?? 'A',
      photo: m['photo'] as String?,
      quantityKg: m['quantityKg'] as num? ?? 0,
      pricePerKg: m['pricePerKg'] as num? ?? 0,
      cropTotal: m['cropTotal'] as num? ?? 0,
      transportMode: m['transportMode'] == 'self'
          ? TransportMode.self
          : TransportMode.platform,
      transportFare: m['transportFare'] as num? ?? 0,
      platformFee: m['platformFee'] as num? ?? 0,
      total: m['total'] as num? ?? 0,
      pickup: UserLocation.fromMap(m['pickup'] as Map<String, dynamic>?),
      dropoff: UserLocation.fromMap(m['dropoff'] as Map<String, dynamic>?),
      status: OrderStatus.parse(m['status'] as String?),
      paymentStatus: m['paymentStatus'] as String? ?? 'unpaid',
      timeline: tl,
      pickupDate: (m['pickupDate'] as Timestamp?)?.toDate(),
      createdAt: (m['createdAt'] as Timestamp?)?.toDate(),
      transporterId: m['transporterId'] as String?,
      transporterName: m['transporterName'] as String?,
      paymentRef: m['paymentRef'] as String? ?? '',
    );
  }
}

/// notifications/{uid}/items/{id}. Text is built from ARB keys + params.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.params,
    this.link,
    required this.read,
    this.createdAt,
  });

  final String id;
  final String type;
  final Map<String, String> params;
  final String? link;
  final bool read;
  final DateTime? createdAt;

  factory AppNotification.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    return AppNotification(
      id: d.id,
      type: m['type'] as String? ?? '',
      params: {
        for (final e
            in (m['params'] as Map<String, dynamic>? ?? const {}).entries)
          e.key: '${e.value}',
      },
      link: m['link'] as String?,
      read: m['read'] as bool? ?? false,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
