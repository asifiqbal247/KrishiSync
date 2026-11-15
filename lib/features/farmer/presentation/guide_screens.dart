import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';

const _pad = EdgeInsets.fromLTRB(
    AppSpacing.screen, AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg);

/// Farming tip pages behind the home Tip Cards (345:6251): better price,
/// packaging, grading. Audio is Tier C; the tip is shown as text.
class TipScreen extends StatelessWidget {
  const TipScreen({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tips = [
      (l.tipBetterPrice, [l.tipPriceBody1, l.tipPriceBody2, l.tipPriceBody3]),
      (l.tipPackaging, [l.tipPackBody1, l.tipPackBody2, l.tipPackBody3]),
      (l.tipGrading, [l.tipGradeBody1, l.tipGradeBody2, l.tipGradeBody3]),
    ];
    final (title, points) = tips[index.clamp(0, tips.length - 1)];
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.tipTitle),
      body: ListView(
        padding: _pad,
        children: [
          Text(title, style: AppTypography.headingBold20.normal),
          for (final p in points) ...[
            const SizedBox(height: AppSpacing.block),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.bgSubtle,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Text(p, style: AppTypography.bodyMedium.copyWith(height: 1.5)),
            ),
          ],
        ],
      ),
    );
  }
}

/// 36 Global Buyers (Figma 292:981). No foreign-buyer data source in v1, so
/// the list is empty and points to the export guide.
class GlobalBuyersScreen extends StatelessWidget {
  const GlobalBuyersScreen({super.key});

  static const _imgH = 120.0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.globalBuyersTitle),
      body: ListView(
        padding: _pad,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Image.asset(AppImages.port,
                height: _imgH, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: AppSpacing.block),
          Text(l.globalBuyersIntro,
              style: AppTypography.bodySmall.normal
                  .withColor(AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.block),
          KsNoteBoxLite(text: l.noExportDemand),
          const SizedBox(
              height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
          KsButton.outline(
              label: l.seeExportGuide,
              onPressed: () => context.push(Routes.exportGuide)),
        ],
      ),
    );
  }
}

/// Plain bordered info text (used where a list would be empty).
class KsNoteBoxLite extends StatelessWidget {
  const KsNoteBoxLite({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Text(text,
            style: AppTypography.bodyMedium.normal
                .withColor(AppColors.textSecondary)),
      );
}

/// 37 Export Guide & Documents (Figma 292:991). Step 1 is ticked from the
/// farmer's real verification status.
class ExportGuideScreen extends ConsumerWidget {
  const ExportGuideScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    final verified = me?.verification == VerificationStatus.verified;
    // Document viewer (207) is Tier C.
    void soon() => KsToast.comingSoon(context);
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.exportGuideTitle),
      body: ListView(
        padding: _pad,
        children: [
          Text(l.exportSteps, style: AppTypography.bodyMediumStrong.normal),
          const SizedBox(height: AppSpacing.block),
          KsTimelineItem(
            title: l.exStep1,
            subtitle: l.exStep1Sub,
            done: verified,
            onTap: verified ? null : () => context.push(Routes.verification),
          ),
          for (final (t, s) in [
            (l.exStep2, l.exStep2Sub),
            (l.exStep3, l.exStep3Sub),
            (l.exStep4, l.exStep4Sub),
          ]) ...[
            const SizedBox(height: AppSpacing.block),
            KsTimelineItem(title: t, subtitle: s, done: false),
          ],
          const SizedBox(height: AppSpacing.block),
          KsSectionHeader(title: l.exDocs),
          const SizedBox(height: AppSpacing.block),
          KsListItem(title: l.exDoc1, subtitle: l.exDoc1Sub, onTap: soon),
          const SizedBox(height: AppSpacing.block),
          KsListItem(title: l.exDoc2, subtitle: l.exDoc2Sub, onTap: soon),
        ],
      ),
    );
  }
}
