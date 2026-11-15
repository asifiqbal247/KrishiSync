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
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/utils/geo.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_cards.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../farmer/data/listing_repository.dart';
import 'buyer_common.dart';

/// 75 Crop Details for buyers (Figma 292:2483), with sticky CTA bar.
/// Rows shown only when backed by real data.
class BuyerListingScreen extends ConsumerWidget {
  const BuyerListingScreen({super.key, required this.listingId});
  final String listingId;

  static const _imageH = 220.0;
  static const _ctaBarH = 72.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final async = ref.watch(listingProvider(listingId));
    final me = ref.watch(currentUserProvider).value;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.cropDetailsTitle),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l.errorGeneric)),
        data: (x) {
          if (x == null) return Center(child: Text(l.errorGeneric));
          final market = ref.watch(marketPriceProvider(x.cropKey)).value;
          final farmer = ref.watch(userByIdProvider(x.farmerId)).value;
          final similar = (ref.watch(similarListingsProvider(x.cropKey)).value ??
                  const [])
              .where((s) => s.id != x.id)
              .toList();
          final km = distanceKm(me?.location.geo, x.pickup.geo);
          final place = placeOf(context, x);
          final fair = market != null &&
              x.pricePerKg >= market.min &&
              x.pricePerKg <= market.max;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
                      AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      child: SizedBox(
                        height: _imageH,
                        child: KsNetImage(
                            url: x.photo,
                            fallbackAsset: CropCatalog.imageFor(x.cropKey)),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.block),
                    Text(l.cropWithGrade(x.cropName(lang), x.grade),
                        style: AppTypography.headingBold22.normal),
                    const SizedBox(height: AppSpacing.block),
                    Text(l.priceLine(Fmt.number(context, x.pricePerKg)),
                        style: AppTypography.h1.normal),
                    if (market != null) ...[
                      const SizedBox(height: AppSpacing.block),
                      Text(
                        fair
                            ? l.marketRangeFair(Fmt.number(context, market.min),
                                Fmt.number(context, market.max))
                            : l.marketRangeOnly(Fmt.number(context, market.min),
                                Fmt.number(context, market.max)),
                        style: AppTypography.bodySmallEmphasis.normal
                            .withColor(AppColors.textSecondary),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.block),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        KsPill(label: l.gradeLabel(x.grade), selected: false),
                        KsPill(
                            label: l.qtyAvailable(
                                Fmt.number(context, x.availableKg)),
                            selected: false),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.block),
                    KsInfoCard(rows: [
                      (l.fieldAvailable, qtyText(context, x.availableKg)),
                      (
                        l.fieldAvailability,
                        l.availableFromDate(Fmt.date(context, x.availableFrom))
                      ),
                      (
                        l.fieldLocation,
                        km == null
                            ? place
                            : l.placeWithKm(
                                place, Fmt.number(context, km.round()))
                      ),
                    ]),
                    const SizedBox(height: AppSpacing.block),
                    KsSectionHeader(title: l.sectionFarmer),
                    const SizedBox(height: AppSpacing.block),
                    KsListItem(
                      thumb: KsNetImage(
                          url: farmer?.photoUrl ?? x.farmerPhotoUrl,
                          fallbackAsset: AppUi.avatarFarmer),
                      title: x.farmerName,
                      subtitle: l.farmerCardSub(
                        (farmer?.isVerified ?? false) ? l.verifiedDot : '',
                        farmer == null || farmer.ratingCount == 0
                            ? l.notAvailable
                            : Fmt.number(context, farmer.ratingAvg,
                                decimals: 1),
                        Fmt.digits(
                            context, '${farmer?.completedOrders ?? 0}'),
                      ),
                      trailingText: l.profileLink,
                      onTap: () =>
                          context.push(Routes.buyerFarmer(x.farmerId)),
                    ),
                    const SizedBox(height: AppSpacing.block),
                    KsSectionHeader(title: l.sectionDelivery),
                    const SizedBox(height: AppSpacing.block),
                    KsInfoCard(rows: [
                      (l.fieldPayment, l.safePayment),
                    ]),
                    if (similar.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.block),
                      KsSectionHeader(title: l.similarCrops),
                      const SizedBox(height: AppSpacing.block),
                      KsCarousel(children: [
                        for (final s in similar)
                          KsMiniCard(
                            image: KsNetImage(
                                url: s.photo,
                                fallbackAsset:
                                    CropCatalog.imageFor(s.cropKey)),
                            title: l.cropWithGrade(s.cropName(lang), s.grade),
                            line2: l.pricePerKg(
                                Fmt.taka(context, s.pricePerKg)),
                            line3: placeOf(context, s),
                            onTap: () => context
                                .pushReplacement(Routes.buyerListing(s.id)),
                          ),
                      ]),
                    ],
                  ],
                ),
              ),
              // Sticky CTA Bar (292:2563) — buyers only (farmers browse 28).
              if (me?.role == UserRole.buyer)
              Container(
                height: _ctaBarH + MediaQuery.of(context).padding.bottom,
                padding: EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.md,
                    AppSpacing.screen,
                    AppSpacing.md + MediaQuery.of(context).padding.bottom),
                decoration: const BoxDecoration(
                  color: AppColors.bgPage,
                  border:
                      Border(top: BorderSide(color: AppColors.borderDefault)),
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.pricePerKg(Fmt.taka(context, x.pricePerKg)),
                            style: AppTypography.labelButton.normal
                                .copyWith(fontWeight: FontWeight.w700)),
                        Text(
                            l.qtyAvailable(
                                Fmt.number(context, x.availableKg)),
                            style: AppTypography.labelSmall.normal.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: KsButton.secondary(
                        label: l.makeOffer,
                        onPressed: () =>
                            context.push(Routes.makeOffer(x.id)),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: KsButton(
                        label: l.placeOrder,
                        onPressed: () =>
                            context.push(Routes.placeOrder(x.id)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
