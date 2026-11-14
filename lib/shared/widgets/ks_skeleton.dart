import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

/// 215 Loading (Skeleton), Figma 292:2622: muted blocks instead of an empty
/// screen while data loads.
class _Bone extends StatelessWidget {
  const _Bone({this.width, required this.height, required this.radius});
  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.bgMuted,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}

/// Skeleton row: bordered box, p 12, radius 12, 48px thumb (radius 8),
/// 12px line + 10px × 120 line, gap 8.
class KsSkeletonRow extends StatelessWidget {
  const KsSkeletonRow({super.key});

  static const _line1 = 12.0;
  static const _line2 = 10.0;
  static const _line2W = 120.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: const Row(children: [
        _Bone(width: AppSizes.thumb, height: AppSizes.thumb, radius: AppRadius.md),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Bone(height: _line1, radius: _line1 / 2),
              SizedBox(height: AppSpacing.sm),
              _Bone(width: _line2W, height: _line2, radius: _line2 / 2),
            ],
          ),
        ),
      ]),
    );
  }
}

/// List skeleton: [rows] skeleton rows with the screen padding.
class KsSkeletonList extends StatelessWidget {
  const KsSkeletonList({super.key, this.rows = 4, this.padded = true});
  final int rows;
  final bool padded;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: !padded,
      padding: padded
          ? const EdgeInsets.fromLTRB(AppSpacing.screen, AppSpacing.contentTop,
              AppSpacing.screen, AppSpacing.lg)
          : EdgeInsets.zero,
      children: [
        for (var i = 0; i < rows; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.block),
          const KsSkeletonRow(),
        ],
      ],
    );
  }
}

/// Home skeleton (215): 72 block, 18 × 160 title, 3 × 150 cards, 18 × 200
/// title, two rows.
class KsSkeletonHome extends StatelessWidget {
  const KsSkeletonHome({super.key});

  static const _banner = 72.0;
  static const _title = 18.0;
  static const _titleW1 = 160.0;
  static const _titleW2 = 200.0;
  static const _card = 150.0;
  static const _cardW = 140.0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
          AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
      children: [
        const _Bone(height: _banner, radius: AppRadius.lg),
        const SizedBox(height: AppSpacing.block),
        const Align(
            alignment: Alignment.centerLeft,
            child: _Bone(width: _titleW1, height: _title, radius: AppRadius.bone)),
        const SizedBox(height: AppSpacing.block),
        SizedBox(
          height: _card,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.md),
                const _Bone(width: _cardW, height: _card, radius: AppRadius.lg),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.block),
        const Align(
            alignment: Alignment.centerLeft,
            child: _Bone(width: _titleW2, height: _title, radius: AppRadius.bone)),
        const SizedBox(height: AppSpacing.block),
        const KsSkeletonRow(),
        const SizedBox(height: AppSpacing.block),
        const KsSkeletonRow(),
      ],
    );
  }
}
