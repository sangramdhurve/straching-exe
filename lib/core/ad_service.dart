import 'dart:io' show Platform;

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'constants/app_constants.dart';

/// Central AdMob handler. Keeps all ad logic in one place so the rest of the
/// app stays ad-agnostic. Uses Google TEST ad units (see AdConfig).
///
/// UX rule (non-negotiable): ads only appear at natural boundaries — banners on
/// browse screens and an interstitial AFTER a routine completes. Never during a
/// stretch or the timer.
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  bool _initialized = false;
  InterstitialAd? _interstitial;
  int _completions = 0;

  bool get isReady => _initialized;

  Future<void> init() async {
    if (!AdConfig.enabled || _initialized) return;
    await MobileAds.instance.initialize();
    _initialized = true;
    preloadInterstitial();
  }

  String get bannerUnitId =>
      Platform.isIOS ? AdConfig.iosBanner : AdConfig.androidBanner;
  String get interstitialUnitId =>
      Platform.isIOS ? AdConfig.iosInterstitial : AdConfig.androidInterstitial;

  void preloadInterstitial() {
    if (!AdConfig.enabled || !_initialized || _interstitial != null) return;
    InterstitialAd.load(
      adUnitId: interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (err) => _interstitial = null,
      ),
    );
  }

  /// Call AFTER a routine finishes (never during). Frequency-capped so it stays gentle.
  void onRoutineComplete() {
    if (!AdConfig.enabled || !_initialized) return;
    _completions++;
    final ad = _interstitial;
    final shouldShow = ad != null &&
        _completions % AdConfig.interstitialEveryNCompletions == 0;
    if (shouldShow) {
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitial = null;
          preloadInterstitial();
        },
        onAdFailedToShowFullScreenContent: (ad, err) {
          ad.dispose();
          _interstitial = null;
          preloadInterstitial();
        },
      );
      ad.show();
    } else {
      preloadInterstitial();
    }
  }
}
