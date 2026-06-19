import 'package:flutter/material.dart';

/// Brand color foundation for StretchHome.
/// Keep in sync with docs/DESIGN-SYSTEM.md.
class AppColors {
  AppColors._();

  // Brand
  static const Color seed = Color(0xFF2A9D8F); // teal — Material 3 seed
  static const Color primary = Color(0xFF2A9D8F);
  static const Color primaryDark = Color(0xFF21867A);
  static const Color accent = Color(0xFFF4A261); // warm amber (use sparingly)
  static const Color success = Color(0xFF8AB17D);

  // Light surfaces
  static const Color bgLight = Color(0xFFF6F8F8);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFECF2F1);
  static const Color inkLight = Color(0xFF15302E);

  // Dark surfaces
  static const Color bgDark = Color(0xFF0F1716);
  static const Color surfaceDark = Color(0xFF16201F);
  static const Color primaryDarkMode = Color(0xFF5FC4B8);
  static const Color inkDark = Color(0xFFE7F0EE);

  // Semantic
  static const Color error = Color(0xFFE25C5C);
  static const Color warning = Color(0xFFE9A23B);
  static const Color muted = Color(0xFF6B7F7C);

  /// Soft tints used behind body-part icons / visual placeholders.
  static const List<Color> tints = [
    Color(0xFFD7EFEC),
    Color(0xFFFCE7D2),
    Color(0xFFE3EFD9),
    Color(0xFFDDE9F2),
    Color(0xFFF1E2EF),
  ];
}
