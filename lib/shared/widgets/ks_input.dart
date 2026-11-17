import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import 'app_icon.dart';

/// HF/Input label: Hind Siliguri Medium 14, primary.
class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;
  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppTypography.bodyMediumEmphasis.normal);
}

BoxDecoration _fieldBox({bool focused = false, bool error = false}) =>
    BoxDecoration(
      color: AppColors.bgPage,
      borderRadius: BorderRadius.circular(AppRadius.md),
      border: Border.all(
        color: error
            ? AppColors.borderError
            : focused
            ? AppColors.borderBrand
            : AppColors.borderDefault,
      ),
    );

/// HF/Input (292:54): label, gap 6, 48-high field, border 1, radius 8, px 12.
class KsTextField extends StatefulWidget {
  const KsTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.suffixText,
    this.suffixColor = AppColors.textSecondary,
    this.prefixText,
    this.prefixColor = AppColors.textSecondary,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.errorText,
    this.maxLength,
    this.enabled = true,
    this.autofocus = false,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? suffixText;
  final Color suffixColor;

  /// Fixed text before the input, e.g. country code "+88".
  final String? prefixText;
  final Color prefixColor;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? errorText;
  final int? maxLength;
  final bool enabled;
  final bool autofocus;

  @override
  State<KsTextField> createState() => _KsTextFieldState();
}

class _KsTextFieldState extends State<KsTextField> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // A section title above can replace the label (e.g. Figma 90).
        if (widget.label.isNotEmpty) ...[
          _Label(widget.label),
          const SizedBox(height: AppSpacing.label),
        ],
        Container(
          height: AppSizes.inputHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: _fieldBox(focused: _focus.hasFocus, error: hasError),
          child: Row(
            children: [
              if (widget.prefixText != null) ...[
                Text(
                  widget.prefixText!,
                  style: AppTypography.bodyMediumEmphasis.normal.withColor(
                    widget.prefixColor,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  enabled: widget.enabled,
                  autofocus: widget.autofocus,
                  keyboardType: widget.keyboardType,
                  inputFormatters: widget.inputFormatters,
                  textInputAction: widget.textInputAction,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  maxLength: widget.maxLength,
                  style: AppTypography.bodyMedium.normal,
                  cursorColor: AppColors.bgBrand,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    counterText: '',
                    hintText: widget.hint,
                    hintStyle: AppTypography.bodyMedium.normal.withColor(
                      AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              if (widget.suffixText != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Text(
                  widget.suffixText!,
                  style: AppTypography.bodyMediumEmphasis.normal.withColor(
                    widget.suffixColor,
                  ),
                ),
              ],
              // Figma keeps an invisible 18px "Picker" slot in every field.
              const SizedBox(width: AppSpacing.sm + AppSizes.iconSm),
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.errorText!,
            style: AppTypography.caption.withColor(AppColors.textError),
          ),
        ],
      ],
    );
  }
}

/// HF/Input used as a picker: label + field with green chevron-down (18).
class KsSelectField extends StatelessWidget {
  const KsSelectField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.onTap,
    this.value,
    this.errorText,
    this.showChevron = true,
  });

  /// Screen 12's union field has no visible chevron in Figma.
  final bool showChevron;
  final String label;
  final String placeholder;
  final String? value;
  final VoidCallback onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Label(label),
        const SizedBox(height: AppSpacing.label),
        Material(
          color: AppColors.bgPage,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              height: AppSizes.inputHeight,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: _fieldBox(error: errorText != null),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      hasValue ? value! : placeholder,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.normal.withColor(
                        hasValue
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  if (showChevron)
                    const AppIcon(
                      AppIcons.chevronDown,
                      size: AppSizes.iconSm,
                      color: AppColors.iconBrand,
                    )
                  else
                    const SizedBox(width: AppSizes.iconSm),
                ],
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            errorText!,
            style: AppTypography.caption.withColor(AppColors.textError),
          ),
        ],
      ],
    );
  }
}
