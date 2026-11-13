import 'package:flutter/painting.dart';

import 'app_colors.dart';

/// Text styles from Figma (DS – Foundations → Typography).
/// Font: Hind Siliguri, fallback Noto Sans Bengali. Letter spacing 0.
/// `height` = Figma line height / font size.
///
/// Many HF components use "line-height: normal". For those, use
/// `style.normal` (see [AppTextStyleX]) which drops the fixed line height.
abstract final class AppTypography {
  static const fontFamily = 'HindSiliguri';
  static const fontFamilyFallback = <String>['NotoSansBengali'];

  static TextStyle _s(double size, FontWeight weight, double lineHeight) =>
      TextStyle(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSize: size,
        fontWeight: weight,
        height: lineHeight / size,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      );

  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;

  static final display28 = _s(28, _bold, 38);
  static final h1 = _s(24, _bold, 34);
  static final headingBold22 = _s(22, _bold, 30);
  static final headingBold20 = _s(20, _bold, 28);
  static final h2 = _s(20, _semiBold, 28);
  static final h3 = _s(18, _semiBold, 26);
  static final bodyLarge = _s(16, _regular, 24);
  static final labelButton = _s(16, _semiBold, 21);
  static final labelMedium15 = _s(15, _semiBold, 21);
  static final bodyMedium = _s(14, _regular, 21);
  static final bodyMediumEmphasis = _s(14, _medium, 21);
  static final bodyMediumStrong = _s(14, _semiBold, 21);
  static final bodySmall = _s(13, _regular, 20);
  static final bodySmallEmphasis = _s(13, _medium, 20);
  static final bodySmallStrong = _s(13, _semiBold, 20);
  static final caption = _s(12, _regular, 17);
  static final labelSmall = _s(11, _medium, 14);
  static final numberLarge = _s(28, _bold, 36);
  static final numberMedium = _s(18, _semiBold, 24);
  static final numberSmall = _s(14, _medium, 20);
}

extension AppTextStyleX on TextStyle {
  /// Figma "line-height: normal" (font's own metrics).
  TextStyle get normal => copyWith(height: null);
  TextStyle withColor(Color c) => copyWith(color: c);
}
