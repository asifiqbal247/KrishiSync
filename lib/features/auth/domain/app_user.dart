import 'package:cloud_firestore/cloud_firestore.dart';

import '../../transport/domain/delivery.dart';

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
    this.vehicle,
    this.verificationDocs = const {},
    this.business,
    this.payoutMethods = const [],
    this.favSuppliers = const [],
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

  /// Transporters only (Figma 194). Null until the vehicle form is saved.
  final Vehicle? vehicle;

  /// Photo URLs for verification (69/139): nidFront, nidBack, selfie,
  /// license.
  final Map<String, String> verificationDocs;

  /// Buyer business info (139): name, licenseNo, tin.
  final Map<String, String>? business;

  /// 197–201 payment methods (bkash / nagad / rocket / bank).
  final List<PayoutMethod> payoutMethods;

  /// Buyer's favourite farmers (119/120), uids.
  final List<String> favSuppliers;

  PayoutMethod? get defaultPayout {
    for (final m in payoutMethods) {
      if (m.isDefault) return m;
    }
    return payoutMethods.isEmpty ? null : payoutMethods.first;
  }

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
      verificationDocs: {
        for (final e in (m['verificationDocs'] as Map<String, dynamic>? ?? const {}).entries)
          e.key: '${e.value}',
      },
      favSuppliers: [
        for (final x in (m['favSuppliers'] as List<dynamic>? ?? const [])) '$x',
      ],
      payoutMethods: [
        for (final x in (m['payoutMethods'] as List<dynamic>? ?? const []))
          PayoutMethod.fromMap(x as Map<String, dynamic>),
      ],
      business: m['business'] == null
          ? null
          : {
              for (final e in (m['business'] as Map<String, dynamic>).entries)
                e.key: '${e.value}',
            },
      vehicle: m['vehicle'] == null
          ? null
          : Vehicle.fromMap(m['vehicle'] as Map<String, dynamic>),
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

/// One saved payment method (users/{uid}.payoutMethods[]).
class PayoutMethod {
  const PayoutMethod({
    required this.type,
    required this.number,
    required this.accountName,
    this.bank,
    this.branch,
    this.isDefault = false,
  });

  /// bkash | nagad | rocket | bank
  final String type;
  final String number;
  final String accountName;
  final String? bank;
  final String? branch;
  final bool isDefault;

  bool get isBank => type == 'bank';

  /// "01712-XXXXXX" for wallets, "****8421" for banks.
  String get masked {
    if (isBank) {
      return number.length <= 4 ? number : '****${number.substring(number.length - 4)}';
    }
    return number.length < 5 ? number : '${number.substring(0, 5)}-${'X' * (number.length - 5)}';
  }

  PayoutMethod copyWith({bool? isDefault}) => PayoutMethod(
        type: type,
        number: number,
        accountName: accountName,
        bank: bank,
        branch: branch,
        isDefault: isDefault ?? this.isDefault,
      );

  factory PayoutMethod.fromMap(Map<String, dynamic> m) => PayoutMethod(
        type: m['type'] as String? ?? 'bkash',
        number: m['number'] as String? ?? '',
        accountName: m['accountName'] as String? ?? '',
        bank: m['bank'] as String?,
        branch: m['branch'] as String?,
        isDefault: m['isDefault'] as bool? ?? false,
      );

  Map<String, dynamic> toMap() => {
        'type': type,
        'number': number,
        'accountName': accountName,
        'bank': bank,
        'branch': branch,
        'isDefault': isDefault,
      };
}
