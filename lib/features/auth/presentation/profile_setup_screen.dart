import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/services/bd_location_service.dart';
import '../../../shared/services/image_storage_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_upload_box.dart';
import '../../../shared/widgets/photo_source_sheet.dart';
import '../data/auth_repository.dart';
import '../data/user_repository.dart';
import '../domain/app_user.dart';

/// 08 Profile Setup (Figma 292:371).
class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key, this.editing = false});

  /// Opened from the profile tab to edit name, photo and address.
  final bool editing;

  @override
  ConsumerState<ProfileSetupScreen> createState() =>
      _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _name = TextEditingController();
  final _nid = TextEditingController();
  File? _photo;
  UserLocation? _location;
  bool _saving = false;
  String? _nameError;
  String? _locationError;
  String? _error;

  @override
  void initState() {
    super.initState();
    final me = ref.read(currentUserProvider).value;
    if (me != null) {
      _name.text = me.name;
      _nid.text = me.nidNumber ?? '';
      if (me.location.isComplete) _location = me.location;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _nid.dispose();
    super.dispose();
  }

  String get _lang => Localizations.localeOf(context).languageCode;

  Future<void> _pickLocation() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final loc = await context.push<UserLocation>(Routes.locationPicker);
    // Flutter gives focus back to the last field when the route pops.
    FocusManager.instance.primaryFocus?.unfocus();
    if (loc != null) {
      setState(() {
        _location = loc;
        _locationError = null;
      });
    }
  }

  Future<void> _pickPhoto() async {
    final f = await pickPhoto(context);
    if (f != null) setState(() => _photo = f);
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    setState(() {
      _nameError = _name.text.trim().isEmpty ? l.commonRequired : null;
      _locationError =
          (_location?.isComplete ?? false) ? null : l.commonRequired;
      _error = null;
    });
    if (_nameError != null || _locationError != null) return;

    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) return;
    setState(() => _saving = true);
    try {
      String? photoUrl;
      if (_photo != null) {
        final up = await ref
            .read(imageStorageProvider)
            .upload(_photo!, kind: ImageKind.profile, ownerUid: uid);
        photoUrl = up.url;
      }
      await ref.read(userRepositoryProvider).saveProfile(
            uid,
            name: _name.text,
            location: _location!,
            photoUrl: photoUrl,
            // Verification has its own screen (69/139) when editing.
            nidNumber: widget.editing ? null : _nid.text,
          );
      if (widget.editing && mounted) {
        KsToast.show(context, l.profileSaved);
        context.pop();
      }
      // First setup: router moves to the role home once complete.
    } on ImageUploadException {
      setState(() => _error = l.errorUpload);
    } catch (_) {
      setState(() => _error = l.errorGeneric);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final loc = _location;
    final ladder = loc == null
        ? null
        : [
            BdPlace.display(loc.district, _lang),
            BdPlace.display(loc.upazila, _lang),
            BdPlace.display(loc.union, _lang),
          ].where((s) => s.isNotEmpty).join(' › ');

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(
        title: widget.editing ? l.editProfileTitle : l.profileSetupTitle,
        onBack: widget.editing
            ? null
            : () => ref.read(authRepositoryProvider).signOut(),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
              AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
          children: [
            KsUploadBox(
              label: l.profileAddPhoto,
              file: _photo,
              networkUrl: _photo == null
                  ? ref.read(currentUserProvider).value?.photoUrl
                  : null,
              onTap: _pickPhoto,
            ),
            const SizedBox(height: AppSpacing.block),
            KsTextField(
              label: l.profileFullName,
              hint: l.profileFullNameHint,
              controller: _name,
              textInputAction: TextInputAction.next,
              errorText: _nameError,
            ),
            const SizedBox(height: AppSpacing.block),
            KsSelectField(
              label: l.profileDivision,
              placeholder: l.selectHint,
              value: loc == null ? null : BdPlace.display(loc.division, _lang),
              onTap: _pickLocation,
              errorText: _locationError,
            ),
            const SizedBox(height: AppSpacing.block),
            KsSelectField(
              label: l.profileDistrictUpazilaUnion,
              placeholder: l.selectHint,
              value: ladder,
              onTap: _pickLocation,
            ),
            const SizedBox(height: AppSpacing.block),
            KsSelectField(
              label: l.profileVillage,
              placeholder: l.profileVillageHint,
              value: loc?.village,
              onTap: _pickLocation,
            ),
            if (!widget.editing) ...[
              const SizedBox(height: AppSpacing.block),
              KsTextField(
                label: l.profileNid,
                hint: l.profileNidHint,
                controller: _nid,
                keyboardType: TextInputType.number,
                maxLength: 17,
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(_error!,
                  style: AppTypography.caption.withColor(AppColors.textError)),
            ],
            const SizedBox(
                height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
            KsButton(
              label: l.profileDone,
              loading: _saving,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
