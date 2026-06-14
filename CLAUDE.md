# CLAUDE.md — StretchHome project memory

> Read this file first in any new session. It is the single source of truth so you
> don't have to re-read every file each time. Update it when something structural changes.

## What this is
**StretchHome** — a free, ad-supported **Flutter** mobile app (Android + iOS) that teaches
**full-body stretching only**, done at home with simple props (chair, wall, table, towel, bag).
For **all ages**. No subscription, no backend. Goal: monetize via AdMob at scale.

- Owner: Sangram. Built collaboratively with Claude.
- Strategy & rationale: `Stretching-App-Strategy.md`
- Design system (source of truth for UI): `docs/DESIGN-SYSTEM.md`
- Action plan & who-does-what: `docs/ACTION-PLAN.md`
- Conventions & progress log: `AGENTS.md`

## Architecture (keep it simple — no backend)
- All content ships **bundled** in `assets/data/*.json` and is loaded once at startup
  (`ContentRepository.load()` in `main()`), so the app works fully offline.
- User state (favorites, theme, large-text, streak) persists on-device via
  `shared_preferences` in `lib/core/app_state.dart` (a `ChangeNotifier` singleton).
- State propagates with `ListenableBuilder` (no extra state-mgmt package).
- Navigation: plain `Navigator.push` + a `NavigationBar` shell (`main_shell.dart`).

## File map (don't re-scan unless needed)
```
lib/
  main.dart                       app entry: loads content + state, MaterialApp, text-scaling
  core/
    app_state.dart                AppState (favorites, theme, largeText, streak) — singleton
    constants/app_constants.dart  AppSpacing, AppRadii, AppDurations, AdConfig, PrefKeys
    theme/app_colors.dart         brand hex colors + tints
    theme/app_theme.dart          Material 3 light/dark themes (Plus Jakarta Sans + Inter)
  models/
    stretch.dart                  Stretch + fromJson
    routine.dart                  Routine + fromJson
    body_part.dart                BodyPart.all (9 sections) + byId
  data/
    content_repository.dart       loads/serves stretches + routines; lookups, filters, search
  widgets/
    hold_timer_ring.dart          HERO: circular countdown (tap=pause), CustomPainter ring
    visual_placeholder.dart       shows assets/visuals/<id>.png or a tinted fallback
    body_part_card.dart, stretch_tile.dart, prop_badge.dart
  screens/
    onboarding/onboarding_screen.dart   welcome + required health disclaimer
    home/main_shell.dart                bottom-nav host (Home/Routines/Favorites/Settings)
    home/home_screen.dart               greeting, streak, today's pick, body-part grid
    body_part/body_part_screen.dart     stretch list + prop filter chips
    stretch/stretch_detail_screen.dart  visual, timer, steps, breathing, mistakes, level toggle, fav
    routine/routines_screen.dart        list of routines
    routine/routine_player_screen.dart  full-screen auto-advancing player + rest + completion
    favorites/favorites_screen.dart
    settings/settings_screen.dart       large-text, theme, disclaimer, privacy note, version
assets/
  data/stretches.json   45 stretches (5 per section) across 9 body sections
  data/routines.json    9 routines (every stretchId must exist in stretches.json)
  visuals/              45 generated flat illustrations <id>.png (tools/generate_visuals.py)
  icon/                 app_icon.png + adaptive foreground (flutter_launcher_icons)
```

## Data schema (authoritative — keep JSON and models in sync)
`stretches.json` → `{ "stretches": [ Stretch ] }`. Stretch keys:
`id, name, bodyPartId, bodyPart, props[], level(gentle|standard|deeper),
targetMuscles[], holdSeconds, sides(1|2), durationLabel, steps[], breathingCue,
commonMistakes[], safetyNote, variants{gentle,deeper}, assetType(illustration),
assetFile(assets/visuals/<id>.png), tags[]`.
Props vocabulary: `none, chair, wall, table, towel, bag`.
Body sections (ids): `neck, shoulders_upper_back, arms_wrists, chest, back,
hips_glutes, hamstrings, quads_hipflexors, calves_ankles`.

`routines.json` → `{ "routines": [ Routine ] }`. Routine keys:
`id, name, description, minutes, level, audience[], tags[], stretchIds[]`.

## How to run (on the user's Mac — Flutter is NOT in Claude's sandbox)
```bash
cd straching-exe
flutter create . --platforms=android,ios   # generates android/ & ios/ around existing lib/
flutter pub get
flutter run
```
Note: `flutter create .` will NOT overwrite existing lib/, pubspec.yaml, or assets.
google_fonts downloads fonts on first run (needs internet once); bundle them later for full offline.

## Monetization (AdMob) — WIRED, test mode
- Dependency: `google_mobile_ads: '>=7.0.0 <10.0.0'` (7.0.0+ fixes the Gradle-9/AGP-9 build break that
  5.x caused). pub auto-picks the newest your Flutter supports.
- `AdService` (`lib/core/ad_service.dart`) inits in `main()`, preloads + shows interstitials.
  `BannerAdSlot` (`lib/widgets/`) renders banners. `AdConfig.enabled = true` with Google **test** IDs.
- Placement: banners at the bottom of Routines + body-part lists; interstitial only at routine
  completion, frequency-capped (`AdConfig.interstitialEveryNCompletions`). NEVER during a stretch/timer.
- Native: test AdMob App IDs in AndroidManifest (`APPLICATION_ID`) + iOS Info.plist (`GADApplicationIdentifier`).
- Before production: replace ALL test IDs (units in `AdConfig` + app IDs in manifest/plist) with your real
  AdMob IDs, and set store target audience **13+** (not "for children"; strategy doc §8).

## Before launch (checklist)
1. Host a **privacy policy** (required by stores + AdMob) and wire it in Settings via `url_launcher`.
2. Fill store **Data Safety / App Privacy** forms (collects advertising ID + analytics).
3. Set developer accounts: Google Play ($25 one-time), Apple ($99/yr).
4. Replace placeholder visuals in `assets/visuals/`.
5. App icon + screenshots + store listing (see strategy doc §12 for ASO).

## Conventions
- Material 3, `useMaterial3: true`. Colors come from `AppColors` / theme `colorScheme` — no hardcoded hex in widgets.
- Spacing via `AppSpacing`, radii via `AppRadii`. Headings = Plus Jakarta Sans, body = Inter.
- Keep stretching-only scope. No strength/cardio/diet/social. Resist scope creep.

## Status (update this)
- DONE: scaffold, theme, models, repository, all core screens, 45 stretches, 9 routines, docs,
  design system, privacy policy + health disclaimer (`docs/legal/`), 45 generated illustrations +
  app icon (`tools/generate_visuals.py`, launcher config in pubspec), store listing (`docs/STORE-LISTING.md`).
- NEXT: user runs app on Mac (Phase 1) + `dart run flutter_launcher_icons`; replace illustrations with
  photos/MP4s; wire AdMob (after base app confirmed); host privacy policy; device testing; store submit.
