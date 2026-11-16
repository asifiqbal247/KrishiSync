import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/app_user.dart';
import 'auth_repository.dart';

abstract interface class UserRepository {
  Stream<AppUser?> watchUser(String uid);

  /// Creates users/{uid} on first login (no role yet). Safe to call again.
  Future<void> ensureUserDoc({
    required String uid,
    required String phone,
    required String language,
  });

  /// One-time self-selected role (farmer / buyer / transporter).
  Future<void> setRole(String uid, UserRole role);

  Future<void> saveProfile(
    String uid, {
    required String name,
    required UserLocation location,
    String? photoUrl,
    String? nidNumber,
  });

  Future<void> setLanguage(String uid, String language);

  /// Buyer adds / removes a favourite supplier (119/120).
  Future<void> setFavSupplier(String uid, String farmerId, bool fav);

  /// Transporter saves the way back (175).
  Future<void> setReturnRoute(String uid, ReturnRoute r);

  /// Adds/replaces the saved address with the same tag (max one per tag).
  Future<void> saveAddress(String uid, SavedAddress address, List<SavedAddress> current);

  /// 69/139: documents → verification "pending" for the moderator.
  Future<void> submitVerification(String uid, Map<String, dynamic> fields);

  /// 197–201: replaces the user's payment methods list.
  Future<void> savePayoutMethods(String uid, List<PayoutMethod> methods);

  /// Raw reviews about [uid], newest first (70/140/195).
  Stream<List<Map<String, dynamic>>> watchReviewsFor(String uid);
}

class FirestoreUserRepository implements UserRepository {
  FirestoreUserRepository(this._db);
  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _db.collection('users').doc(uid);

  @override
  Stream<AppUser?> watchUser(String uid) => _doc(uid)
      .snapshots()
      .map((s) => s.exists ? AppUser.fromDoc(s) : null);

  final Map<String, Future<void>> _ensuring = {};

  @override
  Future<void> ensureUserDoc({
    required String uid,
    required String phone,
    required String language,
  }) =>
      // OTP screen and the app-level listener may both call this at once.
      _ensuring[uid] ??= _ensure(uid, phone, language)
          .whenComplete(() => _ensuring.remove(uid));

  Future<void> _ensure(String uid, String phone, String language) async {
    final ref = _doc(uid);
    final snap = await ref.get();
    if (snap.exists) return;
    await ref.set({
      'phone': phone,
      'name': '',
      'language': language,
      'status': 'active',
      'verification': 'none',
      'ratingAvg': 0,
      'ratingCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> savePayoutMethods(String uid, List<PayoutMethod> methods) =>
      _doc(uid).update({
        'payoutMethods': [for (final m in methods) m.toMap()],
        'updatedAt': FieldValue.serverTimestamp(),
      });

  @override
  Future<void> submitVerification(String uid, Map<String, dynamic> fields) =>
      _doc(uid).update({
        ...fields,
        'verification': 'pending',
        'updatedAt': FieldValue.serverTimestamp(),
      });

  @override
  Stream<List<Map<String, dynamic>>> watchReviewsFor(String uid) => _db
      .collection('reviews')
      .where('toUid', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots()
      .map((q) => [for (final d in q.docs) d.data()]);

  @override
  Future<void> setRole(String uid, UserRole role) => _doc(uid).update({
        'role': role.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  @override
  Future<void> saveProfile(
    String uid, {
    required String name,
    required UserLocation location,
    String? photoUrl,
    String? nidNumber,
  }) =>
      _doc(uid).update({
        'name': name.trim(),
        'location': location.toMap(),
        'photoUrl': ?photoUrl,
        if (nidNumber != null && nidNumber.trim().isNotEmpty) ...{
          'nidNumber': nidNumber.trim(),
          'verification': 'pending',
        },
        'updatedAt': FieldValue.serverTimestamp(),
      });

  @override
  Future<void> setLanguage(String uid, String language) => _doc(uid).update({
        'language': language,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  @override
  Future<void> setReturnRoute(String uid, ReturnRoute r) => _doc(uid).update({
        'returnRoute': r.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

  @override
  Future<void> setFavSupplier(String uid, String farmerId, bool fav) =>
      _doc(uid).update({
        'favSuppliers': fav
            ? FieldValue.arrayUnion([farmerId])
            : FieldValue.arrayRemove([farmerId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

  @override
  Future<void> saveAddress(
      String uid, SavedAddress address, List<SavedAddress> current) {
    final list = [
      address,
      ...current.where((a) => a.tag != address.tag),
    ];
    return _doc(uid).update({
      'savedAddresses': [for (final a in list) a.toMap()],
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

final firestoreProvider =
    Provider<FirebaseFirestore>((_) => FirebaseFirestore.instance);

final userRepositoryProvider = Provider<UserRepository>(
    (ref) => FirestoreUserRepository(ref.watch(firestoreProvider)));

/// The signed-in user's profile document (null = signed out or no doc yet).
final currentUserProvider = StreamProvider<AppUser?>((ref) {
  final auth = ref.watch(authStateProvider);
  final uid = auth.value?.uid;
  if (uid == null) return Stream.value(null);
  return ref.watch(userRepositoryProvider).watchUser(uid);
});

/// Any user's public profile (names, photo, district, rating).
final userByIdProvider = StreamProvider.family<AppUser?, String>(
    (ref, uid) => ref.watch(userRepositoryProvider).watchUser(uid));

/// Top suppliers on Buyer Home: farmers by rating.
final topFarmersProvider = StreamProvider<List<AppUser>>((ref) => ref
    .watch(firestoreProvider)
    .collection('users')
    .where('role', isEqualTo: 'farmer')
    .orderBy('ratingAvg', descending: true)
    .limit(10)
    .snapshots()
    .map((q) => [for (final d in q.docs) AppUser.fromDoc(d)]));
