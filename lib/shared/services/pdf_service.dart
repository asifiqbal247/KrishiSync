import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../core/l10n/formatters.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';

/// Receipts, statements, trace records and inspection reports as PDF,
/// opened in the phone's share menu (save to Files / Drive, WhatsApp…).
///
/// The page is drawn with the app's own widgets outside the visible screen
/// and captured as an image, so Bangla text looks exactly like in the app
/// (the `pdf` package cannot join Bangla letters itself).
class PdfService {
  const PdfService._();

  static const _pageWidth = 595.0; // A4 width in points
  static const _margin = 24.0;
  static const _pixelRatio = 2.5;

  /// Logical width the page is drawn at (a phone-like column).
  static const _drawWidth = 420.0;

  /// Draws [children] under a "গোলাঘর · [title]" header and shares the PDF.
  static Future<void> share(
    BuildContext context, {
    required String title,
    required String fileName,
    required List<Widget> children,
  }) async {
    final l = AppLocalizations.of(context);
    final key = GlobalKey();
    final page = Material(
      color: AppColors.bgPage,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screen),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.appName,
                style: AppTypography.headingBold20.normal
                    .withColor(AppColors.textBrand)),
            const SizedBox(height: AppSpacing.xs),
            Text(title, style: AppTypography.bodyMediumStrong.normal),
            Text(Fmt.date(context, DateTime.now()),
                style: AppTypography.caption.normal
                    .withColor(AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.block),
            ...children,
          ],
        ),
      ),
    );
    final entry = OverlayEntry(
      builder: (_) => Positioned(
        left: -_drawWidth * 3, // off screen
        top: 0,
        width: _drawWidth,
        child: RepaintBoundary(key: key, child: page),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(entry);
    try {
      await WidgetsBinding.instance.endOfFrame;
      await WidgetsBinding.instance.endOfFrame;
      await _shareBoundary(key, fileName: fileName, title: title);
    } finally {
      entry.remove();
    }
  }

  static Future<void> _shareBoundary(
    GlobalKey key, {
    required String fileName,
    required String title,
  }) async {
    final ro = key.currentContext?.findRenderObject();
    if (ro is! RenderRepaintBoundary) return;
    final image = await ro.toImage(pixelRatio: _pixelRatio);
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    if (png == null) return;

    final contentW = _pageWidth - 2 * _margin;
    final contentH = contentW * image.height / image.width;
    final doc = pw.Document(title: title);
    doc.addPage(pw.Page(
      pageFormat:
          PdfPageFormat(_pageWidth, contentH + 2 * _margin, marginAll: _margin),
      build: (_) => pw.Image(pw.MemoryImage(png.buffer.asUint8List()),
          width: contentW, height: contentH),
    ));
    final bytes = await doc.save();
    final name = '$fileName.pdf';
    await SharePlus.instance.share(ShareParams(
      files: [XFile.fromData(bytes, mimeType: 'application/pdf', name: name)],
      fileNameOverrides: [name],
      title: title,
    ));
  }
}
