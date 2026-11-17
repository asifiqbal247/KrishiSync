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
import '../../../shared/widgets/ks_skeleton.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../data/transport_repository.dart';
import '../domain/delivery.dart';
import 'nav_screens.dart' show routeKm, driveTime;
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

    bool keep(Trip t) => switch (_f) {
      _LoadFilter.all => true,
      _LoadFilter.nearby =>
        (distanceKm(base, t.lead.pickup.geo) ?? 1e9) <=
            TransporterHomeScreen.nearbyKm,
      _LoadFilter.full => cap > 0 && t.weightKg >= cap * _fullShare,
      // Several farms of one purchase order in one trip.
      _LoadFilter.multi => t.multi,
    };

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(
        title: widget.returnOnly ? l.trReturnLoads : l.loadsTitle,
      ),
      body: switch (async) {
        AsyncError(:final error) => KsErrorState.from(
          error,
          onRetry: () => ref.invalidate(openLoadsProvider),
        ),
        AsyncData(value: final all) => () {
          final loads = widget.returnOnly
              ? returnLoads(all, (current?.dropoff ?? me?.location)?.district)
              : all;
          final shown = Trip.group(loads).where(keep).toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.contentTop,
              AppSpacing.screen,
              AppSpacing.lg,
            ),
            children: [
              KsRouteMap(
                height: _mapH,
                points: [
                  for (final t in shown)
                    for (final d in t.stops) ?d.pickup.geo,
                ],
              ),
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
                      onTap: () => setState(() => _f = f),
                    ),
                ],
              ),
              if (shown.isEmpty) ...[
                const SizedBox(height: AppSpacing.block),
                Text(
                  l.noLoads,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.normal.withColor(
                    AppColors.textSecondary,
                  ),
                ),
              ],
              for (final t in shown) ...[
                const SizedBox(height: AppSpacing.block),
                LoadTile(
                  d: t.summary,
                  stops: t.stops.length,
                  withDate: widget.returnOnly,
                  onTap: () => context.push(Routes.trLoad(t.lead.id)),
                ),
              ],
            ],
          );
        }(),
        _ => const KsSkeletonList(),
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

  Future<void> _accept(Trip t, AppUser me) async {
    if (!ensureVehicle(context, me)) return;
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await ref
          .read(transportRepositoryProvider)
          .placeTripBid(t, me, t.suggestedFare);
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
    final t = ref.watch(tripProvider(widget.deliveryId));
    if (t == null || me == null) {
      return Scaffold(
        appBar: KsAppBar(title: l.loadDetailsTitle),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final d = t.summary;
    final buyer = ref.watch(userByIdProvider(d.buyerId)).value;
    // My bid on the whole trip = my bids on every farm.
    final myParts = [
      for (final s in t.stops)
        (ref.watch(bidsProvider(s.id)).value ?? const <Bid>[])
            .where((b) => b.transporterId == me.uid)
            .firstOrNull,
    ];
    final mine = myParts.any((b) => b == null)
        ? null
        : myParts.fold<num>(0, (a, b) => a + b!.fare);
    final cap = me.vehicle?.capacityKg;
    final when = d.pickupDate == null ? '' : Fmt.date(context, d.pickupDate!);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.loadDetailsTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.contentTop,
          AppSpacing.screen,
          AppSpacing.lg,
        ),
        children: [
          KsRouteMap(
            height: _mapH,
            from: d.pickup.geo,
            to: d.dropoff.geo,
            points: [for (final s in t.stops.skip(1)) ?s.pickup.geo],
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              KsInfoRow(
                l.rowGoods,
                l.loadSub(d.cropName(lang), qtyKgText(context, d.weightKg)),
              ),
              if (t.multi)
                KsInfoRow(
                  l.fieldPickup,
                  l.pickupsLine(
                    Fmt.digits(context, '${t.stops.length}'),
                    {for (final s in t.stops) districtOf(context, s.pickup)}
                        .join(', '),
                  ),
                )
              else
                KsInfoRow(
                  l.fieldPickup,
                  l.placeDate(placeFull(context, d.pickup), when),
                ),
              KsInfoRow(l.rowDestination, placeFull(context, d.dropoff)),
              // Several farms: the whole way (every farm, then the buyer).
              if (t.multi)
                KsInfoRow(
                  l.rowDistance,
                  () {
                    final km = routeKm(null, t.stops, d.dropoff.geo);
                    return l.nameDot(
                      l.kmOnly(Fmt.number(context, km.round())),
                      driveTime(context, km),
                    );
                  }(),
                )
              else if (d.roadKm != null)
                KsInfoRow(
                  l.rowDistance,
                  l.distanceLine(
                    Fmt.number(context, d.roadKm!),
                    Fmt.number(context, d.hours!),
                  ),
                ),
              KsInfoRow(
                l.rowFare,
                l.fareSafeLine(Fmt.taka(context, d.suggestedFare)),
              ),
              KsInfoRow(
                l.rowCustomer,
                (buyer?.isVerified ?? false)
                    ? l.nameVerified(d.buyerName)
                    : d.buyerName,
              ),
            ],
          ),
          if (cap != null && cap > 0) ...[
            const SizedBox(height: AppSpacing.block),
            Text(
              d.weightKg <= cap
                  ? l.fitsTruck(tonsText(context, cap))
                  : l.tooBigTruck(tonsText(context, cap)),
              style: AppTypography.bodySmall.normal.withColor(
                d.weightKg <= cap
                    ? AppColors.textSecondary
                    : AppColors.textError,
              ),
            ),
          ],
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          if (d.status != DeliveryStatus.open)
            KsNoteBox(
              title: d.transporterId == me.uid
                  ? l.nJobAssigned(d.orderNo)
                  : l.loadTaken,
            )
          else if (mine != null)
            KsNoteBox(title: l.myBidLine(Fmt.taka(context, mine)))
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
              onPressed: () => _accept(t, me),
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

  Future<void> _send(Trip t, AppUser me) async {
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
      await ref.read(transportRepositoryProvider).placeTripBid(t, me, fare);
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
    final t = ref.watch(tripProvider(widget.deliveryId));
    final bids = ref.watch(bidsProvider(widget.deliveryId)).value ?? const [];
    if (t == null || me == null) {
      return Scaffold(
        appBar: KsAppBar(title: l.fareOfferTitle),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final d = t.summary;
    // Other drivers' trip totals: their bids on every farm added up.
    final otherTotals = <String, num>{};
    for (final s in t.stops) {
      for (final b in ref.watch(bidsProvider(s.id)).value ?? const <Bid>[]) {
        if (b.transporterId == me.uid) continue;
        otherTotals[b.transporterId] =
            (otherTotals[b.transporterId] ?? 0) + b.fare;
      }
    }
    final others =
        bids
            .where((b) => b.transporterId != me.uid)
            .map((b) => otherTotals[b.transporterId] ?? b.fare)
            .toList()
          ..sort();
    final when = d.pickupDate == null ? '' : Fmt.date(context, d.pickupDate!);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.fareOfferTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.contentTop,
          AppSpacing.screen,
          AppSpacing.lg,
        ),
        children: [
          KsListItem(
            thumb: Image.asset(AppUi.thumbLoad, fit: BoxFit.cover),
            title: routeOf(context, d),
            subtitle: l.loadSubDate(
              d.cropName(lang),
              tonsText(context, d.weightKg),
              when,
            ),
            showChevron: false,
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              KsInfoRow(
                l.suggestedFareRow,
                l.takaRange(
                  Fmt.number(context, _r100(d.suggestedFare * 0.95)),
                  Fmt.number(context, _r100(d.suggestedFare * 1.05)),
                ),
              ),
              KsInfoRow(
                l.otherBidsRow,
                others.isEmpty
                    ? l.noneYet
                    : l.otherBidsLine(
                        Fmt.digits(context, '${others.length}'),
                        Fmt.taka(context, others.first),
                      ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          KsTextField(
            label: l.yourFare,
            hint: Fmt.number(context, d.suggestedFare),
            controller: _fare,
            suffixText: l.currencySymbol,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯]')),
            ],
            errorText: _err,
          ),
          const SizedBox(height: AppSpacing.block),
          Text(
            l.fareNote,
            style: AppTypography.bodySmall.normal.withColor(
              AppColors.textSecondary,
            ),
          ),
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          KsButton(
            label: l.sendProposal,
            loading: _busy,
            onPressed: () => _send(t, me),
          ),
        ],
      ),
    );
  }
}
