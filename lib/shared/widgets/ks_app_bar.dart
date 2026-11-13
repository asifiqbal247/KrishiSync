import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';

/// HF/App Bar (292:32): 56 high, 44×44 back button, gap 12,
/// title Hind Siliguri SemiBold 18, right padding 16.
class KsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KsAppBar({
    super.key,
    this.title,
    this.showBack = true,
    this.onBack,
    this.actions = const [],
  });

  final String? title;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgPage,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: AppSizes.appBarHeight,
          child: Padding(
            padding: EdgeInsets.only(
              left: showBack ? 0 : AppSpacing.screen,
              right: AppSpacing.screen,
            ),
            child: Row(
              children: [
                if (showBack) ...[
                  _BackButton(onTap: onBack ?? () => Navigator.maybePop(context)),
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: title == null
                      ? const SizedBox.shrink()
                      : Text(
                          title!,
                          style: AppTypography.h3.normal,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
                ...actions,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: MaterialLocalizations.of(context).backButtonTooltip,
      child: InkResponse(
        onTap: onTap,
        radius: AppSizes.backButton / 2,
        child: SvgPicture.asset(
          AppIcons.appBack,
          width: AppSizes.backButton,
          height: AppSizes.backButton,
          colorFilter:
              const ColorFilter.mode(AppColors.iconPrimary, BlendMode.srcIn),
        ),
      ),
    );
  }
}
