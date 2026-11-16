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
import '../../../shared/data/trade_stats_repository.dart';
import '../../../shared/services/bd_location_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_search_bar.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../auth/data/user_repository.dart';
import '../../chat/presentation/chat_screens.dart';
import '../../inspection/data/inspection_repository.dart';
import '../../trade/data/trade_repository.dart';
import '../../trade/domain/trade_models.dart';
import '../../transport/presentation/transport_common.dart';

const _pad = EdgeInsets.fromLTRB(
  AppSpacing.screen,
  AppSpacing.contentTop,
  AppSpacing.screen,
  AppSpacing.lg,
);

/// "New" supplier = first order with them in the last 30 days.
const _newFor = Duration(days: 30);

/// Performance window on 120.
const _perfMonths = 6;

/// A farmer the buyer has ordered from, built from the buyer's orders.
class _Supplier {
  _Supplier(this.farmerId, this.farmerName);
  final String farmerId;
  final String farmerName;
  final orders = <TradeOrder>[];

  DateTime? get first => orders
      .map((o) => o.createdAt)
      .whereType<DateTime>()
      .fold<DateTime?>(null, (a, b) => a == null || b.isBefore(a) ? b : a);
}

List<_Supplier> _suppliersOf(List<TradeOrder> orders) {
  final map = <String, _Supplier>{};
  for (final o in orders) {
    if (o.status == OrderStatus.cancelled) continue;
    map
        .putIfAbsent(o.farmerId, () => _Supplier(o.farmerId, o.farmerName))
        .orders
        .add(o);
  }
  return map.values.toList()
    ..sort((a, b) => b.orders.length.compareTo(a.orders.length));
}

enum _Filter { all, fav, fresh }

/// 119 Suppliers (Figma 292:1358): the farmers this buyer has ordered from.
class SuppliersScreen extends ConsumerStatefulWidget {
  const SuppliersScreen({super.key});

  @override
  ConsumerState<SuppliersScreen> createState() => _SuppliersState();
}

class _SuppliersState extends ConsumerState<SuppliersScreen> {
  final _q = TextEditingController();
  _Filter _f = _Filter.all;

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    final orders = ref.watch(myOrdersProvider).value;
    final favs = me?.favSuppliers ?? const <String>[];
    final now = DateTime.now();
    final q = _q.text.trim().toLowerCase();

    final rows = <Widget>[];
    for (final s in _suppliersOf(orders ?? const [])) {
      final fav = favs.contains(s.farmerId);
      final isNew = s.first != null && now.difference(s.first!) < _newFor;
      if (_f == _Filter.fav && !fav) continue;
      if (_f == _Filter.fresh && !isNew) continue;
      final u = ref.watch(userByIdProvider(s.farmerId)).value;
      final district = u == null
          ? ''
          : BdPlace.display(u.location.district, lang);
      if (q.isNotEmpty &&
          !s.farmerName.toLowerCase().contains(q) &&
          !district.toLowerCase().contains(q)) {
        continue;
      }
      rows.add(
        KsListItem(
          thumb: KsNetImage(
            url: u?.photoUrl,
            thumbSize: KsListItem.thumbSize.round(),
            fallbackAsset: AppUi.avatarFarmer,
          ),
          title: u?.name ?? s.farmerName,
          subtitle: l.supLine(
            district,
            u == null || u.ratingCount == 0
                ? l.notAvailable
                : Fmt.number(context, u.ratingAvg, decimals: 1),
            Fmt.digits(context, '${s.orders.length}'),
          ),
          trailingText: fav ? l.supFavTag : null,
          onTap: () => context.push(Routes.supplier(s.farmerId)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.supTitle),
      body: ListView(
        padding: _pad,
        children: [
          KsSearchBar(
            hint: l.supSearchHint,
            controller: _q,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.block),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final (f, label) in [
                (_Filter.all, l.supAll),
                (_Filter.fav, l.supFav),
                (_Filter.fresh, l.supNew),
              ])
                KsPill(
                  label: label,
                  selected: _f == f,
                  onTap: () => setState(() => _f = f),
                ),
            ],
          ),
          if (orders == null) ...[
            const SizedBox(height: AppSpacing.block),
            const KsSkeletonList(rows: 3),
          ] else if (rows.isEmpty) ...[
            const SizedBox(height: AppSpacing.xl),
            Text(
              l.supEmpty,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.normal.withColor(
                AppColors.textSecondary,
              ),
            ),
          ],
          for (final r in rows) ...[
            const SizedBox(height: AppSpacing.block),
            r,
          ],
        ],
      ),
    );
  }
}

/// 120 Supplier Profile (Figma 292:1374): how this farmer has supplied
/// this buyer — from the buyer's own orders, weighing and inspections.
class SupplierProfileScreen extends ConsumerWidget {
  const SupplierProfileScreen({super.key, required this.farmerId});
  final String farmerId;

  /// Share of the ordered kg the buyer accepted on one order:
  /// inspection decision when there is one, else the order was taken.
  static double _accepted(TradeOrder o, Inspection? x) {
    if (x != null && x.done) {
      return switch (x.decision) {
        InspectionDecision.cancel => 0,
        InspectionDecision.partial =>
          (x.weighedKg ?? 0) <= 0
              ? 0
              : ((x.acceptKg ?? 0) / x.weighedKg!).clamp(0, 1).toDouble(),
        _ => 1,
      };
    }
    return 1;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    final u = ref.watch(userByIdProvider(farmerId)).value;
    final all = (ref.watch(myOrdersProvider).value ?? const <TradeOrder>[])
        .where((o) => o.farmerId == farmerId)
        .toList();
    if (u == null || me == null) {
      return Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(title: l.supProfileTitle),
        body: const KsSkeletonList(rows: 3),
      );
    }

    // Orders checked at the farm (weighing or the buyer's inspector).
    final checked = <(TradeOrder, double)>[];
    for (final o in all) {
      final x = ref.watch(inspectionProvider(o.id)).value;
      final loaded = o.timeline.containsKey('pickedUp');
      // Loaded, or the buyer's inspector already decided at the farm.
      final inspected = x != null && x.done;
      if (loaded || inspected) checked.add((o, _accepted(o, x)));
    }
    num kgOf(TradeOrder o) => o.orderedKg ?? o.quantityKg;
    double? ratio(
      Iterable<(TradeOrder, double)> xs,
      num Function(TradeOrder, double) part,
    ) {
      final whole = xs.fold<num>(0, (a, e) => a + kgOf(e.$1));
      if (whole <= 0) return null;
      return (xs.fold<num>(0, (a, e) => a + part(e.$1, e.$2)) / whole)
          .clamp(0, 1)
          .toDouble();
    }

    final loaded = checked.where((e) => e.$1.timeline.containsKey('pickedUp'));
    final totalKg = loaded.fold<num>(0, (a, e) => a + e.$1.quantityKg);
    final onTime = loaded.isEmpty
        ? null
        : loaded.where((e) => TradeStatsRepository.farmerOnTime(e.$1)).length /
              loaded.length;
    final quality = ratio(checked, (o, acc) => kgOf(o) * acc);
    final since = DateTime.now().subtract(
      const Duration(days: 30 * _perfMonths),
    );
    final recent = checked.where(
      (e) => e.$1.createdAt != null && e.$1.createdAt!.isAfter(since),
    );
    final delivered = ratio(
      recent,
      (o, _) => o.timeline.containsKey('pickedUp') ? o.quantityKg : 0,
    );
    final accept = ratio(recent, (o, acc) => kgOf(o) * acc);

    String pct(double? v) => v == null
        ? l.notAvailable
        : l.pctText(Fmt.digits(context, '${(v * 100).round()}'));
    final fav = me.favSuppliers.contains(farmerId);

    Future<void> toggleFav() async {
      final repo = ref.read(userRepositoryProvider);
      try {
        await repo.setFavSupplier(me.uid, farmerId, !fav);
        if (!context.mounted) return;
        KsToast.show(
          context,
          fav ? l.toastFavRemoved : l.toastFavAdded,
          actionLabel: l.toastUndo,
          onAction: () => repo.setFavSupplier(me.uid, farmerId, fav),
        );
      } catch (_) {
        if (context.mounted) KsToast.show(context, l.errorGeneric);
      }
    }

    Widget stat(String label, String value) => Expanded(
      child: KsStatCard(label: label, value: value),
    );

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.supProfileTitle),
      body: ListView(
        padding: _pad,
        children: [
          KsListItem(
            thumb: KsNetImage(
              url: u.photoUrl,
              thumbSize: KsListItem.thumbSize.round(),
              fallbackAsset: AppUi.avatarFarmer,
            ),
            title: u.name,
            subtitle: l.supStatusLine(
              u.isVerified ? l.verifiedBadge : l.notVerified,
              BdPlace.display(u.location.district, lang),
            ),
            onTap: () => context.push(Routes.buyerFarmer(farmerId)),
          ),
          const SizedBox(height: AppSpacing.block),
          Row(
            children: [
              stat(
                l.statRating,
                u.ratingCount == 0
                    ? l.notAvailable
                    : Fmt.number(context, u.ratingAvg, decimals: 1),
              ),
              const SizedBox(width: AppSpacing.lg),
              stat(l.statOnTime, pct(onTime)),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          Row(
            children: [
              stat(l.supQuality, pct(quality)),
              const SizedBox(width: AppSpacing.lg),
              stat(
                l.supTotal,
                totalKg == 0 ? l.notAvailable : tonsText(context, totalKg),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          KsSectionHeader(
            title: l.supPerf(Fmt.digits(context, '$_perfMonths')),
          ),
          const SizedBox(height: AppSpacing.block),
          _Progress(
            label: l.supCommitted,
            value: delivered,
            text: pct(delivered),
          ),
          const SizedBox(height: AppSpacing.block),
          _Progress(label: l.supAcceptance, value: accept, text: pct(accept)),
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          Row(
            children: [
              Expanded(
                child: KsButton.outline(
                  label: l.messageBtn,
                  onPressed: () => openChatWith(context, ref, farmerId),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: KsButton(
                  label: fav ? l.supRemoveFav : l.supAddFav,
                  onPressed: toggleFav,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Figma "Progress": label + value, 8px track (muted) with brand fill.
class _Progress extends StatelessWidget {
  const _Progress({
    required this.label,
    required this.value,
    required this.text,
  });
  final String label;
  final double? value;
  final String text;

  static const _h = 8.0;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(label, style: AppTypography.bodySmallEmphasis.normal),
          ),
          Text(text, style: AppTypography.bodySmallStrong.normal),
        ],
      ),
      const SizedBox(height: AppSpacing.xs + AppSpacing.s2xs),
      ClipRRect(
        borderRadius: BorderRadius.circular(_h / 2),
        child: SizedBox(
          height: _h,
          child: Stack(
            children: [
              const Positioned.fill(
                child: ColoredBox(color: AppColors.bgMuted),
              ),
              FractionallySizedBox(
                widthFactor: value ?? 0,
                heightFactor: 1,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.bgBrand,
                    borderRadius: BorderRadius.all(Radius.circular(_h / 2)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
