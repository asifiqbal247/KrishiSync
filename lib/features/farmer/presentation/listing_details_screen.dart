import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/data/market_price_repository.dart';
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/services/bd_location_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../data/listing_repository.dart';
import '../domain/listing.dart';
import 'listing_widgets.dart';

/// 23 Crop Details (Figma 292:448), farmer's own listing.
class ListingDetailsScreen extends ConsumerWidget {
  const ListingDetailsScreen({super.key, required this.listingId});
  final String listingId;

  static const _imageHeight = 160.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final async = ref.watch(listingProvider(listingId));

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.cropDetailsTitle),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l.errorGeneric)),
        data: (x) {
          if (x == null) return Center(child: Text(l.errorGeneric));
          final market = ref.watch(marketPriceProvider(x.cropKey)).value;
          final (badge, badgeBg, badgeFg) = listingBadge(l, x.status);
          return SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
                  AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  child: SizedBox(
                    height: _imageHeight,
                    child: KsNetImage(
                      url: x.photo,
                      fallbackAsset: CropCatalog.imageFor(x.cropKey),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.block),
                Row(
                  children: [
                    Expanded(
                      child: Text(l.cropWithGrade(x.cropName(lang), x.grade),
                          style: AppTypography.headingBold20.normal),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.x10,
                          vertical: AppSpacing.badgeV),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(AppRadius.badge),
                      ),
                      child: Text(badge,
                          style: AppTypography.bodySmallEmphasis.normal
                              .withColor(badgeFg)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.block),
                KsInfoCard(rows: [
                  (l.fieldQuantity,
                      l.qtyKg(Fmt.number(context, x.availableKg))),
                  (l.fieldMyPrice,
                      l.priceLine(Fmt.number(context, x.pricePerKg))),
                  if (market != null)
                    (
                      l.fieldMarketPrice,
                      l.rangeLine(Fmt.number(context, market.min),
                          Fmt.number(context, market.max))
                    ),
                  (
                    l.fieldAvailability,
                    l.availableFromDate(Fmt.date(context, x.availableFrom))
                  ),
                  (
                    l.fieldPickup,
                    BdPlace.display(x.pickup.upazila, lang).isNotEmpty
                        ? BdPlace.display(x.pickup.upazila, lang)
                        : BdPlace.display(x.pickup.district, lang)
                  ),
                ]),
                if (x.status == ListingStatus.hidden &&
                    (x.moderationNote ?? '').isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.block),
                  Text(l.moderationNote(x.moderationNote!),
                      style: AppTypography.bodySmall
                          .withColor(AppColors.textError)),
                ],
                const SizedBox(
                    height:
                        AppSpacing.block + AppSpacing.xs + AppSpacing.block),
                // Offers arrive in Part 5; count is 0 until then.
                KsButton(
                  label: l.seeBuyerOffers(Fmt.digits(context, '0')),
                  onPressed: x.status == ListingStatus.active
                      ? () => KsToast.comingSoon(context)
                      : null,
                ),
                if (x.status == ListingStatus.active) ...[
                  const SizedBox(height: AppSpacing.block),
                  KsButton.outline(
                    label: l.markSold,
                    onPressed: () =>
                        ref.read(listingRepositoryProvider).markSold(x.id),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
