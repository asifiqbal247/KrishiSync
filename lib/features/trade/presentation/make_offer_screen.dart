import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../auth/data/user_repository.dart';
import '../../buyer/presentation/buyer_common.dart';
import '../../farmer/data/listing_repository.dart';
import '../data/trade_repository.dart';

/// 77 Make Offer (Figma 292:1041), buyer.
class MakeOfferScreen extends ConsumerStatefulWidget {
  const MakeOfferScreen({super.key, required this.listingId});
  final String listingId;

  @override
  ConsumerState<MakeOfferScreen> createState() => _MakeOfferScreenState();
}

class _MakeOfferScreenState extends ConsumerState<MakeOfferScreen> {
  final _price = TextEditingController();
  final _qty = TextEditingController();
  DateTime? _date;
  bool _sending = false;
  String? _priceErr;
  String? _qtyErr;
  String? _dateErr;

  @override
  void initState() {
    super.initState();
    _price.addListener(() => setState(() {}));
    _qty.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _price.dispose();
    _qty.dispose();
    super.dispose();
  }

  num? _n(TextEditingController c) =>
      num.tryParse(Fmt.latinDigits(c.text.trim()));

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 120)),
      initialDate: _date ?? now.add(const Duration(days: 2)),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _send() async {
    final l = AppLocalizations.of(context);
    final listing = ref.read(listingProvider(widget.listingId)).value;
    final me = ref.read(currentUserProvider).value;
    if (listing == null || me == null) return;
    final price = _n(_price);
    final qty = _n(_qty);
    setState(() {
      _priceErr = (price == null || price <= 0) ? l.errPriceInvalid : null;
      _qtyErr = (qty == null || qty <= 0)
          ? l.errQtyInvalid
          : (qty > listing.availableKg ? l.errQtyTooMuch : null);
      _dateErr = _date == null ? l.commonRequired : null;
    });
    if (_priceErr != null || _qtyErr != null || _dateErr != null) return;
    setState(() => _sending = true);
    try {
      await ref.read(tradeRepositoryProvider).createOffer(
            buyer: me,
            listing: listing,
            pricePerKg: price!,
            quantityKg: qty!,
            deliveryDate: _date!,
          );
      if (!mounted) return;
      KsToast.show(context, l.offerSent);
      context.pop();
    } catch (_) {
      if (mounted) KsToast.show(context, l.errorGeneric);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final listing = ref.watch(listingProvider(widget.listingId)).value;
    final total = (_n(_price) ?? 0) * (_n(_qty) ?? 0);
    final numFmt = [FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯.]'))];

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.offerTitle),
      body: listing == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
                  AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
              children: [
                KsListItem(
                  thumb: KsNetImage(
                      url: listing.photo,
                      thumbSize: KsListItem.thumbSize.round(),
                      fallbackAsset: CropCatalog.imageFor(listing.cropKey)),
                  title: l.cropWithGrade(listing.cropName(lang), listing.grade),
                  subtitle: l.farmerQty(listing.farmerName,
                      qtyText(context, listing.availableKg)),
                  trailingText: Fmt.taka(context, listing.pricePerKg),
                  showChevron: false,
                ),
                const SizedBox(height: AppSpacing.block),
                KsTextField(
                  label: l.offerYourPrice,
                  hint: Fmt.number(context, listing.pricePerKg),
                  controller: _price,
                  suffixText: l.sellPriceUnit,
                  keyboardType: TextInputType.number,
                  inputFormatters: numFmt,
                  errorText: _priceErr,
                ),
                const SizedBox(height: AppSpacing.block),
                KsTextField(
                  label: l.sellQuantity,
                  hint: Fmt.number(context, listing.availableKg),
                  controller: _qty,
                  suffixText: l.unitKg,
                  keyboardType: TextInputType.number,
                  inputFormatters: numFmt,
                  errorText: _qtyErr,
                ),
                const SizedBox(height: AppSpacing.block),
                KsSelectField(
                  label: l.offerDeliveryDate,
                  placeholder: l.selectHint,
                  value: _date == null ? null : Fmt.date(context, _date!),
                  onTap: _pickDate,
                  errorText: _dateErr,
                  showChevron: false,
                ),
                const SizedBox(height: AppSpacing.block),
                KsInfoCard(rows: [
                  (l.offerTotal, Fmt.taka(context, total)),
                  (l.fieldPayment, l.safePayment),
                ]),
                const SizedBox(
                    height:
                        AppSpacing.block + AppSpacing.xs + AppSpacing.block),
                KsButton(
                    label: l.offerSend, loading: _sending, onPressed: _send),
              ],
            ),
    );
  }
}
