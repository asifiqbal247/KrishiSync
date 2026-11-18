import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_hero.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../../auth/data/user_repository.dart';
import '../../buyer/presentation/buyer_common.dart' show qtyText;
import '../data/live_location.dart';
import '../data/transport_repository.dart';
import '../domain/delivery.dart';
import 'transport_common.dart';

/// Road ≈ 1.3 × straight line; a loaded truck averages 40 km/h (same as
/// [Delivery.roadKm]).
const _roadFactor = 1.3;
const _kmPerHour = 40.0;

/// Road km along [start] → farms in [order] → [drop].
double routeKm(GeoPoint? start, List<Delivery> order, GeoPoint? drop) {
  final pts = [?start, for (final d in order) ?d.pickup.geo, ?drop];
  var km = 0.0;
  for (var i = 0; i < pts.length - 1; i++) {
    km += kmBetween(pts[i], pts[i + 1]);
  }
  return km * _roadFactor;
}

/// Shortest farm order (every order is tried; a PO has only a few farms).
List<Delivery> bestOrder(
  GeoPoint? start,
  List<Delivery> stops,
  GeoPoint? drop,
) {
  if (stops.length < 2) return stops;
  var best = stops;
  var bestKm = routeKm(start, stops, drop);
  void walk(List<Delivery> done, List<Delivery> left) {
    if (left.isEmpty) {
      final km = routeKm(start, done, drop);
      if (km < bestKm - 0.01) {
        bestKm = km;
        best = done;
      }
      return;
    }
    for (final d in left) {
      walk([...done, d], [...left]..remove(d));
    }
  }

  walk(const [], stops);
  return best;
}

/// "৫ ঘ. ২০ মি." / "২০ মি." for [km] at truck speed.
String driveTime(BuildContext context, double km) {
  final l = AppLocalizations.of(context);
  final min = (km / _kmPerHour * 60).round();
  final h = min ~/ 60;
  final m = min % 60;
  String n(int v) => Fmt.digits(context, '$v');
  if (h == 0) return l.minutesShort(n(m));
  return m == 0 ? l.hoursOnly(n(h)) : l.hoursMinutes(n(h), n(m));
}

String _km(BuildContext context, double km) =>
    AppLocalizations.of(context).kmOnly(Fmt.number(context, km.round()));

/// 155 Route Map (Figma 292:1747): the farmers' pickup order vs the
/// shortest order; the choice is kept and drives the stop numbers.
class RouteMapScreen extends ConsumerStatefulWidget {
  const RouteMapScreen({super.key, required this.deliveryId});
  final String deliveryId;

  @override
  ConsumerState<RouteMapScreen> createState() => _RouteMapState();
}

class _RouteMapState extends ConsumerState<RouteMapScreen> {
  static const _mapH = 260.0;
  bool _optimized = true;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = ref.watch(tripProvider(widget.deliveryId));
    final me = ref.watch(myPositionProvider).value;
    if (t == null) {
      return Scaffold(
        appBar: KsAppBar(title: l.routeMapTitle),
        body: const KsSkeletonList(rows: 3),
      );
    }
    final drop = t.lead.dropoff.geo;
    // Only farms still to load can be reordered.
    final todo = t.stops
        .where((d) => d.status == DeliveryStatus.assigned)
        .toList();
    final loaded = t.stops.where((d) => !todo.contains(d)).toList();
    final start = me ?? (todo.isEmpty ? null : todo.first.pickup.geo);
    final yours = Trip(todo).stops;
    final best = bestOrder(start, yours, drop);
    final yoursKm = routeKm(start, yours, drop);
    final bestKm = routeKm(start, best, drop);
    final chosen = _optimized ? best : yours;
    final chosenKm = _optimized ? bestKm : yoursKm;

    Widget option(bool opt, String label, double km) {
      final on = _optimized == opt;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _optimized = opt),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: on ? AppColors.bgSubtle : AppColors.bgPage,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: on ? AppColors.borderBrand : AppColors.borderDefault,
                width: on ? AppSizes.borderBrand : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.bodySmall.normal.withColor(
                    AppColors.textSecondary,
                  ),
                ),
                Text(_km(context, km), style: AppTypography.bold18.normal),
                Text(
                  driveTime(context, km),
                  style: AppTypography.bodySmall.normal.withColor(
                    AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.routeMapTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.contentTop,
          AppSpacing.screen,
          AppSpacing.lg,
        ),
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              KsPill(
                label: l.routeOptimized,
                selected: _optimized,
                onTap: () => setState(() => _optimized = true),
              ),
              KsPill(
                label: l.routeYours,
                selected: !_optimized,
                onTap: () => setState(() => _optimized = false),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          KsRouteMap(
            height: _mapH,
            truck: me,
            points: [for (final d in t.stops) ?d.pickup.geo, ?drop],
            path: [?start, for (final d in chosen) ?d.pickup.geo, ?drop],
            // 155 keeps its rounded map (Figma radius 16).
            radius: BorderRadius.circular(AppRadius.xl),
          ),
          const SizedBox(height: AppSpacing.block),
          Row(
            children: [
              option(false, l.routeYours, yoursKm),
              const SizedBox(width: AppSpacing.md),
              option(true, l.routeOptimizedShort, bestKm),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              KsInfoRow(l.rowTotalDistance, _km(context, chosenKm)),
              KsInfoRow(l.rowEstTime, driveTime(context, chosenKm)),
              KsInfoRow(
                l.rowSaving,
                yoursKm - bestKm < 1
                    ? l.savingNone
                    : l.savingKm(
                        Fmt.number(context, (yoursKm - bestKm).round()),
                      ),
              ),
            ],
          ),
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          KsButton(
            label: l.startNav,
            onPressed: () async {
              final po = t.lead.poNo;
              if (po != null) {
                await ref.read(stopOrderProvider.notifier).save(po, [
                  for (final d in loaded) d.id,
                  for (final d in chosen) d.id,
                ]);
              }
              if (context.mounted) {
                context.pushReplacement(Routes.trNav(t.lead.id));
              }
            },
          ),
        ],
      ),
    );
  }
}

/// 156 / 157 / 158 Navigation (Figma 292:1778): live truck position, the
/// way to the next stop, its distance and time. "পৌঁছেছি" opens loading
/// (162) or delivery (167); tapping the map opens Google Maps turn by turn.
class NavigationScreen extends ConsumerWidget {
  const NavigationScreen({super.key, required this.deliveryId});
  final String deliveryId;

  /// Bottom panel (info + buttons) height in Figma: 800 − 612 map.
  static const _panelH = 188.0;

  /// Space around the pins when the map fits the route.
  static const _fitSide = 40.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final t = ref.watch(tripProvider(deliveryId));
    final me = ref.watch(myPositionProvider).value;
    if (t == null) {
      return Scaffold(
        appBar: KsAppBar(title: l.navTitle),
        body: const KsSkeletonList(rows: 3),
      );
    }
    final next = t.nextPickup;
    final toBuyer = next == null;
    final target = toBuyer ? t.lead.dropoff.geo : next.pickup.geo;
    final person = ref
        .watch(userByIdProvider(toBuyer ? t.lead.buyerId : next.farmerId))
        .value;
    // Needs the phone's GPS; without a fix the distance shows "—".
    final km = me == null || target == null
        ? null
        : kmBetween(me, target) * _roadFactor;
    final stopText = toBuyer
        ? l.nameDot(
            districtOf(context, t.lead.dropoff),
            l.cropQty(t.lead.cropName(lang), qtyText(context, t.loadedKg)),
          )
        : l.nameDot(next.farmerName, placeFull(context, next.pickup));
    final todo = [
      for (final d in t.stops)
        if (d.status == DeliveryStatus.assigned) d,
    ];

    Future<void> openGoogle() async {
      if (target == null) return;
      final uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
        '&destination=${target.latitude},${target.longitude}'
        '&travelmode=driving',
      );
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    final h = MediaQuery.of(context).size.height;
    final bottom = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      extendBodyBehindAppBar: true,
      appBar: KsAppBar(title: l.navTitle, onImage: true),
      body: Column(
        children: [
          Stack(
            children: [
              KsRouteMap(
                height: h - _panelH - bottom,
                truck: me,
                points: [
                  for (final d in todo) ?d.pickup.geo,
                  ?t.lead.dropoff.geo,
                ],
                path: [
                  ?me,
                  for (final d in todo) ?d.pickup.geo,
                  ?t.lead.dropoff.geo,
                ],
                // Figma 156: full-bleed, square corners.
                radius: BorderRadius.zero,
                fitPadding: EdgeInsets.fromLTRB(
                  _fitSide,
                  MediaQuery.of(context).padding.top +
                      AppSizes.appBarHeight +
                      _fitSide,
                  _fitSide,
                  _fitSide,
                ),
                onTap: openGoogle,
              ),
              // Figma 156-158 "Top Shade": 140 high.
              const KsHeroShade(figmaHeight: 140),
            ],
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.lg,
                  AppSpacing.screen,
                  AppSpacing.lg,
                ),
                child: Column(
                  children: [
                    KsInfoBox(
                      children: [
                        KsInfoRow(l.rowNextStop, stopText),
                        KsInfoRow(
                          l.rowDistTime,
                          km == null
                              ? l.notAvailable
                              : l.nameDot(
                                  _km(context, km),
                                  driveTime(context, km),
                                ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: KsButton.outline(
                            label: l.callBtn,
                            onPressed: person == null
                                ? null
                                : () => launchUrl(
                                    Uri.parse('tel:${person.phone}'),
                                  ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: KsButton(
                            label: l.arrivedBtn,
                            onPressed: t.delivered
                                ? null
                                : () => context.push(
                                    toBuyer
                                        ? Routes.trDeliver(t.lead.id)
                                        : Routes.trWeigh(next.id),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
