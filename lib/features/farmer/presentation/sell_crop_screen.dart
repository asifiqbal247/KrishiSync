import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/data/market_price_repository.dart';
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/services/bd_location_service.dart';
import '../../../shared/services/image_storage_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_map_preview.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_photo_gallery.dart';
import '../../../shared/widgets/ks_photo_picker.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../admin/data/admin_repository.dart';
import '../../trade/data/trade_repository.dart';
import '../data/listing_repository.dart';
import '../domain/listing.dart';

enum _When { today, tomorrow, date }

/// 18 → 19 → 20 Sell Crop (Figma 292:2030, 292:2108, 292:535) + 21 success.
class SellCropScreen extends ConsumerStatefulWidget {
  const SellCropScreen({super.key, this.edit});

  /// Edit an existing listing (same 3 steps, prefilled). All changes are
  /// live at once; no moderator approval.
  final Listing? edit;

  @override
  ConsumerState<SellCropScreen> createState() => _SellCropScreenState();
}

class _SellCropScreenState extends ConsumerState<SellCropScreen> {
  static const _mapHeight = 200.0; // Figma 19: 328×200, square
  static const _reviewImageHeight = 200.0; // Figma 20: 328×200, square
  static const _grades = ['A', 'B', 'C'];

  int _step = 1;

  // Step 1
  String _cropKey = CropCatalog.sellChips.first.key; // Figma: টমেটো
  final _otherName = TextEditingController();
  String _grade = 'A';
  final _qty = TextEditingController();
  List<PickedPhoto> _photos = const [];

  // Step 2
  final _price = TextEditingController();
  _When _when = _When.tomorrow; // Figma 19 shows কাল selected
  DateTime? _date;
  UserLocation? _pickup;

  bool _publishing = false;
  String? _qtyError;
  String? _photoError;
  String? _otherError;
  String? _priceError;
  String? _error;

  @override
  void initState() {
    super.initState();
    final me = ref.read(currentUserProvider).value;
    if (me != null && me.location.isComplete) _pickup = me.location;
    final x = widget.edit;
    if (x != null) {
      _cropKey = x.cropKey;
      if (x.cropKey == CropCatalog.other) _otherName.text = x.cropNameBn;
      _grade = x.grade;
      _qty.text = '${x.availableKg}';
      _photos = [for (final u in x.photos) PickedPhoto.url(u)];
      _price.text = '${x.pricePerKg}';
      _when = _When.date;
      _date = x.availableFrom;
      _pickup = x.pickup;
    }
  }

  /// Edit mode: more than price / quantity / date changed? (A listing
  /// that is not active yet is always saved in full, which publishes it.)
  bool get _fullEdit {
    final x = widget.edit!;
    final (bn, _, _) = _cropNames;
    return x.status != ListingStatus.active ||
        _cropKey != x.cropKey ||
        bn != x.cropNameBn ||
        _grade != x.grade ||
        _photos.any((p) => p.file != null) ||
        !listEquals([for (final p in _photos) p.url], x.photos) ||
        !mapEquals(_pickup?.toMap(), x.pickup.toMap());
  }

  @override
  void dispose() {
    _otherName.dispose();
    _qty.dispose();
    _price.dispose();
    super.dispose();
  }

  String get _lang => Localizations.localeOf(context).languageCode;

  num? _num(TextEditingController c) =>
      num.tryParse(Fmt.latinDigits(c.text.trim()));

  DateTime get _availableFrom {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return switch (_when) {
      _When.today => today,
      _When.tomorrow => today.add(const Duration(days: 1)),
      _When.date => _date ?? today,
    };
  }

  (String bn, String en, String category) get _cropNames {
    if (_cropKey == CropCatalog.other) {
      final n = _otherName.text.trim();
      return (n, n, CropCategory.other.name);
    }
    final c =
        catalogCrop(ref.read(catalogProvider), _cropKey) ??
        CropCatalog.sellChips.first;
    return (c.bn, c.en, c.category.name);
  }

  // ---------------- navigation ----------------

  void _back() {
    if (_step > 1) {
      setState(() => _step--);
    } else {
      context.pop();
    }
  }

  void _nextFrom1() {
    final l = AppLocalizations.of(context);
    final q = _num(_qty);
    setState(() {
      _otherError =
          (_cropKey == CropCatalog.other && _otherName.text.trim().isEmpty)
          ? l.commonRequired
          : null;
      _qtyError = (q == null || q <= 0) ? l.errQtyInvalid : null;
      _photoError = _photos.isEmpty ? l.errPhotoRequired : null;
    });
    if (_otherError == null && _qtyError == null && _photoError == null) {
      setState(() => _step = 2);
    }
  }

  void _nextFrom2() {
    final l = AppLocalizations.of(context);
    final p = _num(_price);
    setState(() {
      _priceError = (p == null || p <= 0) ? l.errPriceInvalid : null;
      _error = (_pickup?.isComplete ?? false) ? null : l.commonRequired;
    });
    if (_priceError == null && _error == null) setState(() => _step = 3);
  }

  Future<void> _pickDate() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 180)),
      initialDate: _date ?? now,
    );
    FocusManager.instance.primaryFocus?.unfocus();
    if (d != null) {
      setState(() {
        _date = d;
        _when = _When.date;
      });
    }
  }

  Future<void> _pickPickup() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final loc = await context.push<UserLocation>(Routes.locationPicker);
    // Flutter gives focus back to the last field when the route pops.
    FocusManager.instance.primaryFocus?.unfocus();
    if (loc != null) {
      setState(() {
        _pickup = loc;
        _error = null;
      });
    }
  }

  Future<void> _publish() async {
    final l = AppLocalizations.of(context);
    final me = ref.read(currentUserProvider).value;
    if (me == null || _photos.isEmpty) return;
    setState(() {
      _publishing = true;
      _error = null;
    });
    try {
      final repo = ref.read(listingRepositoryProvider);
      final x = widget.edit;
      if (x != null) {
        // A buyer may have ordered since the edit started.
        if (await ref
            .read(tradeRepositoryProvider)
            .hasOpenOrder(me.uid, x.id)) {
          setState(() => _error = l.listingHasOrder);
          return;
        }
        if (!_fullEdit) {
          await repo.quickEdit(
            x,
            availableKg: _num(_qty)!,
            pricePerKg: _num(_price)!,
            availableFrom: _availableFrom,
          );
          if (!mounted) return;
          KsToast.show(context, l.listingUpdated);
          context.pop();
          return;
        }
      }
      final urls = <String>[];
      for (final p in _photos) {
        if (p.url != null) {
          urls.add(p.url!);
          continue;
        }
        final up = await ref
            .read(imageStorageProvider)
            .upload(p.file!, kind: ImageKind.listing, ownerUid: me.uid);
        urls.add(up.url);
      }
      final (bn, en, category) = _cropNames;
      final draft = ListingDraft(
        cropKey: _cropKey,
        cropNameBn: bn,
        cropNameEn: en,
        category: category,
        grade: _grade,
        quantityKg: _num(_qty)!,
        pricePerKg: _num(_price)!,
        availableFrom: _availableFrom,
        pickup: _pickup!,
      );
      if (x != null) {
        await repo.edit(x, draft, urls);
        if (!mounted) return;
        KsToast.show(context, l.listingUpdated);
        context.pop();
        return;
      }
      await repo.create(farmer: me, photoUrls: urls, draft: draft);
      if (!mounted) return;
      await showKsSuccessModal(
        context,
        title: l.listingSuccessTitle,
        body: l.listingSuccessBody,
        cta: l.listingSuccessCta,
        onCta: () => context.pushReplacement(Routes.farmerListings),
      );
    } on ImageUploadException {
      setState(() => _error = l.errorUpload);
    } catch (_) {
      setState(() => _error = l.errorGeneric);
    } finally {
      if (mounted) setState(() => _publishing = false);
    }
  }

  // ---------------- build ----------------

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return PopScope(
      canPop: _step == 1 && !_publishing,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !_publishing) _back();
      },
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(
          title: widget.edit == null ? l.sellTitle : l.editListingTitle,
          onBack: _back,
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.contentTop,
              AppSpacing.screen,
              AppSpacing.lg,
            ),
            children: [
              KsStepper(
                labels: [l.sellStep1, l.sellStep2, l.sellStep3],
                current: _step,
              ),
              const SizedBox(height: AppSpacing.block),
              ...switch (_step) {
                1 => _step1(l),
                2 => _step2(l),
                _ => _step3(l),
              },
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String t) =>
      Text(t, style: AppTypography.bodyMediumEmphasis.normal);

  Widget _err(String? e) => e == null
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Text(
            e,
            style: AppTypography.caption.withColor(AppColors.textError),
          ),
        );

  List<Widget> _step1(AppLocalizations l) {
    final chips = [
      for (final c in ref.watch(sellCropsProvider)) (c.key, c.name(_lang)),
      (CropCatalog.other, l.cropOther),
    ];
    return [
      _label(l.sellChooseCrop),
      const SizedBox(height: AppSpacing.block),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final (key, name) in chips)
            KsPill(
              label: name,
              selected: _cropKey == key,
              onTap: () => setState(() => _cropKey = key),
            ),
        ],
      ),
      if (_cropKey == CropCatalog.other) ...[
        const SizedBox(height: AppSpacing.block),
        KsTextField(
          label: l.fieldCrop,
          hint: l.sellOtherCropHint,
          controller: _otherName,
          errorText: _otherError,
        ),
      ],
      const SizedBox(height: AppSpacing.block),
      _label(l.sellGrade),
      const SizedBox(height: AppSpacing.block),
      Wrap(
        spacing: AppSpacing.sm,
        children: [
          for (final g in _grades)
            KsPill(
              label: l.gradeLabel(g),
              selected: _grade == g,
              onTap: () => setState(() => _grade = g),
            ),
        ],
      ),
      const SizedBox(height: AppSpacing.block),
      KsTextField(
        label: l.sellQuantity,
        hint: Fmt.digits(context, '500'),
        controller: _qty,
        suffixText: l.unitKg,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯.]')),
        ],
        errorText: _qtyError,
      ),
      const SizedBox(height: AppSpacing.block),
      KsPhotoPicker(
        label: l.sellAddPhoto,
        photos: _photos,
        onChanged: (p) => setState(() {
          _photos = p;
          _photoError = null;
        }),
      ),
      _err(_photoError),
      const SizedBox(
        height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
      ),
      KsButton(label: l.sellNext, onPressed: _nextFrom1),
    ];
  }

  List<Widget> _step2(AppLocalizations l) {
    final market = ref.watch(marketPriceProvider(_cropKey)).value;
    final geo = _pickup?.geo;
    return [
      KsTextField(
        label: l.sellPrice,
        hint: Fmt.digits(context, '38'),
        controller: _price,
        suffixText: l.sellPriceUnit,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯.]')),
        ],
        errorText: _priceError,
      ),
      if (market != null) ...[
        const SizedBox(height: AppSpacing.block),
        Text(
          l.sellMarketRange(
            Fmt.number(context, market.min),
            Fmt.number(context, market.max),
          ),
          style: AppTypography.bodySmallEmphasis.normal.withColor(
            AppColors.textSecondary,
          ),
        ),
      ],
      const SizedBox(height: AppSpacing.block),
      _label(l.sellAvailableFrom),
      const SizedBox(height: AppSpacing.block),
      Wrap(
        spacing: AppSpacing.sm,
        children: [
          KsPill(
            label: l.sellToday,
            selected: _when == _When.today,
            onTap: () => setState(() => _when = _When.today),
          ),
          KsPill(
            label: l.sellTomorrow,
            selected: _when == _When.tomorrow,
            onTap: () => setState(() => _when = _When.tomorrow),
          ),
          KsPill(
            label: _when == _When.date && _date != null
                ? Fmt.date(context, _date!)
                : l.sellPickDate,
            selected: _when == _When.date,
            onTap: _pickDate,
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.block),
      KsMapPreview(
        height: _mapHeight,
        point: geo == null ? null : LatLng(geo.latitude, geo.longitude),
      ),
      const SizedBox(height: AppSpacing.block),
      KsSelectField(
        label: l.sellPickup,
        placeholder: l.selectHint,
        value: _pickup == null ? null : _placeLine(_pickup!),
        onTap: _pickPickup,
        errorText: _error,
      ),
      const SizedBox(
        height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
      ),
      KsButton(label: l.sellNext, onPressed: _nextFrom2),
    ];
  }

  List<Widget> _step3(AppLocalizations l) {
    final (bn, en, _) = _cropNames;
    final crop = _lang == 'bn' ? bn : en;
    return [
      // Figma 20: Photo Gallery (tap or swipe, "১/৪" counter).
      KsPhotoGallery(
        height: _reviewImageHeight,
        photos: [for (final p in _photos) p.image()],
      ),
      const SizedBox(height: AppSpacing.block),
      KsInfoCard(
        rows: [
          (l.fieldCrop, l.cropWithGrade(crop, _grade)),
          (l.fieldQuantity, l.qtyKg(Fmt.number(context, _num(_qty)!))),
          (l.fieldPrice, l.priceLine(Fmt.number(context, _num(_price)!))),
          (l.fieldAvailability, Fmt.date(context, _availableFrom)),
          (l.fieldPickup, _placeLine(_pickup!)),
        ],
      ),
      if (_error != null) ...[
        const SizedBox(height: AppSpacing.sm),
        Text(
          _error!,
          style: AppTypography.caption.withColor(AppColors.textError),
        ),
      ],
      const SizedBox(
        height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
      ),
      Row(
        children: [
          Expanded(
            child: KsButton.outline(
              label: l.sellEdit,
              onPressed: _publishing ? null : () => setState(() => _step = 1),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: KsButton(
              label: widget.edit == null ? l.sellPublish : l.commonSave,
              loading: _publishing,
              onPressed: _publish,
            ),
          ),
        ],
      ),
    ];
  }

  String _placeLine(UserLocation loc) {
    final up = BdPlace.display(loc.upazila, _lang);
    return up.isNotEmpty ? up : BdPlace.display(loc.district, _lang);
  }
}

/// Edit Listing: loads the listing, then the Sell Crop steps prefilled.
class EditListingScreen extends ConsumerWidget {
  const EditListingScreen({super.key, required this.listingId});
  final String listingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final x = ref.watch(listingProvider(listingId)).value;
    if (x == null) {
      return Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(title: AppLocalizations.of(context).editListingTitle),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    // Keyed so a later live update does not reset the form being edited.
    return SellCropScreen(key: ValueKey(x.id), edit: x);
  }
}
