import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/data/market_price_repository.dart';
import '../../../shared/services/bd_location_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_hero.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_photo_gallery.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../auth/data/user_repository.dart';
import '../../trade/data/trade_repository.dart';
import '../data/listing_repository.dart';
import '../domain/listing.dart';
import 'listing_widgets.dart';

/// 23 Crop Details (Figma 292:448), farmer's own listing.
class ListingDetailsScreen extends ConsumerWidget {
  const ListingDetailsScreen({super.key, required this.listingId});
  final String listingId;

  /// Figma hero photo height (full-bleed, square corners).
  static const _heroH = 252.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final async = ref.watch(listingProvider(listingId));

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      extendBodyBehindAppBar: true,
      appBar: KsAppBar(title: l.cropDetailsTitle, onImage: true),
      body: Stack(
        children: [
          async.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => Center(child: Text(l.errorGeneric)),
            data: (x) {
              if (x == null) return Center(child: Text(l.errorGeneric));
              final market = ref.watch(marketPriceProvider(x.cropKey)).value;
              final (badge, badgeBg, badgeFg) = listingBadge(l, x.status);
              return SafeArea(
                top: false,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  children: [
                    KsHeroPhoto(
                      figmaHeight: _heroH,
                      image: KsPhotoGallery(photos: listingPhotos(x)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screen,
                        KsHeroPhoto.gap,
                        AppSpacing.screen,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l.cropWithGrade(x.cropName(lang), x.grade),
                                  style: AppTypography.headingBold20.normal,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.x10,
                                  vertical: AppSpacing.badgeV,
                                ),
                                decoration: BoxDecoration(
                                  color: badgeBg,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.badge,
                                  ),
                                ),
                                child: Text(
                                  badge,
                                  style: AppTypography.bodySmallEmphasis.normal
                                      .withColor(badgeFg),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.block),
                          KsInfoCard(
                            rows: [
                              (
                                l.fieldQuantity,
                                l.qtyKg(Fmt.number(context, x.availableKg)),
                              ),
                              (
                                l.fieldMyPrice,
                                l.priceLine(Fmt.number(context, x.pricePerKg)),
                              ),
                              if (market != null)
                                (
                                  l.fieldMarketPrice,
                                  l.rangeLine(
                                    Fmt.number(context, market.min),
                                    Fmt.number(context, market.max),
                                  ),
                                ),
                              (
                                l.fieldAvailability,
                                l.availableFromDate(
                                  Fmt.date(context, x.availableFrom),
                                ),
                              ),
                              (
                                l.fieldPickup,
                                BdPlace.display(
                                      x.pickup.upazila,
                                      lang,
                                    ).isNotEmpty
                                    ? BdPlace.display(x.pickup.upazila, lang)
                                    : BdPlace.display(x.pickup.district, lang),
                              ),
                            ],
                          ),
                          if (x.status == ListingStatus.hidden &&
                              (x.moderationNote ?? '').isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.block),
                            Text(
                              l.moderationNote(x.moderationNote!),
                              style: AppTypography.bodySmall.withColor(
                                AppColors.textError,
                              ),
                            ),
                          ],
                          const SizedBox(
                            height:
                                AppSpacing.block +
                                AppSpacing.xs +
                                AppSpacing.block,
                          ),
                          KsButton(
                            label: l.seeBuyerOffers(
                              Fmt.digits(
                                context,
                                '${(ref.watch(listingOffersProvider(x.id)).value ?? const []).length}',
                              ),
                            ),
                            onPressed: x.status == ListingStatus.active
                                ? () => context.push(Routes.listingOffers(x.id))
                                : null,
                          ),
                          if (x.status == ListingStatus.active) ...[
                            const SizedBox(height: AppSpacing.block),
                            KsButton.outline(
                              label: l.markSold,
                              onPressed: () => ref
                                  .read(listingRepositoryProvider)
                                  .markSold(x.id),
                            ),
                          ],
                          ..._editActions(context, ref, l, x),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const KsHeroShade(),
        ],
      ),
    );
  }

  /// Edit / withdraw (only while no order is running on the listing).
  List<Widget> _editActions(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
    Listing x,
  ) {
    const editable = [
      ListingStatus.pending,
      ListingStatus.active,
      ListingStatus.hidden,
    ];
    if (!editable.contains(x.status)) return const [];
    final busy = (ref.watch(myOrdersProvider).value ?? const []).any(
      (o) => o.listingId == x.id && o.status.isOngoing,
    );
    return [
      const SizedBox(height: AppSpacing.block),
      Row(
        children: [
          Expanded(
            child: KsButton.outline(
              label: l.editListing,
              compact: true,
              onPressed: busy
                  ? null
                  : () => context.push(Routes.farmerEditListing(x.id)),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: KsButton.destructive(
              label: l.withdrawListing,
              compact: true,
              onPressed: busy
                  ? null
                  : () async {
                      final ok = await showKsConfirm(
                        context,
                        title: l.withdrawListingTitle,
                        body: l.withdrawListingBody,
                        noLabel: l.commonNo,
                        yesLabel: l.withdrawListing,
                      );
                      if (!ok) return;
                      try {
                        final me = ref.read(currentUserProvider).value;
                        if (me == null) return;
                        if (await ref
                            .read(tradeRepositoryProvider)
                            .hasOpenOrder(me.uid, x.id)) {
                          if (context.mounted) {
                            KsToast.show(context, l.listingHasOrder);
                          }
                          return;
                        }
                        await ref
                            .read(listingRepositoryProvider)
                            .withdraw(x.id);
                        if (context.mounted) {
                          KsToast.show(context, l.listingWithdrawnToast);
                        }
                      } catch (_) {
                        if (context.mounted) {
                          KsToast.show(context, l.errorGeneric);
                        }
                      }
                    },
            ),
          ),
        ],
      ),
      if (busy) ...[
        const SizedBox(height: AppSpacing.sm),
        Text(
          l.listingHasOrder,
          style: AppTypography.caption.normal.withColor(
            AppColors.textSecondary,
          ),
        ),
      ],
    ];
  }
}
