import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';

enum KsButtonType { primary, secondary, outline, text }

/// HF/Button (315:170). Size L: 48 high, radius 14, px 24,
/// label Hind Siliguri SemiBold 16.
/// Primary: brand fill + coloured shadow. Text: brand, underlined.
class KsButton extends StatelessWidget {
  const KsButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = KsButtonType.primary,
    this.loading = false,
    this.expand = true,
  });

  const KsButton.outline({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.expand = true,
  }) : type = KsButtonType.outline;

  const KsButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.expand = true,
  }) : type = KsButtonType.secondary;

  const KsButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.expand = true,
  }) : type = KsButtonType.text;

  final String label;
  final VoidCallback? onPressed;
  final KsButtonType type;
  final bool loading;
  final bool expand;

  bool get _enabled => onPressed != null && !loading;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      KsButtonType.primary => _primary(),
      KsButtonType.secondary => _outline(fill: AppColors.bgSubtle, shadow: false),
      KsButtonType.outline => _outline(),
      KsButtonType.text => _text(),
    };
  }

  Widget _primary() {
    // While loading the button keeps its brand colour (spinner inside).
    final active = onPressed != null;
    final bg = active ? AppColors.bgBrand : AppColors.bgDisabled;
    final fg = _enabled ? AppColors.textOnBrand : AppColors.textDisabled;
    final radius = BorderRadius.circular(AppRadius.button);
    return Container(
      width: expand ? double.infinity : null,
      height: AppSizes.buttonL,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: active ? AppShadows.brandButton : null,
      ),
      child: Material(
        color: bg,
        borderRadius: radius,
        child: InkWell(
          onTap: _enabled ? onPressed : null,
          borderRadius: radius,
          highlightColor: AppColors.bgBrandPressed,
          splashColor: AppColors.bgBrandHover,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2xl),
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: AppColors.textOnBrand,
                      ),
                    )
                  : Text(label,
                      style: AppTypography.labelButton.normal.withColor(fg)),
            ),
          ),
        ),
      ),
    );
  }

  /// Button/Secondary (315:32): subtle fill, 1.5px brand border, no shadow.
  /// Button/Outline (315:50): white, 1.5px brand border, shadow
  /// 0 2 3 rgba(31,31,31,.06), brand SemiBold 16.
  Widget _outline({Color fill = AppColors.bgPage, bool shadow = true}) {
    final fg = _enabled ? AppColors.textBrand : AppColors.textDisabled;
    final radius = BorderRadius.circular(AppRadius.button);
    return Container(
      width: expand ? double.infinity : null,
      height: AppSizes.buttonL,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: _enabled && shadow ? AppShadows.outlineButton : null,
      ),
      child: Material(
        color: fill,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
              color: _enabled ? AppColors.borderBrand : AppColors.borderDefault,
              width: 1.5),
        ),
        child: InkWell(
          onTap: _enabled ? onPressed : null,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2xl),
            child: Center(
              child: Text(label,
                  style: AppTypography.labelButton.normal.withColor(fg)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _text() {
    final fg = _enabled ? AppColors.textBrand : AppColors.textDisabled;
    return SizedBox(
      width: expand ? double.infinity : null,
      height: AppSizes.buttonL,
      child: InkWell(
        onTap: _enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: Center(
          child: Text(
            label,
            style: AppTypography.labelButton.normal.copyWith(
              color: fg,
              decoration: TextDecoration.underline,
              decorationColor: fg,
            ),
          ),
        ),
      ),
    );
  }
}
