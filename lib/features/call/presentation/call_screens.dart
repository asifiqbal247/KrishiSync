import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app/router.dart';
import '../../../core/config/app_secrets.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_icon.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../auth/data/user_repository.dart';
import '../data/call_repository.dart';

// Figma 218 Video Call (412:6167) sizes.
const _btn = 64.0;
const _btnIcon = 30.0;
const _speakerIcon = 26.0;
const _btnRowBottom = 46.0; // 800 − 754 (bottom of the labels)
const _topShadeH = 180.0;
const _bottomShadeH = 240.0;
const _selfW = 96.0;
const _selfH = 128.0;
const _selfIcon = 40.0;
const _selfBorder = 2.0;
const _selfBottom = 160.0; // 800 − 512 − 128
const _titleTop = 20.0; // 48 − 28 status bar
const _labelW = 80.0;

/// Starts an in-app call with [peerUid] (T8 toast, then 217). Voice calls
/// can turn the camera on later.
Future<void> startCall(
  BuildContext context,
  WidgetRef ref,
  String peerUid, {
  bool video = false,
}) async {
  final l = AppLocalizations.of(context);
  final me = ref.read(currentUserProvider).value;
  if (me == null) return;
  if (AppSecrets.agoraAppId.isEmpty) {
    KsToast.show(context, l.callNotReady);
    return;
  }
  final peer = await ref.read(userByIdProvider(peerUid).future);
  if (peer == null || !context.mounted) return;
  KsToast.show(context, l.callingToast(peer.name));
  if (!await Permission.microphone.request().isGranted) {
    if (context.mounted) KsToast.show(context, l.callNeedMic);
    return;
  }
  if (video && !await Permission.camera.request().isGranted) video = false;
  try {
    final id = await ref
        .read(callRepositoryProvider)
        .start(me, peer, video: video);
    if (context.mounted) await context.push(Routes.call(id));
  } catch (_) {
    if (context.mounted) KsToast.show(context, l.errorGeneric);
  }
}

/// 217–220 Video Call (Figma 412:6142…6217). Also the voice call: same
/// screen with the camera off and the other person's photo behind.
class CallScreen extends ConsumerStatefulWidget {
  const CallScreen({super.key, required this.callId});
  final String callId;

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  RtcEngine? _engine;
  int? _remoteUid;
  bool _remoteVideo = false;
  bool _camOn = false;
  bool _micOff = false;
  bool _speaker = false;
  bool _left = false;
  int _seconds = 0;
  Timer? _clock;
  Timer? _ringTimer;

  String get _id => widget.callId;
  String? get _me => ref.read(currentUserProvider).value?.uid;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final c = await ref.read(callProvider(_id).future);
    if (!mounted || c == null) return;
    _camOn = c.video && await Permission.camera.isGranted;
    _speaker = c.video;
    try {
      final e = createAgoraRtcEngine();
      _engine = e;
      await e.initialize(
        const RtcEngineContext(
          appId: AppSecrets.agoraAppId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );
      e.registerEventHandler(
        RtcEngineEventHandler(
          onUserJoined: (_, uid, _) {
            _ringTimer?.cancel();
            setState(() => _remoteUid = uid);
            _clock ??= Timer.periodic(
              const Duration(seconds: 1),
              (_) => setState(() => _seconds++),
            );
          },
          onUserOffline: (_, _, _) => _hangUp(),
          onRemoteVideoStateChanged: (_, _, state, _, _) => setState(
            () => _remoteVideo =
                state == RemoteVideoState.remoteVideoStateStarting ||
                state == RemoteVideoState.remoteVideoStateDecoding,
          ),
        ),
      );
      await e.enableVideo();
      await e.enableLocalVideo(_camOn);
      if (_camOn) await e.startPreview();
      await e.setDefaultAudioRouteToSpeakerphone(_speaker);
      await e.joinChannel(
        token: '', // Agora project in "Testing mode: APP ID"
        channelId: _id,
        uid: 0,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
          publishMicrophoneTrack: true,
          publishCameraTrack: true,
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,
        ),
      );
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted) KsToast.show(context, AppLocalizations.of(context).errorGeneric);
      await _hangUp();
      return;
    }
    // Caller: nobody answers in time → missed.
    if (c.callerId == _me && c.status == CallStatus.ringing) {
      _ringTimer = Timer(CallRepository.ringTimeout, () async {
        final now = ref.read(callProvider(_id)).value;
        if (now?.status != CallStatus.ringing) return;
        try {
          await ref.read(callRepositoryProvider).markMissed(now!);
        } catch (_) {}
      });
    }
  }

  /// End button / back / the other person left.
  Future<void> _hangUp() async {
    final c = ref.read(callProvider(_id)).value;
    if (c != null && !c.isOver) {
      final mine = c.callerId == _me;
      final s = c.status == CallStatus.ringing
          ? (mine ? CallStatus.cancelled : CallStatus.declined)
          : CallStatus.ended;
      try {
        await ref.read(callRepositoryProvider).setStatus(_id, s);
      } catch (_) {}
    }
    await _leave();
  }

  Future<void> _leave() async {
    if (_left) return;
    _left = true;
    _clock?.cancel();
    _ringTimer?.cancel();
    final e = _engine;
    _engine = null;
    if (e != null) {
      try {
        await e.leaveChannel();
        await e.release();
      } catch (_) {}
    }
    if (mounted && context.canPop()) context.pop();
  }

  @override
  void dispose() {
    _clock?.cancel();
    _ringTimer?.cancel();
    final e = _engine;
    if (!_left && e != null) {
      e.leaveChannel().then((_) => e.release()).catchError((_) {});
    }
    super.dispose();
  }

  Future<void> _toggleCamera() async {
    final e = _engine;
    if (e == null) return;
    if (!_camOn && !await Permission.camera.request().isGranted) return;
    final on = !_camOn;
    await e.enableLocalVideo(on);
    if (on) await e.startPreview();
    if (mounted) setState(() => _camOn = on);
  }

  Future<void> _toggleMic() async {
    await _engine?.muteLocalAudioStream(!_micOff);
    if (mounted) setState(() => _micOff = !_micOff);
  }

  Future<void> _toggleSpeaker() async {
    await _engine?.setEnableSpeakerphone(!_speaker);
    if (mounted) setState(() => _speaker = !_speaker);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final me = _me ?? '';
    final c = ref.watch(callProvider(_id)).value;
    ref.listen(callProvider(_id), (_, next) {
      final now = next.value;
      if (now == null || !now.isOver || _left) return;
      final msg = switch (now.status) {
        CallStatus.declined when now.callerId == me => l.callDeclined,
        CallStatus.missed when now.callerId == me => l.callNoAnswer,
        _ => l.callEnded,
      };
      KsToast.show(context, msg);
      _leave();
    });

    final String status;
    if (_remoteUid != null) {
      final t = Fmt.timer(context, _seconds);
      status = _camOn || _remoteVideo ? l.callVideoOn(t) : l.callVoiceOn(t);
    } else if (c?.status == CallStatus.ringing && c?.callerId == me) {
      status = l.callRinging;
    } else {
      status = l.callConnecting;
    }
    final e = _engine;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _hangUp();
      },
      child: _CallFrame(
        photoUrl: c?.peerPhoto(me),
        video: e != null && _remoteUid != null && _remoteVideo
            ? AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: e,
                  canvas: VideoCanvas(uid: _remoteUid),
                  connection: RtcConnection(channelId: _id),
                ),
              )
            : null,
        name: c?.peerName(me) ?? '',
        status: status,
        selfView: _SelfView(
          child: e != null && _camOn
              ? AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: e,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                )
              : null,
        ),
        buttons: [
          _CallButton(
            icon: AppIcons.callSpeaker,
            iconSize: _speakerIcon,
            label: l.callSpeaker,
            on: _speaker,
            onIcon: AppColors.callIconOn,
            onTap: _toggleSpeaker,
          ),
          _CallButton(
            icon: AppIcons.callCamera,
            label: l.callCamera,
            // "Off=হ্যাঁ": white button, red icon.
            on: !_camOn,
            onIcon: AppColors.callIconOff,
            onTap: _toggleCamera,
          ),
          _CallButton(
            icon: AppIcons.callMic,
            label: l.callMic,
            on: _micOff,
            onIcon: AppColors.callIconOff,
            onTap: _toggleMic,
          ),
          _CallButton(
            icon: AppIcons.callEnd,
            label: l.callEnd,
            fill: AppColors.callEnd,
            onTap: _hangUp,
          ),
        ],
      ),
    );
  }
}

/// Incoming call, in 217's style: caller photo behind, name, "কল আসছে…",
/// decline (red) and answer (green).
class IncomingCallScreen extends ConsumerStatefulWidget {
  const IncomingCallScreen({super.key, required this.callId});
  final String callId;

  @override
  ConsumerState<IncomingCallScreen> createState() => _IncomingState();
}

class _IncomingState extends ConsumerState<IncomingCallScreen> {
  bool _busy = false;

  Future<void> _answer() async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    if (!await Permission.microphone.request().isGranted) {
      if (mounted) {
        KsToast.show(context, l.callNeedMic);
        setState(() => _busy = false);
      }
      return;
    }
    final c = ref.read(callProvider(widget.callId)).value;
    if (c?.video ?? false) await Permission.camera.request();
    try {
      await ref
          .read(callRepositoryProvider)
          .setStatus(widget.callId, CallStatus.accepted);
      if (mounted) context.pushReplacement(Routes.call(widget.callId));
    } catch (_) {
      // Already cancelled / missed: the listener closes the screen.
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _decline() async {
    setState(() => _busy = true);
    try {
      await ref
          .read(callRepositoryProvider)
          .setStatus(widget.callId, CallStatus.declined);
    } catch (_) {}
    if (mounted && context.canPop()) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value?.uid ?? '';
    final c = ref.watch(callProvider(widget.callId)).value;
    ref.listen(callProvider(widget.callId), (_, next) {
      final now = next.value;
      if (_busy || now == null || now.status == CallStatus.ringing) return;
      if (now.status != CallStatus.accepted) {
        KsToast.show(context, l.callEnded);
        if (context.canPop()) context.pop();
      }
    });
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !_busy) _decline();
      },
      child: _CallFrame(
        photoUrl: c?.peerPhoto(me),
        name: c?.peerName(me) ?? '',
        status: (c?.video ?? false) ? l.callIncomingVideo : l.callIncoming,
        buttons: [
          _CallButton(
            icon: AppIcons.callEnd,
            label: l.callDecline,
            fill: AppColors.callEnd,
            onTap: _busy ? null : _decline,
          ),
          _CallButton(
            icon: AppIcons.phone,
            label: l.callAnswer,
            fill: AppColors.callAccept,
            onTap: _busy ? null : _answer,
          ),
        ],
      ),
    );
  }
}

/// 218's frame: full-bleed video or photo, top / bottom shades, name and
/// status at the top left, self view above the round buttons.
class _CallFrame extends StatelessWidget {
  const _CallFrame({
    required this.photoUrl,
    required this.name,
    required this.status,
    required this.buttons,
    this.video,
    this.selfView,
  });

  final String? photoUrl;
  final Widget? video;
  final String name;
  final String status;
  final Widget? selfView;
  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    final photo = photoUrl;
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: AppColors.callBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          ?video ??
              (photo == null || photo.isEmpty
                  ? null
                  : Image.network(
                      photo,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    )),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: _topShadeH,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.callShadeTop, AppColors.callShadeClear],
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: _bottomShadeH,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.callShadeClear, AppColors.callShadeBottom],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                _titleTop,
                AppSpacing.xl,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.headingBold22.normal.withColor(
                      AppColors.textOnImage,
                    ),
                  ),
                  Text(
                    status,
                    style: AppTypography.bodyMedium.normal.withColor(
                      AppColors.textOnImage,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (selfView != null)
            Positioned(
              right: AppSpacing.lg,
              bottom: _selfBottom + bottomPad,
              child: selfView!,
            ),
          Positioned(
            left: AppSpacing.s2xl - (_labelW - _btn) / 2,
            right: AppSpacing.s2xl - (_labelW - _btn) / 2,
            bottom: _btnRowBottom + bottomPad,
            child: Row(
              mainAxisAlignment: buttons.length > 2
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.spaceAround,
              children: buttons,
            ),
          ),
        ],
      ),
    );
  }
}

/// 96×128 self view: own camera, or the person icon when it is off.
class _SelfView extends StatelessWidget {
  const _SelfView({this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) => Container(
    width: _selfW,
    height: _selfH,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: AppColors.callBg,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      border: Border.all(color: AppColors.callSelfBorder, width: _selfBorder),
    ),
    alignment: Alignment.center,
    child:
        child ??
        const AppIcon(
          AppIcons.callSelf,
          size: _selfIcon,
          color: AppColors.callIcon,
        ),
  );
}

/// HF/Switch/218-* and call-speaker: 64px round button + Medium 12 label.
/// [on] = white button with [onIcon]; [fill] = solid end / answer button.
class _CallButton extends StatelessWidget {
  const _CallButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconSize = _btnIcon,
    this.on = false,
    this.onIcon = AppColors.callIcon,
    this.fill,
  });

  final String icon;
  final String label;
  final VoidCallback? onTap;
  final double iconSize;
  final bool on;
  final Color onIcon;
  final Color? fill;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: _labelW,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          label: label,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: _btn,
              height: _btn,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    fill ?? (on ? AppColors.callButtonOn : AppColors.callButton),
              ),
              child: AppIcon(
                icon,
                size: iconSize,
                color: fill == null && on ? onIcon : AppColors.callIcon,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.label),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.captionEmphasis.normal.withColor(
            AppColors.textOnImage,
          ),
        ),
      ],
    ),
  );
}
