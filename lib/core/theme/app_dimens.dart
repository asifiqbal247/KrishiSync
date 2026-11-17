import 'package:flutter/painting.dart';

import 'app_colors.dart';

/// Spacing scale from Figma (DS – Foundations → Spacing).
abstract final class AppSpacing {
  static const double s2xs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double s2xl = 24;
  static const double s3xl = 32;
  static const double s4xl = 40;

  /// Screen side padding (360 frame → 328 content).
  static const double screen = lg;

  /// Vertical gap between blocks inside HF screen "Content" columns.
  static const double block = 14;

  /// Top padding of HF screen "Content" under the app bar.
  static const double contentTop = sm;

  /// Gap between label and field in HF/Input.
  static const double label = 6;

  /// 10px gaps used in some HF lists and notes.
  static const double x10 = 10;

  /// Status badge vertical padding (319:35).
  static const double badgeV = 3;
}

/// Corner radius scale from Figma, plus the extra radii used by HF components.
abstract final class AppRadius {
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double x2l = 20;
  static const double full = 999;

  // Component radii found in HF – Components (not in the scale).
  static const double button = 14; // HF/Button/Primary
  static const double tile = 18; // HF/Action Tile
  static const double chip = 22; // HF/Chip
  static const double navIcon = 6; // bottom-nav icon wrap
  static const double badge = 13; // status badge
  static const double bone = 6; // 215 skeleton title line
  static const double statTile = 10; // 64 track-record stat tile
  static const double modal = 24; // HF/Modal
  static const double actionIcon = 22; // action tile icon wrap (44/2)
}

/// Fixed sizes from HF components.
abstract final class AppSizes {
  static const double appBarHeight = 56;

  /// Selected / Secondary / Outline border: 1.5px brand.
  static const double borderBrand = 1.5;
  static const double backButton = 44;
  static const double buttonL = 48;
  static const double buttonM = 40;
  static const double buttonS = 32;
  static const double inputHeight = 48;
  static const double searchHeight = 48;
  static const double chipMinHeight = 44;
  static const double bottomNavHeight = 72;
  static const double fab = 56;
  static const double icon = 24;
  static const double iconSm = 18;
  static const double iconXs = 16;
  static const double thumb = 48;
  static const double sectionHeader = 28;
  static const double modalWidth = 312;
  static const double modalIcon = 64;
  static const double dialogIcon = 40;
}

/// Shadows from Figma (DS – Foundations → Shadows) and HF components.
abstract final class AppShadows {
  static const small = [
    BoxShadow(color: Color(0x14000000), offset: Offset(0, 1), blurRadius: 3),
  ];
  static const medium = [
    BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 12),
  ];
  static const large = [
    BoxShadow(color: Color(0x24000000), offset: Offset(0, 8), blurRadius: 24),
  ];

  /// Button/Primary in screens: drop-shadow 0 4 5 rgba(46,125,50,.32).
  static const brandButton = [
    BoxShadow(
      color: AppColors.shadowBrandButton,
      offset: Offset(0, 4),
      blurRadius: 5,
    ),
  ];

  /// Button/Warning: drop-shadow 0 4 5 rgba(242,201,76,.50).
  static const warningButton = [
    BoxShadow(
      color: AppColors.shadowWarning,
      offset: Offset(0, 4),
      blurRadius: 5,
    ),
  ];

  /// Button/Destructive: drop-shadow 0 4 5 rgba(201,76,76,.30).
  static const destructiveButton = [
    BoxShadow(
      color: AppColors.shadowDestructive,
      offset: Offset(0, 4),
      blurRadius: 5,
    ),
  ];

  /// Confirm dialogs (D1–D6): 0 8 24 rgba(0,0,0,.20).
  static const dialog = [
    BoxShadow(
      color: AppColors.shadowDialog,
      offset: Offset(0, 8),
      blurRadius: 24,
    ),
  ];

  /// Button/Outline: drop-shadow 0 2 3 rgba(31,31,31,.06).
  static const outlineButton = [
    BoxShadow(
      color: AppColors.shadowOutline,
      offset: Offset(0, 2),
      blurRadius: 3,
    ),
  ];

  /// Brand action tile (main action): drop-shadow 0 6 7 rgba(46,125,51,.30).
  static const brandTile = [
    BoxShadow(
      color: AppColors.shadowBrandTileStrong,
      offset: Offset(0, 6),
      blurRadius: 7,
    ),
  ];

  /// HF/Modal: drop-shadow 0 12 16 rgba(0,0,0,.18).
  static const modal = [
    BoxShadow(
      color: AppColors.shadowModal,
      offset: Offset(0, 12),
      blurRadius: 16,
    ),
  ];

  /// HF/List Item: drop-shadow 0 4 7 rgba(31,51,31,.08).
  static const card = [
    BoxShadow(color: AppColors.shadowCard, offset: Offset(0, 4), blurRadius: 7),
  ];

  /// HF/Action Tile: drop-shadow 0 4 6 rgba(46,125,51,.10).
  static const tile = [
    BoxShadow(
      color: AppColors.shadowBrandTile,
      offset: Offset(0, 4),
      blurRadius: 6,
    ),
  ];
}
