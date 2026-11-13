import 'package:flutter/services.dart';
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
import '../../../shared/utils/geo.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_states.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../data/transport_repository.dart';
import '../domain/delivery.dart';
import 'transport_common.dart';
import 'transporter_home_screen.dart';

enum _LoadFilter { all, nearby, full, multi }

/// 143 Available Loads (Figma 292:1673). [returnOnly]: loads that start in
/// the drop district of the driver's current job ("ফিরতি লোড").
class LoadsScreen extends ConsumerStatefulWidget {
  const LoadsScreen({super.key, this.returnOnly = false});
  final bool returnOnly;

  @override
  ConsumerState<LoadsScreen> createState() => _LoadsScreenState();
}

class _LoadsScreenState extends ConsumerState<LoadsScreen> {
  _LoadFilter _f = _LoadFilter.all;
  static const _mapH = 126.0;

  /// A load counts as "full" when it fills at least 70% of the truck.
  static const _fullShare = 0.7;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    final async = ref.watch(openLoadsProvider);
    final jobs = ref.watch(myDeliveriesProvider).value ?? const <Delivery>[];
    final base = me?.vehicle?.base?.geo ?? me?.location.geo;
    final cap = me?.vehicle?.capacityKg ?? 0;
    final current = jobs.where((j) => j.status.isActive).firstOrNull;

    bool keep(Delivery d) => switch (_f) {
          _LoadFilter.all => true,
          _LoadFilter.nearby => (distanceKm(base, d.pickup.geo) ?? 1e9) <=
              TransporterHomeScreen.nearbyKm,
          _LoadFilter.full => cap > 0 && d.weightKg >= cap * _fullShare,
          // Pooling several farms in one trip is Tier C.
          _LoadFilter.multi => false,
        };

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(
          title: widget.returnOnly ? l.trReturnLoads : l.loadsTitle),
      body: switch (async) {
        AsyncError(:final error) => KsErrorState.from(error,
            onRetry: () => ref.invalidate(openLoadsProvider)),
        AsyncData(value: final all) => () {
            var shown = widget.returnOnly
                ? returnLoads(all, (current?.dropoff ?? me?.location)?.district)
                : all;
            shown = shown.where(keep).toList();
            return ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
                  AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
              children: [
                KsRouteMap(
                    height: _mapH,
                    points: [for (final d in shown) ?d.pickup.geo]),
                const SizedBox(height: AppSpacing.block),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final (f, label) in [
                      (_LoadFilter.all, l.filterAll),
                      (_LoadFilter.nearby, l.filterNearby),
                      (_LoadFilter.full, l.filterFullLoad),
                      (_LoadFilter.multi, l.filterMultiPickup),
                    ])
                      KsPill(
                          label: label,
                          selected: _f == f,
                          onTap: () => setState(() => _f = f)),
                  ],
                ),
                if (shown.isEmpty) ...[
                  const SizedBox(height: AppSpacing.block),
                  Text(l.noLoads,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.normal
                          .withColor(AppColors.textSecondary)),
                ],
                for (final d in shown) ...[
                  const SizedBox(height: AppSpacing.block),
                  LoadTile(
                      d: d,
                      withDate: widget.returnOnly,
                      onTap: () => context.push(Routes.trLoad(d.id))),
                ],
              ],
            );
          }(),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

/// Opens the vehicle form when the driver has no truck saved yet.
bool ensureVehicle(BuildContext context, AppUser? me) {
  if (me?.vehicle != null) return true;
  KsToast.show(context, AppLocalizations.of(context).vehicleNeeded);
  context.push(Routes.trVehicle);
  return false;
}

/// 144 Load Details (Figma 292:1687).
class LoadDetailsScreen extends ConsumerStatefulWidget {
  const LoadDetailsScreen({super.key, required this.deliveryId});
  final String deliveryId;

  @override
  ConsumerState<LoadDetailsScreen> createState() => _LoadDetailsScreenState();
}

class _LoadDetailsScreenState extends ConsumerState<LoadDetailsScreen> {
  bool _busy = false;
  static const _mapH = 146.0;

  Future<void> _accept(Delivery d, AppUser me) async {
    if (!ensureVehicle(context, me)) return;
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(transportRepositoryProvider).placeBid(d, me, d.suggestedFare);
      if (mounted) KsToast.show(context, l.bidSent);
    } catch (_) {
      if (mounted) KsToast.show(context, l.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    final d = ref.watch(deliveryProvider(widget.deliveryId)).value;
    final bids = ref.watch(bidsProvider(widget.deliveryId)).value ?? const [];
    if (d == null || me == null) {
      return Scaffold(
        appBar: KsAppBar(title: l.loadDetailsTitle),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final buyer = ref.watch(userByIdProvider(d.buyerId)).value;
    final mine = bids.where((b) => b.transporterId == me.uid).firstOrNull;
    final cap = me.vehicle?.capacityKg;
    final when = d.pickupDate == null ? '' : Fmt.date(context, d.pickupDate!);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.loadDetailsTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
            AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
        children: [
          KsRouteMap(height: _mapH, from: d.pickup.geo, to: d.dropoff.geo),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(children: [
            KsInfoRow(l.rowGoods,
                l.loadSub(d.cropName(lang), qtyKgText(context, d.weightKg))),
            KsInfoRow(l.fieldPickup, l.placeDate(placeFull(context, d.pickup), when)),
            KsInfoRow(l.rowDestination, placeFull(context, d.dropoff)),
            if (d.roadKm != null)
              KsInfoRow(
                  l.rowDistance,
                  l.distanceLine(Fmt.number(context, d.roadKm!),
                      Fmt.number(context, d.hours!))),
            KsInfoRow(l.rowFare,
                l.fareSafeLine(Fmt.taka(context, d.suggestedFare))),
            KsInfoRow(
                l.rowCustomer,
                (buyer?.isVerified ?? false)
                    ? l.nameVerified(d.buyerName)
                    : d.buyerName),
          ]),
          if (cap != null && cap > 0) ...[
            const SizedBox(height: AppSpacing.block),
            Text(
              d.weightKg <= cap
                  ? l.fitsTruck(tonsText(context, cap))
                  : l.tooBigTruck(tonsText(context, cap)),
              style: AppTypography.bodySmall.normal.withColor(
                  d.weightKg <= cap ? AppColors.textSecondary : AppColors.textError),
            ),
          ],
          const SizedBox(
              height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
          if (d.status != DeliveryStatus.open)
            KsNoteBox(
                title: d.transporterId == me.uid
                    ? l.nJobAssigned(d.orderNo)
                    : l.loadTaken)
          else if (mine != null)
            KsNoteBox(title: l.myBidLine(Fmt.taka(context, mine.fare)))
          else ...[
            KsButton.secondary(
              label: l.sendFareOffer,
              onPressed: _busy
                  ? null
                  : () {
                      if (ensureVehicle(context, me)) {
                        context.push(Routes.trFareOffer(d.id));
                      }
                    },
            ),
            const SizedBox(height: AppSpacing.block),
            KsButton(
              label: l.acceptJob,
              loading: _busy,
              onPressed: () => _accept(d, me),
            ),
          ],
        ],
      ),
    );
  }
}

/// "৪৫০০ কেজি" (144 shows kg, not tons).
String qtyKgText(BuildContext context, num kg) =>
    AppLocalizations.of(context).qtyKg(Fmt.number(context, kg));

/// 145 Freight Offer (Figma 292:3321).
class FareOfferScreen extends ConsumerStatefulWidget {
  const FareOfferScreen({super.key, required this.deliveryId});
  final String deliveryId;

  @override
  ConsumerState<FareOfferScreen> createState() => _FareOfferScreenState();
}

class _FareOfferScreenState extends ConsumerState<FareOfferScreen> {
  final _fare = TextEditingController();
  String? _err;
  bool _busy = false;

  @override
  void dispose() {
    _fare.dispose();
    super.dispose();
  }

  static num _r100(num v) => (v / 100).round() * 100;

  Future<void> _send(Delivery d, AppUser me) async {
    final l = AppLocalizations.of(context);
    final fare = num.tryParse(Fmt.latinDigits(_fare.text.trim()));
    if (fare == null || fare <= 0) {
      setState(() => _err = l.errFareInvalid);
      return;
    }
    setState(() {
      _err = null;
      _busy = true;
    });
    try {
      await ref.read(transportRepositoryProvider).placeBid(d, me, fare);
      if (!mounted) return;
      KsToast.show(context, l.bidSent);
      context.pop();
    } catch (_) {
      if (mounted) KsToast.show(context, l.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    final d = ref.watch(deliveryProvider(widget.deliveryId)).value;
    final bids = ref.watch(bidsProvider(widget.deliveryId)).value ?? const [];
    if (d == null || me == null) {
      return Scaffold(
        appBar: KsAppBar(title: l.fareOfferTitle),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final others = bids.where((b) => b.transporterId != me.uid).toList();
    final when = d.pickupDate == null ? '' : Fmt.date(context, d.pickupDate!);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.fareOfferTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
            AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
        children: [
          KsListItem(
            thumb: Image.asset(AppUi.thumbLoad, fit: BoxFit.cover),
            title: routeOf(context, d),
            subtitle: l.loadSubDate(
                d.cropName(lang), tonsText(context, d.weightKg), when),
            showChevron: false,
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(children: [
            KsInfoRow(
                l.suggestedFareRow,
                l.takaRange(Fmt.number(context, _r100(d.suggestedFare * 0.95)),
                    Fmt.number(context, _r100(d.suggestedFare * 1.05)))),
            KsInfoRow(
                l.otherBidsRow,
                others.isEmpty
                    ? l.noneYet
                    : l.otherBidsLine(Fmt.digits(context, '${others.length}'),
                        Fmt.taka(context, others.first.fare))),
          ]),
          const SizedBox(height: AppSpacing.block),
          KsTextField(
            label: l.yourFare,
            hint: Fmt.number(context, d.suggestedFare),
            controller: _fare,
            suffixText: l.currencySymbol,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯]'))
            ],
            errorText: _err,
          ),
          const SizedBox(height: AppSpacing.block),
          Text(l.fareNote,
              style: AppTypography.bodySmall.normal
                  .withColor(AppColors.textSecondary)),
          const SizedBox(
              height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
          KsButton(
            label: l.sendProposal,
            loading: _busy,
            onPressed: () => _send(d, me),
          ),
        ],
      ),
    );
  }
}
