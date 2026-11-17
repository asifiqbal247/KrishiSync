import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/services/bd_location_service.dart';
import '../../../shared/widgets/app_icon.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_search_bar.dart';
import '../data/user_repository.dart';
import '../domain/app_user.dart';

/// 09 Division → 10 District → 11 Upazila → 12 Union, Village & Map Pin.
/// Figma 292:3355, 292:3374, 292:3386, 292:3405.
/// Pops with a [UserLocation].
class LocationPickerScreen extends ConsumerStatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  ConsumerState<LocationPickerScreen> createState() =>
      _LocationPickerScreenState();
}

class _LocationPickerScreenState extends ConsumerState<LocationPickerScreen> {
  static const _total = 4;

  int _step = 1;
  BdPlace? _division;
  BdPlace? _district;
  BdPlace? _upazila;
  BdPlace? _union;
  LatLng? _pin;
  AddressTag _tag = AddressTag.home;
  bool _gpsBusy = false;
  String? _gpsError;
  String? _unionError;

  final _search = TextEditingController();
  final _village = TextEditingController();
  final _landmark = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    _village.dispose();
    _landmark.dispose();
    super.dispose();
  }

  String get _lang => Localizations.localeOf(context).languageCode;

  void _go(int step) => setState(() {
    _step = step;
    _search.clear();
  });

  void _back() {
    if (_step > 1) {
      _go(_step - 1);
    } else {
      context.pop();
    }
  }

  void _pickDivision(BdPlace d) {
    _division = d;
    _district = _upazila = _union = null;
    _go(2);
  }

  void _pickDistrict(BdPlace d) {
    _district = d;
    _upazila = _union = null;
    _go(3);
  }

  void _pickUpazila(BdPlace u) {
    _upazila = u;
    _union = null;
    _pin = (u.lat != null && u.lng != null) ? LatLng(u.lat!, u.lng!) : null;
    _go(4);
  }

  Future<void> _useGps(BdLocations data) async {
    setState(() {
      _gpsBusy = true;
      _gpsError = null;
    });
    final l = AppLocalizations.of(context);
    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever ||
          !await Geolocator.isLocationServiceEnabled()) {
        throw Exception('no-permission');
      }
      final pos = await Geolocator.getCurrentPosition(
        // Plain Android GPS: no Google "Location Accuracy" pop-up.
        locationSettings: AndroidSettings(
          timeLimit: const Duration(seconds: 20),
          forceLocationManager: true,
        ),
      );
      final path = data.nearest(pos.latitude, pos.longitude);
      if (path == null) throw Exception('not-found');
      setState(() {
        _division = path.division;
        _district = path.district;
        _upazila = path.upazila;
        _union = null;
        _pin = LatLng(pos.latitude, pos.longitude);
        _step = 4;
      });
    } catch (_) {
      setState(() => _gpsError = l.locGpsFailed);
    } finally {
      if (mounted) setState(() => _gpsBusy = false);
    }
  }

  void _useSaved(SavedAddress a) => context.pop(a.location);

  Future<void> _pickUnion() async {
    final up = _upazila;
    if (up == null) return;
    final chosen = await showModalBottomSheet<BdPlace>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _UnionSheet(unions: up.children, lang: _lang),
    );
    if (chosen != null) {
      setState(() {
        _union = chosen;
        _unionError = null;
        if (chosen.lat != null && chosen.lng != null) {
          _pin = LatLng(chosen.lat!, chosen.lng!);
        }
      });
    }
  }

  Future<void> _confirm(AppUser? me) async {
    final l = AppLocalizations.of(context);
    if (_union == null && (_upazila?.children.isNotEmpty ?? false)) {
      setState(() => _unionError = l.commonRequired);
      return;
    }
    final loc = UserLocation(
      divisionId: _division!.id,
      division: _division!.stored,
      districtId: _district!.id,
      district: _district!.stored,
      upazilaId: _upazila!.id,
      upazila: _upazila!.stored,
      unionId: _union?.id,
      union: _union?.stored,
      village: _village.text.trim().isEmpty ? null : _village.text.trim(),
      landmark: _landmark.text.trim().isEmpty ? null : _landmark.text.trim(),
      geo: _pin == null ? null : GeoPoint(_pin!.latitude, _pin!.longitude),
    );
    // Return the address first. Saving the shortcut updates users/{uid},
    // which refreshes the router; doing that before pop() loses the result.
    final repo = ref.read(userRepositoryProvider);
    context.pop(loc);
    if (me != null) {
      // Optional shortcut ("বাড়ি", "খামার"…); failure must not block the flow.
      repo
          .saveAddress(
            me.uid,
            SavedAddress(tag: _tag, location: loc),
            me.savedAddresses,
          )
          .catchError((_) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final data = ref.watch(bdLocationsProvider);
    final me = ref.watch(currentUserProvider).value;
    final title = switch (_step) {
      1 => l.locTitleDivision,
      2 => l.locTitleDistrict,
      3 => l.locTitleUpazila,
      _ => l.locTitleVillage,
    };

    return PopScope(
      canPop: _step == 1,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(title: title, onBack: _back),
        body: data.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l.errorGeneric)),
          data: (d) => SafeArea(
            top: false,
            child: switch (_step) {
              1 => _divisionStep(l, d, me),
              2 => _listStep(
                l,
                step: 2,
                level: l.locLevelDistrict,
                searchHint: l.locSearchDistrict,
                items: _division?.children ?? const [],
                count: (p) => l.locUpazilaCount(
                  Fmt.digits(context, '${p.children.length}'),
                ),
                onPick: _pickDistrict,
              ),
              3 => _listStep(
                l,
                step: 3,
                level: l.locLevelUpazila,
                searchHint: l.locSearchUpazila,
                items: _district?.children ?? const [],
                count: null,
                onPick: _pickUpazila,
              ),
              _ => _villageStep(l, me),
            },
          ),
        ),
      ),
    );
  }

  // ---------- shared bits ----------

  Widget _stepLabel(AppLocalizations l, int step, String level) => Text(
    l.locStep(
      Fmt.digits(context, '$step'),
      Fmt.digits(context, '$_total'),
      level,
    ),
    style: AppTypography.caption.normal.copyWith(
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
    ),
  );

  Widget _breadcrumb(AppLocalizations l) {
    final crumbs = <(String, VoidCallback?)>[];
    if (_division != null) {
      final isLast = _step == 2;
      crumbs.add((
        isLast
            ? l.locDivisionPill(_division!.name(_lang))
            : _division!.name(_lang),
        isLast ? null : () => _go(2),
      ));
    }
    if (_district != null && _step >= 3) {
      crumbs.add((_district!.name(_lang), _step == 3 ? null : () => _go(3)));
    }
    if (_upazila != null && _step >= 4) {
      crumbs.add((_upazila!.name(_lang), null));
    }
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.label,
      children: [
        for (var i = 0; i < crumbs.length; i++)
          KsPill(
            label: crumbs[i].$1,
            selected: i == crumbs.length - 1,
            onTap: crumbs[i].$2,
          ),
      ],
    );
  }

  static const _contentPadding = EdgeInsets.fromLTRB(
    AppSpacing.screen,
    AppSpacing.contentTop,
    AppSpacing.screen,
    AppSpacing.s2xl,
  );

  // ---------- 09 Division ----------

  Widget _divisionStep(AppLocalizations l, BdLocations d, AppUser? me) {
    final q = _search.text;
    final searching = q.trim().isNotEmpty;
    final saved = me?.savedAddresses ?? const <SavedAddress>[];

    // Global search across district / upazila names.
    final hits = <(BdPlace, BdPlace, BdPlace?)>[];
    if (searching) {
      for (final dv in d.divisions) {
        for (final ds in dv.children) {
          if (ds.matches(q)) hits.add((dv, ds, null));
          for (final up in ds.children) {
            if (up.matches(q)) hits.add((dv, ds, up));
          }
        }
      }
    }

    return ListView(
      padding: _contentPadding,
      children: [
        KsListItem(
          highlighted: true,
          thumb: Image.asset(AppImages.locationThumb, fit: BoxFit.cover),
          title: _gpsBusy ? l.locGpsLocating : l.locUseGps,
          subtitle:
              _gpsError ??
              (me?.location.isComplete == true
                  ? _placeLine(me!.location)
                  : null),
          trailingText: l.locGps,
          onTap: _gpsBusy ? null : () => _useGps(d),
        ),
        if (saved.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: AppSizes.sectionHeader,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(l.locRecent, style: AppTypography.labelButton.normal),
            ),
          ),
          for (final a in saved) ...[
            const SizedBox(height: AppSpacing.x10),
            KsListItem(
              thumb: Image.asset(AppImages.locationThumb, fit: BoxFit.cover),
              title: _tagLabel(l, a.tag),
              subtitle: [
                _placeLine(a.location),
                if (a.location.geo != null) l.locMapPinSaved,
              ].join(' · '),
              trailingText: _tagLabel(l, a.tag),
              onTap: () => _useSaved(a),
            ),
          ],
        ],
        const SizedBox(height: AppSpacing.md),
        KsSearchBar(
          hint: l.locSearchAll,
          controller: _search,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.md),
        _stepLabel(l, 1, l.locLevelDivision),
        if (searching) ...[
          if (hits.isEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              l.locNoResults,
              style: AppTypography.bodyMedium.withColor(
                AppColors.textSecondary,
              ),
            ),
          ],
          for (final (dv, ds, up) in hits.take(40)) ...[
            const SizedBox(height: AppSpacing.md),
            KsListItem(
              title: up?.name(_lang) ?? ds.name(_lang),
              subtitle: up == null
                  ? dv.name(_lang)
                  : '${ds.name(_lang)}, ${dv.name(_lang)}',
              onTap: () {
                _division = dv;
                if (up == null) {
                  _pickDistrict(ds);
                } else {
                  _district = ds;
                  _pickUpazila(up);
                }
              },
            ),
          ],
        ] else
          for (final dv in d.divisions) ...[
            const SizedBox(height: AppSpacing.md),
            KsListItem(
              title: dv.name(_lang),
              trailingText: l.locDistrictCount(
                Fmt.digits(context, '${dv.children.length}'),
              ),
              onTap: () => _pickDivision(dv),
            ),
          ],
      ],
    );
  }

  // ---------- 10 District / 11 Upazila ----------

  Widget _listStep(
    AppLocalizations l, {
    required int step,
    required String level,
    required String searchHint,
    required List<BdPlace> items,
    required String Function(BdPlace)? count,
    required void Function(BdPlace) onPick,
  }) {
    final shown = items.where((p) => p.matches(_search.text)).toList();
    return ListView(
      padding: _contentPadding,
      children: [
        _breadcrumb(l),
        const SizedBox(height: AppSpacing.md),
        KsSearchBar(
          hint: searchHint,
          controller: _search,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.md),
        _stepLabel(l, step, level),
        if (shown.isEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            l.locNoResults,
            style: AppTypography.bodyMedium.withColor(AppColors.textSecondary),
          ),
        ],
        for (final p in shown) ...[
          const SizedBox(height: AppSpacing.md),
          KsListItem(
            title: p.name(_lang),
            trailingText: count?.call(p),
            onTap: () => onPick(p),
          ),
        ],
      ],
    );
  }

  // ---------- 12 Union, Village & Map Pin ----------

  static const _mapHeight = 160.0; // Figma 12: 328×160, square
  static const _mapZoom = 13.0;
  static const _pinSize = 28.0;

  Widget _villageStep(AppLocalizations l, AppUser? me) {
    final tags = [
      (AddressTag.home, l.locTagHome),
      (AddressTag.farm, l.locTagFarm),
      (AddressTag.store, l.locTagStore),
      (AddressTag.other, l.locTagOther),
    ];
    return ListView(
      padding: _contentPadding,
      children: [
        _breadcrumb(l),
        const SizedBox(height: AppSpacing.md),
        _stepLabel(l, 4, l.locLevelUnionVillage),
        const SizedBox(height: AppSpacing.md),
        KsSelectField(
          label: l.locUnionLabel,
          placeholder: l.locUnionHint,
          value: _union?.name(_lang),
          onTap: _pickUnion,
          errorText: _unionError,
          showChevron: false,
        ),
        const SizedBox(height: AppSpacing.md),
        KsTextField(
          label: l.locVillageLabel,
          hint: l.locVillageHint,
          controller: _village,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.md),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.photo),
          child: SizedBox(
            height: _mapHeight,
            child: _pin == null
                ? Image.asset(AppImages.mapStrip, fit: BoxFit.cover)
                : FlutterMap(
                    options: MapOptions(
                      initialCenter: _pin!,
                      initialZoom: _mapZoom,
                      onTap: (_, p) => setState(() => _pin = p),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.asif.krishisync',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _pin!,
                            width: _pinSize,
                            height: _pinSize,
                            alignment: Alignment.topCenter,
                            child: const AppIcon(
                              AppIcons.location,
                              size: _pinSize,
                              color: AppColors.iconBrand,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        KsTextField(
          label: l.locLandmarkLabel,
          hint: l.locLandmarkHint,
          controller: _landmark,
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.x10,
          ),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.locWhyTitle, style: AppTypography.bodySmallStrong.normal),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l.locWhyBody,
                style: AppTypography.caption.normal.withColor(
                  AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (me != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(l.locSaveAs, style: AppTypography.bodyMediumEmphasis.normal),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final (tag, label) in tags) ...[
                  if (tag != AddressTag.home)
                    const SizedBox(width: AppSpacing.sm),
                  KsPill(
                    label: label,
                    selected: _tag == tag,
                    onTap: () => setState(() => _tag = tag),
                  ),
                ],
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md + AppSpacing.xs + AppSpacing.md),
        KsButton(label: l.locConfirm, onPressed: () => _confirm(me)),
      ],
    );
  }

  String _placeLine(UserLocation loc) => [
    BdPlace.display(loc.upazila, _lang),
    BdPlace.display(loc.district, _lang),
  ].where((s) => s.isNotEmpty).join(', ');

  String _tagLabel(AppLocalizations l, AddressTag t) => switch (t) {
    AddressTag.home => l.locTagHome,
    AddressTag.farm => l.locTagFarm,
    AddressTag.store => l.locTagStore,
    AddressTag.other => l.locTagOther,
  };
}

/// Union list shown from the "ইউনিয়ন / পৌরসভা" field.
class _UnionSheet extends StatefulWidget {
  const _UnionSheet({required this.unions, required this.lang});
  final List<BdPlace> unions;
  final String lang;

  @override
  State<_UnionSheet> createState() => _UnionSheetState();
}

class _UnionSheetState extends State<_UnionSheet> {
  final _q = TextEditingController();

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final shown = widget.unions.where((u) => u.matches(_q.text)).toList();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (_, scroll) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.lg,
          AppSpacing.screen,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.locUnionLabel, style: AppTypography.h3.normal),
            const SizedBox(height: AppSpacing.md),
            KsSearchBar(
              hint: l.commonSearch,
              controller: _q,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: ListView.separated(
                controller: scroll,
                padding: const EdgeInsets.only(bottom: AppSpacing.s2xl),
                itemCount: shown.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (_, i) => KsListItem(
                  title: shown[i].name(widget.lang),
                  onTap: () => Navigator.pop(context, shown[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
