import 'package:material_ui/material_ui.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import 'app_icon.dart';
import 'ks_list_item.dart';
import 'ks_toast.dart';

/// V1 Voice Search (Figma 527:9277): listens in the app's language
/// (bn-BD / en-US) with the phone's speech service and returns the words,
/// or null when nothing was heard / cancelled.
Future<String?> listenForSearch(BuildContext context) async {
  final l = AppLocalizations.of(context);
  final stt = SpeechToText();
  var ok = false;
  try {
    ok = await stt.initialize();
  } catch (_) {}
  if (!context.mounted) return null;
  if (!ok) {
    KsToast.show(context, l.voiceSearchUnavailable);
    return null;
  }
  final lang = Localizations.localeOf(context).languageCode;
  final words = await showModalBottomSheet<String>(
    context: context,
    builder: (_) => _ListenSheet(stt, lang == 'bn' ? 'bn_BD' : 'en_US'),
  );
  await stt.cancel();
  final w = words?.trim() ?? '';
  return w.isEmpty ? null : w;
}

class _ListenSheet extends StatefulWidget {
  const _ListenSheet(this.stt, this.localeId);
  final SpeechToText stt;
  final String localeId;

  @override
  State<_ListenSheet> createState() => _ListenSheetState();
}

class _ListenSheetState extends State<_ListenSheet> {
  static const _listenFor = Duration(seconds: 15);
  static const _pauseFor = Duration(seconds: 3);
  String _words = '';
  bool _closed = false;

  @override
  void initState() {
    super.initState();
    widget.stt.listen(
      onResult: _onResult,
      listenOptions: SpeechListenOptions(
        localeId: widget.localeId,
        listenFor: _listenFor,
        pauseFor: _pauseFor,
        partialResults: true,
      ),
    );
  }

  void _onResult(SpeechRecognitionResult r) {
    if (!mounted || _closed) return;
    setState(() => _words = r.recognizedWords);
    if (r.finalResult) _finish();
  }

  Future<void> _finish() async {
    if (_closed) return;
    _closed = true;
    await widget.stt.stop();
    if (mounted) Navigator.pop(context, _words);
  }

  Widget _mic() => const ColoredBox(
        color: AppColors.bgSubtle,
        child: Center(child: AppIcon(AppIcons.mic, color: AppColors.iconBrand)),
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
            Text(_words.isEmpty ? l.voiceSearchListening : _words,
                style: AppTypography.headingBold20.normal),
            const SizedBox(height: AppSpacing.block),
            KsListItem(
              thumb: _mic(),
              title: l.voiceSearchStop,
              subtitle: l.voiceSearchStopSub,
              showChevron: false,
              onTap: _finish,
            ),
            const SizedBox(height: AppSpacing.md),
            KsListItem(
              thumb: _mic(),
              title: l.voiceSearchExample,
              subtitle: l.voiceSearchExampleSub,
              showChevron: false,
            ),
          ],
        ),
      ),
    );
  }
}
