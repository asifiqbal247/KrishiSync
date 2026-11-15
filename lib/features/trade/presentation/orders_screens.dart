import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_states.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../buyer/presentation/buyer_common.dart';
import '../../transport/data/transport_repository.dart';
import '../data/trade_repository.dart';
import '../domain/trade_models.dart';

(String, Color, Color) orderBadge(AppLocalizations l, OrderStatus s) =>
    switch (s) {
      OrderStatus.confirmed => (
        l.orderStatusConfirmed,
        AppColors.bgSuccessSubtle,
        AppColors.textSuccess,
      ),
      OrderStatus.transportBooked => (
        l.orderStatusTransportBooked,
        AppColors.bgSuccessSubtle,
        AppColors.textSuccess,
      ),
      OrderStatus.pickedUp => (
        l.orderStatusPickedUp,
        AppColors.bgWarningSubtle,
        AppColors.textWarning,
      ),
      OrderStatus.inTransit => (
        l.orderStatusInTransit,
        AppColors.bgWarningSubtle,
        AppColors.textWarning,
      ),
      OrderStatus.delivered => (
        l.orderStatusDelivered,
        AppColors.bgSuccessSubtle,
        AppColors.textSuccess,
      ),
      OrderStatus.completed => (
        l.orderStatusCompleted,
        AppColors.bgMuted,
        AppColors.textSecondary,
      ),
      OrderStatus.cancelled => (
        l.orderStatusCancelled,
        AppColors.bgErrorSubtle,
        AppColors.textError,
      ),
    };

enum _Tab { all, ongoing, done, cancelled }

/// 40 Orders (farmer) / 105 Orders (buyer) — Figma 292:683.
class OrdersTab extends ConsumerStatefulWidget {
  const OrdersTab({super.key, this.onBack});
  final VoidCallback? onBack;

  @override
  ConsumerState<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends ConsumerState<OrdersTab> {
  _Tab _tab = _Tab.all;

  bool _in(TradeOrder o) => switch (_tab) {
    _Tab.all => true,
    _Tab.ongoing => o.status.isOngoing,
    _Tab.done =>
      o.status == OrderStatus.completed || o.status == OrderStatus.delivered,
    _Tab.cancelled => o.status == OrderStatus.cancelled,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final async = ref.watch(myOrdersProvider);
    final tabs = [
      (_Tab.all, l.ordersTabAll),
      (_Tab.ongoing, l.ordersTabOngoing),
      (_Tab.done, l.ordersTabDone),
      (_Tab.cancelled, l.ordersTabCancelled),
    ];
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(
        title: l.ordersTitle,
        showBack: widget.onBack != null,
        onBack: widget.onBack,
      ),
      body: switch (async) {
        AsyncError(:final error) => KsErrorState.from(
          error,
          onRetry: () => ref.invalidate(myOrdersProvider),
        ),
        AsyncData(value: final all) when all.isEmpty => _empty(l),
        _ => ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.contentTop,
            AppSpacing.screen,
            AppSpacing.lg,
          ),
          children: [
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final (t, label) in tabs)
                  KsPill(
                    label: label,
                    selected: _tab == t,
                    onTap: () => setState(() => _tab = t),
                  ),
              ],
            ),
            ...async.when(
              loading: () => [
                const SizedBox(height: AppSpacing.block),
                const KsSkeletonList(padded: false),
              ],
              error: (_, _) => const [],
              data: (all) {
                final shown = all.where(_in).toList();
                if (shown.isEmpty) {
                  return [
                    const SizedBox(height: AppSpacing.block),
                    Text(
                      l.emptyFilter,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.normal.withColor(
                        AppColors.textSecondary,
                      ),
                    ),
                  ];
                }
                return [
                  for (final o in shown) ...[
                    const SizedBox(height: AppSpacing.block),
                    () {
                      final (badge, bg, fg) = orderBadge(l, o.status);
                      return KsListItem(
                        thumb: KsNetImage(
                          url: o.photo,
                          thumbSize: KsListItem.thumbSize.round(),
                          fallbackAsset: CropCatalog.imageFor(o.cropKey),
                        ),
                        title: o.cropName(lang),
                        subtitle: l.qtyPrice(
                          qtyText(context, o.quantityKg),
                          Fmt.number(context, o.pricePerKg),
                        ),
                        badge: badge,
                        badgeColor: bg,
                        badgeTextColor: fg,
                        onTap: () => context.push(Routes.order(o.id)),
                      );
                    }(),
                  ],
                ];
              },
            ),
          ],
        ),
      },
    );
  }

  /// 41 Empty State (292:409). Farmer: sell crop. Buyer: go to market.
  Widget _empty(AppLocalizations l) {
    final isFarmer =
        ref.watch(currentUserProvider).value?.role == UserRole.farmer;
    return KsEmptyState(
      title: l.emptyOrdersTitle,
      body: isFarmer ? l.emptyOrdersFarmerBody : l.emptyOrdersBuyerBody,
      ctaLabel: isFarmer ? l.homeSellCrop : l.emptyOrdersBuyerCta,
      onCta: isFarmer
          ? () => context.push(Routes.farmerSell)
          : () => ref.read(buyerTabProvider.notifier).go(1),
    );
  }
}

/// 42 Order Details (farmer) / 106 (buyer) — Figma 292:696.
class OrderDetailsScreen extends ConsumerWidget {
  const OrderDetailsScreen({super.key, required this.orderId});
  final String orderId;

  /// The next step for this person, or null when there is none (Part 6).
  Widget? _action(BuildContext context, WidgetRef ref, AppLocalizations l,
      TradeOrder o, bool iAmFarmer) {
    final platform = o.transportMode == TransportMode.platform;
    final repo = ref.read(transportRepositoryProvider);

    Future<void> confirmThen(
        String title, String body, Future<void> Function() run) async {
      final ok = await showKsConfirm(context,
          title: title,
          body: body,
          noLabel: l.commonCancel,
          yesLabel: l.yesConfirm,
          positive: true);
      if (!ok) return;
      try {
        await run();
      } catch (_) {
        if (context.mounted) KsToast.show(context, l.errorGeneric);
      }
    }

    KsButton go(String label, String route) =>
        KsButton(label: label, onPressed: () => context.push(route));

    if (iAmFarmer) {
      if (!platform && o.status == OrderStatus.confirmed) {
        return KsButton(
          label: l.handedOver,
          onPressed: () => confirmThen(l.handedOverTitle, l.handedOverBody,
              () => repo.farmerHandedOver(o)),
        );
      }
      return null;
    }
    return switch (o.status) {
      OrderStatus.confirmed when platform =>
        go(l.orderBookTruck, Routes.buyerBook(o.id)),
      OrderStatus.transportBooked || OrderStatus.pickedUp when platform =>
        go(l.orderReceive, Routes.buyerReceive(o.id)),
      OrderStatus.pickedUp => KsButton(
          label: l.receivedSelf,
          onPressed: () => confirmThen(
              l.receivedTitle, l.receivedBody, () => repo.buyerReceived(o)),
        ),
      OrderStatus.delivered => go(l.orderRate, Routes.buyerRate(o.id)),
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    final o = ref.watch(orderProvider(orderId)).value;
    if (o == null || me == null) {
      return Scaffold(
        appBar: KsAppBar(title: l.orderDetailsTitle),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final iAmFarmer = me.uid == o.farmerId;
    final (badge, bg, fg) = orderBadge(l, o.status);

    String when(DateTime? d) {
      if (d == null) return l.stepWaiting;
      final time = Fmt.digits(context, DateFormat('H:mm').format(d));
      return l.dateTime(Fmt.date(context, d), time);
    }

    final reached = OrderStatus.values.indexOf(o.status);
    // A step is done if it happened, even when the order was cancelled later.
    bool done(OrderStatus s) =>
        o.timeline.containsKey(s.name) ||
        (o.status != OrderStatus.cancelled &&
            reached >= OrderStatus.values.indexOf(s));
    void soon() => KsToast.comingSoon(context);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.orderDetailsTitle),
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
              url: o.photo,
              thumbSize: KsListItem.thumbSize.round(),
              fallbackAsset: CropCatalog.imageFor(o.cropKey),
            ),
            title: l.cropQtyTitle(
              o.cropName(lang),
              qtyText(context, o.quantityKg),
            ),
            subtitle: l.orderNoLine(o.orderNo),
            badge: badge,
            badgeColor: bg,
            badgeTextColor: fg,
            showChevron: false,
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              KsLinkRow(
                label: iAmFarmer ? l.rowBuyer : l.rowFarmer,
                value: iAmFarmer ? o.buyerName : o.farmerName,
                onTap: () => context.push(iAmFarmer
                    ? Routes.buyerProfile(o.buyerId)
                    : Routes.buyerFarmer(o.farmerId)),
              ),
              KsInfoRow(
                l.offerTotal,
                Fmt.taka(context, iAmFarmer ? o.cropTotal : o.total),
              ),
              KsInfoRow(
                l.rowPayment,
                o.paymentStatus == 'unpaid' ? l.paymentPending : l.paymentHeld,
              ),
              if (o.pickupDate != null)
                KsLinkRow(
                  label: iAmFarmer ? l.rowLoadAndMoney : l.rowPickupDate,
                  value: Fmt.date(context, o.pickupDate!),
                  onTap: soon,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          KsSectionHeader(title: l.orderStatusSection),
          const SizedBox(height: AppSpacing.block),
          KsTimelineItem(
            title: l.stepConfirmed,
            subtitle: when(o.timeline['confirmed'] ?? o.createdAt),
            done: done(OrderStatus.confirmed),
          ),
          const SizedBox(height: AppSpacing.block),
          KsTimelineItem(
            title: o.transportMode == TransportMode.self
                ? l.stepTruckBookedSelf
                : l.stepTruckBooked,
            // Self transport has no booking step: show the order time.
            subtitle: when(o.timeline['transportBooked'] ??
                (o.transportMode == TransportMode.self
                    ? o.timeline['confirmed']
                    : null)),
            done: done(OrderStatus.transportBooked),
            onTap: !iAmFarmer &&
                    o.transportMode == TransportMode.platform &&
                    o.transporterId != null
                ? () => context.push(Routes.buyerAssigned(o.id))
                : null,
          ),
          const SizedBox(height: AppSpacing.block),
          KsTimelineItem(
            title: iAmFarmer ? l.stepLoaded : l.stepLoadedBuyer,
            subtitle: when(o.timeline['pickedUp']),
            done: done(OrderStatus.pickedUp),
          ),
          const SizedBox(height: AppSpacing.block),
          KsTimelineItem(
            title: l.stepDelivered,
            subtitle: when(o.timeline['delivered']),
            done: done(OrderStatus.delivered),
          ),
          const SizedBox(height: AppSpacing.block),
          KsListItem(
            title: l.orderProblem,
            subtitle: l.orderProblemSub,
            onTap: () => context.push(Routes.report(orderId: o.id)),
          ),
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          ?_action(context, ref, l, o, iAmFarmer),
          // D5: buyer may cancel until the crop is loaded.
          if (!iAmFarmer &&
              (o.status == OrderStatus.confirmed ||
                  o.status == OrderStatus.transportBooked)) ...[
            const SizedBox(height: AppSpacing.block),
            KsButton.text(
              label: l.cancelOrder,
              onPressed: () async {
                final fee = TradeRepository.cancelFee(o);
                final ok = await showKsConfirm(context,
                    title: l.cancelOrderTitle,
                    body: fee == 0
                        ? l.cancelOrderBodyNoFee(Fmt.taka(context, o.total))
                        : l.cancelOrderBody(Fmt.taka(context, fee),
                            Fmt.taka(context, o.total - fee)),
                    noLabel: l.noGoBack,
                    yesLabel: l.yesCancel);
                if (!ok) return;
                try {
                  await ref
                      .read(tradeRepositoryProvider)
                      .cancelOrder(o, me.uid);
                  if (context.mounted) KsToast.show(context, l.orderCancelled);
                } catch (_) {
                  if (context.mounted) KsToast.show(context, l.errorGeneric);
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}
