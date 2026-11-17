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
import '../../../shared/services/bd_location_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_states.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../auth/data/user_repository.dart';
import '../../farmer/data/trade_doc_repository.dart';
import '../../farmer/presentation/trade_doc_screen.dart' show tradeDocName;
import '../data/trade_repository.dart';
import '../domain/trade_models.dart';

/// 16 / 72 / 142 Notifications. Text is built from ARB keys + params,
/// so it follows the app language.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  static (String, String) text(BuildContext context, AppNotification n) {
    final l = AppLocalizations.of(context);
    final bn = Localizations.localeOf(context).languageCode == 'bn';
    final p = n.params;
    final crop = (bn ? p['cropBn'] : p['cropEn']) ?? '';
    String num(String? v) => Fmt.number(context, double.tryParse(v ?? '') ?? 0);
    String docName(String? t) => tradeDocName(
      l,
      TradeDocType.values.firstWhere(
        (x) => x.name == t,
        orElse: () => TradeDocType.phyto,
      ),
    );
    return switch (n.type) {
      'offer_new' => (
        l.nOfferNew(crop),
        l.nOfferNewBody(
          p['buyer'] ?? '',
          num(p['price']),
          l.qtyKg(num(p['qty'])),
        ),
      ),
      'offer_counter' => (
        l.nOfferCounter(crop),
        l.nOfferCounterBody(p['farmer'] ?? '', num(p['price'])),
      ),
      'offer_accepted' => (
        l.nOfferAccepted(crop),
        l.nOfferAcceptedBody(num(p['price'])),
      ),
      'offer_rejected' => (l.nOfferRejected(crop), ''),
      'order_new' => (
        l.nOrderNew(p['no'] ?? ''),
        l.nOrderNewBody(p['buyer'] ?? '', crop, l.qtyKg(num(p['qty']))),
      ),
      'listing_approved' => (l.nListingApproved(crop), l.nListingApprovedBody),
      'listing_rejected' => (l.nListingRejected(crop), p['note'] ?? ''),
      'bid_new' => (
        l.nBidNew(p['no'] ?? ''),
        l.nBidNewBody(
          p['name'] ?? '',
          Fmt.taka(context, double.tryParse(p['fare'] ?? '') ?? 0),
        ),
      ),
      'job_assigned' => (l.nJobAssigned(p['no'] ?? ''), crop),
      'order_cancelled' => (l.nOrderCancelled(p['no'] ?? ''), crop),
      'commit_new' => (
        l.nCommitNew(crop),
        l.nCommitNewBody(p['farmer'] ?? '', l.qtyKg(num(p['qty']))),
      ),
      'commit_accepted' => (l.nCommitAccepted(p['no'] ?? ''), crop),
      'verify_ok' => (l.nVerifyOk, l.nVerifyOkBody),
      'verify_rejected' => (l.nVerifyRejected, l.nVerifyRejectedBody),
      'doc_ok' => (
        l.nDocOk(docName(p['doc'])),
        // Export papers vs a driver's licence / vehicle papers.
        p['doc'] == TradeDocType.phyto.name ||
                p['doc'] == TradeDocType.license.name
            ? l.nDocOkBody
            : l.nDocOkDriverBody,
      ),
      'doc_rejected' => (l.nDocRejected(docName(p['doc'])), l.nDocRejectedBody),
      'report_resolved' => (l.nReportResolved, p['note'] ?? ''),
      'report_dismissed' => (l.nReportDismissed, p['note'] ?? ''),
      'trip_picked' => (l.nTripPicked(p['no'] ?? ''), crop),
      'trip_delivered' => (l.nTripDelivered(p['no'] ?? ''), crop),
      'farmer_delivered' => (l.nFarmerDelivered(p['no'] ?? ''), crop),
      'contract_new' => (l.nContractNew(crop), p['buyer'] ?? ''),
      'contract_active' => (l.nContractActive(crop), p['name'] ?? ''),
      'contract_rejected' => (l.nContractRejected(crop), p['name'] ?? ''),
      'contract_cancelled' => (l.nContractCancelled(crop), p['name'] ?? ''),
      'contract_order' => (
        l.nContractOrder(p['no'] ?? ''),
        l.nOrderNewBody(p['buyer'] ?? '', crop, l.qtyKg(num(p['qty']))),
      ),
      'truck_booked' => (
        l.nTruckBooked(p['no'] ?? ''),
        l.nTruckBookedBody(p['name'] ?? ''),
      ),
      'extra_request' => (
        l.nExtraRequest(p['no'] ?? ''),
        l.nExtraRequestBody(l.qtyKg(num(p['qty']))),
      ),
      'extra_approved' => (l.nExtraApproved(p['no'] ?? ''), ''),
      'extra_declined' => (l.nExtraDeclined(p['no'] ?? ''), ''),
      'weight_less' => (l.nWeightLess(p['no'] ?? ''), crop),
      'loaded_paid' => (l.nLoadedPaid(p['no'] ?? ''), crop),
      'inspection_done' => (
        l.nInspectionDone(p['no'] ?? ''),
        l.nameDot(p['farmer'] ?? '', switch (p['decision']) {
          'partial' => l.decPartial,
          'cancel' => l.decCancel,
          _ => l.decApproved,
        }),
      ),
      'return_load' => (
        l.nReturnLoad(
          BdPlace.display(p['from'], bn ? 'bn' : 'en'),
          BdPlace.display(p['to'], bn ? 'bn' : 'en'),
        ),
        crop,
      ),
      'price_alert' => (
        l.nPriceAlert(crop),
        l.nPriceAlertBody(
          Fmt.taka(context, double.tryParse(p['price'] ?? '') ?? 0),
        ),
      ),
      _ => (n.type, ''),
    };
  }

  static String? routeFor(AppNotification n) {
    final link = n.link;
    if (link == null) return null;
    final i = link.indexOf(':');
    if (i < 0) return null;
    final kind = link.substring(0, i);
    final id = link.substring(i + 1);
    return switch (kind) {
      'offer' => Routes.offer(id),
      'order' => Routes.order(id),
      'listing' => Routes.farmerListingDetails(id),
      'book' => Routes.buyerBook(id),
      'job' => Routes.trJob(id),
      'return' => Routes.trReturnDone(id),
      // tradeDocs id = {uid}_{type}
      'doc' when id.contains('_') => Routes.tradeDoc(
        id.substring(0, id.lastIndexOf('_')),
        id.substring(id.lastIndexOf('_') + 1),
      ),
      'load' => Routes.trLoad(id),
      'demand' => Routes.demandOffers(id),
      'price' => Routes.priceTrend(id),
      'contract' => Routes.contractStatus(id),
      'truck' || 'loaded' => Routes.farmerLoad(id),
      'delivered' => Routes.farmerDelivered(id),
      'extra' => Routes.extraWeight(id),
      'weight' => Routes.weightDiff(id),
      'rescue' => Routes.rescue(id),
      'inspection' => Routes.loadReport(id),
      'trace' => Routes.trace(id),
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final uid = ref.watch(currentUserProvider).value?.uid;
    final async = ref.watch(myNotificationsProvider);
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.notifTitle),
      body: async.when(
        loading: () => const KsSkeletonList(),
        error: (e, _) => KsErrorState.from(
          e,
          onRetry: () => ref.invalidate(myNotificationsProvider),
        ),
        data: (list) => list.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(AppSpacing.screen),
                child: Text(
                  l.notifEmpty,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.normal.withColor(
                    AppColors.textSecondary,
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.contentTop,
                  AppSpacing.screen,
                  AppSpacing.lg,
                ),
                itemCount: list.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (_, i) {
                  final n = list[i];
                  final (title, body) = text(context, n);
                  final route = routeFor(n);
                  return KsListItem(
                    highlighted: !n.read,
                    thumb: Image.asset(AppUi.tileBell, fit: BoxFit.cover),
                    title: title,
                    subtitle: [
                      if (body.isNotEmpty) body,
                      if (n.createdAt != null) Fmt.date(context, n.createdAt!),
                    ].join(' · '),
                    showChevron: route != null,
                    onTap: () {
                      if (uid != null && !n.read) {
                        ref.read(tradeRepositoryProvider).markRead(uid, n.id);
                      }
                      if (route != null) context.push(route);
                    },
                  );
                },
              ),
      ),
    );
  }
}
