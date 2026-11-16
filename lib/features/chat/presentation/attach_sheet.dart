import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/photo_source_sheet.dart';

/// What the person picked in the attach sheet, ready to upload.
/// [kind] is image | video | doc; [name] is the document's file name.
typedef PickedFile = ({File file, String kind, String? name});

/// Longest chat video (same cap as voice messages).
const maxVideo = Duration(seconds: 60);

/// 216 Chat – Attach File sheet (Figma 412:6115): photo, video, document.
/// Returns the picked file, or null when the person backs out.
Future<PickedFile?> pickAttachment(BuildContext context) async {
  final l = AppLocalizations.of(context);
  final kind = await showModalBottomSheet<String>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.xl,
          AppSpacing.screen,
          AppSpacing.s2xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.attachTitle, style: AppTypography.headingBold20.normal),
            for (final (k, img, t, s) in [
              ('image', AppUi.attachImage, l.attachPhoto, l.attachPhotoSub),
              ('video', AppUi.attachVideo, l.attachVideo, l.attachVideoSub),
              ('doc', AppUi.attachDoc, l.attachDoc, l.attachDocSub),
            ]) ...[
              const SizedBox(height: AppSpacing.block),
              _Option(
                image: img,
                title: t,
                subtitle: s,
                onTap: () => Navigator.pop(ctx, k),
              ),
            ],
          ],
        ),
      ),
    ),
  );
  if (kind == null || !context.mounted) return null;

  switch (kind) {
    case 'image':
      final f = await pickPhoto(context);
      return f == null ? null : (file: f, kind: 'image', name: null);
    case 'video':
      final source = await askPhotoSource(context);
      if (source == null) return null;
      final x = await ImagePicker().pickVideo(
        source: source,
        maxDuration: maxVideo,
      );
      return x == null ? null : (file: File(x.path), kind: 'video', name: null);
    default:
      final p = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
      );
      final path = p?.path;
      if (p == null || path == null) return null;
      // A photo of a receipt is sent like any photo; PDFs as documents.
      final isPdf = path.toLowerCase().endsWith('.pdf');
      return (
        file: File(path),
        kind: isPdf ? 'doc' : 'image',
        name: isPdf ? p.name : null,
      );
  }
}

/// One option row: 1px card border, radius 12, padding 16, gap 14,
/// 44px icon tile, SemiBold 16 title, Regular 13 secondary subtitle.
class _Option extends StatelessWidget {
  const _Option({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String image;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  static const _icon = 44.0;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.lg);
    return Material(
      color: AppColors.bgPage,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: radius,
                child: Image.asset(image, width: _icon, height: _icon),
              ),
              const SizedBox(width: AppSpacing.block),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.labelButton.normal),
                    const SizedBox(height: AppSpacing.s2xs),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.normal.withColor(
                        AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
