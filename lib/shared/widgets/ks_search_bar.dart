import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import 'app_icon.dart';
import 'voice_search_sheet.dart';

/// HF/Search Bar (292:59): surface fill, radius 16, h 48, pl 16 pr 8, gap 8,
/// 20px search icon (border/strong), Regular 14 text, 32px white mic circle
/// with 16px brand mic. The mic does voice search (V1): the words are typed
/// into the field (cursor at the end, keyboard open) so the user can edit
/// them and then press search. A button-style bar passes them to [onVoice]
/// instead (e.g. open the search screen with them).
class KsSearchBar extends StatefulWidget {
  const KsSearchBar({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onMic,
    this.onVoice,
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
  final ValueChanged<String>? onVoice;
  final bool readOnly;
  final bool autofocus;

  @override
  State<KsSearchBar> createState() => _KsSearchBarState();
}

class _KsSearchBarState extends State<KsSearchBar> {
  static const _searchIcon = 20.0;
  static const _micBox = 32.0;
  final _focus = FocusNode();

  String get hint => widget.hint;
  TextEditingController? get controller => widget.controller;
  ValueChanged<String>? get onChanged => widget.onChanged;
  ValueChanged<String>? get onSubmitted => widget.onSubmitted;
  VoidCallback? get onTap => widget.onTap;
  VoidCallback? get onMic => widget.onMic;
  ValueChanged<String>? get onVoice => widget.onVoice;
  bool get readOnly => widget.readOnly;
  bool get autofocus => widget.autofocus;

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asButton = readOnly && onTap != null;
    final bar = _bar(context, asButton);
    return asButton
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: bar,
          )
        : bar;
  }

  Future<void> _voice(BuildContext context) async {
    final words = await listenForSearch(context);
    if (words == null) return;
    if (onVoice != null) {
      onVoice!(words);
      return;
    }
    if (controller == null || !mounted) return;
    controller!.text = words;
    controller!.selection = TextSelection.collapsed(offset: words.length);
    onChanged?.call(words);
    if (!readOnly) _focus.requestFocus();
  }

  Widget _bar(BuildContext context, bool asButton) {
    return Container(
      height: AppSizes.searchHeight,
      padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        children: [
          const AppIcon(
            AppIcons.search,
            size: _searchIcon,
            color: AppColors.borderStrong,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: IgnorePointer(
              ignoring: asButton,
              child: TextField(
                controller: controller,
                focusNode: _focus,
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
                  hintStyle: AppTypography.bodyMedium.normal.withColor(
                    AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Material(
            color: AppColors.bgPage,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onMic ?? () => _voice(context),
              child: const SizedBox.square(
                dimension: _micBox,
                child: Center(
                  child: AppIcon(
                    AppIcons.mic,
                    size: AppSizes.iconXs,
                    color: AppColors.iconBrand,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
