import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../trade/data/payment_service.dart';
import '../../trade/data/trade_repository.dart';

enum DemandStatus {
  open,
  filled,
  closed;

  static DemandStatus parse(String? v) =>
      values.firstWhere((s) => s.name == v, orElse: () => open);
}

/// Firestore: demands/{id} — a buyer asks for a crop (96/98).
class Demand {
  const Demand({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    required this.cropKey,
    required this.cropNameBn,
    required this.cropNameEn,
    required this.grade,
    required this.quantityKg,
    required this.targetPrice,
    required this.dropoff,
    this.deliveryDate,
    required this.monthly,
    required this.status,
    this.createdAt,
  });

  final String id;
  final String buyerId;
  final String buyerName;
  final String cropKey;
  final String cropNameBn;
  final String cropNameEn;
  final String grade;
  final num quantityKg;
  final num targetPrice;
  final UserLocation dropoff;
  final DateTime? deliveryDate;
  final bool monthly;
  final DemandStatus status;
  final DateTime? createdAt;

  String cropName(String lang) => lang == 'bn' ? cropNameBn : cropNameEn;

  factory Demand.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    return Demand(
      id: d.id,
      buyerId: m['buyerId'] as String? ?? '',
      buyerName: m['buyerName'] as String? ?? '',
      cropKey: m['cropKey'] as String? ?? 'other',
      cropNameBn: m['cropNameBn'] as String? ?? '',
      cropNameEn: m['cropNameEn'] as String? ?? '',
      grade: m['grade'] as String? ?? 'A',
      quantityKg: m['quantityKg'] as num? ?? 0,
      targetPrice: m['targetPrice'] as num? ?? 0,
      dropoff: UserLocation.fromMap(m['dropoff'] as Map<String, dynamic>?),
      deliveryDate: (m['deliveryDate'] as Timestamp?)?.toDate(),
      monthly: m['monthly'] as bool? ?? false,
      status: DemandStatus.parse(m['status'] as String?),
      createdAt: (m['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

enum CommitStatus {
  pending,
  accepted,
  rejected;

  static CommitStatus parse(String? v) =>
      values.firstWhere((s) => s.name == v, orElse: () => pending);
}

/// demands/{id}/commits/{farmerId} — a farmer offers to supply (33).
class Commit {
  const Commit({
    required this.farmerId,
    required this.farmerName,
    this.photoUrl,
    required this.ratingAvg,
    required this.ratingCount,
    required this.quantityKg,
    this.readyDate,
    required this.pickup,
    required this.status,
    this.orderId,
  });

  final String farmerId;
  final String farmerName;
  final String? photoUrl;
  final double ratingAvg;
  final int ratingCount;
  final num quantityKg;
  final DateTime? readyDate;
  final UserLocation pickup;
  final CommitStatus status;
  final String? orderId;

  factory Commit.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    return Commit(
      farmerId: d.id,
      farmerName: m['farmerName'] as String? ?? '',
      photoUrl: m['photoUrl'] as String?,
      ratingAvg: (m['ratingAvg'] as num?)?.toDouble() ?? 0,
      ratingCount: (m['ratingCount'] as num?)?.toInt() ?? 0,
      quantityKg: m['quantityKg'] as num? ?? 0,
      readyDate: (m['readyDate'] as Timestamp?)?.toDate(),
      pickup: UserLocation.fromMap(m['pickup'] as Map<String, dynamic>?),
      status: CommitStatus.parse(m['status'] as String?),
      orderId: m['orderId'] as String?,
    );
  }
}

class DemandRepository {
  DemandRepository(this._db, this._trade, this._pay);
  final FirebaseFirestore _db;
  final TradeRepository _trade;
  final PaymentService _pay;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('demands');
  CollectionReference<Map<String, dynamic>> _commits(String id) =>
      _col.doc(id).collection('commits');

  Future<void> create({
    required AppUser buyer,
    required String cropKey,
    required String cropNameBn,
    required String cropNameEn,
    required String grade,
    required num quantityKg,
    required num targetPrice,
    required UserLocation dropoff,
    required DateTime deliveryDate,
    required bool monthly,
  }) => _col.add({
    'buyerId': buyer.uid,
    'buyerName': buyer.business?['name'] ?? buyer.name,
    'cropKey': cropKey,
    'cropNameBn': cropNameBn,
    'cropNameEn': cropNameEn,
    'grade': grade,
    'quantityKg': quantityKg,
    'targetPrice': targetPrice,
    'dropoff': dropoff.toMap(),
    'deliveryDate': Timestamp.fromDate(deliveryDate),
    'monthly': monthly,
    'status': DemandStatus.open.name,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  });

  Stream<List<Demand>> watchOpen() => _col
      .where('status', isEqualTo: DemandStatus.open.name)
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots()
      .map((q) => [for (final d in q.docs) Demand.fromDoc(d)]);

  Stream<List<Demand>> watchMine(String buyerId) => _col
      .where('buyerId', isEqualTo: buyerId)
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots()
      .map((q) => [for (final d in q.docs) Demand.fromDoc(d)]);

  Stream<Demand?> watch(String id) =>
      _col.doc(id).snapshots().map((d) => d.exists ? Demand.fromDoc(d) : null);

  Stream<List<Commit>> watchCommits(String id) =>
      _commits(id)
          .snapshots()
          .map((q) => [for (final d in q.docs) Commit.fromDoc(d)]);

  /// 33 Commit supply (one commitment per farmer, can be changed while
  /// pending).
  Future<void> commit(
    Demand d,
    AppUser farmer, {
    required num quantityKg,
    required DateTime readyDate,
  }) async {
    await _commits(d.id).doc(farmer.uid).set({
      'farmerName': farmer.name,
      'photoUrl': farmer.photoUrl,
      'ratingAvg': farmer.ratingAvg,
      'ratingCount': farmer.ratingCount,
      'quantityKg': quantityKg,
      'readyDate': Timestamp.fromDate(readyDate),
      'pickup': farmer.location.toMap(),
      'status': CommitStatus.pending.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _trade.notify(
      toUid: d.buyerId,
      fromUid: farmer.uid,
      type: 'commit_new',
      params: {
        'cropBn': d.cropNameBn,
        'cropEn': d.cropNameEn,
        'farmer': farmer.name,
        'qty': '$quantityKg',
      },
      link: 'demand:${d.id}',
    );
  }

  /// 99 Accept selected: one order per farmer (placeholder payment), then
  /// the demand is marked filled when the accepted total covers it.
  Future<void> accept(
    Demand d,
    List<Commit> picked,
    AppUser buyer,
    num alreadyAcceptedKg,
  ) async {
    for (final c in picked) {
      final pay = await _pay.holdForOrder(
        orderNo: d.id,
        amountBdt: c.quantityKg * d.targetPrice,
        payerUid: buyer.uid,
      );
      if (!pay.success) throw Exception('payment');
      final order = await _trade.placeDemandOrder(
        buyer: buyer,
        src: OrderSource(
          demandId: d.id,
          farmerId: c.farmerId,
          farmerName: c.farmerName,
          cropKey: d.cropKey,
          cropNameBn: d.cropNameBn,
          cropNameEn: d.cropNameEn,
          grade: d.grade,
          pickup: c.pickup,
          pickupDate: c.readyDate ?? DateTime.now(),
        ),
        quantityKg: c.quantityKg,
        pricePerKg: d.targetPrice,
        dropoff: d.dropoff,
        paymentRef: 'demand:${pay.reference ?? ''}',
      );
      await _commits(d.id)
          .doc(c.farmerId)
          .update({'status': CommitStatus.accepted.name, 'orderId': order.id});
    }
    final total =
        alreadyAcceptedKg + picked.fold<num>(0, (a, c) => a + c.quantityKg);
    if (total >= d.quantityKg) {
      await _col.doc(d.id).update({
        'status': DemandStatus.filled.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  static const firstPoNo = 1;

  String _poText(int n) =>
      'PO-${DateTime.now().year}-${n.toString().padLeft(4, '0')}';

  /// 104 preview: the number the next purchase order will get.
  Future<String> peekPoNo() async {
    final c = await _db.collection('counters').doc('po').get();
    return _poText((c.data()?['next'] as num?)?.toInt() ?? firstPoNo);
  }

  /// 104 "confirm PO": takes the next PO number, then pays and places one
  /// order per pooled farmer (same as 99 accept) and records the PO.
  Future<String> confirmPo(
    Demand d,
    List<Commit> pooled,
    AppUser buyer,
    num alreadyAcceptedKg,
  ) async {
    final counter = _db.collection('counters').doc('po');
    final no = await _db.runTransaction<String>((tx) async {
      final c = await tx.get(counter);
      final next = (c.data()?['next'] as num?)?.toInt() ?? firstPoNo;
      tx.set(counter, {'next': next + 1});
      return _poText(next);
    });
    await accept(d, pooled, buyer, alreadyAcceptedKg);
    await _col.doc(d.id).update({
      'poNos': FieldValue.arrayUnion([no]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return no;
  }

  Future<void> close(String id) => _col.doc(id).update({
    'status': DemandStatus.closed.name,
    'updatedAt': FieldValue.serverTimestamp(),
  });
}

final demandRepositoryProvider = Provider<DemandRepository>(
  (ref) => DemandRepository(
    ref.watch(firestoreProvider),
    ref.watch(tradeRepositoryProvider),
    ref.watch(paymentServiceProvider),
  ),
);

final openDemandsProvider = StreamProvider<List<Demand>>(
  (ref) => ref.watch(demandRepositoryProvider).watchOpen(),
);

final myDemandsProvider = StreamProvider<List<Demand>>((ref) {
  final uid = ref.watch(currentUserProvider).value?.uid;
  if (uid == null) return Stream.value(const []);
  return ref.watch(demandRepositoryProvider).watchMine(uid);
});

final demandProvider = StreamProvider.family<Demand?, String>(
  (ref, id) => ref.watch(demandRepositoryProvider).watch(id),
);

final commitsProvider = StreamProvider.family<List<Commit>, String>(
  (ref, id) => ref.watch(demandRepositoryProvider).watchCommits(id),
);
