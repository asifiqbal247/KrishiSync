import 'dart:io';

import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';

/// HF/Switch/*-upload (e.g. 525:9623): subtle green fill, 1.2px dashed brand
/// border, radius 14, 32px camera image + Medium 13 secondary label.
/// "On=হ্যাঁ" (a photo is picked or saved): same box with a solid border
/// and "✓ ছবি যোগ হয়েছে · আবার তুলতে চাপুন" ([doneLabel]); no preview.
class KsUploadBox extends StatelessWidget {
  const KsUploadBox({
    super.key,
    required this.label,
    required this.onTap,
    this.file,
    this.networkUrl,
    this.height = defaultHeight,
    this.uploading = false,
    this.cameraSize = _camera,
    this.doneLabel,
  });

  static const defaultHeight = 61.4;

  /// Figma box heights (360×800 frame; the box fills the free space).
  static const deliveryHeight = 229.0; // 110, 114, 139
  static const reportHeight = 227.0; // 203
  static const podHeight = 260.0; // 167, 172
  static const truckHeight = 175.0; // 194
  static const pickupHeight = 167.0; // 163
  static const pickupPartialHeight = 157.0; // 164

  static const _camera = 32.0;
  static const cameraSmall = 28.0; // 163, 164
  static const _dash = 1.2;

  final String label;
  final VoidCallback onTap;
  final File? file;
  final String? networkUrl;
  final double height;
  final bool uploading;
  final double cameraSize;

  /// Text once a photo is added (default "✓ ছবি যোগ হয়েছে · …").
  final String? doneLabel;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.button);
    final done = file != null || (networkUrl ?? '').isNotEmpty;
    final text = done
        ? doneLabel ?? AppLocalizations.of(context).photoAdded
        : label;
    return Semantics(
      button: true,
      label: text,
      child: GestureDetector(
        onTap: uploading ? null : onTap,
        child: CustomPaint(
          foregroundPainter: _DashedRRectPainter(
            color: AppColors.borderBrand,
            strokeWidth: _dash,
            radius: AppRadius.button,
            solid: done,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Container(
              height: height,
              width: double.infinity,
              color: AppColors.bgSubtle,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.cameraUpload,
                            width: cameraSize, height: cameraSize),
                        const SizedBox(height: AppSpacing.label),
                        Text(text,
                            style: AppTypography.bodySmallEmphasis.normal
                                .withColor(AppColors.textSecondary)),
                      ],
                    ),
                  if (uploading)
                    const ColoredBox(
                      color: AppColors.gray300,
                      child: Center(
                        child: CircularProgressIndicator(
                            color: AppColors.textOnBrand),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  _DashedRRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    this.solid = false,
  });

  final Color color;
  final double strokeWidth;
  final double radius;
  final bool solid;

  static const _dashLen = 6.0;
  static const _gapLen = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final half = strokeWidth / 2;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(half, half, size.width - strokeWidth,
          size.height - strokeWidth),
      Radius.circular(radius),
    );
    if (solid) {
      canvas.drawRRect(rrect, paint);
      return;
    }
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + _dashLen), paint);
        d += _dashLen + _gapLen;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRRectPainter old) =>
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.solid != solid;
}
