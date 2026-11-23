import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/services/pdf_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_search_bar.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../buyer/presentation/buyer_common.dart';
import '../../transport/data/transport_repository.dart';
import '../../transport/domain/delivery.dart';
import '../../transport/presentation/transport_common.dart';
import '../data/trade_repository.dart';
import '../domain/trade_models.dart';
import 'payment_screens.dart';

enum TxState { done, held, cancelled }

/// One row of the history, from an order (farmer/buyer) or a trip.
class Tx {
  const Tx({
    required this.orderId,
    required this.date,
    required this.title,
    required this.party,
    required this.amount,
    required this.state,
    this.photo,
    required this.cropKey,
    required this.search,
  });
  final String orderId;
  final DateTime date;
  final String title;
  final String party;
  final num amount;
  final TxState state;
  final String? photo;
  final String cropKey;
  final String search;
}

List<Tx> _txs(BuildContext context, AppUser me, List<TradeOrder> orders,
    List<Delivery> trips) {
  final l = AppLocalizations.of(context);
  final lang = Localizations.localeOf(context).languageCode;
  if (me.role == UserRole.transporter) {
    return [
      for (final t in trips)
        if (t.status != DeliveryStatus.open)
          Tx(
            orderId: t.orderId,
            date: t.timeline['delivered'] ?? t.createdAt ?? DateTime.now(),
            title: l.noOrderCrop(t.orderNo, t.cropName(lang)),
            party: t.buyerName,
            amount: fareOf(t),
            state: switch (t.status) {
              DeliveryStatus.delivered => TxState.done,
              DeliveryStatus.cancelled => TxState.cancelled,
              _ => TxState.held,
            },
            photo: t.photo,
            cropKey: t.cropKey,
            search: '${t.orderNo} ${t.cropNameBn} ${t.cropNameEn} ${t.buyerName}',
          ),
    ];
  }
  final farmer = me.role == UserRole.farmer;
  return [
    for (final o in orders)
      Tx(
        orderId: o.id,
        date: o.createdAt ?? DateTime.now(),
        title: l.payItemTitle(o.cropName(lang), qtyText(context, o.quantityKg)),
        party: farmer ? o.buyerName : o.farmerName,
        amount: farmer ? o.cropTotal : o.total,
        state: o.status == OrderStatus.cancelled
            ? TxState.cancelled
            : (farmer
                ? (farmerPaid(o) ? TxState.done : TxState.held)
                : (o.status.isOngoing ? TxState.held : TxState.done)),
        photo: o.photo,
        cropKey: o.cropKey,
        search:
            '${o.orderNo} ${o.cropNameBn} ${o.cropNameEn} ${farmer ? o.buyerName : o.farmerName}',
      ),
  ];
}

String _stateLabel(AppLocalizations l, TxState s, bool buyer) => switch (s) {
      TxState.done => buyer ? l.histPaid : l.histReceived,
      TxState.held => l.histHeld,
      TxState.cancelled => l.histCancelled,
    };

/// All of the user's rows (orders or trips), newest first.
List<Tx> watchTxs(BuildContext context, WidgetRef ref, AppUser me) {
  final orders = me.role == UserRole.transporter
      ? const <TradeOrder>[]
      : (ref.watch(myOrdersProvider).value ?? const <TradeOrder>[]);
  final trips = me.role == UserRole.transporter
      ? (ref.watch(myDeliveriesProvider).value ?? const <Delivery>[])
      : const <Delivery>[];
  return _txs(context, me, orders, trips)
    ..sort((a, b) => b.date.compareTo(a.date));
}

/// 62 / 129 / 186 Transaction History (Figma 292:2717).
class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() => _HistoryState();
}

class _HistoryState extends ConsumerState<TransactionHistoryScreen> {
  final _q = TextEditingController();
  TxState? _f;

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
    if (me == null) return const Scaffold(body: KsSkeletonList());
    final buyer = me.role == UserRole.buyer;
    final all = watchTxs(context, ref, me);
    final now = DateTime.now();
    final month = all
        .where((t) =>
            // A buyer has paid for held orders too; others count received.
            (buyer ? t.state != TxState.cancelled : t.state == TxState.done) &&
            t.date.year == now.year &&
            t.date.month == now.month)
        .fold<num>(0, (a, t) => a + t.amount);
    final held = all
        .where((t) => t.state == TxState.held)
        .fold<num>(0, (a, t) => a + t.amount);
    final q = _q.text.trim().toLowerCase();
    final shown = all
        .where((t) => _f == null || t.state == _f)
        .where((t) => q.isEmpty || t.search.toLowerCase().contains(q))
        .toList();
    // Group by month.
    final groups = <String, List<Tx>>{};
    for (final t in shown) {
      groups
          .putIfAbsent(DateFormat.yMMMM(lang).format(t.date), () => [])
          .add(t);
    }
    String tk(num v) => Fmt.taka(context, v);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.historyTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
            AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
        children: [
          Row(children: [
            Expanded(
                child: KsStatCard(
                    label: buyer ? l.histBuyMonth : l.histIncomeMonth,
                    value: tk(month))),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
                child: KsStatCard(label: l.payHeldFarmer, value: tk(held))),
          ]),
          const SizedBox(height: AppSpacing.block),
          KsSearchBar(
              hint: l.histSearchHint,
              controller: _q,
              onChanged: (_) => setState(() {})),
          const SizedBox(height: AppSpacing.block),
          Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
            for (final (s, label) in [
              (null, l.filterAll),
              (TxState.done, buyer ? l.histPaid : l.histReceived),
              (TxState.held, l.histHeld),
              (TxState.cancelled, l.histCancelled),
            ])
              KsPill(
                  label: label,
                  selected: _f == s,
                  onTap: () => setState(() => _f = s)),
          ]),
          if (shown.isEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            Text(l.histEmpty,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.normal
                    .withColor(AppColors.textSecondary)),
          ],
          for (final e in groups.entries) ...[
            const SizedBox(height: AppSpacing.block),
            Row(children: [
              Expanded(
                  child: Text(Fmt.digits(context, e.key),
                      style: AppTypography.bodyMediumStrong.normal)),
              Text(
                  l.monthTotal(tk(e.value
                      .where((t) => t.state != TxState.cancelled)
                      .fold<num>(0, (a, t) => a + t.amount))),
                  style: AppTypography.caption.normal
                      .withColor(AppColors.textBrand)),
            ]),
            for (final t in e.value) ...[
              const SizedBox(height: AppSpacing.block),
              KsListItem(
                thumb: KsNetImage(
                    url: t.photo,
                    thumbSize: KsListItem.thumbSize.round(),
                    fallbackAsset: CropCatalog.imageFor(t.cropKey)),
                title: t.title,
                subtitle: l.histRowSub(t.party, Fmt.date(context, t.date),
                    _stateLabel(l, t.state, buyer)),
                trailingText: tk(t.amount),
                onTap: () => context.push(Routes.receipt(t.orderId)),
              ),
            ],
          ],
          const SizedBox(
              height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
          KsButton.outline(
              label: l.statementBtn,
              onPressed: () => context.push(Routes.statement)),
        ],
      ),
    );
  }
}

enum _Period { month, three, twelve, custom }

/// 63 / 130 / 187 Statement / Export (Figma 292:2737). Shared as text;
/// PDF needs the `pdf` package (not added).
class StatementScreen extends ConsumerStatefulWidget {
  const StatementScreen({super.key});

  @override
  ConsumerState<StatementScreen> createState() => _StatementState();
}

class _StatementState extends ConsumerState<StatementScreen> {
  _Period _p = _Period.three;
  DateTimeRange? _custom;
  static const _previewH = 120.0;
  static const _shareIcon = 56.0;
  static const _shareItemW = 64.0;

  DateTimeRange _range() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day, 23, 59);
    return switch (_p) {
      _Period.month => DateTimeRange(start: DateTime(now.year, now.month), end: end),
      _Period.three =>
        DateTimeRange(start: DateTime(now.year, now.month - 2), end: end),
      _Period.twelve =>
        DateTimeRange(start: DateTime(now.year, now.month - 11), end: end),
      _Period.custom => _custom ??
          DateTimeRange(start: DateTime(now.year, now.month), end: end),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    if (me == null) return const Scaffold(body: KsSkeletonList());
    final buyer = me.role == UserRole.buyer;
    final r = _range();
    final rows = watchTxs(context, ref, me)
        .where((t) =>
            t.state != TxState.cancelled &&
            !t.date.isBefore(r.start) &&
            !t.date.isAfter(r.end))
        .toList();
    final total = rows.fold<num>(0, (a, t) => a + t.amount);
    final period = l.dateRange(Fmt.digits(context, DateFormat.yMMM(lang).format(r.start)),
        Fmt.digits(context, DateFormat.yMMM(lang).format(r.end)));
    final totalLabel = buyer ? l.rowTotalSpent : l.rowTotalIncome;
    final text = [
      l.statementHeader,
      me.name,
      '${l.rowPeriod}: $period',
      '${l.rowTotalDeals}: ${l.countTi(Fmt.digits(context, '${rows.length}'))}',
      '$totalLabel: ${Fmt.taka(context, total)}',
      '',
      for (final t in rows)
        '${Fmt.date(context, t.date)} · ${t.title} · ${t.party} · ${Fmt.taka(context, t.amount)}',
      '',
      l.statementVerified,
    ].join('\n');

    Future<void> shareSheet() =>
        SharePlus.instance.share(ShareParams(text: text));

    // WhatsApp / email open that app with the statement; if it is not
    // there, the phone's share sheet opens instead.
    Future<void> openOr(Uri uri) async {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication)
          .catchError((_) => false);
      if (!ok) await shareSheet();
    }

    // Figma 292:2760: 64 wide, 56px logo, gap 6, Medium 12 primary label.
    Widget shareButton(String label, Widget logo, VoidCallback onTap) =>
        Semantics(
          button: true,
          label: label,
          child: GestureDetector(
            onTap: onTap,
            child: SizedBox(
              width: _shareItemW,
              child: Column(children: [
                SizedBox.square(dimension: _shareIcon, child: logo),
                const SizedBox(height: AppSpacing.label),
                Text(label,
                    textAlign: TextAlign.center,
                    style: AppTypography.captionEmphasis.normal
                        .withColor(AppColors.textPrimary)),
              ]),
            ),
          ),
        );

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.statementTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
            AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
        children: [
          Text(l.periodLabel, style: AppTypography.bodySmallStrong.normal),
          const SizedBox(height: AppSpacing.block),
          Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
            for (final (p, label) in [
              (_Period.month, l.periodThisMonth),
              (_Period.three, l.periodLast3),
              (_Period.twelve, l.period12),
              (_Period.custom, l.periodCustom),
            ])
              KsPill(
                label: label,
                selected: _p == p,
                onTap: () async {
                  if (p == _Period.custom) {
                    final now = DateTime.now();
                    final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(now.year - 2),
                        lastDate: now);
                    if (picked == null) return;
                    _custom = picked;
                  }
                  setState(() => _p = p);
                },
              ),
          ]),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(children: [
            KsInfoRow(l.rowPeriod, period),
            KsInfoRow(l.rowTotalDeals,
                l.countTi(Fmt.digits(context, '${rows.length}'))),
            KsInfoRow(totalLabel, Fmt.taka(context, total)),
          ]),
          const SizedBox(height: AppSpacing.block),
          Container(
            height: _previewH,
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.bgSubtle,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: SingleChildScrollView(
              child: Text(text,
                  style: AppTypography.caption.normal
                      .withColor(AppColors.textSecondary)),
            ),
          ),
          const SizedBox(height: AppSpacing.block),
          Text(l.statementPrivacy,
              style: AppTypography.caption.normal
                  .withColor(AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.block),
          Text(l.shareLabel, style: AppTypography.bodySmallStrong.normal),
          const SizedBox(height: AppSpacing.block),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shareButton(
                l.shareWhatsapp,
                SvgPicture.asset(AppUi.shareWhatsapp),
                () => openOr(Uri.parse(
                    'whatsapp://send?text=${Uri.encodeComponent(text)}')),
              ),
              shareButton(
                l.shareEmail,
                SvgPicture.asset(AppUi.shareEmail),
                () => openOr(Uri(
                  scheme: 'mailto',
                  query: 'subject=${Uri.encodeComponent(l.statementTitle)}'
                      '&body=${Uri.encodeComponent(text)}',
                )),
              ),
              // Messenger has no "share text" link: the share sheet lists it.
              shareButton(
                l.shareMessenger,
                SvgPicture.asset(AppUi.shareMessenger),
                shareSheet,
              ),
              shareButton(
                l.shareOther,
                Image.asset(AppUi.shareOther),
                shareSheet,
              ),
            ],
          ),
          const SizedBox(
              height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
          KsButton(
              label: l.pdfDownloadFull,
              onPressed: () => PdfService.share(context,
                      title: l.statementTitle,
                      fileName: 'Golaghor-statement',
                      children: [
                        KsInfoBox(children: [
                          KsInfoRow(l.rowPeriod, period),
                          KsInfoRow(l.rowTotalDeals,
                              l.countTi(Fmt.digits(context, '${rows.length}'))),
                          KsInfoRow(totalLabel, Fmt.taka(context, total)),
                        ]),
                        const SizedBox(height: AppSpacing.block),
                        Text(text, style: AppTypography.caption.normal),
                      ])),
        ],
      ),
    );
  }
}
