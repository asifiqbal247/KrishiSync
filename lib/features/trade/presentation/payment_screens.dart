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
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../buyer/presentation/buyer_common.dart';
import '../../transport/presentation/transport_common.dart';
import '../data/trade_repository.dart';
import '../domain/trade_models.dart';
import '../../profile/presentation/payment_method_screens.dart';

const _pad = EdgeInsets.fromLTRB(
    AppSpacing.screen, AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg);

/// Farmer is paid when the crop is loaded (safe payment rule).
bool farmerPaid(TradeOrder o) =>
    o.status != OrderStatus.cancelled &&
    OrderStatus.values.indexOf(o.status) >=
        OrderStatus.values.indexOf(OrderStatus.pickedUp);

bool _thisMonth(DateTime? d) {
  final now = DateTime.now();
  return d != null && d.year == now.year && d.month == now.month;
}

/// "01712-XXXXXX" from "+8801712345678".
String maskedPhone(String e164) {
  final local = e164.startsWith('+88') ? e164.substring(3) : e164;
  if (local.length < 5) return local;
  return '${local.substring(0, 5)}-${'X' * (local.length - 5)}';
}

Widget _cropThumb(TradeOrder o) => KsNetImage(
    url: o.photo,
    thumbSize: KsListItem.thumbSize.round(),
    fallbackAsset: CropCatalog.imageFor(o.cropKey));

/// 56 Payments (farmer, Figma 292:798) / 124 Payments (buyer, 292:1513).
/// All amounts come from real orders; the payment itself is a placeholder.
class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    final async = ref.watch(myOrdersProvider);
    final isFarmer = me?.role == UserRole.farmer;
    String tk(num v) => Fmt.taka(context, v);
    String date(DateTime? d) => d == null ? '' : Fmt.date(context, d);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.payTitle),
      body: switch (async) {
        AsyncData(value: final all) => () {
            final orders =
                all.where((o) => o.status != OrderStatus.cancelled).toList();
            final num held;
            final num month;
            if (isFarmer) {
              held = orders
                  .where((o) => !farmerPaid(o))
                  .fold<num>(0, (a, o) => a + o.cropTotal);
              month = orders
                  .where((o) =>
                      farmerPaid(o) &&
                      _thisMonth(o.timeline['pickedUp'] ?? o.createdAt))
                  .fold<num>(0, (a, o) => a + o.cropTotal);
            } else {
              held = orders
                  .where((o) => o.status.isOngoing)
                  .fold<num>(0, (a, o) => a + o.total);
              month = orders
                  .where((o) => _thisMonth(o.createdAt))
                  .fold<num>(0, (a, o) => a + o.total);
            }
            final rows = <Widget>[];
            for (final o in orders) {
              final title = l.payItemTitle(
                  o.cropName(lang), qtyText(context, o.quantityKg));
              if (isFarmer) {
                rows.add(KsListItem(
                  thumb: _cropThumb(o),
                  title: title,
                  subtitle: farmerPaid(o)
                      ? l.paySentSub(date(o.timeline['pickedUp']))
                      : l.payHeldSub(date(o.createdAt)),
                  trailingText: tk(o.cropTotal),
                  onTap: () => context.push(Routes.receipt(o.id)),
                ));
              } else {
                rows.add(KsListItem(
                  thumb: _cropThumb(o),
                  title: l.orderLine(o.orderNo, title),
                  subtitle: o.status.isOngoing
                      ? l.payHeldSub(date(o.createdAt))
                      : l.payPaidSub(date(o.createdAt)),
                  // Booked truck fare gets its own row (124); otherwise the
                  // whole amount is on the order.
                  trailingText: tk(o.transporterId == null
                      ? o.total
                      : o.cropTotal + o.platformFee),
                  onTap: () => context.push(Routes.receipt(o.id)),
                ));
                if (o.transporterId != null && o.transportFare > 0) {
                  final delivered = !o.status.isOngoing;
                  rows.add(KsListItem(
                    thumb: Image.asset(AppUi.avatarDriver, fit: BoxFit.cover),
                    title: l.payTransportTitle(o.transporterName ?? ''),
                    subtitle: delivered
                        ? l.payPaidSub(date(o.timeline['delivered']))
                        : l.payHeldSub(date(o.timeline['transportBooked'])),
                    trailingText: tk(o.transportFare),
                    onTap: () => context.push(Routes.receipt(o.id)),
                  ));
                }
              }
            }
            return ListView(
              padding: _pad,
              children: [
                Row(children: [
                  Expanded(
                      child: KsStatCard(
                          label: isFarmer ? l.payHeldFarmer : l.payHeldBuyer,
                          value: tk(held))),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                      child: KsStatCard(
                          label: isFarmer ? l.payReceivedMonth : l.payPaidMonth,
                          value: tk(month))),
                ]),
                if (isFarmer && me != null) ...[
                  const SizedBox(height: AppSpacing.block),
                  // Payout accounts (197–201) are Tier B.
                  KsListItem(
                    thumb: Container(
                      color: AppColors.bgSubtle,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Image.asset(AppUi.glyphWallet),
                    ),
                    title: l.payReceiveMethod,
                    subtitle: me.defaultPayout == null
                        ? l.pmNone
                        : payoutLine(l, me.defaultPayout!),
                    trailingText: l.changeLink,
                    onTap: () => context.push(Routes.paymentMethods),
                  ),
                ],
                const SizedBox(height: AppSpacing.block),
                KsSectionHeader(title: l.payHistory),
                if (rows.isEmpty) ...[
                  const SizedBox(height: AppSpacing.block),
                  Text(l.payEmpty,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.normal
                          .withColor(AppColors.textSecondary)),
                ],
                for (final r in rows) ...[
                  const SizedBox(height: AppSpacing.block),
                  r,
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

/// 58 Receipt (farmer, 292:810) / 125 (buyer, 292:1561); transporters get
/// their fare receipt from Earnings (178) and Trip Complete (168).
class ReceiptScreen extends ConsumerWidget {
  const ReceiptScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    final o = ref.watch(orderProvider(orderId)).value;
    if (o == null || me == null) {
      return Scaffold(
        appBar: KsAppBar(title: l.receiptTitle),
        body: const KsSkeletonList(rows: 3),
      );
    }
    String tk(num v) => Fmt.taka(context, v);
    final role = me.uid == o.farmerId
        ? UserRole.farmer
        : (me.uid == o.transporterId ? UserRole.transporter : UserRole.buyer);
    final method = _method(l, o);
    final created = o.createdAt ?? DateTime.now();
    final no = 'INV-${created.year}'
        '${created.month.toString().padLeft(2, '0')}'
        '${created.day.toString().padLeft(2, '0')}-'
        '${o.orderNo.replaceAll(RegExp(r'[^0-9]'), '')}';
    final crop = l.cropQty(o.cropName(lang), qtyText(context, o.quantityKg));

    final (num amount, bool paid, List<(String, String)> rows) = switch (role) {
      UserRole.farmer => (
          o.cropTotal,
          farmerPaid(o),
          [
            (l.rowReceiptNo, no),
            (l.rowBuyer, o.buyerName),
            (l.rowCrop, crop),
            (l.rowPrice, l.priceLine(Fmt.number(context, o.pricePerKg))),
            (l.rowPlatformFee(Fmt.digits(context, '0')), tk(0)),
            (l.rowDate, Fmt.date(context, o.timeline['pickedUp'] ?? created)),
          ]
        ),
      UserRole.transporter => (
          o.transportFare,
          !o.status.isOngoing,
          [
            (l.rowReceiptNo, no),
            (l.rowCustomer, o.buyerName),
            (l.rowCrop, crop),
            (
              l.rowRoute,
              l.routeLine(districtOf(context, o.pickup),
                  districtOf(context, o.dropoff))
            ),
            (l.rowDate, Fmt.date(context, o.timeline['delivered'] ?? created)),
          ]
        ),
      _ => (
          o.total,
          true,
          [
            (l.rowReceiptNo, no),
            (l.rowFarmer, o.farmerName),
            (l.rowCrop, crop),
            (l.rowPrice, l.priceLine(Fmt.number(context, o.pricePerKg))),
            if (o.transportFare > 0) (l.rowFareLabel, tk(o.transportFare)),
            (
              l.rowPlatformFee(
                  Fmt.digits(context, '${TradeRepository.platformFeePct}')),
              tk(o.platformFee)
            ),
            (l.rowDate, Fmt.date(context, created)),
          ]
        ),
    };

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.receiptTitle),
      body: ListView(
        padding: _pad,
        children: [
          const SizedBox(height: AppSpacing.block),
          Text(tk(amount),
              textAlign: TextAlign.center,
              style: AppTypography.display28.normal),
          const SizedBox(height: AppSpacing.sm),
          Text(paid ? l.receiptPaid(method) : l.receiptHeld,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.normal
                  .withColor(AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(children: [
            for (final (k, v) in rows) KsInfoRow(k, v),
          ]),
          const SizedBox(
              height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
          // PDF export is Tier C.
          KsButton.outline(
              label: l.pdfDownload,
              onPressed: () => KsToast.comingSoon(context)),
        ],
      ),
    );
  }

  /// Safe Payment (82) stores the chosen method as "bank:…" / "bkash:…".
  static String _method(AppLocalizations l, TradeOrder o) =>
      o.paymentRef.startsWith('bank') ? l.methodBank : l.methodBkash;
}
