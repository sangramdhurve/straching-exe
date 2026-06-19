# Home Stretching App — Strategy & Launch Plan

*Prepared for Sangram · June 2026 · Working title: **StretchHome** (rename later)*

A free, ad-supported mobile app that teaches **full-body stretching only**, designed for doing at home using simple props (chair, table, wall, towel, a bag/purse), with clear visuals showing how to perform each stretch. Cross-platform (Android + iOS), built together in Flutter, monetized with ads, no membership.

---

## 1. The one-line vision

> **"Open the app, pick a body part, follow a guided stretch on screen — anywhere at home, no equipment, no subscription."**

Everything below serves that sentence. If a feature doesn't help someone stretch a body part correctly at home, it doesn't go in version 1.

---

## 2. Why this idea can work

- **Real, evergreen demand.** Stiffness, back/neck pain from desk work, warm-ups, cool-downs, and "I should stretch more" are universal. Search demand for "stretching for back," "neck stretches," "stretching for seniors," etc. is steady and global.
- **Narrow = strong.** Most fitness apps try to do everything (workouts, diet, tracking). Doing **only stretching, only at home, only with household props** is a sharp, memorable positioning that's easy to rank for and easy to explain.
- **Low cost to run.** Content can be bundled into the app. No live servers, no trainers, no inventory. Your main cost is your time plus tiny store fees.
- **Ad model fits casual, repeat use.** People stretch in short sessions, often daily. Frequent, short sessions = more natural ad breaks than a once-a-week heavy app.

**The honest catch:** ad revenue per user is small, so this only makes real money at **scale** (tens of thousands of users) or with **good Tier-1 traffic** (US/UK/Canada/Australia users are worth far more than others). Plan for a slow build, not an overnight payday. More on the numbers in Section 9.

---

## 3. Who it's for, and how it helps them

| Audience | What they want | How the app helps |
|---|---|---|
| **Desk workers (25–45)** | Relief from neck/back/shoulder tightness | Short "desk reset" routines using a chair and wall |
| **Older adults / seniors (55+)** | Gentle, safe mobility; balance support | Chair- and wall-supported stretches, slow pace, large text |
| **Beginners / generally stiff people** | Simple guidance, fear of "doing it wrong" | Step-by-step visuals, breathing cues, "common mistakes" |
| **Active people / athletes** | Warm-up & cool-down | Targeted pre/post routines by body part |
| **Busy parents** | 5 minutes, at home, no gear | Quick routines, no setup |

**Core user benefits to put front-and-center in your store listing and marketing:**

1. **Completely free** — no paywall, no trial, no "premium."
2. **No equipment** — uses things every home already has.
3. **Safe for all ages** — gentle options and supported variations.
4. **Clear visuals** — see exactly how to position your body.
5. **Fast** — routines from 3 to 15 minutes.
6. **Offline** — works without internet (content bundled in the app).

---

## 4. The stretching content system (the heart of the app)

This is your real product. The code is just a wrapper around good content. Build the content library as **structured data** (a spreadsheet → JSON) so the app reads it and you can expand forever without touching code.

### 4.1 Organize by body part ("part to part")

Cover the full body, top to bottom. Suggested sections:

1. **Neck** (sides, rotation, levator scapulae)
2. **Shoulders & upper back** (cross-body, wall slides, doorway chest)
3. **Arms, wrists & forearms** (desk/typing relief)
4. **Chest** (wall/doorway opener)
5. **Mid & lower back** (cat-cow on floor, seated twist, child's pose)
6. **Hips & glutes** (figure-4 on chair, standing hip flexor)
7. **Hamstrings** (chair-supported, wall, towel-assisted)
8. **Quads & hip flexors** (standing, chair-supported)
9. **Calves & ankles** (wall push, step stretch)
10. **Full-body flows** (gentle morning, desk reset, bedtime wind-down)

### 4.2 Props (the "home equipment")

You mentioned a chair, table, wall, and a bag/purse. Standardize on **five universal props** so the same set covers nearly every home:

- **Chair** — support for balance, seated stretches, figure-4.
- **Wall** — calf stretch, chest opener, posture support.
- **Table / counter** — hamstring and back support at hip height.
- **Towel** — hamstring assist, shoulder mobility (replaces a strap).
- **Bag / purse** — a light household "weight" for gentle loaded stretches (or skip — keep most stretches no-weight for safety).

Tag every stretch with the prop(s) it needs, so users can filter: *"Show me stretches I can do with just a wall."*

### 4.3 Difficulty & age adaptation (one routine, three levels)

Instead of separate apps for young and old, give each stretch up to three variations:

- **Gentle / Supported** (seniors, beginners, recovery) — uses chair or wall for balance, smaller range.
- **Standard** (most users).
- **Deeper** (flexible/active users) — larger range, optional bag for light load.

This is how you serve "all age groups" without fragmenting the app.

### 4.4 Anatomy of one stretch entry (the data template)

Every stretch in your library should have these fields. This becomes your content spreadsheet:

| Field | Example |
|---|---|
| Name | Standing Calf Stretch (Wall) |
| Body part | Calves & ankles |
| Props | Wall |
| Level | Standard (with Gentle + Deeper variants) |
| Target muscle | Gastrocnemius / soleus |
| Hold time | 30 sec each side |
| Reps / sides | 2 sides |
| Step-by-step | 1) Face wall, hands at shoulder height… 2) Step one foot back… |
| Breathing cue | Exhale as you lean in |
| Common mistakes | Don't bounce; keep back heel down |
| Safety note | Stop if you feel sharp pain |
| Visual asset | calf_wall.mp4 / calf_wall.json (Lottie) |
| Voice/caption | optional narration text |

Aim for a **launch library of ~40–60 stretches** (4–6 per body section). That's enough to feel complete without overwhelming you. Expand after launch.

---

## 5. Feature set — what to build, and when

Resist the urge to build everything. Ship a focused MVP, then add.

### MVP (Version 1.0 — launch this)

- Browse stretches **by body part**.
- Each stretch screen: looping **visual** + steps + breathing + hold timer.
- **Pre-built routines** (e.g., "Desk Reset 5 min," "Full Body 10 min," "Gentle for Seniors").
- **Routine player** — auto-advances through stretches with a countdown timer and rest between.
- **Filter by prop** (chair / wall / none).
- **Favorites** (save stretches you like — stored on the device).
- **Offline** content.
- **AdMob ads** (see Section 9 for placement).
- **Health disclaimer** on first launch + privacy policy link.

### Version 1.1–1.2 (fast follows, weeks after launch)

- Daily reminder/notification ("Time to stretch").
- Simple streak counter (days stretched).
- Search.
- Dark mode + larger-text accessibility mode (great for seniors).
- More routines and stretches.

### Version 2.0+ (later, once you have users)

- True interactive **3D model** you can rotate (MVP uses pre-rendered loops — see Section 8).
- Voice guidance / audio coaching.
- "Build your own routine."
- Multiple languages (big growth lever — start with the largest non-English markets for your audience).
- Optional account sync across devices.

**What to deliberately leave OUT:** social feed, calorie/diet tracking, wearables, anything non-stretching. Scope creep is the #1 way solo apps never ship.

---

## 6. Tech stack (since we're coding this together)

Given **both platforms at once**, **near-zero budget**, and **launch soon**, the clear choice:

| Layer | Recommendation | Why |
|---|---|---|
| **App framework** | **Flutter** (Dart) | One codebase → Android **and** iOS. Free. Great for content/animation-heavy UIs. |
| **Content storage** | Bundled JSON + assets in the app | No backend needed = $0 hosting, works offline. |
| **Local data** (favorites, streaks) | `shared_preferences` or `sqflite` | On-device, free, no server. |
| **Ads** | `google_mobile_ads` (AdMob) | Official Flutter AdMob plugin. |
| **Analytics** | Firebase Analytics (free Spark tier) | See what users actually do; free. |
| **Animations** | `lottie` (vector) and/or `video_player` (mp4 loops) | Lightweight, smooth, small file size. |
| **Notifications** | `flutter_local_notifications` | Free local reminders, no server. |

This keeps **running costs at essentially $0** — you only pay the one-time/annual store fees. We can scaffold the Flutter project, data model, and screens together step by step when you're ready to build.

---

## 7. How you'll actually make the visuals (on under $500)

You don't need to pay anyone. Here's a realistic pipeline, cheapest-first. **My recommendation: launch with polished 2D, upgrade to 3D after.**

### Option A — 2D illustrated/animated poses (fastest, cheapest, recommended for launch)

- Draw or generate **2–3 key poses** per stretch (start position → stretch position), add **direction arrows** and a highlight on the target muscle.
- Animate lightly in **Rive** (free) or export simple loops — or even just show 2 clean images with arrows. This is enough to teach a stretch clearly.
- **Tiny file sizes**, looks clean, ships fast. Many top stretching apps use exactly this style.
- Tools: Figma/Inkscape (free) for drawing, **Rive** (free tier) for animation, or an AI image generator for base illustrations that you then standardize.

### Option B — Pre-rendered 3D loops (the "wow," still free)

This is the free 3D pipeline, and it's well-trodden:

1. **Character:** get a free rigged human from **Mixamo** (Adobe, free, royalty-free) or build one in **MakeHuman** (free). AI options like **Meshy** have free tiers too.
2. **Pose/animate:** import into **Blender** (free, open-source). For stretches you mostly need slow, simple movements — a few keyframes (start → hold → release) per stretch is enough.
3. **Render:** export each stretch as a short **looping MP4 or WebM** (or an image sequence). Use Blender's Eevee renderer — fast and free.
4. **Drop into the app** as `video_player` loops. Same data template as Section 4.4.

Render a **camera angle that clearly shows the body**; optionally render front + side angles for tricky stretches.

> **Key decision:** *Real-time, rotatable 3D inside the app* (where the user spins the model) is heavier to build and best saved for Version 2.0. For launch, **pre-rendered loops give you the 3D look without the engineering cost.** Start with Option A or B, not interactive 3D.

### Make it consistent

Whatever you choose, lock a **style guide** before producing 50 stretches: same character, same background, same camera framing, same arrow/label style. Consistency is what makes an app look professional. Produce **one perfect stretch first**, get it looking great, then mass-produce the rest to match.

---

## 8. The all-ages decision that affects your money (read this carefully)

You want the app usable by **all age groups**. That's great for *content* — but how you set the **store "target audience"** has a big effect on **ad revenue and rules**:

- If you tell Google Play / Apple that your app **targets children (under 13)**, you fall under **Google Play's Families Policy** (and Apple's Kids rules + COPPA/GDPR-K laws). Then you **must** use child-directed ad settings: only G-rated ads, `setTagForChildDirectedTreatment(true)`, and a self-certified Families ads SDK. **Result: much lower ad rates and stricter approval.**
- If you set the target audience to **13+ / "Everyone (not primarily children)"**, your content can still be perfectly suitable for kids and seniors, but you **avoid the child-directed ad restrictions** and earn normal ad rates.

**Recommendation:** Target the store listing at **13+ (teens and adults)**, write the content so it's gentle and clear enough for grandparents and capable enough for athletes, and note "suitable for all ages, younger children with adult supervision." You keep the universal feel **and** healthy ad revenue. Only go the formal "for children" route if under-13 is genuinely your primary audience — and know it costs you ad income and adds compliance work.

---

## 9. Monetization — AdMob, realistically

### Ad formats and where to place them

| Format | Where to use it | Notes |
|---|---|---|
| **Rewarded** (highest value) | "Unlock this bonus routine" / "Watch to remove next break" | User opts in → best rates, least annoying. Lean on this. |
| **Interstitial** (full screen) | **After** a user finishes a routine, not before/during | Natural break. Cap to ~1 per few minutes; never mid-stretch. |
| **Banner** (low value) | Bottom of browse/list screens | Keep **off** the active stretch player — don't distract or cause mistaps. |
| **App Open** (use sparingly) | Occasionally on cold start | Easy to overdo; can hurt retention. |

**Golden rule:** never show an ad **during** a stretch or routine. Interrupting someone mid-pose ruins the experience and tanks retention. Ads go at natural boundaries (finished a routine, browsing, opting into a bonus).

### What ad rates actually look like (2025–2026 benchmarks)

eCPM = revenue per 1,000 ad views. It varies massively by country:

| Format | Global average eCPM | Tier-1 (US/UK/CA/AU) eCPM |
|---|---|---|
| Banner | ~$0.20–$0.80 | ~$0.50–$1.50 |
| Interstitial | ~$2.50–$5.00 | ~$5–$12 |
| Rewarded video | ~$8–$18 | ~$15–$45 |

### Honest revenue model (illustrative, not a promise)

Assume **1,000 daily active users**, mostly mixed/global traffic, each finishing ~1 routine/day:

- ~1 interstitial/day × 1,000 × 30 days = 30,000 views × ~$3 = **~$90/mo**
- ~0.3 rewarded/day × 1,000 × 30 = 9,000 views × ~$10 = **~$90/mo**
- Banners across browsing ≈ **~$30–$80/mo**
- **≈ $200–$300/month at 1,000 DAU** (much higher if your users skew US/Europe).

Scale that mentally: **10,000 DAU ≈ $2–3k/month**; **100,000 DAU ≈ $20–30k/month** — and proportionally more if you attract Western users. The lesson: **growth and geography are the whole game.** Build something people reopen daily, and chase quality traffic.

### Don't sabotage yourself

- Too many ads → uninstalls → AdMob can limit/ban your account. Be conservative early.
- Never click your own ads (instant ban). Use **test ad units** while developing.
- Keep one **non-ad path** so the core experience always feels usable and free.

---

## 10. Legal & safety (don't skip — this protects you)

For a free, ad-supported, all-ages health app you need three things in place **before** launch:

1. **Health/medical disclaimer.** Show on first launch and keep in Settings: *"This app provides general fitness information, not medical advice. Consult a healthcare provider before starting, especially if you have injuries, are pregnant, or have a medical condition. Stop immediately if you feel pain."* This is essential liability protection for any exercise app.
2. **Privacy policy (required).** Both app stores **and AdMob require** a public privacy policy URL because ads collect data. You can generate one free (e.g., a privacy policy generator) and host it free (GitHub Pages, Google Sites). It must disclose ad partners and any analytics.
3. **Store data-safety forms.** Google Play's "Data safety" section and Apple's "App Privacy" labels must be filled in honestly (you collect advertising ID + analytics).

Also: use your **own original visuals** (don't copy another app's illustrations or videos), and confirm any character/animation assets are licensed for commercial use (Mixamo and Blender output are fine).

---

## 11. Step-by-step launch roadmap (~8–12 weeks)

Realistic for a small team building together, near-zero budget.

**Phase 0 — Decide & set up (Week 1)**
- Lock the name, the 10 body-part sections, and your 40–60 stretch list.
- Register developer accounts: **Google Play one-time $25**, **Apple $99/year**.
- Pick visual style (Option A 2D or B 3D) and produce **one perfect sample stretch**.

**Phase 1 — Content production (Weeks 2–4)**
- Fill the content spreadsheet (Section 4.4) for all stretches.
- Produce all visuals to match your sample. (This is the longest part — start early.)
- Write all step text, cues, and safety notes.

**Phase 2 — Build the MVP (Weeks 4–8, overlaps content)**
- Scaffold the Flutter app, data model, navigation.
- Build: body-part browse → stretch screen → routine player with timer → favorites → prop filter.
- Integrate AdMob (test units first), analytics, disclaimer, privacy link.

**Phase 3 — Test (Weeks 8–9)**
- Test on real Android + iOS devices.
- Run a small closed test (friends/family) — Google Play closed testing now effectively requires a tester group before production; line up ~12 testers early.
- Fix bugs, check ad placement feels non-annoying.

**Phase 4 — Launch (Weeks 9–12)**
- Create store listings (icon, screenshots, description — see Section 12).
- Submit to both stores (Apple review takes days; Play testing track takes a bit longer).
- Switch AdMob from test to **live** ad units only at the very end.
- Soft-launch, watch analytics + crash reports, iterate.

> Tip: **Android first** if you want money/feedback fastest — cheaper, faster approval, bigger global reach. You can submit iOS in parallel since Flutter gives you both, but if anything slips, let iOS follow.

---

## 12. Getting found — App Store Optimization (ASO) + low-cost marketing

You won't earn from ads if nobody installs. With ~$0 marketing budget, **ASO is your main growth engine.**

**Store listing essentials:**
- **App name/title:** include the keyword, e.g., *"StretchHome: Daily Stretching"* or *"Stretching Exercises at Home."*
- **Keywords:** stretching, flexibility, mobility, back stretch, neck pain, seniors, warm up, cool down, home exercise.
- **Screenshots:** show the actual stretch visuals + benefits as captions ("Relieve neck tension in 5 minutes"). Screenshots sell more than the description.
- **Short, benefit-led description.** First two lines matter most.

**Free/cheap growth channels:**
- **Short-form video** (YouTube Shorts, Instagram Reels, TikTok): post individual stretches — "30-second neck fix at your desk." This content doubles as marketing and is endless.
- **Niche communities:** subreddits and forums for back pain, desk workers, seniors, yoga beginners (follow each community's self-promo rules).
- **Pinterest:** stretching infographics perform very well and drive long-term traffic.
- **Ask for ratings** in-app after a user completes a few routines (ratings boost ranking).

**Pick a niche to win first.** "Stretching for desk workers" or "gentle stretching for seniors" is far easier to rank for and market than generic "stretching." Own a niche, then broaden.

---

## 13. Success metrics to watch

- **Installs** and **install→open rate**.
- **Day-1 / Day-7 / Day-30 retention** (do people come back? this drives ad revenue most).
- **Routines completed per user** (engagement = more ad views).
- **Ad eCPM and revenue per daily active user (ARPDAU)**.
- **Uninstall rate** (spikes here often mean too many/badly-placed ads).
- **Rating** (aim 4.5+).

Retention beats install count. 1,000 users who return daily are worth more than 10,000 who open once.

---

## 14. Top risks & how to handle them

| Risk | Mitigation |
|---|---|
| Ad revenue is small until you scale | Treat early months as growth, not income; lean on rewarded ads; chase Tier-1 traffic and retention. |
| Content production is slow/inconsistent | Make ONE perfect stretch, lock a style guide, then batch-produce. Start content in Week 1. |
| Too many ads → uninstalls/ban | Conservative placement, never mid-stretch, keep core free and clean. |
| All-ages → child-ad restrictions kill revenue | Target store listing at 13+ (Section 8). |
| Injury/liability | Prominent health disclaimer, gentle/supported variants, "stop if pain" cues. |
| Scope creep → never ships | Freeze MVP scope (Section 5). Stretching only. Ship, then add. |
| App rejected at review | Have privacy policy + data-safety forms ready; line up testers early for Play. |

---

## 15. Do these five things this week

1. **Lock the list:** finalize the 10 body-part sections and your 40–60 stretch names.
2. **Register Google Play** ($25 one-time) so the clock starts; decide on Apple ($99/yr) now or after Android.
3. **Produce one perfect sample stretch** in your chosen style (2D recommended for speed).
4. **Set up the content spreadsheet** using the template in Section 4.4.
5. **Tell me when you're ready to build** — we'll scaffold the Flutter project, the data model, and the first screens together.

---

*Built to launch lean: stretching only, home only, free forever, ads-supported. Win a niche, keep people coming back daily, and let scale + Tier-1 traffic do the earning.*
