# Generating human demo clips for StretchHome

How to produce the looping **human demonstration** clips the app plays in sync with
the hold timer. Build the **5 showcase** stretches first, get them approved, then repeat
for the remaining 40. The app code is already done — this is purely a media pipeline.

## What the app expects (per stretch)
Two files in `assets/visuals/`, named by the stretch `id`:
- `<id>.mp4` — square (1:1), ~3–5 s, **seamless loop**, **muted**, H.264, ~720×720, small.
- `<id>.png` — poster (first frame). Shown while the video loads and under reduce-motion.

Then in `assets/data/stretches.json` set that stretch's:
```json
"assetType": "video",
"assetFile": "assets/visuals/<id>.mp4"
```
`DemoPlayer` (`lib/widgets/demo_player.dart`) handles the rest: looping, timer-synced
play/pause, poster fallback, and a tinted fallback if a file is missing.

## Art direction (keep it consistent across all 45 — "one character language")
- **One demonstrator**: same person, calm neutral athleisure, friendly, all-ages (not hyper-athletic).
- **Neutral home/studio**: plain warm-neutral background, soft even light, minimal props
  (only the chair/wall/towel/etc. the stretch actually uses).
- **Framing**: full body in frame, centered, camera at the height that best reads the pose.
  Use a 3/4 or side angle where the stretch direction would be ambiguous head-on.
- **Motion**: show the *held* position with a small natural breathing/settle motion — NOT a
  full rep. The point is "copy this pose", and the loop should read as continuous.
- Brand-adjacent palette (teal/warm) is a plus but not required.

## Showcase set (one per posture archetype)
| id | posture | props |
|---|---|---|
| `neck_side_stretch` | standing/seated, upper body | none |
| `chair_hamstring` | seated on a chair | chair |
| `standing_forward_fold` | standing forward bend | none |
| `wall_calf` | standing, hands on wall | wall |
| `triceps_overhead` | standing, arm overhead | none |

(`cross_body_shoulder` already has a 3D reference clip from the Blender pipeline.)

## Option A — AI-generated human (the chosen direction)
1. **Lock the character.** Generate one approved reference portrait/full-body of the demonstrator
   (text-to-image). Reuse it as an identity/reference image for every pose so the person stays
   consistent.
2. **Pose per stretch.** Image-to-image or a posed prompt to get a clean keyframe of the held
   stretch (match the `steps` in stretches.json so the form is correct).
3. **Animate to a short loop.** Image-to-video for a 3–5 s clip with gentle breathing motion.
   Prefer a model/setting that can produce a seamless or near-seamless loop.
4. **Encode** with the helper (adds `seamless` boomerang if the source doesn't loop cleanly):
   ```bash
   tools/encode_demo.sh path/to/raw_clip.mp4 neck_side_stretch
   # or, if the loop has a visible jump:
   tools/encode_demo.sh path/to/raw_clip.mp4 neck_side_stretch seamless
   ```
5. **Wire it up**: set `assetType`/`assetFile` in stretches.json (step above).
6. **Verify**: `flutter run`, open the stretch, Start hold → demo plays with the ring; toggle
   reduce-motion → poster only.

**Quality bar / reject if:** wrong/garbled anatomy (hands, joints), the form contradicts the
written steps, the person/background drifts between clips, or the loop visibly jumps. AI photoreal
humans across varied poses are the hard part — if a clip can't pass, use a fallback below; no app
change is needed.

## Option B — Blender 3D human (proven fallback)
The repo already renders a 3D Mixamo human (`assets/blender/character_*.fbx`,
`assets/blender/renders/`, e.g. `cross_body_shoulder.gif`). Render the pose, export a frame
sequence or mp4, then run `tools/encode_demo.sh "renders/<id>_%04d.png" <id> seamless`.

## Option C — keep the illustration
Leave `assetType: "illustration"`; the app shows the existing `assets/visuals/<id>.png`. Use this
for any stretch whose clip isn't good enough yet.

## Keep the app small
Showcase = 5 clips. Budget ~300–800 KB each (crf 28, 720p, 3–5s). Re-encode with a higher `-crf`
(e.g. 30–32) if total bundle growth gets heavy before scaling to all 45.
