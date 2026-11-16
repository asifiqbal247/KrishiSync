import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';

import '../../../shared/utils/sheet_utils.dart';
import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/data/market_price_repository.dart';
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/utils/geo.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_map_preview.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_option_card.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_search_bar.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../../admin/data/admin_repository.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../buyer/presentation/buyer_common.dart';
import '../../transport/presentation/transport_common.dart';
import '../data/demand_repository.dart';
import 'quality_standard_screen.dart';

const _pad = EdgeInsets.fromLTRB(
  AppSpacing.screen,
  AppSpacing.contentTop,
  AppSpacing.screen,
  AppSpacing.lg,
);
const _gapBeforeCta = AppSpacing.block + AppSpacing.xs + AppSpacing.block;
const _grades = ['A', 'B', 'C'];

/// Accepted + pending commitments for one demand.
num _sum(Iterable<Commit> cs) => cs.fold<num>(0, (a, c) => a + c.quantityKg);

String _date(BuildContext c, DateTime? d) => d == null ? '' : Fmt.date(c, d);

// ───────────────────────── Buyer ─────────────────────────

/// 96 / 98 Post Demand (Figma 292:1090 / 292:1110), two steps.
class PostDemandScreen extends ConsumerStatefulWidget {
  const PostDemandScreen({super.key});

  @override
  ConsumerState<PostDemandScreen> createState() => _PostDemandState();
}

class _PostDemandState extends ConsumerState<PostDemandScreen> {
  int _step = 1;
  Crop? _crop;
  String _grade = 'A';
  final _qty = TextEditingController();
  final _price = TextEditingController();
  UserLocation? _dropoff;
  DateTime? _date;
  bool _monthly = false;
  final Map<String, String?> _err = {};
  bool _busy = false;
  static const _mapH = 110.0;
  static const _optImg = 36.0;

  @override
  void initState() {
    super.initState();
    final me = ref.read(currentUserProvider).value;
    if (me != null && me.location.isComplete) _dropoff = me.location;
  }

  @override
  void dispose() {
    _qty.dispose();
    _price.dispose();
    super.dispose();
  }

  num? _n(TextEditingController c) =>
      num.tryParse(Fmt.latinDigits(c.text.trim()));

  void _next() {
    final l = AppLocalizations.of(context);
    setState(() {
      _err
        ..clear()
        ..['crop'] = _crop == null ? l.commonRequired : null
        ..['qty'] = (_n(_qty) ?? 0) <= 0 ? l.errQtyInvalid : null
        ..['price'] = (_n(_price) ?? 0) <= 0 ? l.commonRequired : null;
    });
    if (_err.values.any((e) => e != null)) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _step = 2);
  }

  Future<void> _publish(AppUser me) async {
    final l = AppLocalizations.of(context);
    setState(() {
      _err
        ..clear()
        ..['loc'] = _dropoff == null ? l.errAddressRequired : null
        ..['date'] = _date == null ? l.commonRequired : null;
    });
    if (_err.values.any((e) => e != null)) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(demandRepositoryProvider)
          .create(
            buyer: me,
            cropKey: _crop!.key,
            cropNameBn: _crop!.bn,
            cropNameEn: _crop!.en,
            grade: _grade,
            quantityKg: _n(_qty)!,
            targetPrice: _n(_price)!,
            dropoff: _dropoff!,
            deliveryDate: _date!,
            monthly: _monthly,
          );
      if (!mounted) return;
      KsToast.show(context, l.demandPosted);
      context.pushReplacement(Routes.myDemands);
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
    final crops = ref.watch(catalogProvider).where((c) => c.active).toList();
    final market = _crop == null
        ? null
        : ref.watch(marketPriceProvider(_crop!.key)).value;
    final digits = [FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯.]'))];
    final geo = _dropoff?.geo;

    final step1 = [
      KsSelectField(
        label: l.fieldCropName,
        placeholder: l.selectHint,
        value: _crop?.name(lang),
        errorText: _err['crop'],
        onTap: () async {
          final c = await showKsOptionsSheet<Crop>(
            context,
            title: l.fieldCropName,
            options: [for (final c in crops) (c.crop, c.crop.name(lang))],
          );
          if (c != null) setState(() => _crop = c);
        },
      ),
      const SizedBox(height: AppSpacing.block),
      KsSelectField(
        label: l.fieldGradeSize,
        placeholder: l.selectHint,
        value: l.gradeLabel(_grade),
        onTap: () async {
          final g = await showKsOptionsSheet<String>(
            context,
            title: l.fieldGradeSize,
            options: [for (final g in _grades) (g, l.gradeLabel(g))],
          );
          if (g == null || !context.mounted) return;
          // 97: show the standard for this crop + grade; "use" confirms it.
          final crop = _crop;
          if (crop == null) {
            setState(() => _grade = g);
            return;
          }
          final ok = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => QualityStandardScreen(
                cropKey: crop.key,
                cropName: crop.name(lang),
                grade: g,
              ),
            ),
          );
          if (ok == true) setState(() => _grade = g);
        },
      ),
      const SizedBox(height: AppSpacing.block),
      KsTextField(
        label: l.fieldQuantity,
        hint: Fmt.digits(context, '5000'),
        controller: _qty,
        suffixText: l.unitKg,
        keyboardType: TextInputType.number,
        inputFormatters: digits,
        errorText: _err['qty'],
      ),
      const SizedBox(height: AppSpacing.block),
      KsTextField(
        label: l.fieldTargetPrice,
        hint: Fmt.digits(context, '30'),
        controller: _price,
        suffixText: l.sellPriceUnit,
        keyboardType: TextInputType.number,
        inputFormatters: digits,
        errorText: _err['price'],
      ),
      if (market != null) ...[
        const SizedBox(height: AppSpacing.block),
        Text(
          l.marketRateLine(
            Fmt.number(context, market.min),
            Fmt.number(context, market.max),
          ),
          style: AppTypography.bodySmall.normal.withColor(
            AppColors.textSecondary,
          ),
        ),
      ],
      const SizedBox(height: _gapBeforeCta),
      KsButton(label: l.sellNext, onPressed: _next),
    ];

    final step2 = [
      KsSelectField(
        label: l.deliveryLocation,
        placeholder: l.selectHint,
        value: _dropoff == null ? null : placeFull(context, _dropoff!),
        errorText: _err['loc'],
        onTap: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          final loc = await context.push<UserLocation>(Routes.locationPicker);
          if (loc != null) setState(() => _dropoff = loc);
        },
      ),
      const SizedBox(height: AppSpacing.block),
      KsMapPreview(
        height: _mapH,
        point: geo == null ? null : LatLng(geo.latitude, geo.longitude),
      ),
      const SizedBox(height: AppSpacing.block),
      KsSelectField(
        label: l.deliveryDate,
        placeholder: l.selectHint,
        value: _date == null ? null : Fmt.date(context, _date!),
        showChevron: false,
        errorText: _err['date'],
        onTap: () async {
          final now = DateTime.now();
          final d = await showDatePicker(
            context: context,
            firstDate: now,
            lastDate: now.add(const Duration(days: 180)),
            initialDate: _date ?? now.add(const Duration(days: 7)),
          );
          if (d != null) setState(() => _date = d);
        },
      ),
      const SizedBox(height: AppSpacing.block),
      KsOptionCard(
        image: const AssetImage(AppImages.langIcon),
        imageSize: _optImg,
        title: l.repeatOnce,
        subtitle: l.repeatOnceSub,
        selected: !_monthly,
        onTap: () => setState(() => _monthly = false),
      ),
      const SizedBox(height: AppSpacing.block),
      KsOptionCard(
        image: const AssetImage(AppImages.langIcon),
        imageSize: _optImg,
        title: l.repeatMonthly,
        subtitle: l.repeatMonthlySub,
        selected: _monthly,
        onTap: () => setState(() => _monthly = true),
      ),
      const SizedBox(height: _gapBeforeCta),
      KsButton(
        label: l.publishDemand,
        loading: _busy,
        onPressed: me == null ? null : () => _publish(me),
      ),
    ];

    return PopScope(
      canPop: _step == 1,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _step = 1);
      },
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(
          title: l.postDemandTitle,
          onBack: _step == 2 ? () => setState(() => _step = 1) : null,
        ),
        body: ListView(
          padding: _pad,
          children: [
            KsStepper(
              labels: [l.stepProductQty, l.stepDelivery],
              current: _step,
            ),
            const SizedBox(height: AppSpacing.block),
            ...(_step == 1 ? step1 : step2),
          ],
        ),
      ),
    );
  }
}

/// Buyer's demands list (opened from home "সংগ্রহ ড্যাশবোর্ড" and the FAB).
class MyDemandsScreen extends ConsumerWidget {
  const MyDemandsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final async = ref.watch(myDemandsProvider);
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.myDemandsTitle),
      body: switch (async) {
        AsyncData(value: final list) => ListView(
          padding: _pad,
          children: [
            KsButton(
              label: l.postDemandTitle,
              onPressed: () => context.push(Routes.postDemand),
            ),
            if (list.isEmpty) ...[
              const SizedBox(height: AppSpacing.block),
              Text(
                l.noDemands,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.normal.withColor(
                  AppColors.textSecondary,
                ),
              ),
            ],
            for (final d in list) ...[
              const SizedBox(height: AppSpacing.block),
              _MyDemandRow(d: d, lang: lang),
            ],
          ],
        ),
        AsyncError() => Center(child: Text(l.errorGeneric)),
        _ => const KsSkeletonList(),
      },
    );
  }
}

class _MyDemandRow extends ConsumerWidget {
  const _MyDemandRow({required this.d, required this.lang});
  final Demand d;
  final String lang;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final n = (ref.watch(commitsProvider(d.id)).value ?? const []).length;
    final (badge, bg, fg) = switch (d.status) {
      DemandStatus.open => (
        l.offersReceived(Fmt.digits(context, '$n')),
        AppColors.bgSuccessSubtle,
        AppColors.textSuccess,
      ),
      DemandStatus.filled => (
        l.demandFilled,
        AppColors.bgMuted,
        AppColors.textSecondary,
      ),
      DemandStatus.closed => (
        l.demandClosed,
        AppColors.bgMuted,
        AppColors.textSecondary,
      ),
    };
    return KsListItem(
      thumb: KsNetImage(
        url: null,
        thumbSize: KsListItem.thumbSize.round(),
        fallbackAsset: CropCatalog.imageFor(d.cropKey),
      ),
      title: l.demandLine(d.cropName(lang), tonsText(context, d.quantityKg)),
      subtitle: l.demandSubTarget(
        _date(context, d.deliveryDate),
        Fmt.number(context, d.targetPrice),
      ),
      badge: badge,
      badgeColor: bg,
      badgeTextColor: fg,
      onTap: () => context.push(Routes.demandOffers(d.id)),
    );
  }
}

enum _Sort { price, quality, rating }

/// 99 Demand Offers / Compare (Figma 292:1140).
class DemandOffersScreen extends ConsumerStatefulWidget {
  const DemandOffersScreen({super.key, required this.demandId});
  final String demandId;

  @override
  ConsumerState<DemandOffersScreen> createState() => _DemandOffersState();
}

class _DemandOffersState extends ConsumerState<DemandOffersScreen> {
  _Sort _sort = _Sort.price;
  final Set<String> _picked = {};
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    final d = ref.watch(demandProvider(widget.demandId)).value;
    final commits = ref.watch(commitsProvider(widget.demandId)).value;
    if (d == null || commits == null || me == null) {
      return Scaffold(
        appBar: KsAppBar(title: l.postDemandTitle),
        body: const KsSkeletonList(),
      );
    }
    final accepted = commits
        .where((c) => c.status == CommitStatus.accepted)
        .toList();
    final pending = commits
        .where((c) => c.status == CommitStatus.pending)
        .toList();
    pending.sort(
      (a, b) => switch (_sort) {
        // Every farmer supplies at the buyer's target price, so "price"
        // sorts by the larger quantity (cheaper per trip).
        _Sort.price => b.quantityKg.compareTo(a.quantityKg),
        _Sort.quality => (a.readyDate ?? DateTime(2100)).compareTo(
          b.readyDate ?? DateTime(2100),
        ),
        _Sort.rating => b.ratingAvg.compareTo(a.ratingAvg),
      },
    );
    final chosen = pending.where((c) => _picked.contains(c.farmerId)).toList();
    final selectedKg = _sum(accepted) + _sum(chosen);
    final open = d.status == DemandStatus.open;

    Widget row(Commit c, {bool done = false}) => KsListItem(
      thumb: KsNetImage(
        url: c.photoUrl,
        thumbSize: KsListItem.thumbSize.round(),
        fallbackAsset: AppUi.avatarFarmer,
      ),
      title: c.farmerName,
      subtitle: l.commitSub(
        qtyText(context, c.quantityKg),
        d.grade,
        c.ratingCount == 0
            ? l.notAvailable
            : Fmt.number(context, c.ratingAvg, decimals: 1),
      ),
      trailingText: done ? null : Fmt.taka(context, d.targetPrice),
      badge: done ? l.acceptedBadge : null,
      highlighted: _picked.contains(c.farmerId),
      showChevron: !done,
      onTap: done
          ? () => context.push(Routes.order(c.orderId ?? ''))
          : (open
                ? () => setState(
                    () => _picked.contains(c.farmerId)
                        ? _picked.remove(c.farmerId)
                        : _picked.add(c.farmerId),
                  )
                : null),
    );

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(
        title: l.offersReceived(Fmt.digits(context, '${commits.length}')),
      ),
      body: ListView(
        padding: _pad,
        children: [
          KsListItem(
            title: l.demandLine(
              d.cropName(lang),
              qtyText(context, d.quantityKg),
            ),
            subtitle: l.demandSubTarget(
              _date(context, d.deliveryDate),
              Fmt.number(context, d.targetPrice),
            ),
            showChevron: false,
          ),
          const SizedBox(height: AppSpacing.block),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final (s, label) in [
                (_Sort.price, l.sortPrice),
                (_Sort.quality, l.sortQuality),
                (_Sort.rating, l.sortRating),
              ])
                KsPill(
                  label: label,
                  selected: _sort == s,
                  onTap: () => setState(() => _sort = s),
                ),
            ],
          ),
          if (commits.isEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            Text(
              l.noCommits,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.normal.withColor(
                AppColors.textSecondary,
              ),
            ),
          ],
          for (final c in accepted) ...[
            const SizedBox(height: AppSpacing.block),
            row(c, done: true),
          ],
          for (final c in pending) ...[
            const SizedBox(height: AppSpacing.block),
            row(c),
          ],
          const SizedBox(height: AppSpacing.block),
          Row(
            children: [
              Expanded(
                child: Text(
                  l.selectedTotal,
                  style: AppTypography.bodySmallStrong.normal,
                ),
              ),
              Text(
                l.ofKg(
                  Fmt.number(context, selectedKg),
                  Fmt.number(context, d.quantityKg),
                ),
                style: AppTypography.bodySmallStrong.normal,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _Progress(value: d.quantityKg == 0 ? 0 : selectedKg / d.quantityKg),
          const SizedBox(height: _gapBeforeCta),
          if (open) ...[
            KsButton(
              label: l.acceptSelected,
              loading: _busy,
              onPressed: () async {
                if (chosen.isEmpty) {
                  KsToast.show(context, l.selectCommit);
                  return;
                }
                setState(() => _busy = true);
                try {
                  await ref
                      .read(demandRepositoryProvider)
                      .accept(d, chosen, me, _sum(accepted));
                  _picked.clear();
                  if (mounted) KsToast.show(this.context, l.commitsAccepted);
                } catch (_) {
                  if (mounted) KsToast.show(this.context, l.errorGeneric);
                } finally {
                  if (mounted) setState(() => _busy = false);
                }
              },
            ),
            const SizedBox(height: AppSpacing.block),
            KsButton.text(
              label: l.closeDemand,
              onPressed: () async {
                final ok = await showKsConfirm(
                  context,
                  title: l.closeDemand,
                  body: l.closeDemandBody,
                  noLabel: l.noGoBack,
                  yesLabel: l.closeDemand,
                );
                if (ok) await ref.read(demandRepositoryProvider).close(d.id);
              },
            ),
          ],
        ],
      ),
    );
  }
}

/// Green progress bar (pooling 32 / selected total 99): 8 high, radius 4.
class _Progress extends StatelessWidget {
  const _Progress({required this.value});
  final double value;
  static const _h = 8.0;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(AppRadius.sm),
    child: LinearProgressIndicator(
      value: value.clamp(0, 1).toDouble(),
      minHeight: _h,
      color: AppColors.bgBrand,
      backgroundColor: AppColors.bgMuted,
    ),
  );
}

// ───────────────────────── Farmer ─────────────────────────

enum _DFilter { all, nearby, big, export }

/// 31 Buyer Demands (farmer, Figma 292:573).
class BuyerDemandsScreen extends ConsumerStatefulWidget {
  const BuyerDemandsScreen({super.key});

  @override
  ConsumerState<BuyerDemandsScreen> createState() => _BuyerDemandsState();
}

class _BuyerDemandsState extends ConsumerState<BuyerDemandsScreen> {
  final _q = TextEditingController();
  _DFilter _f = _DFilter.all;
  static const _nearbyKm = 150.0;
  static const _bigKg = 2000;

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    final async = ref.watch(openDemandsProvider);
    final q = _q.text.trim().toLowerCase();

    bool keep(Demand d) {
      final hay = [
        d.cropNameBn,
        d.cropNameEn.toLowerCase(),
        districtOf(context, d.dropoff).toLowerCase(),
      ];
      if (q.isNotEmpty && !hay.any((h) => h.contains(q))) return false;
      return switch (_f) {
        _DFilter.all => true,
        _DFilter.nearby =>
          (distanceKm(me?.location.geo, d.dropoff.geo) ?? 1e9) <= _nearbyKm,
        _DFilter.big => d.quantityKg >= _bigKg,
        // Export demands are Tier C.
        _DFilter.export => false,
      };
    }

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.buyerDemandsTitle),
      body: switch (async) {
        AsyncData(value: final all) => () {
          final list = all.where(keep).toList();
          return ListView(
            padding: _pad,
            children: [
              KsSearchBar(
                hint: l.demandSearchHint,
                controller: _q,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.block),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final (f, label) in [
                    (_DFilter.all, l.filterAll),
                    (_DFilter.nearby, l.filterNearby),
                    (_DFilter.big, l.filterBigOrder),
                    (_DFilter.export, l.filterExport),
                  ])
                    KsPill(
                      label: label,
                      selected: _f == f,
                      onTap: () => setState(() => _f = f),
                    ),
                ],
              ),
              if (list.isEmpty) ...[
                const SizedBox(height: AppSpacing.block),
                Text(
                  l.noDemands,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.normal.withColor(
                    AppColors.textSecondary,
                  ),
                ),
              ],
              for (final d in list) ...[
                const SizedBox(height: AppSpacing.block),
                _DemandRow(d: d, lang: lang),
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

class _DemandRow extends ConsumerWidget {
  const _DemandRow({required this.d, required this.lang});
  final Demand d;
  final String lang;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final commits = ref.watch(commitsProvider(d.id)).value ?? const [];
    final got = _sum(commits);
    final pct = d.quantityKg == 0 ? 0 : (got * 100 / d.quantityKg).round();
    return KsListItem(
      thumb: KsNetImage(
        url: null,
        thumbSize: KsListItem.thumbSize.round(),
        fallbackAsset: CropCatalog.imageFor(d.cropKey),
      ),
      title: l.demandLine(d.cropName(lang), tonsText(context, d.quantityKg)),
      subtitle: got > 0
          ? l.poolingSub(Fmt.digits(context, '$pct'))
          : l.demandRowSub(d.buyerName, _date(context, d.deliveryDate)),
      trailingText: l.pricePerKg(Fmt.taka(context, d.targetPrice)),
      onTap: () => context.push(Routes.demandDetails(d.id)),
    );
  }
}

/// 32 Demand Details + 33 Commit Supply sheet (farmer).
class DemandDetailsScreen extends ConsumerWidget {
  const DemandDetailsScreen({super.key, required this.demandId});
  final String demandId;

  Future<void> _commitSheet(
    BuildContext context,
    WidgetRef ref,
    Demand d,
    AppUser me,
    num left,
    Commit? mine,
  ) async {
    final l = AppLocalizations.of(context);
    final qty = TextEditingController(
      text: mine == null ? '' : '${mine.quantityKg}',
    );
    var ready = mine?.readyDate ?? DateTime.now().add(const Duration(days: 3));
    String? err;
    var busy = false;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) {
          final n = num.tryParse(Fmt.latinDigits(qty.text.trim())) ?? 0;
          return Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.xl,
              AppSpacing.screen,
              AppSpacing.s2xl + MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.howMuchSupply,
                  style: AppTypography.headingBold20.normal,
                ),
                const SizedBox(height: AppSpacing.block),
                KsTextField(
                  label: l.fieldQuantity,
                  hint: Fmt.number(ctx, left),
                  controller: qty,
                  suffixText: l.unitKg,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯.]')),
                  ],
                  errorText: err,
                  onChanged: (_) => setS(() {}),
                ),
                const SizedBox(height: AppSpacing.block),
                KsSelectField(
                  label: l.readyFrom,
                  placeholder: '',
                  value: Fmt.date(ctx, ready),
                  showChevron: false,
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    final now = DateTime.now();
                    final p = await showDatePicker(
                      context: ctx,
                      firstDate: now,
                      lastDate: now.add(const Duration(days: 180)),
                      initialDate: ready,
                    );
                    if (p != null) setS(() => ready = p);
                  },
                ),
                const SizedBox(height: AppSpacing.block),
                KsInfoBox(
                  children: [
                    KsInfoRow(l.estTotal, Fmt.taka(ctx, n * d.targetPrice)),
                    KsInfoRow(l.rowPayment, l.paymentSafeLoad),
                  ],
                ),
                const SizedBox(height: AppSpacing.block),
                KsButton(
                  label: l.commonConfirm,
                  loading: busy,
                  onPressed: () async {
                    if (n <= 0) {
                      setS(() => err = l.errQtyInvalid);
                      return;
                    }
                    if (n > left) {
                      setS(() => err = l.errQtyLeft(qtyText(ctx, left)));
                      return;
                    }
                    setS(() => busy = true);
                    try {
                      await ref
                          .read(demandRepositoryProvider)
                          .commit(d, me, quantityKg: n, readyDate: ready);
                      if (ctx.mounted) Navigator.pop(ctx);
                      if (context.mounted) KsToast.show(context, l.commitSent);
                    } catch (_) {
                      setS(() => busy = false);
                      if (context.mounted) {
                        KsToast.show(context, l.errorGeneric);
                      }
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
    disposeAfterSheet([qty]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    final d = ref.watch(demandProvider(demandId)).value;
    final commits = ref.watch(commitsProvider(demandId)).value ?? const [];
    if (d == null || me == null) {
      return Scaffold(
        appBar: KsAppBar(title: l.demandDetailsTitle),
        body: const KsSkeletonList(rows: 3),
      );
    }
    final buyer = ref.watch(userByIdProvider(d.buyerId)).value;
    final mine = commits.where((c) => c.farmerId == me.uid).firstOrNull;
    final others = _sum(commits.where((c) => c.farmerId != me.uid));
    final got = _sum(commits);
    final left = (d.quantityKg - others).clamp(0, d.quantityKg);
    final km = distanceKm(me.location.geo, d.dropoff.geo);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.demandDetailsTitle),
      body: ListView(
        padding: _pad,
        children: [
          KsInfoBox(
            children: [
              KsLinkRow(
                label: l.rowBuyer,
                value: (buyer?.isVerified ?? false)
                    ? l.verifiedSuffix(d.buyerName)
                    : d.buyerName,
                onTap: () => context.push(Routes.buyerProfile(d.buyerId)),
              ),
              KsInfoRow(
                l.rowRating,
                buyer == null || buyer.ratingCount == 0
                    ? l.notAvailable
                    : l.ratingTrades(
                        Fmt.number(context, buyer.ratingAvg, decimals: 1),
                        Fmt.digits(context, '${buyer.ratingCount}'),
                      ),
              ),
              KsInfoRow(l.rowCrop, l.cropWithGrade(d.cropName(lang), d.grade)),
              KsInfoRow(l.rowNeed, qtyText(context, d.quantityKg)),
              KsInfoRow(
                l.rowPrice,
                l.priceLine(Fmt.number(context, d.targetPrice)),
              ),
              KsInfoRow(
                l.rowDelivery,
                l.placeDate(
                  districtOf(context, d.dropoff),
                  _date(context, d.deliveryDate),
                ),
              ),
              if (km != null)
                KsInfoRow(
                  l.rowDistance,
                  l.kmOnly(Fmt.number(context, (km * 1.3).round())),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          KsLinkRow(
            label: l.stdTitle,
            value: l.seeLinkShort,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => QualityStandardScreen(
                  cropKey: d.cropKey,
                  cropName: d.cropName(lang),
                  grade: d.grade,
                  pick: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.block),
          Row(
            children: [
              Expanded(
                child: Text(
                  l.poolingProgress,
                  style: AppTypography.bodySmallStrong.normal,
                ),
              ),
              Text(
                l.ofKg(
                  Fmt.number(context, got),
                  Fmt.number(context, d.quantityKg),
                ),
                style: AppTypography.bodySmallStrong.normal,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _Progress(value: d.quantityKg == 0 ? 0 : got / d.quantityKg),
          const SizedBox(height: AppSpacing.block),
          Text(
            l.poolingNote,
            style: AppTypography.bodySmall.normal.withColor(
              AppColors.textSecondary,
            ),
          ),
          if (mine != null) ...[
            const SizedBox(height: AppSpacing.block),
            KsNoteBox(
              title: l.myCommitLine(
                qtyText(context, mine.quantityKg),
                mine.status == CommitStatus.accepted
                    ? l.acceptedBadge
                    : l.commitPending,
              ),
            ),
          ],
          const SizedBox(height: _gapBeforeCta),
          if (d.status == DemandStatus.open &&
              me.role == UserRole.farmer &&
              (mine == null || mine.status == CommitStatus.pending)) ...[
            // Committing a future harvest is Tier C.
            KsButton.secondary(
              label: l.futureHarvest,
              onPressed: () => KsToast.comingSoon(context),
            ),
            const SizedBox(height: AppSpacing.block),
            KsButton(
              label: l.wantToSupply,
              onPressed: left <= 0
                  ? null
                  : () => _commitSheet(context, ref, d, me, left, mine),
            ),
          ],
        ],
      ),
    );
  }
}
