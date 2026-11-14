import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/domain/crop_catalog.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../trade/data/trade_repository.dart';

/// Totals for A1 (Firestore count() queries — no document reads).
class AdminStats {
  const AdminStats({
    required this.byRole,
    required this.activeListings,
    required this.pendingListings,
    required this.ongoingOrders,
    required this.completedOrders,
    required this.openReports,
    required this.pendingVerifications,
  });
  final Map<UserRole, int> byRole;
  final int activeListings;
  final int pendingListings;
  final int ongoingOrders;
  final int completedOrders;
  final int openReports;
  final int pendingVerifications;

  int get totalUsers => byRole.values.fold(0, (a, v) => a + v);
}

/// Admin-managed crop (crops/{key}, A6). Bundled crops can be turned off;
/// new crops can be added.
class CropDoc {
  const CropDoc({
    required this.key,
    required this.bn,
    required this.en,
    required this.category,
    required this.active,
  });
  final String key;
  final String bn;
  final String en;
  final CropCategory category;
  final bool active;

  factory CropDoc.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    return CropDoc(
      key: d.id,
      bn: m['nameBn'] as String? ?? d.id,
      en: m['nameEn'] as String? ?? d.id,
      category: CropCategory.values.firstWhere(
        (c) => c.name == m['category'],
        orElse: () => CropCategory.other,
      ),
      active: m['active'] as bool? ?? true,
    );
  }
}

/// One row of the merged catalog (bundled + Firestore).
class CatalogCrop {
  const CatalogCrop(this.crop, this.active, {this.custom = false});
  final Crop crop;
  final bool active;
  final bool custom;
}

class AdminRepository {
  AdminRepository(this._db, this._trade);
  final FirebaseFirestore _db;
  final TradeRepository _trade;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  Future<int> _count(Query<Map<String, dynamic>> q) async =>
      (await q.count().get()).count ?? 0;

  Future<AdminStats> stats() async {
    final roles = <UserRole, int>{};
    for (final r in UserRole.values) {
      roles[r] = await _count(_users.where('role', isEqualTo: r.name));
    }
    final listings = _db.collection('listings');
    final orders = _db.collection('orders');
    return AdminStats(
      byRole: roles,
      activeListings: await _count(
        listings.where('status', isEqualTo: 'active'),
      ),
      pendingListings: await _count(
        listings.where('status', isEqualTo: 'pending'),
      ),
      ongoingOrders: await _count(
        orders.where(
          'status',
          whereIn: [
            'confirmed',
            'transportBooked',
            'pickedUp',
            'inTransit',
            'delivered',
          ],
        ),
      ),
      completedOrders: await _count(
        orders.where('status', isEqualTo: 'completed'),
      ),
      openReports: await _count(
        _db.collection('reports').where('status', isEqualTo: 'open'),
      ),
      pendingVerifications: await _count(
        _users.where('verification', isEqualTo: 'pending'),
      ),
    );
  }

  // ---------------- users (A2 / A3) ----------------

  Stream<List<AppUser>> watchUsers() => _users
      .orderBy('createdAt', descending: true)
      .limit(500)
      .snapshots()
      .map((q) => [for (final d in q.docs) AppUser.fromDoc(d)]);

  Future<void> setStatus(String uid, UserStatus s) => _users.doc(uid).update({
    'status': s.name,
    'updatedAt': FieldValue.serverTimestamp(),
  });

  Future<void> setRole(String uid, UserRole r) => _users.doc(uid).update({
    'role': r.name,
    'updatedAt': FieldValue.serverTimestamp(),
  });

  // ---------------- verification (M6) ----------------

  Stream<List<AppUser>> watchPendingVerification() => _users
      .where('verification', isEqualTo: VerificationStatus.pending.name)
      .limit(100)
      .snapshots()
      .map((q) => [for (final d in q.docs) AppUser.fromDoc(d)]);

  Future<void> setVerification(
    AppUser u,
    VerificationStatus v,
    String modUid,
  ) async {
    await _users.doc(u.uid).update({
      'verification': v.name,
      'verifiedBy': modUid,
      'verifiedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await _trade.notify(
      toUid: u.uid,
      fromUid: modUid,
      type: v == VerificationStatus.verified ? 'verify_ok' : 'verify_rejected',
    );
  }

  // ---------------- crop catalog (A6) ----------------

  Stream<List<CropDoc>> watchCrops() => _db
      .collection('crops')
      .snapshots()
      .map((q) => [for (final d in q.docs) CropDoc.fromDoc(d)]);

  Future<void> saveCrop(CropDoc c) => _db.collection('crops').doc(c.key).set({
    'nameBn': c.bn,
    'nameEn': c.en,
    'category': c.category.name,
    'active': c.active,
    'updatedAt': FieldValue.serverTimestamp(),
  });
}

final adminRepositoryProvider = Provider<AdminRepository>(
  (ref) => AdminRepository(
    ref.watch(firestoreProvider),
    ref.watch(tradeRepositoryProvider),
  ),
);

final adminStatsProvider = FutureProvider.autoDispose<AdminStats>(
  (ref) => ref.watch(adminRepositoryProvider).stats(),
);

final allUsersProvider = StreamProvider<List<AppUser>>(
  (ref) => ref.watch(adminRepositoryProvider).watchUsers(),
);

final pendingVerificationProvider = StreamProvider<List<AppUser>>(
  (ref) => ref.watch(adminRepositoryProvider).watchPendingVerification(),
);

final cropDocsProvider = StreamProvider<List<CropDoc>>(
  (ref) => ref.watch(adminRepositoryProvider).watchCrops(),
);

/// Bundled crops (with admin on/off) + admin-added crops.
final catalogProvider = Provider<List<CatalogCrop>>((ref) {
  final docs = {
    for (final d in ref.watch(cropDocsProvider).value ?? const <CropDoc>[])
      d.key: d,
  };
  return [
    for (final c in CropCatalog.all)
      CatalogCrop(c, docs[c.key]?.active ?? true),
    for (final d in docs.values)
      if (CropCatalog.byKey(d.key) == null)
        CatalogCrop(
          Crop(d.key, d.bn, d.en, d.category, null),
          d.active,
          custom: true,
        ),
  ];
});

/// Chips for Sell Crop (18): the Figma chips (unless turned off), then
/// crops the admin added.
final sellCropsProvider = Provider<List<Crop>>((ref) {
  final all = ref.watch(catalogProvider).where((c) => c.active).toList();
  final chipKeys = {for (final c in CropCatalog.sellChips) c.key};
  return [
    for (final c in all)
      if (chipKeys.contains(c.crop.key)) c.crop,
    for (final c in all)
      if (c.custom) c.crop,
  ];
});

/// Crop by key from the merged catalog (names for admin-added crops).
Crop? catalogCrop(List<CatalogCrop> all, String key) {
  for (final c in all) {
    if (c.crop.key == key) return c.crop;
  }
  return null;
}
