import 'dart:io';

import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';

/// HF/Switch/*-upload (e.g. 525:9623): subtle green fill, 1.2px dashed brand
/// border, radius 14, 32px camera image + Medium 13 secondary label.
/// When a photo is picked it shows the preview instead.
class KsUploadBox extends StatelessWidget {
  const KsUploadBox({
    super.key,
    required this.label,
    required this.onTap,
    this.file,
    this.networkUrl,
    this.height = defaultHeight,
    this.uploading = false,
  });

  static const defaultHeight = 61.4;
  static const previewHeight = 120.0;
  static const _camera = 32.0;
  static const _dash = 1.2;

  final String label;
  final VoidCallback onTap;
  final File? file;
  final String? networkUrl;
  final double height;
  final bool uploading;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.button);
    final hasImage = file != null || networkUrl != null;
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: uploading ? null : onTap,
        child: CustomPaint(
          foregroundPainter: _DashedRRectPainter(
            color: AppColors.borderBrand,
            strokeWidth: _dash,
            radius: AppRadius.button,
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
                  if (hasImage)
                    file != null
                        ? Image.file(file!, fit: BoxFit.cover)
                        : Image.network(networkUrl!, fit: BoxFit.cover)
                  else
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.cameraUpload,
                            width: _camera, height: _camera),
                        const SizedBox(height: AppSpacing.label),
                        Text(label,
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
  });

  final Color color;
  final double strokeWidth;
  final double radius;

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
      old.color != color || old.strokeWidth != strokeWidth;
}
