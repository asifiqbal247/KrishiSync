import 'package:material_ui/material_ui.dart';

import '../../core/l10n/formatters.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';

/// HF/Switch/Gallery (Figma 706:9759 …): up to 4 photos, swipe or tap to
/// see the next one, "১/৪" counter bottom-right (12 inset, 8×4 padding,
/// radius 4, rgba(31,31,31,.6), Medium 12 white). Square corners.
///
/// [height] null fills the parent (hero use inside KsHeroPhoto).
class KsPhotoGallery extends StatefulWidget {
  const KsPhotoGallery({super.key, required this.photos, this.height});

  /// One widget per photo (asset, file or network image, BoxFit.cover).
  final List<Widget> photos;
  final double? height;

  /// Figma counter template "১/৪": four photos at most.
  static const maxPhotos = 4;

  @override
  State<KsPhotoGallery> createState() => _KsPhotoGalleryState();
}

class _KsPhotoGalleryState extends State<KsPhotoGallery> {
  final _ctrl = PageController();
  int _i = 0;

  static const _inset = AppSpacing.md;
  static const _padH = AppSpacing.sm;
  static const _padV = AppSpacing.xs;
  static const _slide = Duration(milliseconds: 250);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _next() {
    final n = widget.photos.length;
    if (n < 2) return;
    final to = (_i + 1) % n;
    if (to == 0) {
      _ctrl.jumpToPage(0);
    } else {
      _ctrl.animateToPage(to, duration: _slide, curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final n = widget.photos.length;
    final gallery = Stack(
      fit: StackFit.expand,
      children: [
        if (n == 0)
          const ColoredBox(color: AppColors.bgMuted)
        else
          GestureDetector(
            onTap: _next,
            child: PageView.builder(
              controller: _ctrl,
              itemCount: n,
              onPageChanged: (i) => setState(() => _i = i),
              itemBuilder: (_, i) => widget.photos[i],
            ),
          ),
        if (n > 1)
          Positioned(
            right: _inset,
            bottom: _inset,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: _padH,
                  vertical: _padV,
                ),
                decoration: BoxDecoration(
                  color: AppColors.galleryBadge,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  Fmt.digits(context, '${_i + 1}/$n'),
                  style: AppTypography.caption.normal.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textOnBrand,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.photo),
      child: widget.height == null
          ? gallery
          : SizedBox(height: widget.height, child: gallery),
    );
  }
}
