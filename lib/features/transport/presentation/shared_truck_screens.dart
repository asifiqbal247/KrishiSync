import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../../shared/widgets/ks_states.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../buyer/presentation/supplier_screens.dart' show ProgressRow;
import '../data/live_location.dart';
import '../data/transport_repository.dart';
import '../domain/delivery.dart';
import 'loads_screens.dart' show qtyKgText;
import 'transport_common.dart';

const _pad = EdgeInsets.fromLTRB(
  AppSpacing.screen,
  AppSpacing.contentTop,
  AppSpacing.screen,
  AppSpacing.lg,
);

/// A load is "on the route" when its farm is at most this far off the
/// truck's way and it ends near the same buyer area.
const _offRouteKm = 30.0;
const _nearDropKm = 60.0;

/// Below this extra distance the farm counts as "রুটেই" (on the way).
const _onRouteKm = 3;

/// Distance (km) from [p] to the segment a–b (flat-earth, fine for BD).
double _toSegmentKm(GeoPoint p, GeoPoint a, GeoPoint b) {
  const kmPerDeg = 111.32;
  final cosLat = cos(p.latitude * pi / 180);
  double x(GeoPoint g) => g.longitude * kmPerDeg * cosLat;
  double y(GeoPoint g) => g.latitude * kmPerDeg;
  final ax = x(a), ay = y(a), bx = x(b), by = y(b), px = x(p), py = y(p);
  final dx = bx - ax, dy = by - ay;
  final len2 = dx * dx + dy * dy;
  final t = len2 == 0
      ? 0.0
      : (((px - ax) * dx + (py - ay) * dy) / len2).clamp(0.0, 1.0);
  final cx = ax + t * dx, cy = ay + t * dy;
  return sqrt((px - cx) * (px - cx) + (py - cy) * (py - cy));
}

/// The driver's running trip: its farms, its buyer and the free space.
class SharedPlan {
  SharedPlan(this.trip, this.capacityKg, this.onTruckKg);
  final Trip trip;
  final num capacityKg;
  final num onTruckKg;
  num get freeKg => max(0, capacityKg - onTruckKg);

  /// The truck's way: every farm, then the buyer.
  List<GeoPoint> get path => [
    for (final s in trip.stops) ?s.pickup.geo,
    ?trip.lead.dropoff.geo,
  ];

  /// Extra km to fetch [d] (there and back to the route), or null when the
  /// load is off this route.
  int? detourKm(Delivery d) {
    final p = d.pickup.geo;
    final pts = path;
    if (p == null || pts.length < 2) return null;
    var best = double.infinity;
    for (var i = 0; i < pts.length - 1; i++) {
      best = min(best, _toSegmentKm(p, pts[i], pts[i + 1]));
    }
    return best > _offRouteKm ? null : (best * 2).round();
  }

  bool endsNearby(Delivery d) {
    final mine = trip.lead.dropoff;
    if (d.dropoff.district != null && d.dropoff.district == mine.district) {
      return true;
    }
    final a = d.dropoff.geo, b = mine.geo;
    return a != null && b != null && kmBetween(a, b) <= _nearDropKm;
  }

  /// Open loads that fit the free space and the route, nearest first.
  List<(Delivery, int)> matches(List<Delivery> open, String myUid) {
    final out = <(Delivery, int)>[];
    for (final d in open) {
      if (d.buyerId == myUid || d.weightKg > freeKg) continue;
      if (trip.stops.any((s) => s.id == d.id) || !endsNearby(d)) continue;
      final km = detourKm(d);
      if (km != null) out.add((d, km));
    }
    out.sort((a, b) => a.$2.compareTo(b.$2));
    return out;
  }

  /// The driver's running trip (the one with the most on the truck).
  static SharedPlan? of(AppUser me, List<Delivery> mine) {
    final active = mine.where(
      (d) => d.transporterId == me.uid && d.status.isActive,
    );
    if (active.isEmpty) return null;
    final trips = Trip.group(active).toList()
      ..sort((a, b) => b.loadedKg.compareTo(a.loadedKg));
    final onTruck = active.fold<num>(
      0,
      (a, d) => a + (d.loadedKg ?? d.weightKg),
    );
    return SharedPlan(trips.first, me.vehicle?.capacityKg ?? 0, onTruck);
  }
}

/// "৮ কিমি ঘুরতে হবে" / "রুটেই".
String detourText(BuildContext context, int km) {
  final l = AppLocalizations.of(context);
  return km < _onRouteKm ? l.onRoute : l.detourKm(Fmt.number(context, km));
}

Future<void> _addLoad(
  BuildContext context,
  WidgetRef ref,
  Delivery d,
  AppUser me,
) async {
  final l = AppLocalizations.of(context);
  try {
    await ref.read(transportRepositoryProvider).placeBid(d, me, fareOf(d));
    if (context.mounted) KsToast.show(context, l.retBidSent);
  } catch (_) {
    if (context.mounted) KsToast.show(context, l.errorGeneric);
  }
}

/// 161 Shared Truck Capacity (Figma 292:3257): free space on the running
/// trip and open loads along its route. Each is a separate job and fare.
class SharedTruckScreen extends ConsumerStatefulWidget {
  const SharedTruckScreen({super.key});

  @override
  ConsumerState<SharedTruckScreen> createState() => _SharedTruckState();
}

class _SharedTruckState extends ConsumerState<SharedTruckScreen> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    final mine = ref.watch(myDeliveriesProvider).value;
    final open = ref.watch(openLoadsProvider).value;
    if (me == null || mine == null || open == null) {
      return Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(title: l.sharedTitle),
        body: const KsSkeletonList(rows: 3),
      );
    }
    final plan = SharedPlan.of(me, mine);
    if (plan == null) {
      return Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(title: l.sharedTitle),
        body: KsEmptyState(
          title: l.sharedNoTripTitle,
          body: l.sharedNoTripBody,
        ),
      );
    }
    final t = plan.trip;
    final found = plan.matches(open, me.uid);
    final first = found.firstOrNull;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.sharedTitle),
      body: ListView(
        padding: _pad,
        children: [
          KsListItem(
            highlighted: true,
            thumb: Image.asset(AppImages.truckRoad, fit: BoxFit.cover),
            title: l.freeSpaceTitle(
              Fmt.number(
                context,
                plan.freeKg / 1000,
                decimals: plan.freeKg % 1000 == 0 ? 0 : 1,
              ),
            ),
            subtitle: l.sharedTruckSub(
              tonsText(context, plan.capacityKg),
              tonsText(context, plan.onTruckKg),
              t.no,
            ),
            showChevron: false,
          ),
          const SizedBox(height: AppSpacing.block),
          ProgressRow(
            label: l.truckFull,
            gap: AppSpacing.xs,
            value: plan.capacityKg <= 0
                ? 0
                : (plan.onTruckKg / plan.capacityKg).clamp(0, 1).toDouble(),
            text: l.ofTons(
              Fmt.number(
                context,
                plan.onTruckKg / 1000,
                decimals: plan.onTruckKg % 1000 == 0 ? 0 : 1,
              ),
              tonsText(context, plan.capacityKg),
            ),
          ),
          const SizedBox(height: AppSpacing.block),
          Text(
            l.loadsOnRoute(routeOf(context, t.lead)),
            style: AppTypography.bodyMediumStrong.normal,
          ),
          if (found.isEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            Text(
              l.sharedNone,
              style: AppTypography.bodyMedium.normal.withColor(
                AppColors.textSecondary,
              ),
            ),
          ],
          for (final (d, km) in found) ...[
            const SizedBox(height: AppSpacing.block),
            KsListItem(
              thumb: KsNetImage(
                url: d.photo,
                thumbSize: KsListItem.thumbSize.round(),
                fallbackAsset: CropCatalog.imageFor(d.cropKey),
              ),
              title: l.cropDashQty(
                d.cropName(lang),
                tonsText(context, d.weightKg),
              ),
              subtitle: l.nameDot(
                districtOf(context, d.pickup),
                detourText(context, km),
              ),
              trailingText: Fmt.taka(context, fareOf(d)),
              highlighted: d.id == first?.$1.id && found.length > 1,
              onTap: () => context.push(Routes.trSharedLoad(d.id)),
            ),
          ],
          const SizedBox(height: AppSpacing.block),
          KsNoteBox(
            warning: true,
            title: l.sharedRuleTitle,
            body: l.sharedRuleBody,
          ),
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          KsButton(
            label: l.addLoad,
            loading: _busy,
            onPressed: first == null
                ? null
                : () async {
                    setState(() => _busy = true);
                    await _addLoad(context, ref, first.$1, me);
                    if (mounted) setState(() => _busy = false);
                  },
          ),
        ],
      ),
    );
  }
}

/// 150 / 151 Shared Load details (Figma 292:4736): one load along the
/// running trip, with its extra distance and its own safe fare.
class SharedLoadScreen extends ConsumerStatefulWidget {
  const SharedLoadScreen({super.key, required this.deliveryId});
  final String deliveryId;

  @override
  ConsumerState<SharedLoadScreen> createState() => _SharedLoadState();
}

class _SharedLoadState extends ConsumerState<SharedLoadScreen> {
  static const _mapH = 242.0;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    final d = ref.watch(deliveryProvider(widget.deliveryId)).value;
    final mine = ref.watch(myDeliveriesProvider).value ?? const <Delivery>[];
    final bids = ref.watch(bidsProvider(widget.deliveryId)).value ?? const [];
    if (d == null || me == null) {
      return Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(title: l.loadDetailsTitle),
        body: const KsSkeletonList(rows: 3),
      );
    }
    final plan = SharedPlan.of(me, mine);
    final km = plan?.detourKm(d);
    final buyer = ref.watch(userByIdProvider(d.buyerId)).value;
    final myBid = bids.where((b) => b.transporterId == me.uid).firstOrNull;
    final at = d.pickupDate;
    final when = at == null
        ? ''
        : (at.hour == 0 && at.minute == 0)
        ? Fmt.date(context, at)
        : '${Fmt.date(context, at)} ${Fmt.time(context, at)}';

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.loadDetailsTitle),
      body: ListView(
        padding: _pad,
        children: [
          KsRouteMap(
            height: _mapH,
            from: d.pickup.geo,
            to: d.dropoff.geo,
            points: [...?plan?.path],
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              KsInfoRow(
                l.rowGoods,
                l.loadSub(d.cropName(lang), qtyKgText(context, d.weightKg)),
              ),
              KsInfoRow(
                l.fieldPickup,
                l.nameDot(districtOf(context, d.pickup), when),
              ),
              KsInfoRow(l.rowDestination, placeFull(context, d.dropoff)),
              if (km != null) KsInfoRow(l.rowDistance, detourText(context, km)),
              KsInfoRow(
                l.rowFare,
                l.fareSafeLine(Fmt.taka(context, fareOf(d))),
              ),
              KsInfoRow(
                l.rowCustomer,
                (buyer?.isVerified ?? false)
                    ? l.nameVerified(d.buyerName)
                    : d.buyerName,
              ),
            ],
          ),
          if (plan != null) ...[
            const SizedBox(height: AppSpacing.block),
            Text(
              d.weightKg <= plan.freeKg
                  ? l.sharedFits(tonsText(context, plan.freeKg))
                  : l.tooBigTruck(tonsText(context, plan.freeKg)),
              style: AppTypography.bodySmall.normal.withColor(
                d.weightKg <= plan.freeKg
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
          else if (myBid != null)
            KsNoteBox(title: l.myBidLine(Fmt.taka(context, myBid.fare)))
          else
            KsButton(
              label: l.addThisLoad,
              loading: _busy,
              onPressed: () async {
                setState(() => _busy = true);
                await _addLoad(context, ref, d, me);
                if (mounted) setState(() => _busy = false);
              },
            ),
        ],
      ),
    );
  }
}
