import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';

/// chats/{a_b} — one thread between two users (ids sorted).
class ChatThread {
  const ChatThread({
    required this.id,
    required this.members,
    required this.names,
    required this.photos,
    required this.roles,
    required this.lastText,
    this.lastVoice = false,
    this.lastAt,
  });

  final String id;
  final List<String> members;
  final Map<String, String> names;
  final Map<String, String> photos;
  final Map<String, String> roles;
  final String lastText;

  /// The last message was a voice message (lastText is then empty).
  final bool lastVoice;
  final DateTime? lastAt;

  bool get hasMessages => lastText.isNotEmpty || lastVoice;

  String other(String me) =>
      members.firstWhere((m) => m != me, orElse: () => me);

  factory ChatThread.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    Map<String, String> map(String k) => {
      for (final e in (m[k] as Map<String, dynamic>? ?? const {}).entries)
        e.key: '${e.value}',
    };
    return ChatThread(
      id: d.id,
      members: [
        for (final x in (m['members'] as List<dynamic>? ?? const [])) '$x',
      ],
      names: map('names'),
      photos: map('photos'),
      roles: map('roles'),
      lastText: m['lastText'] as String? ?? '',
      lastVoice: m['lastVoice'] == true,
      lastAt: (m['lastAt'] as Timestamp?)?.toDate(),
    );
  }
}

class ChatMessage {
  const ChatMessage(this.from, this.text, this.at,
      {this.voiceUrl, this.voiceSec});
  final String from;
  final String text;
  final DateTime? at;

  /// Voice message (V2): audio URL and length in seconds.
  final String? voiceUrl;
  final int? voiceSec;
  bool get isVoice => voiceUrl != null;

  factory ChatMessage.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    return ChatMessage(
      m['from'] as String? ?? '',
      m['text'] as String? ?? '',
      (m['at'] as Timestamp?)?.toDate(),
      voiceUrl: m['voiceUrl'] as String?,
      voiceSec: (m['voiceSec'] as num?)?.toInt(),
    );
  }
}

class ChatRepository {
  ChatRepository(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _chats =>
      _db.collection('chats');

  static String idFor(String a, String b) =>
      (a.compareTo(b) < 0) ? '${a}_$b' : '${b}_$a';

  /// Creates the thread if needed (names/photos/roles of both people).
  Future<String> open(AppUser me, AppUser other) async {
    final id = idFor(me.uid, other.uid);
    final ref = _chats.doc(id);
    if (!(await ref.get()).exists) {
      await ref.set({
        'members': [me.uid, other.uid]..sort(),
        'names': {me.uid: me.name, other.uid: other.name},
        'photos': {me.uid: me.photoUrl ?? '', other.uid: other.photoUrl ?? ''},
        'roles': {
          me.uid: me.role?.name ?? '',
          other.uid: other.role?.name ?? '',
        },
        'lastText': '',
        'lastAt': FieldValue.serverTimestamp(),
      });
    }
    return id;
  }

  Stream<List<ChatThread>> watchMine(String uid) => _chats
      .where('members', arrayContains: uid)
      .orderBy('lastAt', descending: true)
      .limit(100)
      .snapshots()
      .map((q) => [for (final d in q.docs) ChatThread.fromDoc(d)]);

  Stream<ChatThread?> watch(String id) => _chats
      .doc(id)
      .snapshots()
      .map((d) => d.exists ? ChatThread.fromDoc(d) : null);

  Stream<List<ChatMessage>> watchMessages(String id) => _chats
      .doc(id)
      .collection('messages')
      .orderBy('at')
      .limitToLast(200)
      .snapshots()
      .map((q) => [for (final d in q.docs) ChatMessage.fromDoc(d)]);

  Future<void> send(String chatId, String from, String text) {
    final b = _db.batch();
    final now = FieldValue.serverTimestamp();
    b.set(_chats.doc(chatId).collection('messages').doc(), {
      'from': from,
      'text': text,
      'at': now,
    });
    b.update(_chats.doc(chatId),
        {'lastText': text, 'lastVoice': false, 'lastAt': now});
    return b.commit();
  }

  Future<void> sendVoice(String chatId, String from,
      {required String url, required int seconds}) {
    final b = _db.batch();
    final now = FieldValue.serverTimestamp();
    b.set(_chats.doc(chatId).collection('messages').doc(), {
      'from': from,
      'text': '',
      'voiceUrl': url,
      'voiceSec': seconds,
      'at': now,
    });
    b.update(_chats.doc(chatId),
        {'lastText': '', 'lastVoice': true, 'lastAt': now});
    return b.commit();
  }

  /// First admin, for "চ্যাটে সাহায্য নিন" (support chat).
  Future<AppUser?> supportUser() async {
    final q = await _db
        .collection('users')
        .where('role', isEqualTo: UserRole.admin.name)
        .limit(1)
        .get();
    return q.docs.isEmpty ? null : AppUser.fromDoc(q.docs.first);
  }
}

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(ref.watch(firestoreProvider)),
);

final myChatsProvider = StreamProvider<List<ChatThread>>((ref) {
  final uid = ref.watch(currentUserProvider).value?.uid;
  if (uid == null) return Stream.value(const []);
  return ref.watch(chatRepositoryProvider).watchMine(uid);
});

final chatProvider = StreamProvider.family<ChatThread?, String>(
  (ref, id) => ref.watch(chatRepositoryProvider).watch(id),
);

final chatMessagesProvider = StreamProvider.family<List<ChatMessage>, String>(
  (ref, id) => ref.watch(chatRepositoryProvider).watchMessages(id),
);
