import 'dart:io';

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
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/services/image_storage_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../../../shared/widgets/ks_upload_box.dart';
import '../../../shared/widgets/photo_source_sheet.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../auth/data/user_repository.dart';
import '../../trade/data/trade_repository.dart';
import '../data/transport_repository.dart';
import '../domain/delivery.dart';
import 'transport_common.dart';

Widget _loading(String title) => Scaffold(
      appBar: KsAppBar(title: title),
      body: const Center(child: CircularProgressIndicator()),
    );

const _contentPad = EdgeInsets.fromLTRB(
    AppSpacing.screen, AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg);

/// Where a buyer's delivery row leads.
String routeForBuyer(Delivery d) => switch (d.status) {
      DeliveryStatus.open => Routes.buyerBook(d.id),
      DeliveryStatus.assigned ||
      DeliveryStatus.pickedUp =>
        Routes.buyerAssigned(d.id),
      _ => Routes.order(d.orderId),
    };

enum _TTab { ongoing, booked, done }

/// 115 Transport (buyer, Figma 292:1463).
class BuyerTransportScreen extends ConsumerStatefulWidget {
  const BuyerTransportScreen({super.key});

  @override
  ConsumerState<BuyerTransportScreen> createState() => _BuyerTransportState();
}

class _BuyerTransportState extends ConsumerState<BuyerTransportScreen> {
  _TTab _tab = _TTab.ongoing;

  bool _in(Delivery d) => switch (_tab) {
        _TTab.ongoing => d.status == DeliveryStatus.pickedUp,
        _TTab.booked =>
          d.status == DeliveryStatus.open || d.status == DeliveryStatus.assigned,
        _TTab.done => d.status == DeliveryStatus.delivered,
      };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final all = ref.watch(myDeliveriesProvider).value;
    final shown = (all ?? const <Delivery>[]).where(_in).toList();

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.transportTitle),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: _contentPad,
              children: [
                Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final (t, label) in [
                        (_TTab.ongoing, l.tabOngoing),
                        (_TTab.booked, l.tabBooked),
                        (_TTab.done, l.tabDone),
                      ])
                        KsPill(
                            label: label,
                            selected: _tab == t,
                            onTap: () => setState(() => _tab = t)),
                    ]),
                if (all == null) ...[
                  const SizedBox(height: AppSpacing.block),
                  const KsSkeletonList(padded: false),
                ] else if (shown.isEmpty) ...[
                  const SizedBox(height: AppSpacing.block),
                  Text(l.noTransport,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.normal
                          .withColor(AppColors.textSecondary)),
                ],
                for (final d in shown) ...[
                  const SizedBox(height: AppSpacing.block),
                  _DeliveryRow(d: d, lang: lang),
                ],
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.lg),
              child: KsButton(
                label: l.bookTruckBtn,
                onPressed: () {
                  final open = (all ?? const <Delivery>[])
                      .where((d) => d.status == DeliveryStatus.open)
                      .firstOrNull;
                  if (open == null) {
                    KsToast.show(context, l.noTruckNeeded);
                  } else {
                    context.push(Routes.buyerBook(open.id));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryRow extends ConsumerWidget {
  const _DeliveryRow({required this.d, required this.lang});
  final Delivery d;
  final String lang;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final bids = d.status == DeliveryStatus.open
        ? (ref.watch(bidsProvider(d.id)).value ?? const [])
        : const <Bid>[];
    return KsListItem(
      thumb: KsNetImage(
          url: d.photo,
          thumbSize: KsListItem.thumbSize.round(),
          fallbackAsset: CropCatalog.imageFor(d.cropKey)),
      title: l.noOrderCrop(d.orderNo, d.cropName(lang)),
      subtitle: d.status == DeliveryStatus.open
          ? l.nameStatus(l.dsOpen,
              l.bidsCountLine(Fmt.digits(context, '${bids.length}')))
          : l.nameStatus(
              d.transporterName ?? '', deliveryStatusLabel(l, d.status)),
      trailingText: Fmt.taka(context, fareOf(d)),
      onTap: () => context.push(routeForBuyer(d)),
    );
  }
}

/// 116 Book Truck (Figma 292:1478): load facts + transporter bids.
class BookTruckScreen extends ConsumerStatefulWidget {
  const BookTruckScreen({super.key, required this.deliveryId});
  final String deliveryId;

  @override
  ConsumerState<BookTruckScreen> createState() => _BookTruckState();
}

class _BookTruckState extends ConsumerState<BookTruckScreen> {
  String? _pick;
  bool _busy = false;

  Future<void> _book(Delivery d, Bid bid) async {
    final l = AppLocalizations.of(context);
    final order = ref.read(orderProvider(d.orderId)).value;
    if (order == null) return;
    setState(() => _busy = true);
    try {
      await ref.read(transportRepositoryProvider).book(d, bid, order);
      if (!mounted) return;
      KsToast.show(context, l.truckBooked);
      context.pushReplacement(Routes.buyerAssigned(d.id));
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
    final d = ref.watch(deliveryProvider(widget.deliveryId)).value;
    final bids = ref.watch(bidsProvider(widget.deliveryId)).value ?? const [];
    ref.watch(orderProvider(widget.deliveryId));
    if (d == null) return _loading(l.bookTruckTitle);
    final pick = _pick ?? (bids.length == 1 ? bids.first.transporterId : null);
    final chosen = bids.where((b) => b.transporterId == pick).firstOrNull;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.bookTruckTitle),
      body: ListView(
        padding: _contentPad,
        children: [
          KsSelectField(
              label: l.pickupLocation,
              placeholder: '',
              value: placeFull(context, d.pickup),
              onTap: () {}),
          const SizedBox(height: AppSpacing.block),
          KsSelectField(
              label: l.rowDestination,
              placeholder: '',
              value: placeFull(context, d.dropoff),
              onTap: () {}),
          const SizedBox(height: AppSpacing.block),
          KsSelectField(
              label: l.goodsWeight,
              placeholder: '',
              value: l.loadSub(d.cropName(lang),
                  l.qtyKg(Fmt.number(context, d.weightKg))),
              showChevron: false,
              onTap: () {}),
          const SizedBox(height: AppSpacing.block),
          KsSelectField(
              label: l.dateLabel,
              placeholder: '',
              value: d.pickupDate == null ? '' : Fmt.date(context, d.pickupDate!),
              showChevron: false,
              onTap: () {}),
          const SizedBox(height: AppSpacing.block),
          KsSectionHeader(title: l.suggestedTrucks),
          if (d.status != DeliveryStatus.open) ...[
            const SizedBox(height: AppSpacing.block),
            KsNoteBox(title: l.truckBooked),
          ] else if (bids.isEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            Text(l.waitingBids,
                style: AppTypography.bodyMedium.normal
                    .withColor(AppColors.textSecondary)),
          ],
          for (final b in bids) ...[
            const SizedBox(height: AppSpacing.block),
            KsListItem(
              thumb: KsNetImage(
                  url: b.photoUrl,
                  thumbSize: KsListItem.thumbSize.round(),
                  fallbackAsset: AppUi.avatarDriver),
              title: b.name,
              subtitle: l.truckSub(
                vehicleTypeLabel(l, b.vehicle.type),
                tonsText(context, b.vehicle.capacityKg),
                b.ratingCount == 0
                    ? l.notAvailable
                    : Fmt.number(context, b.ratingAvg, decimals: 1),
              ),
              trailingText: Fmt.taka(context, b.fare),
              highlighted: b.transporterId == pick,
              onTap: d.status == DeliveryStatus.open
                  ? () => setState(() => _pick = b.transporterId)
                  : null,
            ),
          ],
          const SizedBox(
              height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
          KsButton(
            label: l.bookBtn,
            loading: _busy,
            onPressed: chosen == null || d.status != DeliveryStatus.open
                ? null
                : () => _book(d, chosen),
          ),
        ],
      ),
    );
  }
}

/// 117 Assigned Transporter (Figma 292:1490).
class AssignedTransportScreen extends ConsumerWidget {
  const AssignedTransportScreen({super.key, required this.deliveryId});
  final String deliveryId;

  static const _mapH = 150.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final d = ref.watch(deliveryProvider(deliveryId)).value;
    if (d == null || d.transporterId == null) {
      return _loading(l.assignedTitle);
    }
    final driver = ref.watch(userByIdProvider(d.transporterId!)).value;
    final rating = driver == null || driver.ratingCount == 0
        ? l.notAvailable
        : Fmt.number(context, driver.ratingAvg, decimals: 1);
    final v = d.vehicle;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.assignedTitle),
      body: ListView(
        padding: _contentPad,
        children: [
          KsListItem(
            thumb: KsNetImage(
                url: d.transporterPhotoUrl ?? driver?.photoUrl,
                thumbSize: KsListItem.thumbSize.round(),
                fallbackAsset: AppUi.avatarDriver),
            title: d.transporterName ?? '',
            subtitle: (driver?.isVerified ?? false)
                ? l.verifiedDriverRating(rating)
                : l.driverRating(rating),
            showChevron: false,
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(children: [
            if (v != null) ...[
              KsInfoRow(l.rowTruck, v.plateNo),
              KsInfoRow(l.rowCapacity, tonsText(context, v.capacityKg)),
            ],
            if (d.pickupDate != null)
              KsInfoRow(l.fieldPickup, Fmt.date(context, d.pickupDate!)),
            KsInfoRow(l.rowFare, l.fareSafeLine(Fmt.taka(context, fareOf(d)))),
          ]),
          const SizedBox(height: AppSpacing.block),
          KsRouteMap(height: _mapH, from: d.pickup.geo, to: d.dropoff.geo),
          const SizedBox(
              height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
          Row(children: [
            Expanded(
              child: KsButton.outline(
                label: l.callBtn,
                onPressed: driver == null
                    ? null
                    : () => launchUrl(Uri(scheme: 'tel', path: driver.phone)),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: KsButton(
                label: l.trackBtn,
                onPressed: () => context.push(Routes.order(d.orderId)),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

/// 110 Delivery Confirmation (buyer, Figma 292:1296): shows the OTP.
class ReceiveDeliveryScreen extends ConsumerStatefulWidget {
  const ReceiveDeliveryScreen({super.key, required this.deliveryId});
  final String deliveryId;

  @override
  ConsumerState<ReceiveDeliveryScreen> createState() => _ReceiveState();
}

class _ReceiveState extends ConsumerState<ReceiveDeliveryScreen> {
  File? _photo;
  bool _busy = false;

  Future<void> _done(Delivery d, String uid) async {
    final l = AppLocalizations.of(context);
    if (d.status != DeliveryStatus.delivered) {
      KsToast.show(context, l.otpWaitDriver);
      return;
    }
    setState(() => _busy = true);
    try {
      if (_photo != null) {
        final url = (await ref.read(imageStorageProvider).upload(_photo!,
                kind: ImageKind.delivery, ownerUid: uid))
            .url;
        await ref.read(transportRepositoryProvider).saveReceiptPhoto(d.id, url);
      }
      if (!mounted) return;
      context.pushReplacement(Routes.buyerRate(d.orderId));
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
    final otp = ref.watch(deliveryOtpProvider(widget.deliveryId)).value;
    if (d == null || me == null) return _loading(l.receiveTitle);
    String kg(num v) => l.qtyKg(Fmt.number(context, v));

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.receiveTitle),
      body: ListView(
        padding: _contentPad,
        children: [
          KsInfoBox(children: [
            KsInfoRow(l.rowOrder, l.noOrderCrop(d.orderNo, d.cropName(lang))),
            KsInfoRow(l.rowOrdered, kg(d.weightKg)),
            KsInfoRow(l.rowLoaded, kg(d.deliveredKg ?? d.weightKg)),
          ]),
          const SizedBox(height: AppSpacing.block),
          KsNoteBox(
            title: l.yourOtp(Fmt.digits(context, otp ?? '----')),
            body: l.otpNote,
            bigTitle: true,
          ),
          const SizedBox(height: AppSpacing.block),
          KsNoteBox(
              title: l.qualityFinalTitle,
              body: l.qualityFinalBody,
              warning: true),
          const SizedBox(height: AppSpacing.block),
          KsUploadBox(
            label: l.deliveryPhotoOpt,
            file: _photo,
            height: _photo == null
                ? KsUploadBox.defaultHeight
                : KsUploadBox.previewHeight,
            onTap: () async {
              final f = await pickPhoto(context);
              if (f != null) setState(() => _photo = f);
            },
          ),
          const SizedBox(
              height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
          KsButton.secondary(
              label: l.otherProblem,
              onPressed: () =>
                  context.push(Routes.report(orderId: d.orderId))),
          const SizedBox(height: AppSpacing.block),
          KsButton(
              label: l.otpGiven,
              loading: _busy,
              onPressed: () => _done(d, me.uid)),
        ],
      ),
    );
  }
}
