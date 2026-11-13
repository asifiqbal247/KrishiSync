import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

/// Onboarding "Dots" (292:2575): active = 18×6 image pill, inactive = 6×6
/// white with 2px strong border, radius 3, gap 6.
class KsPageDots extends StatelessWidget {
  const KsPageDots({super.key, required this.count, required this.index});

  final int count;
  final int index;

  static const _h = 6.0;
  static const _activeW = 18.0;
  static const _r = 3.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.label),
          i == index
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(_r),
                  child: Image.asset(AppImages.dotActive,
                      width: _activeW, height: _h, fit: BoxFit.cover),
                )
              : Container(
                  width: _h,
                  height: _h,
                  decoration: BoxDecoration(
                    color: AppColors.bgPage,
                    borderRadius: BorderRadius.circular(_r),
                    border: Border.all(color: AppColors.borderStrong, width: 2),
                  ),
                ),
        ],
      ],
    );
  }
}
