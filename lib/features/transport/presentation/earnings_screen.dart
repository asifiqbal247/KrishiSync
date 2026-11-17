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
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../auth/data/user_repository.dart';
import '../../profile/presentation/payment_method_screens.dart' show payoutLine;
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
          // A purchase order's farms are one trip (one row, whole fare).
          final history = Trip.group(
            jobs.where(
              (j) => j.status.isActive || j.status == DeliveryStatus.delivered,
            ),
          ).toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.contentTop,
              AppSpacing.screen,
              AppSpacing.s2xl,
            ),
            children: [
              Row(
                children: [
                  Expanded(
                    child: KsStatCard(
                      label: l.trThisWeek,
                      value: tk(weekTotal),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: KsStatCard(
                      label: l.trPendingPay,
                      value: tk(pending),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.block),
              KsBarChart(values: week, labels: weekLabels(l)),
              const SizedBox(height: AppSpacing.block),
              KsSectionHeader(
                title: l.earnHistory,
                actionLabel: l.seeAllLink,
                onAction: () => context.push(Routes.history),
              ),
              if (history.isEmpty) ...[
                const SizedBox(height: AppSpacing.block),
                Text(
                  l.earnEmpty,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.normal.withColor(
                    AppColors.textSecondary,
                  ),
                ),
              ],
              for (final t in history) ...[
                const SizedBox(height: AppSpacing.block),
                KsListItem(
                  thumb: KsNetImage(
                    url: t.lead.photo,
                    thumbSize: KsListItem.thumbSize.round(),
                    fallbackAsset: CropCatalog.imageFor(t.lead.cropKey),
                  ),
                  title: l.noOrderCrop(t.no, t.lead.cropName(lang)),
                  subtitle: t.delivered ? l.earnPaidSub : l.earnHeldSub,
                  trailingText: tk(t.fare ?? fareOf(t.lead)),
                  // Paid → 181 fare receipt; held → 180 payment status.
                  onTap: () => context.push(
                    t.delivered
                        ? Routes.receipt(t.lead.orderId)
                        : Routes.trPayStatus(t.lead.id),
                  ),
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

/// 180 Payment Secured (Figma 292:1874): the fare waits in safe payment
/// and is released when the buyer gives the delivery code.
class PayStatusScreen extends ConsumerWidget {
  const PayStatusScreen({super.key, required this.deliveryId});
  final String deliveryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    final t = ref.watch(tripProvider(deliveryId));
    if (t == null || me == null) {
      return Scaffold(
        appBar: KsAppBar(title: l.payStatusTitle),
        body: const KsSkeletonList(rows: 3),
      );
    }
    final d = t.lead;
    final booked = d.timeline['assigned'];
    final delivered = t.delivered ? d.timeline['delivered'] : null;
    String when(DateTime? at) =>
        at == null ? l.stepWaiting : Fmt.date(context, at);
    final pm = me.defaultPayout;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.payStatusTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.contentTop,
          AppSpacing.screen,
          AppSpacing.lg,
        ),
        children: [
          const SizedBox(height: AppSpacing.block),
          Text(
            Fmt.taka(context, t.fare ?? fareOf(d)),
            textAlign: TextAlign.center,
            style: AppTypography.display28.normal,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            t.delivered ? l.paySentLine : l.payHeldLine,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.normal.withColor(
              AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.block),
          KsTimelineItem(
            title: l.payStepCustomer,
            subtitle: when(booked),
            done: booked != null,
          ),
          const SizedBox(height: AppSpacing.block),
          KsTimelineItem(
            title: l.payStepDelivered,
            subtitle: when(delivered),
            done: delivered != null,
          ),
          const SizedBox(height: AppSpacing.block),
          KsTimelineItem(
            title: l.payStepSent,
            subtitle: when(delivered),
            done: delivered != null,
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              KsLinkRow(
                label: l.rowPayMethod,
                value: pm == null ? l.pmNone : payoutLine(l, pm),
                onTap: () => context.push(Routes.paymentMethods),
              ),
            ],
          ),
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          KsButton.outline(
            label: l.getHelp,
            onPressed: () => context.push(Routes.help),
          ),
        ],
      ),
    );
  }
}
