import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import 'app_icon.dart';
import 'ks_toast.dart';

/// HF/Search Bar (292:59): surface fill, radius 16, h 48, pl 16 pr 8, gap 8,
/// 20px search icon (border/strong), Regular 14 text, 32px white mic circle
/// with 16px brand mic.
class KsSearchBar extends StatelessWidget {
  const KsSearchBar({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onMic,
    this.readOnly = false,
    this.autofocus = false,
  });

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// When set (and [readOnly]), the whole bar acts as a button.
  final VoidCallback? onTap;
  final VoidCallback? onMic;
  final bool readOnly;
  final bool autofocus;

  static const _searchIcon = 20.0;
  static const _micBox = 32.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.searchHeight,
      padding:
          const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        children: [
          const AppIcon(AppIcons.search,
              size: _searchIcon, color: AppColors.borderStrong),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              onTap: onTap,
              readOnly: readOnly,
              autofocus: autofocus,
              textInputAction: TextInputAction.search,
              style: AppTypography.bodyMedium.normal,
              cursorColor: AppColors.bgBrand,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: AppTypography.bodyMedium.normal
                    .withColor(AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Material(
            color: AppColors.bgPage,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              // Voice search is planned for a later version.
              onTap: onMic ?? () => KsToast.comingSoon(context),
              child: const SizedBox.square(
                dimension: _micBox,
                child: Center(
                  child: AppIcon(AppIcons.mic,
                      size: AppSizes.iconXs, color: AppColors.iconBrand),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
