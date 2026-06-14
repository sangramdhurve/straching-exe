# StretchHome 🧘

A free, ad-supported **Flutter** app teaching **full-body stretching only**, done at home with
simple props (chair, wall, table, towel, bag). For **all ages**. No subscription, no backend.

## Quick start (on macOS)
```bash
flutter create . --platforms=android,ios   # adds android/ & ios/ around existing code
flutter pub get
flutter run
```
Requires Flutter: https://docs.flutter.dev/get-started/install/macos

## What's inside
- **Stretch by body part** (9 sections) with step-by-step guidance, breathing cues, and safety notes
- **Hold-timer ring** (tap to pause) and gentle / standard / deeper variations
- **Guided routines** with a full-screen auto-advancing player and rest breaks
- **Favorites**, dark mode, and a large-text accessibility mode
- Works **offline** — all content is bundled JSON; user state is on-device

## Project docs
- `Stretching-App-Strategy.md` — business strategy & monetization
- `docs/ACTION-PLAN.md` — who does what, phase by phase
- `docs/DESIGN-SYSTEM.md` — colors, type, components, screen layouts
- `CLAUDE.md` — architecture + file map (read first when editing)
- `AGENTS.md` — working conventions & progress log

## Validate content
```bash
node tools/validate_content.js
```

## Status
MVP scaffold complete: themed UI, 22 stretches, 6 routines, all core screens.
Next: expand content, add visuals, wire AdMob + privacy policy, ship to stores.
