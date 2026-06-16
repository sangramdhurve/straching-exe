#!/usr/bin/env python3
"""StretchHome app icon / logo — vector-built, rendered to exact store sizes.

A calm figure in an overhead "morning stretch" reach, on a richer teal with a
soft sunrise aura. Brand teal #2A9D8F. No text in the icon (store best practice).

Outputs:
  store-assets/icon/play_icon_512.png      512x512  (Google Play listing icon)
  store-assets/icon/apple_icon_1024.png    1024x1024 RGB, NO alpha (Apple)
  assets/icon/app_icon.png                 1024 full (Flutter launcher source)
  assets/icon/app_icon_foreground.png      1024 adaptive foreground (figure only)
  tools/_icon_preview.png                  side-by-side preview

Deps: cairosvg, Pillow
Run:  python3 tools/generate_store_icon.py
"""
import os
import cairosvg
from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
STORE_ICON = os.path.join(ROOT, "store-assets", "icon")
APP_ICON = os.path.join(ROOT, "assets", "icon")
os.makedirs(STORE_ICON, exist_ok=True)
os.makedirs(APP_ICON, exist_ok=True)

# The reaching figure, as thick rounded strokes (modern, friendly line-art).
FIGURE = """
  <g fill="none" stroke="#FFFFFF" stroke-width="54"
     stroke-linecap="round" stroke-linejoin="round">
    <!-- arms: shoulders -> elbows -> hands, an open overhead reach -->
    <polyline points="512,406 440,372 360,210"/>
    <polyline points="512,406 584,372 664,210"/>
    <!-- torso -->
    <line x1="512" y1="372" x2="512" y2="600"/>
    <!-- legs: hips -> knees -> feet, gentle stance -->
    <polyline points="512,596 470,716 452,842"/>
    <polyline points="512,596 554,716 572,842"/>
  </g>
  <!-- head -->
  <circle cx="512" cy="296" r="60" fill="#FFFFFF"/>
"""


def svg(mode):
    if mode == "foreground":
        # figure only, scaled into the adaptive safe zone, transparent bg
        return f"""<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="1024" viewBox="0 0 1024 1024">
  <g transform="translate(512,512) scale(0.62) translate(-512,-512)">
    {FIGURE}
  </g>
</svg>"""
    return f"""<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="1024" viewBox="0 0 1024 1024">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#33B6A6"/>
      <stop offset="1" stop-color="#1C7E72"/>
    </linearGradient>
    <radialGradient id="aura" cx="0.5" cy="0.40" r="0.55">
      <stop offset="0" stop-color="#7FE0D2" stop-opacity="0.55"/>
      <stop offset="0.6" stop-color="#7FE0D2" stop-opacity="0.16"/>
      <stop offset="1" stop-color="#7FE0D2" stop-opacity="0"/>
    </radialGradient>
  </defs>
  <rect width="1024" height="1024" fill="url(#bg)"/>
  <circle cx="512" cy="404" r="360" fill="url(#aura)"/>
  {FIGURE}
</svg>"""


def render(mode, size, path, flatten=None):
    png = cairosvg.svg2png(bytestring=svg(mode).encode(),
                           output_width=size, output_height=size)
    tmp = path + ".tmp.png"
    with open(tmp, "wb") as f:
        f.write(png)
    im = Image.open(tmp).convert("RGBA")
    if flatten is not None:
        bg = Image.new("RGBA", im.size, flatten)
        bg.alpha_composite(im)
        im = bg.convert("RGB")
    im.save(path)
    os.remove(tmp)
    return im


def main():
    # Apple needs a flat square with NO alpha; teal fallback irrelevant (full bg)
    render("full", 1024, os.path.join(STORE_ICON, "apple_icon_1024.png"),
           flatten=(42, 157, 143, 255))
    render("full", 512, os.path.join(STORE_ICON, "play_icon_512.png"))
    render("full", 1024, os.path.join(APP_ICON, "app_icon.png"),
           flatten=(42, 157, 143, 255))
    render("foreground", 1024, os.path.join(APP_ICON, "app_icon_foreground.png"))
    print("Icons written.")

    # preview: 512 store icon + a rounded (masked) preview to mimic launcher
    base = Image.open(os.path.join(STORE_ICON, "play_icon_512.png")).convert("RGBA")
    from PIL import ImageDraw
    rad = 112
    mask = Image.new("L", base.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, 512, 512], radius=rad, fill=255)
    rounded = Image.new("RGBA", base.size, (0, 0, 0, 0))
    rounded.paste(base, (0, 0), mask)
    sheet = Image.new("RGB", (512 * 2 + 48, 512 + 32), (246, 248, 248))
    sheet.paste(base.convert("RGB"), (16, 16))
    sheet.paste(Image.new("RGB", base.size, (246, 248, 248)), (512 + 32, 16))
    sheet.paste(rounded, (512 + 32, 16), rounded)
    sheet.save(os.path.join(HERE, "_icon_preview.png"))
    print("Preview written.")


if __name__ == "__main__":
    main()
