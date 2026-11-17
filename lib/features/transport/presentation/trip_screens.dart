import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/services/image_storage_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_hero.dart';
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
import '../../auth/domain/app_user.dart';
import '../../buyer/presentation/buyer_common.dart' show qtyText;
import '../data/transport_repository.dart';
import '../domain/delivery.dart';
import 'transport_common.dart';

/// Opens Google Maps directions pickup → drop (decided in PLAN.md).
Future<void> openDirections(Delivery d) async {
  final a = d.pickup.geo;
  final b = d.dropoff.geo;
  if (a == null || b == null) return;
  final uri = Uri.parse(
    'https://www.google.com/maps/dir/?api=1'
    '&origin=${a.latitude},${a.longitude}'
    '&destination=${b.latitude},${b.longitude}&travelmode=driving',
  );
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// Google Maps directions through every farm of a trip, then the buyer.
Future<void> openTripDirections(Trip t) async {
  final todo = t.stops.where((d) => d.status == DeliveryStatus.assigned);
  final pts = [for (final d in todo) ?d.pickup.geo];
  final b = t.lead.dropoff.geo;
  if (b == null) return;
  String ll(GeoPoint g) => '${g.latitude},${g.longitude}';
  final uri = Uri.parse(
    'https://www.google.com/maps/dir/?api=1'
    '&destination=${ll(b)}'
    '${pts.isEmpty ? '' : '&waypoints=${pts.map(ll).join('|')}'}'
    '&travelmode=driving',
  );
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// Everything on the truck now: weight of all running jobs.
num loadOnTruck(Iterable<Delivery> mine) => mine
    .where((d) => d.status.isActive)
    .fold<num>(0, (a, d) => a + (d.loadedKg ?? d.weightKg));

Widget _loading(String title) => Scaffold(
  appBar: KsAppBar(title: title),
  body: const Center(child: CircularProgressIndicator()),
);

enum _JobTab { today, upcoming, done }

/// 152 My Jobs (Figma 292:1715) — the "ট্রিপ" tab.
class MyJobsScreen extends ConsumerStatefulWidget {
  const MyJobsScreen({super.key});

  @override
  ConsumerState<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends ConsumerState<MyJobsScreen> {
  _JobTab _tab = _JobTab.today;

  bool _in(Trip t) {
    final now = DateTime.now();
    final endOfToday = DateTime(now.year, now.month, now.day + 1);
    final at = t.lead.pickupDate;
    final future = at != null && !at.isBefore(endOfToday);
    final s = t.status;
    return switch (_tab) {
      // Running jobs always show under "today".
      _JobTab.today => s.isActive && (s == DeliveryStatus.pickedUp || !future),
      _JobTab.upcoming => s == DeliveryStatus.assigned && future,
      _JobTab.done => s == DeliveryStatus.delivered,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final jobs = ref.watch(myDeliveriesProvider).value;
    // A purchase order's farms are one job (multi-stop).
    final shown = Trip.group(jobs ?? const <Delivery>[]).where(_in).toList();
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.myJobsTitle, showBack: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.contentTop,
          AppSpacing.screen,
          AppSpacing.lg,
        ),
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final (t, label) in [
                (_JobTab.today, l.jobsToday),
                (_JobTab.upcoming, l.jobsUpcoming),
                (_JobTab.done, l.jobsDone),
              ])
                KsPill(
                  label: label,
                  selected: _tab == t,
                  onTap: () => setState(() => _tab = t),
                ),
            ],
          ),
          if (jobs == null) ...[
            const SizedBox(height: AppSpacing.block),
            const KsSkeletonList(padded: false),
          ] else if (shown.isEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            Text(
              l.noJobs,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.normal.withColor(
                AppColors.textSecondary,
              ),
            ),
          ],
          for (final t in shown) ...[
            const SizedBox(height: AppSpacing.block),
            _jobRow(context, l, lang, t),
          ],
        ],
      ),
    );
  }

  Widget _jobRow(
    BuildContext context,
    AppLocalizations l,
    String lang,
    Trip t,
  ) {
    final j = t.summary;
    final status = t.status;
    return KsListItem(
      thumb: KsNetImage(
        url: j.photo,
        thumbSize: KsListItem.thumbSize.round(),
        fallbackAsset: CropCatalog.imageFor(j.cropKey),
      ),
      title: l.jobTitle(
        t.no,
        j.cropName(lang),
        tonsText(context, j.loadedKg ?? j.weightKg),
      ),
      subtitle: t.multi
          ? l.placeDate(
              routeOf(context, j),
              l.pickupsN(Fmt.digits(context, '${t.stops.length}')),
            )
          : j.pickupDate == null
          ? routeOf(context, j)
          : l.placeDate(routeOf(context, j), Fmt.date(context, j.pickupDate!)),
      badge: switch (status) {
        DeliveryStatus.pickedUp => l.badgeRunning,
        DeliveryStatus.delivered => l.badgeDone,
        _ => l.badgeScheduled,
      },
      badgeColor: status == DeliveryStatus.pickedUp
          ? AppColors.bgWarningSubtle
          : AppColors.bgSuccessSubtle,
      badgeTextColor: status == DeliveryStatus.pickedUp
          ? AppColors.textWarning
          : AppColors.textSuccess,
      onTap: () => context.push(
        status == DeliveryStatus.delivered
            ? Routes.trDone(j.id)
            : Routes.trJob(j.id),
      ),
    );
  }
}

/// 153 Pickup Schedule (Figma 292:1729): every farm of the trip in
/// pickup order, then the delivery.
class PickupScheduleScreen extends ConsumerWidget {
  const PickupScheduleScreen({super.key, required this.deliveryId});
  final String deliveryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final t = ref.watch(tripProvider(deliveryId));
    if (t == null) return _loading(l.scheduleTitle);
    final d = t.summary;
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.scheduleTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.contentTop,
          AppSpacing.screen,
          AppSpacing.lg,
        ),
        children: [
          KsInfoBox(
            children: [
              KsInfoRow(
                l.rowJob,
                l.jobTitle(t.no, d.cropName(lang), qtyTextKg(context, d)),
              ),
              KsInfoRow(
                l.rowTotalStops,
                t.multi
                    ? l.stopsMany(Fmt.digits(context, '${t.stops.length}'))
                    : l.stopsOne,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          KsSectionHeader(title: l.pickupOrder),
          for (final (i, s) in t.stops.indexed) ...[
            const SizedBox(height: AppSpacing.block),
            KsTimelineItem(
              title: l.stopN(Fmt.digits(context, '${i + 1}'), s.farmerName),
              subtitle: l.stopSub(
                placeFull(context, s.pickup),
                qtyTextKg(context, s),
                s.pickupDate == null ? '' : Fmt.date(context, s.pickupDate!),
              ),
              done:
                  s.status == DeliveryStatus.pickedUp ||
                  s.status == DeliveryStatus.delivered,
            ),
          ],
          const SizedBox(height: AppSpacing.block),
          KsTimelineItem(
            title: l.stopDelivery,
            subtitle: placeFull(context, d.dropoff),
            done: t.delivered,
          ),
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          KsButton(
            label: l.seeRoute,
            // 155 route choice for several farms, else straight to 156.
            onPressed: () => context.push(
              t.multi ? Routes.trRoute(d.id) : Routes.trNav(d.id),
            ),
          ),
        ],
      ),
    );
  }
}

String qtyTextKg(BuildContext context, Delivery d) =>
    AppLocalizations.of(context).qtyKg(Fmt.number(context, d.weightKg));

/// 159 Trip Status (Figma 292:1793).
class TripStatusScreen extends ConsumerStatefulWidget {
  const TripStatusScreen({super.key, required this.deliveryId});
  final String deliveryId;

  @override
  ConsumerState<TripStatusScreen> createState() => _TripStatusScreenState();
}

class _TripStatusScreenState extends ConsumerState<TripStatusScreen> {
  /// Figma hero map height (full-bleed, square corners).
  static const _heroH = 242.0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    final t = ref.watch(tripProvider(widget.deliveryId));
    final mine = ref.watch(myDeliveriesProvider).value ?? const <Delivery>[];
    if (t == null || me == null) return _loading(l.tripStatusTitle);
    final d = t.lead;
    final cap = me.vehicle?.capacityKg ?? 0;
    // Free space counts every running job on the truck (shared loads too).
    final freeKg = cap - loadOnTruck(mine);
    final done = t.delivered;
    final next = t.nextPickup;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      extendBodyBehindAppBar: true,
      appBar: KsAppBar(title: l.tripStatusTitle, onImage: true),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            children: [
              KsHeroPhoto(
                figmaHeight: _heroH,
                image: KsRouteMap(
                  height: double.infinity,
                  fitPadding: heroMapFit(context),
                  from: d.pickup.geo,
                  to: d.dropoff.geo,
                  points: [for (final s in t.stops.skip(1)) ?s.pickup.geo],
                  onTap: () => context.push(Routes.trNav(d.id)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  0,
                  AppSpacing.screen,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!done && freeKg > 0) ...[
                      const SizedBox(height: AppSpacing.block),
                      KsListItem(
                        highlighted: true,
                        thumb: Image.asset(AppUi.thumbLoad, fit: BoxFit.cover),
                        title: l.freeSpaceTitle(
                          Fmt.number(
                            context,
                            freeKg / 1000,
                            decimals: freeKg % 1000 == 0 ? 0 : 1,
                          ),
                        ),
                        subtitle: l.freeSpaceSub,
                        trailingText: l.seeLink,
                        onTap: () => context.push(Routes.trShared),
                      ),
                    ],
                    for (final (i, s) in t.stops.indexed) ...[
                      const SizedBox(height: AppSpacing.block),
                      () {
                        final loaded =
                            s.status == DeliveryStatus.pickedUp ||
                            s.status == DeliveryStatus.delivered;
                        final at = s.timeline['pickedUp'];
                        return KsTimelineItem(
                          title: l.stepPickupN(
                            Fmt.digits(context, '${i + 1}'),
                            s.farmerName,
                          ),
                          subtitle: !loaded
                              ? l.stepWaiting
                              : at == null
                              ? l.stepLoadedDone
                              : l.stepLoadedAt(Fmt.time(context, at)),
                          done: loaded,
                        );
                      }(),
                    ],
                    const SizedBox(height: AppSpacing.block),
                    KsTimelineItem(
                      title: l.stepDeliveryTo(d.buyerName),
                      subtitle: done ? l.dsDelivered : l.stepWaiting,
                      done: done,
                    ),
                    const SizedBox(height: AppSpacing.block),
                    Text(
                      l.offlineSafeNote,
                      style: AppTypography.bodySmall.normal.withColor(
                        AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.block),
                    KsListItem(
                      title: l.tripProblem,
                      subtitle: l.orderProblemSub,
                      onTap: () =>
                          context.push(Routes.report(orderId: d.orderId)),
                    ),
                    const SizedBox(
                      height:
                          AppSpacing.block + AppSpacing.xs + AppSpacing.block,
                    ),
                    // Load the next farm; when all are loaded, go to the buyer.
                    if (next != null)
                      KsButton(
                        label: t.multi
                            ? l.startWeighingStop(
                                Fmt.digits(context, '${t.stopNo(next)}'),
                              )
                            : l.startWeighing,
                        onPressed: () => context.push(Routes.trWeigh(next.id)),
                      )
                    else if (!done)
                      KsButton(
                        label: l.deliverNow,
                        onPressed: () => context.push(Routes.trDeliver(d.id)),
                      )
                    else
                      KsButton(
                        label: l.tripDoneBtn,
                        onPressed: () => context.push(Routes.trDone(d.id)),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const KsHeroShade(figmaHeight: 140),
        ],
      ),
    );
  }
}

/// 167 Proof of Delivery (Figma 292:1808).
class ProofOfDeliveryScreen extends ConsumerStatefulWidget {
  const ProofOfDeliveryScreen({super.key, required this.deliveryId});
  final String deliveryId;

  @override
  ConsumerState<ProofOfDeliveryScreen> createState() => _PodState();
}

class _PodState extends ConsumerState<ProofOfDeliveryScreen> {
  final _qty = TextEditingController();
  final _otp = TextEditingController();
  File? _photo;
  String? _qtyErr;
  String? _otpErr;
  bool _busy = false;

  @override
  void dispose() {
    _qty.dispose();
    _otp.dispose();
    super.dispose();
  }

  Future<void> _submit(Delivery d, AppUser me) async {
    final l = AppLocalizations.of(context);
    final qtyText = Fmt.latinDigits(_qty.text.trim());
    final qty = qtyText.isEmpty ? d.weightKg : num.tryParse(qtyText);
    final otp = Fmt.latinDigits(_otp.text.trim());
    setState(() {
      _qtyErr = (qty == null || qty <= 0) ? l.errQtyInvalid : null;
      _otpErr = otp.length == 4 ? null : l.errOtp4;
    });
    if (_qtyErr != null || _otpErr != null) return;
    setState(() => _busy = true);
    try {
      String? url;
      if (_photo != null) {
        url =
            (await ref
                    .read(imageStorageProvider)
                    .upload(
                      _photo!,
                      kind: ImageKind.delivery,
                      ownerUid: me.uid,
                    ))
                .url;
      }
      final t = ref.read(tripProvider(d.id)) ?? Trip([d]);
      if (t.multi) {
        await ref
            .read(transportRepositoryProvider)
            .markTripDelivered(t, me.uid, otp: otp, photoUrl: url);
      } else {
        await ref
            .read(transportRepositoryProvider)
            .markDelivered(
              d,
              me.uid,
              otp: otp,
              deliveredKg: qty!,
              photoUrl: url,
            );
      }
      if (!mounted) return;
      context.pushReplacement(Routes.trDone(d.id));
    } on TransportException catch (e) {
      if (mounted) {
        setState(() => _otpErr = e.code == 'wrong_otp' ? l.errOtpWrong : null);
        if (e.code != 'wrong_otp') KsToast.show(context, l.errorGeneric);
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
    final me = ref.watch(currentUserProvider).value;
    final d = ref.watch(deliveryProvider(widget.deliveryId)).value;
    if (d == null || me == null) return _loading(l.podTitle);
    final t = ref.watch(tripProvider(d.id)) ?? Trip([d]);
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.podTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.contentTop,
          AppSpacing.screen,
          AppSpacing.lg,
        ),
        children: [
          KsUploadBox(
            label: l.podPhoto,
            file: _photo,
            height: _photo == null
                ? KsUploadBox.defaultHeight
                : KsUploadBox.previewHeight,
            onTap: () async {
              final f = await pickPhoto(context);
              if (f != null) setState(() => _photo = f);
            },
          ),
          const SizedBox(height: AppSpacing.block),
          // A multi-stop trip keeps each farm's weighed amount.
          if (t.multi)
            KsInfoBox(
              children: [
                KsInfoRow(l.deliveredQty, qtyText(context, t.loadedKg)),
              ],
            )
          else
            KsTextField(
              label: l.deliveredQty,
              hint: Fmt.number(context, d.weightKg),
              controller: _qty,
              suffixText: l.unitKg,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯.]')),
              ],
              errorText: _qtyErr,
            ),
          const SizedBox(height: AppSpacing.block),
          KsTextField(
            label: l.buyerOtp,
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
            l.podNote,
            style: AppTypography.bodySmall.normal.withColor(
              AppColors.textSecondary,
            ),
          ),
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          KsButton(
            label: l.podSubmit,
            loading: _busy,
            onPressed: () => _submit(d, me),
          ),
        ],
      ),
    );
  }
}

/// 168 Trip Complete (Figma 292:2687).
class TripCompleteScreen extends ConsumerWidget {
  const TripCompleteScreen({super.key, required this.deliveryId});
  final String deliveryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = ref.watch(tripProvider(deliveryId));
    final open = ref.watch(openLoadsProvider).value ?? const <Delivery>[];
    if (t == null) return _loading(l.tripDoneTitle);
    final d = t.lead;
    final fare = Fmt.taka(context, t.fare ?? fareOf(d));
    final returns = returnLoads(open, d.dropoff.district);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.tripDoneTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.contentTop,
          AppSpacing.screen,
          AppSpacing.lg,
        ),
        children: [
          const SizedBox(height: AppSpacing.block),
          Text(
            l.tripDoneHeading,
            textAlign: TextAlign.center,
            style: AppTypography.headingBold22.normal,
          ),
          const SizedBox(height: AppSpacing.block),
          Text(
            l.tripDoneBody(fare),
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.normal.withColor(
              AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.block),
          // Receipts / payouts are Tier B.
          KsListItem(
            title: l.seeReceipt,
            subtitle: l.receiptSub(fare),
            onTap: () => context.push(Routes.receipt(d.orderId)),
          ),
          const SizedBox(height: AppSpacing.block),
          KsListItem(
            title: d.transporterRated ? l.alreadyRated : l.rateCustomer,
            subtitle: l.nameOrderNo(d.buyerName, t.no),
            showChevron: !d.transporterRated,
            onTap: d.transporterRated
                ? null
                : () => context.push(Routes.trRate(d.id)),
          ),
          if (returns.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            KsSectionHeader(title: l.dontGoEmpty),
            for (final (i, r) in returns.take(2).indexed) ...[
              const SizedBox(height: AppSpacing.block),
              LoadTile(
                d: r,
                withDate: true,
                highlighted: i == 0,
                onTap: () => context.push(Routes.trLoad(r.id)),
              ),
            ],
          ],
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          KsButton(
            label: l.acceptReturnLoad,
            onPressed: () => context.push(Routes.trReturnLoads),
          ),
          const SizedBox(height: AppSpacing.block),
          KsButton.outline(
            label: l.seeEarnings,
            onPressed: () => context.go(Routes.transporterHome),
          ),
        ],
      ),
    );
  }
}
