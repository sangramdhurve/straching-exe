import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_constants.dart';
import 'app_colors.dart';

/// Central Material 3 theme for StretchHome.
/// Headings: Plus Jakarta Sans · Body/UI: Inter (via google_fonts).
class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
    ).copyWith(
      primary: isDark ? AppColors.primaryDarkMode : AppColors.primary,
      secondary: AppColors.accent,
      tertiary: AppColors.success,
      surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      error: AppColors.error,
    );

    final base = (isDark ? ThemeData.dark() : ThemeData.light()).textTheme;
    final textTheme = GoogleFonts.interTextTheme(base).copyWith(
      displaySmall: GoogleFonts.plusJakartaSans(
          textStyle: base.displaySmall, fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.plusJakartaSans(
          textStyle: base.headlineMedium, fontWeight: FontWeight.w700),
      headlineSmall: GoogleFonts.plusJakartaSans(
          textStyle: base.headlineSmall, fontWeight: FontWeight.w700),
      titleLarge: GoogleFonts.plusJakartaSans(
          textStyle: base.titleLarge, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.plusJakartaSans(
          textStyle: base.titleMedium, fontWeight: FontWeight.w600),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      textTheme: textTheme,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: scheme.onSurface,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.card)),
        clipBehavior: Clip.antiAlias,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.button)),
          textStyle: GoogleFonts.plusJakartaSans(
              fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.button)),
          side: BorderSide(color: scheme.outlineVariant),
          textStyle: GoogleFonts.plusJakartaSans(
              fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.chip)),
        side: BorderSide.none,
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : AppColors.surfaceVariantLight,
        selectedColor: scheme.primary,
        labelStyle: TextStyle(color: scheme.onSurface),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        elevation: 0,
        height: 68,
        indicatorColor: scheme.primary.withValues(alpha: 0.16),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button)),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.6),
        thickness: 1,
      ),
    );
  }
}
