import 'package:material_ui/material_ui.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
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
/// (Bangla / English, if the phone's speech service has it) and returns
/// the words, or null when nothing was heard / cancelled. The caller puts
/// the words in the search field so the user can edit them first.
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
  final localeId = await _localeFor(stt, lang);
  if (!context.mounted) return null;
  final words = await showModalBottomSheet<String>(
    context: context,
    builder: (_) => _ListenSheet(stt, localeId),
  );
  await stt.cancel();
  final w = words?.trim() ?? '';
  if (w.isEmpty) {
    if (context.mounted && words != null) {
      KsToast.show(context, l.voiceSearchNoWords);
    }
    return null;
  }
  return w;
}

/// The phone's own id for the app language (e.g. "bn_BD", "bn_IN"), or
/// null to use the phone's default language when it has no such voice.
Future<String?> _localeFor(SpeechToText stt, String lang) async {
  try {
    final all = await stt.locales();
    final ids = [for (final x in all) x.localeId];
    final want = lang == 'bn' ? 'bn_BD' : 'en_US';
    if (ids.contains(want)) return want;
    for (final id in ids) {
      if (id.toLowerCase().startsWith(lang)) return id;
    }
    // Some phones list no locales but still understand the language.
    if (ids.isEmpty) return want;
  } catch (_) {}
  return null;
}

class _ListenSheet extends StatefulWidget {
  const _ListenSheet(this.stt, this.localeId);
  final SpeechToText stt;
  final String? localeId;

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
    // Without these the sheet would wait forever when the phone stops
    // listening on its own (silence, no match, no network).
    widget.stt.errorListener = _onError;
    widget.stt.statusListener = _onStatus;
    _listen();
  }

  Future<void> _listen() async {
    try {
      await widget.stt.listen(
        onResult: _onResult,
        listenOptions: SpeechListenOptions(
          localeId: widget.localeId,
          listenFor: _listenFor,
          pauseFor: _pauseFor,
          partialResults: true,
          cancelOnError: true,
          listenMode: ListenMode.search,
        ),
      );
    } catch (_) {
      _finish();
    }
  }

  @override
  void dispose() {
    widget.stt.errorListener = null;
    widget.stt.statusListener = null;
    super.dispose();
  }

  void _onResult(SpeechRecognitionResult r) {
    if (!mounted || _closed) return;
    setState(() => _words = r.recognizedWords);
    if (r.finalResult) _finish();
  }

  void _onError(SpeechRecognitionError e) => _finish();

  void _onStatus(String status) {
    if (status == SpeechToText.doneStatus) _finish();
  }

  Future<void> _finish() async {
    if (_closed) return;
    _closed = true;
    try {
      await widget.stt.stop();
    } catch (_) {}
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
