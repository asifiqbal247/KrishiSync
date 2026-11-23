import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../trade/data/trade_repository.dart';

/// ringing → accepted → ended, or ringing → declined / missed / cancelled.
enum CallStatus { ringing, accepted, declined, missed, cancelled, ended }

/// Firestore calls/{id}. The id is also the Agora channel name.
class Call {
  const Call({
    required this.id,
    required this.callerId,
    required this.callerName,
    this.callerPhoto,
    required this.calleeId,
    required this.calleeName,
    this.calleePhoto,
    required this.video,
    required this.status,
    this.createdAt,
  });

  final String id;
  final String callerId;
  final String callerName;
  final String? callerPhoto;
  final String calleeId;
  final String calleeName;
  final String? calleePhoto;

  /// Started as a video call (camera on); voice calls can turn it on.
  final bool video;
  final CallStatus status;
  final DateTime? createdAt;

  bool get isOver =>
      status != CallStatus.ringing && status != CallStatus.accepted;

  String peerName(String me) => me == callerId ? calleeName : callerName;
  String? peerPhoto(String me) => me == callerId ? calleePhoto : callerPhoto;

  factory Call.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    return Call(
      id: d.id,
      callerId: m['callerId'] as String? ?? '',
      callerName: m['callerName'] as String? ?? '',
      callerPhoto: m['callerPhoto'] as String?,
      calleeId: m['calleeId'] as String? ?? '',
      calleeName: m['calleeName'] as String? ?? '',
      calleePhoto: m['calleePhoto'] as String?,
      video: m['video'] as bool? ?? false,
      status: CallStatus.values.firstWhere(
        (s) => s.name == m['status'],
        orElse: () => CallStatus.ended,
      ),
      createdAt: (m['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

class CallRepository {
  CallRepository(this._db, this._trade);
  final FirebaseFirestore _db;
  final TradeRepository _trade;

  /// A call still "ringing" after this long is treated as missed.
  static const ringTimeout = Duration(seconds: 45);

  CollectionReference<Map<String, dynamic>> get _calls =>
      _db.collection('calls');

  Future<String> start(AppUser me, AppUser peer, {required bool video}) async {
    final ref = _calls.doc();
    await ref.set({
      'callerId': me.uid,
      'callerName': me.name,
      'callerPhoto': me.photoUrl,
      'calleeId': peer.uid,
      'calleeName': peer.name,
      'calleePhoto': peer.photoUrl,
      'video': video,
      'status': CallStatus.ringing.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Stream<Call?> watch(String id) => _calls
      .doc(id)
      .snapshots()
      .map((d) => d.exists ? Call.fromDoc(d) : null);

  /// Calls ringing for [uid] right now.
  Stream<List<Call>> watchIncoming(String uid) => _calls
      .where('calleeId', isEqualTo: uid)
      .where('status', isEqualTo: CallStatus.ringing.name)
      .snapshots()
      .map((q) => [for (final d in q.docs) Call.fromDoc(d)]);

  Future<void> setStatus(String id, CallStatus s) => _calls.doc(id).update({
    'status': s.name,
    if (s == CallStatus.accepted) 'answeredAt': FieldValue.serverTimestamp(),
    if (s != CallStatus.accepted) 'endedAt': FieldValue.serverTimestamp(),
  });

  /// Nobody answered: mark missed and leave a bell item for the callee.
  Future<void> markMissed(Call c) async {
    await setStatus(c.id, CallStatus.missed);
    await _trade.notify(
      toUid: c.calleeId,
      fromUid: c.callerId,
      type: 'call_missed',
      params: {'name': c.callerName},
    );
  }
}

final callRepositoryProvider = Provider(
  (ref) => CallRepository(
    ref.watch(firestoreProvider),
    ref.watch(tradeRepositoryProvider),
  ),
);

final callProvider = StreamProvider.family<Call?, String>(
  (ref, id) => ref.watch(callRepositoryProvider).watch(id),
);

final incomingCallsProvider = StreamProvider<List<Call>>((ref) {
  final uid = ref.watch(currentUserProvider).value?.uid;
  if (uid == null) return Stream.value(const []);
  return ref.watch(callRepositoryProvider).watchIncoming(uid);
});
