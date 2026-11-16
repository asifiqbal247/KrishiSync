import 'dart:async';
import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:record/record.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_icon.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_toast.dart';

/// Longest voice message; recording stops and sends at this point.
/// Firestore rules allow the same maximum.
const maxVoiceSeconds = 60;

/// "0:15" in the app's digits.
String voiceLen(BuildContext context, int seconds) => Fmt.digits(
  context,
  '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}',
);

/// V2 Voice Message (Figma 527:9301): records while the sheet is open.
/// Returns the audio file and its length, or null when cancelled.
Future<(File, int)?> recordVoice(BuildContext context) async {
  final l = AppLocalizations.of(context);
  final rec = AudioRecorder();
  try {
    if (!await rec.hasPermission()) {
      if (context.mounted) KsToast.show(context, l.micDenied);
      return null;
    }
    if (!context.mounted) return null;
    return await showModalBottomSheet<(File, int)>(
      context: context,
      builder: (_) => _VoiceSheet(rec),
    );
  } finally {
    await rec.dispose(); // also stops a recording left running
  }
}

class _VoiceSheet extends StatefulWidget {
  const _VoiceSheet(this.rec);
  final AudioRecorder rec;

  @override
  State<_VoiceSheet> createState() => _VoiceSheetState();
}

class _VoiceSheetState extends State<_VoiceSheet> {
  Timer? _tick;
  int _sec = 0;
  bool _done = false;

  // The recording is streamed as plain AAC (ADTS) into a .aac file.
  // Saving straight to a file gives an MP4 container (.m4a), which
  // Cloudinary reads as "mp4"; the audio preset allows aac/m4a/mp3 only.
  File? _file;
  IOSink? _sink;
  final _ended = Completer<void>();

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      _file = File(
        '${Directory.systemTemp.path}/'
        'ks_voice_${DateTime.now().millisecondsSinceEpoch}.aac',
      );
      _sink = _file!.openWrite();
      // Small mono AAC: ~30 KB per 10 seconds.
      final stream = await widget.rec.startStream(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 24000,
          sampleRate: 16000,
          numChannels: 1,
        ),
      );
      stream.listen(
        _sink!.add,
        onDone: () {
          if (!_ended.isCompleted) _ended.complete();
        },
      );
    } catch (_) {
      await _closeFile(delete: true);
      if (mounted) Navigator.pop(context);
      return;
    }
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _sec++);
      if (_sec >= maxVoiceSeconds) _send();
    });
  }

  Future<void> _closeFile({bool delete = false}) async {
    final sink = _sink;
    _sink = null;
    try {
      await sink?.flush();
      await sink?.close();
      if (delete) await _file?.delete();
    } catch (_) {}
  }

  Future<void> _send() async {
    if (_done) return;
    _done = true;
    _tick?.cancel();
    await widget.rec.stop();
    // Last audio chunks arrive just after stop.
    await _ended.future.timeout(const Duration(seconds: 2), onTimeout: () {});
    await _closeFile();
    if (!mounted) return;
    final f = _file;
    Navigator.pop(context, f == null || _sec < 1 ? null : (f, _sec));
  }

  Future<void> _cancel() async {
    if (_done) return;
    _done = true;
    _tick?.cancel();
    await widget.rec.cancel();
    await _closeFile(delete: true);
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _tick?.cancel();
    if (!_done) _closeFile(delete: true); // sheet dragged away
    super.dispose();
  }

  Widget _icon(String icon) => ColoredBox(
    color: AppColors.bgSubtle,
    child: Center(child: AppIcon(icon, color: AppColors.iconBrand)),
  );

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screen),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l.voiceRecording(voiceLen(context, _sec)),
              style: AppTypography.headingBold20.normal,
            ),
            const SizedBox(height: AppSpacing.block),
            KsListItem(
              thumb: _icon(AppIcons.send),
              title: l.voiceSend,
              subtitle: l.voiceSendSub,
              showChevron: false,
              onTap: _send,
            ),
            const SizedBox(height: AppSpacing.md),
            KsListItem(
              thumb: _icon(AppIcons.close),
              title: l.voiceCancel,
              subtitle: l.voiceCancelSub,
              showChevron: false,
              onTap: _cancel,
            ),
          ],
        ),
      ),
    );
  }
}
