import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/services/image_storage_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../../../shared/widgets/ks_upload_box.dart';
import '../../../shared/widgets/photo_source_sheet.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../buyer/presentation/buyer_common.dart';
import '../../chat/presentation/chat_screens.dart';
import '../../inspection/data/inspection_repository.dart';
import '../../inspection/presentation/inspection_screens.dart';
import '../../profile/presentation/payment_method_screens.dart';
import '../../trade/data/payment_service.dart';
import '../../trade/data/trade_repository.dart';
import '../../trade/domain/trade_models.dart';
import '../data/transport_repository.dart';
import '../domain/delivery.dart';
import 'transport_common.dart';

const _pad = EdgeInsets.fromLTRB(
  AppSpacing.screen,
  AppSpacing.contentTop,
  AppSpacing.screen,
  AppSpacing.lg,
);
const _gapBeforeCta = AppSpacing.block + AppSpacing.xs + AppSpacing.block;
const _heroH = 200.0; // Figma 328×200 photo, square corners

/// One "mon" (মন) = 40 kg, the fixed unit shown on the weighing screen.
const kgPerMon = 40;

Widget _loading(String title) => Scaffold(
  backgroundColor: AppColors.bgPage,
  appBar: KsAppBar(title: title),
  body: const KsSkeletonList(),
);

/// Picture + big title + line, used by 48 / 51 / 52.
class _ResultHead extends StatelessWidget {
  const _ResultHead({
    required this.image,
    required this.title,
    required this.body,
  });
  final String image;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.photo),
        child: Image.asset(
          image,
          height: _heroH,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(height: AppSpacing.block),
      Text(
        title,
        textAlign: TextAlign.center,
        style: AppTypography.headingBold22.normal,
      ),
      const SizedBox(height: AppSpacing.sm),
      Text(
        body,
        textAlign: TextAlign.center,
        style: AppTypography.bodySmall.normal.withColor(
          AppColors.textSecondary,
        ),
      ),
    ],
  );
}

// ───────────────────────── Farmer ─────────────────────────

/// Farmer's "load & money" page for one order: 45 Truck Coming before
/// loading, 52 waiting for the buyer on extra weight, then 48 Loaded & Paid
/// or 51 Weight Less.
class FarmerLoadScreen extends ConsumerStatefulWidget {
  const FarmerLoadScreen({super.key, required this.orderId});
  final String orderId;

  @override
  ConsumerState<FarmerLoadScreen> createState() => _FarmerLoadState();
}

class _FarmerLoadState extends ConsumerState<FarmerLoadScreen> {
  bool _codeAsked = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final o = ref.watch(orderProvider(widget.orderId)).value;
    final me = ref.watch(currentUserProvider).value;
    if (o == null || me == null) return _loading(l.truckComingTitle);
    // Make the farmer's loading code once a truck is booked.
    if (!_codeAsked && o.transporterId != null) {
      _codeAsked = true;
      ref.read(transportRepositoryProvider).ensureLoadCode(o.id);
    }
    final loaded = farmerLoaded(o);
    if (loaded) return _loadedView(context, o, me);
    if (o.extraPending && !o.extraExpired) return _extraWaitView(context, o);
    return _truckView(context, o);
  }

  // 45 Truck Coming (Figma 292:721).
  Widget _truckView(BuildContext context, TradeOrder o) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final d = ref.watch(deliveryProvider(o.id)).value;
    final booked = d?.transporterId != null;
    final code = booked ? ref.watch(loadCodeProvider(o.id)).value : null;
    final driver = booked
        ? ref.watch(userByIdProvider(d!.transporterId!)).value
        : null;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.truckComingTitle),
      body: ListView(
        padding: _pad,
        children: [
          KsNoteBox(
            title: booked ? l.truckBookedByBuyer : l.truckNotBooked,
            body: booked
                ? l.truckBookedBody(o.buyerName)
                : l.truckNotBookedBody,
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              if (o.pickupDate != null)
                KsInfoRow(l.rowWhenComes, Fmt.date(context, o.pickupDate!)),
              KsInfoRow(l.rowWhereComes, placeFull(context, o.pickup)),
              KsInfoRow(
                l.rowGoods,
                l.cropQtyComma(
                  o.cropName(lang),
                  qtyText(context, o.quantityKg),
                ),
              ),
              KsInfoRow(
                l.rowDestination,
                l.nameDistrict(o.buyerName, districtOf(context, o.dropoff)),
              ),
            ],
          ),
          if (booked) ...[
            const SizedBox(height: AppSpacing.block),
            Text(
              l.truckComingSection,
              style: AppTypography.bodyMediumStrong.normal,
            ),
            const SizedBox(height: AppSpacing.block),
            KsListItem(
              thumb: KsNetImage(
                url: d!.transporterPhotoUrl,
                thumbSize: KsListItem.thumbSize.round(),
                fallbackAsset: AppUi.avatarDriver,
              ),
              title: d.transporterName ?? '',
              subtitle: [
                if (d.vehicle != null) ...[
                  vehicleTypeLabel(l, d.vehicle!.type),
                  Fmt.plate(context, d.vehicle!.plateNo),
                ],
                if ((driver?.ratingCount ?? 0) > 0)
                  Fmt.number(context, driver!.ratingAvg, decimals: 1),
              ].join(' · '),
              badge: driver?.isVerified == true ? l.verifiedBadge : null,
              showChevron: false,
            ),
            const SizedBox(height: AppSpacing.block),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.bgSuccessSubtle,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.borderBrand),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.yourLoadOtp(Fmt.digits(context, code ?? '····')),
                    style: AppTypography.headingBold20.normal.withColor(
                      AppColors.textBrand,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l.yourLoadOtpBody,
                    style: AppTypography.bodySmall.normal,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.block),
            Row(
              children: [
                Expanded(
                  child: KsButton.outline(
                    label: l.callBtn,
                    compact: true,
                    onPressed: driver?.phone == null
                        ? null
                        : () => launchUrl(
                            Uri(scheme: 'tel', path: driver!.phone),
                          ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: KsButton.outline(
                    label: l.messageBtn,
                    compact: true,
                    onPressed: () =>
                        openChatWith(context, ref, d.transporterId!),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: KsButton.outline(
                    label: l.trackBtn,
                    compact: true,
                    onPressed: () => context.push(Routes.track(o.id)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.block),
            KsButton(label: l.otpGiven, onPressed: () => context.pop()),
          ],
        ],
      ),
    );
  }

  // 52 Weight More — waiting for the buyer (Figma 292:5070).
  Widget _extraWaitView(BuildContext context, TradeOrder o) {
    final l = AppLocalizations.of(context);
    final extra = o.extraKg ?? 0;
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.weightMoreTitle),
      body: ListView(
        padding: _pad,
        children: [
          _ResultHead(
            image: AppImages.scale,
            title: l.waitingBuyer,
            body: l.waitingBuyerBody(qtyText(context, extra)),
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              KsInfoRow(l.rowOrder, qtyText(context, o.quantityKg)),
              KsInfoRow(l.rowWeighed, qtyText(context, o.quantityKg + extra)),
              KsInfoRow(
                l.rowExtraPrice,
                Fmt.taka(context, extra * o.pricePerKg),
              ),
              KsInfoRow(
                l.rowReplyTime,
                l.minutes(
                  Fmt.digits(context, '${TradeOrder.extraWait.inMinutes}'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          KsNoteBox(
            warning: true,
            title: l.ifNoReply,
            body: l.ifNoReplyBody(
              Fmt.digits(context, '${TradeOrder.extraWait.inMinutes}'),
              qtyText(context, o.quantityKg),
            ),
          ),
          const SizedBox(height: _gapBeforeCta),
          KsButton(
            label: l.trackChalan,
            onPressed: () => context.push(Routes.track(o.id)),
          ),
          const SizedBox(height: AppSpacing.block),
          KsButton.secondary(
            label: l.goHome,
            onPressed: () => context.go(Routes.farmerHome),
          ),
        ],
      ),
    );
  }

  // 48 Loaded & Paid (292:3039) / 51 Weight Less (292:5044).
  Widget _loadedView(BuildContext context, TradeOrder o, AppUser me) {
    final l = AppLocalizations.of(context);
    final less = o.weighedLess;
    final pm = me.defaultPayout;
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: less ? l.weightLessTitle : l.loadedTitle),
      body: ListView(
        padding: _pad,
        children: [
          _ResultHead(
            image: less ? AppImages.scale : AppImages.handshake,
            title: less ? l.weightLessHeading : l.moneySent,
            body: less ? l.weightLessBody : l.moneySentBody,
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              if (less) ...[
                KsInfoRow(l.rowOrder, qtyText(context, o.orderedKg!)),
                KsInfoRow(l.rowWeighed, qtyText(context, o.quantityKg)),
              ] else ...[
                KsInfoRow(l.rowWeightDigital, qtyText(context, o.quantityKg)),
                KsInfoRow(
                  l.rowPrice,
                  l.priceLine(Fmt.number(context, o.pricePerKg)),
                ),
              ],
              KsInfoRow(l.rowReceivedTotal, Fmt.taka(context, o.cropTotal)),
              KsLinkRow(
                label: l.rowMethod,
                value: pm == null ? l.pmNone : payoutLine(l, pm),
                onTap: () => context.push(Routes.paymentMethods),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          KsNoteBox(
            warning: true,
            title: l.moneyFinal,
            body: less ? l.moneyFinalLessBody : l.moneyFinalBody,
          ),
          const SizedBox(height: _gapBeforeCta),
          if (less) ...[
            KsButton(
              label: l.seePayments,
              onPressed: () => context.push(Routes.payments),
            ),
            const SizedBox(height: AppSpacing.block),
            KsButton.secondary(
              label: l.goHome,
              onPressed: () => context.go(Routes.farmerHome),
            ),
          ] else ...[
            KsButton(
              label: l.seeReceipt,
              onPressed: () => context.push(Routes.receipt(o.id)),
            ),
            const SizedBox(height: AppSpacing.block),
            KsButton.outline(
              label: l.seePayments,
              onPressed: () => context.push(Routes.payments),
            ),
          ],
        ],
      ),
    );
  }
}

/// Crop is on the truck (or further) and the order is not cancelled.
bool farmerLoaded(TradeOrder o) =>
    o.status != OrderStatus.cancelled &&
    OrderStatus.values.indexOf(o.status) >=
        OrderStatus.values.indexOf(OrderStatus.pickedUp);

// ───────────────────────── Transporter ─────────────────────────

/// 162 Pickup – Loading & Digital Weighing (Figma 292:3014). Inspector rows
/// and QR check are Tier C, so only the fixed "মন" row is shown.
class LoadWeighScreen extends ConsumerStatefulWidget {
  const LoadWeighScreen({super.key, required this.deliveryId});
  final String deliveryId;

  @override
  ConsumerState<LoadWeighScreen> createState() => _LoadWeighState();
}

class _LoadWeighState extends ConsumerState<LoadWeighScreen> {
  final _kg = TextEditingController();
  final _otp = TextEditingController();
  final List<File> _photos = [];
  String? _kgErr;
  String? _otpErr;
  bool _busy = false;
  bool _filled = false;
  static const _maxPhotos = 3;

  @override
  void dispose() {
    _kg.dispose();
    _otp.dispose();
    super.dispose();
  }

  Future<void> _submit(
    Delivery d,
    TradeOrder o,
    AppUser me, {
    num? maxKg,
  }) async {
    final l = AppLocalizations.of(context);
    final repo = ref.read(transportRepositoryProvider);
    final weighed = num.tryParse(Fmt.latinDigits(_kg.text.trim())) ?? 0;
    setState(() {
      _kgErr = weighed <= 0 ? l.errQtyInvalid : null;
      _otpErr = null;
    });
    if (_kgErr != null) return;

    // More than ordered: ask the buyer first (52 / 134). After a partial
    // inspection only the approved amount may be loaded.
    var loadKg = maxKg != null && weighed > maxKg ? maxKg : weighed;
    if (loadKg > o.quantityKg) {
      if (o.extraStatus == null) {
        setState(() => _busy = true);
        try {
          await repo.requestExtra(o, loadKg, me.uid);
        } catch (_) {
          if (mounted) KsToast.show(context, l.errorGeneric);
        } finally {
          if (mounted) setState(() => _busy = false);
        }
        return;
      }
      if (o.extraPending && !o.extraExpired) {
        KsToast.show(context, l.waitingBuyer);
        return;
      }
      final allowed = o.extraStatus == 'approved'
          ? o.quantityKg + (o.extraKg ?? 0)
          : o.quantityKg;
      if (loadKg > allowed) loadKg = allowed;
    }

    final otp = Fmt.latinDigits(_otp.text.trim());
    if (otp.length != 4) {
      setState(() => _otpErr = l.errOtp4);
      return;
    }
    setState(() => _busy = true);
    try {
      final urls = <String>[];
      for (final f in _photos) {
        urls.add(
          (await ref
                  .read(imageStorageProvider)
                  .upload(f, kind: ImageKind.delivery, ownerUid: me.uid))
              .url,
        );
      }
      await repo.markPickedUp(
        d,
        o,
        me.uid,
        loadedKg: loadKg,
        otp: otp,
        photos: urls,
      );
      if (!mounted) return;
      KsToast.show(context, l.loadDone(qtyText(context, loadKg)));
      context.pop();
    } on TransportException catch (e) {
      if (!mounted) return;
      if (e.code == 'wrong_otp') {
        setState(() => _otpErr = l.errOtpWrong);
      } else {
        KsToast.show(context, l.errorGeneric);
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
    final d = ref.watch(deliveryProvider(widget.deliveryId)).value;
    final o = d == null ? null : ref.watch(orderProvider(d.orderId)).value;
    final xAsync = d == null ? null : ref.watch(inspectionProvider(d.orderId));
    if (d == null ||
        o == null ||
        me == null ||
        xAsync == null ||
        xAsync.isLoading) {
      return _loading(l.weighTitle);
    }
    // 88–94: buyer's inspector, if one was sent.
    final x = xAsync.value;
    final inspWait = x != null && !x.done;
    final partialKg = x?.decision == InspectionDecision.partial
        ? x!.acceptKg
        : null;
    if (!_filled) {
      _filled = true;
      _kg.text =
          '${partialKg ?? (x?.decision == InspectionDecision.approve ? x!.weighedKg : null) ?? (o.extraStatus == 'approved' ? o.quantityKg + (o.extraKg ?? 0) : o.quantityKg)}';
    }
    final farmer = ref.watch(userByIdProvider(d.farmerId)).value;
    final trip = ref.watch(tripProvider(d.id)) ?? Trip([d]);
    final extra = o.extraKg ?? 0;
    final waiting = o.extraPending && !o.extraExpired;

    final String? extraNote = switch (o.extraStatus) {
      'pending' when waiting => l.extraWaitNote(
        qtyText(context, extra),
        qtyText(context, o.quantityKg),
      ),
      'pending' ||
      'declined' => l.extraLoadOrdered(qtyText(context, o.quantityKg)),
      'approved' => l.extraApprovedNote(qtyText(context, o.quantityKg + extra)),
      _ => null,
    };

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.weighTitle),
      body: ListView(
        padding: _pad,
        children: [
          KsListItem(
            thumb: KsNetImage(
              url: farmer?.photoUrl,
              thumbSize: KsListItem.thumbSize.round(),
              fallbackAsset: AppUi.avatarFarmer,
            ),
            title: l.nameDot(
              d.farmerName,
              l.cropQtyComma(tonsText(context, o.quantityKg), d.cropName(lang)),
            ),
            subtitle: l.gradeStop(
              o.grade,
              Fmt.digits(context, '${trip.stopNo(d)}'),
              Fmt.digits(context, '${trip.stops.length}'),
            ),
            showChevron: false,
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              if (x != null) ...[
                KsInfoRow(l.rowInspector, l.inspPresent(x.inspectorName)),
                KsInfoRow(
                  l.rowInspDecision,
                  x.done ? decisionLabel(l, x.decision!) : l.stepWaiting,
                ),
              ],
              KsInfoRow(l.oneMon, l.monFixed(Fmt.digits(context, '$kgPerMon'))),
            ],
          ),
          if (inspWait || partialKg != null) ...[
            const SizedBox(height: AppSpacing.block),
            KsNoteBox(
              warning: true,
              title: inspWait
                  ? l.inspWaitNote
                  : l.inspPartialNote(qtyText(context, partialKg!)),
            ),
          ],
          const SizedBox(height: AppSpacing.block),
          // Big weight, "২,০০০ কেজি" style: the number is editable.
          Row(
            children: [
              IntrinsicWidth(
                child: TextField(
                  controller: _kg,
                  enabled: !waiting,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯.]')),
                  ],
                  style: AppTypography.display28.normal,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(l.unitKg, style: AppTypography.display28.normal),
            ],
          ),
          if (_kgErr != null)
            Text(
              _kgErr!,
              style: AppTypography.caption.normal.withColor(
                AppColors.textError,
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.scaleNote,
            style: AppTypography.caption.normal.withColor(
              AppColors.textSecondary,
            ),
          ),
          if (extraNote != null) ...[
            const SizedBox(height: AppSpacing.block),
            KsNoteBox(warning: true, title: extraNote),
          ],
          const SizedBox(height: AppSpacing.block),
          KsUploadBox(
            label: l.scalePhotos(
              Fmt.digits(context, '${_photos.length}'),
              Fmt.digits(context, '$_maxPhotos'),
            ),
            file: _photos.isEmpty ? null : _photos.last,
            height: _photos.isEmpty
                ? KsUploadBox.defaultHeight
                : KsUploadBox.previewHeight,
            onTap: _photos.length >= _maxPhotos
                ? () {}
                : () async {
                    final f = await pickPhoto(context);
                    if (f != null) setState(() => _photos.add(f));
                  },
          ),
          const SizedBox(height: AppSpacing.block),
          KsTextField(
            label: l.farmerOtp,
            hint: l.otpHint4,
            controller: _otp,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯]')),
              LengthLimitingTextInputFormatter(4),
            ],
            errorText: _otpErr,
          ),
          const SizedBox(height: AppSpacing.block),
          Text(
            l.weighNote,
            style: AppTypography.bodySmall.normal.withColor(
              AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: _gapBeforeCta),
          KsButton.outline(
            label: l.notLoadedReport,
            onPressed: () => context.push(Routes.report(orderId: d.orderId)),
          ),
          const SizedBox(height: AppSpacing.block),
          KsButton(
            label: l.otpAndLoad,
            loading: _busy,
            onPressed: waiting || inspWait
                ? null
                : () => _submit(d, o, me, maxKg: partialKg),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Buyer ─────────────────────────

/// 133 Weight Difference (Less) (Figma 292:3788).
class WeightLessScreen extends ConsumerWidget {
  const WeightLessScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final o = ref.watch(orderProvider(orderId)).value;
    if (o == null) return _loading(l.weightDiffTitle);
    final ordered = o.orderedKg ?? o.quantityKg;
    final lessKg = ordered - o.quantityKg;
    final cropBack = lessKg * o.pricePerKg;
    String tk(num v) => Fmt.taka(context, v);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.weightDiffTitle),
      body: ListView(
        padding: _pad,
        children: [
          KsNoteBox(
            warning: true,
            title: l.weightLessRefund(tk(o.weightRefund)),
            body: l.weightLessRefundBody(o.orderNo, o.cropName(lang)),
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              KsInfoRow(l.rowOrderedKg, qtyText(context, ordered)),
              KsInfoRow(l.rowLoadWeighed, qtyText(context, o.quantityKg)),
              KsInfoRow(l.rowLess, qtyText(context, lessKg), strong: true),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              KsInfoRow(
                l.rowCropRefund(Fmt.number(context, o.pricePerKg)),
                tk(cropBack),
              ),
              KsInfoRow(
                l.rowFeeRefund(
                  Fmt.digits(context, '${TradeRepository.platformFeePct}'),
                ),
                tk(o.weightRefund - cropBack),
              ),
              KsInfoRow(l.rowTotalRefund, tk(o.weightRefund), strong: true),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          Text(
            l.weightLessNote(qtyText(context, o.quantityKg)),
            style: AppTypography.bodySmall.normal.withColor(
              AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: _gapBeforeCta),
          KsButton.outline(
            label: l.seeWeighReport,
            onPressed: () => showLoadPhotos(context, o),
          ),
          const SizedBox(height: AppSpacing.block),
          KsButton(
            label: l.seeRefundStatus,
            onPressed: () => context.push(Routes.refund(o.id)),
          ),
        ],
      ),
    );
  }
}

/// Weighing photos taken by the driver at loading.
Future<void> showLoadPhotos(BuildContext context, TradeOrder o) async {
  final l = AppLocalizations.of(context);
  if (o.loadPhotos.isEmpty) {
    KsToast.show(context, l.noLoadPhotos);
    return;
  }
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(AppSpacing.screen),
        children: [
          Text(
            l.weighReportTitle(qtyText(context, o.quantityKg)),
            style: AppTypography.headingBold20.normal,
          ),
          for (final u in o.loadPhotos) ...[
            const SizedBox(height: AppSpacing.block),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.photo),
              child: KsNetImage(url: u, fallbackAsset: AppImages.scale),
            ),
          ],
        ],
      ),
    ),
  );
}

/// 134 Extra Weight Approval (Figma 292:3819).
class ExtraWeightScreen extends ConsumerStatefulWidget {
  const ExtraWeightScreen({super.key, required this.orderId});
  final String orderId;

  @override
  ConsumerState<ExtraWeightScreen> createState() => _ExtraWeightState();
}

class _ExtraWeightState extends ConsumerState<ExtraWeightScreen> {
  bool _busy = false;

  Future<void> _answer(TradeOrder o, bool approve, num pay) async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      if (approve) {
        final r = await ref
            .read(paymentServiceProvider)
            .holdForOrder(
              orderNo: o.orderNo,
              amountBdt: pay,
              payerUid: o.buyerId,
            );
        if (!r.success) throw Exception('payment');
      }
      await ref.read(transportRepositoryProvider).answerExtra(o, approve);
      if (!mounted) return;
      KsToast.show(context, approve ? l.extraApproved : l.extraDeclined);
      context.pop();
    } catch (_) {
      if (mounted) {
        setState(() => _busy = false);
        KsToast.show(context, l.errorGeneric);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final o = ref.watch(orderProvider(widget.orderId)).value;
    if (o == null) return _loading(l.weightMoreTitle);
    final extra = o.extraKg ?? 0;
    final price = extra * o.pricePerKg;
    final fee = (price * TradeRepository.platformFeePct / 100).round();
    final pay = price + fee;
    final open = o.extraPending && !o.extraExpired;
    String tk(num v) => Fmt.taka(context, v);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.weightMoreTitle),
      body: ListView(
        padding: _pad,
        children: [
          KsNoteBox(
            warning: true,
            title: l.extraNeedApproval(qtyText(context, extra)),
            body: l.extraNeedApprovalBody(o.farmerName, o.cropName(lang)),
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              KsInfoRow(l.rowOrderedKg, qtyText(context, o.quantityKg)),
              KsInfoRow(
                l.rowScaleWeighed,
                qtyText(context, o.quantityKg + extra),
              ),
              KsInfoRow(l.rowMore, qtyText(context, extra), strong: true),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              KsInfoRow(
                l.rowExtraPriceAt(Fmt.number(context, o.pricePerKg)),
                tk(price),
              ),
              KsInfoRow(
                l.rowFeePct(
                  Fmt.digits(context, '${TradeRepository.platformFeePct}'),
                ),
                tk(fee),
              ),
              KsInfoRow(l.rowTotalToPay, tk(pay), strong: true),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          Text(
            l.extraNote(
              Fmt.digits(context, '${TradeOrder.extraWait.inMinutes}'),
            ),
            style: AppTypography.bodySmall.normal.withColor(
              AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: _gapBeforeCta),
          if (open)
            Row(
              children: [
                Expanded(
                  child: KsButton(
                    label: l.approveAndPay(tk(pay)),
                    compact: true,
                    loading: _busy,
                    onPressed: () => _answer(o, true, pay),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: KsButton.secondary(
                    label: l.keepOrdered(qtyText(context, o.quantityKg)),
                    compact: true,
                    onPressed: _busy ? null : () => _answer(o, false, 0),
                  ),
                ),
              ],
            )
          else
            KsNoteBox(
              title: switch (o.extraStatus) {
                'approved' => l.extraApproved,
                'declined' => l.extraDeclined,
                _ => l.extraExpiredNote(qtyText(context, o.quantityKg)),
              },
            ),
        ],
      ),
    );
  }
}

/// 132 Refund Status (Figma 292:3759): for a cancelled order (D5) or a
/// weight-less refund (133). Payment is a placeholder, so the last step
/// stays waiting.
class RefundScreen extends ConsumerWidget {
  const RefundScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final o = ref.watch(orderProvider(orderId)).value;
    final me = ref.watch(currentUserProvider).value;
    if (o == null) return _loading(l.refundTitle);
    final cancelled = o.status == OrderStatus.cancelled;
    final amount = cancelled ? (o.refund ?? o.total) : o.weightRefund;
    final at = cancelled ? o.timeline['cancelled'] : o.timeline['pickedUp'];
    String tk(num v) => Fmt.taka(context, v);
    final ordered = o.orderedKg ?? o.quantityKg;
    final cropBack = (ordered - o.quantityKg) * o.pricePerKg;
    final pm = me?.defaultPayout;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.refundTitle),
      body: ListView(
        padding: _pad,
        children: [
          Text(tk(amount), style: AppTypography.display28.normal),
          const SizedBox(height: AppSpacing.sm),
          Text(
            cancelled
                ? l.refundSubCancel(
                    o.cropName(lang),
                    qtyText(context, o.quantityKg),
                  )
                : l.refundSubWeight(
                    o.cropName(lang),
                    qtyText(context, ordered - o.quantityKg),
                  ),
            style: AppTypography.bodySmall.normal.withColor(
              AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              if (cancelled) ...[
                KsInfoRow(l.rowCropValue, tk(o.cropTotal)),
                if (o.transportFare > 0)
                  KsInfoRow(
                    o.cancelFee > 0 ? l.rowTransportCut : l.rowTransport,
                    tk(o.transportFare - o.cancelFee),
                  ),
                KsInfoRow(
                  l.rowPlatformFeePct(
                    Fmt.digits(context, '${TradeRepository.platformFeePct}'),
                  ),
                  tk(o.platformFee),
                ),
              ] else ...[
                KsInfoRow(l.rowCropValue, tk(cropBack)),
                KsInfoRow(
                  l.rowPlatformFeePct(
                    Fmt.digits(context, '${TradeRepository.platformFeePct}'),
                  ),
                  tk(o.weightRefund - cropBack),
                ),
              ],
              KsInfoRow(l.rowTotalRefund, tk(amount), strong: true),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          KsTimelineItem(
            title: cancelled ? l.refundStepCancelled : l.refundStepWeighed,
            subtitle: at == null ? '' : Fmt.date(context, at),
            done: true,
          ),
          const SizedBox(height: AppSpacing.block),
          KsTimelineItem(
            title: l.refundStepProcessing,
            subtitle: l.refundWithin3Days,
            done: true,
          ),
          const SizedBox(height: AppSpacing.block),
          KsTimelineItem(
            title: l.refundStepArrived,
            subtitle: l.stepWaiting,
            done: false,
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              KsInfoRow(
                l.rowRefundTo,
                pm == null ? l.refundSameMethod : payoutLine(l, pm),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          Text(
            l.refundNote,
            style: AppTypography.bodySmall.normal.withColor(
              AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: _gapBeforeCta),
          KsButton.outline(
            label: l.getHelp,
            onPressed: () => context.push(Routes.help),
          ),
        ],
      ),
    );
  }
}
