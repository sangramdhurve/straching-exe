# StretchHome — Design Review Panel (UI/UX + Visuals)

*Three specialists reviewed the app independently — a UX/usability designer, a visual/brand
designer, and an accessibility auditor. This is the moderated synthesis: consensus, debate, and a
prioritized fix list. June 2026.*

---

## The panel

- **UX / Usability** — information architecture, the stretch/timer flow, routine player, discoverability.
- **Visual / Brand** — aesthetics, color, type, illustration quality, the timer ring, icon, polish.
- **Accessibility** — WCAG 2.1 AA, all-ages/seniors, contrast, touch targets, screen readers, motion.

A recurring theme across all three: the **design system doc already specifies** many of these
improvements (pause controls, exit confirmation, reduce-motion, richer onboarding, level filters,
completion stats) — the MVP simply hasn't implemented them yet. So a lot of this is "finish what's
already designed," not "rethink."

---

## Where all three agree (fix these first)

1. **The timer needs real controls, not just tap-the-ring.** All three flagged it. The hero
   `HoldTimerRing` only pauses when you tap the 232 px ring — undiscoverable, and a hard blocker for
   switch-access/motor-impaired users. Add a dedicated **Pause/Resume + Skip** button row beneath it.
2. **The favorite heart is red — make it teal.** Both UX and Visual flagged `scheme.error` (red) for
   the favorited state. Red reads as "error/delete," not "saved." One-line fix in two files.
3. **Body-part card text clips in large-text mode.** UX and Accessibility both caught
   `maxLines: 2 + TextOverflow.ellipsis` on names like "Shoulders & Upper Back" — it truncates at 1.3×+
   scale, which is exactly the senior audience. Remove the clip; let cards grow.
4. **Visual consistency is the #1 visual problem.** The app currently mixes **three** visual languages:
   44 flat 2D stick figures + 1 photorealistic Mixamo clip + the stylized 3D mannequin. Advancing
   through a routine jumps between them. Whatever we pick, **all 45 must match.**
5. **Accessibility/motion gaps.** No screen-reader label on the timer/visuals/icon-buttons, no
   reduce-motion option (looping GIFs animate unconditionally), and a contrast risk on muted text.

---

## The debate (where the experts push back)

**Character direction — the visual designer disagrees with the current plan.**
You chose the **realistic Mixamo human**. The visual designer argued the opposite — commit to the
**stylized 3D mannequin** instead, because it's age-neutral, gender-neutral, already brand-teal, and
distinctive vs. competitors, whereas shipping the photorealistic character means re-rendering all 45
poses to avoid the mix. The accessibility auditor leans the same way (a neutral figure sidesteps
representation issues for an all-ages app).
*Moderator's reconciliation:* this is a legitimate taste call that's yours to make — but the part
**everyone agrees on** is that the current 3-language mix can't ship. Pick one and render all 45 in it.
If realistic, plan for the full re-render; if stylized, we already have the mannequin.

**2D illustration quality.**
The visual designer was blunt — the auto-generated stick figures read "school project" and several
(Neck Side Stretch, Cat-Cow) don't actually show the stretch. The UX designer considered them
*functionally* acceptable. *Reconciliation:* fine as launch placeholders, but they're the weakest
brand signal and the first thing a store browser sees — upgrading them (or replacing with the chosen
3D) is the highest-leverage visual work.

---

## Prioritized backlog

### P0 — pre-launch, mostly quick code fixes
- Favorite heart → `scheme.primary` (teal) in `stretch_tile.dart` + `stretch_detail_screen.dart`.
- Remove `maxLines/ellipsis` clip on `BodyPartCard`; replace greedy `Spacer` so it reflows; test at 1.6×/2×.
- Timer: add **Pause/Resume + Skip** buttons below the ring; wrap ring in `Semantics(liveRegion)`; add
  `tooltip`/labels to icon-only buttons (favorite in tile, close in player).
- Pin `colorScheme.onSurfaceVariant` to `#4A6966` for AA contrast on captions/badges/cues.
- Add `semanticsLabel: stretch.name` to visuals; show static PNG instead of GIF when reduce-motion is on.
- Assign `headlineLarge` to Plus Jakarta Sans (currently falls back to Inter).
- Delay the post-routine interstitial ~400 ms so the "Nicely done!" screen renders first.
- Add an **exit-routine confirmation** dialog (accidental close loses the whole routine).

### P1 — soon after launch
- **Search** (or a "Browse all stretches" list) — 45 stretches behind a 9-category taxonomy are hard to find.
- **Level filter chips** (Gentle/Standard/Deeper) on the body-part screen, alongside prop chips.
- **Completion screen** with real feedback: time, # stretches, updated streak, weekly dot.
- **Routine detail preview** (see the stretches before starting) + a **thumbnail of the next stretch** on the rest screen.
- **Reduce-motion toggle** + **Rate-this-app** in Settings; add the missing leading icon on "Large text."
- Unify illustration backgrounds to the 5 defined brand tints (kill the "patchwork" look).

### P2 — bigger bets
- **Commit to ONE character language and render all 45** (the consensus blocker, see debate).
- 9 **custom body-part icons** (anatomical silhouettes) to replace stock Material icons.
- **Onboarding personalization**: 2 extra slides (available props, daily-reminder opt-in) → better "today's pick."
- **"Quick Relief" mode** (UX's bold idea): tap a body silhouette where it hurts → instant 3-stretch micro-routine. Collapses the whole discovery funnel into one gesture — potentially the stickiest feature.
- **App icon redesign** (clearer stretching silhouette + a second accent color so it reads at 60 px).
- **Completion "bloom"** (Visual's signature moment): the timer ring expands into a teal→amber bloom — a 2-second, screenshot-worthy reward.

---

## Bottom line
The bones are strong — clean architecture, a real design system, a thoughtful large-text floor
(the accessibility auditor's favorite decision). The gaps are mostly **finishing** the designed-but-
unbuilt details (timer controls, exit confirm, reduce-motion, completion feedback) and making one
**decisive visual choice** so all 45 stretches look like one app. Most P0 items are quick code changes
we can do immediately.

---

## All-Ages Legibility & Trust Pass (Demo-Hero Redesign)

*Senior UI/UX + UX-research critique, June 2026. Context: a new `DemoPlayer` widget now plays a
looping human video demo on the Stretch Detail and Routine Player screens, synced to the hold timer
(`onRunningChanged` pauses the clip when the timer pauses). The strategic goal — backed by
`docs/MARKET-RESEARCH.md` — is to make that demo the unmistakable **hero**, answer the recurring
"am I doing it right?" worry inline, and tune every screen for the under-served 50+ / all-ages
audience the premium athletic apps ignore. All recommendations reuse existing tokens
(`AppSpacing`, `AppRadii`, `AppColors`, `theme.colorScheme`) — no hardcoded hex — and preserve the
large-text 1.3×, reduce-motion, 48dp-target, and WCAG-AA guarantees already in place.*

### Why this pass exists (research → design)
The market split is clean: premium apps (StretchIt, Pliability) win trust with **real-human video +
narrated breathing/form cues**; the free tier (Bend, Leap) ships **illustration only** and eats the
"illustrations disrupt the flow / I can't tell if I'm doing it right" complaint. StretchHome's
`DemoPlayer` is the wedge that closes that gap cheaply — *but only if the demo is visually dominant
and captioned with a form cue.* Today it isn't: on the detail screen the demo is a 320px square that
shares equal billing with a pile of info pills, and the actual hold timer + breathing cue live far
below it, so during the hold the user is watching a small looping clip with the "am I doing it
right?" answer scrolled off-screen. The 50+ segment also needs bigger type, bigger targets, and
gentle-first framing — none of which the current screens lean into.

### Findings by screen

**Stretch Detail (`stretch_detail_screen.dart`) — the demo is not yet the hero.**
- The layout order is demo → info pills (`Wrap`) → "Start hold" button / timer → level toggle →
  steps → breathing callout. The breathing cue (the single most useful "am I doing it right?" signal
  during a hold) is a callout *below the steps* — invisible while holding. The level toggle sits
  *under* the timer, so users discover gentle/standard/deeper only after starting.
- The demo and the timer are two separate, vertically distant elements. During the hold the eye has
  to ping-pong between a small clip (top) and a ring (mid-screen). They should read as **one hero
  block**: demo on top, timer + live breathing cue immediately under it, nothing else between.
- `_infoPill` and the breathing/level callouts use `bodySmall`/`bodyMedium` with
  `onSurfaceVariant` — fine for AA but small for older eyes when they carry the *primary* form
  information.
- There is **no form-cue caption on the demo**. The schema has no `formCue` field, but
  `breathingCue` + the first `commonMistakes` entry are perfect raw material for a 3–5 word overlay
  ("Keep your back flat", "Ease in on the exhale").

**Routine Player (`routine_player_screen.dart`) — closer, but demo is the smallest element.**
- The active layout is name → side label → demo (200px) → timer ring → breathing cue. Good that the
  breathing cue is already under the ring. But the demo is capped at 200px and sits *above* a
  full-size ring, so the **timer**, not the demo, is the largest thing on screen — backwards for a
  watch-don't-read player. The hero clip should be the dominant block, the ring its companion.
- Progress is a thin `LinearProgressIndicator` + "2/7". For all-ages glanceability this is fine, but
  the breathing cue could be promoted (size/weight) since it's the live coaching line.
- Rest screen shows the *next* stretch as a static `VisualPlaceholder` — good, keep it.

**Home (`home_screen.dart`) — clear but cool; under-uses warmth & gentle framing.**
- Greeting is `bodyMedium` + `headlineSmall` "Time to stretch" — competent but generic. No name, no
  gentle-first reassurance, no "all ages / go at your own pace" trust signal that the research says
  converts the 50+ buyer.
- Body-part grid uses `childAspectRatio: 0.9` with `titleMedium` names clipped at `maxLines: 2 +
  ellipsis`. At 1.3× the longer names ("Shoulders & Upper Back", "Quads & Hip Flexors") risk
  clipping — the design system explicitly forbids ellipsis on names. (Flagged before; still live in
  `body_part_card.dart`.)
- "Today's Pick" card is teal-on-white with white70 sub-text — verify the `white70` description and
  the `white` meta row clear AA on `scheme.primary`; `white70` on teal is borderline.

**Hold Timer Ring (`hold_timer_ring.dart`) — solid; minor all-ages tuning.**
- Controls are labeled 48dp `IconButton`s — good. The design system asks for a **56dp** primary
  pause/resume; it's currently a default-size `IconButton.filledTonal`. Bump the primary control.
- The center label (`centerLabel`) is `bodyMedium` on `onSurfaceVariant` — readable, but the "hold /
  each side" context could be slightly larger for seniors.

### Prioritized punch-list

#### P0 — do now (make the demo the hero + form-confidence + all-ages legibility)
1. **Stretch Detail: fuse demo + timer + breathing into one hero block, demo on top.**
   Reorder so the demo (enlarge the `maxWidth`/`maxHeight` from 320 toward the available width, it's
   the focal point), then *immediately* the hold timer, then the **live breathing cue** directly
   under the ring (move it up from below the steps). Push info pills (duration, props, muscles) and
   the level toggle *above* the demo or into a compact row, and the steps/mistakes/safety *below*
   the hero. Goal: while holding, the user sees demo + ring + breathing with zero scrolling.
   *Why: watch-don't-read; answers "am I doing it right?" at the exact moment of use.*
2. **Add an inline form-cue caption overlaid on / directly under the demo.**
   Show a 3–5 word cue sourced from `breathingCue` (or the first `commonMistakes` item rephrased
   positively) in a pill at the bottom of the `DemoPlayer` box — `labelMedium`/`titleSmall`,
   `scheme.onSurface` on a `scheme.surface` scrim at ~85% alpha, `AppRadii.chip`. Honor reduce-motion
   (static, no fade). *Why: this is the highest-leverage trust upgrade per the research — it closes
   the form-feedback gap an illustration-only competitor can't.*
3. **Surface the breathing cue prominently during the hold (both screens).**
   On Detail and in the Routine Player, render the breathing cue right under the ring at
   `titleMedium`/`bodyLarge` weight in `scheme.primary` (not buried `bodyMedium`/`onSurfaceVariant`),
   with `Semantics(liveRegion: true)`. *Why: breathing guidance is the calm, trust-building coaching
   line; it must be legible mid-stretch for all ages.*
4. **Routine Player: make the demo the dominant block, not the ring.**
   Raise the demo's `maxWidth/maxHeight` (200 → larger, scaled to available height) and let the ring
   be the secondary companion. *Why: a watch-don't-read player should lead with the body, not the
   clock.*
5. **Clarify gentle/standard/deeper and move it above the hero on Detail.**
   Add a short label above the `SegmentedButton` ("Choose your intensity — go only as far as is
   comfortable") and place the toggle *before* the demo/timer so users pick intensity first. Keep the
   selected segment `scheme.primary`. *Why: form-confidence + gentle-first framing for seniors;
   "never implies the user is doing it wrong" (design principle 1.3).*
6. **Bigger tap target on the primary timer control.**
   Make the pause/resume `IconButton.filledTonal` 56dp (per design system §8.2) while Restart/Skip
   stay 48dp. *Why: the most-used control in the most critical moment, for motor/older users.*
7. **Body-part card: remove `maxLines: 2 + ellipsis` clip; let cards grow.**
   In `body_part_card.dart`, drop the ellipsis on `bodyPart.name` and let the card reflow at 1.3×+.
   *Why: design system forbids clipping names; this is the exact senior audience. (Still unfixed.)*
8. **Home: warm, gentle-first greeting + trust line.**
   Replace "Time to stretch" with a warmer, all-ages line and add a quiet sub-line such as
   "Gentle stretches for every body — go at your own pace" in `bodyMedium`/`onSurfaceVariant`.
   *Why: research says gentle, no-pressure framing is the conversion lever for the 50+ segment.*

#### P1 — soon
9. Detail: give the demo a real form-cue *pill row* that can rotate 1–2 cues (breathing + one
   positive form cue) on a slow cross-fade synced to nothing (or to phases later); reduce-motion =
   first cue only.
10. Routine Player: promote the side label + a thumbnail of the current demo into a tighter header so
    the body-block owns more vertical space; consider an "auto-advance off" affordance for users who
    need more time (cognitive/motor accessibility, design system §8.7).
11. Verify "Today's Pick" `white70` text meets AA on `scheme.primary`; if borderline, switch to a
    surface-tinted card with `onSurface` text or raise opacity.
12. Add a one-line "designed to be gentle / no equipment needed" trust strip on Home or the body-part
    screen (research §3 trust signals).
13. Bump `centerLabel` and `durationLabel` legibility a notch for seniors; ensure the ring grows to
    260dp in large-text mode (design system §8.4).

#### P2 — later
14. Add a real `formCue` (and optional `cuesByLevel`) field to the stretch schema + model so the
    overlay isn't reusing `breathingCue`/`commonMistakes` — authored, level-aware cues.
15. Optional second demo angle (front + side) toggle on Detail to mirror StretchIt's multi-angle
    trust signal cheaply (research §6.3).
16. "Wrong vs right" still callout beside the demo for the 5–6 stretches where position is most
    ambiguous.
17. Once all 45 clips exist, ensure ONE consistent demonstrator/background (ties to the unresolved
    "one visual language" blocker above).

### Bottom line
The `DemoPlayer` is the right strategic bet, but on the Detail screen the demo isn't yet the hero and
the form/breathing guidance is scrolled out of view during the hold. The P0 work is mostly
**re-ordering and re-weighting existing widgets** — fuse demo + timer + breathing into one hero block,
caption the demo with a form cue, promote the breathing line, enlarge the demo in the player, and warm
up Home — all with existing tokens and zero new dependencies. That turns "watch-don't-read" and
"am I doing it right?" from aspirations into the screen's center of gravity.
