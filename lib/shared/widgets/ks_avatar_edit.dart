import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../features/auth/data/user_repository.dart';
import '../../l10n/app_localizations.dart';
import '../services/image_storage_service.dart';
import 'app_icon.dart';
import 'ks_toast.dart';
import 'photo_source_sheet.dart';

/// Profile picture with a small camera badge (bottom-right). Tapping the
/// picture opens camera / gallery and saves the new photo at once.
/// (No Figma for this; the badge uses the brand colour like other HF bits.)
class KsAvatarEdit extends ConsumerStatefulWidget {
  const KsAvatarEdit({super.key, required this.uid, required this.child});

  final String uid;

  /// The current picture (network image or role fallback).
  final Widget child;

  @override
  ConsumerState<KsAvatarEdit> createState() => _KsAvatarEditState();
}

class _KsAvatarEditState extends ConsumerState<KsAvatarEdit> {
  static const _badge = 18.0;
  static const _icon = 11.0;
  static const _inset = 2.0;
  bool _busy = false;

  Future<void> _change() async {
    final l = AppLocalizations.of(context);
    final f = await pickPhoto(context);
    if (f == null || !mounted) return;
    setState(() => _busy = true);
    try {
      final up = await ref
          .read(imageStorageProvider)
          .upload(f, kind: ImageKind.profile, ownerUid: widget.uid);
      await ref.read(userRepositoryProvider).setPhoto(widget.uid, up.url);
      if (mounted) KsToast.show(context, l.photoUpdated);
    } on ImageUploadException {
      if (mounted) KsToast.show(context, l.errorUpload);
    } catch (_) {
      if (mounted) KsToast.show(context, l.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Semantics(
      button: true,
      label: l.changePhoto,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _busy ? null : _change,
        child: Stack(
          fit: StackFit.expand,
          children: [
            widget.child,
            if (_busy)
              const ColoredBox(
                color: AppColors.galleryBadge,
                child: Center(
                  child: SizedBox.square(
                    dimension: _badge,
                    child: CircularProgressIndicator(
                      strokeWidth: _inset,
                      color: AppColors.textOnBrand,
                    ),
                  ),
                ),
              ),
            Positioned(
              right: _inset,
              bottom: _inset,
              child: Container(
                width: _badge,
                height: _badge,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.bgBrand,
                  shape: BoxShape.circle,
                ),
                child: const AppIcon(
                  AppIcons.camera,
                  size: _icon,
                  color: AppColors.textOnBrand,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
