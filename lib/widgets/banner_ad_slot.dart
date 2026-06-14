import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../core/ad_service.dart';
import '../core/constants/app_constants.dart';

/// A self-contained banner slot for browse screens.
/// Renders nothing if ads are disabled or the banner hasn't loaded —
/// so it never leaves an empty gap. Place it at the bottom of list screens only
/// (never on a stretch/timer screen).
class BannerAdSlot extends StatefulWidget {
  const BannerAdSlot({super.key});

  @override
  State<BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends State<BannerAdSlot> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    if (!AdConfig.enabled || !AdService.instance.isReady) return;
    final ad = BannerAd(
      size: AdSize.banner,
      adUnitId: AdService.instance.bannerUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, err) => ad.dispose(),
      ),
    )..load();
    _ad = ad;
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AdConfig.enabled || !_loaded || _ad == null) {
      return const SizedBox.shrink();
    }
    return SafeArea(
      top: false,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: _ad!.size.height.toDouble(),
        color: Theme.of(context).colorScheme.surface,
        child: AdWidget(ad: _ad!),
      ),
    );
  }
}
