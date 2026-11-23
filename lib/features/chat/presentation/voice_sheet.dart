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
/// Bars in a voice message waveform (0–100 each), stored with the message.
const voiceWaveBars = 40;

/// A finished recording: the file, its length and its waveform.
typedef VoiceClip = ({File file, int seconds, List<int> wave});

Future<VoiceClip?> recordVoice(BuildContext context) async {
  final l = AppLocalizations.of(context);
  final rec = AudioRecorder();
  try {
    if (!await rec.hasPermission()) {
      if (context.mounted) KsToast.show(context, l.micDenied);
      return null;
    }
    if (!context.mounted) return null;
    return await showModalBottomSheet<VoiceClip>(
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
  StreamSubscription<Amplitude>? _ampSub;

  /// Loudness every 100 ms (0–100), shrunk to [voiceWaveBars] on send.
  final _levels = <int>[];
  static const _ampEvery = Duration(milliseconds: 100);

  /// dBFS at or below this counts as silence.
  static const _silentDb = -50.0;

  /// Less than this per second means nothing was really recorded.
  static const _minBytesPerSec = 1000;

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
      // Mono AAC at 44.1 kHz (every phone's encoder supports it; 16 kHz
      // gave silent / unplayable files on some phones): ~80 KB per 10 s.
      // The phone's own mic, no Bluetooth: since the call SDK added the
      // Bluetooth permission, the recorder would otherwise try a headset.
      final stream = await widget.rec.startStream(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 64000,
          sampleRate: 44100,
          numChannels: 1,
          androidConfig: AndroidRecordConfig(
            manageBluetooth: false,
            audioSource: AndroidAudioSource.mic,
          ),
        ),
      );
      _ampSub = widget.rec.onAmplitudeChanged(_ampEvery).listen((a) {
        final db = a.current.isFinite ? a.current : _silentDb;
        _levels.add(
          ((db - _silentDb) / -_silentDb * 100).round().clamp(0, 100),
        );
      });
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

  /// [_levels] averaged into [voiceWaveBars] bars.
  List<int> _wave() {
    if (_levels.isEmpty) return const [];
    return [
      for (var i = 0; i < voiceWaveBars; i++)
        () {
          final a = i * _levels.length ~/ voiceWaveBars;
          final b = ((i + 1) * _levels.length ~/ voiceWaveBars).clamp(
            a + 1,
            _levels.length,
          );
          final part = _levels.sublist(a.clamp(0, _levels.length - 1), b);
          return part.reduce((x, y) => x + y) ~/ part.length;
        }(),
    ];
  }

  Future<void> _closeFile({bool delete = false}) async {
    await _ampSub?.cancel();
    _ampSub = null;
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
    // Nothing really recorded (mic blocked / busy): say so, don't send.
    final size = f == null ? 0 : await f.length().catchError((_) => 0);
    if (!mounted) return;
    if (f == null || _sec < 1 || size < _sec * _minBytesPerSec) {
      if (_sec >= 1) {
        KsToast.show(context, AppLocalizations.of(context).voiceRecordFailed);
      }
      Navigator.pop(context);
      return;
    }
    Navigator.pop(context, (file: f, seconds: _sec, wave: _wave()));
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
