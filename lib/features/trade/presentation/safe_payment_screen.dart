import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

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
import '../../../shared/widgets/ks_option_card.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../farmer/domain/listing.dart';
import '../data/payment_service.dart';
import '../data/trade_repository.dart';
import '../domain/trade_models.dart';

/// Everything Place Order (78) worked out, handed to Safe Payment (82).
class OrderDraft {
  const OrderDraft({
    required this.listing,
    this.offer,
    required this.quantityKg,
    required this.pricePerKg,
    required this.mode,
    required this.transportFare,
    required this.dropoff,
    required this.cropTotal,
    required this.fee,
    required this.total,
  });
  final Listing listing;
  final Offer? offer;
  final num quantityKg;
  final num pricePerKg;
  final TransportMode mode;
  final num transportFare;
  final UserLocation dropoff;
  final num cropTotal;
  final num fee;
  final num total;
}

enum _Method { bank, bkash }

/// 82 Safe Payment (Figma 292:1526). UI only — [PaymentService] is the
/// placeholder; no real money moves. Pops with the new order id.
class SafePaymentScreen extends ConsumerStatefulWidget {
  const SafePaymentScreen({super.key, required this.draft});
  final OrderDraft draft;

  @override
  ConsumerState<SafePaymentScreen> createState() => _SafePaymentState();
}

class _SafePaymentState extends ConsumerState<SafePaymentScreen> {
  _Method _method = _Method.bank;
  bool _busy = false;

  static const _optionImage = 36.0;
  static const _optionPy = 12.0;

  Future<void> _pay(AppUser me) async {
    final l = AppLocalizations.of(context);
    final d = widget.draft;
    setState(() => _busy = true);
    try {
      final pay = await ref.read(paymentServiceProvider).holdForOrder(
            orderNo: d.listing.id,
            amountBdt: d.total,
            payerUid: me.uid,
          );
      if (!pay.success) throw Exception('payment');
      final order = await ref.read(tradeRepositoryProvider).placeOrder(
            buyer: me,
            listing: d.listing,
            offer: d.offer,
            quantityKg: d.quantityKg,
            pricePerKg: d.pricePerKg,
            mode: d.mode,
            transportFare: d.transportFare,
            dropoff: d.dropoff,
            paymentRef: '${_method.name}:${pay.reference ?? ''}',
          );
      if (mounted) context.pop(order.id);
    } on TradeException catch (e) {
      if (mounted) {
        KsToast.show(context,
            e.code == 'qty_too_much' ? l.errQtyTooMuch : l.errorGeneric);
      }
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
    final me = ref.watch(currentUserProvider).value;
    final d = widget.draft;
    String tk(num v) => Fmt.taka(context, v);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.safePayTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
            AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
        children: [
          KsInfoBox(children: [
            KsInfoRow(l.rowOrder,
                l.orderLine(l.newOrderLabel, d.listing.cropName(lang))),
            KsInfoRow(l.rowCropPrice, tk(d.cropTotal)),
            if (d.mode == TransportMode.platform)
              KsInfoRow(l.rowTransport, tk(d.transportFare)),
            KsInfoRow(
                l.rowPlatformFee(Fmt.digits(
                    context, '${TradeRepository.platformFeePct}')),
                tk(d.fee)),
            KsInfoRow(l.rowTotal, tk(d.total)),
          ]),
          const SizedBox(height: AppSpacing.block),
          Text(l.safePayExplain,
              style: AppTypography.bodySmall.normal
                  .withColor(AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.block),
          KsOptionCard(
            image: const AssetImage(AppUi.glyphWallet),
            imageSize: _optionImage,
            verticalPadding: _optionPy,
            titleStyleSmall: true,
            title: l.payBank,
            subtitle: l.payDemoSub,
            selected: _method == _Method.bank,
            onTap: () => setState(() => _method = _Method.bank),
          ),
          const SizedBox(height: AppSpacing.block),
          KsOptionCard(
            image: const AssetImage(AppUi.glyphWallet),
            imageSize: _optionImage,
            verticalPadding: _optionPy,
            titleStyleSmall: true,
            title: l.payBkash,
            selected: _method == _Method.bkash,
            onTap: () => setState(() => _method = _Method.bkash),
          ),
          const SizedBox(height: AppSpacing.block),
          // Payment Methods (197–201) are Tier B.
          KsListItem(
            title: l.payAddMethod,
            subtitle: l.payAddMethodSub,
            onTap: () => KsToast.comingSoon(context),
          ),
          const SizedBox(
              height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
          KsButton(
            label: l.payNow(tk(d.total)),
            loading: _busy,
            onPressed: me == null ? null : () => _pay(me),
          ),
        ],
      ),
    );
  }
}
