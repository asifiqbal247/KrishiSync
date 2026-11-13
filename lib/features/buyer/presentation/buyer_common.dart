import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/services/bd_location_service.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../auth/data/user_repository.dart';
import '../../farmer/domain/listing.dart';

/// Quantity text: 3000 kg → "৩ টন", 500 kg → "৫০০ কেজি".
String qtyText(BuildContext context, num kg) {
  final l = AppLocalizations.of(context);
  if (kg >= 1000 && kg % 1000 == 0) {
    return l.qtyTon(Fmt.number(context, kg / 1000));
  }
  return l.qtyKg(Fmt.number(context, kg));
}

String placeOf(BuildContext context, Listing x) {
  final lang = Localizations.localeOf(context).languageCode;
  final d = BdPlace.display(x.pickup.district, lang);
  return d.isNotEmpty ? d : BdPlace.display(x.pickup.upazila, lang);
}

/// Categories shown on 71 / 74 (Figma order) with their images.
List<(CropCategory?, String, String)> marketCategories(
        AppLocalizations l, {bool withAll = false}) =>
    [
      if (withAll) (null, AppUi.catAll, l.catAll),
      (CropCategory.vegetable, AppUi.catVegetable, l.catVegetable),
      (CropCategory.fruit, AppUi.catFruit, l.catFruit),
      (CropCategory.grain, AppUi.catGrain, l.catGrain),
      (CropCategory.fish, AppUi.catAll, l.catFish),
      (CropCategory.spice, AppUi.catSpice, l.catSpice),
      if (!withAll) (CropCategory.pulse, AppUi.catGrain, l.catPulse),
    ];

/// Market filter shared by Buyer Home (categories) and Marketplace (74).
class MarketFilter {
  const MarketFilter({
    this.category,
    this.districtId,
    this.minQty,
    this.maxPrice,
  });

  final CropCategory? category;
  final String? districtId;
  final num? minQty;
  final num? maxPrice;

  bool matches(Listing x) =>
      (category == null || x.category == category!.name) &&
      (districtId == null || x.pickup.districtId == districtId) &&
      (minQty == null || x.availableKg >= minQty!) &&
      (maxPrice == null || x.pricePerKg <= maxPrice!);

  MarketFilter copyWith({
    CropCategory? category,
    bool clearCategory = false,
    String? districtId,
    num? minQty,
    num? maxPrice,
  }) =>
      MarketFilter(
        category: clearCategory ? null : (category ?? this.category),
        districtId: districtId ?? this.districtId,
        minQty: minQty ?? this.minQty,
        maxPrice: maxPrice ?? this.maxPrice,
      );
}

class MarketFilterController extends Notifier<MarketFilter> {
  @override
  MarketFilter build() => const MarketFilter();
  void set(MarketFilter f) => state = f;
}

final marketFilterProvider =
    NotifierProvider<MarketFilterController, MarketFilter>(
        MarketFilterController.new);

/// Selected tab in the buyer shell (Home can jump to Market).
class BuyerTabController extends Notifier<int> {
  @override
  int build() => 0;
  void go(int i) => state = i;
}

final buyerTabProvider =
    NotifierProvider<BuyerTabController, int>(BuyerTabController.new);

/// Marketplace row (74): photo, "Crop (Grade A)", "500 কেজি · জেলা · 4.7",
/// "৳ 38", chevron. Rating comes from the farmer's profile.
class MarketListingTile extends ConsumerWidget {
  const MarketListingTile({super.key, required this.listing});
  final Listing listing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final farmer = ref.watch(userByIdProvider(listing.farmerId)).value;
    final parts = [
      qtyText(context, listing.availableKg),
      placeOf(context, listing),
      if (farmer != null && farmer.ratingCount > 0)
        Fmt.number(context, farmer.ratingAvg, decimals: 1),
    ].where((s) => s.isNotEmpty);
    return KsListItem(
      thumb: KsNetImage(
        url: listing.photo,
        thumbSize: KsListItem.thumbSize.round(),
        fallbackAsset: CropCatalog.imageFor(listing.cropKey),
      ),
      title: l.cropWithGrade(listing.cropName(lang), listing.grade),
      subtitle: parts.join(' · '),
      trailingText: Fmt.taka(context, listing.pricePerKg),
      onTap: () => context.push(Routes.buyerListing(listing.id)),
    );
  }
}
