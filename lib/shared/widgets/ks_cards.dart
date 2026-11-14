import 'package:material_ui/material_ui.dart';

import '../../core/l10n/formatters.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import '../data/market_price_repository.dart';
import '../domain/crop_catalog.dart';

/// "Card" used in horizontal carousels (15, 71, 75): 140 wide, white,
/// #E0E0E0 border, radius 12, p 12, gap 6; 116×64 thumb radius 8;
/// SemiBold 14 title, Regular 12 secondary line, SemiBold 13 third line.
class KsMiniCard extends StatelessWidget {
  const KsMiniCard({
    super.key,
    required this.image,
    required this.title,
    required this.line2,
    required this.line3,
    this.line3Color = AppColors.textPrimary,
    this.onTap,
  });

  final Widget image;
  final String title;
  final String line2;
  final String line3;
  final Color line3Color;
  final VoidCallback? onTap;

  static const width = 140.0;
  static const height = 164.0;
  static const _thumbH = 64.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.bgPage,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: SizedBox(
                  height: _thumbH, width: double.infinity, child: image),
            ),
            const SizedBox(height: AppSpacing.label),
            Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyMediumStrong.normal),
            const SizedBox(height: AppSpacing.label),
            Text(line2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption.normal
                    .withColor(AppColors.textSecondary)),
            // 4 (not 6): Hind Siliguri's line box is ~2px taller than
            // Figma's, and the card height is fixed at 164.
            const SizedBox(height: AppSpacing.xs),
            Text(line3,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmallStrong.normal
                    .withColor(line3Color)),
          ],
        ),
      ),
    );
  }
}

/// Market price card: crop photo, name, "৳ 38/কেজি", "+12%" green / red.
class KsPriceCard extends StatelessWidget {
  const KsPriceCard({super.key, required this.price, this.onTap});
  final MarketPrice price;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final crop = CropCatalog.byKey(price.cropKey);
    final pct = price.changePct;
    final up = pct >= 0;
    return KsMiniCard(
      onTap: onTap,
      image: crop?.image == null
          ? const ColoredBox(color: AppColors.bgMuted)
          : Image.asset(crop!.image!, fit: BoxFit.cover),
      title: crop?.name(lang) ?? price.cropKey,
      line2: l.pricePerKg(Fmt.taka(context, price.price)),
      line3: '${up ? '+' : '−'}${Fmt.digits(context, '${pct.abs()}')}%',
      line3Color: up ? AppColors.textSuccess : AppColors.textError,
    );
  }
}

/// Horizontal carousel row of [KsMiniCard]s, gap 12.
class KsCarousel extends StatelessWidget {
  const KsCarousel({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: KsMiniCard.height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: children.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
          itemBuilder: (_, i) => children[i],
        ),
      );
}

/// HF/Category Item (292:219): 64 wide, 90 high, 56px round image,
/// gap 6, Medium 12 label.
class KsCategoryItem extends StatelessWidget {
  const KsCategoryItem({
    super.key,
    required this.image,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final String image;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  static const _w = 64.0;
  static const _h = 90.0;
  static const _img = 56.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: _w,
        height: _h,
        child: Column(
          children: [
            Container(
              width: _img,
              height: _img,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: selected
                    ? Border.all(color: AppColors.borderBrand, width: 2)
                    : null,
              ),
              child: ClipOval(child: Image.asset(image, fit: BoxFit.cover)),
            ),
            const SizedBox(height: AppSpacing.label),
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTypography.caption.normal.copyWith(
                    fontWeight: FontWeight.w500,
                    color: selected
                        ? AppColors.textBrand
                        : AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
