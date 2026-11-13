import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';

/// Selectable card used by Language Selection (02) and Role Selection (14).
/// Selected: 2px brand border. Default: 1px default border. Radius 12, p 16,
/// gap 14, 44px image (radius 10), title SemiBold 16, subtitle Regular 13,
/// 20px radio dot.
class KsOptionCard extends StatelessWidget {
  const KsOptionCard({
    super.key,
    required this.image,
    required this.title,
    this.subtitle,
    required this.selected,
    required this.onTap,
    this.imageSize = _imageSize,
    this.verticalPadding = AppSpacing.lg,
    this.titleStyleSmall = false,
  });

  final ImageProvider image;
  final String title;
  final String? subtitle;

  /// 44 (02, 14) or 36 (78 transport options).
  final double imageSize;
  final double verticalPadding;

  /// 78 uses SemiBold 15 titles instead of 16.
  final bool titleStyleSmall;
  final bool selected;
  final VoidCallback onTap;

  static const _imageSize = 44.0;
  static const _imageRadius = 10.0;
  static const _radio = 20.0;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.lg);
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: AppColors.bgPage,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            // Selected border is 2px: shrink padding by 1 to keep the size.
            padding: EdgeInsets.symmetric(
              horizontal: selected ? AppSpacing.lg - 1 : AppSpacing.lg,
              vertical: selected ? verticalPadding - 1 : verticalPadding,
            ),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color:
                    selected ? AppColors.borderBrand : AppColors.borderDefault,
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(_imageRadius),
                  child: Image(
                    image: image,
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: AppSpacing.block),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title,
                          style: titleStyleSmall
                              ? AppTypography.labelMedium15.normal
                              : AppTypography.labelButton.normal,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.s2xs),
                        Text(subtitle!,
                            style: AppTypography.bodySmall.normal
                                .withColor(AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.block),
                Container(
                  width: _radio,
                  height: _radio,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.bgBrand : AppColors.bgMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
