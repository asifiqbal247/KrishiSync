import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/domain/app_user.dart';

/// pending → (moderator) → active | hidden ;  active → sold (farmer).
/// Farmer edits of photos / crop / grade / pickup → pending again;
/// withdraw (no running order) → withdrawn (soft delete).
enum ListingStatus {
  pending,
  active,
  sold,
  hidden,
  withdrawn;

  static ListingStatus parse(String? v) =>
      values.firstWhere((s) => s.name == v, orElse: () => pending);
}

/// Firestore: listings/{id}
class Listing {
  const Listing({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    this.farmerPhotoUrl,
    required this.cropKey,
    required this.cropNameBn,
    required this.cropNameEn,
    required this.category,
    required this.grade,
    required this.quantityKg,
    required this.availableKg,
    required this.pricePerKg,
    required this.availableFrom,
    required this.pickup,
    required this.photos,
    required this.status,
    this.moderationNote,
    this.createdAt,
  });

  final String id;
  final String farmerId;
  final String farmerName;
  final String? farmerPhotoUrl;
  final String cropKey;
  final String cropNameBn;
  final String cropNameEn;
  final String category;
  final String grade; // A | B | C
  final num quantityKg;
  final num availableKg;
  final num pricePerKg;
  final DateTime availableFrom;
  final UserLocation pickup;
  final List<String> photos;
  final ListingStatus status;
  final String? moderationNote;
  final DateTime? createdAt;

  String cropName(String lang) => lang == 'bn' ? cropNameBn : cropNameEn;
  String? get photo => photos.isEmpty ? null : photos.first;

  factory Listing.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    return Listing(
      id: d.id,
      farmerId: m['farmerId'] as String? ?? '',
      farmerName: m['farmerName'] as String? ?? '',
      farmerPhotoUrl: m['farmerPhotoUrl'] as String?,
      cropKey: m['cropKey'] as String? ?? 'other',
      cropNameBn: m['cropNameBn'] as String? ?? '',
      cropNameEn: m['cropNameEn'] as String? ?? '',
      category: m['category'] as String? ?? 'other',
      grade: m['grade'] as String? ?? 'A',
      quantityKg: m['quantityKg'] as num? ?? 0,
      availableKg: m['availableKg'] as num? ?? 0,
      pricePerKg: m['pricePerKg'] as num? ?? 0,
      availableFrom:
          (m['availableFrom'] as Timestamp?)?.toDate() ?? DateTime.now(),
      pickup: UserLocation.fromMap(m['pickup'] as Map<String, dynamic>?),
      photos: [for (final p in (m['photos'] as List? ?? const [])) '$p'],
      status: ListingStatus.parse(m['status'] as String?),
      moderationNote: m['moderationNote'] as String?,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

/// Values collected by Sell Crop 18–20 before publishing.
class ListingDraft {
  const ListingDraft({
    required this.cropKey,
    required this.cropNameBn,
    required this.cropNameEn,
    required this.category,
    required this.grade,
    required this.quantityKg,
    required this.pricePerKg,
    required this.availableFrom,
    required this.pickup,
  });

  final String cropKey;
  final String cropNameBn;
  final String cropNameEn;
  final String category;
  final String grade;
  final num quantityKg;
  final num pricePerKg;
  final DateTime availableFrom;
  final UserLocation pickup;
}
