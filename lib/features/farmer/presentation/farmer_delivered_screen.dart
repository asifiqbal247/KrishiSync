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
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../auth/data/user_repository.dart';
import '../../buyer/presentation/buyer_common.dart' show qtyText;
import '../../trade/data/trade_repository.dart';
import '../../transport/data/transport_repository.dart';
import '../../transport/presentation/rate_screens.dart' show reviewedProvider;

/// 53 Delivery Confirmation (farmer, Figma 292:752): the crop reached the
/// buyer. Sent vs received weight, delivery time; rate the buyer (54).
class FarmerDeliveredScreen extends ConsumerWidget {
  const FarmerDeliveredScreen({super.key, required this.orderId});
  final String orderId;

  /// Figma sizes below its 28px status bar (the phone's own bar is added).
  static const _heroH = 232.0 - 28;
  static const _shadeH = 120.0 - 28;

  /// Figma "Hero Space": the info box starts below the photo.
  static const _heroSpace = 140.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    final o = ref.watch(orderProvider(orderId)).value;
    // Platform truck: the load's weighed and delivered amounts.
    final d = ref.watch(deliveryProvider(orderId)).value;
    final top = MediaQuery.of(context).padding.top;

    final body = o == null || me == null
        ? const KsSkeletonList(rows: 3)
        : () {
            final rated =
                ref
                    .watch(reviewedProvider('${o.id}|${me.uid}|${o.buyerId}'))
                    .value ??
                false;
            final sent = d?.loadedKg ?? o.quantityKg;
            final got = d?.deliveredKg ?? sent;
            final at = d?.timeline['delivered'] ?? o.timeline['delivered'];
            return ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screen,
                top + AppSizes.appBarHeight + AppSpacing.contentTop,
                AppSpacing.screen,
                AppSpacing.lg,
              ),
              children: [
                const SizedBox(height: _heroSpace),
                const SizedBox(height: AppSpacing.block),
                KsInfoBox(
                  children: [
                    KsInfoRow(l.rowBuyer, o.buyerName),
                    KsInfoRow(l.rowSentQty, qtyText(context, sent)),
                    KsInfoRow(l.rowReceivedQty, qtyText(context, got)),
                    if (at != null)
                      KsInfoRow(
                        l.rowDeliveredAt,
                        '${Fmt.date(context, at)}, ${Fmt.time(context, at)}',
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.block),
                Text(
                  l.farmerDeliveredNote,
                  style: AppTypography.bodyMedium.normal.withColor(
                    AppColors.textSecondary,
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
                ),
                KsButton.secondary(
                  label: rated ? l.alreadyRated : l.rateBuyerBtn,
                  onPressed: rated
                      ? null
                      : () => context.push(Routes.farmerRateBuyer(o.id)),
                ),
                const SizedBox(height: AppSpacing.block),
                KsButton(
                  label: l.seePayStatus,
                  onPressed: () => context.push(Routes.receipt(o.id)),
                ),
              ],
            );
          }();

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      extendBodyBehindAppBar: true,
      appBar: KsAppBar(title: l.farmerDeliveredTitle, onImage: true),
      body: Stack(
        children: [
          // Hero photo (bottom corners 24) with a dark top shade so the
          // white app bar stays readable.
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(AppRadius.modal),
            ),
            child: Image.asset(
              AppImages.truckRoad,
              height: _heroH + top,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: _shadeH + top,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.heroShade, AppColors.heroShadeEnd],
              ),
            ),
          ),
          body,
        ],
      ),
    );
  }
}
