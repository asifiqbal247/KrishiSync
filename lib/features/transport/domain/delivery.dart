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
    this.poNo,
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

  /// Pooled purchase order (104): all its farms are one multi-stop trip.
  final String? poNo;

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
      poNo: m['poNo'] as String?,
    );
  }

  /// Same load with group totals (weight, fares) for list rows.
  Delivery withTotals({
    required num weightKg,
    required num suggestedFare,
    num? fare,
    num? loadedKg,
  }) => Delivery(
    id: id,
    orderId: orderId,
    orderNo: orderNo,
    buyerId: buyerId,
    buyerName: buyerName,
    farmerId: farmerId,
    farmerName: farmerName,
    cropKey: cropKey,
    cropNameBn: cropNameBn,
    cropNameEn: cropNameEn,
    photo: photo,
    weightKg: weightKg,
    pickup: pickup,
    dropoff: dropoff,
    pickupDate: pickupDate,
    suggestedFare: suggestedFare,
    distanceKm: distanceKm,
    status: status,
    transporterId: transporterId,
    transporterName: transporterName,
    transporterPhotoUrl: transporterPhotoUrl,
    vehicle: vehicle,
    fare: fare,
    deliveredKg: deliveredKg,
    loadedKg: loadedKg,
    proofPhotoUrl: proofPhotoUrl,
    transporterRated: transporterRated,
    timeline: timeline,
    createdAt: createdAt,
    poNo: poNo,
  );
}

/// A truck job: one load, or every farm of one purchase order (multi-stop,
/// 153 / 160). Stops are in pickup order (date, then farmer name).
class Trip {
  Trip(List<Delivery> items)
    : stops = [...items]
        ..sort((a, b) {
          final t = (a.pickupDate ?? DateTime(0)).compareTo(
            b.pickupDate ?? DateTime(0),
          );
          return t != 0 ? t : a.farmerName.compareTo(b.farmerName);
        });

  /// Stops in exactly this order (the driver's chosen route, 155).
  Trip.exact(this.stops);

  /// This trip with the stops in [ids] order (unknown ids are ignored; when
  /// the list does not cover every stop the normal order stays).
  Trip ordered(List<String> ids) {
    final byId = {for (final s in stops) s.id: s};
    if (ids.length != stops.length || !ids.every(byId.containsKey)) {
      return this;
    }
    return Trip.exact([for (final id in ids) byId[id]!]);
  }

  final List<Delivery> stops;

  /// The farm with the earliest pickup (lead stays the same in any order,
  /// so links and receipts keep pointing at one delivery).
  Delivery get lead => stops.reduce((a, b) => _byDate(a, b) <= 0 ? a : b);

  static int _byDate(Delivery a, Delivery b) {
    final t = (a.pickupDate ?? DateTime(0)).compareTo(
      b.pickupDate ?? DateTime(0),
    );
    return t != 0 ? t : a.farmerName.compareTo(b.farmerName);
  }

  bool get multi => stops.length > 1;

  /// "PO-2026-0001", or the order number for a single load.
  String get no => lead.poNo ?? lead.orderNo;

  num get weightKg => stops.fold<num>(0, (a, d) => a + d.weightKg);
  num get loadedKg =>
      stops.fold<num>(0, (a, d) => a + (d.loadedKg ?? d.weightKg));
  num get suggestedFare => stops.fold<num>(0, (a, d) => a + d.suggestedFare);
  num? get fare => stops.any((d) => d.fare == null)
      ? null
      : stops.fold<num>(0, (a, d) => a + d.fare!);

  /// Next farm still to load, or null when every stop is loaded.
  Delivery? get nextPickup =>
      stops.where((d) => d.status == DeliveryStatus.assigned).firstOrNull;

  /// 1-based stop number of [d].
  int stopNo(Delivery d) => stops.indexWhere((x) => x.id == d.id) + 1;

  bool get allPicked => stops.every(
    (d) =>
        d.status == DeliveryStatus.pickedUp ||
        d.status == DeliveryStatus.delivered,
  );
  bool get delivered =>
      stops.every((d) => d.status == DeliveryStatus.delivered);

  /// Status of the whole job: open until booked, then the slowest stop.
  DeliveryStatus get status {
    if (stops.any((d) => d.status == DeliveryStatus.open)) {
      return DeliveryStatus.open;
    }
    if (delivered) return DeliveryStatus.delivered;
    if (stops.any((d) => d.status == DeliveryStatus.pickedUp)) {
      return DeliveryStatus.pickedUp;
    }
    return lead.status;
  }

  /// Lead load showing the trip's totals (list rows, 144).
  Delivery get summary => multi
      ? lead.withTotals(
          weightKg: weightKg,
          suggestedFare: suggestedFare,
          fare: fare,
          loadedKg: stops.any((d) => d.loadedKg != null) ? loadedKg : null,
        )
      : lead;

  /// Groups loads into trips (one per purchase order, else one per load).
  static List<Trip> group(Iterable<Delivery> loads) {
    final byPo = <String, List<Delivery>>{};
    final out = <Trip>[];
    for (final d in loads) {
      if (d.poNo == null || d.status == DeliveryStatus.cancelled) {
        out.add(Trip([d]));
      } else {
        byPo
            .putIfAbsent(
              '${d.poNo}|${d.status == DeliveryStatus.open}',
              () => [],
            )
            .add(d);
      }
    }
    out.addAll(byPo.values.map(Trip.new));
    return out;
  }

  /// The trip [d] belongs to, from the loads this person can see.
  static Trip of(Delivery d, Iterable<Delivery> pool) {
    if (d.poNo == null) return Trip([d]);
    final seen = <String, Delivery>{d.id: d};
    for (final x in pool) {
      if (x.poNo == d.poNo &&
          x.status != DeliveryStatus.cancelled &&
          (x.status == DeliveryStatus.open) ==
              (d.status == DeliveryStatus.open)) {
        seen[x.id] = x;
      }
    }
    return Trip(seen.values.toList());
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
