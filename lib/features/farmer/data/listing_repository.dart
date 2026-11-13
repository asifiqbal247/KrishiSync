import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../domain/listing.dart';

abstract interface class ListingRepository {
  /// Creates a listing with status `pending` (needs moderator approval).
  Future<String> create({
    required AppUser farmer,
    required ListingDraft draft,
    required List<String> photoUrls,
  });

  Stream<List<Listing>> watchMine(String farmerId);
  Stream<Listing?> watch(String id);
  Stream<List<Listing>> watchByStatus(ListingStatus status, {int limit = 50});
  Stream<int> countByStatus(ListingStatus status);

  /// Buyers: approved listings only (rules allow only status == active).
  Stream<List<Listing>> watchActive({int limit = 200});
  Stream<List<Listing>> watchActiveByFarmer(String farmerId);
  Stream<List<Listing>> watchActiveByCrop(String cropKey, {int limit = 10});

  Future<void> markSold(String id);

  /// Moderator / admin actions.
  Future<void> approve(String id, String moderatorUid);
  Future<void> reject(String id, String moderatorUid, String note);
}

class FirestoreListingRepository implements ListingRepository {
  FirestoreListingRepository(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('listings');

  @override
  Future<String> create({
    required AppUser farmer,
    required ListingDraft draft,
    required List<String> photoUrls,
  }) async {
    final ref = _col.doc();
    await ref.set({
      'farmerId': farmer.uid,
      'farmerName': farmer.name,
      'farmerPhotoUrl': farmer.photoUrl,
      'farmerDistrict': farmer.location.district,
      'cropKey': draft.cropKey,
      'cropNameBn': draft.cropNameBn,
      'cropNameEn': draft.cropNameEn,
      'category': draft.category,
      'grade': draft.grade,
      'quantityKg': draft.quantityKg,
      'availableKg': draft.quantityKg,
      'pricePerKg': draft.pricePerKg,
      'availableFrom': Timestamp.fromDate(draft.availableFrom),
      'pickup': draft.pickup.toMap(),
      'photos': photoUrls,
      'status': ListingStatus.pending.name,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  List<Listing> _list(QuerySnapshot<Map<String, dynamic>> q) =>
      [for (final d in q.docs) Listing.fromDoc(d)];

  @override
  Stream<List<Listing>> watchMine(String farmerId) => _col
      .where('farmerId', isEqualTo: farmerId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(_list);

  @override
  Stream<Listing?> watch(String id) => _col
      .doc(id)
      .snapshots()
      .map((d) => d.exists ? Listing.fromDoc(d) : null);

  @override
  Stream<List<Listing>> watchByStatus(ListingStatus status, {int limit = 50}) =>
      _col
          .where('status', isEqualTo: status.name)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map(_list);

  @override
  Stream<int> countByStatus(ListingStatus status) => _col
      .where('status', isEqualTo: status.name)
      .snapshots()
      .map((q) => q.size);

  @override
  Stream<List<Listing>> watchActive({int limit = 200}) => _col
      .where('status', isEqualTo: ListingStatus.active.name)
      .orderBy('createdAt', descending: true)
      .limit(limit)
      .snapshots()
      .map(_list);

  @override
  Stream<List<Listing>> watchActiveByFarmer(String farmerId) => _col
      .where('farmerId', isEqualTo: farmerId)
      .where('status', isEqualTo: ListingStatus.active.name)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(_list);

  @override
  Stream<List<Listing>> watchActiveByCrop(String cropKey, {int limit = 10}) =>
      _col
          .where('status', isEqualTo: ListingStatus.active.name)
          .where('cropKey', isEqualTo: cropKey)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map(_list);

  @override
  Future<void> markSold(String id) => _col.doc(id).update({
        'status': ListingStatus.sold.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  @override
  Future<void> approve(String id, String moderatorUid) =>
      _col.doc(id).update({
        'status': ListingStatus.active.name,
        'moderationNote': null,
        'moderatedBy': moderatorUid,
        'moderatedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

  @override
  Future<void> reject(String id, String moderatorUid, String note) =>
      _col.doc(id).update({
        'status': ListingStatus.hidden.name,
        'moderationNote': note,
        'moderatedBy': moderatorUid,
        'moderatedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
}

final listingRepositoryProvider = Provider<ListingRepository>(
    (ref) => FirestoreListingRepository(ref.watch(firestoreProvider)));

final myListingsProvider = StreamProvider<List<Listing>>((ref) {
  final uid = ref.watch(currentUserProvider).value?.uid;
  if (uid == null) return Stream.value(const []);
  return ref.watch(listingRepositoryProvider).watchMine(uid);
});

final listingProvider = StreamProvider.family<Listing?, String>(
    (ref, id) => ref.watch(listingRepositoryProvider).watch(id));

final listingsByStatusProvider =
    StreamProvider.family<List<Listing>, ListingStatus>(
        (ref, s) => ref.watch(listingRepositoryProvider).watchByStatus(s));

final listingCountProvider = StreamProvider.family<int, ListingStatus>(
    (ref, s) => ref.watch(listingRepositoryProvider).countByStatus(s));

final activeListingsProvider = StreamProvider<List<Listing>>(
    (ref) => ref.watch(listingRepositoryProvider).watchActive());

final farmerActiveListingsProvider =
    StreamProvider.family<List<Listing>, String>((ref, farmerId) =>
        ref.watch(listingRepositoryProvider).watchActiveByFarmer(farmerId));

final similarListingsProvider = StreamProvider.family<List<Listing>, String>(
    (ref, cropKey) =>
        ref.watch(listingRepositoryProvider).watchActiveByCrop(cropKey));
