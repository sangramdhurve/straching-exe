#!/usr/bin/env bash
#
# encode_demo.sh — turn a raw demo source into the app-ready pair:
#   assets/visuals/<id>.mp4   (square, looping, muted, small H.264)
#   assets/visuals/<id>.png   (poster = first frame; reduce-motion + loading frame)
#
# The app's DemoPlayer (lib/widgets/demo_player.dart) plays the MP4 in sync with
# the hold timer and shows the PNG when reduce-motion is on. Keep clips SHORT
# (~3–5s) and well-compressed so the bundled app stays small (offline, no CDN).
#
# Usage:
#   tools/encode_demo.sh <input>  <stretch_id>  [seamless]
#     <input>      a video file, OR a printf-style frame glob e.g. "renders/frame_%04d.png"
#     <stretch_id> e.g. neck_side_stretch (must match an id in assets/data/stretches.json)
#     seamless     optional literal word "seamless" -> append a reversed copy
#                  (boomerang) so the loop has no visible jump. Doubles duration.
#
# Examples:
#   tools/encode_demo.sh ~/clips/neck.mov neck_side_stretch
#   tools/encode_demo.sh "assets/blender/renders/calf_%04d.png" wall_calf seamless
#
# Requires ffmpeg (brew install ffmpeg).
set -euo pipefail

IN="${1:?need an input video or frame glob}"
ID="${2:?need a stretch id, e.g. neck_side_stretch}"
SEAMLESS="${3:-}"

OUT_DIR="assets/visuals"
MP4="$OUT_DIR/$ID.mp4"
PNG="$OUT_DIR/$ID.png"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$OUT_DIR"

# Square center-crop -> 720, steady 24fps, no audio, web-friendly, compressed.
VF="crop='min(iw,ih)':'min(iw,ih)',scale=720:720:flags=lanczos,fps=24,format=yuv420p"
ENC=(-an -c:v libx264 -profile:v high -pix_fmt yuv420p -movflags +faststart -crf 28 -preset slow)

# Frame-glob inputs need -framerate; video inputs don't.
INARGS=(-i "$IN")
case "$IN" in *%0*d*) INARGS=(-framerate 24 -i "$IN");; esac

if [ "$SEAMLESS" = "seamless" ]; then
  # base -> forward.mp4, then concat with its reverse for a no-jump boomerang loop.
  ffmpeg -y "${INARGS[@]}" -vf "$VF" "${ENC[@]}" "$TMP/fwd.mp4"
  ffmpeg -y -i "$TMP/fwd.mp4" -vf reverse "${ENC[@]}" "$TMP/rev.mp4"
  printf "file '%s'\nfile '%s'\n" "$TMP/fwd.mp4" "$TMP/rev.mp4" > "$TMP/list.txt"
  ffmpeg -y -f concat -safe 0 -i "$TMP/list.txt" -c copy "$MP4"
else
  ffmpeg -y "${INARGS[@]}" -vf "$VF" "${ENC[@]}" "$MP4"
fi

# Poster = first frame of the final clip.
ffmpeg -y -i "$MP4" -frames:v 1 -update 1 "$PNG"

BYTES=$(wc -c < "$MP4" | tr -d ' ')
echo "✓ $MP4  ($((BYTES/1024)) KB)"
echo "✓ $PNG  (poster)"
echo "Next: set this stretch's assetType=\"video\" and assetFile=\"$MP4\" in assets/data/stretches.json"
