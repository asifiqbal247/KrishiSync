import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_dimens.dart';
import 'app_typography.dart';

/// Single ThemeData for the whole app. Built only from tokens.
abstract final class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppTypography.fontFamily,
      fontFamilyFallback: AppTypography.fontFamilyFallback,
      scaffoldBackgroundColor: AppColors.bgPage,
      colorScheme: const ColorScheme.light(
        primary: AppColors.bgBrand,
        onPrimary: AppColors.textOnBrand,
        secondary: AppColors.sage500,
        onSecondary: AppColors.white,
        tertiary: AppColors.bgAccent,
        error: AppColors.bgError,
        onError: AppColors.white,
        surface: AppColors.bgPage,
        onSurface: AppColors.textPrimary,
        outline: AppColors.borderDefault,
      ),
      splashFactory: InkRipple.splashFactory,
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displaySmall: AppTypography.display28,
        headlineMedium: AppTypography.h1,
        headlineSmall: AppTypography.h2,
        titleLarge: AppTypography.h3,
        titleMedium: AppTypography.labelButton,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelButton,
        labelMedium: AppTypography.caption,
        labelSmall: AppTypography.labelSmall,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgPage,
        surfaceTintColor: AppColors.bgPage,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: AppTypography.h3.normal,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: AppColors.bgPage.withValues(alpha: 0),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDefault,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.bgBrand,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.bgBrand,
        selectionHandleColor: AppColors.bgBrand,
        selectionColor: AppColors.green200,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.bgPage,
        surfaceTintColor: AppColors.bgPage,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.x2l)),
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.bgPage,
        surfaceTintColor: AppColors.bgPage,
      ),
    );
  }
}
