# StretchHome — Action Plan (who does what, phase by phase)

This is our shared playbook. **Claude** = what I build/write. **You (Sangram)** = what only you can do
(run on your Mac, film videos, pay fees, create accounts, publish). Check items off as we go.

---

## Division of labor at a glance

| Area | Claude does | You do |
|---|---|---|
| App code (Flutter) | Write & maintain all Dart code | Run it on your Mac, test on device |
| Content (text) | Write all stretch instructions, routines, copy | Review for accuracy/preference |
| Visuals — 2D | Generate illustrated poses where possible | Approve style |
| Visuals — video/3D | Write Blender scripts + guide you | Film MP4s / render in Blender, drop files in |
| Policies | Draft privacy policy + health disclaimer | Host the policy online, (optional) lawyer review |
| Monetization | Write AdMob integration code | Create AdMob account, paste real IDs, go live |
| Stores | Write listing copy, ASO, screenshot layout | Pay fees, upload builds, submit for review |

---

## Phase 1 — Get a working app on your phone  ✅ mostly done

**Claude (done):**
- [x] Flutter project scaffold + modern Material 3 theme (teal wellness palette, dark mode)
- [x] Data models + content repository (loads bundled JSON, offline)
- [x] All core screens: onboarding+disclaimer, home, body-part list, stretch detail (hold-timer ring + gentle/standard/deeper toggle + favorite), routines, full-screen routine player (auto-advance + rest + completion), favorites, settings
- [x] Starter content: 22 stretches across 9 body sections + 6 routines
- [x] Design system spec + project memory docs (CLAUDE.md, AGENTS.md, this file)

**You — to see it run (~20–30 min):**
1. [ ] Install Flutter on your Mac: https://docs.flutter.dev/get-started/install/macos
2. [ ] In the project folder run:
   ```bash
   flutter create . --platforms=android,ios
   flutter pub get
   flutter run
   ```
   (This adds the `android/` and `ios/` folders around the existing code without overwriting it.)
3. [ ] Confirm it launches: onboarding → home → open a body part → start a stretch timer → play a routine.
4. [ ] Tell me anything that looks off — I'll fix it.
5. [ ] (Optional now) Register **Google Play** developer account ($25 one-time).

---

## Phase 2 — Make it full & beautiful

**Claude:**
- [ ] Expand content from 22 → 50–60 stretches (more per section) + a few more routines
- [ ] Add a Search screen and a daily reminder (local notification) + streak polish
- [ ] Generate 2D illustrated poses for stretches (clean, consistent style)
- [ ] Write the **privacy policy** text + finalize the health disclaimer
- [ ] Write Blender scripts for optional 3D loops, and an AI-image prompt set as a fallback
- [ ] Draft an app icon concept

**You:**
- [ ] Film the **MP4s** (you're handling these) — or render the 3D in Blender (give me access and I'll script it)
- [ ] Drop visuals into `assets/visuals/<id>.png` (or mp4) — they appear automatically
- [ ] Create a free **AdMob** account
- [ ] Host the privacy policy (free: GitHub Pages / Google Sites) and send me the URL
- [ ] Decide app name + pick the icon direction

---

## Phase 3 — Monetize & launch

**Claude:**
- [ ] Integrate AdMob: init in `main()`, rewarded + interstitial at routine completion, banner on browse
- [ ] Set target audience to **13+** in code/config notes (keeps ad revenue unrestricted)
- [ ] Write store listing: title, description, ASO keywords, screenshot captions
- [ ] Pre-launch checklist pass (Data Safety form answers, etc.)

**You:**
- [ ] Pay store fees (Google Play done in P1; Apple $99/yr if launching iOS)
- [ ] Paste your **real AdMob IDs**, flip `AdConfig.enabled = true`
- [ ] Set up Google Play **closed testing** (line up ~12 testers early)
- [ ] Upload builds, submit for review on both stores
- [ ] After approval, switch ads to live and publish 🎉

---

## Right now — your two immediate steps
1. **Run Phase 1 step 2** on your Mac and confirm the app launches.
2. **Start gathering MP4s** for the 22 stretches we have (filenames = stretch `id`, listed in `assets/data/stretches.json`).

I'll keep expanding content and visuals in parallel. Ping me when the app runs or if anything breaks.
