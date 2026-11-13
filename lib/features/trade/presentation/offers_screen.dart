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
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../auth/data/user_repository.dart';
import '../../buyer/presentation/buyer_common.dart';
import '../../farmer/data/listing_repository.dart';
import '../data/trade_repository.dart';
import '../domain/trade_models.dart';

enum _Tab { all, fresh, talking }

/// 24 Buyer Offers (Figma 292:472), farmer — offers on one listing.
class OffersScreen extends ConsumerStatefulWidget {
  const OffersScreen({super.key, required this.listingId});
  final String listingId;

  @override
  ConsumerState<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends ConsumerState<OffersScreen> {
  _Tab _tab = _Tab.all;

  bool _inTab(Offer o) => switch (_tab) {
        _Tab.all => true,
        _Tab.fresh => o.status == OfferStatus.pending && o.lastBy == 'buyer',
        _Tab.talking => o.status == OfferStatus.countered,
      };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final listing = ref.watch(listingProvider(widget.listingId)).value;
    final market = listing == null
        ? null
        : ref.watch(marketPriceProvider(listing.cropKey)).value;
    final offers =
        ref.watch(listingOffersProvider(widget.listingId)).value ?? const [];
    final shown = offers.where(_inTab).toList();
    final tabs = [
      (_Tab.all, l.offerTabAll),
      (_Tab.fresh, l.offerTabNew),
      (_Tab.talking, l.offerTabTalking),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.offersTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
            AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
        children: [
          Wrap(spacing: AppSpacing.sm, children: [
            for (final (t, label) in tabs)
              KsPill(
                  label: label,
                  selected: _tab == t,
                  onTap: () => setState(() => _tab = t)),
          ]),
          if (market != null) ...[
            const SizedBox(height: AppSpacing.block),
            Text(
              l.marketRangeShort(Fmt.number(context, market.min),
                  Fmt.number(context, market.max)),
              style: AppTypography.bodySmallEmphasis.normal
                  .withColor(AppColors.textSecondary),
            ),
          ],
          if (shown.isEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            Text(l.emptyFilter,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.normal
                    .withColor(AppColors.textSecondary)),
          ],
          for (final o in shown) ...[
            const SizedBox(height: AppSpacing.block),
            _OfferTile(offer: o),
          ],
        ],
      ),
    );
  }
}

class _OfferTile extends ConsumerWidget {
  const _OfferTile({required this.offer});
  final Offer offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final buyer = ref.watch(userByIdProvider(offer.buyerId)).value;
    final rating = buyer == null || buyer.ratingCount == 0
        ? null
        : Fmt.number(context, buyer.ratingAvg, decimals: 1);
    final sub = buyer?.isVerified == true && rating != null
        ? l.buyerVerifiedRating(rating)
        : rating != null
            ? l.buyerRating(rating)
            : l.newBuyerQty(qtyText(context, offer.quantityKg));
    final closed = !offer.status.isOpen;
    return Opacity(
      opacity: closed ? 0.6 : 1,
      child: KsListItem(
        thumb: KsNetImage(
            url: offer.buyerPhotoUrl, fallbackAsset: AppUi.avatarBuyer),
        title: offer.buyerName,
        subtitle: sub,
        trailingText:
            l.pricePerKgShort(Fmt.number(context, offer.pricePerKg)),
        onTap: () => context.push(Routes.offer(offer.id)),
      ),
    );
  }
}
