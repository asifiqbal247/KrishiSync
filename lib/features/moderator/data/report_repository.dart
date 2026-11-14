import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../trade/data/trade_repository.dart';
import '../../trade/domain/trade_models.dart';

enum ReportStatus {
  open,
  inReview,
  resolved,
  dismissed;

  static ReportStatus parse(String? v) =>
      values.firstWhere((s) => s.name == v, orElse: () => open);
}

/// Reasons from Figma 203/204 (labels in ARB).
abstract final class ReportReasons {
  static const all = [
    'driver_behavior',
    'late_delivery',
    'app_problem',
    'other',
  ];
}

/// Firestore: reports/{id} (Report Issue 203/204 → Moderator M4/M5).
class Report {
  const Report({
    required this.id,
    required this.reporterId,
    required this.reporterName,
    required this.reporterRole,
    this.orderId,
    this.orderNo,
    this.cropNameBn,
    this.cropNameEn,
    required this.reason,
    required this.details,
    this.photoUrl,
    required this.status,
    this.escalated = false,
    this.modNote,
    this.createdAt,
  });

  final String id;
  final String reporterId;
  final String reporterName;
  final String reporterRole;
  final String? orderId;
  final String? orderNo;
  final String? cropNameBn;
  final String? cropNameEn;
  final String reason;
  final String details;
  final String? photoUrl;
  final ReportStatus status;
  final bool escalated;
  final String? modNote;
  final DateTime? createdAt;

  String? cropName(String lang) => lang == 'bn' ? cropNameBn : cropNameEn;

  factory Report.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    return Report(
      id: d.id,
      reporterId: m['reporterId'] as String? ?? '',
      reporterName: m['reporterName'] as String? ?? '',
      reporterRole: m['reporterRole'] as String? ?? '',
      orderId: m['orderId'] as String?,
      orderNo: m['orderNo'] as String?,
      cropNameBn: m['cropNameBn'] as String?,
      cropNameEn: m['cropNameEn'] as String?,
      reason: m['reason'] as String? ?? 'other',
      details: m['details'] as String? ?? '',
      photoUrl: m['photoUrl'] as String?,
      status: ReportStatus.parse(m['status'] as String?),
      escalated: m['escalated'] as bool? ?? false,
      modNote: m['modNote'] as String?,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

class ReportRepository {
  ReportRepository(this._db, this._trade);
  final FirebaseFirestore _db;
  final TradeRepository _trade;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('reports');

  Future<void> create({
    required AppUser me,
    TradeOrder? order,
    required String reason,
    required String details,
    String? photoUrl,
  }) => _col.add({
    'reporterId': me.uid,
    'reporterName': me.name,
    'reporterRole': me.role?.name ?? '',
    'orderId': order?.id,
    'orderNo': order?.orderNo,
    'cropNameBn': order?.cropNameBn,
    'cropNameEn': order?.cropNameEn,
    'reason': reason,
    'details': details,
    'photoUrl': photoUrl,
    'status': ReportStatus.open.name,
    'escalated': false,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  });

  Stream<List<Report>> watchByStatus(ReportStatus s) => _col
      .where('status', isEqualTo: s.name)
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots()
      .map((q) => [for (final d in q.docs) Report.fromDoc(d)]);

  Stream<Report?> watch(String id) =>
      _col.doc(id).snapshots().map((d) => d.exists ? Report.fromDoc(d) : null);

  Future<int> countOpen() async =>
      (await _col
              .where('status', isEqualTo: ReportStatus.open.name)
              .count()
              .get())
          .count ??
      0;

  /// Moderator: move a report on, optionally with a note to the reporter.
  Future<void> setStatus(
    Report r,
    ReportStatus s, {
    required String modUid,
    String? note,
    bool? escalate,
  }) async {
    await _col.doc(r.id).update({
      'status': s.name,
      'handledBy': modUid,
      if (note != null && note.isNotEmpty) 'modNote': note,
      'escalated': ?escalate,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    if (s == ReportStatus.resolved || s == ReportStatus.dismissed) {
      await _trade.notify(
        toUid: r.reporterId,
        fromUid: modUid,
        type: s == ReportStatus.resolved
            ? 'report_resolved'
            : 'report_dismissed',
        params: {'no': r.orderNo ?? '', 'note': note ?? ''},
        link: r.orderId == null ? null : 'order:${r.orderId}',
      );
    }
  }
}

final reportRepositoryProvider = Provider<ReportRepository>(
  (ref) => ReportRepository(
    ref.watch(firestoreProvider),
    ref.watch(tradeRepositoryProvider),
  ),
);

final reportsByStatusProvider =
    StreamProvider.family<List<Report>, ReportStatus>(
      (ref, s) => ref.watch(reportRepositoryProvider).watchByStatus(s),
    );

final reportProvider = StreamProvider.family<Report?, String>(
  (ref, id) => ref.watch(reportRepositoryProvider).watch(id),
);

final openReportsCountProvider = StreamProvider<int>(
  (ref) => ref
      .watch(reportRepositoryProvider)
      .watchByStatus(ReportStatus.open)
      .map((l) => l.length),
);
