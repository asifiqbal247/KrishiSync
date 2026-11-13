import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import 'app_icon.dart';

/// HF/List Item (292:66): white card, 1px default border, radius 16, p 12,
/// gap 12, shadow 0 4 7 rgba(31,51,31,.08); 48px thumb (radius 12);
/// title SemiBold 15, subtitle Regular 13 secondary; trailing Medium 13;
/// chevron 18 brand.
/// [highlighted] = surface fill + 1.5px brand border (e.g. GPS card in 09).
class KsListItem extends StatelessWidget {
  const KsListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.thumb,
    this.trailingText,
    this.trailing,
    this.onTap,
    this.highlighted = false,
    this.showChevron = true,
    this.subtitleMaxLines = 2,
    this.badge,
    this.badgeColor = AppColors.bgSuccessSubtle,
    this.badgeTextColor = AppColors.textSuccess,
  });

  /// HF/List Item / Status (319:26) badge: px 10, py 3, radius 13,
  /// Medium 13, success colours by default.
  final String? badge;
  final Color badgeColor;
  final Color badgeTextColor;

  final String title;
  final String? subtitle;
  final Widget? thumb;
  final String? trailingText;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool highlighted;
  final bool showChevron;
  final int subtitleMaxLines;

  static const thumbSize = AppSizes.thumb;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.xl);
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: AppShadows.card,
      ),
      child: Material(
        color: highlighted ? AppColors.bgSurface : AppColors.bgPage,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: highlighted ? AppColors.borderBrand : AppColors.borderDefault,
            width: highlighted ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                if (thumb != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child: SizedBox.square(dimension: thumbSize, child: thumb),
                  ),
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title,
                          style: AppTypography.labelMedium15.normal,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.s2xs),
                        Text(subtitle!,
                            style: AppTypography.bodySmall.normal
                                .withColor(AppColors.textSecondary),
                            maxLines: subtitleMaxLines,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ],
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x10, vertical: AppSpacing.badgeV),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(AppRadius.badge),
                    ),
                    child: Text(badge!,
                        style: AppTypography.bodySmallEmphasis.normal
                            .withColor(badgeTextColor)),
                  ),
                ],
                if (trailingText != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  Text(trailingText!,
                      style: AppTypography.bodySmallEmphasis.normal),
                ],
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  trailing!,
                ],
                if (showChevron) ...[
                  const SizedBox(width: AppSpacing.md),
                  const AppIcon(AppIcons.chevronRight,
                      size: AppSizes.iconSm, color: AppColors.iconBrand),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
