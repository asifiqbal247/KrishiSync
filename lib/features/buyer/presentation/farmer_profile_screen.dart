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
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../farmer/data/listing_repository.dart';
import '../../chat/presentation/chat_screens.dart';
import '../../../shared/data/trade_stats_repository.dart';
import 'buyer_common.dart';

/// 76 Farmer Profile (Figma 292:1026), seen by buyers.
class FarmerProfileScreen extends ConsumerStatefulWidget {
  const FarmerProfileScreen({super.key, required this.farmerId});
  final String farmerId;

  @override
  ConsumerState<FarmerProfileScreen> createState() => _FarmerProfileState();
}

class _FarmerProfileState extends ConsumerState<FarmerProfileScreen> {
  /// Figma shows two crops; "সব দেখুন" shows the rest.
  static const _preview = 2;
  bool _all = false;

  String get farmerId => widget.farmerId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    // Delivery stats open the buyer's own history with this farmer (120).
    final VoidCallback? history = me?.role == UserRole.buyer
        ? () => context.push(Routes.supplier(farmerId))
        : null;
    final lang = Localizations.localeOf(context).languageCode;
    final farmer = ref.watch(userByIdProvider(farmerId)).value;
    final stats =
        ref.watch(tradeStatsProvider(farmerId)).value ?? TradeStats.empty;
    final listings =
        ref.watch(farmerActiveListingsProvider(farmerId)).value ?? const [];
    String n(int v) => l.countTi(Fmt.digits(context, '$v'));

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.farmerProfileTitle),
      body: farmer == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.contentTop,
                AppSpacing.screen,
                AppSpacing.lg,
              ),
              children: [
                KsListItem(
                  thumb: KsNetImage(
                    url: farmer.photoUrl,
                    fallbackAsset: AppUi.avatarFarmer,
                  ),
                  title: farmer.name,
                  subtitle: [
                    BdPlace.display(farmer.location.district, lang),
                    farmer.isVerified ? l.verifiedNid : l.notVerified,
                  ].where((s) => s.isNotEmpty).join(' · '),
                  showChevron: false,
                ),
                const SizedBox(height: AppSpacing.block),
                Row(
                  children: [
                    Expanded(
                      child: KsStatCard(
                        label: l.statRating,
                        onTap: () => context.push(Routes.userRatings(farmerId)),
                        value: farmer.ratingCount == 0
                            ? l.notAvailable
                            : l.ratingWithCount(
                                Fmt.number(
                                  context,
                                  farmer.ratingAvg,
                                  decimals: 1,
                                ),
                                Fmt.digits(context, '${farmer.ratingCount}'),
                              ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: KsStatCard(
                        label: l.statOnTime,
                        onTap: history,
                        value: stats.onTimePct == null
                            ? l.notAvailable
                            : '${Fmt.digits(context, '${stats.onTimePct}')}%',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.block),
                Row(
                  children: [
                    Expanded(
                      child: KsStatCard(
                        label: l.statCompleted,
                        value: n(stats.done),
                        onTap: history,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: KsStatCard(
                        label: l.statComplaints,
                        value: n(stats.complaints),
                        onTap: history,
                      ),
                    ),
                  ],
                ),
                if (listings.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.block),
                  KsSectionHeader(
                    title: l.availableCrops,
                    actionLabel: listings.length > _preview && !_all
                        ? l.commonSeeAll
                        : null,
                    onAction: () => setState(() => _all = true),
                  ),
                  for (final x
                      in _all ? listings : listings.take(_preview)) ...[
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
                  height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
                ),
                // Chat is Tier C.
                KsButton.outline(
                  label: l.sendMessage,
                  onPressed: () => openChatWith(context, ref, farmerId),
                ),
              ],
            ),
    );
  }
}
