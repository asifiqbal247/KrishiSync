import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/data/trade_stats_repository.dart';
import '../../../shared/services/bd_location_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../auth/data/user_repository.dart';
import 'transport_common.dart';

/// 80 Buyer – Transporter Profile (Figma 292:3187): a driver's verified
/// status, track record (stats/{uid}) and truck. Opened from a bid on Book
/// Truck (79) with [pick] — "choose this transporter" returns true — or
/// from the assigned-truck card (view only).
class TransporterProfileScreen extends ConsumerWidget {
  const TransporterProfileScreen({
    super.key,
    required this.uid,
    this.pick = false,
  });
  final String uid;
  final bool pick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final u = ref.watch(userByIdProvider(uid)).value;
    final s = ref.watch(tradeStatsProvider(uid)).value ?? TradeStats.empty;
    if (u == null) {
      return Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(title: l.tpProfileTitle),
        body: const KsSkeletonList(rows: 3),
      );
    }
    // "5%", or "0.5%" when it has a fraction.
    String pct(num? v) => v == null
        ? l.notAvailable
        : l.pctText(
            Fmt.digits(
              context,
              v == v.roundToDouble() ? '${v.round()}' : v.toStringAsFixed(1),
            ),
          );
    final v = u.vehicle;
    final since = u.createdAt == null
        ? null
        : l.tpSince(
            Fmt.digits(context, DateFormat.yMMM(lang).format(u.createdAt!)),
          );

    Widget stat(String label, String value) => Expanded(
      child: KsStatCard(label: label, value: value),
    );

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.tpProfileTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.contentTop,
          AppSpacing.screen,
          AppSpacing.lg,
        ),
        children: [
          KsListItem(
            thumb: KsNetImage(
              url: u.photoUrl,
              thumbSize: KsListItem.thumbSize.round(),
              fallbackAsset: AppUi.avatarDriver,
            ),
            title: u.name,
            subtitle: [
              u.isVerified ? l.tpVerifiedDriver : l.tpDriver,
              ?since,
            ].join(' · '),
            trailingText: u.ratingCount == 0
                ? l.notAvailable
                : Fmt.number(context, u.ratingAvg, decimals: 1),
            showChevron: false,
          ),
          const SizedBox(height: AppSpacing.block),
          Row(
            children: [
              stat(l.tpTrips, l.countTi(Fmt.digits(context, '${s.done}'))),
              const SizedBox(width: AppSpacing.md),
              stat(l.tpOnTime, pct(s.onTimePct)),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          Row(
            children: [
              stat(l.tpCancelRate, pct(s.cancelPct)),
              const SizedBox(width: AppSpacing.md),
              stat(l.tpDamage, pct(s.complaintPct)),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              KsInfoRow(
                l.rowTruck,
                v == null
                    ? l.notAvailable
                    : l.tpTruckLine(
                        vehicleTypeLabel(l, v.type),
                        tonsText(context, v.capacityKg),
                        u.isVerified ? l.verifiedBadge : l.notVerified,
                      ),
                boldValue: true,
              ),
              KsInfoRow(
                l.tpFitness,
                u.isVerified ? l.tpValid : l.notVerified,
                boldValue: true,
              ),
              KsInfoRow(
                l.tpMainRoute,
                s.topFrom == null
                    ? l.notAvailable
                    : l.tpRoute(
                        BdPlace.display(s.topFrom, lang),
                        BdPlace.display(s.topTo, lang),
                      ),
                boldValue: true,
              ),
            ],
          ),
          if (pick) ...[
            const SizedBox(
              height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
            ),
            KsButton(label: l.tpChoose, onPressed: () => context.pop(true)),
          ],
        ],
      ),
    );
  }
}
