import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';

/// HF/Button Type=Pill (315:162 / 315:166), Size M: 44 high, radius 22, px 16.
/// Selected: brand fill, white SemiBold 14. Default: subtle fill, brand
/// Medium 14.
class KsPill extends StatelessWidget {
  const KsPill({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.chip);
    return Material(
      color: selected ? AppColors.bgBrand : AppColors.bgSubtle,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          height: AppSizes.chipMinHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          alignment: Alignment.center,
          child: Text(
            label,
            style: selected
                ? AppTypography.bodyMediumStrong.normal
                    .withColor(AppColors.textOnBrand)
                : AppTypography.bodyMediumEmphasis.normal
                    .withColor(AppColors.textBrand),
          ),
        ),
      ),
    );
  }
}
