import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  farmer,
  buyer,
  transporter,
  moderator,
  admin;

  /// Roles a user may pick for themselves at sign-up.
  static const selfSelectable = [farmer, buyer, transporter];

  static UserRole? tryParse(String? v) {
    for (final r in values) {
      if (r.name == v) return r;
    }
    return null;
  }
}

enum UserStatus { active, suspended }

enum VerificationStatus { none, pending, verified, rejected }

/// Place on the Division → District → Upazila → Union ladder.
class UserLocation {
  const UserLocation({
    this.divisionId,
    this.division,
    this.districtId,
    this.district,
    this.upazilaId,
    this.upazila,
    this.unionId,
    this.union,
    this.village,
    this.landmark,
    this.geo,
  });

  final String? divisionId;
  final String? division; // stored as "bn|en"
  final String? districtId;
  final String? district;
  final String? upazilaId;
  final String? upazila;
  final String? unionId;
  final String? union;
  final String? village;
  final String? landmark;
  final GeoPoint? geo;

  bool get isComplete =>
      divisionId != null && districtId != null && upazilaId != null;

  factory UserLocation.fromMap(Map<String, dynamic>? m) {
    if (m == null) return const UserLocation();
    return UserLocation(
      divisionId: m['divisionId'] as String?,
      division: m['division'] as String?,
      districtId: m['districtId'] as String?,
      district: m['district'] as String?,
      upazilaId: m['upazilaId'] as String?,
      upazila: m['upazila'] as String?,
      unionId: m['unionId'] as String?,
      union: m['union'] as String?,
      village: m['village'] as String?,
      landmark: m['landmark'] as String?,
      geo: m['geo'] as GeoPoint?,
    );
  }

  Map<String, dynamic> toMap() => {
        'divisionId': divisionId,
        'division': division,
        'districtId': districtId,
        'district': district,
        'upazilaId': upazilaId,
        'upazila': upazila,
        'unionId': unionId,
        'union': union,
        'village': village,
        'landmark': landmark,
        'geo': geo,
      };
}

/// Firestore: users/{uid}
class AppUser {
  const AppUser({
    required this.uid,
    required this.phone,
    this.role,
    this.name = '',
    this.photoUrl,
    this.language = 'bn',
    this.location = const UserLocation(),
    this.nidNumber,
    this.verification = VerificationStatus.none,
    this.status = UserStatus.active,
    this.ratingAvg = 0,
    this.ratingCount = 0,
    this.createdAt,
    this.savedAddresses = const [],
    this.completedOrders = 0,
    this.onTimeRate,
    this.complaintCount = 0,
  });

  final String uid;
  final String phone;
  final UserRole? role;
  final String name;
  final String? photoUrl;
  final String language;
  final UserLocation location;
  final String? nidNumber;
  final VerificationStatus verification;
  final UserStatus status;
  final double ratingAvg;
  final int ratingCount;
  final DateTime? createdAt;
  final List<SavedAddress> savedAddresses;

  /// Trade stats, updated when orders complete (Parts 5–6).
  final int completedOrders;
  final int? onTimeRate; // 0–100, null until first delivery
  final int complaintCount;

  bool get isVerified => verification == VerificationStatus.verified;

  bool get hasRole => role != null;
  bool get profileComplete => name.trim().isNotEmpty && location.isComplete;
  bool get isSuspended => status == UserStatus.suspended;

  factory AppUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final m = doc.data() ?? const {};
    return AppUser(
      uid: doc.id,
      phone: m['phone'] as String? ?? '',
      role: UserRole.tryParse(m['role'] as String?),
      name: m['name'] as String? ?? '',
      photoUrl: m['photoUrl'] as String?,
      language: m['language'] as String? ?? 'bn',
      location: UserLocation.fromMap(m['location'] as Map<String, dynamic>?),
      nidNumber: m['nidNumber'] as String?,
      verification: VerificationStatus.values.firstWhere(
          (v) => v.name == m['verification'],
          orElse: () => VerificationStatus.none),
      status: m['status'] == 'suspended'
          ? UserStatus.suspended
          : UserStatus.active,
      ratingAvg: (m['ratingAvg'] as num?)?.toDouble() ?? 0,
      ratingCount: (m['ratingCount'] as num?)?.toInt() ?? 0,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate(),
      completedOrders: (m['completedOrders'] as num?)?.toInt() ?? 0,
      onTimeRate: (m['onTimeRate'] as num?)?.toInt(),
      complaintCount: (m['complaintCount'] as num?)?.toInt() ?? 0,
      savedAddresses: [
        for (final a in (m['savedAddresses'] as List<dynamic>? ?? const []))
          SavedAddress.fromMap(a as Map<String, dynamic>),
      ],
    );
  }
}

/// users/{uid}.savedAddresses[] — "save as" tags from screen 12.
enum AddressTag { home, farm, store, other }

class SavedAddress {
  const SavedAddress({required this.tag, required this.location});
  final AddressTag tag;
  final UserLocation location;

  factory SavedAddress.fromMap(Map<String, dynamic> m) => SavedAddress(
        tag: AddressTag.values.firstWhere((t) => t.name == m['tag'],
            orElse: () => AddressTag.other),
        location: UserLocation.fromMap(m['location'] as Map<String, dynamic>?),
      );

  Map<String, dynamic> toMap() => {'tag': tag.name, 'location': location.toMap()};
}
