import 'package:material_ui/material_ui.dart';

import '../../core/l10n/formatters.dart';
import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import 'app_icon.dart';
import 'ks_button.dart';

/// HF/Section Header (292:82): h 28, SemiBold 16 title, underlined
/// Medium 13 brand "সব দেখুন" link.
class KsSectionHeader extends StatelessWidget {
  const KsSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.sectionHeader,
      child: Row(
        children: [
          Expanded(
            child: Text(title,
                style: AppTypography.labelButton.normal,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: AppTypography.bodySmallEmphasis.normal.copyWith(
                  color: AppColors.textBrand,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.textBrand,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// HF/Stat Card (292:77): subtle fill, 1px green/100 border (in screens),
/// radius 16, p 12, gap 4, Regular 12 label, Bold 18 brand value,
/// 16px brand chevron top-right.
class KsStatCard extends StatelessWidget {
  const KsStatCard({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  static const _arrowInset = 11.0;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.xl);
    return Material(
      color: AppColors.bgSubtle,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: AppColors.green100),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: AppSizes.iconXs + AppSpacing.xs),
                    child: Text(label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.normal
                            .withColor(AppColors.textSecondary)),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(value,
                      style: AppTypography.bold18.normal
                          .withColor(AppColors.textBrand)),
                ],
              ),
            ),
            const Positioned(
              top: _arrowInset,
              right: _arrowInset,
              child: AppIcon(AppIcons.chevronRight,
                  size: AppSizes.iconXs, color: AppColors.iconBrand),
            ),
          ],
        ),
      ),
    );
  }
}

/// HF/Action Tile (292:74): radius 18, p 14, gap 8, 44px round icon wrap with
/// 26px icon, 18px arrow, SemiBold 15 title, Regular 12 hint.
/// [primary] = brand fill, white text, white icon wrap (main role action).
class KsActionTile extends StatelessWidget {
  const KsActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.hint,
    required this.onTap,
    this.primary = false,
  });

  final String icon; // image asset (glyph png/webp)
  final String title;
  final String hint;
  final VoidCallback onTap;
  final bool primary;

  static const _wrap = 44.0;
  static const _icon = 26.0;
  static const _pad = 14.0;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.tile);
    final fg = primary ? AppColors.textOnBrand : AppColors.textPrimary;
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: primary ? AppShadows.brandTile : AppShadows.tile,
      ),
      child: Material(
        color: primary ? AppColors.bgBrand : AppColors.bgPage,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: primary
              ? BorderSide.none
              : const BorderSide(color: AppColors.green100),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.all(_pad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: _wrap,
                      height: _wrap,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            primary ? AppColors.bgPage : AppColors.bgSubtle,
                        borderRadius:
                            BorderRadius.circular(AppRadius.actionIcon),
                      ),
                      child: Image.asset(icon,
                          width: _icon, height: _icon, fit: BoxFit.contain),
                    ),
                    const Spacer(),
                    AppIcon(AppIcons.chevronRight,
                        size: AppSizes.iconSm,
                        color: primary
                            ? AppColors.iconOnBrand
                            : AppColors.iconBrand),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(title,
                    style: AppTypography.labelMedium15.normal.withColor(fg)),
                const SizedBox(height: AppSpacing.sm),
                Opacity(
                  opacity: primary ? 0.9 : 1,
                  child: Text(hint,
                      style: AppTypography.caption.normal.withColor(primary
                          ? AppColors.textOnBrand
                          : AppColors.textSecondary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "Info" box used in 20 / 23: 1px default border, radius 12, px 14 py 12,
/// rows gap 10, label Regular 13 secondary, value Medium 14.
class KsInfoCard extends StatelessWidget {
  const KsInfoCard({super.key, required this.rows});
  final List<(String, String)> rows;

  static const _px = 14.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(horizontal: _px, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.x10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rows[i].$1,
                    style: AppTypography.bodySmall.normal
                        .withColor(AppColors.textSecondary)),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(rows[i].$2,
                      textAlign: TextAlign.right,
                      style: AppTypography.bodyMediumEmphasis.normal),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Stepper in 18–20: 3 steps, 28px circles (brand when reached, muted
/// otherwise), SemiBold 13 number, Medium 11 label.
class KsStepper extends StatelessWidget {
  const KsStepper({super.key, required this.labels, required this.current});
  final List<String> labels;
  final int current; // 1-based

  static const _dot = 28.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < labels.length; i++)
          Expanded(
            child: Column(
              children: [
                Container(
                  width: _dot,
                  height: _dot,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < current ? AppColors.bgBrand : AppColors.bgMuted,
                  ),
                  child: Text(
                    Fmt.digits(context, '${i + 1}'),
                    style: AppTypography.bodySmallStrong.normal.withColor(
                        i < current
                            ? AppColors.textOnBrand
                            : AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: AppTypography.labelSmall.normal.withColor(i < current
                      ? AppColors.textPrimary
                      : AppColors.textSecondary),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// HF/Modal success dialog (e.g. 21, 26, 209–211): 312 wide, radius 24, p 24,
/// gap 12, 64px icon, Bold 18 title, Regular 14 secondary body, 264 button.
Future<void> showKsSuccessModal(
  BuildContext context, {
  required String title,
  required String body,
  required String cta,
  required VoidCallback onCta,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.overlayScrim,
    pageBuilder: (ctx, _, _) => Center(
      child: Container(
        width: AppSizes.modalWidth,
        padding: const EdgeInsets.all(AppSpacing.s2xl),
        decoration: BoxDecoration(
          color: AppColors.bgPage,
          borderRadius: BorderRadius.circular(AppRadius.modal),
          boxShadow: AppShadows.modal,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppImages.successCheck,
                  width: AppSizes.modalIcon, height: AppSizes.modalIcon),
              const SizedBox(height: AppSpacing.md),
              Text(title,
                  textAlign: TextAlign.center,
                  style: AppTypography.bold18.normal),
              const SizedBox(height: AppSpacing.md),
              Text(body,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.normal
                      .withColor(AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.md),
              KsButton(
                label: cta,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  onCta();
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
