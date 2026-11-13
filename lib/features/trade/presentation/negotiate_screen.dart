import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/data/market_price_repository.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../auth/data/user_repository.dart';
import '../../buyer/presentation/buyer_common.dart';
import '../data/trade_repository.dart';
import '../domain/trade_models.dart';

/// 25 Negotiate (Figma 292:487) + D1 reject confirm + 26 accepted modal.
/// Used by both sides; it is "my turn" when the other side spoke last.
class NegotiateScreen extends ConsumerStatefulWidget {
  const NegotiateScreen({super.key, required this.offerId});
  final String offerId;

  @override
  ConsumerState<NegotiateScreen> createState() => _NegotiateScreenState();
}

class _NegotiateScreenState extends ConsumerState<NegotiateScreen> {
  final _counter = TextEditingController();
  bool _busy = false;
  String? _err;

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } catch (_) {
      if (mounted) KsToast.show(context, AppLocalizations.of(context).errorGeneric);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    final o = ref.watch(offerProvider(widget.offerId)).value;
    if (o == null || me == null) {
      return Scaffold(
        appBar: KsAppBar(title: l.negotiateTitle),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final iAmFarmer = me.uid == o.farmerId;
    final otherUid = iAmFarmer ? o.buyerId : o.farmerId;
    final other = ref.watch(userByIdProvider(otherUid)).value;
    final market = ref.watch(marketPriceProvider(o.cropKey)).value;
    final myTurn = o.status.isOpen && o.lastBy != (iAmFarmer ? 'farmer' : 'buyer');
    final left = o.expiresAt?.difference(DateTime.now());
    final repo = ref.read(tradeRepositoryProvider);
    final otherName = iAmFarmer ? o.buyerName : o.farmerName;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.negotiateTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
            AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
        children: [
          KsInfoBox(children: [
            KsLinkRow(
              label: iAmFarmer ? l.rowBuyer : l.rowFarmer,
              value: (other?.isVerified ?? false)
                  ? l.verifiedSuffix(otherName)
                  : otherName,
              onTap: () => iAmFarmer
                  ? null
                  : context.push(Routes.buyerFarmer(o.farmerId)),
            ),
            KsInfoRow(
                iAmFarmer
                    ? l.rowBuyerOffer
                    : (o.lastBy == 'farmer' ? l.rowFarmerCounter : l.rowMyOffer),
                l.priceLine(Fmt.number(context, o.pricePerKg))),
            KsInfoRow(iAmFarmer ? l.fieldMyPrice : l.fieldPrice,
                l.priceLine(Fmt.number(context, o.listingPrice))),
            if (market != null)
              KsInfoRow(
                  l.fieldMarketPrice,
                  l.rangeLine(Fmt.number(context, market.min),
                      Fmt.number(context, market.max))),
            KsInfoRow(l.fieldQuantity, qtyText(context, o.quantityKg)),
            KsInfoRow(l.rowPayment,
                iAmFarmer ? l.paymentSafeLoad : l.safePayment),
            if (o.status.isOpen)
              KsInfoRow(
                l.rowOfferValidity,
                left == null || left.isNegative
                    ? l.offerExpired
                    : l.hoursLeft(Fmt.digits(context, '${left.inHours}')),
              )
            else
              KsInfoRow(l.fieldAvailability, _statusText(l, o.status)),
          ]),
          if (myTurn) ...[
            const SizedBox(height: AppSpacing.block),
            KsTextField(
              label: l.counterLabel,
              hint: Fmt.number(context, o.pricePerKg),
              controller: _counter,
              suffixText: l.sellPriceUnit,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯.]'))
              ],
              errorText: _err,
            ),
            const SizedBox(
                height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
            Row(children: [
              Expanded(
                child: KsButton.destructive(
                  label: l.reject,
                  onPressed: _busy
                      ? null
                      : () async {
                          final ok = await showKsConfirm(context,
                              title: l.rejectConfirmTitle,
                              body: l.rejectConfirmBody,
                              noLabel: l.noGoBack,
                              yesLabel: l.yesReject);
                          if (!ok) return;
                          await _run(() =>
                              repo.rejectOffer(o, byUid: me.uid));
                          if (context.mounted) {
                            KsToast.show(context, l.offerRejected);
                          }
                        },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: KsButton.outline(
                  label: l.counter,
                  onPressed: _busy
                      ? null
                      : () async {
                          final p = num.tryParse(
                              Fmt.latinDigits(_counter.text.trim()));
                          if (p == null || p <= 0) {
                            setState(() => _err = l.errPriceInvalid);
                            return;
                          }
                          setState(() => _err = null);
                          await _run(() => repo.counterOffer(o,
                              byUid: me.uid, pricePerKg: p));
                          _counter.clear();
                          if (context.mounted) {
                            KsToast.show(context, l.counterSent);
                          }
                        },
                ),
              ),
            ]),
            const SizedBox(height: AppSpacing.block),
            KsButton(
              label: l.acceptOffer,
              loading: _busy,
              onPressed: () async {
                await _run(() => repo.acceptOffer(o, byUid: me.uid));
                if (!context.mounted) return;
                if (iAmFarmer) {
                  await showKsSuccessModal(
                    context,
                    title: l.offerAcceptedTitle,
                    body: l.offerAcceptedBody,
                    cta: l.seeOrder,
                    onCta: () => context.pop(),
                  );
                }
              },
            ),
          ],
          // Buyer: an accepted offer can be ordered at the agreed price.
          if (!iAmFarmer && o.status == OfferStatus.accepted) ...[
            const SizedBox(
                height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
            KsButton(
              label: l.orderNowFromOffer,
              onPressed: () => context.push(
                  Routes.placeOrder(o.listingId, offerId: o.id)),
            ),
          ],
          if (!myTurn && o.status.isOpen) ...[
            const SizedBox(height: AppSpacing.block),
            Text(_statusText(l, o.status),
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.normal
                    .withColor(AppColors.textSecondary)),
          ],
        ],
      ),
    );
  }

  String _statusText(AppLocalizations l, OfferStatus s) => switch (s) {
        OfferStatus.pending => l.offerStatusPending,
        OfferStatus.countered => l.offerStatusCountered,
        OfferStatus.accepted => l.offerStatusAccepted,
        OfferStatus.rejected => l.offerStatusRejected,
        OfferStatus.withdrawn => l.offerStatusWithdrawn,
      };
}
