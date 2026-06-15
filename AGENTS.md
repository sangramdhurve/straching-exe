# AGENTS.md — working agreement & progress log

This file is for any AI agent (or person) working in this repo. Pair it with `CLAUDE.md`
(architecture + file map). Goal: make changes safely without re-reading everything.

## Golden rules
1. **Read `CLAUDE.md` first.** It has the file map, data schema, and conventions.
2. **Stretching only.** No strength, cardio, diet, social, or backend features. Guard the scope.
3. **No backend.** Content is bundled JSON; user state is local (`shared_preferences`). Keep it that way unless explicitly asked.
4. **Theme tokens only.** Use `AppColors`, `AppSpacing`, `AppRadii`, and `Theme.of(context).colorScheme`. Never hardcode hex/sizes in widgets.
5. **Keep JSON ⇄ models in sync.** If you change `stretches.json`/`routines.json` shape, update `models/` and the schema in `CLAUDE.md`.
6. **Routine integrity.** Every `stretchIds` entry in `routines.json` must exist in `stretches.json`. Validate before committing (see below).
7. **Ad UX is sacred.** Never show ads during a stretch or timer. Completion screen / browse lists only.
8. **Accessibility.** Maintain large-text mode, ≥48dp touch targets, AA contrast.

## Definition of done for a change
- Code compiles (`flutter analyze` clean on the user's Mac).
- Content JSON validates and all routine references resolve.
- New strings are user-friendly and gentle (all-ages tone).
- `CLAUDE.md` "Status" updated if structure changed.

## Validate content (run in Claude's sandbox or the Mac)
```bash
node tools/validate_content.js
```
Checks JSON parses, required fields exist, and every routine stretchId resolves.

## How to add a new stretch
1. Add an object to `assets/data/stretches.json` following the schema (unique `id`).
2. `assetFile` must be `assets/visuals/<id>.png` (placeholder shows until the PNG exists).
3. Optionally add its `id` to a routine in `routines.json`.
4. Run the validator.

## How to add real visuals
- Drop `assets/visuals/<id>.png` (clean 2D pose, ~1080×1080). It appears automatically.
- For video later: add the mp4, set the stretch's `assetType` to `video`, and extend `VisualPlaceholder`/add a video widget.

## Progress log (newest first)
- 2026-06-15 (h) — Shipped P2 (docs/UX-REVIEW.md). Prop personalization: onboarding "What do you have
  nearby?" step + Settings → Personalize → "Home props" editor, persisted as AppState.availableProps
  (+ propsConfigured). Prop-aware "Today's Pick": ContentRepository.dailySuggestionFor() filters
  routines to those doable with the user's props (floor/"none" always allowed; falls back to all so the
  card never disappears); Home passes the set in (repo stays AppState-free). Completion "bloom":
  animated check + radial glow, honors reduce-motion. Custom body-map body-part icons: 9 consistent
  silhouettes with the target region in teal (tools/generate_bodypart_icons.py → assets/icons/bodyparts/,
  declared in pubspec), wired into BodyPartCard via Image.asset with an Icon fallback +
  excludeFromSemantics. Two verify agents (code review + UX) caught a silently-failed edit
  (dailySuggestionFor was never written to disk) — fixed — plus unified onboarding⇄settings prop
  copy/chip style and added an "All props" summary. Still pending: ONE character language across all 45
  (blocked on more Mixamo animations), app-icon redesign, "Quick Relief" tap-the-pain micro-routine.
- 2026-06-14 (g) — Shipped P1 (docs/UX-REVIEW.md): Search screen (empty = browse-all) + Home search
  bar; prop+level filter chips with labels + "Clear filters"; Routine preview screen (routines list +
  daily card now route here, then Start → player); rest-screen next-stretch thumbnail; completion
  stats (stretches/minutes/streak, "nice start" on day 1); Settings "Send feedback"; unified
  illustration backgrounds (regenerated all 45). Two verify agents (code review + UX flow) →
  fixed launchUrl error handling + 5 UX micro-wins. Next: P2 (one character language for all 45,
  custom body-part icons, onboarding personalization, prop-aware "today's pick", icon redesign).
- 2026-06-14 (f) — Multi-agent design review (docs/UX-REVIEW.md). Implemented all P0 fixes:
  teal favorite (was red), body-part card clipping fix, pinned onSurfaceVariant (AA contrast) +
  headlineLarge font, timer ring Pause/Restart/Skip controls + Semantics live region, reduce-motion
  (AppState + Settings toggle + GIF→PNG fallback), routine-player exit confirm + 400ms-delayed
  interstitial. Two verification agents (code review + a11y recheck) found follow-ups, all fixed:
  reactive reduce-motion, step-badge contrast, progress-bar label, decorative-chevron exclusion,
  dialog autofocus. P1/P2 backlog remains in UX-REVIEW.md.
- 2026-06-14 (e) — 3D pipeline proven via Blender MCP. Studio scene (floor/lights/teal world/
  square cam) in `assets/blender/`. Realistic Mixamo characters import (character_female.fbx /
  character_male.fbx). Best path = Mixamo ANIMATIONS (With Skin) dropped in `assets/blender/anims/`;
  Blender 5.1 has no FFMPEG output, so render PNG seq to renders/seq/ then encode with sandbox ffmpeg.
  First clip done: "Arm Stretching" -> renders/arm_stretch.mp4 (maps to cross_body_shoulder).
- 2026-06-14 (d) — Wired AdMob in TEST mode: google_mobile_ads `>=7.0.0 <10.0.0` (fixes Gradle-9 break),
  AdService + BannerAdSlot, banners on browse screens, frequency-capped interstitial at routine
  completion, native app IDs in manifest + Info.plist. No ads on stretch/timer screens.
- 2026-06-14 (c) — Generated 45 flat stretch illustrations + app icon (tools/generate_visuals.py),
  added flutter_launcher_icons config, wrote store listing + ASO (docs/STORE-LISTING.md).
- 2026-06-14 (b) — Expanded content to 45 stretches (5 per section) + 9 routines.
  Drafted privacy policy + health disclaimer (hostable HTML) in `docs/legal/`.
- 2026-06-14 (a) — Initial build: scaffold, Material 3 theme, models, repository, onboarding,
  home, body-part, stretch detail (timer ring + level toggle), routines, routine player
  (auto-advance + rest + completion), favorites, settings. 22 stretches / 6 routines.
  Design system spec written. AdMob wired but disabled. Docs created.
- NEXT — Expand to 50+ stretches; create 2D visuals; AdMob live + privacy policy;
  app icon & store listings; on-device testing; optional reminders + streak polish.
