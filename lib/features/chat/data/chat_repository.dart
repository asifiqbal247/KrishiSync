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
    this.lastFile = '',
    this.lastCall = '',
    this.lastDeleted = false,
    this.lastAt,
    this.readAt = const {},
    this.typing = const {},
    this.pins = const [],
  });

  final String id;
  final List<String> members;
  final Map<String, String> names;
  final Map<String, String> photos;
  final Map<String, String> roles;
  final String lastText;

  /// The last message was a voice message (lastText is then empty).
  final bool lastVoice;

  /// Kind of the last attachment (216): image | video | doc, or ''.
  final String lastFile;

  /// The last message was a call log: voice | video, or ''.
  final String lastCall;

  /// The last message was unsent.
  final bool lastDeleted;
  final DateTime? lastAt;

  /// When each person last opened the chat (WhatsApp-style "seen" ticks).
  final Map<String, DateTime> readAt;

  /// When each person last typed (shown as "লিখছে…" for a few seconds).
  final Map<String, DateTime> typing;

  /// Up to [maxPins] pinned messages, oldest first.
  final List<PinnedMessage> pins;
  static const maxPins = 3;

  bool get hasMessages =>
      lastText.isNotEmpty ||
      lastVoice ||
      lastFile.isNotEmpty ||
      lastCall.isNotEmpty ||
      lastDeleted;

  String other(String me) =>
      members.firstWhere((m) => m != me, orElse: () => me);

  factory ChatThread.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    Map<String, String> map(String k) => {
      for (final e in (m[k] as Map<String, dynamic>? ?? const {}).entries)
        e.key: '${e.value}',
    };
    Map<String, DateTime> times(String k) => {
      for (final e in (m[k] as Map<String, dynamic>? ?? const {}).entries)
        if (e.value is Timestamp) e.key: (e.value as Timestamp).toDate(),
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
      lastFile: m['lastFile'] as String? ?? '',
      lastCall: m['lastCall'] as String? ?? '',
      lastDeleted: m['lastDeleted'] == true,
      lastAt: (m['lastAt'] as Timestamp?)?.toDate(),
      readAt: times('readAt'),
      typing: times('typing'),
      pins: [
        for (final p in (m['pins'] as List<dynamic>? ?? const []))
          PinnedMessage.fromMap(p as Map<String, dynamic>),
      ],
    );
  }
}

class ChatMessage {
  const ChatMessage(
    this.from,
    this.text,
    this.at, {
    this.id = '',
    this.voiceUrl,
    this.voiceSec,
    this.voiceWave = const [],
    this.deleted = false,
    this.hiddenFor = const [],
    this.editedAt,
    this.replyTo,
    this.fileUrl,
    this.fileKind,
    this.fileName,
    this.callKind,
    this.callResult,
    this.callSec,
  });
  final String id;
  final String from;
  final String text;
  final DateTime? at;

  /// Unsent for everyone: shows "এই বার্তাটি মুছে ফেলা হয়েছে".
  final bool deleted;

  /// People who deleted it for themselves only.
  final List<String> hiddenFor;

  /// Set when the sender edited the text (within 15 minutes).
  final DateTime? editedAt;

  /// The message this one answers (quoted on top of the bubble).
  final ReplyRef? replyTo;

  /// Short text for quotes, pins and previews.
  String get kind => isVoice
      ? 'voice'
      : isFile
      ? (fileKind ?? 'doc')
      : isCall
      ? 'call'
      : 'text';

  /// Voice message (V2): audio URL and length in seconds.
  final String? voiceUrl;
  final int? voiceSec;

  /// Loudness bars (0–100) recorded with the voice message; empty for old
  /// messages.
  final List<int> voiceWave;
  bool get isVoice => voiceUrl != null;

  /// Attachment (216): image | video | doc, its URL and (doc) file name.
  final String? fileUrl;
  final String? fileKind;
  final String? fileName;
  bool get isFile => fileUrl != null;

  /// Call log (written by the caller when a call ends): voice | video,
  /// result ended | missed | declined | cancelled, and talk time.
  final String? callKind;
  final String? callResult;
  final int? callSec;
  bool get isCall => callKind != null;

  factory ChatMessage.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const {};
    return ChatMessage(
      m['from'] as String? ?? '',
      m['text'] as String? ?? '',
      (m['at'] as Timestamp?)?.toDate(),
      id: d.id,
      voiceUrl: m['voiceUrl'] as String?,
      voiceSec: (m['voiceSec'] as num?)?.toInt(),
      voiceWave: [
        for (final x in (m['voiceWave'] as List<dynamic>? ?? const []))
          (x as num).toInt(),
      ],
      deleted: m['deleted'] == true,
      editedAt: (m['editedAt'] as Timestamp?)?.toDate(),
      replyTo: m['replyTo'] is Map<String, dynamic>
          ? ReplyRef.fromMap(m['replyTo'] as Map<String, dynamic>)
          : null,
      hiddenFor: [
        for (final x in (m['hiddenFor'] as List<dynamic>? ?? const [])) '$x',
      ],
      fileUrl: m['fileUrl'] as String?,
      fileKind: m['fileKind'] as String?,
      fileName: m['fileName'] as String?,
      callKind: m['callKind'] as String?,
      callResult: m['callResult'] as String?,
      callSec: (m['callSec'] as num?)?.toInt(),
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

  Future<void> send(
    String chatId,
    String from,
    String text, {
    ReplyRef? reply,
  }) {
    final b = _db.batch();
    final now = FieldValue.serverTimestamp();
    b.set(_chats.doc(chatId).collection('messages').doc(), {
      'from': from,
      'text': text,
      'replyTo': ?reply?.toMap(),
      'at': now,
    });
    b.update(_chats.doc(chatId), {
      'lastText': text,
      'lastVoice': false,
      'lastFile': '',
      'lastCall': '',
      'lastDeleted': false,
      'lastAt': now,
    });
    return b.commit();
  }

  Future<void> sendVoice(
    String chatId,
    String from, {
    required String url,
    required int seconds,
    List<int> wave = const [],
    ReplyRef? reply,
  }) {
    final b = _db.batch();
    final now = FieldValue.serverTimestamp();
    b.set(_chats.doc(chatId).collection('messages').doc(), {
      'from': from,
      'text': '',
      'voiceUrl': url,
      'voiceSec': seconds,
      if (wave.isNotEmpty) 'voiceWave': wave,
      'replyTo': ?reply?.toMap(),
      'at': now,
    });
    b.update(_chats.doc(chatId), {
      'lastText': '',
      'lastVoice': true,
      'lastFile': '',
      'lastCall': '',
      'lastDeleted': false,
      'lastAt': now,
    });
    return b.commit();
  }

  /// Photo, video or document message (216).
  Future<void> sendFile(
    String chatId,
    String from, {
    required String url,
    required String kind,
    String? name,
  }) {
    final b = _db.batch();
    final now = FieldValue.serverTimestamp();
    b.set(_chats.doc(chatId).collection('messages').doc(), {
      'from': from,
      'text': '',
      'fileUrl': url,
      'fileKind': kind,
      'fileName': ?name,
      'at': now,
    });
    b.update(_chats.doc(chatId), {
      'lastText': '',
      'lastVoice': false,
      'lastFile': kind,
      'lastCall': '',
      'lastDeleted': false,
      'lastAt': now,
    });
    return b.commit();
  }

  /// Call log bubble ("ভয়েস কল · ১৮ সেকেন্ড"); tapping it calls back.
  Future<void> sendCallLog(
    String chatId,
    String from, {
    required bool video,
    required String result,
    required int seconds,
  }) {
    final b = _db.batch();
    final now = FieldValue.serverTimestamp();
    final kind = video ? 'video' : 'voice';
    b.set(_chats.doc(chatId).collection('messages').doc(), {
      'from': from,
      'text': '',
      'callKind': kind,
      'callResult': result,
      'callSec': seconds,
      'at': now,
    });
    b.update(_chats.doc(chatId), {
      'lastText': '',
      'lastVoice': false,
      'lastFile': '',
      'lastCall': kind,
      'lastDeleted': false,
      'lastAt': now,
    });
    return b.commit();
  }

  /// Unsend for everyone (own message): the content is removed and the
  /// bubble says it was deleted. [isLast]: also update the chat preview.
  Future<void> unsend(String chatId, String messageId, {required bool isLast}) {
    final b = _db.batch();
    b.update(_chats.doc(chatId).collection('messages').doc(messageId), {
      'deleted': true,
      'text': '',
      for (final k in _contentKeys) k: FieldValue.delete(),
    });
    if (isLast) {
      b.update(_chats.doc(chatId), {
        'lastText': '',
        'lastVoice': false,
        'lastFile': '',
        'lastCall': '',
        'lastDeleted': true,
      });
    }
    return b.commit();
  }

  /// Edit own text (rules allow 15 minutes after sending).
  static const editWindow = Duration(minutes: 15);

  Future<void> edit(
    String chatId,
    String messageId,
    String text, {
    required bool isLast,
  }) {
    final b = _db.batch();
    b.update(_chats.doc(chatId).collection('messages').doc(messageId), {
      'text': text,
      'editedAt': FieldValue.serverTimestamp(),
    });
    if (isLast) b.update(_chats.doc(chatId), {'lastText': text});
    return b.commit();
  }

  /// Opened the chat: the other person's messages so far are "seen".
  Future<void> markRead(String chatId, String uid) =>
      _chats.doc(chatId).update({'readAt.$uid': FieldValue.serverTimestamp()});

  /// "লিখছে…": on while typing (sent at most every few seconds), off when
  /// the text is sent or cleared.
  Future<void> setTyping(String chatId, String uid, {required bool on}) =>
      _chats.doc(chatId).update({
        'typing.$uid': on ? FieldValue.serverTimestamp() : FieldValue.delete(),
      });

  Future<void> setPins(String chatId, List<PinnedMessage> pins) =>
      _chats.doc(chatId).update({
        'pins': [for (final p in pins) p.toMap()],
      });

  /// Delete for me: hidden only on [uid]'s side.
  Future<void> hideForMe(String chatId, String messageId, String uid) =>
      _chats.doc(chatId).collection('messages').doc(messageId).update({
        'hiddenFor': FieldValue.arrayUnion([uid]),
      });

  static const _contentKeys = [
    'voiceUrl',
    'voiceSec',
    'voiceWave',
    'fileUrl',
    'fileKind',
    'fileName',
    'callKind',
    'callResult',
    'callSec',
  ];

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

/// The quoted message of a reply: who wrote it and a short preview.
class ReplyRef {
  const ReplyRef({
    required this.id,
    required this.from,
    required this.text,
    required this.kind,
  });

  final String id;
  final String from;

  /// Text of the original (cut to [maxText]); empty for voice / files.
  final String text;

  /// text | voice | image | video | doc | call
  final String kind;

  static const maxText = 120;

  factory ReplyRef.of(ChatMessage m) => ReplyRef(
    id: m.id,
    from: m.from,
    text: m.text.length > maxText ? m.text.substring(0, maxText) : m.text,
    kind: m.kind,
  );

  factory ReplyRef.fromMap(Map<String, dynamic> m) => ReplyRef(
    id: m['id'] as String? ?? '',
    from: m['from'] as String? ?? '',
    text: m['text'] as String? ?? '',
    kind: m['kind'] as String? ?? 'text',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'from': from,
    'text': text,
    'kind': kind,
  };
}

/// A pinned message as shown in the bar on top of the chat.
typedef PinnedMessage = ReplyRef;
