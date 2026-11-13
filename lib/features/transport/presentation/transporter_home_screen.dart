import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/utils/geo.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_home_header.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../../auth/data/user_repository.dart';
import '../data/transport_repository.dart';
import '../domain/delivery.dart';
import 'transport_common.dart';
import 'transporter_shell.dart';

/// 141 Transporter Home (Figma 292:2446). All numbers from real jobs/loads.
class TransporterHomeScreen extends ConsumerWidget {
  const TransporterHomeScreen({super.key});

  /// "Nearby" = within this many km of the driver's base.
  static const nearbyKm = 100.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    final jobs = ref.watch(myDeliveriesProvider).value ?? const <Delivery>[];
    final open = ref.watch(openLoadsProvider).value ?? const <Delivery>[];
    final now = DateTime.now();
    String n(int v) => l.countTi(Fmt.digits(context, '$v'));
    void tab(int i) => ref.read(transporterTabProvider.notifier).go(i);

    final base = me?.vehicle?.base?.geo ?? me?.location.geo;
    double? km(Delivery d) => distanceKm(base, d.pickup.geo);
    final byDistance = [...open]
      ..sort((a, b) => (km(a) ?? 1e9).compareTo(km(b) ?? 1e9));
    final nearbyCount = base == null
        ? open.length
        : open.where((d) => (km(d) ?? 1e9) <= nearbyKm).length;

    final active = jobs.where((j) => j.status.isActive).toList();
    final ongoing = active.isEmpty ? null : active.first;
    final week = weekEarnings(jobs, now);
    final weekTotal = week.fold<num>(0, (a, v) => a + v);
    final today = week[DateTime(now.year, now.month, now.day)
        .difference(weekStart(now))
        .inDays];
    final pending = active.fold<num>(0, (a, j) => a + fareOf(j));
    final returns = returnLoads(open, ongoing?.dropoff.district);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsHomeHeader(
        name: me?.name ?? '',
        photoUrl: me?.photoUrl,
        fallbackAvatar: AppUi.avatarDriver,
        onBell: () => context.push(Routes.notifications),
        onChat: () => KsToast.comingSoon(context),
        onAvatar: () => tab(3),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
            AppSpacing.contentTop, AppSpacing.screen, AppSpacing.s2xl),
        children: [
          Row(children: [
            Expanded(
                child: KsStatCard(
                    label: l.trStatToday,
                    value: Fmt.taka(context, today),
                    onTap: () => tab(2))),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
                child: KsStatCard(
                    label: l.trStatOngoing,
                    value: n(active.length),
                    onTap: () => tab(1))),
          ]),
          if (ongoing != null) ...[
            const SizedBox(height: AppSpacing.block),
            KsListItem(
              highlighted: true,
              thumb: Image.asset(AppUi.thumbTrip, fit: BoxFit.cover),
              title: l.trOngoingTitle(ongoing.orderNo),
              subtitle: l.trOngoingSub(Fmt.digits(context, '1'),
                  deliveryStatusLabel(l, ongoing.status)),
              trailingText: l.trContinue,
              onTap: () => context.push(Routes.trTrip(ongoing.id)),
            ),
          ],
          const SizedBox(height: AppSpacing.block),
          KsSectionHeader(title: l.trWhatToDo),
          const SizedBox(height: AppSpacing.block),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: KsActionTile(
                primary: true,
                icon: AppUi.glyphBox,
                title: l.trFindLoads,
                hint: l.trFindLoadsSub(Fmt.digits(context, '$nearbyCount')),
                onTap: () => context.push(Routes.trLoads),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: KsActionTile(
                icon: AppUi.glyphTruck,
                title: l.trMyJobs,
                hint: l.trMyJobsSub(Fmt.digits(context, '${active.length}')),
                onTap: () => tab(1),
              ),
            ),
          ]),
          const SizedBox(height: AppSpacing.block),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: KsActionTile(
                icon: AppUi.glyphMap,
                title: l.trReturnLoads,
                hint: l.trReturnLoadsSub,
                onTap: () => context.push(Routes.trReturnLoads),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: KsActionTile(
                icon: AppUi.glyphWallet,
                title: l.trEarnings,
                hint: l.trEarningsSub(Fmt.taka(context, weekTotal)),
                onTap: () => tab(2),
              ),
            ),
          ]),
          const SizedBox(height: AppSpacing.block),
          KsSectionHeader(
            title: l.trNearbyLoads,
            actionLabel: l.seeAllLink,
            onAction: () => context.push(Routes.trLoads),
          ),
          if (byDistance.isEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            KsListItem(title: l.noLoads, showChevron: false),
          ],
          for (final d in byDistance.take(3)) ...[
            const SizedBox(height: AppSpacing.block),
            LoadTile(d: d, onTap: () => context.push(Routes.trLoad(d.id))),
          ],
          if (returns.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            KsSectionHeader(
              title: l.trReturnChances,
              actionLabel: l.seeAllLink,
              onAction: () => context.push(Routes.trReturnLoads),
            ),
            const SizedBox(height: AppSpacing.block),
            LoadTile(
              d: returns.first,
              highlighted: true,
              withDate: true,
              onTap: () => context.push(Routes.trLoad(returns.first.id)),
            ),
          ],
          const SizedBox(height: AppSpacing.block),
          KsSectionHeader(
            title: l.trWeekEarnings,
            actionLabel: l.seeAllLink,
            onAction: () => tab(2),
          ),
          const SizedBox(height: AppSpacing.block),
          KsBarChart(values: week, labels: weekLabels(l)),
          const SizedBox(height: AppSpacing.block),
          Row(children: [
            Expanded(
                child: KsStatCard(
                    label: l.trThisWeek,
                    value: Fmt.taka(context, weekTotal),
                    onTap: () => tab(2))),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
                child: KsStatCard(
                    label: l.trPendingPay,
                    value: Fmt.taka(context, pending),
                    onTap: () => tab(1))),
          ]),
        ],
      ),
    );
  }
}
