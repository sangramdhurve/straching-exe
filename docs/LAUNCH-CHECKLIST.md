# StretchHome — Launch Checklist (current source of truth)

*Updated June 2026. Decision: ship now with 2D illustrations (+ one 3D clip), add more 3D in updates.*

## ✅ Done (build side — all complete)
- Cross-platform Flutter app (Android + iOS), modern Material 3 theme, dark mode, large-text mode.
- All core screens: onboarding + health disclaimer, home, body-part browse, stretch detail (hold
  timer + gentle/standard/deeper), routines, full-screen routine player, favorites, settings.
- **45 stretches** (5 per body section) + **9 routines** — content validated, all references resolve.
- **45 2D illustrations** + **1 real 3D animated clip** (Cross-Body Shoulder Stretch).
- **AdMob wired in test mode** — banners on browse screens, frequency-capped interstitial at routine
  completion, never during a stretch.
- App icon + adaptive icon (run `dart run flutter_launcher_icons`).
- Privacy policy + health disclaimer drafted (`docs/legal/`), store listing + ASO written
  (`docs/STORE-LISTING.md`), data-safety answers (`docs/legal/README.md`).
- Builds and runs on device (confirmed on Android emulator).

## ⏳ Only you can do (needs your logins/accounts)
1. **Pick the app package/bundle ID** (permanent — can't change after publishing).
   Currently the placeholder `com.example.stretchhome`. Tell me your choice (e.g.
   `com.stretchhome.app`) and I'll set it in ~1 minute.
2. **Host the privacy policy** (free): put `docs/legal/privacy-policy.html` on GitHub Pages,
   Google Sites, or Netlify Drop. Send me the public URL — I'll wire it into Settings.
3. **Create developer accounts:** Google Play ($25 one-time), Apple ($99/yr if launching iOS).
4. **Create an AdMob account** → get your real App IDs + ad unit IDs. Send them to me; I swap the
   test IDs (in `AdConfig`, AndroidManifest, Info.plist) for your real ones and set target
   audience to **13+**.
5. **Capture 5–6 screenshots** from the running app for the store listing (see the shot list in
   `docs/STORE-LISTING.md`).
6. **Fill the store forms:** Google Play *Data safety* / Apple *App Privacy* — answers are in
   `docs/legal/README.md`. Declare "contains ads."
7. **Build release & submit:** `flutter build appbundle` (Android) / Xcode archive (iOS), set up
   Google Play closed testing (~12 testers), upload, submit for review. Flip ads to your real IDs
   at the very end.

## 🔁 What I'll do the moment you're ready (just say the word)
- Set your chosen package/bundle ID.
- Wire the hosted privacy-policy URL into Settings (via `url_launcher`).
- Swap test AdMob IDs → your real IDs.
- Render + wire any Mixamo animations you drop into `assets/blender/anims/` as in-app 3D loops.
- Add a male/female character toggle once your Avaturn avatars are in.

## Notes
- The single 3D clip on Cross-Body Shoulder is intentional (a preview of the capability). To keep
  visuals 100% uniform for launch, you can revert it: in `assets/data/stretches.json`, change
  `cross_body_shoulder` `assetFile` back to `...cross_body_shoulder.png`. Your call.
- These remain Google **test** ad IDs until step 4 — safe to view/tap, but you earn nothing until
  you swap in real IDs.
- Recommended order: 1 → 3 → 2/4 in parallel → 5/6 → 7.
