import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/services/bd_location_service.dart';
import '../../../shared/utils/geo.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_option_card.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../buyer/presentation/buyer_common.dart';
import '../../farmer/data/listing_repository.dart';
import '../data/payment_service.dart';
import '../data/trade_repository.dart';
import '../domain/trade_models.dart';

/// 78 Place Order (Figma 292:1058), buyer. Pays with the placeholder
/// PaymentService (version 1) and creates the order.
class PlaceOrderScreen extends ConsumerStatefulWidget {
  const PlaceOrderScreen({super.key, required this.listingId, this.offerId});
  final String listingId;
  final String? offerId;

  @override
  ConsumerState<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends ConsumerState<PlaceOrderScreen> {
  static const _optionImage = 36.0;
  static const _optionPy = 14.0;

  final _qty = TextEditingController();
  TransportMode _mode = TransportMode.platform;
  UserLocation? _dropoff;
  bool _paying = false;
  String? _qtyErr;
  String? _addrErr;

  @override
  void initState() {
    super.initState();
    final me = ref.read(currentUserProvider).value;
    if (me != null && me.location.isComplete) _dropoff = me.location;
    _qty.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _qty.dispose();
    super.dispose();
  }

  String get _lang => Localizations.localeOf(context).languageCode;

  String _addrLine(UserLocation loc) => [
        loc.village ?? '',
        BdPlace.display(loc.upazila, _lang),
        BdPlace.display(loc.district, _lang),
      ].where((s) => s.isNotEmpty).join(', ');

  Future<void> _pickAddress() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final loc = await context.push<UserLocation>(Routes.locationPicker);
    FocusManager.instance.primaryFocus?.unfocus();
    if (loc != null) {
      setState(() {
        _dropoff = loc;
        _addrErr = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final listing = ref.watch(listingProvider(widget.listingId)).value;
    final offer = widget.offerId == null
        ? null
        : ref.watch(offerProvider(widget.offerId!)).value;
    if (listing == null || (widget.offerId != null && offer == null)) {
      return Scaffold(
        appBar: KsAppBar(title: l.placeOrderTitle),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final price = offer?.pricePerKg ?? listing.pricePerKg;
    final qty = offer?.quantityKg ??
        num.tryParse(Fmt.latinDigits(_qty.text.trim())) ??
        listing.availableKg;
    final km = distanceKm(listing.pickup.geo, _dropoff?.geo);
    final fare = _mode == TransportMode.platform
        ? TradeRepository.estimateFare(km)
        : 0;
    final cropTotal = price * qty;
    final fee = (cropTotal * TradeRepository.platformFeePct / 100).round();
    final total = cropTotal + fare + fee;

    Future<void> pay() async {
      final me = ref.read(currentUserProvider).value;
      if (me == null) return;
      setState(() {
        _qtyErr = (qty <= 0)
            ? l.errQtyInvalid
            : (qty > listing.availableKg ? l.errQtyTooMuch : null);
        _addrErr = _dropoff == null ? l.errAddressRequired : null;
      });
      if (_qtyErr != null || _addrErr != null) return;
      setState(() => _paying = true);
      try {
        final pay = await ref.read(paymentServiceProvider).holdForOrder(
              orderNo: listing.id,
              amountBdt: total,
              payerUid: me.uid,
            );
        if (!pay.success) throw Exception('payment');
        final order = await ref.read(tradeRepositoryProvider).placeOrder(
              buyer: me,
              listing: listing,
              offer: offer,
              quantityKg: qty,
              pricePerKg: price,
              mode: _mode,
              transportFare: fare,
              dropoff: _dropoff!,
              paymentRef: pay.reference ?? '',
            );
        if (!mounted) return;
        await showKsSuccessModal(
          this.context,
          title: l.orderPlacedTitle,
          body: l.orderPlacedBody,
          cta: l.seeOrder,
          onCta: () => this.context.pushReplacement(Routes.order(order.id)),
        );
      } on TradeException catch (e) {
        if (mounted) {
          KsToast.show(this.context,
              e.code == 'qty_too_much' ? l.errQtyTooMuch : l.errorGeneric);
        }
      } catch (_) {
        if (mounted) KsToast.show(this.context, l.errorGeneric);
      } finally {
        if (mounted) setState(() => _paying = false);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.placeOrderTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
            AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
        children: [
          KsListItem(
            thumb: KsNetImage(
                url: listing.photo,
                thumbSize: KsListItem.thumbSize.round(),
                fallbackAsset: CropCatalog.imageFor(listing.cropKey)),
            title: l.cropQtyTitle(listing.cropName(_lang), qtyText(context, qty)),
            subtitle: l.farmerPrice(
                listing.farmerName, Fmt.number(context, price)),
            showChevron: false,
          ),
          if (offer == null) ...[
            const SizedBox(height: AppSpacing.block),
            KsTextField(
              label: l.sellQuantity,
              hint: Fmt.number(context, listing.availableKg),
              controller: _qty,
              suffixText: l.unitKg,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯.]'))
              ],
              errorText: _qtyErr,
            ),
          ],
          const SizedBox(height: AppSpacing.block),
          KsSelectField(
            label: l.deliveryAddress,
            placeholder: l.selectHint,
            value: _dropoff == null ? null : _addrLine(_dropoff!),
            onTap: _pickAddress,
            errorText: _addrErr,
          ),
          const SizedBox(height: AppSpacing.block),
          KsOptionCard(
            image: const AssetImage(AppImages.truckRoad),
            imageSize: _optionImage,
            verticalPadding: _optionPy,
            titleStyleSmall: true,
            title: l.platformTruck,
            subtitle: l.platformTruckSub,
            selected: _mode == TransportMode.platform,
            onTap: () => setState(() => _mode = TransportMode.platform),
          ),
          const SizedBox(height: AppSpacing.block),
          KsOptionCard(
            image: const AssetImage(AppImages.truckRoad),
            imageSize: _optionImage,
            verticalPadding: _optionPy,
            titleStyleSmall: true,
            title: l.selfTransport,
            selected: _mode == TransportMode.self,
            onTap: () => setState(() => _mode = TransportMode.self),
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoCard(rows: [
            (l.rowCropPrice, Fmt.taka(context, cropTotal)),
            (l.rowTransport, Fmt.taka(context, fare)),
            (
              l.rowPlatformFee(Fmt.digits(
                  context, '${TradeRepository.platformFeePct}')),
              Fmt.taka(context, fee)
            ),
            (l.rowTotal, Fmt.taka(context, total)),
          ]),
          const SizedBox(
              height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
          KsButton(label: l.payWithSafe, loading: _paying, onPressed: pay),
        ],
      ),
    );
  }
}
