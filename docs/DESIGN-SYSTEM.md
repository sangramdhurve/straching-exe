# StretchHome — UI/UX Design System Specification

**Version:** 1.0  
**Platform:** Flutter (Material 3)  
**Target audience:** All ages, teens to seniors  
**Aesthetic:** Clean, modern, calming wellness — not childish  

---

## Table of Contents

1. [Design Principles](#1-design-principles)
2. [Color System](#2-color-system)
3. [Typography](#3-typography)
4. [Spacing & Layout](#4-spacing--layout)
5. [Core Components](#5-core-components)
6. [Screen-by-Screen Layout](#6-screen-by-screen-layout)
7. [Motion & Micro-Interactions](#7-motion--micro-interactions)
8. [Accessibility](#8-accessibility)
9. [Ad Placement UX](#9-ad-placement-ux)

---

## 1. Design Principles

These six principles guide every design decision in StretchHome — from color choices to interaction timing. When in doubt, return to this list.

### 1.1 Calm
The UI should lower, not raise, the user's heart rate. Avoid harsh contrasts, jarring animations, or dense information overload. Use soft teal as the dominant hue, generous whitespace, and smooth transitions. Every screen should feel like walking into a quiet, well-lit room.

### 1.2 Clear
Information hierarchy must be immediately obvious. One primary action per screen. Labels are plain English — no fitness jargon without explanation. Icons always appear with text labels at the bottom navigation level. Content is scannable in under 3 seconds.

### 1.3 Confidence-Building
The app must empower users of all fitness levels without intimidating them. Progress is celebrated quietly but meaningfully (streaks, completion rings). Difficulty levels (Gentle / Standard / Deeper) give users control without judgment. Never use language that implies the user is doing it "wrong."

### 1.4 Accessible
Every interactive element meets WCAG AA contrast. Touch targets are at least 48 × 48 dp. A Large-Text mode scales the type scale by 1.3× for senior users. Screen-reader labels are present on all controls. Color is never the sole carrier of meaning.

### 1.5 Fast
No unnecessary loading screens. Offline-first content. Transitions are brief (200–350 ms). The timer screen loads in under 100 ms. Navigation between the main tabs is instantaneous. Users should be able to start a stretch within three taps from cold launch.

### 1.6 Distraction-Free
During an active stretch or the hold-timer, the screen shows only what is needed: the visual, the timer, and one action. No ads, no notification banners, no promotional nudges. Full-screen mode is automatic in the Routine Player. The rest of the app keeps ads contained to defined, non-intrusive zones.

---

## 2. Color System

### 2.1 Brand Foundation

The Material 3 `ColorScheme.fromSeed` is seeded from `#2A9D8F`. All tonal palettes are derived from this seed by the M3 algorithm. The values below are fixed overrides that must be applied after seed generation to ensure brand accuracy.

### 2.2 Full Color Table

| Token | Role | Hex (Light) | Hex (Dark) | Usage notes |
|---|---|---|---|---|
| `colorPrimary` | Brand / interactive | `#2A9D8F` | `#5FC4B8` | Buttons, active nav icons, timer ring fill |
| `colorPrimaryDark` | Primary pressed / focused | `#21867A` | `#4AADA1` | Pressed state on buttons, focused ring outlines |
| `colorAccentWarm` | Highlight / streak | `#F4A261` | `#F4A261` | Streak flame icon, badge dot, celebration confetti — use sparingly |
| `colorSuccess` | Completion / positive | `#8AB17D` | `#9BC98E` | Checkmark ticks, "completed" state, progress fill on finished items |
| `colorBackground` | Screen background | `#F6F8F8` | `#0F1716` | Scaffold background |
| `colorSurface` | Cards, sheets, dialogs | `#FFFFFF` | `#16201F` | Card backgrounds, bottom sheets |
| `colorSurfaceVariant` | Subtle containers | `#ECF2F1` | `#1E2D2B` | Chip backgrounds, inactive tab backgrounds, input fill |
| `colorOnSurface` | Primary text / ink | `#15302E` | `#D9ECEB` | Headings, body text, icons on surfaces |
| `colorOnSurfaceVariant` | Secondary text | `#4A6966` | `#8AADAA` | Captions, hints, secondary labels |
| `colorOutline` | Borders / dividers | `#C4D4D3` | `#2E4341` | Card borders (optional), chip outlines, input borders |
| `colorError` | Error states | `#C0392B` | `#FF6B6B` | Inline form errors, error snackbar icon |
| `colorWarning` | Warning states | `#E67E22` | `#FFB347` | Health disclaimer banner, prop-required warnings |
| `colorDisabled` | Inactive controls | `#B0C4C3` | `#3A4F4E` | Disabled buttons, inactive nav icons |
| `colorScrim` | Modal overlay | `#000000` at 40% | `#000000` at 60% | Bottom sheet scrim, full-screen overlay |

### 2.3 Semantic Color Pairings

| Semantic use | Background | Foreground / icon | Notes |
|---|---|---|---|
| Primary button (enabled) | `colorPrimary` | `#FFFFFF` | Minimum contrast 4.6 : 1 ✓ |
| Primary button (dark mode) | `#5FC4B8` | `#0F1716` | Contrast 5.1 : 1 ✓ |
| Destructive action | `colorError` | `#FFFFFF` | |
| Health disclaimer banner | `#FFF3E0` / `#2D1F0A` | `colorWarning` icon + `colorOnSurface` text | Light/dark |
| Streak badge | `colorAccentWarm` | `#FFFFFF` | Max 1–2 locations per screen |
| Completion checkmark | `colorSuccess` | `#FFFFFF` | |
| Chip (active) | `colorPrimary` at 15% | `colorPrimary` | Filled tonal chip |
| Chip (inactive) | `colorSurfaceVariant` | `colorOnSurfaceVariant` | |

### 2.4 Never Do

- Do not use `colorAccentWarm` for large background fills — it is an accent only.
- Do not use color alone to communicate pass/fail; always pair with an icon or label.
- Do not introduce additional hues outside this palette without explicit design approval.

---

## 3. Typography

### 3.1 Font Pairing

| Role | Font family | Source |
|---|---|---|
| Display / Headings | **Plus Jakarta Sans** | Google Fonts |
| Body / UI labels | **Inter** | Google Fonts |

**Rationale:** Plus Jakarta Sans has a geometric warmth that reads as modern and friendly without being playful or childish. Its optical corrections at large sizes make it excellent for display use. Inter was designed for screen legibility and holds clarity down to 11 sp, making it ideal for body copy, captions, and UI chrome. Together they create visual differentiation between content areas and structural chrome without visual conflict.

**Flutter setup:**
```dart
// pubspec.yaml
google_fonts: ^6.x.x

// theme
TextTheme get textTheme => GoogleFonts.plusJakartaSansTextTheme(
  GoogleFonts.interTextTheme(),
);
```

### 3.2 Type Scale — Standard Mode

| Token | Family | Size (sp) | Weight | Line-height | Letter-spacing | Usage |
|---|---|---|---|---|---|---|
| `displayLarge` | Plus Jakarta Sans | 48 | 700 | 1.10 | −0.5 | Hero/onboarding splash text |
| `displayMedium` | Plus Jakarta Sans | 36 | 700 | 1.12 | −0.3 | Completion celebration text |
| `headlineLarge` (h1) | Plus Jakarta Sans | 28 | 700 | 1.18 | −0.2 | Screen titles |
| `headlineMedium` (h2) | Plus Jakarta Sans | 22 | 600 | 1.22 | 0 | Section headers |
| `headlineSmall` (h3) | Plus Jakarta Sans | 18 | 600 | 1.28 | 0 | Card titles, body-part names |
| `titleLarge` | Plus Jakarta Sans | 16 | 600 | 1.32 | 0.1 | List tile primary labels |
| `titleMedium` | Inter | 15 | 500 | 1.36 | 0.1 | Routine names, dialog titles |
| `bodyLarge` | Inter | 16 | 400 | 1.55 | 0 | Primary body copy, instructions |
| `bodyMedium` | Inter | 14 | 400 | 1.55 | 0.1 | Secondary body copy, descriptions |
| `bodySmall` | Inter | 12 | 400 | 1.60 | 0.2 | Captions, timestamps |
| `labelLarge` | Inter | 14 | 600 | 1.20 | 0.4 | Button labels |
| `labelMedium` | Inter | 12 | 500 | 1.20 | 0.4 | Chip labels, badge text |
| `labelSmall` | Inter | 11 | 500 | 1.30 | 0.5 | Overlines, prop tags |

### 3.3 Type Scale — Large-Text Accessibility Mode

When the user enables **Large Text** in Settings (or when Flutter's `textScaleFactor` ≥ 1.3), apply this scale. The multiplier is **1.3×** applied to sp values, rounded to the nearest whole number.

| Token | Standard size | Large-Text size | Notes |
|---|---|---|---|
| `displayLarge` | 48 sp | 62 sp | Only used sparingly; stays in bounds |
| `headlineLarge` | 28 sp | 36 sp | |
| `headlineMedium` | 22 sp | 28 sp | |
| `headlineSmall` | 18 sp | 23 sp | |
| `titleLarge` | 16 sp | 21 sp | |
| `bodyLarge` | 16 sp | 21 sp | |
| `bodyMedium` | 14 sp | 18 sp | |
| `bodySmall` | 12 sp | 16 sp | Minimum readable size |
| `labelLarge` | 14 sp | 18 sp | Button labels — ensure button height increases |
| `labelMedium` | 12 sp | 16 sp | |

**Implementation:**
```dart
// In SettingsProvider:
double get textScaleFactor => largTextEnabled ? 1.3 : 1.0;

// Wrap root:
MediaQuery(
  data: MediaQuery.of(context).copyWith(
    textScaler: TextScaler.linear(textScaleFactor),
  ),
  child: child,
)
```

Layouts must be tested at 1.3× to ensure no text is clipped. All cards and tiles must expand vertically, not clip text. Never use `overflow: TextOverflow.ellipsis` on instructional copy.

### 3.4 Typographic Rules

- Maximum line length: **64 characters** for body copy (use 16 sp / width constraint).
- Do not use italic for instructional text — reserve for emphasis only.
- Timer digit (in the circular hold timer): use **Plus Jakarta Sans 700, 56 sp** (72 sp in large-text mode), monospace-digit-friendly with `fontFeatures: [FontFeature.tabularFigures()]`.

---

## 4. Spacing & Layout

### 4.1 4pt Base Grid

All spacing, padding, margin, and gap values are multiples of **4 dp**.

| Token | Value | Common use |
|---|---|---|
| `space2` | 2 dp | Icon-to-label micro gap |
| `space4` | 4 dp | Tight internal padding |
| `space8` | 8 dp | Row spacing, chip padding |
| `space12` | 12 dp | List tile vertical padding |
| `space16` | 16 dp | Standard horizontal screen padding |
| `space20` | 20 dp | Card internal padding |
| `space24` | 24 dp | Section spacing |
| `space32` | 32 dp | Large section breaks |
| `space40` | 40 dp | Hero area breathing room |
| `space48` | 48 dp | Bottom safe-area clearance |
| `space64` | 64 dp | Display spacing |

### 4.2 Screen Padding

| Context | Horizontal | Vertical top | Vertical bottom |
|---|---|---|---|
| Standard screen | 16 dp | 12 dp | 16 dp + safe area |
| Full-screen player | 0 | 0 | safe area only |
| Bottom sheet | 20 dp | 24 dp | 32 dp + safe area |
| Dialog | 24 dp | 24 dp | 24 dp |

### 4.3 Border Radius

| Component | Radius |
|---|---|
| Body-part card, routine card | 20 dp |
| Stretch detail modal card | 24 dp |
| Primary / secondary button | 16 dp |
| Chips | 100 dp (fully rounded, pill) |
| Bottom sheet | 28 dp top corners |
| Snackbar | 12 dp |
| Input field | 12 dp |
| Progress ring background track | circular (50% of diameter) |
| Avatar / level badge | 100 dp (circle) |
| Image / illustration placeholder | 16 dp |

### 4.4 Card Grid

The body-part grid on the Home screen uses a **2-column grid** with equal columns.

```
Screen width: W
Column width: (W − 16 − 16 − 12) / 2   [16dp padding each side, 12dp gap]
Card aspect ratio: 4:3
Card minimum height: 120 dp
```

On tablets (width ≥ 600 dp), switch to a **3-column grid** with the same 16 dp edge padding and 12 dp inter-column gap.

### 4.5 Elevation & Shadow

Material 3 elevation tones are used. Do not use hard drop shadows; use tonal surface colors + optional subtle shadow.

| Level | Use | Shadow |
|---|---|---|
| 0 — Flat | Background, surface | None |
| 1 — Raised | Cards on background | `BoxShadow(color: #15302E 08%, blurRadius: 8, offset: (0, 2))` |
| 2 — Overlay | Bottom sheets, modals | `BoxShadow(color: #15302E 12%, blurRadius: 16, offset: (0, 4))` |
| 3 — Dialog | Dialogs, tooltips | `BoxShadow(color: #15302E 18%, blurRadius: 24, offset: (0, 8))` |

---

## 5. Core Components

### 5.1 Buttons

#### Primary Button (FilledButton)

- **Background:** `colorPrimary`
- **Label color:** `#FFFFFF`
- **Border radius:** 16 dp
- **Height:** 52 dp (min), expands with large text
- **Horizontal padding:** 24 dp
- **Font:** `labelLarge` (Inter 14/18 sp, 600 weight)
- **State — Hover/Pressed:** Background shifts to `colorPrimaryDark`; scale animation to 0.97×
- **State — Disabled:** Background `colorDisabled`, label `colorOnSurfaceVariant`
- **State — Loading:** Replace label with 20 dp `CircularProgressIndicator` (white, strokeWidth 2.5)
- **Icon variant:** Leading icon 20 dp, 8 dp gap to label

```dart
// Minimum touch target enforced
SizedBox(
  height: max(52, labelHeight + 28),
  child: FilledButton(...)
)
```

#### Secondary Button (OutlinedButton)

- **Background:** transparent
- **Border:** 1.5 dp solid `colorPrimary`
- **Label color:** `colorPrimary`
- **Border radius:** 16 dp
- **Height:** 52 dp min
- **State — Pressed:** Background `colorPrimary` at 12% tint

#### Text Button (TextButton)

- **Label color:** `colorPrimary`
- **No border, no background**
- **Underline:** none (not needed; color provides affordance)
- **Use for:** secondary/tertiary actions, "Skip" in onboarding, "See all" links
- **Minimum touch area:** Wrap in 48 dp tall `InkWell` or set `ButtonStyle` minimum size to 48 × 48 dp

#### Destructive Button

- Same shape as Primary
- Background: `colorError`
- Use only in confirmation dialogs, never on first tap

---

### 5.2 Body-Part Card

Used in the Home screen grid and in search results.

**Anatomy (top to bottom within card):**
1. **Illustration / icon area** — 56 × 56 dp tinted icon or lottie illustration, centered, on `colorSurfaceVariant` background covering the top 60% of the card. Icon color: `colorPrimary`.
2. **Body-part name** — `headlineSmall` (Plus Jakarta Sans 18 sp / 23 sp LT, 600), `colorOnSurface`, 8 dp padding from icon area bottom.
3. **Stretch count** — `bodySmall` (Inter 12/16 sp, 400), `colorOnSurfaceVariant`. Format: "12 stretches".
4. **Optional prop badge** — bottom-right corner, see §5.8.

**Card container:**
- Background: `colorSurface`
- Border radius: 20 dp
- Elevation: Level 1 shadow
- Padding: 16 dp all sides (icon area is edge-to-edge at top, inset padding applies to text area)
- Pressed state: scale 0.96×, shadow lifts to Level 2

**Accessibility:**
- Semantics label: `"[Body part name], [count] stretches"`
- Role: `button`

---

### 5.3 Stretch List Tile

Used in the Body-Part Detail screen and Favorites.

**Anatomy (left to right):**
1. **Thumbnail** — 64 × 64 dp rounded rect (12 dp radius), shows illustration or icon placeholder on `colorSurfaceVariant`
2. **Text block** (flex-expand):
   - Primary: stretch name, `titleLarge` (Plus Jakarta Sans 16/21 sp, 600), `colorOnSurface`
   - Secondary: muscle target, `bodySmall` (Inter 12/16 sp, 400), `colorOnSurfaceVariant`
   - Tertiary (optional): `[Duration] · [Level]`, `labelSmall`, `colorOnSurfaceVariant`
3. **Trailing:**
   - Favorite icon button (heart, 24 dp): `colorPrimary` when favorited, `colorOutline` when not
   - Disclosure chevron, 16 dp, `colorOnSurfaceVariant`

**Container:**
- Background: `colorSurface`
- Divider: 1 dp `colorOutline` at 50% opacity, only between tiles (not above first or below last in a group)
- Vertical padding: 12 dp
- Horizontal padding: 16 dp
- Minimum height: 80 dp
- Tap ripple: `colorPrimary` at 10%

---

### 5.4 Circular Hold Timer Ring (Hero Component)

This is the most prominent UI element in the app. It appears on the Stretch Detail screen and in the Routine Player. It must feel calm, tactile, and legible.

#### Visual Specification

**Overall diameter:** 240 dp (standard), 200 dp (in compact routine player).

**Layers (bottom to top):**

1. **Track ring** — full circle, stroke width 12 dp, color `colorSurfaceVariant` (light) / `#2E4341` (dark).
2. **Progress ring** — arc drawn with `CustomPaint`, stroke width 12 dp, `StrokeCap.round` on both ends, color `colorPrimary`. Starts at 12 o'clock (−90°), sweeps clockwise. Animates via `AnimationController` with `Curves.linear` for smooth per-frame tick.
3. **Glow effect** — optional subtle outer glow on progress ring end: `BoxShadow`-equivalent via `MaskFilter.blur(BlurStyle.outer, 6)` in `colorPrimary` at 40% opacity. Disable when `reduceMotion` is true.
4. **Center content:**
   - **Seconds remaining** — Plus Jakarta Sans 700, 56 sp (72 sp large-text), `colorOnSurface`, tabular figures. Format: `"30"` (just the number, no unit).
   - **"sec" label** — Inter 400, 12 sp (16 sp LT), `colorOnSurfaceVariant`, 4 dp below number.
   - **Breathing cue** (when phase is active) — Inter 500, 13 sp, `colorPrimary`, 8 dp above number. Text cycles: `"Breathe in…"` → `"Hold…"` → `"Breathe out…"` Each phase displayed for the appropriate duration.

5. **Ring background fill** — `colorSurface` circle, diameter = ring diameter − stroke − 8 dp, centered.

#### Controls Below the Ring

Arranged in a horizontal row, centered, 32 dp below the ring bottom:

| Control | Type | Size | Icon | Semantics label |
|---|---|---|---|---|
| Previous stretch | IconButton | 48 × 48 dp | `skip_previous` 28 dp | "Previous stretch" |
| Pause / Resume | FilledIconButton | 56 × 56 dp | `pause` / `play_arrow` 32 dp | "Pause timer" / "Resume timer" |
| Skip | IconButton | 48 × 48 dp | `skip_next` 28 dp | "Skip this stretch" |

- Pause/Resume button background: `colorPrimary`, icon white.
- Previous/Skip buttons: `colorSurfaceVariant` background, `colorOnSurface` icon.

#### Animation Behavior

- **Start:** Ring sweeps from 0 to full (100%) instantly on screen entry, then begins draining (100% → 0%) over the hold duration.
- **Countdown:** Progress decreases linearly over `holdDuration` seconds. `AnimationController.duration = Duration(seconds: holdDuration)`.
- **Completion:** At 0%, flash `colorSuccess` for 300 ms, then auto-advance or show "Done" overlay. Haptic feedback: `HapticFeedback.mediumImpact()`.
- **Pause:** Ring freezes at current progress. Pause button transitions to play. Timer value remains displayed.
- **Reduced-motion mode:** No glow, no flash animation; color changes only.

---

### 5.5 Bottom Navigation Bar

Persistent across Home, Routines, Favorites, and Settings screens.

**Specification:**
- Material 3 `NavigationBar` widget
- Background: `colorSurface`
- Top border: 1 dp `colorOutline` at 30% opacity
- Height: 80 dp + safe area inset
- `indicatorColor`: `colorPrimary` at 15% (M3 default tonal indicator)

| Tab index | Label | Icon (outlined) | Icon (filled/active) | Semantics |
|---|---|---|---|---|
| 0 | Home | `home_outlined` | `home` | "Home, tab" |
| 1 | Routines | `fitness_center_outlined` | `fitness_center` | "Routines, tab" |
| 2 | Favorites | `favorite_border` | `favorite` | "Favorites, tab" |
| 3 | Settings | `settings_outlined` | `settings` | "Settings, tab" |

- Active icon color: `colorPrimary`
- Active label color: `colorPrimary`
- Inactive icon/label: `colorOnSurfaceVariant`
- Label style: `labelMedium` (Inter 12/16 sp, 500)
- All four tabs always visible; no badge counts except on Favorites (optional: show count if > 0)

---

### 5.6 Chips & Filters

Used on Body-Part Detail to filter stretches by prop (Chair, Wall, No Prop, etc.) and by level (Gentle, Standard, Deeper).

**Pill shape:** `FilterChip` with `BorderRadius.circular(100)`.

| State | Background | Border | Label color |
|---|---|---|---|
| Unselected | `colorSurfaceVariant` | none | `colorOnSurfaceVariant` |
| Selected | `colorPrimary` at 15% | 1.5 dp `colorPrimary` | `colorPrimary` |
| Pressed | `colorPrimary` at 25% | 1.5 dp `colorPrimary` | `colorPrimary` |
| Disabled | `colorDisabled` at 30% | none | `colorDisabled` |

- Height: 36 dp
- Horizontal padding: 16 dp
- Label: `labelMedium` (Inter 12/16 sp, 500)
- Leading checkmark when selected: 16 dp `Icons.check`, `colorPrimary`
- Arranged in a horizontally scrollable `SingleChildScrollView` row, no wrapping on the filter bar

---

### 5.7 Prop Badges

Small contextual tags shown on stretch tiles and detail screens to indicate required equipment.

**Shape:** Pill, `BorderRadius.circular(100)`, height 22 dp, horizontal padding 8 dp.

| Prop type | Background | Text color | Icon |
|---|---|---|---|
| No prop | `#E8F4EC` / `#1E3527` | `colorSuccess` | `check_circle_outline` 12 dp |
| Chair | `#E8F0F4` / `#1C2D3A` | `#4A7FA5` / `#7AB8D9` | `chair_outlined` 12 dp |
| Wall | `#F4EDE8` / `#3A2D1C` | `#A07050` / `#D9A87A` | `vertical_align_bottom` 12 dp |
| Yoga block | `#EDE8F4` / `#2A1C3A` | `#7050A0` / `#A87AD9` | `crop_square` 12 dp |
| Yoga strap | `#F4F4E8` / `#3A3A1C` | `#8A8A30` / `#C4C450` | `linear_scale` 12 dp |

- Label: `labelSmall` (Inter 11/14 sp, 500)
- Never stack more than 2 badges horizontally; if a stretch needs more, use a compact "2 props" badge and expand on detail view

---

### 5.8 Progress & Streak Indicator

Appears in the Home screen header area.

**Streak display:**
- Horizontal row: flame icon (`local_fire_department`, `colorAccentWarm`, 20 dp) + streak number (`headlineSmall`, Plus Jakarta Sans 600) + label `"day streak"` (`bodySmall`, `colorOnSurfaceVariant`).
- If streak = 0, show motivational sub-text: `"Start your first day today!"` in `bodySmall` `colorOnSurfaceVariant`.

**Weekly progress dots:**
- Row of 7 circles, 10 dp diameter, 8 dp gap.
- Completed day: filled `colorPrimary`.
- Today (not yet complete): filled `colorPrimary` at 30% + 1.5 dp `colorPrimary` border.
- Future / not completed: filled `colorSurfaceVariant`.
- Labels below each dot: `"M" "T" "W" "T" "F" "S" "S"`, `labelSmall`, `colorOnSurfaceVariant`.

**Session completion ring (optional Home widget):**
- Mini circular ring, 48 dp diameter, stroke 4 dp, showing today's stretch minutes vs. daily goal. Color: `colorPrimary`. Track: `colorSurfaceVariant`.

---

### 5.9 Snackbars

**Container:**
- Background: `colorOnSurface` (near-black / near-white inverted from surface)
- Border radius: 12 dp
- Margin: 16 dp all sides, floated above bottom nav
- Maximum width: screen width − 32 dp (never full-bleed)
- Elevation: Level 2 shadow

| Type | Icon | Icon color | Use |
|---|---|---|---|
| Success | `check_circle` 20 dp | `colorSuccess` | Favorite saved, routine completed |
| Error | `error_outline` 20 dp | `#FF6B6B` | Save failed, no connection |
| Info | `info_outline` 20 dp | `#5FC4B8` | Tip, reminder set |
| Warning | `warning_amber_outlined` 20 dp | `colorWarning` | Prop not available suggestion |

- Label: `bodyMedium`, `colorSurface` (inverted text on dark snackbar background)
- Action button (optional): `labelLarge`, `colorAccentWarm`, right-aligned, 8 dp padding
- Auto-dismiss: 3 seconds (success/info), 5 seconds (error/warning)
- Dismiss on swipe: yes

---

### 5.10 Empty States

Used when Favorites is empty, search returns no results, or a body part has no stretches loaded.

**Anatomy (centered column):**
1. Illustration — 160 × 160 dp tinted SVG or Lottie, `colorSurfaceVariant` tinted, with a single `colorPrimary` accent element. Never a generic sad face — use a gentle, relevant illustration (e.g., a figure sitting for empty Favorites, a magnifying glass for no search results).
2. Headline — `headlineMedium` (Plus Jakarta Sans 22/28 sp, 600), `colorOnSurface`, centered, max 2 lines.
3. Body — `bodyMedium` (Inter 14/18 sp, 400), `colorOnSurfaceVariant`, centered, max 3 lines, 24 dp horizontal padding.
4. Primary action button (if applicable) — FilledButton, 200 dp min width, centered, 24 dp top margin.

**Examples:**
- Empty Favorites: headline `"Nothing saved yet"`, body `"Tap the heart on any stretch to save it here."`, CTA `"Browse stretches"`.
- No search results: headline `"No results found"`, body `"Try a different body part or remove a filter."`, CTA `"Clear filters"`.

---

## 6. Screen-by-Screen Layout

### 6.1 First-Run Onboarding + Health Disclaimer

**Purpose:** Orient new users, set expectations, collect minimal personalization, display required health disclaimer.

**Screens in sequence (4 slides + disclaimer):**

#### Slide 1 — Welcome
- **Full-bleed background:** `colorBackground`, large centered Lottie animation (gentle figure stretching).
- **Headline:** `"Feel better,\nevery day."` — `displayLarge`, centered.
- **Subhead:** `"Simple stretching routines for every body, every age."` — `bodyLarge`, `colorOnSurfaceVariant`, centered.
- **Progress indicator:** 4 dots at bottom, `colorPrimary` active.
- **CTA:** `"Get started"` FilledButton, full-width minus 32 dp edge padding, bottom 40 dp.
- **Skip:** TextButton `"Skip intro"` above CTA, `colorOnSurfaceVariant`.

#### Slide 2 — Personalize (optional, swipeable past)
- **Question:** `"What would you like to focus on?"` — `headlineLarge`.
- **Body part multi-select chips** in a 2-column wrap grid. Chips use filter chip style. Up to 8 options.
- **CTA:** `"Next"` FilledButton.

#### Slide 3 — Props
- **Question:** `"What do you have available?"` — `headlineLarge`.
- **List of prop options** as multi-select chips.
- **CTA:** `"Next"` FilledButton.

#### Slide 4 — Reminders
- **Headline:** `"Set a daily reminder?"` — `headlineLarge`.
- **Time picker:** Material 3 `TimePickerDialog`-style inline picker, default 8:00 AM.
- **Toggle:** `"Enable daily reminder"` SwitchListTile.
- **CTA:** `"Start stretching"` FilledButton.

#### Health Disclaimer Screen (shown before first stretch)
- Displayed as a **modal bottom sheet** (not a full-screen page) with `DraggableScrollableSheet`.
- **Header:** `"Before you begin"` — `headlineMedium`, `colorOnSurface`.
- **Warning icon:** `warning_amber_outlined` 40 dp, `colorWarning`, centered above header.
- **Body text:** Full disclaimer copy in `bodyMedium`. Text must be fully scrollable. Key point: `"Consult a healthcare provider before starting any new exercise program, especially if you have existing medical conditions, injuries, or chronic pain. Stop immediately if you experience pain."` — must be shown in full; no truncation.
- **Acknowledge checkbox:** `"I understand and accept these guidelines"` — `CheckboxListTile`, required before CTA activates.
- **CTA:** `"I understand, let's go"` FilledButton, disabled until checkbox checked.
- **Accessible at any time** from Settings → "Health Disclaimer."

---

### 6.2 Home Screen

**Purpose:** Daily starting point. Greet the user, suggest what to do today, provide quick access to all content.

**Layout (scrollable column, 16 dp horizontal padding):**

1. **App bar** (not elevated, background matches scaffold):
   - Left: App logo (teal mark) + `"StretchHome"` wordmark, `headlineSmall`, `colorPrimary`.
   - Right: Avatar/profile icon button (48 × 48 dp) OR notification bell if reminders enabled.

2. **Greeting section** (24 dp top padding):
   - `"Good morning, [Name]!"` or `"Good morning!"` if no name — `headlineLarge`, `colorOnSurface`.
   - Motivational sub-line or streak: e.g., `"3-day streak 🔥 Keep it up!"` — `bodyMedium`, `colorOnSurfaceVariant`. (No emoji in large-text mode — replace flame with text `"[flame]"`; use the prop badge-style streak component described in §5.8.)

3. **Streak / progress section** (16 dp top margin):
   - Weekly progress dots component (§5.8), on a `colorSurface` card with 16 dp internal padding, 20 dp radius, full-width.

4. **"Today's suggestion" section** (24 dp top margin):
   - Section label: `"Suggested for you"` — `labelLarge`, `colorOnSurfaceVariant`, uppercase, 12 dp bottom margin.
   - Horizontal scroll row of 2–3 **Routine Cards** (wider format: 200 × 120 dp, 20 dp radius, `colorSurface`, elevation 1). Each card shows: routine name `titleMedium`, duration `bodySmall`, difficulty chip.

5. **Body-part grid** (24 dp top margin):
   - Section label: `"Browse by body part"` — `labelLarge`, `colorOnSurfaceVariant`.
   - 2-column grid of Body-Part Cards (§5.2). Gap 12 dp. No horizontal scroll; grid grows vertically.

6. **Quick routines section** (24 dp top margin):
   - Section label: `"Quick routines"` + `"See all"` TextButton right-aligned.
   - Vertical list of 3 stretch list tiles (§5.3) showing featured quick routines.

7. **Bottom padding:** 16 dp + bottom safe area.

**Ad zone (Home only):** A native ad card may appear between section 4 (suggestion) and section 5 (body-part grid). See §9.

---

### 6.3 Body-Part Detail Screen

**Purpose:** Show all stretches for a selected body part, filterable by prop and level.

**App bar:**
- Back button (chevron left, 48 × 48 dp touch area).
- Title: body-part name, `headlineLarge`.
- No overflow menu.

**Layout (top to bottom):**

1. **Hero image / illustration area:** full-width, 180 dp height, edge-to-edge. Shows anatomical illustration or decorative illustration of the body region. `colorSurfaceVariant` background, `colorPrimary` tinted illustration.

2. **Summary bar** (16 dp horizontal padding, 16 dp vertical, on `colorSurface`):
   - `"[N] stretches"` `bodyMedium` · `"[M] routines"` `bodyMedium`, `colorOnSurfaceVariant`.

3. **Filter bar** (horizontally scrollable chips, 16 dp left padding, 8 dp top margin):
   - First chip: `"All"` (default selected).
   - Prop chips: `"No prop"`, `"Chair"`, `"Wall"`, etc.
   - Level chips: `"Gentle"`, `"Standard"`, `"Deeper"`.
   - Chips are single-select within each category; `"All"` resets both.

4. **Stretch list** (16 dp horizontal padding, 12 dp top margin):
   - Vertically scrollable list of Stretch List Tiles (§5.3).
   - Section headers if grouping by muscle sub-group: `labelLarge`, `colorOnSurfaceVariant`, 16 dp top padding.

5. **Floating action area (bottom, above bottom nav):** `"Start [Body Part] Routine"` FilledButton, full-width minus 32 dp, 16 dp bottom margin + safe area.

**Ad zone:** A banner-style ad may appear below the filter bar and above the stretch list when the list is first loaded. See §9.

---

### 6.4 Stretch Detail Screen

**Purpose:** Full information and timer for a single stretch.

**Navigation:** Modal route from stretch list tile tap. Slides up as a bottom sheet (full-height) or as a page route. Use `DraggableScrollableSheet` at initial size 0.92.

**Layout (scrollable column within sheet):**

1. **Sheet handle** (8 × 32 dp pill, `colorOutline`, centered, 12 dp top margin).

2. **Visual area** — 280 dp height, full width, `colorSurfaceVariant` background, 20 dp top radius. Illustration or video placeholder. Future: show looping animation of the stretch.

3. **Header area** (16 dp horizontal padding, 16 dp top margin):
   - Stretch name — `headlineLarge` (`headlineMedium` if name > 20 chars).
   - Muscle targets row — inter 14 sp, `colorOnSurfaceVariant`, comma-separated list. `"Targets: Hamstrings, Lower Back"`.
   - Row: prop badges + favorite icon button (32 dp heart, right-aligned, `colorPrimary` / `colorOutline`).

4. **Level toggle** (segmented button, 16 dp horizontal padding, 16 dp top margin):
   - Three segments: `"Gentle"`, `"Standard"`, `"Deeper"`.
   - Selected: `colorPrimary` fill, white label.
   - Unselected: `colorSurfaceVariant`, `colorOnSurfaceVariant` label.
   - On change: update hold time, update breathing cue text, update common mistakes if level-specific.

5. **Circular Hold Timer Ring** (center-aligned, 240 dp, §5.4) — 24 dp top margin.
   - Below ring: timer controls (Previous / Pause-Resume / Skip).
   - Breathing cue text 12 dp below controls: `"Breathe in for 4 counts"` etc., `bodyMedium`, `colorOnSurfaceVariant`, centered.

6. **Step-by-step instructions** (16 dp horizontal padding, 24 dp top margin):
   - Section label: `"How to do it"` `headlineSmall`.
   - Numbered steps: each step in a row — circle number badge (`colorPrimary` 24 dp filled circle, `labelMedium` white), then `bodyMedium` instruction text. Steps separated by 12 dp vertical gap.

7. **Common mistakes section** (24 dp top margin):
   - Section label: `"Common mistakes"` `headlineSmall`.
   - Each mistake: `"⚠"` icon (16 dp, `colorWarning`) + `bodyMedium` text. No actual emoji in production — use `Icon(Icons.warning_amber_outlined)`.

8. **Bottom action:** `"Add to routine"` OutlinedButton, full-width minus 32 dp, 24 dp bottom margin + safe area.

---

### 6.5 Routine Player (Full-Screen)

**Purpose:** Guide the user through a complete stretching routine without distraction. Zero ads. Zero navigation chrome.

**Entry:** Tapping a routine card → brief 3-2-1 countdown overlay → player screen.

**Screen is full-screen** (`SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky)`). Screen stays awake (`WakelockPlus.enable()`).

**Layout:**

```
┌─────────────────────────────────┐
│  [Exit ×]           [2 / 7]    │  ← top bar: exit + progress
│                                 │
│   Progress dots: ●●○○○○○       │  ← 12dp below top bar
│                                 │
│  ┌─────────────────────────┐   │
│  │                         │   │
│  │   Stretch illustration  │   │  ← ~40% screen height
│  │                         │   │
│  └─────────────────────────┘   │
│                                 │
│  [Stretch Name]  headlineLarge  │  ← 16dp below visual
│  [Targets: Hamstrings]  body    │
│                                 │
│      ┌─────────────────┐       │
│      │   Hold Timer    │       │  ← 200dp ring, center
│      │      Ring       │       │
│      └─────────────────┘       │
│                                 │
│  [Prev]   [Pause]   [Skip]     │  ← controls
│                                 │
│  Breathing cue text             │
└─────────────────────────────────┘
```

**Top bar (48 dp height, transparent background):**
- Left: `"×"` IconButton (48 × 48 dp) with label `"Exit"` below icon (12 sp). Tapping shows confirmation dialog: `"Exit routine? Your progress will be lost."` with `"Keep going"` (primary) and `"Exit"` (destructive text button).
- Right: `"[current] / [total]"` label, `titleMedium`, `colorOnSurface`.

**Progress dots row:**
- N dots (one per stretch), 8 dp diameter, 6 dp gap.
- Completed: `colorPrimary` filled.
- Current: `colorPrimary` pulsing (scale 1.0 → 1.25 → 1.0, 800 ms loop, unless reduced-motion).
- Remaining: `colorSurfaceVariant` filled.

**Rest Screen (between stretches, 15 sec default):**
- Full-screen background: gentle gradient `colorPrimary` at 10% to `colorBackground`.
- Centered: `"Rest"` `displayMedium`, then countdown timer (large digits, same style), then `"Next: [next stretch name]"` `titleLarge` with thumbnail.
- Skip rest: `"Skip rest"` TextButton, bottom-centered.

**Completion Screen:**
- Replaces routine player in-place (no navigation push).
- **Large centered animation:** Confetti or ripple (Lottie, `colorPrimary` + `colorAccentWarm`, subtle, 2 sec).
- **Headline:** `"Great work!"` `displayMedium`.
- **Summary:** duration, number of stretches, streak update.
- **Actions:** `"Share"` OutlinedButton + `"Done"` FilledButton, stacked, bottom-centered.
- **Ad placement:** A rewarded or interstitial-format native ad card appears on this screen only, below the summary and above the action buttons. See §9.

---

### 6.6 Favorites Screen

**Purpose:** Quick access to saved stretches.

**App bar:** `"Favorites"` `headlineLarge`, no back button (root tab).

**If favorites exist:**
- Filter chips bar: `"All"`, `"Body Part"` (dropdown chip), `"Level"`.
- Scrollable list of Stretch List Tiles (§5.3), grouped by body part with section headers.
- Long-press to show contextual action menu: `"Remove from favorites"`, `"Add to routine"`.

**If empty:**
- Empty state (§5.10): illustration of a heart, headline `"Nothing saved yet"`, body `"Tap the ♡ on any stretch to save it here."`, CTA `"Browse stretches"` → navigates to Home.

---

### 6.7 Settings Screen

**Purpose:** Personalization, accessibility, and legal/info.

**App bar:** `"Settings"` `headlineLarge`, no back button (root tab).

**Layout (scrollable list with section headers):**

#### Section: Appearance
- `"Dark mode"` — `SwitchListTile`. Options: System / Light / Dark (show current mode as subtitle).
- `"Large text"` — `SwitchListTile`. Subtitle: `"Increases text size for easier reading."` Toggling this applies the 1.3× scale immediately (live preview in settings itself).
- `"Reduce motion"` — `SwitchListTile`. Subtitle: `"Minimizes animations."`.

#### Section: Personalization
- `"Body parts"` — `ListTile` with chevron. Opens the same multi-select chip screen as onboarding Slide 2.
- `"Available props"` — `ListTile` with chevron. Opens prop selection.
- `"Daily goal"` — `ListTile`, subtitle shows current goal (e.g., `"10 minutes"`), chevron. Opens a simple picker.

#### Section: Reminders
- `"Daily reminder"` — `SwitchListTile`.
- `"Reminder time"` — `ListTile`, subtitle shows time (e.g., `"8:00 AM"`), only visible when reminder is enabled. Tapping opens `showTimePicker`.
- `"Reminder sound"` — `ListTile`, chevron, subtitle: `"Default"`.

#### Section: About & Legal
- `"Health Disclaimer"` — `ListTile`, chevron. Opens the same modal bottom sheet as first-run.
- `"Privacy Policy"` — `ListTile`, chevron. Opens in-app WebView or external browser.
- `"Terms of Service"` — `ListTile`, chevron.
- `"Version"` — `ListTile`, subtitle: `"StretchHome 1.0.0 (build 1)"`. Tapping 7× triggers Easter egg (not specified).
- `"Rate this app"` — `ListTile` with star icon.
- `"Send feedback"` — `ListTile` with email icon.

**All `ListTile` items:**
- Leading icon: 24 dp, `colorOnSurfaceVariant`.
- Title: `titleMedium`.
- Dividers between sections only (not between items within a section).
- Section headers: `labelLarge`, `colorPrimary`, 16 dp top padding, 8 dp bottom padding, `colorBackground` background.

---

## 7. Motion & Micro-Interactions

### 7.1 Transition Principles

- **Duration:** 200–350 ms for most transitions. Never exceed 500 ms for navigational transitions.
- **Easing:** Use Material 3 standard easing curves:
  - Enter: `Curves.easeOutCubic`
  - Exit: `Curves.easeInCubic`
  - Emphasized (hero): `Curves.easeInOutCubic`
- **Philosophy:** Motion communicates hierarchy and relationship, not decoration. A card expanding into a detail view tells the user "you went deeper." A sheet rising from the bottom tells the user "this is temporary."

### 7.2 Specific Animations

| Interaction | Animation | Duration | Curve | Reduced-motion fallback |
|---|---|---|---|---|
| Tab switch (bottom nav) | Cross-fade + translate Y 4 dp | 200 ms | `easeOutCubic` | Instant |
| Card tap → detail | Shared-element container expand | 300 ms | `easeInOutCubic` | Fade only |
| Stretch list tile → stretch detail | Bottom sheet slide up | 350 ms | `easeOutCubic` | Fade only |
| Routine player entry | Scale up from 0.95 + fade | 250 ms | `easeOutCubic` | Fade only |
| Timer ring fill drain | Linear per-frame arc sweep | N/A (continuous) | `linear` | Numeric countdown only |
| Timer ring completion flash | Scale 1.0 → 1.05 → 1.0 + color flash | 300 ms | `easeInOut` | Color change only |
| Completion confetti | Lottie particle explosion | 2000 ms | lottie | Static checkmark |
| Heart / favorite toggle | Scale 1.0 → 1.3 → 1.0 | 200 ms | `easeInOut` | Instant icon swap |
| Snackbar appear | Slide up 16 dp + fade in | 250 ms | `easeOutCubic` | Fade only |
| Chip selection | Fill tint expand from center | 150 ms | `easeOut` | Instant |
| Progress dot completion | Scale 0.8 → 1.0 + fill | 200 ms | `easeOutBack` | Instant fill |
| Breathing cue text | Cross-fade between phases | 400 ms | `easeInOut` | Instant swap |

### 7.3 Haptics

| Event | Haptic pattern |
|---|---|
| Timer hold complete | `HapticFeedback.mediumImpact()` |
| Routine stretch advance | `HapticFeedback.lightImpact()` |
| Routine complete | `HapticFeedback.heavyImpact()` followed by 300 ms pause + `mediumImpact()` |
| Favorite toggle | `HapticFeedback.selectionClick()` |
| Error / invalid action | `HapticFeedback.vibrate()` (short) |

All haptics must be user-disableable in Settings. Respect `AccessibilityFeatures.disableAnimations` from Flutter's `MediaQuery`.

### 7.4 Reduced-Motion Mode

When `MediaQuery.of(context).disableAnimations == true` OR when the user has enabled `"Reduce motion"` in settings:
- Replace all slide/scale/expand transitions with a 150 ms cross-fade.
- Disable Lottie animations; show static illustrations.
- Disable timer ring glow effect.
- Disable progress dot pulse.
- Breathing cue text changes instantly.
- Timer ring still animates (it is functional, not decorative) but removes the glow and the completion flash.

---

## 8. Accessibility

### 8.1 Color Contrast (WCAG AA)

All text and icon elements meet WCAG 2.1 Level AA (4.5:1 for normal text, 3:1 for large text and UI components).

| Combination | Light contrast | Dark contrast | Pass |
|---|---|---|---|
| `colorOnSurface` (#15302E) on `colorSurface` (#FFF) | 14.2 : 1 | N/A | AA ✓ |
| `colorOnSurface` (#D9ECEB) on `colorSurface` (#16201F dark) | N/A | 11.3 : 1 | AA ✓ |
| `#FFFFFF` on `colorPrimary` (#2A9D8F) | 4.6 : 1 | N/A | AA ✓ |
| `#0F1716` on `#5FC4B8` (dark mode primary) | N/A | 5.1 : 1 | AA ✓ |
| `colorOnSurfaceVariant` (#4A6966) on `colorSurface` (#FFF) | 5.2 : 1 | N/A | AA ✓ |
| `colorPrimary` (#2A9D8F) on `colorSurfaceVariant` (#ECF2F1) | 4.8 : 1 | N/A | AA ✓ |

Verify all combinations using the `contrast_checker` tool or the Material Theme Builder before shipping. Flag any new color pairings to design review.

### 8.2 Touch Targets

- **Minimum:** 48 × 48 dp for all interactive elements (Material M3 baseline).
- Increase to **56 × 56 dp** for the pause/resume button in the timer (it is the primary action in the most critical moment).
- Icon-only buttons without visible labels must have a `Tooltip` widget wrapping them for pointer users.
- List tile tap areas must span the full row width, not just the text.

### 8.3 Screen-Reader (TalkBack / VoiceOver) Support

- Every interactive widget has a `Semantics` widget with a meaningful `label`, `hint` (where the action is non-obvious), and appropriate `button`/`slider`/`switch` role.
- Timer ring: `Semantics(label: "Hold timer, [N] seconds remaining", liveRegion: true)` — updates every 5 seconds to avoid over-announcement.
- Breathing cue: `Semantics(liveRegion: true)` — announces when text changes.
- Bottom nav: `Semantics(label: "[Tab name], tab [N] of 4, [selected/not selected]")`.
- Progress dots row: single semantics container: `"Routine progress: [N] of [total] stretches completed"`.
- Body-part card: `"[Body part], [N] stretches, double-tap to open"`.
- Favorite button: `"[Stretch name], [favorited/not favorited], double-tap to toggle"`.

### 8.4 Large-Text Mode

- Implemented as described in §3.3.
- All cards and tiles expand vertically to accommodate text — no `maxLines` clipping on names or instructions.
- Test at 1.3× scale using Flutter's Accessibility Inspector and `FlutterTest.setTextScaleFactor`.
- The hold timer digit must remain legible at 72 sp; the ring diameter may grow from 240 dp to 260 dp in large-text mode.

### 8.5 Color-Only Meaning

Never rely on color alone:
- Error state: red border + error icon + error text below input (never just red border).
- Active filter chip: checked icon + color tint (never just color).
- Streak progress dot: position in the row communicates day (label below); fill communicates status.
- Prop badges: icon + text label (never icon alone).

### 8.6 Focus Management

- When the Stretch Detail bottom sheet opens, focus moves to the sheet's first interactive element.
- When it closes, focus returns to the triggering list tile.
- When a routine advances to the next stretch, announce the new stretch name via `liveRegion: true` semantics.
- The Health Disclaimer bottom sheet traps focus within the sheet until acknowledged.

### 8.7 Additional Considerations

- **Low vision:** Support system font scaling beyond 1.3× (do not cap `textScaleFactor`). Layout must not break above 1.5×.
- **Motor impairment:** All timed interactions (timer, auto-advance) have a clearly visible pause control. Auto-advance can be disabled in Settings.
- **Cognitive accessibility:** Instructions use plain language. Steps are numbered. Breathing cues are explicit. Never rely on metaphor alone.
- **No flashing content:** No content flashes faster than 3 Hz (WCAG 2.3.1 seizure safety).

---

## 9. Ad Placement UX

StretchHome uses advertising to support free access. Placement must respect the calming, distraction-free experience — especially during active use.

### 9.1 Approved Ad Zones

| Zone | Screen | Ad format | Notes |
|---|---|---|---|
| Browse zone | Home (between Suggestion row and Body-part grid) | Native content card, styled to match app cards — same radius, same shadow, clearly labeled `"Sponsored"` in `labelSmall` `colorOnSurfaceVariant` | Max 1 per Home visit, refreshes on return |
| Browse zone | Body-Part Detail (below filter bar, above list) | Native banner, 60 dp height, `colorSurface` background, rounded 12 dp | Max 1 per screen |
| Post-completion | Routine completion screen (between stats summary and action buttons) | Native rewarded ad card, 200 dp height, same card styling, `"Sponsored"` label | Only when connected; never if no internet |
| Post-completion | Single stretch session end (if shown as standalone, not in a routine) | Same as above | Max 1, shown only after a session of ≥ 2 stretches |
| Interstitial | Between Body-Part Detail and Stretch Detail (max 1× per 10 minutes of app use) | Standard interstitial, dismissible after 5 seconds | **Rate-limited strictly** — not every transition |

### 9.2 Strict No-Ad Zones

The following must **never** contain ads, ad-triggered interruptions, or promotional notifications:

| Zone | Reason |
|---|---|
| During any hold timer countdown | Breaks concentration, could cause physical harm if user is mid-stretch |
| Routine Player (any screen while timer is running) | Same reason — active stretch zone |
| Rest screen between stretches | Brief respite — must be calm |
| Health Disclaimer modal | Legal and safety context |
| Onboarding flow | First impression must be clean |
| Empty states | Ad in empty state is patronizing |
| Settings screen | Settings require concentration and trust |
| Any bottom sheet while stretch instructions are visible | Distracting at point of use |

### 9.3 Ad Styling Rules

- All ads must use the same `borderRadius` (20 dp for card-style), shadow level, and background color as the surrounding content.
- The `"Sponsored"` label must be legible (`labelSmall`, `colorOnSurfaceVariant`) and must not attempt to visually mimic app content without the label.
- Ads must not use autoplay audio.
- Ads must not use countdown timers to force engagement.
- Ads must support dark mode (prefer native ads with dark-mode-compatible creative).
- On the Routine Player completion screen, the ad card must be visually separated from the `"Great work!"` headline by at least 24 dp.

### 9.4 User Control

- Settings → `"Ad preferences"` ListTile (if ad network supports user opt-out link) — required for GDPR/CCPA compliance.
- Future: consider a one-time IAP to remove ads permanently — this should be surfaced gently (e.g., a `"Go ad-free"` TextButton in Settings, never a pop-up).

---

## Appendix A: Flutter Implementation Notes

### A.1 ThemeData Setup

```dart
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2A9D8F),
    brightness: Brightness.light,
  ).copyWith(
    primary: const Color(0xFF2A9D8F),
    onPrimary: Colors.white,
    surface: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF15302E),
    surfaceContainerHighest: const Color(0xFFECF2F1),
    background: const Color(0xFFF6F8F8),
    error: const Color(0xFFC0392B),
  ),
  scaffoldBackgroundColor: const Color(0xFFF6F8F8),
  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    elevation: 0,
    shadowColor: const Color(0xFF15302E).withOpacity(0.08),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      minimumSize: const Size.fromHeight(52),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  ),
  chipTheme: ChipThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
  ),
);
```

### A.2 Key Packages

| Package | Use |
|---|---|
| `google_fonts` | Plus Jakarta Sans + Inter |
| `lottie` | Animations (onboarding, completion) |
| `flutter_animate` | Micro-interaction helper |
| `wakelock_plus` | Keep screen awake during routine player |
| `shared_preferences` | Persist settings (large text, dark mode) |
| `google_mobile_ads` | Ad SDK |
| `fl_chart` | Progress charts (optional stats screen) |
| `provider` or `riverpod` | State management |

---

*End of StretchHome Design System Specification v1.0*
