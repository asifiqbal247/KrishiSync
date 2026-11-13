import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/data/market_price_repository.dart';
import '../../../shared/services/bd_location_service.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_cards.dart';
import '../../../shared/widgets/ks_home_header.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_search_bar.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../auth/data/user_repository.dart';
import '../../farmer/data/listing_repository.dart';
import 'buyer_common.dart';

/// 71 Buyer Home (Figma 292:2325). Demand / pooling / procurement sections
/// are Tier C and stay hidden; order stats fill in with Part 5–6 data.
class BuyerHomeScreen extends ConsumerWidget {
  const BuyerHomeScreen({super.key});

  static const _recommended = 5;
  static const _catRowH = 90.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    final active = ref.watch(activeListingsProvider).value ?? const [];
    final prices = ref.watch(marketPricesProvider).value ?? const [];
    final suppliers = (ref.watch(topFarmersProvider).value ?? const [])
        .where((u) => u.ratingCount > 0)
        .toList();
    void soon() => KsToast.comingSoon(context);
    String n(int v) => l.countTi(Fmt.digits(context, '$v'));

    void openCategory(category) {
      ref
          .read(marketFilterProvider.notifier)
          .set(MarketFilter(category: category));
      ref.read(buyerTabProvider.notifier).go(1);
    }

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsHomeHeader(
        name: me?.name ?? '',
        photoUrl: me?.photoUrl,
        fallbackAvatar: AppUi.avatarBuyer,
        onBell: () => context.push(Routes.notifications),
        onChat: soon,
        onAvatar: () => ref.read(buyerTabProvider.notifier).go(3),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
            AppSpacing.contentTop, AppSpacing.screen, AppSpacing.s2xl),
        children: [
          KsSearchBar(
            hint: l.buyerSearchHint,
            readOnly: true,
            onTap: () => context.push(Routes.buyerSearch),
          ),
          const SizedBox(height: AppSpacing.block),
          Row(children: [
            Expanded(
                child: KsStatCard(
                    label: l.statOngoingOrders,
                    value: n(0),
                    onTap: () => ref.read(buyerTabProvider.notifier).go(2))),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
                child: KsStatCard(
                    label: l.statInTransit,
                    value: n(0),
                    onTap: () => ref.read(buyerTabProvider.notifier).go(2))),
          ]),
          const SizedBox(height: AppSpacing.block),
          Row(children: [
            Expanded(
                child: KsStatCard(
                    label: l.statSafePay,
                    value: Fmt.taka(context, 0),
                    onTap: soon)),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
                child: KsStatCard(
                    label: l.statNewOffers, value: n(0), onTap: soon)),
          ]),
          const SizedBox(height: AppSpacing.block),
          SizedBox(
            height: _catRowH,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: marketCategories(l).length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppSpacing.md),
              itemBuilder: (_, i) {
                final (cat, img, label) = marketCategories(l)[i];
                return KsCategoryItem(
                    image: img,
                    label: label,
                    onTap: () => openCategory(cat));
              },
            ),
          ),
          const SizedBox(height: AppSpacing.block),
          KsSectionHeader(title: l.quickActions),
          const SizedBox(height: AppSpacing.block),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: KsActionTile(
                primary: true,
                icon: AppUi.glyphDemand,
                title: l.actPostDemand,
                hint: l.actPostDemandSub,
                onTap: soon,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: KsActionTile(
                icon: AppUi.glyphMarket,
                title: l.actMarket,
                hint: l.actMarketSub(Fmt.digits(context, '${active.length}')),
                onTap: () {
                  ref.read(marketFilterProvider.notifier).set(
                      const MarketFilter());
                  ref.read(buyerTabProvider.notifier).go(1);
                },
              ),
            ),
          ]),
          const SizedBox(height: AppSpacing.block),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: KsActionTile(
                icon: AppUi.tipClipboard,
                title: l.actProcurement,
                hint: l.actProcurementSub,
                onTap: soon,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: KsActionTile(
                icon: AppUi.glyphTruck,
                title: l.actBookTruck,
                hint: l.actBookTruckSub,
                onTap: soon,
              ),
            ),
          ]),
          if (prices.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            KsSectionHeader(
                title: l.homeTodayPrices,
                actionLabel: l.commonSeeAll,
                onAction: soon),
            const SizedBox(height: AppSpacing.block),
            KsCarousel(children: [
              for (final p in prices) KsPriceCard(price: p),
            ]),
          ],
          if (suppliers.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            KsSectionHeader(title: l.topSuppliers),
            const SizedBox(height: AppSpacing.block),
            KsCarousel(children: [
              for (final u in suppliers)
                KsMiniCard(
                  image: KsNetImage(
                      url: u.photoUrl, fallbackAsset: AppUi.avatarFarmer),
                  title: u.name,
                  line2: [
                    BdPlace.display(u.location.district, lang),
                    Fmt.number(context, u.ratingAvg, decimals: 1),
                  ].join(' · '),
                  line3: u.onTimeRate == null
                      ? l.notAvailable
                      : l.onTimePct(Fmt.digits(context, '${u.onTimeRate}')),
                  onTap: () => context.push(Routes.buyerFarmer(u.uid)),
                ),
            ]),
          ],
          if (active.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            KsSectionHeader(
              title: l.recommendedCrops,
              actionLabel: l.commonSeeAll,
              onAction: () => ref.read(buyerTabProvider.notifier).go(1),
            ),
            for (final x in active.take(_recommended)) ...[
              const SizedBox(height: AppSpacing.block),
              MarketListingTile(listing: x),
            ],
          ],
        ],
      ),
    );
  }
}
