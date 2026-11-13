import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import 'app_icon.dart';

class KsNavItem {
  const KsNavItem({required this.label, required this.icon});
  final String label;

  /// Builds the 24px icon for active / inactive state.
  final Widget Function(bool active) icon;

  /// Figma nav-on/* and nav-off/* image pair.
  factory KsNavItem.images(String label, String on, String off) => KsNavItem(
        label: label,
        icon: (a) => Image.asset(a ? on : off,
            width: AppSizes.icon, height: AppSizes.icon, fit: BoxFit.contain),
      );

  /// Stroke SVG icon (brand when active, secondary when not) — used for
  /// Admin/Moderator, which have no Figma nav art.
  factory KsNavItem.svg(String label, String asset) => KsNavItem(
        label: label,
        icon: (a) => AppIcon(asset,
            color: a ? AppColors.iconBrand : AppColors.textSecondary),
      );
}

/// HF/Bottom Nav (292:225 / 292:246 / 292:263): 72 high, white, top border,
/// items aligned to bottom with pb 8, gap 4, label 11 (active Bold brand,
/// inactive Medium secondary). Optional raised centre FAB: 56px brand circle,
/// 4px white border, Bold 28 "+".
class KsBottomNav extends StatelessWidget {
  const KsBottomNav({
    super.key,
    required this.items,
    required this.index,
    required this.onTap,
    this.fabLabel,
    this.onFab,
    this.fabIcon,
  }) : assert(fabLabel == null || items.length == 4);

  final List<KsNavItem> items;
  final int index;
  final ValueChanged<int> onTap;
  final String? fabLabel;
  final VoidCallback? onFab;

  /// Widget inside the FAB; defaults to the Figma "+".
  final Widget? fabIcon;

  static const _fabBorder = 4.0;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final cells = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (fabLabel != null && i == 2) cells.add(_fab());
      cells.add(_tab(i));
    }
    return Container(
      height: AppSizes.bottomNavHeight + bottomInset,
      padding: EdgeInsets.only(bottom: AppSpacing.sm + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.bgPage,
        border: Border(top: BorderSide(color: AppColors.borderDefault)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: cells,
      ),
    );
  }

  Widget _tab(int i) {
    final active = i == index;
    return Expanded(
      child: InkResponse(
        onTap: () => onTap(i),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            items[i].icon(active),
            const SizedBox(height: AppSpacing.xs),
            Text(
              items[i].label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: active
                  ? AppTypography.navActive.normal
                      .withColor(AppColors.textBrand)
                  : AppTypography.labelSmall.normal
                      .withColor(AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fab() {
    return Expanded(
      child: OverflowBox(
        maxHeight: double.infinity,
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: onFab,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSizes.fab,
                height: AppSizes.fab,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.bgBrand,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.bgPage, width: _fabBorder),
                ),
                child: fabIcon ??
                    Text('+',
                        style: AppTypography.display28.normal
                            .withColor(AppColors.textOnBrand)),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(fabLabel!,
                  style: AppTypography.labelSmall.normal
                      .withColor(AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
