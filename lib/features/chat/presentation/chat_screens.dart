import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_icon.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_search_bar.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../auth/data/user_repository.dart';
import '../../call/presentation/call_screens.dart';
import '../../auth/domain/app_user.dart';
import '../../moderator/presentation/report_screens.dart';
import '../../../shared/services/image_storage_service.dart';
import '../data/chat_repository.dart';
import 'attach_sheet.dart';
import 'voice_sheet.dart';

const _pad = EdgeInsets.fromLTRB(
  AppSpacing.screen,
  AppSpacing.contentTop,
  AppSpacing.screen,
  AppSpacing.lg,
);

/// Opens (creating if needed) the chat with [otherUid] and shows it.
Future<void> openChatWith(
  BuildContext context,
  WidgetRef ref,
  String otherUid,
) async {
  final l = AppLocalizations.of(context);
  final me = ref.read(currentUserProvider).value;
  final other = await ref.read(userByIdProvider(otherUid).future);
  if (me == null || other == null || !context.mounted) return;
  try {
    final id = await ref.read(chatRepositoryProvider).open(me, other);
    if (context.mounted) context.push(Routes.chat(id));
  } catch (_) {
    if (context.mounted) KsToast.show(context, l.errorGeneric);
  }
}

/// "10:30", "গতকাল" or a date — the list's time column (65).
String chatTime(BuildContext context, DateTime? t) {
  if (t == null) return '';
  final now = DateTime.now();
  final day = DateTime(t.year, t.month, t.day);
  final today = DateTime(now.year, now.month, now.day);
  if (day == today) return Fmt.digits(context, DateFormat('H:mm').format(t));
  if (today.difference(day).inDays == 1) {
    return AppLocalizations.of(context).yesterday;
  }
  return Fmt.date(context, t);
}

/// Name as shown in a thread: drivers get "(চালক)" like Figma 65.
String chatName(AppLocalizations l, ChatThread c, String uid) {
  final n = c.names[uid] ?? '';
  return c.roles[uid] == UserRole.transporter.name
      ? l.nameWithRole(n, l.roleDriverShort)
      : n;
}

/// 65 / 135 / 189 Messages (Figma 292:837).
class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesState();
}

class _MessagesState extends ConsumerState<MessagesScreen> {
  final _q = TextEditingController();

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    final async = ref.watch(myChatsProvider);
    final q = _q.text.trim().toLowerCase();
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.messagesTitle),
      body: switch (async) {
        AsyncData(value: final all) when me != null => () {
          final list = all
              .where((c) => c.hasMessages)
              .where(
                (c) =>
                    (c.names[c.other(me.uid)] ?? '').toLowerCase().contains(q),
              )
              .toList();
          return ListView(
            padding: _pad,
            children: [
              KsSearchBar(
                hint: l.searchNameHint,
                controller: _q,
                onChanged: (_) => setState(() {}),
              ),
              if (list.isEmpty) ...[
                const SizedBox(height: AppSpacing.block),
                Text(
                  l.noChats,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.normal.withColor(
                    AppColors.textSecondary,
                  ),
                ),
              ],
              for (final c in list) ...[
                const SizedBox(height: AppSpacing.block),
                KsListItem(
                  thumb: KsNetImage(
                    url: (c.photos[c.other(me.uid)] ?? '').isEmpty
                        ? null
                        : c.photos[c.other(me.uid)],
                    thumbSize: KsListItem.thumbSize.round(),
                    fallbackAsset: avatarFor(c.roles[c.other(me.uid)]),
                  ),
                  title: chatName(l, c, c.other(me.uid)),
                  subtitle: switch (c.lastFile) {
                    'image' => l.attachPhoto,
                    'video' => l.attachVideo,
                    'doc' => l.attachDoc,
                    _ when c.lastDeleted => l.msgUnsent,
                    _ => switch (c.lastCall) {
                      'voice' => l.callLogVoice,
                      'video' => l.callLogVideo,
                      _ => c.lastVoice ? l.voiceMessage : c.lastText,
                    },
                  },
                  trailingText: chatTime(context, c.lastAt),
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    context.push(Routes.chat(c.id));
                  },
                ),
              ],
            ],
          );
        }(),
        AsyncError() => Center(child: Text(l.errorGeneric)),
        _ => const KsSkeletonList(),
      },
    );
  }
}

/// 66 / 136 / 190 Chat (Figma 292:845). Text, voice (V2) and attachments
/// (216: photo, video, document) are real; video calls are Tier C.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.chatId});
  final String chatId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatState();
}

class _ChatState extends ConsumerState<ChatScreen> {
  final _text = TextEditingController();
  final _scroll = ScrollController();
  static const _btn = 44.0;
  static const _bubbleMax = 0.72;

  final _player = AudioPlayer();
  StreamSubscription<Duration>? _posSub;
  StreamSubscription<Duration>? _durSub;
  StreamSubscription<void>? _endSub;
  String? _playing; // voice URL now loaded in the player
  bool _paused = false;
  Duration _pos = Duration.zero;
  Duration _dur = Duration.zero;

  /// Messenger-like speed chip: 1× → 1.5× → 2×.
  static const _speeds = [1.0, 1.5, 2.0];
  int _speed = 0;
  bool _sendingVoice = false;
  bool _sendingFile = false;

  @override
  void initState() {
    super.initState();
    _posSub = _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _pos = p);
    });
    _durSub = _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _dur = d);
    });
    _endSub = _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _playing = null;
          _paused = false;
          _pos = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _durSub?.cancel();
    _endSub?.cancel();
    _player.dispose();
    _text.dispose();
    _scroll.dispose();
    super.dispose();
  }

  /// Play button: start, pause or resume this voice message.
  Future<void> _playPause(String url) async {
    try {
      if (_playing == url) {
        if (_paused) {
          await _player.resume();
        } else {
          await _player.pause();
        }
        if (mounted) setState(() => _paused = !_paused);
        return;
      }
      await _start(url);
    } catch (_) {
      _playFailed();
    }
  }

  Future<void> _start(String url, {Duration from = Duration.zero}) async {
    await _player.stop();
    setState(() {
      _playing = url;
      _paused = false;
      _pos = from;
      _dur = Duration.zero;
    });
    await _player.play(UrlSource(url), position: from);
    await _player.setPlaybackRate(_speeds[_speed]);
  }

  /// Tap / drag on the waveform: jump there ([f] = 0…1 of [seconds]).
  Future<void> _seek(String url, double f, int seconds) async {
    final total = _playing == url && _dur > Duration.zero
        ? _dur
        : Duration(seconds: seconds);
    final to = total * f.clamp(0.0, 1.0);
    try {
      if (_playing == url) {
        await _player.seek(to);
        setState(() => _pos = to);
      } else {
        await _start(url, from: to);
      }
    } catch (_) {
      _playFailed();
    }
  }

  Future<void> _cycleSpeed() async {
    setState(() => _speed = (_speed + 1) % _speeds.length);
    try {
      await _player.setPlaybackRate(_speeds[_speed]);
    } catch (_) {}
  }

  void _playFailed() {
    if (!mounted) return;
    setState(() {
      _playing = null;
      _paused = false;
    });
    KsToast.show(context, AppLocalizations.of(context).voicePlayFailed);
  }

  /// Long-press a message: unsend for everyone (own) / delete for me.
  Future<void> _messageMenu(ChatMessage m, String me, bool isLast) async {
    final l = AppLocalizations.of(context);
    final repo = ref.read(chatRepositoryProvider);
    final mine = m.from == me;
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (mine && !m.deleted) ...[
                KsListItem(
                  title: l.msgUnsend,
                  subtitle: l.msgUnsendSub,
                  showChevron: false,
                  onTap: () => Navigator.pop(ctx, 'unsend'),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              KsListItem(
                title: l.msgDeleteMe,
                subtitle: l.msgDeleteMeSub,
                showChevron: false,
                onTap: () => Navigator.pop(ctx, 'me'),
              ),
            ],
          ),
        ),
      ),
    );
    if (choice == null || !mounted) return;
    try {
      if (choice == 'unsend') {
        final ok = await showKsConfirm(
          context,
          title: l.msgUnsendConfirm,
          body: l.msgUnsendConfirmBody,
          noLabel: l.noGoBack,
          yesLabel: l.msgDeleteYes,
        );
        if (!ok) return;
        if (_playing == m.voiceUrl) await _player.stop();
        await repo.unsend(widget.chatId, m.id, isLast: isLast);
      } else {
        await repo.hideForMe(widget.chatId, m.id, me);
      }
    } catch (_) {
      if (mounted) KsToast.show(context, l.errorGeneric);
    }
  }

  /// Mic: record (V2), upload, send.
  Future<void> _voice(String uid) async {
    if (_sendingVoice) return;
    FocusManager.instance.primaryFocus?.unfocus();
    final rec = await recordVoice(context);
    if (rec == null || !mounted) return;
    final (:file, seconds: sec, :wave) = rec;
    setState(() => _sendingVoice = true);
    try {
      final url = await ref
          .read(imageStorageProvider)
          .uploadAudio(file, ownerUid: uid);
      await ref
          .read(chatRepositoryProvider)
          .sendVoice(widget.chatId, uid, url: url, seconds: sec, wave: wave);
    } catch (_) {
      if (mounted) {
        KsToast.show(context, AppLocalizations.of(context).errorGeneric);
      }
    } finally {
      if (mounted) setState(() => _sendingVoice = false);
    }
  }

  /// "+": pick a photo, video or document (216), upload, send.
  Future<void> _attach(String uid) async {
    if (_sendingFile) return;
    FocusManager.instance.primaryFocus?.unfocus();
    final picked = await pickAttachment(context);
    if (picked == null || !mounted) return;
    final l = AppLocalizations.of(context);
    setState(() => _sendingFile = true);
    try {
      final store = ref.read(imageStorageProvider);
      final url = picked.kind == 'image'
          ? (await store.upload(
              picked.file,
              kind: ImageKind.chat,
              ownerUid: uid,
            )).url
          : await store.uploadFile(
              picked.file,
              video: picked.kind == 'video',
              ownerUid: uid,
            );
      await ref
          .read(chatRepositoryProvider)
          .sendFile(
            widget.chatId,
            uid,
            url: url,
            kind: picked.kind,
            name: picked.name,
          );
    } on ImageUploadException catch (e) {
      if (mounted) {
        KsToast.show(
          context,
          e.message == 'too_large'
              ? l.fileTooLarge(
                  Fmt.digits(context, picked.kind == 'video' ? '20' : '5'),
                )
              : l.errorGeneric,
        );
      }
    } catch (_) {
      if (mounted) KsToast.show(context, l.errorGeneric);
    } finally {
      if (mounted) setState(() => _sendingFile = false);
    }
  }

  /// Video or PDF: open in the phone's own player / viewer.
  Future<void> _openFile(String url) async {
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && mounted) {
      KsToast.show(context, AppLocalizations.of(context).fileOpenFailed);
    }
  }

  Future<void> _send(String uid) async {
    final t = _text.text.trim();
    if (t.isEmpty) return;
    _text.clear();
    try {
      await ref.read(chatRepositoryProvider).send(widget.chatId, uid, t);
    } catch (_) {
      if (mounted) {
        KsToast.show(context, AppLocalizations.of(context).errorGeneric);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    final chat = ref.watch(chatProvider(widget.chatId)).value;
    final msgs = ref.watch(chatMessagesProvider(widget.chatId)).value;
    // "Delete for me" hides a message only on this side.
    final shown = msgs
        ?.where((m) => me == null || !m.hiddenFor.contains(me.uid))
        .toList();
    void soon() => KsToast.comingSoon(context);
    final width = MediaQuery.of(context).size.width;
    if (msgs != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.jumpTo(_scroll.position.maxScrollExtent);
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(
        title: chat == null || me == null
            ? ''
            : chatName(l, chat, chat.other(me.uid)),
        actions: [
          // Audio call (not in Figma; Asif asked for it, left of video).
          _RoundButton(
            icon: AppIcons.phone,
            onTap: chat == null || me == null
                ? soon
                : () => startCall(context, ref, chat.other(me.uid)),
          ),
          const SizedBox(width: AppSpacing.sm),
          _RoundButton(
            icon: AppIcons.video,
            onTap: chat == null || me == null
                ? soon
                : () => startCall(
                    context,
                    ref,
                    chat.other(me.uid),
                    video: true,
                  ),
          ),
          // Info (like Messenger): the other person's profile.
          if (chat != null && me != null)
            ?switch (profileRouteFor(
              chat.roles[chat.other(me.uid)],
              chat.other(me.uid),
            )) {
              final route? => Padding(
                padding: const EdgeInsets.only(left: AppSpacing.sm),
                child: _RoundButton(
                  icon: AppIcons.info,
                  onTap: () => context.push(route),
                ),
              ),
              null => null,
            },
          const SizedBox(width: AppSpacing.lg),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: msgs == null || me == null
                  ? const KsSkeletonList(rows: 3)
                  : shown!.isEmpty
                  ? Center(
                      child: Text(
                        l.chatStart,
                        style: AppTypography.bodyMedium.normal.withColor(
                          AppColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.separated(
                      controller: _scroll,
                      padding: _pad,
                      itemCount: shown.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.block),
                      itemBuilder: (_, i) {
                        final m = shown[i];
                        final mine = m.from == me.uid;
                        return Align(
                          alignment: mine
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          // Long-press: unsend for everyone / delete for me.
                          child: GestureDetector(
                            onLongPress: () => _messageMenu(
                              m,
                              me.uid,
                              m.id == msgs.last.id,
                            ),
                            child: m.deleted
                              ? _DeletedBubble(
                                  mine: mine,
                                  maxWidth: width * _bubbleMax,
                                )
                              : m.isVoice
                              ? _VoiceBubble(
                                  m: m,
                                  mine: mine,
                                  maxWidth: width * _bubbleMax,
                                  active: _playing == m.voiceUrl,
                                  playing:
                                      _playing == m.voiceUrl && !_paused,
                                  position: _playing == m.voiceUrl
                                      ? _pos
                                      : Duration.zero,
                                  duration:
                                      _playing == m.voiceUrl &&
                                          _dur > Duration.zero
                                      ? _dur
                                      : Duration(seconds: m.voiceSec ?? 0),
                                  speed: _speeds[_speed],
                                  onPlay: () => _playPause(m.voiceUrl!),
                                  onSeek: (f) => _seek(
                                    m.voiceUrl!,
                                    f,
                                    m.voiceSec ?? 0,
                                  ),
                                  onSpeed: _cycleSpeed,
                                )
                              : m.isCall
                              ? _CallBubble(
                                  m: m,
                                  mine: mine,
                                  maxWidth: width * _bubbleMax,
                                  // Tap = call back (same kind).
                                  onTap: () => startCall(
                                    context,
                                    ref,
                                    chat!.other(me.uid),
                                    video: m.callKind == 'video',
                                  ),
                                )
                              : m.isFile
                              ? _FileBubble(
                                  m: m,
                                  mine: mine,
                                  maxWidth: width * _bubbleMax,
                                  onOpen: () => m.fileKind == 'image'
                                      ? showPhoto(context, m.fileUrl!)
                                      : _openFile(
                                          m.fileKind == 'video'
                                              ? playableVideo(m.fileUrl!)
                                              : m.fileUrl!,
                                        ),
                                )
                              : Container(
                                  constraints: BoxConstraints(
                                    maxWidth: width * _bubbleMax,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: AppSpacing.x10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: mine
                                        ? AppColors.bgBrand
                                        : AppColors.bgSurface,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.lg,
                                    ),
                                  ),
                                  child: Text(
                                    m.text,
                                    style: AppTypography.bodyMedium.normal
                                        .withColor(
                                          mine
                                              ? AppColors.textOnBrand
                                              : AppColors.textPrimary,
                                        ),
                                  ),
                                ),
                          ),
                        );
                      },
                    ),
            ),
            if (_sendingFile) ...[
              const LinearProgressIndicator(
                color: AppColors.bgBrand,
                backgroundColor: AppColors.bgSubtle,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            // Composer (292:862): attach · field · voice · send, gap 8.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                AppSpacing.lg,
              ),
              child: Row(
                children: [
                  _RoundButton(
                    icon: AppIcons.plus,
                    onTap: me == null ? null : () => _attach(me.uid),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Container(
                      height: _btn,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.block,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgSurface,
                        borderRadius: BorderRadius.circular(_btn / 2),
                      ),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: _text,
                        style: AppTypography.bodyMedium.normal,
                        cursorColor: AppColors.bgBrand,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => me == null ? null : _send(me.uid),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: l.typeMessage,
                          hintStyle: AppTypography.bodyMedium.normal.withColor(
                            AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(
                    onTap: me == null || _sendingVoice
                        ? null
                        : () => _voice(me.uid),
                    child: Image.asset(
                      AppUi.chatVoice,
                      width: _btn,
                      height: _btn,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(
                    onTap: me == null ? null : () => _send(me.uid),
                    child: Image.asset(
                      AppUi.chatSend,
                      width: _btn,
                      height: _btn,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 44px subtle circle with a 24px brand icon (attach / video call).
class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.onTap});
  final String icon;
  final VoidCallback? onTap;
  static const _size = 44.0;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.bgSubtle,
    shape: const CircleBorder(),
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: SizedBox.square(
        dimension: _size,
        child: Center(
          child: AppIcon(icon, size: AppSizes.icon, color: AppColors.iconBrand),
        ),
      ),
    ),
  );
}

/// Chat attachment (216). Photo: rounded picture, tap for full screen.
/// Video / document: bubble with the sheet's icon tile and a label.
/// Unsent message: "এই বার্তাটি মুছে ফেলা হয়েছে" in an outlined bubble.
class _DeletedBubble extends StatelessWidget {
  const _DeletedBubble({required this.mine, required this.maxWidth});
  final bool mine;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.x10,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgPage,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Text(
        mine ? l.msgUnsentMine : l.msgUnsent,
        style: AppTypography.bodyMedium.normal.withColor(
          AppColors.textSecondary,
        ),
      ),
    );
  }
}

/// Voice message player (Messenger-like; not in Figma): play / pause,
/// waveform of the recording (tap or drag to jump), time, speed chip.
class _VoiceBubble extends StatelessWidget {
  const _VoiceBubble({
    required this.m,
    required this.mine,
    required this.maxWidth,
    required this.active,
    required this.playing,
    required this.position,
    required this.duration,
    required this.speed,
    required this.onPlay,
    required this.onSeek,
    required this.onSpeed,
  });

  final ChatMessage m;
  final bool mine;
  final double maxWidth;

  /// This message is loaded in the player (playing or paused).
  final bool active;
  final bool playing;
  final Duration position;
  final Duration duration;
  final double speed;
  final VoidCallback onPlay;
  final ValueChanged<double> onSeek;
  final VoidCallback onSpeed;

  static const _button = 32.0;
  static const _icon = 16.0;
  static const _waveH = 28.0;
  static const _waveW = 132.0;
  static const _chipH = 22.0;

  /// Old messages have no recorded waveform: a steady pattern from the URL.
  List<int> get _bars {
    if (m.voiceWave.isNotEmpty) return m.voiceWave;
    var x = (m.voiceUrl ?? '').hashCode & 0x7fffffff;
    return [
      for (var i = 0; i < voiceWaveBars; i++)
        () {
          x = (x * 1103515245 + 12345) & 0x7fffffff;
          return 25 + x % 60;
        }(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final total = duration.inMilliseconds;
    final played = total == 0
        ? 0.0
        : (position.inMilliseconds / total).clamp(0.0, 1.0);
    final fg = mine ? AppColors.textOnBrand : AppColors.textPrimary;
    final shown = active ? position : duration;
    final speedText = Fmt.digits(
      context,
      '${speed == speed.roundToDouble() ? speed.round() : speed}×',
    );

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.x10,
      ),
      decoration: BoxDecoration(
        color: mine ? AppColors.bgBrand : AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            button: true,
            label: playing ? l.voicePause : l.voicePlay,
            child: GestureDetector(
              onTap: onPlay,
              child: Container(
                width: _button,
                height: _button,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: mine
                      ? AppColors.voiceMineButton
                      : AppColors.voiceTheirsButton,
                ),
                child: AppIcon(
                  playing ? AppIcons.pause : AppIcons.play,
                  size: _icon,
                  color: mine
                      ? AppColors.voiceMineIcon
                      : AppColors.voiceTheirsIcon,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (d) => onSeek(d.localPosition.dx / _waveW),
              onHorizontalDragUpdate: (d) =>
                  onSeek(d.localPosition.dx / _waveW),
              child: SizedBox(
                width: _waveW,
                height: _waveH,
                child: CustomPaint(
                  painter: _WavePainter(
                    bars: _bars,
                    played: played,
                    playedColor: mine
                        ? AppColors.voiceMinePlayed
                        : AppColors.voiceTheirsPlayed,
                    restColor: mine
                        ? AppColors.voiceMineRest
                        : AppColors.voiceTheirsRest,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            voiceLen(context, shown.inSeconds),
            style: AppTypography.caption.normal.withColor(fg),
          ),
          if (active) ...[
            const SizedBox(width: AppSpacing.sm),
            Semantics(
              button: true,
              label: l.voiceSpeed(speedText),
              child: GestureDetector(
                onTap: onSpeed,
                child: Container(
                  height: _chipH,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: mine
                        ? AppColors.voiceMineChip
                        : AppColors.voiceTheirsChip,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    speedText,
                    style: AppTypography.labelSmall.normal.withColor(fg),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Rounded bars; the played part (left) in [playedColor].
class _WavePainter extends CustomPainter {
  _WavePainter({
    required this.bars,
    required this.played,
    required this.playedColor,
    required this.restColor,
  });

  final List<int> bars;
  final double played;
  final Color playedColor;
  final Color restColor;

  static const _minBar = 0.12;
  static const _gapRatio = 0.4;

  @override
  void paint(Canvas canvas, Size size) {
    if (bars.isEmpty) return;
    final slot = size.width / bars.length;
    final barW = slot * (1 - _gapRatio);
    final paint = Paint()..strokeCap = StrokeCap.round;
    for (var i = 0; i < bars.length; i++) {
      final h = size.height * (_minBar + (1 - _minBar) * bars[i] / 100);
      final x = i * slot + slot / 2;
      paint
        ..color = (i + 0.5) / bars.length <= played ? playedColor : restColor
        ..strokeWidth = barW;
      canvas.drawLine(
        Offset(x, (size.height - h) / 2 + barW / 2),
        Offset(x, (size.height + h) / 2 - barW / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WavePainter old) =>
      old.played != played ||
      old.bars != bars ||
      old.playedColor != playedColor;
}

/// Public profile page of a chat partner (info button), or null (staff).
String? profileRouteFor(String? role, String uid) => switch (role) {
  'farmer' => Routes.buyerFarmer(uid),
  'buyer' => Routes.buyerProfile(uid),
  'transporter' => Routes.transporterProfile(uid),
  _ => null,
};

/// Call log: phone / video icon, "ভয়েস কল" + talk time or the result.
/// The caller wrote it, so "mine" = I called. Tap calls back.
class _CallBubble extends StatelessWidget {
  const _CallBubble({
    required this.m,
    required this.mine,
    required this.maxWidth,
    required this.onTap,
  });

  final ChatMessage m;
  final bool mine;
  final double maxWidth;
  final VoidCallback onTap;

  static const _tile = 36.0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final video = m.callKind == 'video';
    final sec = m.callSec ?? 0;
    final missed = !mine && m.callResult != 'ended';
    final fg = mine ? AppColors.textOnBrand : AppColors.textPrimary;
    final title = missed
        ? (video ? l.callLogMissedVideo : l.callLogMissedVoice)
        : (video ? l.callLogVideo : l.callLogVoice);
    final sub = switch (m.callResult) {
      'ended' => sec < 60
          ? l.callLogSeconds(Fmt.digits(context, '$sec'))
          : voiceLen(context, sec),
      'declined' when mine => l.callLogDeclined,
      'cancelled' when mine => l.callLogCancelled,
      _ when mine => l.callLogNoAnswer,
      _ => l.callLogTapBack,
    };
    return Semantics(
      button: true,
      label: '$title, $sub',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: const EdgeInsets.all(AppSpacing.x10),
          decoration: BoxDecoration(
            color: mine ? AppColors.bgBrand : AppColors.bgSurface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: _tile,
                height: _tile,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: mine ? AppColors.bgBrandHover : AppColors.bgSubtle,
                ),
                child: AppIcon(
                  video ? AppIcons.video : AppIcons.phone,
                  size: AppSizes.icon,
                  color: mine
                      ? AppColors.textOnBrand
                      : missed
                      ? AppColors.textError
                      : AppColors.iconBrand,
                ),
              ),
              const SizedBox(width: AppSpacing.x10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyMediumStrong.normal.withColor(
                        missed ? AppColors.textError : fg,
                      ),
                    ),
                    Text(
                      sub,
                      style: AppTypography.caption.normal.withColor(fg),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FileBubble extends StatelessWidget {
  const _FileBubble({
    required this.m,
    required this.mine,
    required this.maxWidth,
    required this.onOpen,
  });

  final ChatMessage m;
  final bool mine;
  final double maxWidth;
  final VoidCallback onOpen;

  static const _photoAspect = 4 / 3;
  static const _tile = 36.0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final radius = BorderRadius.circular(AppRadius.lg);
    if (m.fileKind == 'image') {
      return GestureDetector(
        onTap: onOpen,
        child: ClipRRect(
          borderRadius: radius,
          child: SizedBox(
            width: maxWidth,
            height: maxWidth / _photoAspect,
            child: KsNetImage(url: m.fileUrl),
          ),
        ),
      );
    }
    final video = m.fileKind == 'video';
    final fg = mine ? AppColors.textOnBrand : AppColors.textPrimary;
    return GestureDetector(
      onTap: onOpen,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: const EdgeInsets.all(AppSpacing.x10),
        decoration: BoxDecoration(
          color: mine ? AppColors.bgBrand : AppColors.bgSurface,
          borderRadius: radius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Image.asset(
                video ? AppUi.attachVideo : AppUi.attachDoc,
                width: _tile,
                height: _tile,
              ),
            ),
            const SizedBox(width: AppSpacing.x10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    video ? l.attachVideo : (m.fileName ?? l.attachDoc),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMediumStrong.normal.withColor(fg),
                  ),
                  Text(
                    video ? l.videoTapToWatch : l.attachDoc,
                    style: AppTypography.caption.normal.withColor(fg),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Cloudinary delivery as H.264 MP4, so any phone's player or browser can
/// play it (phones may record HEVC; converted once, then cached).
String playableVideo(String url) => url.contains('/video/upload/')
    ? url.replaceFirst('/video/upload/', '/video/upload/vc_h264,f_mp4/')
    : url;

/// Full-screen photo with pinch zoom (chat photos, papers).
Future<void> showPhoto(BuildContext context, String url) => showDialog<void>(
  context: context,
  barrierColor: AppColors.photoBackdrop,
  builder: (ctx) => GestureDetector(
    onTap: () => Navigator.pop(ctx),
    child: InteractiveViewer(
      child: Center(
        child: KsNetImage(url: url, fit: BoxFit.contain),
      ),
    ),
  ),
);

// ───────────────────────── Help ─────────────────────────

/// One FAQ: title + answer sections (role label, text).
typedef Faq = (String, List<(String?, String)>);

List<Faq> faqs(AppLocalizations l) => [
  (l.q1, [(null, l.q1Farmer)]),
  (
    l.q2,
    [
      (l.roleFarmer, l.q2Farmer),
      (l.roleTransporter, l.q2Transporter),
      (l.rowBuyer, l.q2Buyer),
    ],
  ),
  (l.q3, [(null, l.q3Buyer)]),
  (l.q4, [(null, l.q4Body)]),
  (l.q5, [(null, l.q5Body)]),
];

/// Calls the helpline (number in the ARB files: `helplineNumber`).
Future<void> callHelpline(BuildContext context) => launchUrl(
  Uri(scheme: 'tel', path: AppLocalizations.of(context).helplineNumber),
);

Future<void> openSupportChat(BuildContext context, WidgetRef ref) async {
  final admin = await ref.read(chatRepositoryProvider).supportUser();
  if (admin == null || !context.mounted) return;
  await openChatWith(context, ref, admin.uid);
}

/// 205 Help & Support (Figma 292:2156).
class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final all = faqs(l);
    // Voice guides: first three topics (audio is Tier C; they open the text).
    final guides = [
      (0, AppUi.glyphLeaf, '1:20'),
      (1, AppUi.glyphWallet, '0:55'),
      (2, AppUi.glyphTruck, '1:10'),
    ];
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.helpTitle),
      body: ListView(
        padding: _pad,
        children: [
          KsButton(
            label: l.callHelpline,
            onPressed: () => callHelpline(context),
          ),
          const SizedBox(height: AppSpacing.block),
          KsSectionHeader(title: l.voiceGuideTitle),
          for (final (i, icon, t) in guides) ...[
            const SizedBox(height: AppSpacing.block),
            KsListItem(
              thumb: Container(
                color: AppColors.bgSubtle,
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Image.asset(icon),
              ),
              title: all[i].$1,
              subtitle: l.listenTime(Fmt.digits(context, t)),
              onTap: () => context.push(Routes.faq(i)),
            ),
          ],
          const SizedBox(height: AppSpacing.block),
          KsSectionHeader(title: l.commonQuestions),
          for (final i in [3, 4]) ...[
            const SizedBox(height: AppSpacing.block),
            KsListItem(
              title: all[i].$1,
              onTap: () => context.push(Routes.faq(i)),
            ),
          ],
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          KsButton.outline(
            label: l.chatHelp,
            onPressed: () => openSupportChat(context, ref),
          ),
        ],
      ),
    );
  }
}

/// 206 Help – FAQ Answer (Figma 292:3642).
class FaqScreen extends ConsumerWidget {
  const FaqScreen({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final all = faqs(l);
    final (title, sections) = all[index.clamp(0, all.length - 1)];
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.faqTitle),
      body: ListView(
        padding: _pad,
        children: [
          Text(title, style: AppTypography.headingBold20.normal),
          for (final (role, text) in sections) ...[
            const SizedBox(height: AppSpacing.block),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.bgSubtle,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (role != null) ...[
                    Text(role, style: AppTypography.bodyMediumStrong.normal),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  Text(
                    text,
                    style: AppTypography.bodySmall.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.block),
          Text(l.faqUseful, style: AppTypography.bodySmallStrong.normal),
          const SizedBox(height: AppSpacing.block),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              KsPill(
                label: l.faqYes,
                selected: false,
                onTap: () => KsToast.show(context, l.faqThanks),
              ),
              KsPill(
                label: l.faqNo,
                selected: false,
                onTap: () => KsToast.show(context, l.faqThanks),
              ),
            ],
          ),
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          KsButton.outline(
            label: l.chatHelp,
            onPressed: () => openSupportChat(context, ref),
          ),
        ],
      ),
    );
  }
}
