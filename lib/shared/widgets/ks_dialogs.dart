import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import 'app_icon.dart';
import 'ks_button.dart';

/// Confirm dialog (D1–D6, e.g. 292:3612): 312 wide, white, radius 16, p 24,
/// gap 12, shadow 0 8 24 rgba(0,0,0,.2); 40px alert icon; Bold 18 title;
/// Regular 14 body (line height 1.5); Secondary "no" + Destructive "yes".
/// Returns true when the destructive action is confirmed.
/// [positive]: safe step (no alert icon, brand "yes" button).
Future<bool> showKsConfirm(
  BuildContext context, {
  required String title,
  required String body,
  required String noLabel,
  required String yesLabel,
  bool positive = false,
}) async {
  final r = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: noLabel,
    barrierColor: AppColors.overlayScrim,
    pageBuilder: (ctx, _, _) => Center(
      child: Container(
        width: AppSizes.modalWidth,
        padding: const EdgeInsets.all(AppSpacing.s2xl),
        decoration: BoxDecoration(
          color: AppColors.bgPage,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppShadows.dialog,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!positive) ...[
                Image.asset(AppUi.alertIcon,
                    width: AppSizes.dialogIcon, height: AppSizes.dialogIcon),
                const SizedBox(height: AppSpacing.md),
              ],
              Text(title, style: AppTypography.bold18.normal),
              const SizedBox(height: AppSpacing.md),
              Text(body, style: AppTypography.bodyMedium.copyWith(height: 1.5)),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: KsButton.secondary(
                      compact: true,
                      label: noLabel,
                      onPressed: () => Navigator.of(ctx).pop(false),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: positive
                        ? KsButton(
                            compact: true,
                            label: yesLabel,
                            onPressed: () => Navigator.of(ctx).pop(true),
                          )
                        : KsButton.destructive(
                            compact: true,
                            label: yesLabel,
                            onPressed: () => Navigator.of(ctx).pop(true),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
  return r ?? false;
}

/// HF/Timeline Item (292:85): 20px dot (done = green check image, pending =
/// white circle with 2px border/strong), gap 12, SemiBold 14 title
/// (brand + underline when tappable), Regular 12 secondary sub.
class KsTimelineItem extends StatelessWidget {
  const KsTimelineItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.done,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final bool done;
  final VoidCallback? onTap;

  static const _dot = 20.0;

  @override
  Widget build(BuildContext context) {
    final link = onTap != null;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          done
              ? Image.asset(AppUi.timelineDone, width: _dot, height: _dot)
              : Container(
                  width: _dot,
                  height: _dot,
                  decoration: BoxDecoration(
                    color: AppColors.bgPage,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.borderStrong, width: 2),
                  ),
                ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMediumStrong.normal.copyWith(
                    color: link ? AppColors.textBrand : AppColors.textPrimary,
                    decoration: link ? TextDecoration.underline : null,
                    decorationColor: AppColors.textBrand,
                  ),
                ),
                const SizedBox(height: AppSpacing.s2xs),
                Text(subtitle,
                    style: AppTypography.caption.normal
                        .withColor(AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Info box like [KsInfoCard] but with free children (normal + link rows).
class KsInfoBox extends StatelessWidget {
  const KsInfoBox({super.key, required this.children});
  final List<Widget> children;

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
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.x10),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// Plain info row: Regular 13 secondary label | Medium 14 value.
class KsInfoRow extends StatelessWidget {
  const KsInfoRow(this.label, this.value, {super.key});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTypography.bodySmall.normal
                  .withColor(AppColors.textSecondary)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                style: AppTypography.bodyMediumEmphasis.normal),
          ),
        ],
      );
}

/// Info-card row that is tappable: label | brand value + 16px chevron
/// (e.g. "ক্রেতা" row in 25, "গাড়িতে লোড + আপনার টাকা" in 42).
class KsLinkRow extends StatelessWidget {
  const KsLinkRow({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSizes.chipMinHeight),
        child: Row(
          children: [
            Text(label,
                style: AppTypography.bodySmall.normal
                    .withColor(AppColors.textSecondary)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: AppTypography.bodyMediumEmphasis.normal
                      .withColor(AppColors.textBrand)),
            ),
            const SizedBox(width: AppSpacing.xs),
            const AppIcon(AppIcons.chevronRight,
                size: AppSizes.iconXs, color: AppColors.iconBrand),
          ],
        ),
      ),
    );
  }
}
