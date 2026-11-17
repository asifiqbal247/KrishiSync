import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../../shared/widgets/ks_states.dart';
import '../../buyer/presentation/buyer_common.dart' show qtyText;
import '../../trade/data/trade_repository.dart';
import '../../trade/domain/trade_models.dart';
import '../../trade/presentation/orders_screens.dart' show orderBadge;

/// Latest orders on the platform, newest first (admin only; rules let
/// moderators and admins read every order).
final allOrdersProvider = StreamProvider.autoDispose<List<TradeOrder>>(
  (ref) => ref.watch(tradeRepositoryProvider).watchAllOrders(),
);

/// A8 Orders (admin, no Figma — same theme as A2 Users): read-only list,
/// filter by status, tap opens the order details.
/// [filter] = 'all' | 'ongoing' | an [OrderStatus] name.
class AdminOrdersScreen extends ConsumerStatefulWidget {
  const AdminOrdersScreen({super.key, this.filter = 'all'});
  final String filter;

  @override
  ConsumerState<AdminOrdersScreen> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends ConsumerState<AdminOrdersScreen> {
  /// Same as the dashboard's "ongoing" card: not completed or cancelled.
  static bool _open(OrderStatus s) =>
      s != OrderStatus.completed && s != OrderStatus.cancelled;

  late String _filter = widget.filter;

  bool _in(TradeOrder o) => switch (_filter) {
    'all' => true,
    'ongoing' => _open(o.status),
    final s => o.status.name == s,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final async = ref.watch(allOrdersProvider);
    final filters = [
      ('all', l.ordersTabAll),
      ('ongoing', l.ordersTabOngoing),
      for (final s in OrderStatus.values) (s.name, orderBadge(l, s).$1),
    ];
    final all = async.value ?? const <TradeOrder>[];
    int count(String key) => key == 'all'
        ? all.length
        : all
              .where(
                (o) =>
                    key == 'ongoing' ? _open(o.status) : o.status.name == key,
              )
              .length;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.adminOrdersTitle),
      body: switch (async) {
        AsyncError(:final error) => KsErrorState.from(
          error,
          onRetry: () => ref.invalidate(allOrdersProvider),
        ),
        AsyncData() when all.isEmpty => KsEmptyState(
          title: l.adminOrdersEmpty,
          body: l.adminOrdersEmptyBody,
        ),
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
                for (final (key, label) in filters)
                  KsPill(
                    label: async.hasValue
                        ? '$label (${Fmt.digits(context, '${count(key)}')})'
                        : label,
                    selected: _filter == key,
                    onTap: () => setState(() => _filter = key),
                  ),
              ],
            ),
            if (!async.hasValue) ...[
              const SizedBox(height: AppSpacing.block),
              const KsSkeletonList(padded: false),
            ] else if (!all.any(_in)) ...[
              const SizedBox(height: AppSpacing.block),
              Text(
                l.emptyFilter,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.normal.withColor(
                  AppColors.textSecondary,
                ),
              ),
            ] else
              for (final o in all.where(_in)) ...[
                const SizedBox(height: AppSpacing.block),
                () {
                  final (badge, bg, fg) = orderBadge(l, o.status);
                  return KsListItem(
                    thumb: KsNetImage(
                      url: o.photo,
                      thumbSize: KsListItem.thumbSize.round(),
                      fallbackAsset: CropCatalog.imageFor(o.cropKey),
                    ),
                    title: l.cropQtyTitle(
                      o.cropName(lang),
                      qtyText(context, o.quantityKg),
                    ),
                    subtitle: l.adminOrderLine(
                      o.orderNo,
                      o.farmerName,
                      o.buyerName,
                      Fmt.taka(context, o.total),
                    ),
                    subtitleMaxLines: 2,
                    badge: badge,
                    badgeColor: bg,
                    badgeTextColor: fg,
                    onTap: () => context.push(Routes.order(o.id)),
                  );
                }(),
              ],
          ],
        ),
      },
    );
  }
}
