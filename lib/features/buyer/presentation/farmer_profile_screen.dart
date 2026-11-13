import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/services/bd_location_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../auth/data/user_repository.dart';
import '../../farmer/data/listing_repository.dart';
import 'buyer_common.dart';

/// 76 Farmer Profile (Figma 292:1026), seen by buyers.
class FarmerProfileScreen extends ConsumerWidget {
  const FarmerProfileScreen({super.key, required this.farmerId});
  final String farmerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final farmer = ref.watch(userByIdProvider(farmerId)).value;
    final listings =
        ref.watch(farmerActiveListingsProvider(farmerId)).value ?? const [];
    String n(int v) => l.countTi(Fmt.digits(context, '$v'));

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.farmerProfileTitle),
      body: farmer == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
                  AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
              children: [
                KsListItem(
                  thumb: KsNetImage(
                      url: farmer.photoUrl, fallbackAsset: AppUi.avatarFarmer),
                  title: farmer.name,
                  subtitle: [
                    BdPlace.display(farmer.location.district, lang),
                    farmer.isVerified ? l.verifiedNid : l.notVerified,
                  ].where((s) => s.isNotEmpty).join(' · '),
                  showChevron: false,
                ),
                const SizedBox(height: AppSpacing.block),
                Row(children: [
                  Expanded(
                    child: KsStatCard(
                      label: l.statRating,
                      value: farmer.ratingCount == 0
                          ? l.notAvailable
                          : l.ratingWithCount(
                              Fmt.number(context, farmer.ratingAvg,
                                  decimals: 1),
                              Fmt.digits(context, '${farmer.ratingCount}')),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: KsStatCard(
                      label: l.statOnTime,
                      value: farmer.onTimeRate == null
                          ? l.notAvailable
                          : '${Fmt.digits(context, '${farmer.onTimeRate}')}%',
                    ),
                  ),
                ]),
                const SizedBox(height: AppSpacing.block),
                Row(children: [
                  Expanded(
                    child: KsStatCard(
                        label: l.statCompleted,
                        value: n(farmer.completedOrders)),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: KsStatCard(
                        label: l.statComplaints,
                        value: n(farmer.complaintCount)),
                  ),
                ]),
                if (listings.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.block),
                  KsSectionHeader(title: l.availableCrops),
                  for (final x in listings) ...[
                    const SizedBox(height: AppSpacing.block),
                    KsListItem(
                      thumb: KsNetImage(
                        url: x.photo,
                        thumbSize: KsListItem.thumbSize.round(),
                        fallbackAsset: CropCatalog.imageFor(x.cropKey),
                      ),
                      title: x.cropName(lang),
                      subtitle: qtyText(context, x.availableKg),
                      trailingText: Fmt.taka(context, x.pricePerKg),
                      onTap: () => context.push(Routes.buyerListing(x.id)),
                    ),
                  ],
                ],
                const SizedBox(
                    height:
                        AppSpacing.block + AppSpacing.xs + AppSpacing.block),
                // Chat is Tier C.
                KsButton.outline(
                  label: l.sendMessage,
                  onPressed: () => KsToast.comingSoon(context),
                ),
              ],
            ),
    );
  }
}
