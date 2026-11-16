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
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../../auth/data/user_repository.dart';
import '../../buyer/presentation/buyer_common.dart';
import '../../buyer/presentation/supplier_screens.dart' show ProgressRow;
import '../../transport/presentation/transport_common.dart';
import '../data/demand_repository.dart';

const _pad = EdgeInsets.fromLTRB(
  AppSpacing.screen,
  AppSpacing.contentTop,
  AppSpacing.screen,
  AppSpacing.lg,
);
const _mapH = 120.0;
const _gapBeforeCta = AppSpacing.block + AppSpacing.xs + AppSpacing.block;

num _sum(Iterable<Commit> cs) => cs.fold<num>(0, (a, c) => a + c.quantityKg);

/// A commitment "matches" when the farmer is ready by the delivery date.
bool _matches(Demand d, Commit c) =>
    d.deliveryDate == null ||
    c.readyDate == null ||
    !c.readyDate!.isAfter(d.deliveryDate!);

/// Loads the demand + its commitments, or a skeleton.
Widget _withDemand(
  BuildContext context,
  WidgetRef ref,
  String demandId,
  String title,
  Widget Function(Demand d, List<Commit> commits) body,
) {
  final d = ref.watch(demandProvider(demandId)).value;
  final cs = ref.watch(commitsProvider(demandId)).value;
  if (d == null || cs == null) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: title),
      body: const KsSkeletonList(rows: 3),
    );
  }
  return body(d, cs);
}

/// 102 Multi-Farmer Matching (Figma 292:1196): farmers who committed to a
/// demand, on a map; the buyer picks who goes into the pool.
class MatchingScreen extends ConsumerStatefulWidget {
  const MatchingScreen({super.key, required this.demandId});
  final String demandId;

  @override
  ConsumerState<MatchingScreen> createState() => _MatchingState();
}

class _MatchingState extends ConsumerState<MatchingScreen> {
  Set<String>? _picked;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    return _withDemand(context, ref, widget.demandId, l.matchTitle, (d, cs) {
      final pending = cs.where((c) => c.status == CommitStatus.pending).toList()
        ..sort((a, b) => b.quantityKg.compareTo(a.quantityKg));
      // Matched farmers start selected.
      final picked = _picked ??= {
        for (final c in pending)
          if (_matches(d, c)) c.farmerId,
      };
      return Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(title: l.matchTitle),
        body: ListView(
          padding: _pad,
          children: [
            Text(
              l.matchHeader(
                d.cropName(lang),
                qtyText(context, d.quantityKg),
                placeFull(context, d.dropoff),
              ),
              style: AppTypography.bodyMediumStrong.normal,
            ),
            const SizedBox(height: AppSpacing.block),
            KsRouteMap(
              height: _mapH,
              to: d.dropoff.geo,
              points: [for (final c in pending) ?c.pickup.geo],
            ),
            if (pending.isEmpty) ...[
              const SizedBox(height: AppSpacing.block),
              Text(
                l.matchNone,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.normal.withColor(
                  AppColors.textSecondary,
                ),
              ),
            ],
            for (final c in pending) ...[
              const SizedBox(height: AppSpacing.block),
              KsListItem(
                thumb: KsNetImage(
                  url: c.photoUrl,
                  thumbSize: KsListItem.thumbSize.round(),
                  fallbackAsset: AppUi.avatarFarmer,
                ),
                title: c.farmerName,
                subtitle: l.matchSub(
                  districtOf(context, c.pickup),
                  qtyText(context, c.quantityKg),
                ),
                trailingText: _matches(d, c) ? l.matchOk : null,
                badge: _matches(d, c) ? null : l.matchWait,
                badgeColor: AppColors.bgWarningSubtle,
                badgeTextColor: AppColors.textWarning,
                highlighted: picked.contains(c.farmerId),
                onTap: () => setState(
                  () => picked.contains(c.farmerId)
                      ? picked.remove(c.farmerId)
                      : picked.add(c.farmerId),
                ),
              ),
            ],
            const SizedBox(height: _gapBeforeCta),
            KsButton(
              label: l.addToPool,
              onPressed: picked.isEmpty
                  ? null
                  : () =>
                        context.push(Routes.pool(d.id), extra: picked.toList()),
            ),
          ],
        ),
      );
    });
  }
}

/// 103 Digital Pooling (Figma 292:1207): the pooled farmers, progress to
/// the demand's target, what is left and the average price.
class PoolScreen extends ConsumerWidget {
  const PoolScreen({
    super.key,
    required this.demandId,
    required this.farmerIds,
  });
  final String demandId;
  final List<String> farmerIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    return _withDemand(context, ref, demandId, l.poolTitle, (d, cs) {
      final accepted = cs.where((c) => c.status == CommitStatus.accepted);
      final pool = cs
          .where(
            (c) =>
                c.status == CommitStatus.pending &&
                farmerIds.contains(c.farmerId),
          )
          .toList();
      final got = _sum(accepted) + _sum(pool);
      final share = d.quantityKg <= 0
          ? 0.0
          : (got / d.quantityKg).clamp(0, 1).toDouble();
      final left = d.quantityKg - got;
      return Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(title: l.poolTitle),
        body: ListView(
          padding: _pad,
          children: [
            ProgressRow(
              label: l.poolTarget(d.cropName(lang)),
              value: share,
              text: l.ofKg(
                Fmt.number(context, got),
                Fmt.number(context, d.quantityKg),
              ),
            ),
            const SizedBox(height: AppSpacing.block),
            Text(
              l.poolFarmers(Fmt.digits(context, '${pool.length}')),
              style: AppTypography.bodyMediumStrong.normal,
            ),
            for (final c in pool) ...[
              const SizedBox(height: AppSpacing.block),
              KsListItem(
                thumb: KsNetImage(
                  url: c.photoUrl,
                  thumbSize: KsListItem.thumbSize.round(),
                  fallbackAsset: AppUi.avatarFarmer,
                ),
                title: c.farmerName,
                subtitle: l.poolFarmerSub(
                  qtyText(context, c.quantityKg),
                  c.readyDate == null
                      ? l.notAvailable
                      : Fmt.date(context, c.readyDate!),
                ),
                onTap: () => context.push(Routes.buyerFarmer(c.farmerId)),
              ),
            ],
            const SizedBox(height: AppSpacing.block),
            KsInfoBox(
              children: [
                KsInfoRow(
                  l.rowLeft,
                  left <= 0 ? qtyText(context, 0) : qtyText(context, left),
                  boldValue: true,
                ),
                // Every farmer supplies at the buyer's target price.
                KsInfoRow(
                  l.rowAvgPrice,
                  l.priceLine(Fmt.number(context, d.targetPrice)),
                  boldValue: true,
                ),
              ],
            ),
            const SizedBox(height: _gapBeforeCta),
            KsButton(
              label: l.poCreate,
              onPressed: pool.isEmpty
                  ? null
                  : () => context.push(
                      Routes.purchaseOrder(d.id),
                      extra: farmerIds,
                    ),
            ),
          ],
        ),
      );
    });
  }
}

/// 104 Purchase Order (Figma 292:1230): one PO for the pool. Confirming
/// pays (placeholder) and creates one order per farmer.
class PurchaseOrderScreen extends ConsumerStatefulWidget {
  const PurchaseOrderScreen({
    super.key,
    required this.demandId,
    required this.farmerIds,
  });
  final String demandId;
  final List<String> farmerIds;

  @override
  ConsumerState<PurchaseOrderScreen> createState() => _PoState();
}

class _PoState extends ConsumerState<PurchaseOrderScreen> {
  bool _busy = false;
  late final Future<String> _preview = ref
      .read(demandRepositoryProvider)
      .peekPoNo();

  Future<void> _confirm(Demand d, List<Commit> pool, num accepted) async {
    final l = AppLocalizations.of(context);
    final me = ref.read(currentUserProvider).value;
    if (me == null) return;
    setState(() => _busy = true);
    try {
      final no = await ref
          .read(demandRepositoryProvider)
          .confirmPo(d, pool, me, accepted);
      if (!mounted) return;
      KsToast.show(
        context,
        l.poDone(no, Fmt.digits(context, '${pool.length}')),
      );
      context.go(Routes.demandOffers(d.id));
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
    return _withDemand(context, ref, widget.demandId, l.poTitle, (d, cs) {
      final pool = cs
          .where(
            (c) =>
                c.status == CommitStatus.pending &&
                widget.farmerIds.contains(c.farmerId),
          )
          .toList();
      final accepted = _sum(cs.where((c) => c.status == CommitStatus.accepted));
      final kg = _sum(pool);
      return Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(title: l.poTitle),
        body: ListView(
          padding: _pad,
          children: [
            FutureBuilder<String>(
              future: _preview,
              builder: (context, snap) => KsInfoBox(
                children: [
                  KsInfoRow(
                    l.rowPoNo,
                    snap.data ?? l.notAvailable,
                    boldValue: true,
                  ),
                  KsInfoRow(
                    l.rowCrop,
                    l.cropWithGrade(d.cropName(lang), d.grade),
                    boldValue: true,
                  ),
                  KsInfoRow(
                    l.rowTotalQty,
                    qtyText(context, kg),
                    boldValue: true,
                  ),
                  KsInfoRow(
                    l.rowSupplier,
                    l.rowFarmersN(Fmt.digits(context, '${pool.length}')),
                    boldValue: true,
                  ),
                  KsInfoRow(
                    l.rowTotalValue,
                    Fmt.taka(context, kg * d.targetPrice),
                    boldValue: true,
                  ),
                  KsInfoRow(
                    l.rowDelivery,
                    l.placeDate(
                      d.deliveryDate == null
                          ? l.notAvailable
                          : Fmt.date(context, d.deliveryDate!),
                      districtOf(context, d.dropoff),
                    ),
                    boldValue: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.block),
            Text(l.poSplit, style: AppTypography.bodyMediumStrong.normal),
            for (final c in pool) ...[
              const SizedBox(height: AppSpacing.block),
              KsListItem(
                title: c.farmerName,
                subtitle: qtyText(context, c.quantityKg),
                trailingText: Fmt.taka(context, c.quantityKg * d.targetPrice),
                onTap: () => context.push(Routes.buyerFarmer(c.farmerId)),
              ),
            ],
            const SizedBox(height: _gapBeforeCta),
            KsButton(
              label: l.poConfirm,
              loading: _busy,
              onPressed: pool.isEmpty || d.status != DemandStatus.open
                  ? null
                  : () => _confirm(d, pool, accepted),
            ),
          ],
        ),
      );
    });
  }
}
