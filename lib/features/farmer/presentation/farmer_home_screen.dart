import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/data/market_price_repository.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_cards.dart';
import '../../../shared/widgets/ks_home_header.dart';
import '../../../shared/widgets/ks_search_bar.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../auth/data/user_repository.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../trade/data/trade_repository.dart';
import '../../trade/domain/trade_models.dart';
import '../data/listing_repository.dart';
import '../domain/listing.dart';

/// 15 Farmer Home (Figma 292:2169). Sections without data yet (offers,
/// orders, demands, payments) appear in later Parts when their data exists.
class FarmerHomeScreen extends ConsumerWidget {
  const FarmerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    final listings = ref.watch(myListingsProvider).value ?? const <Listing>[];
    final running = listings
        .where((x) =>
            x.status == ListingStatus.active ||
            x.status == ListingStatus.pending)
        .length;
    final prices = ref.watch(marketPricesProvider).value ?? const [];
    final newOffers = (ref.watch(myOffersProvider).value ?? const [])
        .where((o) => o.status == OfferStatus.pending && o.lastBy == 'buyer')
        .toList();
    void soon() => KsToast.comingSoon(context);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsHomeHeader(
        name: me?.name ?? '',
        photoUrl: me?.photoUrl,
        onBell: () => context.push(Routes.notifications),
        onChat: soon,
        onAvatar: () {},
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
            AppSpacing.contentTop, AppSpacing.screen, AppSpacing.s2xl),
        children: [
          KsSearchBar(
            hint: l.farmerSearchHint,
            readOnly: true,
            onTap: soon,
          ),
          if (newOffers.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            KsListItem(
              highlighted: true,
              thumb: Image.asset(AppUi.tileBell, fit: BoxFit.cover),
              title: l.homeNewOffers(
                  Fmt.digits(context, '${newOffers.length}')),
              subtitle: l.homeOffersSub(
                  newOffers.first.cropName(Localizations.localeOf(context)
                      .languageCode),
                  Fmt.number(
                      context,
                      newOffers
                          .map((o) => o.pricePerKg)
                          .reduce((a, b) => a > b ? a : b))),
              trailingText: l.homeSee,
              onTap: () => context
                  .push(Routes.listingOffers(newOffers.first.listingId)),
            ),
          ],
          if (prices.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            KsSectionHeader(
                title: l.homeTodayPrices,
                actionLabel: l.commonSeeAll,
                onAction: () => context.push(Routes.marketPrices)),
            const SizedBox(height: AppSpacing.block),
            KsCarousel(children: [
              for (final p in prices)
                KsPriceCard(
                    price: p,
                    onTap: () => context.push(Routes.priceTrend(p.cropKey))),
            ]),
          ],
          const SizedBox(height: AppSpacing.block),
          KsSectionHeader(title: l.homeWhatToDo),
          const SizedBox(height: AppSpacing.block),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: KsActionTile(
                  primary: true,
                  icon: AppUi.glyphLeaf,
                  title: l.homeSellCrop,
                  hint: l.homeSellCropSub,
                  onTap: () => context.push(Routes.farmerSell),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: KsActionTile(
                  icon: AppUi.glyphList,
                  title: l.homeMyListings,
                  hint: l.homeMyListingsSub(
                      Fmt.digits(context, '$running')),
                  onTap: () => context.push(Routes.farmerListings),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: KsActionTile(
                  icon: AppUi.glyphTrendUp,
                  title: l.homeBuyerDemand,
                  hint: l.homeBuyerDemandSub,
                  onTap: soon,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: KsActionTile(
                  icon: AppUi.glyphWallet,
                  title: l.homePayments,
                  hint: l.homePaymentsSub(Fmt.taka(
                      context,
                      () {
                        final now = DateTime.now();
                        return (ref.watch(myOrdersProvider).value ??
                                const <TradeOrder>[])
                            .where((o) =>
                                o.status != OrderStatus.cancelled &&
                                o.createdAt != null &&
                                o.createdAt!.year == now.year &&
                                o.createdAt!.month == now.month)
                            .fold<num>(0, (a, o) => a + o.cropTotal);
                      }())),
                  onTap: () => context.push(Routes.payments),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          _ExportBanner(onTap: soon),
          const SizedBox(height: AppSpacing.block),
          KsSectionHeader(
              title: l.homeTips, actionLabel: l.commonSeeAll, onAction: soon),
          const SizedBox(height: AppSpacing.block),
          SizedBox(
            height: _TipCard.height,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _TipCard(
                    image: AppUi.glyphTrendUp,
                    title: l.tipBetterPrice,
                    time: '1:05',
                    done: true,
                    onTap: soon),
                const SizedBox(width: AppSpacing.md),
                _TipCard(
                    image: AppUi.tipClipboard,
                    title: l.tipPackaging,
                    time: '0:50',
                    onTap: soon),
                const SizedBox(width: AppSpacing.md),
                _TipCard(
                    image: AppUi.tipStar,
                    title: l.tipGrading,
                    time: '1:20',
                    onTap: soon),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Banner Slider (292:108, slide 1): muted fill, radius 12, h 140, p 16,
/// Bold 17 title, Regular 13 sub, brand CTA pill, 96px image radius 14,
/// then 3 dots (active 18×6 brand, others 6×6 subtle).
class _ExportBanner extends StatelessWidget {
  const _ExportBanner({required this.onTap});
  final VoidCallback onTap;

  static const _h = 140.0;
  static const _img = 96.0;
  static const _imgLeft = 216.0;
  static const _imgTop = 22.0;
  static const _imgRadius = 14.0;
  static const _ctaPx = 14.0;
  static const _ctaPy = 6.0;
  static const _dotH = 6.0;
  static const _dotW = 18.0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: _h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.bgMuted,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.homeBannerExportTitle,
                          style: AppTypography.bold17.normal),
                      const SizedBox(height: AppSpacing.xs),
                      Text(l.homeBannerExportSub,
                          style: AppTypography.bodySmall.normal
                              .withColor(AppColors.textSecondary)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: _ctaPx, vertical: _ctaPy),
                        decoration: BoxDecoration(
                          color: AppColors.bgBrand,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                        ),
                        child: Text(l.homeSee,
                            style: AppTypography.caption.normal.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textOnBrand)),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: _imgLeft,
                  top: _imgTop,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_imgRadius),
                    child: Image.asset(AppImages.port,
                        width: _img, height: _img, fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.label),
                Container(
                  width: i == 0 ? _dotW : _dotH,
                  height: _dotH,
                  decoration: BoxDecoration(
                    color: i == 0 ? AppColors.bgBrand : AppColors.bgSubtle,
                    borderRadius: BorderRadius.circular(_dotH / 2),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// HF/Tip Cards (345:6251): 140 wide, white, #E0E0E0 border, radius 12,
/// p 12, gap 6; 116×64 thumb (radius 8, subtle or #F3F3F3 bg); SemiBold 14
/// title; Regular 12 "শুনুন · m:ss"; 20px check on the first (listened).
class _TipCard extends StatelessWidget {
  const _TipCard({
    required this.image,
    required this.title,
    required this.time,
    required this.onTap,
    this.done = false,
  });

  final String image;
  final String title;
  final String time;
  final VoidCallback onTap;
  final bool done;

  static const height = 168.0;
  static const _w = 140.0;
  static const _thumbH = 64.0;
  static const _check = 20.0;
  static const _checkInset = 7.0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _w,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.bgPage,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: _thumbH,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: done ? AppColors.bgSubtle : AppColors.tipThumbBg,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Image.asset(image, fit: BoxFit.contain),
                ),
                const SizedBox(height: AppSpacing.label),
                Text(title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMediumStrong.normal),
                const SizedBox(height: AppSpacing.label),
                Text(l.tipListen(Fmt.digits(context, time)),
                    style: AppTypography.caption.normal
                        .withColor(AppColors.textSecondary)),
              ],
            ),
            if (done)
              Positioned(
                right: _checkInset - AppSpacing.md,
                top: _checkInset - AppSpacing.md,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_check / 2),
                  child: Image.asset(AppImages.dotActive,
                      width: _check, height: _check, fit: BoxFit.cover),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
