# StretchHome — Store Release Graphics

All graphics are generated, spec-verified, and ready to upload. Brand teal `#2A9D8F`,
calm overhead-reach figure mark, consistent across every asset.

Regenerate anytime with the scripts in `tools/`:
`generate_store_icon.py` (icon) · `generate_app_mockups.py` (screens) · `generate_store_graphics.py` (feature + screenshots).

## Folder map
```
store-assets/
  icon/
    play_icon_512.png            512×512  PNG-32 (alpha)      → Google Play app icon
    apple_icon_1024.png          1024×1024 PNG (NO alpha)     → App Store / Xcode icon
  feature/
    play_feature_graphic_1024x500.png  1024×500 (NO alpha)   → Google Play feature graphic
  screenshots/
    play/        01–05  1080×1920  (9:16)                    → Google Play phone screenshots
    apple_6_7/   01–05  1290×2796  (6.7" iPhone)              → App Store screenshots
    apple_6_9/   01–05  1320×2868  (6.9" iPhone)              → App Store screenshots
  mockups/       01–05  1080×2280  raw app-screen recreations (source for the screenshots)
```

## Google Play Console — where each file goes
- **App icon** → Store listing → App icon → `icon/play_icon_512.png`
- **Feature graphic** → Store listing → Feature graphic → `feature/play_feature_graphic_1024x500.png` (required; Play blocks publishing without it)
- **Phone screenshots** → Store listing → Phone → upload all 5 from `screenshots/play/` (min 2, we give 5)

## Apple App Store Connect — where each file goes
- **App icon** → set in Xcode asset catalog (App Icon, 1024pt) → `icon/apple_icon_1024.png` (must have **no alpha/transparency**, which this file satisfies)
- **iPhone 6.9" screenshots** → App Store → upload all 5 from `screenshots/apple_6_9/`
- **iPhone 6.7" screenshots** → upload all 5 from `screenshots/apple_6_7/`
  (Apple auto-scales these down for smaller iPhones; iPad screenshots only needed if you ship an iPad build.)

## Screenshot captions (baked into the images)
1. Full-body stretches, made for home
2. Follow a calm hold-timer
3. Guided routines that flow hands-free
4. Target exactly where you feel tight
5. Build a gentle daily streak

## Specs verified (all ✅)
| Asset | Required | This file |
|---|---|---|
| Play icon | 512×512, 32-bit PNG, ≤1 MB | 512×512 RGBA, 0.08 MB |
| Apple icon | 1024×1024, no alpha | 1024×1024 RGB, 0.20 MB |
| Feature graphic | 1024×500, no alpha, ≤1 MB | 1024×500 RGB, 0.12 MB |
| Play screenshots | 9:16, 320–3840 px, ≤8 MB | 1080×1920 RGB |
| Apple 6.7" | 1290×2796 | exact |
| Apple 6.9" | 1320×2868 | exact |

## Notes
- The launcher icon source (`assets/icon/app_icon.png` + `app_icon_foreground.png`) was also
  refreshed to match — run `dart run flutter_launcher_icons` to regenerate Android/iOS launcher icons.
- These are **final, store-ready** files (the real app screens, exact pixel specs). An optional
  editable Canva version of the feature graphic can be set up once Canva is connected.
- Graphics don't affect the launch blockers tracked in `docs/LAUNCH-CHECKLIST.md` (real AdMob IDs,
  package/bundle ID, hosted privacy policy).
