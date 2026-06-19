/// 4pt-based spacing scale.
class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppRadii {
  AppRadii._();
  static const double card = 22;
  static const double button = 16;
  static const double chip = 30;
}

class AppDurations {
  AppDurations._();
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 350);
  static const int restBetweenSeconds = 5; // rest screen between stretches in a routine
}

/// AdMob configuration.
///
/// While building, these are Google's official TEST ad unit IDs (safe to view/click).
/// Before releasing, set [enabled] = true and replace these with the real IDs
/// from your AdMob console. See CLAUDE.md → "Monetization" for the full checklist.
class AdConfig {
  AdConfig._();

  /// Master switch for ads. Currently ON using Google TEST ad units (safe to view/tap).
  /// Replace the IDs below with your real AdMob units before production, and keep this true.
  static const bool enabled = true;

  /// Gentle cadence: show an interstitial only once every N routine completions.
  static const int interstitialEveryNCompletions = 2;

  // ---- Android test units ----
  static const String androidBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const String androidInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const String androidRewarded = 'ca-app-pub-3940256099942544/5224354917';

  // ---- iOS test units ----
  static const String iosBanner = 'ca-app-pub-3940256099942544/2934735716';
  static const String iosInterstitial = 'ca-app-pub-3940256099942544/4411468910';
  static const String iosRewarded = 'ca-app-pub-3940256099942544/1712485313';
}

/// Keys used with shared_preferences.
class PrefKeys {
  PrefKeys._();
  static const String onboardingDone = 'onboarding_done';
  static const String favorites = 'favorite_stretch_ids';
  static const String largeText = 'large_text_mode';
  static const String themeMode = 'theme_mode'; // system | light | dark
  static const String streakCount = 'streak_count';
  static const String lastStretchDate = 'last_stretch_date';
  static const String reduceMotion = 'reduce_motion';
  static const String availableProps = 'available_props';
  static const String propsConfigured = 'props_configured';
}

/// Hosted links opened from the app (GitHub Pages).
class Links {
  Links._();
  static const String privacyPolicy =
      'https://sangramdhurve.github.io/stretchhome-legal/privacy-policy.html';
  static const String healthDisclaimer =
      'https://sangramdhurve.github.io/stretchhome-legal/health-disclaimer.html';
}
