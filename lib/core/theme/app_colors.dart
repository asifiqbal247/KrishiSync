import 'package:flutter/painting.dart';

/// All colors come from Figma variables (DS – Foundations, node 20:3).
/// Figma `#RRGGBBAA` is written here as Flutter `0xAARRGGBB`.
/// Never use a raw Color anywhere else in the app.
abstract final class AppColors {
  // ---- Primitives ----
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  static const green50 = Color(0xFFE8F5E9);
  static const green100 = Color(0x262E7D32);
  static const green200 = Color(0x4D2E7D32);
  static const green500 = Color(0xFF2E7D32);
  static const green600 = Color(0xE52E7D32);
  static const green700 = Color(0xCC2E7D32);

  static const sage50 = Color(0x26789262);
  static const sage100 = Color(0x40789262);
  static const sage200 = Color(0x66789262);
  static const sage500 = Color(0xFF789262);

  static const yellow50 = Color(0x33F2C94C);
  static const yellow100 = Color(0x66F2C94C);
  static const yellow500 = Color(0xFFF2C94C);
  static const yellow700 = Color(0xCCF2C94C);

  static const red50 = Color(0x1FC94C4C);
  static const red100 = Color(0x38C94C4C);
  static const red500 = Color(0xFFC94C4C);

  static const gray50 = Color(0x0A1F1F1F);
  static const gray100 = Color(0x121F1F1F);
  static const gray200 = Color(0x1F1F1F1F);
  static const gray300 = Color(0x591F1F1F);
  static const gray500 = Color(0xA61F1F1F);
  static const gray700 = Color(0xCC1F1F1F);
  static const gray900 = Color(0xFF1F1F1F);

  // ---- Semantic: backgrounds ----
  static const bgPage = white;
  static const bgSurface = green50;
  static const bgSubtle = green50;
  static const bgMuted = gray100;
  static const bgBrand = green500;
  static const bgBrandHover = green600;
  static const bgBrandPressed = green700;
  static const bgDisabled = gray200;
  static const bgAccent = yellow500;
  static const bgSuccessSubtle = green50;
  static const bgWarningSubtle = yellow50;
  static const bgErrorSubtle = red50;
  static const bgInfoSubtle = sage50;
  static const bgError = red500;
  static const bgOverlay = gray900;

  // ---- Semantic: text ----
  static const textPrimary = gray900;
  static const textSecondary = gray500;
  static const textDisabled = gray300;
  static const textOnBrand = white;
  static const textBrand = green500;
  static const textSuccess = green500;
  static const textWarning = gray900;
  static const textError = red500;
  static const textInfo = gray900;

  // ---- Semantic: borders ----
  static const borderDefault = gray200;
  static const borderStrong = gray300;
  static const borderBrand = green500;
  static const borderError = red500;

  // ---- Semantic: icons ----
  static const iconPrimary = gray900;
  static const iconSecondary = sage500;
  static const iconBrand = green500;
  static const iconOnBrand = white;
  static const iconWarning = yellow500;
  static const iconError = red500;

  // ---- Splash (01) ----
  /// Splash Fade end colour (white, 0% alpha).
  static const whiteTransparent = Color(0x00FFFFFF);
  /// Version text shadow: rgba(0,0,0,0.35).
  static const splashTextShadow = Color(0x59000000);

  // ---- Shadow colors used by HF components (not in the variable set) ----
  /// Primary button drop shadow as used in screens (Button/Primary 315:14):
  /// rgba(46,125,50,0.32).
  static const shadowBrandButton = Color(0x522E7D32);
  /// List item drop shadow: rgba(31,51,31,0.08).
  static const shadowCard = Color(0x141F331F);
  /// Action tile drop shadow: rgba(46,125,51,0.10).
  static const shadowBrandTile = Color(0x1A2E7D33);
  /// Brand action tile shadow: rgba(46,125,51,0.30).
  static const shadowBrandTileStrong = Color(0x4D2E7D33);
  /// Outline button shadow: rgba(31,31,31,0.06).
  static const shadowOutline = Color(0x0F1F1F1F);
  /// HF/Modal shadow: rgba(0,0,0,0.18).
  static const shadowModal = Color(0x2E000000);
  /// Modal overlay: rgba(31,31,31,0.45).
  static const overlayScrim = Color(0x731F1F1F);
  /// Price / tip card border (#E0E0E0 in Figma cards).
  static const cardBorder = Color(0xFFE0E0E0);
  /// Tip card thumb background (#F3F3F3).
  static const tipThumbBg = Color(0xFFF3F3F3);
}
