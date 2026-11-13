import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import 'ks_button.dart';

/// Common layout of the state screens (Figma 41 / 212 / 214):
/// centered column, gap 14, padding 8/16/16, spacers above and below.
class _StateLayout extends StatelessWidget {
  const _StateLayout({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.contentTop,
          AppSpacing.screen,
          AppSpacing.lg,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: (c.maxHeight - AppSpacing.contentTop - AppSpacing.lg)
                .clamp(0, double.infinity),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.block),
                children[i],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

Widget _circle(String asset) => ClipOval(
  child: Image.asset(
    asset,
    width: _stateCircle,
    height: _stateCircle,
    fit: BoxFit.cover,
  ),
);

const _stateCircle = 128.0;
const _emptyImageH = 160.0;

/// 41 Empty State (292:409): 160-high rounded image, Bold 20 title,
/// Regular 14 secondary body, primary CTA.
class KsEmptyState extends StatelessWidget {
  const KsEmptyState({
    super.key,
    required this.title,
    required this.body,
    this.ctaLabel,
    this.onCta,
    this.image = AppImages.stateEmpty,
  });

  final String title;
  final String body;
  final String? ctaLabel;
  final VoidCallback? onCta;
  final String image;

  @override
  Widget build(BuildContext context) {
    return _StateLayout(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Image.asset(
            image,
            width: double.infinity,
            height: _emptyImageH,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTypography.headingBold20.normal,
        ),
        Text(
          body,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.normal.withColor(
            AppColors.textSecondary,
          ),
        ),
        if (ctaLabel != null) KsButton(label: ctaLabel!, onPressed: onCta),
      ],
    );
  }
}

/// 212 Error Screen (292:389): red warning circle, Bold 22 title,
/// body, Warning "retry" button, optional Outline "get help".
class KsErrorState extends StatelessWidget {
  const KsErrorState({super.key, required this.onRetry, this.onHelp});

  final VoidCallback onRetry;
  final VoidCallback? onHelp;

  /// Shows 214 No Internet when [error] is a connection problem,
  /// otherwise 212 Error Screen.
  static Widget from(
    Object? error, {
    required VoidCallback onRetry,
    VoidCallback? onHelp,
  }) {
    final offline =
        error is SocketException ||
        (error is FirebaseException && error.code == 'unavailable');
    return offline
        ? KsOfflineState(onRetry: onRetry)
        : KsErrorState(onRetry: onRetry, onHelp: onHelp);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _StateLayout(
      children: [
        _circle(AppImages.stateError),
        Text(
          l.stateErrorTitle,
          textAlign: TextAlign.center,
          style: AppTypography.headingBold22.normal,
        ),
        Text(
          l.stateErrorBody,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.normal.withColor(
            AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        KsButton.warning(label: l.commonRetry, onPressed: onRetry),
        if (onHelp != null)
          KsButton.outline(label: l.stateGetHelp, onPressed: onHelp),
      ],
    );
  }
}

/// 214 No Internet (292:420): green globe circle, Bold 20 title,
/// body, Warning "retry" button.
class KsOfflineState extends StatelessWidget {
  const KsOfflineState({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _StateLayout(
      children: [
        _circle(AppImages.stateOffline),
        Text(
          l.errorNetwork,
          textAlign: TextAlign.center,
          style: AppTypography.headingBold20.normal,
        ),
        Text(
          l.stateOfflineBody,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.normal.withColor(
            AppColors.textSecondary,
          ),
        ),
        KsButton.warning(label: l.commonRetry, onPressed: onRetry),
      ],
    );
  }
}
