import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
import '../data/live_location.dart';
import '../data/transport_repository.dart';
import '../../trade/domain/trade_models.dart';
import '../domain/delivery.dart';
import '../../chat/presentation/chat_screens.dart';
import 'transport_common.dart';

Widget _loading(String title) => Scaffold(
  appBar: KsAppBar(title: title),
  body: const Center(child: CircularProgressIndicator()),
);

const _contentPad = EdgeInsets.fromLTRB(
  AppSpacing.screen,
  AppSpacing.contentTop,
  AppSpacing.screen,
  AppSpacing.lg,
);

/// Where a buyer's delivery row leads.
String routeForBuyer(Delivery d) => switch (d.status) {
  DeliveryStatus.open => Routes.buyerBook(d.id),
  DeliveryStatus.assigned ||
  DeliveryStatus.pickedUp => Routes.buyerAssigned(d.id),
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
                        onTap: () => setState(() => _tab = t),
                      ),
                  ],
                ),
                if (all == null) ...[
                  const SizedBox(height: AppSpacing.block),
                  const KsSkeletonList(padded: false),
                ] else if (shown.isEmpty) ...[
                  const SizedBox(height: AppSpacing.block),
                  Text(
                    l.noTransport,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.normal.withColor(
                      AppColors.textSecondary,
                    ),
                  ),
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
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                AppSpacing.lg,
              ),
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
        fallbackAsset: CropCatalog.imageFor(d.cropKey),
      ),
      title: l.noOrderCrop(d.orderNo, d.cropName(lang)),
      subtitle: d.status == DeliveryStatus.open
          ? l.nameStatus(
              l.dsOpen,
              l.bidsCountLine(Fmt.digits(context, '${bids.length}')),
            )
          : l.nameStatus(
              d.transporterName ?? '',
              deliveryStatusLabel(l, d.status),
            ),
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

  /// Books [driver] for every farm of the trip (one bid per farm).
  Future<void> _book(Trip t, String driver) async {
    final l = AppLocalizations.of(context);
    final d = t.lead;
    final orders = [
      for (final s in t.stops) ref.read(orderProvider(s.orderId)).value,
    ];
    final bids = [
      for (final s in t.stops)
        (ref.read(bidsProvider(s.id)).value ?? const <Bid>[])
            .where((b) => b.transporterId == driver)
            .firstOrNull,
    ];
    if (orders.contains(null) || bids.contains(null)) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(transportRepositoryProvider)
          .bookTrip(t, bids.cast<Bid>(), orders.cast<TradeOrder>());
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
    final t = ref.watch(tripProvider(widget.deliveryId));
    if (t == null) return _loading(l.bookTruckTitle);
    final d = t.summary;
    // A driver's offer for the trip = their bids on every farm, added up.
    final perStop = [
      for (final s in t.stops) ...[
        ref.watch(bidsProvider(s.id)).value ?? const <Bid>[],
      ],
    ];
    for (final s in t.stops) {
      ref.watch(orderProvider(s.orderId));
    }
    final bids = [
      for (final b in perStop.first)
        if (perStop.every(
          (list) => list.any((x) => x.transporterId == b.transporterId),
        ))
          (
            b,
            perStop.fold<num>(
              0,
              (a, list) =>
                  a +
                  list
                      .firstWhere((x) => x.transporterId == b.transporterId)
                      .fare,
            ),
          ),
    ]..sort((a, b) => a.$2.compareTo(b.$2));
    final pick =
        _pick ?? (bids.length == 1 ? bids.first.$1.transporterId : null);
    final chosen = bids.where((b) => b.$1.transporterId == pick).firstOrNull;
    final open = t.status == DeliveryStatus.open;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.bookTruckTitle),
      body: ListView(
        padding: _contentPad,
        children: [
          KsSelectField(
            label: l.pickupLocation,
            placeholder: '',
            value: t.multi
                ? l.pickupsLine(
                    Fmt.digits(context, '${t.stops.length}'),
                    {for (final s in t.stops) districtOf(context, s.pickup)}
                        .join(', '),
                  )
                : placeFull(context, d.pickup),
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.block),
          KsSelectField(
            label: l.rowDestination,
            placeholder: '',
            value: placeFull(context, d.dropoff),
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.block),
          KsSelectField(
            label: l.goodsWeight,
            placeholder: '',
            value: l.loadSub(
              d.cropName(lang),
              l.qtyKg(Fmt.number(context, d.weightKg)),
            ),
            showChevron: false,
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.block),
          KsSelectField(
            label: l.dateLabel,
            placeholder: '',
            value: d.pickupDate == null ? '' : Fmt.date(context, d.pickupDate!),
            showChevron: false,
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.block),
          KsSectionHeader(title: l.suggestedTrucks),
          if (!open) ...[
            const SizedBox(height: AppSpacing.block),
            KsNoteBox(title: l.truckBooked),
          ] else if (bids.isEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            Text(
              l.waitingBids,
              style: AppTypography.bodyMedium.normal.withColor(
                AppColors.textSecondary,
              ),
            ),
          ],
          for (final (b, total) in bids) ...[
            const SizedBox(height: AppSpacing.block),
            KsListItem(
              thumb: KsNetImage(
                url: b.photoUrl,
                thumbSize: KsListItem.thumbSize.round(),
                fallbackAsset: AppUi.avatarDriver,
              ),
              title: b.name,
              subtitle: l.truckSub(
                vehicleTypeLabel(l, b.vehicle.type),
                tonsText(context, b.vehicle.capacityKg),
                b.ratingCount == 0
                    ? l.notAvailable
                    : Fmt.number(context, b.ratingAvg, decimals: 1),
              ),
              trailingText: Fmt.taka(context, total),
              highlighted: b.transporterId == pick,
              // 80: see the driver's profile; "choose" selects this bid.
              onTap: open
                  ? () async {
                      final ok = await context.push<bool>(
                        Routes.transporterProfile(b.transporterId, pick: true),
                      );
                      if (ok == true && mounted) {
                        setState(() => _pick = b.transporterId);
                      }
                    }
                  : null,
            ),
          ],
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          KsButton(
            label: l.bookBtn,
            loading: _busy,
            onPressed: chosen == null || !open
                ? null
                : () => _book(t, chosen.$1.transporterId),
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
    final live =
        d.status == DeliveryStatus.assigned ||
            d.status == DeliveryStatus.pickedUp
        ? ref.watch(livePosProvider(d.id)).value
        : null;
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
              fallbackAsset: AppUi.avatarDriver,
            ),
            title: d.transporterName ?? '',
            subtitle: (driver?.isVerified ?? false)
                ? l.verifiedDriverRating(rating)
                : l.driverRating(rating),
            onTap: () =>
                context.push(Routes.transporterProfile(d.transporterId!)),
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              if (v != null) ...[
                KsInfoRow(l.rowTruck, Fmt.plate(context, v.plateNo)),
                KsInfoRow(l.rowCapacity, tonsText(context, v.capacityKg)),
              ],
              if (d.pickupDate != null)
                KsInfoRow(l.fieldPickup, Fmt.date(context, d.pickupDate!)),
              KsInfoRow(
                l.rowFare,
                l.fareSafeLine(
                  Fmt.taka(
                    context,
                    ref.watch(tripProvider(d.id))?.fare ?? fareOf(d),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          KsRouteMap(
            height: _mapH,
            from: d.pickup.geo,
            to: d.dropoff.geo,
            truck: live?.geo,
          ),
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          Row(
            children: [
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
                  onPressed: () => context.push(Routes.buyerTrack(d.id)),
                ),
              ),
            ],
          ),
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
        final url =
            (await ref
                    .read(imageStorageProvider)
                    .upload(_photo!, kind: ImageKind.delivery, ownerUid: uid))
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
          KsInfoBox(
            children: [
              KsInfoRow(l.rowOrder, l.noOrderCrop(d.orderNo, d.cropName(lang))),
              KsInfoRow(l.rowOrdered, kg(d.weightKg)),
              KsInfoRow(l.rowLoaded, kg(d.deliveredKg ?? d.weightKg)),
            ],
          ),
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
            warning: true,
          ),
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
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          KsButton.secondary(
            label: l.otherProblem,
            onPressed: () => context.push(Routes.report(orderId: d.orderId)),
          ),
          const SizedBox(height: AppSpacing.block),
          KsButton(
            label: l.otpGiven,
            loading: _busy,
            onPressed: () => _done(d, me.uid),
          ),
        ],
      ),
    );
  }
}

/// 108 Tracking (buyer, Figma 292:2665; farmer from 45): route map with
/// the truck's live position (sent by the driver's phone while the trip is
/// active), trip status, arrival estimate and distance left. Without a
/// live position: pickup date + road time and the whole road distance.
class TrackingScreen extends ConsumerWidget {
  const TrackingScreen({super.key, required this.deliveryId});
  final String deliveryId;

  static const _mapH = 300.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final d = ref.watch(deliveryProvider(deliveryId)).value;
    if (d == null || d.transporterId == null) return _loading(l.trackTitle);
    final driver = ref.watch(userByIdProvider(d.transporterId!)).value;
    final v = d.vehicle;
    final rating = driver == null || driver.ratingCount == 0
        ? l.notAvailable
        : Fmt.number(context, driver.ratingAvg, decimals: 1);
    final active =
        d.status == DeliveryStatus.assigned ||
        d.status == DeliveryStatus.pickedUp;
    final live = active ? ref.watch(livePosProvider(d.id)).value : null;
    // Share of the road still left; only once the crop is on the truck.
    final left = d.status == DeliveryStatus.pickedUp ? tripLeft(d, live) : null;
    final start = d.timeline['pickedUp'] ?? d.pickupDate;
    var eta =
        d.timeline['delivered'] ??
        (left != null && d.hours != null
            ? DateTime.now().add(
                Duration(minutes: (d.hours! * 60 * left).round()),
              )
            : start == null || d.hours == null
            ? null
            : start.add(Duration(hours: d.hours!)));
    // A planned time that has already passed (truck late or not loaded
    // yet): count the whole road time from now instead.
    if (eta != null &&
        d.timeline['delivered'] == null &&
        d.hours != null &&
        eta.isBefore(DateTime.now())) {
      eta = DateTime.now().add(Duration(hours: d.hours!));
    }
    final seen = live?.at == null
        ? null
        : DateTime.now().difference(live!.at!).inMinutes;
    final status = switch (d.status) {
      DeliveryStatus.pickedUp => l.tsOnWay,
      DeliveryStatus.delivered => l.tsDelivered,
      _ => l.tsWaitingPickup,
    };

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.trackTitle),
      body: ListView(
        padding: _contentPad,
        children: [
          KsRouteMap(
            height: _mapH,
            from: d.pickup.geo,
            to: d.dropoff.geo,
            truck: live?.geo,
          ),
          const SizedBox(height: AppSpacing.block),
          KsListItem(
            thumb: KsNetImage(
              url: d.transporterPhotoUrl ?? driver?.photoUrl,
              thumbSize: KsListItem.thumbSize.round(),
              fallbackAsset: AppUi.avatarDriver,
            ),
            title: d.transporterName ?? '',
            subtitle: v == null
                ? rating
                : l.truckCapRating(
                    vehicleTypeLabel(l, v.type),
                    Fmt.plate(context, v.plateNo),
                    rating,
                  ),
            badge: (driver?.isVerified ?? false) ? l.verifiedBadge : null,
            showChevron: false,
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              KsInfoRow(l.rowStatus, status),
              if (eta != null)
                KsInfoRow(
                  l.rowEta,
                  l.dateTime(
                    Fmt.date(context, eta),
                    Fmt.digits(context, DateFormat('H:mm').format(eta)),
                  ),
                ),
              if (active)
                KsInfoRow(
                  l.rowTruckSeen,
                  seen == null
                      ? l.liveOff
                      : seen < 1
                      ? l.liveJustNow
                      : l.liveMinAgo(Fmt.digits(context, '$seen')),
                ),
              if (d.roadKm != null)
                left == null
                    ? KsInfoRow(
                        l.rowRemaining,
                        l.kmOnly(Fmt.number(context, d.roadKm!)),
                      )
                    : KsInfoRow(
                        l.rowLeftKm,
                        l.kmOnly(
                          Fmt.number(context, (d.roadKm! * left).round()),
                        ),
                      ),
            ],
          ),
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          Row(
            children: [
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
                // In-app chat is Tier C.
                child: KsButton.outline(
                  label: l.messageBtn,
                  onPressed: () => openChatWith(context, ref, d.transporterId!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
