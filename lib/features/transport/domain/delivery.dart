import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/domain/app_user.dart';

/// Life of a delivery ("load"). One per platform-truck order.
enum DeliveryStatus {
  open, // waiting for transporter bids
  assigned, // buyer booked a transporter
  pickedUp, // loaded at the farm (farmer is paid)
  delivered, // driver entered the buyer's OTP
  cancelled;

  static DeliveryStatus parse(String? v) =>
      values.firstWhere((s) => s.name == v, orElse: () => open);

  bool get isActive => this == assigned || this == pickedUp;
}

/// Firestore: deliveries/{orderId}.
class Delivery {
  const Delivery({
    required this.id,
    required this.orderId,
    required this.orderNo,
    required this.buyerId,
    required this.buyerName,
    required this.farmerId,
    required this.farmerName,
    required this.cropKey,
    required this.cropNameBn,
    required this.cropNameEn,
    this.photo,
    required this.weightKg,
    required this.pickup,
    required this.dropoff,
    this.pickupDate,
    required this.suggestedFare,
    this.distanceKm,
    required this.status,
    this.transporterId,
    this.transporterName,
    this.transporterPhotoUrl,
    this.vehicle,
    this.fare,
    this.deliveredKg,
    this.loadedKg,
    this.proofPhotoUrl,
    this.transporterRated = false,
    this.timeline = const {},
    this.createdAt,
  });

  final String id;
  final String orderId;
  final String orderNo;
  final String buyerId;
  final String buyerName;
  final String farmerId;
  final String farmerName;
  final String cropKey;
  final String cropNameBn;
  final String cropNameEn;
  final String? photo;
  final num weightKg;
  final UserLocation pickup;
  final UserLocation dropoff;
  final DateTime? pickupDate;
  final num suggestedFare;
  final double? distanceKm;
  final DeliveryStatus status;
  final String? transporterId;
  final String? transporterName;
  final String? transporterPhotoUrl;
  final Vehicle? vehicle;
  final num? fare;
  final num? deliveredKg;

  /// Weighed at loading (162).
  final num? loadedKg;
  final String? proofPhotoUrl;
  final bool transporterRated;
  final Map<String, DateTime> timeline;
  final DateTime? createdAt;

  String cropName(String lang) => lang == 'bn' ? cropNameBn : cropNameEn;

  /// Road distance ≈ 1.3 × straight line; average truck speed 40 km/h.
  int? get roadKm => distanceKm == null ? null : (distanceKm! * 1.3).round();
  int? get hours => roadKm == null ? null : (roadKm! / 40).ceil();

  factory Delivery.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    final tl = <String, DateTime>{};
    (m['timeline'] as Map<String, dynamic>? ?? const {}).forEach((k, v) {
      if (v is Timestamp) tl[k] = v.toDate();
    });
    return Delivery(
      id: d.id,
      orderId: m['orderId'] as String? ?? d.id,
      orderNo: m['orderNo'] as String? ?? '',
      buyerId: m['buyerId'] as String? ?? '',
      buyerName: m['buyerName'] as String? ?? '',
      farmerId: m['farmerId'] as String? ?? '',
      farmerName: m['farmerName'] as String? ?? '',
      cropKey: m['cropKey'] as String? ?? 'other',
      cropNameBn: m['cropNameBn'] as String? ?? '',
      cropNameEn: m['cropNameEn'] as String? ?? '',
      photo: m['photo'] as String?,
      weightKg: m['weightKg'] as num? ?? 0,
      pickup: UserLocation.fromMap(m['pickup'] as Map<String, dynamic>?),
      dropoff: UserLocation.fromMap(m['dropoff'] as Map<String, dynamic>?),
      pickupDate: (m['pickupDate'] as Timestamp?)?.toDate(),
      suggestedFare: m['suggestedFare'] as num? ?? 0,
      distanceKm: (m['distanceKm'] as num?)?.toDouble(),
      status: DeliveryStatus.parse(m['status'] as String?),
      transporterId: m['transporterId'] as String?,
      transporterName: m['transporterName'] as String?,
      transporterPhotoUrl: m['transporterPhotoUrl'] as String?,
      vehicle: m['vehicle'] == null
          ? null
          : Vehicle.fromMap(m['vehicle'] as Map<String, dynamic>),
      fare: m['fare'] as num?,
      deliveredKg: m['deliveredKg'] as num?,
      loadedKg: m['loadedKg'] as num?,
      proofPhotoUrl: m['proofPhotoUrl'] as String?,
      transporterRated: m['transporterRated'] as bool? ?? false,
      timeline: tl,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

/// Transporter's truck (users/{uid}.vehicle, Figma 194).
class Vehicle {
  const Vehicle({
    required this.type,
    required this.plateNo,
    required this.capacityKg,
    this.photoUrl,
    this.base,
    this.routeTo,
  });

  /// Key from [VehicleTypes.all].
  final String type;
  final String plateNo;
  final num capacityKg;
  final String? photoUrl;
  final UserLocation? base;

  /// Preferred route destination district, stored "bn|en".
  final String? routeTo;

  factory Vehicle.fromMap(Map<String, dynamic> m) => Vehicle(
        type: m['type'] as String? ?? 'medium_open',
        plateNo: m['plateNo'] as String? ?? '',
        capacityKg: m['capacityKg'] as num? ?? 0,
        photoUrl: m['photoUrl'] as String?,
        base: m['base'] == null
            ? null
            : UserLocation.fromMap(m['base'] as Map<String, dynamic>),
        routeTo: m['routeTo'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'type': type,
        'plateNo': plateNo,
        'capacityKg': capacityKg,
        'photoUrl': photoUrl,
        'base': base?.toMap(),
        'routeTo': routeTo,
      };
}

/// Common truck types in Bangladesh (labels come from ARB).
abstract final class VehicleTypes {
  static const all = [
    'pickup',
    'small_open',
    'medium_open',
    'medium_covered',
    'large_open',
    'covered_van',
    'refrigerated',
  ];
}

enum BidStatus {
  pending,
  accepted,
  rejected;

  static BidStatus parse(String? v) =>
      values.firstWhere((s) => s.name == v, orElse: () => pending);
}

/// Firestore: deliveries/{id}/bids/{transporterId} (Figma 145 / 116).
class Bid {
  const Bid({
    required this.transporterId,
    required this.name,
    this.photoUrl,
    required this.vehicle,
    required this.ratingAvg,
    required this.ratingCount,
    required this.fare,
    required this.status,
    this.createdAt,
  });

  final String transporterId;
  final String name;
  final String? photoUrl;
  final Vehicle vehicle;
  final double ratingAvg;
  final int ratingCount;
  final num fare;
  final BidStatus status;
  final DateTime? createdAt;

  factory Bid.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    return Bid(
      transporterId: d.id,
      name: m['name'] as String? ?? '',
      photoUrl: m['photoUrl'] as String?,
      vehicle: Vehicle.fromMap(m['vehicle'] as Map<String, dynamic>? ?? {}),
      ratingAvg: (m['ratingAvg'] as num?)?.toDouble() ?? 0,
      ratingCount: (m['ratingCount'] as num?)?.toInt() ?? 0,
      fare: m['fare'] as num? ?? 0,
      status: BidStatus.parse(m['status'] as String?),
      createdAt: (m['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
