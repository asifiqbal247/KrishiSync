import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';

/// HF/Toast (292:242): brand fill, radius 12, pl 16 / pr 12 / py 12, gap 12,
/// 22px check icon, Medium 14 white text, optional SemiBold 14 action.
/// "Short non-blocking feedback at the bottom (auto-hides after 3s)."
abstract final class KsToast {
  static const _iconSize = 22.0;
  static const _duration = Duration(seconds: 3);
  static OverlayEntry? _current;
  static Timer? _timer;

  static void show(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _hide();
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    final entry = OverlayEntry(
      builder: (ctx) => Positioned(
        left: AppSpacing.screen,
        right: AppSpacing.screen,
        bottom: MediaQuery.of(ctx).padding.bottom + AppSpacing.lg,
        child: Material(
          color: AppColors.bgBrand,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.md, AppSpacing.md, AppSpacing.md),
            child: Row(
              children: [
                Image.asset(AppImages.toastCheck,
                    width: _iconSize, height: _iconSize),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(message,
                      style: AppTypography.bodyMediumEmphasis.normal
                          .withColor(AppColors.textOnBrand)),
                ),
                if (actionLabel != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  GestureDetector(
                    onTap: () {
                      _hide();
                      onAction?.call();
                    },
                    child: Text(actionLabel,
                        style: AppTypography.bodyMediumStrong.normal
                            .withColor(AppColors.textOnBrand)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
    _current = entry;
    overlay.insert(entry);
    _timer = Timer(_duration, _hide);
  }

  /// Toast for features planned for a later version (e.g. voice search).
  static void comingSoon(BuildContext context) =>
      show(context, AppLocalizations.of(context).comingSoon);

  static void _hide() {
    _timer?.cancel();
    _timer = null;
    _current?.remove();
    _current = null;
  }
}
