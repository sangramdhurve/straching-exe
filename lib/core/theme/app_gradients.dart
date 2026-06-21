import 'package:flutter/material.dart';

/// Teal-based gradients for the "fresh look" hero cards and banners.
/// Brand-anchored on the seed teal (#2A9D8F) and warmed toward aqua — premium
/// feel without leaving the StretchHome identity. White text on these passes
/// WCAG AA at large/bold sizes (which is how we use it).
class AppGradients {
  AppGradients._();

  /// Primary hero gradient (deep teal → teal → aqua). Top-left to bottom-right.
  static const LinearGradient hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF177F72), Color(0xFF2A9D8F), Color(0xFF49C5B1)],
  );

  /// Cooler companion (teal → soft aqua-blue) for a second accent card.
  static const LinearGradient cool = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2A9D8F), Color(0xFF4FB6C9)],
  );

  /// A scrim laid over photos inside a hero card so white text stays legible
  /// regardless of the image behind it.
  static const LinearGradient photoScrim = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00103A35), Color(0xCC0E332F)],
    stops: [0.35, 1.0],
  );
}
