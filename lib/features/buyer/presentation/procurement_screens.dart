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
import '../../../shared/widgets/app_icon.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../demand/data/demand_repository.dart';
import '../../inspection/data/inspection_repository.dart';
import '../../trade/data/trade_repository.dart';
import '../../trade/domain/trade_models.dart';
import '../../transport/presentation/transport_common.dart';
import 'supplier_screens.dart';

const _pad = EdgeInsets.fromLTRB(AppSpacing.screen, AppSpacing.contentTop,
    AppSpacing.screen, AppSpacing.lg);

String _pctText(BuildContext context, double v) => AppLocalizations.of(context)
    .pctText(Fmt.digits(context, '${(v * 100).round()}'));

/// "৳ 6.8 লাখ" from 1 lakh, otherwise "৳ 68,000".
String _bigTaka(BuildContext context, num v) => v >= 100000
    ? AppLocalizations.of(context)
        .takaLakh(Fmt.number(context, v / 100000, decimals: 1))
    : Fmt.taka(context, v);

/// 100 Procurement Dashboard (Figma 292:1163): the buyer's open demands,
/// committed amount, farmers joined and money held — from real demands,
/// commitments and orders. Opens 101.
class ProcurementDashboardScreen extends ConsumerWidget {
  const ProcurementDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final demands = (ref.watch(myDemandsProvider).value ?? const <Demand>[])
        .where((d) => d.status == DemandStatus.open)
        .toList();
    final orders = ref.watch(myOrdersProvider).value ?? const <TradeOrder>[];
    final held = orders
        .where((o) => o.status.isOngoing)
        .fold<num>(0, (a, o) => a + o.total);

    num committed = 0;
    final farmers = <String>{};
    final progress = <(Demand, num)>[];
    for (final d in demands) {
      final cs = (ref.watch(commitsProvider(d.id)).value ?? const <Commit>[])
          .where((c) => c.status != CommitStatus.rejected);
      final got = cs.fold<num>(0, (a, c) => a + c.quantityKg);
      committed += got;
      farmers.addAll(cs.map((c) => c.farmerId));
      progress.add((d, got));
    }

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.procTitle),
      body: ListView(
        padding: _pad,
        children: [
          Row(children: [
            Expanded(
              child: KsStatCard(
                label: l.procOpenDemands,
                value: l.countTi(Fmt.digits(context, '${demands.length}')),
                onTap: () => context.push(Routes.myDemands),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: KsStatCard(
                  label: l.procCommitted,
                  value: tonsText(context, committed)),
            ),
          ]),
          const SizedBox(height: AppSpacing.block),
          Row(children: [
            Expanded(
              child: KsStatCard(
                label: l.procFarmers,
                value: l.procPeople(Fmt.digits(context, '${farmers.length}')),
                onTap: () => context.push(Routes.suppliers),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: KsStatCard(
                label: l.procSafePay,
                value: _bigTaka(context, held),
                onTap: () => context.push(Routes.payments),
              ),
            ),
          ]),
          const SizedBox(height: AppSpacing.block),
          KsSectionHeader(
            title: l.procOngoing,
            actionLabel: l.commonSeeAll,
            onAction: () => context.push(Routes.myDemands),
          ),
          if (progress.isEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            Text(l.procNone,
                style: AppTypography.bodyMedium.normal
                    .withColor(AppColors.textSecondary)),
          ],
          for (final (d, got) in progress) ...[
            const SizedBox(height: AppSpacing.block),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.push(Routes.demandOffers(d.id)),
              child: ProgressRow(
                label: l.procLine(
                    d.cropName(lang), tonsText(context, d.quantityKg)),
                value: d.quantityKg <= 0
                    ? 0
                    : (got / d.quantityKg).clamp(0, 1).toDouble(),
                text: _pctText(
                    context,
                    d.quantityKg <= 0
                        ? 0
                        : (got / d.quantityKg).clamp(0, 1).toDouble()),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.block),
          KsListItem(
            thumb: const ColoredBox(
              color: AppColors.bgSubtle,
              child: Center(
                  child: AppIcon(AppIcons.leaf, color: AppColors.iconBrand)),
            ),
            title: l.procAnalytics,
            subtitle: l.procAnalyticsSub,
            onTap: () => context.push(Routes.procurementAnalytics),
          ),
        ],
      ),
    );
  }
}

enum _Period { month, three, year }

/// 101 Procurement Analytics (Figma 292:3210): spend, average price of the
/// most-bought crop, a spend bar chart, supplier performance and delivery
/// progress for the chosen period — from the buyer's orders.
class ProcurementAnalyticsScreen extends ConsumerStatefulWidget {
  const ProcurementAnalyticsScreen({super.key});

  @override
  ConsumerState<ProcurementAnalyticsScreen> createState() =>
      _AnalyticsState();
}

class _AnalyticsState extends ConsumerState<ProcurementAnalyticsScreen> {
  _Period _p = _Period.month;

  static const _maxSuppliers = 3;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    final start = switch (_p) {
      _Period.month => DateTime(now.year, now.month),
      _Period.three => DateTime(now.year, now.month - 2),
      _Period.year => DateTime(now.year),
    };
    final orders = (ref.watch(myOrdersProvider).value ?? const <TradeOrder>[])
        .where((o) =>
            o.status != OrderStatus.cancelled &&
            o.createdAt != null &&
            !o.createdAt!.isBefore(start))
        .toList();

    // Spend and the most-bought crop (by kg).
    final spend = orders.fold<num>(0, (a, o) => a + o.total);
    final byCrop = <String, (String, num, num)>{}; // key → (name, kg, money)
    for (final o in orders) {
      final c = byCrop[o.cropKey];
      byCrop[o.cropKey] = (
        o.cropName(lang),
        (c?.$2 ?? 0) + o.quantityKg,
        (c?.$3 ?? 0) + o.cropTotal,
      );
    }
    final top = byCrop.values.isEmpty
        ? null
        : byCrop.values.reduce((a, b) => a.$2 >= b.$2 ? a : b);

    // Bars: days of this month / weeks of 3 months / months of the year.
    final buckets = switch (_p) {
      _Period.month => DateUtils.getDaysInMonth(now.year, now.month),
      _Period.three => (now.difference(start).inDays ~/ 7) + 1,
      _Period.year => 12,
    };
    final bars = List<num>.filled(buckets, 0);
    for (final o in orders) {
      final d = o.createdAt!;
      final i = switch (_p) {
        _Period.month => d.day - 1,
        _Period.three => d.difference(start).inDays ~/ 7,
        _Period.year => d.month - 1,
      };
      if (i >= 0 && i < buckets) bars[i] += o.total;
    }

    // Supplier performance: accepted share of ordered kg (weighing +
    // the buyer's inspector), top suppliers by spend.
    final perFarmer = <String, (String, num, num, num)>{}; // name, spend, kg, okKg
    var delivered = 0.0, left = 0.0;
    var platform = 0, inspected = 0;
    for (final o in orders) {
      final x = ref.watch(inspectionProvider(o.id)).value;
      final kg = o.orderedKg ?? o.quantityKg;
      final checked = o.timeline.containsKey('pickedUp') || (x?.done ?? false);
      final f = perFarmer[o.farmerId];
      perFarmer[o.farmerId] = (
        o.farmerName,
        (f?.$2 ?? 0) + o.total,
        (f?.$3 ?? 0) + (checked ? kg : 0),
        (f?.$4 ?? 0) + (checked ? kg * acceptedShare(o, x) : 0),
      );
      if (o.timeline.containsKey('delivered')) {
        delivered += o.quantityKg;
      } else {
        left += o.quantityKg;
      }
      if (o.transportMode == TransportMode.platform) {
        platform++;
        if (x != null) inspected++;
      }
    }
    final ranked = perFarmer.values.where((f) => f.$3 > 0).toList()
      ..sort((a, b) => b.$2.compareTo(a.$2));

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.procAnalytics),
      body: ListView(
        padding: _pad,
        children: [
          Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
            for (final (p, label) in [
              (_Period.month, l.anMonth),
              (_Period.three, l.an3Months),
              (_Period.year, l.anYear),
            ])
              KsPill(
                  label: label,
                  selected: _p == p,
                  onTap: () => setState(() => _p = p)),
          ]),
          const SizedBox(height: AppSpacing.block),
          Row(children: [
            Expanded(
              child: KsStatCard(
                  label: l.anSpend, value: _bigTaka(context, spend)),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: KsStatCard(
                label: l.anAvgPrice(top?.$1 ?? l.notAvailable),
                value: top == null || top.$2 <= 0
                    ? l.notAvailable
                    : l.pricePerKg(Fmt.taka(context, (top.$3 / top.$2).round())),
              ),
            ),
          ]),
          const SizedBox(height: AppSpacing.block),
          _BarChart(values: bars),
          if (orders.isEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            Text(l.anNoData,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.normal
                    .withColor(AppColors.textSecondary)),
          ],
          if (ranked.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            Text(l.anSuppliers, style: AppTypography.bodyMediumStrong.normal),
            for (final f in ranked.take(_maxSuppliers)) ...[
              const SizedBox(height: AppSpacing.block),
              ProgressRow(
                label: f.$1,
                value: (f.$4 / f.$3).clamp(0, 1).toDouble(),
                text: _pctText(context, (f.$4 / f.$3).clamp(0, 1).toDouble()),
              ),
            ],
          ],
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(children: [
            KsInfoRow(
              l.anDeliveredLeft,
              l.anSlash(tonsText(context, delivered), tonsText(context, left)),
              boldValue: true,
            ),
            KsInfoRow(
              l.anWithInspector,
              platform == 0
                  ? l.notAvailable
                  : _pctText(context, inspected / platform),
              boldValue: true,
            ),
          ]),
        ],
      ),
    );
  }
}

/// Figma 101 "Chart": bordered box, 14px brand bars every 20px, scrolls
/// sideways, 10px labels (1, 2, 3 …) under the bars.
class _BarChart extends StatelessWidget {
  const _BarChart({required this.values});
  final List<num> values;

  static const _boxH = 156.0;
  static const _barW = 14.0;
  static const _step = 20.0;
  static const _maxBar = 96.0;
  static const _plotH = 100.0;

  @override
  Widget build(BuildContext context) {
    final max = values.fold<num>(0, (a, v) => v > a ? v : a);
    return Container(
      height: _boxH,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < values.length; i++)
              SizedBox(
                width: _step,
                child: Column(children: [
                  SizedBox(
                    height: _plotH,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        width: _barW,
                        height: max <= 0 ? 0 : _maxBar * values[i] / max,
                        decoration: BoxDecoration(
                          color: AppColors.bgBrand,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: _barW,
                      child: Text(Fmt.digits(context, '${i + 1}'),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.visible,
                          style: AppTypography.chartLabel.normal
                              .withColor(AppColors.textSecondary)),
                    ),
                  ),
                ]),
              ),
          ],
        ),
      ),
    );
  }
}
