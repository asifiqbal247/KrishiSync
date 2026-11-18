import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/services/bd_location_service.dart';
import '../../../shared/services/image_storage_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../../../shared/widgets/ks_upload_box.dart';
import '../../../shared/widgets/photo_source_sheet.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../data/transport_repository.dart';
import '../domain/delivery.dart';
import 'transport_common.dart';

/// 194 Vehicle & Capacity (Figma 292:1935). Shown once after a transporter
/// finishes the profile, and again from the profile tab to edit.
class VehicleScreen extends ConsumerStatefulWidget {
  const VehicleScreen({super.key});

  @override
  ConsumerState<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends ConsumerState<VehicleScreen> {
  final _plate = TextEditingController();
  final _cap = TextEditingController();
  File? _photo;
  String? _type;
  UserLocation? _base;
  String? _routeTo;
  String? _typeErr, _plateErr, _capErr;
  bool _busy = false;
  bool _filled = false;

  @override
  void dispose() {
    _plate.dispose();
    _cap.dispose();
    super.dispose();
  }

  /// Prefill from the saved vehicle (edit) or the profile location.
  void _prefill(AppUser me) {
    if (_filled) return;
    _filled = true;
    final v = me.vehicle;
    _base = v?.base ?? me.location;
    if (v == null) return;
    _type = v.type;
    _plate.text = v.plateNo;
    _cap.text = Fmt.number(
      context,
      v.capacityKg / 1000,
      decimals: v.capacityKg % 1000 == 0 ? 0 : 1,
    );
    _routeTo = v.routeTo;
  }

  Future<void> _pickType() async {
    final l = AppLocalizations.of(context);
    final t = await showKsOptionsSheet<String>(
      context,
      title: l.vehicleType,
      options: [for (final k in VehicleTypes.all) (k, vehicleTypeLabel(l, k))],
    );
    if (t != null) setState(() => _type = t);
  }

  Future<void> _pickBase() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final loc = await context.push<UserLocation>(Routes.locationPicker);
    FocusManager.instance.primaryFocus?.unfocus();
    if (loc != null) setState(() => _base = loc);
  }

  Future<void> _pickRoute(String lang) async {
    final l = AppLocalizations.of(context);
    final data = await ref.read(bdLocationsProvider.future);
    if (!mounted) return;
    final districts = [for (final dv in data.divisions) ...dv.children]
      ..sort((a, b) => a.name(lang).compareTo(b.name(lang)));
    final picked = await showKsOptionsSheet<BdPlace>(
      context,
      title: l.preferredRoute,
      searchHint: l.commonSearch,
      options: [for (final d in districts) (d, d.name(lang))],
    );
    if (picked != null) setState(() => _routeTo = picked.stored);
  }

  Future<void> _save(AppUser me) async {
    final l = AppLocalizations.of(context);
    final tons = num.tryParse(Fmt.latinDigits(_cap.text.trim()));
    setState(() {
      _typeErr = _type == null ? l.commonRequired : null;
      _plateErr = _plate.text.trim().isEmpty ? l.commonRequired : null;
      _capErr = (tons == null || tons <= 0) ? l.commonRequired : null;
    });
    if (_typeErr != null || _plateErr != null || _capErr != null) return;
    setState(() => _busy = true);
    try {
      var photoUrl = me.vehicle?.photoUrl;
      if (_photo != null) {
        photoUrl =
            (await ref
                    .read(imageStorageProvider)
                    .upload(_photo!, kind: ImageKind.profile, ownerUid: me.uid))
                .url;
      }
      final first = me.vehicle == null;
      await ref
          .read(transportRepositoryProvider)
          .saveVehicle(
            me.uid,
            Vehicle(
              type: _type!,
              plateNo: _plate.text.trim(),
              capacityKg: (tons! * 1000).round(),
              photoUrl: photoUrl,
              base: _base,
              routeTo: _routeTo,
            ),
          );
      if (!mounted) return;
      if (first) {
        // 211 Success (Transporter); the router then opens the home.
        await showKsSuccessModal(
          context,
          title: l.successTitle,
          body: l.successBody,
          cta: l.okBtn,
          onCta: () => context.go(Routes.transporterHome),
        );
      } else {
        KsToast.show(context, l.successTitle);
        context.pop();
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
    if (me == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    _prefill(me);
    final baseText = _base == null ? null : placeFull(context, _base!);
    final from = _base == null ? '' : districtOf(context, _base!);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.vehicleTitle, showBack: me.vehicle != null),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.contentTop,
          AppSpacing.screen,
          AppSpacing.lg,
        ),
        children: [
          KsUploadBox(
            label: l.truckPhoto,
            file: _photo,
            networkUrl: _photo == null ? me.vehicle?.photoUrl : null,
            // Figma 194: 175 high, with or without a photo.
            height: KsUploadBox.truckHeight,
            onTap: () async {
              final f = await pickPhoto(context);
              if (f != null) setState(() => _photo = f);
            },
          ),
          const SizedBox(height: AppSpacing.block),
          KsSelectField(
            label: l.vehicleType,
            placeholder: l.selectHint,
            value: _type == null ? null : vehicleTypeLabel(l, _type!),
            errorText: _typeErr,
            onTap: _pickType,
          ),
          const SizedBox(height: AppSpacing.block),
          KsTextField(
            label: l.regNo,
            hint: l.regHint,
            controller: _plate,
            errorText: _plateErr,
          ),
          const SizedBox(height: AppSpacing.block),
          KsSelectField(
            label: l.baseLocation,
            placeholder: l.selectHint,
            value: baseText,
            onTap: _pickBase,
          ),
          const SizedBox(height: AppSpacing.block),
          KsTextField(
            label: l.maxCapacity,
            hint: Fmt.digits(context, '5'),
            controller: _cap,
            suffixText: l.tonUnit,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯.]')),
            ],
            errorText: _capErr,
          ),
          const SizedBox(height: AppSpacing.block),
          KsSelectField(
            label: l.preferredRoute,
            placeholder: l.selectHint,
            value: _routeTo == null
                ? null
                : '$from – ${BdPlace.display(_routeTo, lang)}',
            onTap: () => _pickRoute(lang),
          ),
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          KsButton(
            label: l.commonSave,
            loading: _busy,
            onPressed: () => _save(me),
          ),
        ],
      ),
    );
  }
}
