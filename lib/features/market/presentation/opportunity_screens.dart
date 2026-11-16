import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/data/market_price_repository.dart';
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/utils/geo.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../../admin/data/admin_repository.dart';
import '../../buyer/presentation/buyer_common.dart';
import '../../demand/data/demand_repository.dart';
import '../../trade/data/trade_repository.dart';
import '../../trade/domain/trade_models.dart';
import '../../transport/presentation/transport_common.dart';
import 'price_screens.dart';

const _pad = EdgeInsets.fromLTRB(
  AppSpacing.screen,
  AppSpacing.contentTop,
  AppSpacing.screen,
  AppSpacing.lg,
);
const _gapBeforeCta = AppSpacing.block + AppSpacing.xs + AppSpacing.block;

/// Demands that are still useful: open, and not for a date already gone.
List<Demand> _live(List<Demand> all) {
  final today = DateTime.now();
  return all
      .where((d) =>
          d.status == DemandStatus.open &&
          (d.monthly ||
              d.deliveryDate == null ||
              !d.deliveryDate!.isBefore(
                  DateTime(today.year, today.month, today.day))))
      .toList();
}

Widget _cropThumb(String cropKey) => KsNetImage(
      url: null,
      thumbSize: KsListItem.thumbSize.round(),
      fallbackAsset: CropCatalog.imageFor(cropKey),
    );

enum _Opp { all, demand, price, buyer }

/// 34 Market Opportunity Feed (farmer, Figma 292:3065). Built from real open
/// buyer demands and the admin's market prices.
class OpportunityFeedScreen extends ConsumerStatefulWidget {
  const OpportunityFeedScreen({super.key});

  @override
  ConsumerState<OpportunityFeedScreen> createState() => _OppState();
}

class _OppState extends ConsumerState<OpportunityFeedScreen> {
  _Opp _f = _Opp.all;
  static const _upcomingDays = 30;
  static const _maxBuyerRows = 5;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final demandsAsync = ref.watch(openDemandsProvider);
    final prices = ref.watch(marketPricesProvider).value ?? const [];
    final catalog = ref.watch(catalogProvider);
    String crop(String key) => catalogCrop(catalog, key)?.name(lang) ?? key;

    if (demandsAsync.isLoading && !demandsAsync.hasValue) {
      return Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(title: l.oppTitle),
        body: const KsSkeletonList(),
      );
    }
    final demands = _live(demandsAsync.value ?? const []);
    final soon = DateTime.now().add(const Duration(days: _upcomingDays));

    // High demand: crops several buyers are asking for.
    final byCrop = <String, List<Demand>>{};
    for (final d in demands) {
      byCrop.putIfAbsent(d.cropKey, () => []).add(d);
    }
    final hot = byCrop.entries
        .where((e) => e.value.map((d) => d.buyerId).toSet().length >= 2)
        .toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    final rows = <(_Opp, Widget)>[
      for (final e in hot)
        (
          _Opp.demand,
          KsListItem(
            thumb: _cropThumb(e.key),
            title: l.oppHighDemand(crop(e.key)),
            subtitle: l.oppHighDemandSub(
              _topDistrict(context, e.value),
              Fmt.digits(context,
                  '${e.value.map((d) => d.buyerId).toSet().length}'),
            ),
            trailingText: l.homeSee,
            onTap: () => context.push(Routes.buyerDemands),
          ),
        ),
      for (final p in prices.where((p) => p.changePct > 0))
        (
          _Opp.price,
          KsListItem(
            thumb: _cropThumb(p.cropKey),
            title: l.oppPriceUp(crop(p.cropKey)),
            subtitle: l.oppPriceUpSub(pctText(context, p.changePct),
                Fmt.taka(context, p.price)),
            trailingText: l.oppSell,
            onTap: () => context.push(Routes.priceTrend(p.cropKey)),
          ),
        ),
      for (final d in demands
          .where((d) => d.deliveryDate == null || !d.deliveryDate!.isAfter(soon))
          .take(_maxBuyerRows))
        (
          _Opp.buyer,
          KsListItem(
            thumb: KsNetImage(
              url: null,
              thumbSize: KsListItem.thumbSize.round(),
              fallbackAsset: AppUi.avatarBuyer,
            ),
            title: l.oppBuyerSeeking(
                crop(d.cropKey), tonsText(context, d.quantityKg)),
            subtitle: l.nameDot(d.buyerName, districtOf(context, d.dropoff)),
            trailingText: l.oppSupply,
            onTap: () => context.push(Routes.demandDetails(d.id)),
          ),
        ),
      for (final d in demands.where(
          (d) => d.deliveryDate != null && d.deliveryDate!.isAfter(soon)))
        (
          _Opp.all,
          KsListItem(
            thumb: _cropThumb(d.cropKey),
            title: l.oppUpcoming(
                crop(d.cropKey), tonsText(context, d.quantityKg)),
            subtitle: l.oppUpcomingSub(d.buyerName,
                DateFormat.MMMM(lang).format(d.deliveryDate!)),
            trailingText: l.oppPlan,
            onTap: () => context.push(Routes.planning),
          ),
        ),
    ];
    final shown = rows
        .where((r) => _f == _Opp.all || r.$1 == _f)
        .map((r) => r.$2)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.oppTitle),
      body: ListView(
        padding: _pad,
        children: [
          Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
            for (final (f, label) in [
              (_Opp.all, l.filterAll),
              (_Opp.demand, l.oppFilterDemand),
              (_Opp.price, l.oppFilterPrice),
              (_Opp.buyer, l.oppFilterBuyer),
            ])
              KsPill(
                  label: label,
                  selected: _f == f,
                  onTap: () => setState(() => _f = f)),
          ]),
          if (shown.isEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            Text(l.oppEmpty,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.normal
                    .withColor(AppColors.textSecondary)),
          ],
          for (final (i, w) in shown.indexed) ...[
            const SizedBox(height: AppSpacing.block),
            i == 0 && w is KsListItem
                ? KsListItem(
                    highlighted: true,
                    thumb: w.thumb,
                    title: w.title,
                    subtitle: w.subtitle,
                    trailingText: w.trailingText,
                    onTap: w.onTap,
                  )
                : w,
          ],
        ],
      ),
    );
  }

  /// District most of these buyers want the crop in.
  String _topDistrict(BuildContext context, List<Demand> ds) {
    final count = <String, int>{};
    for (final d in ds) {
      final name = districtOf(context, d.dropoff);
      if (name.isEmpty) continue;
      count[name] = (count[name] ?? 0) + 1;
    }
    if (count.isEmpty) return '';
    return (count.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
        .first
        .key;
  }
}

/// Bangladesh crop seasons (রবি / খরিফ-১ / খরিফ-২) by month.
enum Season {
  rabi([11, 12, 1, 2]),
  kharif1([3, 4, 5, 6]),
  kharif2([7, 8, 9, 10]);

  const Season(this.months);
  final List<int> months;

  static Season of(DateTime d) =>
      values.firstWhere((s) => s.months.contains(d.month));
}

/// 35 Production Planning (Figma 292:3081): open buyer demands for each
/// season, grouped by crop, so a farmer can plan before sowing. The land /
/// expected-yield box needs a farm-size field that profiles don't have yet,
/// so it is left out.
class PlanningScreen extends ConsumerStatefulWidget {
  const PlanningScreen({super.key});

  @override
  ConsumerState<PlanningScreen> createState() => _PlanningState();
}

class _PlanningState extends ConsumerState<PlanningScreen> {
  Season _s = Season.of(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final catalog = ref.watch(catalogProvider);
    final demands = _live(ref.watch(openDemandsProvider).value ?? const [])
        .where((d) =>
            d.monthly ||
            d.deliveryDate == null ||
            _s.months.contains(d.deliveryDate!.month))
        .toList();
    final byCrop = <String, List<Demand>>{};
    for (final d in demands) {
      byCrop.putIfAbsent(d.cropKey, () => []).add(d);
    }
    final groups = byCrop.entries.toList()
      ..sort((a, b) => _kg(b.value).compareTo(_kg(a.value)));

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.planTitle),
      body: ListView(
        padding: _pad,
        children: [
          Text(l.planIntro,
              style: AppTypography.bodySmall.normal
                  .withColor(AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.block),
          Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
            for (final (s, label) in [
              (Season.rabi, l.seasonRabi),
              (Season.kharif1, l.seasonKharif1),
              (Season.kharif2, l.seasonKharif2),
            ])
              KsPill(
                  label: label,
                  selected: _s == s,
                  onTap: () => setState(() => _s = s)),
          ]),
          if (groups.isEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            Text(l.planEmpty,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.normal
                    .withColor(AppColors.textSecondary)),
          ],
          for (final e in groups) ...[
            const SizedBox(height: AppSpacing.block),
            () {
              final ds = e.value;
              final prices = ds.map((d) => d.targetPrice).toList()..sort();
              final buyers = ds.map((d) => d.buyerName).toSet().toList();
              final dates = ds
                  .map((d) => d.deliveryDate)
                  .whereType<DateTime>()
                  .toList()
                ..sort();
              final name =
                  catalogCrop(catalog, e.key)?.name(lang) ?? e.key;
              return KsListItem(
                thumb: _cropThumb(e.key),
                title: l.planCropLine(name, tonsText(context, _kg(ds))),
                subtitle: [
                  buyers.length == 1
                      ? buyers.first
                      : l.planBuyersMore(buyers.first,
                          Fmt.digits(context, '${buyers.length - 1}')),
                  if (dates.isNotEmpty)
                    DateFormat.MMMM(lang).format(dates.first),
                  if (ds.length >= 2) l.planHighDemand,
                ].join(' · '),
                trailingText: prices.first == prices.last
                    ? Fmt.taka(context, prices.first)
                    : l.priceRangeTk(Fmt.number(context, prices.first),
                        Fmt.number(context, prices.last)),
                onTap: () => context.push(Routes.buyerDemands),
              );
            }(),
          ],
          const SizedBox(height: AppSpacing.block),
          KsNoteBox(warning: true, title: l.planWhenPaid, body: l.planWhenPaidBody),
          const SizedBox(height: _gapBeforeCta),
          KsButton(
            label: l.planCta,
            onPressed: () => context.push(Routes.buyerDemands),
          ),
        ],
      ),
    );
  }

  static num _kg(List<Demand> ds) =>
      ds.fold<num>(0, (a, d) => a + d.quantityKg);
}

/// 55 Surplus Rescue (farmer, Figma 292:3128): a buyer cancelled before
/// loading — show other buyers who want this crop now (open demands),
/// best price first.
class SurplusRescueScreen extends ConsumerWidget {
  const SurplusRescueScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final o = ref.watch(orderProvider(orderId)).value;
    final demandsAsync = ref.watch(openDemandsProvider);
    if (o == null || (demandsAsync.isLoading && !demandsAsync.hasValue)) {
      return Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(title: l.rescueTitle),
        body: const KsSkeletonList(),
      );
    }
    final market = ref.watch(marketPriceProvider(o.cropKey)).value;
    final others = _live(demandsAsync.value ?? const [])
        .where((d) => d.cropKey == o.cropKey && d.buyerId != o.buyerId)
        .toList()
      ..sort((a, b) => b.targetPrice.compareTo(a.targetPrice));

    String when(Demand d) => d.deliveryDate == null
        ? (d.monthly ? l.repeatMonthly : '')
        : Fmt.date(context, d.deliveryDate!);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.rescueTitle),
      body: ListView(
        padding: _pad,
        children: [
          KsNoteBox(
            warning: true,
            title: l.rescueCancelled,
            body: l.rescueCancelledBody(o.buyerName,
                qtyText(context, o.orderedKg ?? o.quantityKg),
                o.cropName(lang), o.orderNo),
          ),
          const SizedBox(height: AppSpacing.block),
          Text(l.rescueFinding(o.cropName(lang)),
              style: AppTypography.bodySmall.normal),
          if (others.isEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            Text(l.rescueNone,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.normal
                    .withColor(AppColors.textSecondary)),
          ],
          for (final (i, d) in others.indexed) ...[
            const SizedBox(height: AppSpacing.block),
            KsListItem(
              highlighted: i == 0,
              thumb: KsNetImage(
                url: null,
                thumbSize: KsListItem.thumbSize.round(),
                fallbackAsset: AppUi.avatarBuyer,
              ),
              title: d.buyerName,
              subtitle: [
                if (distanceKm(o.pickup.geo, d.dropoff.geo) case final km?)
                  l.kmShort(Fmt.number(context, km.round())),
                if (when(d).isNotEmpty) when(d),
              ].join(' · '),
              trailingText: Fmt.taka(context, d.targetPrice),
              onTap: () => context.push(Routes.demandDetails(d.id)),
            ),
          ],
          const SizedBox(height: AppSpacing.block),
          Text(
              market == null
                  ? l.rescueOldPrice(Fmt.number(context, o.pricePerKg))
                  : l.rescueOldAndMarket(
                      Fmt.number(context, o.pricePerKg),
                      Fmt.number(context, market.min),
                      Fmt.number(context, market.max)),
              style: AppTypography.caption.normal
                  .withColor(AppColors.textSecondary)),
          const SizedBox(height: _gapBeforeCta),
          if (others.isNotEmpty) ...[
            KsButton(
              label: l.rescueTakeBest,
              onPressed: () =>
                  context.push(Routes.demandDetails(others.first.id)),
            ),
            const SizedBox(height: AppSpacing.block),
          ],
          KsButton.secondary(
            label: l.rescueRelist,
            onPressed: () => context.push(o.listingId.isEmpty
                ? Routes.farmerSell
                : Routes.farmerListingDetails(o.listingId)),
          ),
        ],
      ),
    );
  }
}

/// Orders a farmer can rescue: cancelled before loading.
bool canRescue(TradeOrder o) =>
    o.status == OrderStatus.cancelled && !o.timeline.containsKey('pickedUp');
