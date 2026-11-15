import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../data/transport_repository.dart';
import '../domain/delivery.dart';
import 'transport_common.dart';

/// 178 Earnings (Figma 292:1855) — the transporter's "আয়" tab.
/// Paid = delivered trips; pending = booked trips not yet delivered.
class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final async = ref.watch(myDeliveriesProvider);
    String tk(num v) => Fmt.taka(context, v);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.earnTitle, showBack: false),
      body: switch (async) {
        AsyncData(value: final jobs) => () {
            final week = weekEarnings(jobs, DateTime.now());
            final weekTotal = week.fold<num>(0, (a, v) => a + v);
            final pending = jobs
                .where((j) => j.status.isActive)
                .fold<num>(0, (a, j) => a + fareOf(j));
            final history = jobs
                .where((j) =>
                    j.status.isActive || j.status == DeliveryStatus.delivered)
                .toList();
            return ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
                  AppSpacing.contentTop, AppSpacing.screen, AppSpacing.s2xl),
              children: [
                Row(children: [
                  Expanded(
                      child: KsStatCard(
                          label: l.trThisWeek, value: tk(weekTotal))),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                      child: KsStatCard(
                          label: l.trPendingPay, value: tk(pending))),
                ]),
                const SizedBox(height: AppSpacing.block),
                KsBarChart(values: week, labels: weekLabels(l)),
                const SizedBox(height: AppSpacing.block),
                KsSectionHeader(title: l.earnHistory),
                if (history.isEmpty) ...[
                  const SizedBox(height: AppSpacing.block),
                  Text(l.earnEmpty,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.normal
                          .withColor(AppColors.textSecondary)),
                ],
                for (final j in history) ...[
                  const SizedBox(height: AppSpacing.block),
                  KsListItem(
                    thumb: KsNetImage(
                        url: j.photo,
                        thumbSize: KsListItem.thumbSize.round(),
                        fallbackAsset: CropCatalog.imageFor(j.cropKey)),
                    title: l.noOrderCrop(j.orderNo, j.cropName(lang)),
                    subtitle: j.status == DeliveryStatus.delivered
                        ? l.earnPaidSub
                        : l.earnHeldSub,
                    trailingText: tk(fareOf(j)),
                    onTap: () => context.push(Routes.receipt(j.orderId)),
                  ),
                ],
              ],
            );
          }(),
        AsyncError() => Center(child: Text(l.errorGeneric)),
        _ => const KsSkeletonList(),
      },
    );
  }
}
