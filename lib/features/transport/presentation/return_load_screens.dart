import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
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
import '../../../shared/services/bd_location_service.dart';
import '../../../shared/utils/sheet_utils.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../chat/presentation/chat_screens.dart' show openChatWith;
import '../data/live_location.dart';
import '../data/transport_repository.dart';
import '../domain/delivery.dart';
import 'transport_common.dart';
import 'trip_screens.dart' show openDirections;

const _pad = EdgeInsets.fromLTRB(AppSpacing.screen, AppSpacing.contentTop,
    AppSpacing.screen, AppSpacing.lg);
const _heroH = 96.0;
const _mapH = 120.0;

/// A load counts as "on the way back" when it starts within this distance
/// of the return-from district and ends within it of the return-to one.
const _nearKm = 60.0;

/// Pickup may be from a day before to two days after the return date.
const _daysBefore = 1;
const _daysAfter = 2;

/// How many other destinations 176 suggests.
const _maxOtherDest = 3;

/// District centre (its own point, or the middle of its upazilas).
GeoPoint? districtCenter(BdLocations data, String? stored) {
  if (stored == null) return null;
  for (final dv in data.divisions) {
    for (final ds in dv.children) {
      if (ds.stored != stored) continue;
      if (ds.lat != null && ds.lng != null) return GeoPoint(ds.lat!, ds.lng!);
      final pts = ds.children.where((u) => u.lat != null && u.lng != null);
      if (pts.isEmpty) return null;
      return GeoPoint(
        pts.map((u) => u.lat!).reduce((a, b) => a + b) / pts.length,
        pts.map((u) => u.lng!).reduce((a, b) => a + b) / pts.length,
      );
    }
  }
  return null;
}

bool _near(UserLocation loc, String target, GeoPoint? centre) =>
    loc.district == target ||
    (loc.geo != null && centre != null && kmBetween(loc.geo!, centre) <= _nearKm);

/// Open loads that fit the saved way back (174).
List<Delivery> returnMatches(
    List<Delivery> open, ReturnRoute r, BdLocations? data, String myUid) {
  final a = data == null ? null : districtCenter(data, r.from);
  final b = data == null ? null : districtCenter(data, r.to);
  final day = DateTime(r.date.year, r.date.month, r.date.day);
  return open.where((d) {
    if (d.buyerId == myUid || d.weightKg > r.spaceKg) return false;
    final p = d.pickupDate;
    if (p != null &&
        (p.isBefore(day.subtract(const Duration(days: _daysBefore))) ||
            p.isAfter(day.add(const Duration(days: _daysAfter + 1))))) {
      return false;
    }
    return _near(d.pickup, r.from, a) && _near(d.dropoff, r.to, b);
  }).toList();
}

/// Suggested way back: from where the current trip ends (or home district)
/// to the truck's base, today, with the truck's full capacity free.
ReturnRoute defaultReturnRoute(AppUser me, List<Delivery> mine) {
  final active = mine.where((d) =>
      d.transporterId == me.uid &&
      (d.status == DeliveryStatus.assigned ||
          d.status == DeliveryStatus.pickedUp));
  final from = active.isNotEmpty
      ? active.first.dropoff.district
      : me.location.district;
  final to = me.vehicle?.base?.district ?? me.location.district;
  return ReturnRoute(
    from: from ?? '',
    to: to ?? '',
    date: DateTime.now(),
    spaceKg: me.vehicle?.capacityKg ?? 0,
  );
}

/// 175 Set Return Route (sheet, Figma 292:2701). Saves users/{uid}.returnRoute.
Future<void> showReturnRouteSheet(
    BuildContext context, WidgetRef ref, AppUser me, ReturnRoute start) async {
  final l = AppLocalizations.of(context);
  final lang = Localizations.localeOf(context).languageCode;
  final data = await ref.read(bdLocationsProvider.future);
  if (!context.mounted) return;
  final districts = [for (final dv in data.divisions) ...dv.children]
    ..sort((a, b) => a.name(lang).compareTo(b.name(lang)));
  final space = TextEditingController(
      text: start.spaceKg <= 0
          ? ''
          : Fmt.number(context, start.spaceKg / 1000, decimals: 1)
              .replaceAll(RegExp(r'[.,]0$'), ''));
  var from = start.from, to = start.to;
  final today = DateTime.now();
  final days = [for (var i = 0; i < 3; i++) DateTime(today.year, today.month, today.day + i)];
  var dayIdx = days.indexWhere((d) => DateUtils.isSameDay(d, start.date));
  if (dayIdx < 0) dayIdx = 0;
  String? err;
  var busy = false;

  String dayLabel(int i) => switch (i) {
        0 => l.retToday,
        1 => l.retTomorrow,
        _ => weekLabels(l)[(days[i].weekday + 1) % 7],
      };

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, set) {
        Future<String?> pick(String title) async {
          final p = await showKsOptionsSheet<BdPlace>(ctx,
              title: title,
              searchHint: l.commonSearch,
              options: [for (final d in districts) (d, d.name(lang))]);
          return p?.stored;
        }

        Future<void> save() async {
          final tons = double.tryParse(Fmt.latinDigits(space.text.trim()));
          if (from.isEmpty || to.isEmpty || tons == null || tons <= 0) {
            set(() => err = l.commonRequired);
            return;
          }
          set(() => busy = true);
          try {
            await ref.read(userRepositoryProvider).setReturnRoute(
                me.uid,
                ReturnRoute(
                    from: from,
                    to: to,
                    date: days[dayIdx],
                    spaceKg: tons * 1000));
            if (ctx.mounted) Navigator.pop(ctx);
          } catch (_) {
            set(() => busy = false);
            if (ctx.mounted) KsToast.show(ctx, l.errorGeneric);
          }
        }

        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screen),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l.retSetRoute, style: AppTypography.headingBold20.normal),
                  const SizedBox(height: AppSpacing.block),
                  KsSelectField(
                    label: l.retFrom,
                    placeholder: l.selectHint,
                    value: from.isEmpty
                        ? null
                        : (from == start.from
                            ? l.retFromHere(BdPlace.display(from, lang))
                            : BdPlace.display(from, lang)),
                    onTap: () async {
                      final p = await pick(l.retFrom);
                      if (p != null) set(() => from = p);
                    },
                  ),
                  const SizedBox(height: AppSpacing.block),
                  KsSelectField(
                    label: l.retTo,
                    placeholder: l.selectHint,
                    value: to.isEmpty ? null : BdPlace.display(to, lang),
                    onTap: () async {
                      final p = await pick(l.retTo);
                      if (p != null) set(() => to = p);
                    },
                  ),
                  const SizedBox(height: AppSpacing.block),
                  Text(l.retWhen, style: AppTypography.bodySmallStrong.normal),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(spacing: AppSpacing.sm, children: [
                    for (var i = 0; i < days.length; i++)
                      KsPill(
                          label: dayLabel(i),
                          selected: dayIdx == i,
                          onTap: () => set(() => dayIdx = i)),
                  ]),
                  const SizedBox(height: AppSpacing.block),
                  KsTextField(
                    label: l.retSpace,
                    hint: Fmt.digits(context, '3'),
                    controller: space,
                    suffixText: l.tonUnit,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯.]'))
                    ],
                    errorText: err,
                  ),
                  const SizedBox(height: AppSpacing.block),
                  KsButton(label: l.retSave, loading: busy, onPressed: save),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
  disposeAfterSheet([space]);
}

/// 174 Return Loads (Figma 292:1844) and 176 No Return Load Found
/// (292:3276): open loads on the driver's saved way back.
class ReturnLoadsScreen extends ConsumerStatefulWidget {
  const ReturnLoadsScreen({super.key});

  @override
  ConsumerState<ReturnLoadsScreen> createState() => _ReturnLoadsState();
}

class _ReturnLoadsState extends ConsumerState<ReturnLoadsScreen> {
  String? _pick;
  bool _busy = false;

  Future<void> _accept(Delivery d, AppUser me) async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(transportRepositoryProvider).placeBid(d, me, fareOf(d));
      if (!mounted) return;
      KsToast.show(context, l.retBidSent);
      context.push(Routes.trLoad(d.id));
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
    final open = ref.watch(openLoadsProvider).value;
    final mine = ref.watch(myDeliveriesProvider).value ?? const <Delivery>[];
    final data = ref.watch(bdLocationsProvider).value;
    if (me == null || open == null) {
      return Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(title: l.retTitle),
        body: const KsSkeletonList(rows: 3),
      );
    }
    final r = me.returnRoute;
    String place(String s) => BdPlace.display(s, lang);
    void edit() => showReturnRouteSheet(
        context, ref, me, r ?? defaultReturnRoute(me, mine));

    final routeCard = KsListItem(
      highlighted: true,
      thumb: Image.asset(AppImages.truckRoad, fit: BoxFit.cover),
      title: r == null ? l.retSetRoute : l.retMyRoute,
      subtitle: r == null
          ? l.retNoRouteSub
          : l.retRouteSub(place(r.from), place(r.to),
              Fmt.date(context, r.date), tonsText(context, r.spaceKg)),
      trailingText: l.retChange,
      onTap: edit,
    );

    if (r == null) {
      return Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(title: l.retTitle),
        body: ListView(padding: _pad, children: [routeCard]),
      );
    }

    final matches = returnMatches(open, r, data, me.uid);
    if (matches.isEmpty) return _none(context, me, r, open, mine, data, edit);

    final chosen = matches.where((d) => d.id == _pick).firstOrNull ??
        (matches.length == 1 ? matches.first : null);
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.retTitle),
      body: ListView(
        padding: _pad,
        children: [
          routeCard,
          const SizedBox(height: AppSpacing.block),
          Text(l.retForYou(place(r.from), place(r.to)),
              style: AppTypography.bodySmallStrong.normal),
          const SizedBox(height: AppSpacing.block),
          KsRouteMap(
            height: _mapH,
            from: data == null ? null : districtCenter(data, r.from),
            to: data == null ? null : districtCenter(data, r.to),
            points: [for (final d in matches) ?d.pickup.geo],
          ),
          for (final d in matches) ...[
            const SizedBox(height: AppSpacing.block),
            KsListItem(
              thumb: KsNetImage(
                url: d.photo,
                thumbSize: KsListItem.thumbSize.round(),
                fallbackAsset: AppImages.truckRoad,
              ),
              title: l.retLoadTitle(districtOf(context, d.pickup),
                  districtOf(context, d.dropoff)),
              subtitle: l.retLoadSub(
                  d.cropName(lang),
                  tonsText(context, d.weightKg),
                  d.pickupDate == null
                      ? l.notAvailable
                      : Fmt.date(context, d.pickupDate!)),
              trailingText: Fmt.taka(context, fareOf(d)),
              highlighted: d.id == chosen?.id,
              onTap: () => setState(() => _pick = d.id),
            ),
          ],
          const SizedBox(
              height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
          KsButton(
            label: l.retAccept,
            loading: _busy,
            onPressed: chosen == null ? null : () => _accept(chosen, me),
          ),
        ],
      ),
    );
  }

  /// 176: nothing on this route yet.
  Widget _none(BuildContext context, AppUser me, ReturnRoute r,
      List<Delivery> open, List<Delivery> mine, BdLocations? data,
      VoidCallback edit) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    String place(String s) => BdPlace.display(s, lang);

    // Last paid trip (the fare is released on delivery).
    final paid = mine
        .where((d) =>
            d.transporterId == me.uid && d.status == DeliveryStatus.delivered)
        .toList()
      ..sort((a, b) => (b.timeline['delivered'] ?? DateTime(0))
          .compareTo(a.timeline['delivered'] ?? DateTime(0)));

    // Other places loads from here are going to.
    final a = data == null ? null : districtCenter(data, r.from);
    final others = <String>{
      for (final d in open)
        if (d.dropoff.district != null &&
            d.dropoff.district != r.to &&
            _near(d.pickup, r.from, a))
          d.dropoff.district!,
    }.take(_maxOtherDest).toList();

    Future<void> setTo(String to) => ref.read(userRepositoryProvider).setReturnRoute(
        me.uid,
        ReturnRoute(from: r.from, to: to, date: r.date, spaceKg: r.spaceKg));

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.retTitle),
      body: ListView(
        padding: _pad,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Image.asset(AppImages.stateEmpty,
                height: _heroH, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: AppSpacing.block),
          Text(l.retNoneTitle,
              textAlign: TextAlign.center,
              style: AppTypography.headingBold22.normal),
          const SizedBox(height: AppSpacing.sm),
          Text(l.retNoneSub(place(r.from), place(r.to)),
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.normal
                  .withColor(AppColors.textSecondary)),
          if (paid.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            KsNoteBox(
              warning: true,
              title: l.retPaidTitle,
              body: l.retPaidBody(
                  paid.first.orderNo, Fmt.taka(context, fareOf(paid.first))),
            ),
          ],
          const SizedBox(height: AppSpacing.block),
          Text(l.retOtherDest, style: AppTypography.bodySmallStrong.normal),
          const SizedBox(height: AppSpacing.sm),
          Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
            KsPill(label: place(r.to), selected: true),
            for (final o in others)
              KsPill(label: place(o), selected: false, onTap: () => setTo(o)),
            KsPill(label: l.retOther, selected: false, onTap: edit),
          ]),
          const SizedBox(height: AppSpacing.sm),
          Text(l.retAlertOn,
              style: AppTypography.caption.normal
                  .withColor(AppColors.textSecondary)),
          const SizedBox(
              height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
          KsButton(
            label: l.retSearchAgain,
            onPressed: () => ref.invalidate(openLoadsProvider),
          ),
          const SizedBox(height: AppSpacing.md),
          KsButton.secondary(
            label: l.retGoHome,
            onPressed: () => context.go(Routes.transporterHome),
          ),
        ],
      ),
    );
  }
}

/// 177 Return Load Confirmed (Figma 292:3296): opened from the booking
/// notification when the job is on the driver's saved way back.
class ReturnDoneScreen extends ConsumerWidget {
  const ReturnDoneScreen({super.key, required this.deliveryId});
  final String deliveryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final d = ref.watch(deliveryProvider(deliveryId)).value;
    if (d == null) {
      return Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(title: l.retDoneBar, showBack: false),
        body: const KsSkeletonList(rows: 3),
      );
    }
    final buyer = ref.watch(userByIdProvider(d.buyerId)).value;
    final live = ref.watch(livePosProvider(d.id)).value;
    final km = live == null || d.pickup.geo == null
        ? null
        : kmBetween(live.geo, d.pickup.geo!).round();
    final when = d.pickupDate == null
        ? l.notAvailable
        : Fmt.digits(context,
            DateFormat('d MMM, H:mm', lang).format(d.pickupDate!));

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.retDoneBar, showBack: false),
      body: ListView(
        padding: _pad,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Image.asset(AppImages.handshake,
                height: _heroH, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: AppSpacing.block),
          Text(l.retDoneTitle,
              textAlign: TextAlign.center,
              style: AppTypography.headingBold22.normal),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(children: [
            KsInfoRow(
                l.rowRoute,
                l.retLoadTitle(districtOf(context, d.pickup),
                    districtOf(context, d.dropoff)),
                boldValue: true),
            KsInfoRow(
                l.rowGoods,
                l.nameDot(d.cropName(lang), tonsText(context, d.weightKg)),
                boldValue: true),
            KsInfoRow(
                l.fieldPickup,
                km == null
                    ? when
                    : l.retPickupLine(when, Fmt.digits(context, '$km')),
                boldValue: true),
            KsInfoRow(l.rowFare, Fmt.taka(context, fareOf(d)), boldValue: true),
          ]),
          const SizedBox(height: AppSpacing.block),
          KsNoteBox(
              warning: true,
              title: l.retPaySafeTitle,
              body: l.retPaySafeBody),
          const SizedBox(
              height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
          KsButton(label: l.retNavigate, onPressed: () => openDirections(d)),
          const SizedBox(height: AppSpacing.md),
          KsButton.outline(
            label: l.retCallBuyer,
            onPressed: buyer == null
                ? () => openChatWith(context, ref, d.buyerId)
                : () => launchUrl(Uri(scheme: 'tel', path: buyer.phone)),
          ),
          const SizedBox(height: AppSpacing.md),
          KsLinkRow(
            label: l.nameDot(d.orderNo, d.cropName(lang)),
            value: l.seeLinkShort,
            onTap: () => context.go(Routes.trJob(d.id)),
          ),
        ],
      ),
    );
  }
}
