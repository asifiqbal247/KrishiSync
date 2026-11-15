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
import '../../../shared/data/market_price_repository.dart';
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_search_bar.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../../admin/data/admin_repository.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';

/// "+১২%" / "−৮%" with sign.
String pctText(BuildContext context, int pct) {
  final l = AppLocalizations.of(context);
  return l.pctChange(pct >= 0 ? '+' : '−', Fmt.digits(context, '${pct.abs()}'));
}

const _pad = EdgeInsets.fromLTRB(
    AppSpacing.screen, AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg);

/// 29 Market Prices (Figma 292:901). Prices are national (admin enters one
/// wholesale price per crop), so the district pills are left out.
class MarketPricesScreen extends ConsumerStatefulWidget {
  const MarketPricesScreen({super.key});

  @override
  ConsumerState<MarketPricesScreen> createState() => _MarketPricesState();
}

class _MarketPricesState extends ConsumerState<MarketPricesScreen> {
  final _q = TextEditingController();
  CropCategory? _cat;

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final async = ref.watch(marketPricesProvider);
    final catalog = ref.watch(catalogProvider);
    final q = _q.text.trim().toLowerCase();

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.mpTitle),
      body: switch (async) {
        AsyncData(value: final prices) => () {
            final latest = prices
                .map((p) => p.updatedAt)
                .whereType<DateTime>()
                .fold<DateTime?>(null, (a, b) => a == null || b.isAfter(a) ? b : a);
            final rows = [
              for (final p in prices)
                if (catalogCrop(catalog, p.cropKey) case final c?)
                  if ((_cat == null || c.category == _cat) &&
                      (q.isEmpty ||
                          c.bn.contains(q) ||
                          c.en.toLowerCase().contains(q)))
                    (c, p),
            ]..sort((a, b) => a.$1.name(lang).compareTo(b.$1.name(lang)));
            return ListView(
              padding: _pad,
              children: [
                KsSearchBar(
                    hint: l.mpSearchHint,
                    controller: _q,
                    onChanged: (_) => setState(() {})),
                const SizedBox(height: AppSpacing.block),
                Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
                  for (final (c, label) in [
                    (null, l.catAll),
                    (CropCategory.vegetable, l.catVegetable),
                    (CropCategory.fruit, l.catFruit),
                    (CropCategory.grain, l.catGrain),
                  ])
                    KsPill(
                        label: label,
                        selected: _cat == c,
                        onTap: () => setState(() => _cat = c)),
                ]),
                const SizedBox(height: AppSpacing.block),
                Row(children: [
                  Expanded(
                      child: Text(l.mpWholesale,
                          style: AppTypography.bodySmallStrong.normal)),
                  if (latest != null)
                    Text(
                        l.mpUpdated(Fmt.digits(
                            context,
                            '${Fmt.date(context, latest)} '
                            '${DateFormat('H:mm').format(latest)}')),
                        style: AppTypography.caption.normal
                            .withColor(AppColors.textSecondary)),
                ]),
                if (rows.isEmpty) ...[
                  const SizedBox(height: AppSpacing.block),
                  Text(l.mpEmpty,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.normal
                          .withColor(AppColors.textSecondary)),
                ],
                for (final (c, p) in rows) ...[
                  const SizedBox(height: AppSpacing.block),
                  KsListItem(
                    thumb: c.image == null
                        ? null
                        : Image.asset(c.image!, fit: BoxFit.cover),
                    title: c.name(lang),
                    subtitle: l.priceLine(Fmt.number(context, p.price)),
                    trailing: Text(pctText(context, p.changePct),
                        style: AppTypography.bodySmallEmphasis.normal.withColor(
                            p.changePct >= 0
                                ? AppColors.textSuccess
                                : AppColors.textError)),
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      context.push(Routes.priceTrend(c.key));
                    },
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

/// 30 Price Trend (Figma 292:925): 7 days / 30 days / 3 months.
class PriceTrendScreen extends ConsumerStatefulWidget {
  const PriceTrendScreen({super.key, required this.cropKey});
  final String cropKey;

  @override
  ConsumerState<PriceTrendScreen> createState() => _PriceTrendState();
}

class _PriceTrendState extends ConsumerState<PriceTrendScreen> {
  int _days = 7;
  static const _bars = 7;

  /// Average price per bucket (7 bars); empty buckets carry the last value.
  (List<num>, List<String>) _series(
      BuildContext context, List<PricePoint> pts, AppLocalizations l) {
    final today = DateTime.now();
    final end = DateTime(today.year, today.month, today.day + 1);
    final start = end.subtract(Duration(days: _days));
    final span = _days / _bars;
    final values = <num>[];
    final labels = <String>[];
    // Before the first recorded price a bar stays empty (0); after it, a
    // day without a new price keeps the last known price.
    num last = 0;
    for (var i = 0; i < _bars; i++) {
      final from = start.add(Duration(hours: (span * 24 * i).round()));
      final to = start.add(Duration(hours: (span * 24 * (i + 1)).round()));
      final inBucket = pts
          .where((p) => !p.date.isBefore(from) && p.date.isBefore(to))
          .map((p) => p.price)
          .toList();
      if (inBucket.isNotEmpty) {
        last = inBucket.reduce((a, b) => a + b) / inBucket.length;
      }
      values.add(last);
      final labelDay = to.subtract(const Duration(days: 1));
      labels.add(_days == 7
          ? weekdayShort(l, labelDay)
          : Fmt.digits(context, '${labelDay.day}/${labelDay.month}'));
    }
    return (values, labels);
  }

  static String weekdayShort(AppLocalizations l, DateTime d) => switch (d.weekday) {
        DateTime.saturday => l.wdSat,
        DateTime.sunday => l.wdSun,
        DateTime.monday => l.wdMon,
        DateTime.tuesday => l.wdTue,
        DateTime.wednesday => l.wdWed,
        DateTime.thursday => l.wdThu,
        _ => l.wdFri,
      };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    final crop = catalogCrop(ref.watch(catalogProvider), widget.cropKey);
    final current = ref.watch(marketPriceProvider(widget.cropKey)).value;
    final hist =
        ref.watch(priceHistoryProvider((widget.cropKey, _days))).value ?? const [];
    // Prices entered before history existed: count today's current price.
    final pts = [...hist];
    if (current?.updatedAt != null &&
        !pts.any((p) =>
            MarketPriceRepository.dayKey(p.date) ==
            MarketPriceRepository.dayKey(current!.updatedAt!))) {
      pts.add(PricePoint(current!.updatedAt!, current.price));
      pts.sort((a, b) => a.date.compareTo(b.date));
    }
    final name = crop?.name(lang) ?? widget.cropKey;
    final price = current?.price ?? (pts.isEmpty ? 0 : pts.last.price);
    final first = pts.isEmpty ? price : pts.first.price;
    final pct = first == 0 ? 0 : (((price - first) / first) * 100).round();
    final (values, labels) = _series(context, pts, l);
    final prices = pts.map((p) => p.price).toList();
    String tk(num v) => Fmt.taka(context, v);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.trendTitle(name)),
      body: ListView(
        padding: _pad,
        children: [
          Wrap(spacing: AppSpacing.sm, children: [
            for (final (d, label) in [
              (7, l.period7),
              (30, l.period30),
              (90, l.period90),
            ])
              KsPill(
                  label: label,
                  selected: _days == d,
                  onTap: () => setState(() => _days = d)),
          ]),
          const SizedBox(height: AppSpacing.block),
          Text(l.priceLine(Fmt.number(context, price)),
              style: AppTypography.display28.normal),
          const SizedBox(height: AppSpacing.sm),
          Text(
              switch (_days) {
                7 => l.sinceWeek(pctText(context, pct)),
                30 => l.sinceMonth(pctText(context, pct)),
                _ => l.since3Months(pctText(context, pct)),
              },
              style: AppTypography.bodySmall.normal
                  .withColor(AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.block),
          if (pts.isEmpty)
            KsNoteBox(title: l.trendNoData)
          else
            KsBarChart(values: values, labels: labels),
          const SizedBox(height: AppSpacing.block),
          if (prices.isNotEmpty)
            KsInfoBox(children: [
              KsInfoRow(l.rowHighest, tk(prices.reduce((a, b) => a > b ? a : b))),
              KsInfoRow(l.rowLowest, tk(prices.reduce((a, b) => a < b ? a : b))),
              KsInfoRow(l.rowAverage,
                  tk((prices.reduce((a, b) => a + b) / prices.length).round())),
            ]),
          const SizedBox(
              height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
          // Price alerts need push notifications (Tier C).
          KsButton.secondary(
            label: l.priceAlert(tk(current?.max ?? price)),
            onPressed: () => KsToast.comingSoon(context),
          ),
          const SizedBox(height: AppSpacing.block),
          if (me?.role == UserRole.farmer)
            KsButton(
                label: l.sellAtPrice,
                onPressed: () => context.push(Routes.farmerSell))
          else if (me?.role == UserRole.buyer)
            KsButton(
                label: l.findInMarket,
                onPressed: () => context.push(Routes.buyerSearch)),
        ],
      ),
    );
  }
}
