import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../l10n/app_localizations.dart';
import 'ks_list_item.dart';
import 'app_icon.dart';

/// Ask camera or gallery, then return the picked file (or null).
Future<File?> pickPhoto(BuildContext context) async {
  final source = await askPhotoSource(context);
  if (source == null) return null;
  final x = await ImagePicker().pickImage(source: source, imageQuality: 90);
  return x == null ? null : File(x.path);
}

/// Camera or gallery sheet (photos and chat videos).
Future<ImageSource?> askPhotoSource(BuildContext context) {
  final l = AppLocalizations.of(context);
  return showModalBottomSheet<ImageSource>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screen),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            KsListItem(
              thumb: const ColoredBox(
                color: AppColors.bgSubtle,
                child: Center(
                    child: AppIcon(AppIcons.camera, color: AppColors.iconBrand)),
              ),
              title: l.photoCamera,
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            const SizedBox(height: AppSpacing.md),
            KsListItem(
              thumb: const ColoredBox(
                color: AppColors.bgSubtle,
                child: Center(
                    child: AppIcon(AppIcons.upload, color: AppColors.iconBrand)),
              ),
              title: l.photoGallery,
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    ),
  );
}
