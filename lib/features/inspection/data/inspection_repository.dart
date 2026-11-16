import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_repository.dart';
import '../../auth/data/user_repository.dart';
import '../../trade/data/trade_repository.dart';
import '../../trade/domain/trade_models.dart';

enum InspectionDecision {
  approve,
  partial,
  cancel;

  static InspectionDecision? parse(String? v) =>
      values.where((d) => d.name == v).firstOrNull;
}

/// Why goods were left out (90 / 91).
enum RejectReason {
  small,
  damaged,
  lowGrade;

  static RejectReason parse(String? v) =>
      values.firstWhere((r) => r.name == v, orElse: () => lowGrade);
}

/// Firestore: inspections/{orderId} — the buyer's own inspector checks the
/// crop at pickup (88–94). The inspector is invited by phone number and
/// logs in with that number; rules match it against the auth token.
class Inspection {
  const Inspection({
    required this.orderId,
    required this.orderNo,
    required this.buyerId,
    required this.buyerName,
    required this.farmerId,
    required this.farmerName,
    required this.cropKey,
    required this.cropNameBn,
    required this.cropNameEn,
    required this.inspectorName,
    required this.inspectorPhone,
    required this.done,
    this.decision,
    this.checks = const [],
    this.weighedKg,
    this.acceptKg,
    this.reason = RejectReason.lowGrade,
    this.photos = const [],
    this.doneAt,
  });

  final String orderId;
  final String orderNo;
  final String buyerId;
  final String buyerName;
  final String farmerId;
  final String farmerName;
  final String cropKey;
  final String cropNameBn;
  final String cropNameEn;
  final String inspectorName;

  /// E.164, e.g. +8801712345678.
  final String inspectorPhone;
  final bool done;
  final InspectionDecision? decision;

  /// One answer per checklist item: true = ঠিক, false = সমস্যা.
  final List<bool> checks;
  final num? weighedKg;
  final num? acceptKg;
  final RejectReason reason;
  final List<String> photos;
  final DateTime? doneAt;

  String cropName(String lang) => lang == 'bn' ? cropNameBn : cropNameEn;
  int get okCount => checks.where((c) => c).length;

  factory Inspection.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    return Inspection(
      orderId: d.id,
      orderNo: m['orderNo'] as String? ?? '',
      buyerId: m['buyerId'] as String? ?? '',
      buyerName: m['buyerName'] as String? ?? '',
      farmerId: m['farmerId'] as String? ?? '',
      farmerName: m['farmerName'] as String? ?? '',
      cropKey: m['cropKey'] as String? ?? 'other',
      cropNameBn: m['cropNameBn'] as String? ?? '',
      cropNameEn: m['cropNameEn'] as String? ?? '',
      inspectorName: m['inspectorName'] as String? ?? '',
      inspectorPhone: m['inspectorPhone'] as String? ?? '',
      done: m['status'] == 'done',
      decision: InspectionDecision.parse(m['decision'] as String?),
      checks: [for (final c in (m['checks'] as List? ?? const [])) c == true],
      weighedKg: m['weighedKg'] as num?,
      acceptKg: m['acceptKg'] as num?,
      reason: RejectReason.parse(m['reason'] as String?),
      photos: [for (final u in (m['photos'] as List? ?? const [])) '$u'],
      doneAt: (m['doneAt'] as Timestamp?)?.toDate(),
    );
  }
}

class InspectionRepository {
  InspectionRepository(this._db, this._trade);
  final FirebaseFirestore _db;
  final TradeRepository _trade;

  /// Checklist size (Figma 89 shows five items).
  static const checklistSize = 5;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('inspections');

  Stream<Inspection?> watch(String orderId) => _col
      .doc(orderId)
      .snapshots()
      .map((d) => d.exists ? Inspection.fromDoc(d) : null);

  /// Invitations for the signed-in phone number (88).
  Stream<List<Inspection>> watchInvites(String phoneE164) => _col
      .where('inspectorPhone', isEqualTo: phoneE164)
      .snapshots()
      .map((q) => [for (final d in q.docs) Inspection.fromDoc(d)]
        ..sort((a, b) => (a.done ? 1 : 0).compareTo(b.done ? 1 : 0)));

  /// Buyer names (or changes) the inspector for an order, until it is done.
  Future<void> invite(TradeOrder o, {required String name, required String phoneE164}) =>
      _col.doc(o.id).set({
        'orderNo': o.orderNo,
        'buyerId': o.buyerId,
        'buyerName': o.buyerName,
        'farmerId': o.farmerId,
        'farmerName': o.farmerName,
        'cropKey': o.cropKey,
        'cropNameBn': o.cropNameBn,
        'cropNameEn': o.cropNameEn,
        'inspectorName': name,
        'inspectorPhone': phoneE164,
        'status': 'invited',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

  Future<void> remove(String orderId) => _col.doc(orderId).delete();

  /// 89–91: the inspector's final report. A cancel also cancels the order
  /// (buyer gets crop money + fee back; the truck keeps its fare).
  Future<void> submit(
    TradeOrder o,
    String byUid, {
    required InspectionDecision decision,
    required List<bool> checks,
    required num weighedKg,
    required num acceptKg,
    RejectReason reason = RejectReason.lowGrade,
    List<String> photos = const [],
  }) async {
    await _col.doc(o.id).update({
      'status': 'done',
      'decision': decision.name,
      'checks': checks,
      'weighedKg': weighedKg,
      'acceptKg': decision == InspectionDecision.cancel ? 0 : acceptKg,
      'reason': reason.name,
      'photos': photos,
      'doneAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    if (decision == InspectionDecision.cancel) {
      await _trade.cancelOrder(o, byUid, keepFare: true);
    }
    final params = {
      'no': o.orderNo,
      'farmer': o.farmerName,
      'decision': decision.name,
      'cropBn': o.cropNameBn,
      'cropEn': o.cropNameEn,
    };
    await _trade.notify(
      toUid: o.buyerId,
      fromUid: byUid,
      type: 'inspection_done',
      params: params,
      link: 'inspection:${o.id}',
    );
    if (o.transporterId != null && decision != InspectionDecision.cancel) {
      await _trade.notify(
        toUid: o.transporterId!,
        fromUid: byUid,
        type: 'inspection_done',
        params: params,
        link: 'job:${o.id}',
      );
    }
  }
}

final inspectionRepositoryProvider = Provider<InspectionRepository>(
  (ref) => InspectionRepository(
    ref.watch(firestoreProvider),
    ref.watch(tradeRepositoryProvider),
  ),
);

final inspectionProvider = StreamProvider.family<Inspection?, String>(
  (ref, orderId) => ref.watch(inspectionRepositoryProvider).watch(orderId),
);

/// Inspections this phone number was invited to (empty when signed out).
final myInvitesProvider = StreamProvider<List<Inspection>>((ref) {
  final phone = ref.watch(authStateProvider).value?.phoneNumber;
  if (phone == null || phone.isEmpty) return Stream.value(const []);
  return ref.watch(inspectionRepositoryProvider).watchInvites(phone);
});
