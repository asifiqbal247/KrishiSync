import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../admin/data/admin_repository.dart';
import '../../auth/data/user_repository.dart';
import '../../trade/data/trade_repository.dart';

/// Papers kept in the app and checked by a moderator (207): a farmer's
/// export papers (37) and a driver's licence and vehicle papers.
enum TradeDocType { phyto, license, driving, vehicle }

enum TradeDocStatus { pending, verified, rejected }

/// tradeDocs/{uid}_{type}: one photo of the paper, its expiry date and the
/// moderator's check.
class TradeDoc {
  const TradeDoc({
    required this.uid,
    required this.type,
    required this.url,
    required this.status,
    this.uploadedAt,
    this.expiresAt,
  });

  final String uid;
  final TradeDocType type;
  final String url;
  final TradeDocStatus status;
  final DateTime? uploadedAt;
  final DateTime? expiresAt;

  String get id => TradeDocRepository.idFor(uid, type);

  bool get expired => expiresAt != null && expiresAt!.isBefore(DateTime.now());

  factory TradeDoc.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    return TradeDoc(
      uid: m['uid'] as String? ?? '',
      type: TradeDocType.values.firstWhere(
        (t) => t.name == m['type'],
        orElse: () => TradeDocType.phyto,
      ),
      url: m['url'] as String? ?? '',
      status: TradeDocStatus.values.firstWhere(
        (s) => s.name == m['status'],
        orElse: () => TradeDocStatus.pending,
      ),
      uploadedAt: (m['uploadedAt'] as Timestamp?)?.toDate(),
      expiresAt: (m['expiresAt'] as Timestamp?)?.toDate(),
    );
  }
}

class TradeDocRepository {
  TradeDocRepository(this._db, this._trade);
  final FirebaseFirestore _db;
  final TradeRepository _trade;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('tradeDocs');

  static String idFor(String uid, TradeDocType t) => '${uid}_${t.name}';

  Stream<TradeDoc?> watch(String uid, TradeDocType t) => _col
      .doc(idFor(uid, t))
      .snapshots()
      .map((d) => d.exists ? TradeDoc.fromDoc(d) : null);

  /// Upload or re-upload: the paper goes back to the moderator's queue.
  Future<void> save({
    required String uid,
    required TradeDocType type,
    required String url,
    required DateTime expiresAt,
  }) => _col.doc(idFor(uid, type)).set({
    'uid': uid,
    'type': type.name,
    'url': url,
    'status': TradeDocStatus.pending.name,
    'uploadedAt': FieldValue.serverTimestamp(),
    'expiresAt': Timestamp.fromDate(expiresAt),
  });

  /// Moderator queue (M6): papers waiting for a check.
  Stream<List<TradeDoc>> watchPending() => _col
      .where('status', isEqualTo: TradeDocStatus.pending.name)
      .limit(100)
      .snapshots()
      .map((q) => [for (final d in q.docs) TradeDoc.fromDoc(d)]);

  Future<void> review(TradeDoc d, bool ok, String modUid) async {
    await _col.doc(d.id).update({
      'status': (ok ? TradeDocStatus.verified : TradeDocStatus.rejected).name,
      'reviewedBy': modUid,
      'reviewedAt': FieldValue.serverTimestamp(),
    });
    await _trade.notify(
      toUid: d.uid,
      fromUid: modUid,
      type: ok ? 'doc_ok' : 'doc_rejected',
      params: {'doc': d.type.name},
      link: 'doc:${d.id}',
    );
  }
}

final tradeDocRepositoryProvider = Provider<TradeDocRepository>(
  (ref) => TradeDocRepository(
    ref.watch(firestoreProvider),
    ref.watch(tradeRepositoryProvider),
  ),
);

final tradeDocProvider =
    StreamProvider.family<TradeDoc?, (String, TradeDocType)>(
      (ref, k) => ref.watch(tradeDocRepositoryProvider).watch(k.$1, k.$2),
    );

final pendingTradeDocsProvider = StreamProvider<List<TradeDoc>>(
  (ref) => ref.watch(tradeDocRepositoryProvider).watchPending(),
);

/// Moderator "যাচাই বাকি": people waiting + export papers waiting.
final pendingVerifyCountProvider = Provider<int?>((ref) {
  final people = ref.watch(pendingVerificationProvider).value;
  if (people == null) return null;
  return people.length +
      (ref.watch(pendingTradeDocsProvider).value?.length ?? 0);
});
