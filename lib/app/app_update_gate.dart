import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../shared/services/app_update_service.dart';
import '../shared/widgets/ks_dialogs.dart';
import '../shared/widgets/ks_toast.dart';
import 'router.dart';

/// Checks appConfig/android once per app start, after the splash, and shows
/// the update dialog when this phone has an older build. "Update" opens
/// the APK link in the browser (Android then asks to install).
class AppUpdateGate extends ConsumerStatefulWidget {
  const AppUpdateGate({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<AppUpdateGate> createState() => _AppUpdateGateState();
}

class _AppUpdateGateState extends ConsumerState<AppUpdateGate> {
  /// Let the first screen settle after the splash.
  static const _afterSplash = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    try {
      await ref.read(splashMinElapsedProvider.future);
      await Future<void>.delayed(_afterSplash);
      final update = await ref.read(appUpdateServiceProvider).check();
      if (update == null || !mounted) return;
      final ctx =
          ref.read(routerProvider).routerDelegate.navigatorKey.currentContext;
      if (ctx == null || !ctx.mounted) return;
      final l = AppLocalizations.of(ctx);
      final bn = Localizations.localeOf(ctx).languageCode == 'bn';
      final i = update.info;
      final notes = bn ? i.changelogBn : i.changelogEn;
      await showKsUpdate(
        ctx,
        title: l.updateTitle,
        body: [
          l.updateVersion(i.latestName),
          if (notes.trim().isNotEmpty) notes.trim(),
          if (update.force) l.updateRequired,
        ].join('\n\n'),
        updateLabel: l.updateNow,
        laterLabel: update.force ? null : l.updateLater,
        onUpdate: () async {
          final ok = await launchUrl(
            Uri.parse(i.apkUrl),
            mode: LaunchMode.externalApplication,
          );
          if (!ok && ctx.mounted) KsToast.show(ctx, l.updateOpenFailed);
        },
      );
    } catch (_) {
      // No internet or no config: just use the app.
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
