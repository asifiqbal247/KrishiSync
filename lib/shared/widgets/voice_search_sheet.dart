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
  // No Bluetooth: since the call SDK added the Bluetooth permission, the
  // plugin would otherwise listen through a paired headset / car kit
  // instead of the phone's mic (and ask for "Nearby devices").
  try {
    ok = await stt.initialize(options: [SpeechToText.androidNoBluetooth]);
  } catch (_) {}
  // Some phones hide their speech service from the normal lookup.
  if (!ok) {
    try {
      ok = await stt.initialize(
        options: [
          SpeechToText.androidNoBluetooth,
          SpeechToText.androidIntentLookup,
        ],
      );
    } catch (_) {}
  }
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

  /// Language the phone is asked for; null = the phone's own language.
  late String? _localeId = widget.localeId;
  bool _retried = false;

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
          localeId: _localeId,
          listenFor: _listenFor,
          pauseFor: _pauseFor,
          partialResults: true,
          cancelOnError: true,
          listenMode: ListenMode.search,
        ),
      );
      _restarting = false;
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

  void _onError(SpeechRecognitionError e) {
    // The phone's recognizer has no Bangla (or is busy): try once more in
    // the phone's own language before giving up.
    final retry = !_retried &&
        _words.isEmpty &&
        (e.errorMsg.contains('language') ||
            e.errorMsg == 'error_busy' ||
            e.errorMsg == 'error_client');
    if (retry && mounted && !_closed) {
      _retried = true;
      _restarting = true;
      _localeId = null;
      widget.stt.cancel().whenComplete(_listen);
      return;
    }
    _finish();
  }

  void _onStatus(String status) {
    // A retry is starting: ignore the "done" of the first attempt.
    if (status == SpeechToText.doneStatus && !_restarting) _finish();
  }

  /// True from the retry until its new listen has started.
  bool _restarting = false;

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
