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
