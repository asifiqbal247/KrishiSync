import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/services/pdf_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../buyer/presentation/buyer_common.dart';
import '../../transport/data/transport_repository.dart';
import '../../transport/presentation/load_screens.dart';
import '../../transport/presentation/transport_common.dart';
import '../data/trade_repository.dart';
import '../domain/trade_models.dart';

/// 109 Traceability Record (buyer, Figma 292:3170): farm → weighing → truck
/// → delivery for one order. A demand filled by several farmers shows one
/// pill per farmer.
class TraceScreen extends ConsumerStatefulWidget {
  const TraceScreen({super.key, required this.orderId});
  final String orderId;

  @override
  ConsumerState<TraceScreen> createState() => _TraceState();
}

class _TraceState extends ConsumerState<TraceScreen> {
  String? _picked;
  static const _qr = 200.0;

  String _time(BuildContext context, DateTime d) => l10nTime(context, d);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final main = ref.watch(orderProvider(widget.orderId)).value;
    if (main == null) {
      return Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(title: l.traceTitle),
        body: const KsSkeletonList(),
      );
    }
    final mine = ref.watch(myOrdersProvider).value ?? const <TradeOrder>[];
    final group = main.demandId == null
        ? [main]
        : mine
            .where((o) =>
                o.demandId == main.demandId &&
                o.status != OrderStatus.cancelled)
            .toList();
    if (group.isEmpty) group.add(main);
    final o = group.firstWhere((x) => x.id == (_picked ?? main.id),
        orElse: () => main);
    final d = o.transportMode == TransportMode.platform
        ? ref.watch(deliveryProvider(o.id)).value
        : null;
    final totalKg = group.fold<num>(0, (a, x) => a + x.quantityKg);
    final delivered = group
        .map((x) => x.timeline['delivered'])
        .whereType<DateTime>()
        .toList()
      ..sort();
    final loadedAt = o.timeline['pickedUp'];
    final deliveredAt = o.timeline['delivered'];

    final steps = <(String, String, bool, VoidCallback?)>[
      (
        l.traceFarmer(o.farmerName, districtOf(context, o.pickup)),
        o.pickupDate == null
            ? l.gradeLabel(o.grade)
            : l.traceReady(Fmt.date(context, o.pickupDate!), o.grade),
        true,
        null,
      ),
      (
        l.traceLoadWeigh,
        loadedAt == null
            ? l.stepWaiting
            : l.nameDot(_time(context, loadedAt), qtyText(context, o.quantityKg)),
        loadedAt != null,
        o.loadPhotos.isEmpty ? null : () => showLoadPhotos(context, o),
      ),
      (
        o.transportMode == TransportMode.self
            ? l.traceSelfTransport
            : l.traceTransport(o.transporterName ?? l.stepWaiting),
        d?.vehicle == null
            ? (o.transportMode == TransportMode.self ? o.buyerName : l.stepWaiting)
            : l.nameDot(vehicleTypeLabel(l, d!.vehicle!.type), Fmt.plate(context, d.vehicle!.plateNo)),
        o.transporterId != null || o.transportMode == TransportMode.self,
        null,
      ),
      (
        l.traceDelivery(districtOf(context, o.dropoff)),
        deliveredAt == null
            ? l.stepWaiting
            : o.transportMode == TransportMode.platform
                ? l.traceOtpVerified(_time(context, deliveredAt))
                : l.traceReceived(_time(context, deliveredAt)),
        deliveredAt != null,
        null,
      ),
    ];

    final summary = [
      l.traceHeader,
      l.traceOrderLine(o.orderNo, o.cropName(lang), qtyText(context, totalKg)),
      for (final x in group)
        l.traceFarmerLine(x.farmerName, districtOf(context, x.pickup),
            qtyText(context, x.quantityKg), l.gradeLabel(x.grade)),
      for (final s in steps.skip(1).where((s) => s.$3)) '${s.$1}: ${s.$2}',
      l.statementVerified,
    ].join('\n');

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.traceTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
            AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
        children: [
          KsListItem(
            thumb: KsNetImage(
              url: o.photo,
              thumbSize: KsListItem.thumbSize.round(),
              fallbackAsset: CropCatalog.imageFor(o.cropKey),
            ),
            title: l.traceOrderTitle(
                main.orderNo, o.cropName(lang), qtyText(context, totalKg)),
            subtitle: [
              l.traceFarmers(Fmt.digits(context, '${group.length}')),
              if (delivered.isNotEmpty)
                l.traceDelivered(Fmt.date(context, delivered.last)),
            ].join(' · '),
            trailingText: l.qrLabel,
            onTap: () => _showQr(context, summary),
          ),
          if (group.length > 1) ...[
            const SizedBox(height: AppSpacing.block),
            Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
              for (final x in group)
                KsPill(
                  label: x.farmerName,
                  selected: x.id == o.id,
                  onTap: () => setState(() => _picked = x.id),
                ),
            ]),
          ],
          for (final s in steps) ...[
            const SizedBox(height: AppSpacing.block),
            KsTimelineItem(
                title: s.$1, subtitle: s.$2, done: s.$3, onTap: s.$4),
          ],
          const SizedBox(
              height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
          Row(children: [
            Expanded(
              child: KsButton.outline(
                label: l.pdfShort,
                onPressed: () => PdfService.share(
                  context,
                  title: l.traceTitle,
                  fileName: 'trace-${main.orderNo}',
                  children: [
                    Text(
                        l.traceOrderTitle(main.orderNo, o.cropName(lang),
                            qtyText(context, totalKg)),
                        style: AppTypography.bodyMediumStrong.normal),
                    for (final x in group)
                      Text(
                          l.traceFarmerLine(
                              x.farmerName,
                              districtOf(context, x.pickup),
                              qtyText(context, x.quantityKg),
                              l.gradeLabel(x.grade)),
                          style: AppTypography.caption.normal),
                    for (final s in steps) ...[
                      const SizedBox(height: AppSpacing.block),
                      KsTimelineItem(
                          title: s.$1, subtitle: s.$2, done: s.$3),
                    ],
                    const SizedBox(height: AppSpacing.block),
                    Center(
                      child: ColoredBox(
                        color: AppColors.bgPage,
                        child: QrImageView(data: summary, size: _qr),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: KsButton(
                label: l.qrShare,
                onPressed: () => _showQr(context, summary),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Future<void> _showQr(BuildContext context, String summary) async {
    final l = AppLocalizations.of(context);
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.traceTitle, style: AppTypography.headingBold20.normal),
              const SizedBox(height: AppSpacing.block),
              ColoredBox(
                color: AppColors.bgPage,
                child: QrImageView(data: summary, size: _qr),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(l.shareQrNote,
                  textAlign: TextAlign.center,
                  style: AppTypography.caption.normal
                      .withColor(AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.block),
              KsButton(
                label: l.shareNow,
                onPressed: () =>
                    SharePlus.instance.share(ShareParams(text: summary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "১৮ সেপ্টে. ৮:২০"
String l10nTime(BuildContext context, DateTime d) => Fmt.digits(
    context,
    '${DateFormat.MMMd(Localizations.localeOf(context).languageCode).format(d)} '
    '${DateFormat('H:mm').format(d)}');
