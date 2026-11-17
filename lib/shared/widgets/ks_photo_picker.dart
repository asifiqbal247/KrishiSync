import 'dart:io';

import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../l10n/app_localizations.dart';
import 'app_icon.dart';
import 'ks_net_image.dart';
import 'ks_photo_gallery.dart';
import 'ks_upload_box.dart';
import 'photo_source_sheet.dart';

/// A photo that is either already uploaded ([url]) or just picked ([file]).
class PickedPhoto {
  const PickedPhoto.url(String this.url) : file = null;
  const PickedPhoto.file(File this.file) : url = null;
  final String? url;
  final File? file;

  Widget image() => file != null
      ? Image.file(file!, fit: BoxFit.cover)
      : KsNetImage(url: url);
}

/// Up to [KsPhotoGallery.maxPhotos] crop photos: picked thumbnails (64,
/// radius 8, × to remove) above the HF upload box, which adds one more.
class KsPhotoPicker extends StatelessWidget {
  const KsPhotoPicker({
    super.key,
    required this.photos,
    required this.onChanged,
    required this.label,
  });

  final List<PickedPhoto> photos;
  final ValueChanged<List<PickedPhoto>> onChanged;
  final String label;

  static const _thumb = 64.0;
  static const _x = 20.0;
  static const _xIcon = 12.0;

  Future<void> _add(BuildContext context) async {
    final f = await pickPhoto(context);
    if (f != null) onChanged([...photos, PickedPhoto.file(f)]);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (photos.isNotEmpty) ...[
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final (i, p) in photos.indexed)
                SizedBox.square(
                  dimension: _thumb,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: p.image(),
                      ),
                      Positioned(
                        top: AppSpacing.xs,
                        right: AppSpacing.xs,
                        child: Semantics(
                          button: true,
                          label: l.removePhoto,
                          child: GestureDetector(
                            onTap: () => onChanged([...photos]..removeAt(i)),
                            child: Container(
                              width: _x,
                              height: _x,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: AppColors.galleryBadge,
                                shape: BoxShape.circle,
                              ),
                              child: const AppIcon(
                                AppIcons.close,
                                size: _xIcon,
                                color: AppColors.textOnBrand,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (photos.length < KsPhotoGallery.maxPhotos)
          KsUploadBox(
            label: photos.isEmpty ? label : l.addMorePhotos,
            onTap: () => _add(context),
          ),
      ],
    );
  }
}
