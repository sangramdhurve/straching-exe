#!/usr/bin/env python3
"""Generate a consistent set of 9 "body-map" icons for StretchHome's body-part
sections. Each icon is the same soft figure silhouette with the relevant region
highlighted in brand teal — so the Home grid reads as one cohesive set instead
of nine unrelated Material glyphs.

Output: assets/icons/bodyparts/<id>.png  (256x256, transparent, 4x supersampled)
Also writes tools/_bodypart_preview.png — a contact sheet for eyeballing.

Run:  python3 tools/generate_bodypart_icons.py
Deps: Pillow
"""
import os
from PIL import Image, ImageDraw, ImageChops, ImageFont

SS = 4                      # supersample factor
OUT = 256
C = OUT * SS               # canvas (working) size
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
ICON_DIR = os.path.join(ROOT, "assets", "icons", "bodyparts")
os.makedirs(ICON_DIR, exist_ok=True)

BASE = (185, 203, 199, 255)   # muted sage-gray figure
TEAL = (42, 157, 143, 255)    # brand primary #2A9D8F


def s(v):
    """scale a 256-space coordinate to the supersampled canvas."""
    return v * SS


def capsule(d, p1, p2, w, fill):
    x1, y1 = s(p1[0]), s(p1[1])
    x2, y2 = s(p2[0]), s(p2[1])
    r = s(w) / 2
    d.line([(x1, y1), (x2, y2)], fill=fill, width=int(s(w)))
    for (cx, cy) in ((x1, y1), (x2, y2)):
        d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=fill)


def rrect(d, box, rad, fill):
    x0, y0, x1, y1 = [s(v) for v in box]
    d.rounded_rectangle([x0, y0, x1, y1], radius=s(rad), fill=fill)


def ellipse(d, cx, cy, rx, ry, fill):
    d.ellipse([s(cx - rx), s(cy - ry), s(cx + rx), s(cy + ry)], fill=fill)


def draw_figure(d, fill):
    """The shared front-facing silhouette (all coords in 256-space)."""
    # head + neck
    ellipse(d, 128, 42, 20, 22, fill)
    capsule(d, (128, 59), (128, 75), 16, fill)
    # torso
    rrect(d, (103, 71, 153, 150), 14, fill)
    # shoulders
    capsule(d, (108, 82), (148, 82), 17, fill)
    # arms (shoulder -> hand), slightly out
    capsule(d, (108, 84), (92, 168), 15, fill)
    capsule(d, (148, 84), (164, 168), 15, fill)
    ellipse(d, 92, 170, 9, 9, fill)
    ellipse(d, 164, 170, 9, 9, fill)
    # pelvis
    rrect(d, (105, 140, 151, 166), 12, fill)
    # legs (hip -> foot)
    capsule(d, (118, 150), (113, 232), 16, fill)
    capsule(d, (138, 150), (143, 232), 16, fill)
    # feet
    ellipse(d, 111, 236, 11, 7, fill)
    ellipse(d, 145, 236, 11, 7, fill)


# Highlight shapes per body part (drawn generously; clipped to the silhouette).
def hl_neck(d):
    capsule(d, (128, 56), (128, 78), 18, TEAL)


def hl_shoulders(d):
    rrect(d, (103, 71, 153, 95), 10, TEAL)
    capsule(d, (108, 82), (148, 82), 18, TEAL)


def hl_arms(d):
    capsule(d, (108, 84), (92, 168), 16, TEAL)
    capsule(d, (148, 84), (164, 168), 16, TEAL)
    ellipse(d, 92, 170, 10, 10, TEAL)
    ellipse(d, 164, 170, 10, 10, TEAL)


def hl_chest(d):
    rrect(d, (104, 86, 152, 114), 8, TEAL)


def hl_back(d):
    rrect(d, (104, 116, 152, 146), 8, TEAL)


def hl_hips(d):
    rrect(d, (103, 139, 153, 168), 12, TEAL)


def hl_quads(d):
    capsule(d, (118, 154), (115, 198), 17, TEAL)
    capsule(d, (138, 154), (141, 198), 17, TEAL)


def hl_hamstrings(d):
    capsule(d, (116, 176), (114, 214), 17, TEAL)
    capsule(d, (140, 176), (142, 214), 17, TEAL)


def hl_calves(d):
    capsule(d, (114, 206), (112, 232), 16, TEAL)
    capsule(d, (142, 206), (144, 232), 16, TEAL)
    ellipse(d, 111, 236, 11, 7, TEAL)
    ellipse(d, 145, 236, 11, 7, TEAL)


PARTS = [
    ("neck", "Neck", hl_neck),
    ("shoulders_upper_back", "Shoulders", hl_shoulders),
    ("arms_wrists", "Arms", hl_arms),
    ("chest", "Chest", hl_chest),
    ("back", "Back", hl_back),
    ("hips_glutes", "Hips", hl_hips),
    ("hamstrings", "Hamstrings", hl_hamstrings),
    ("quads_hipflexors", "Quads", hl_quads),
    ("calves_ankles", "Calves", hl_calves),
]


def render(part_id, hl_fn):
    # 1) silhouette
    fig = Image.new("RGBA", (C, C), (0, 0, 0, 0))
    draw_figure(ImageDraw.Draw(fig), BASE)
    body_alpha = fig.split()[3]

    # 2) highlight layer
    hl = Image.new("RGBA", (C, C), (0, 0, 0, 0))
    hl_fn(ImageDraw.Draw(hl))
    hl_alpha = hl.split()[3]

    # 3) clip highlight to the body and paint teal there
    clip = ImageChops.multiply(hl_alpha, body_alpha)
    teal = Image.new("RGBA", (C, C), TEAL)
    out = fig.copy()
    out.paste(teal, (0, 0), clip)

    out = out.resize((OUT, OUT), Image.LANCZOS)
    out.save(os.path.join(ICON_DIR, f"{part_id}.png"))
    return out


def main():
    imgs = []
    for pid, _label, fn in PARTS:
        imgs.append(render(pid, fn))
    print(f"Wrote {len(imgs)} icons to {ICON_DIR}")

    # contact sheet on a tinted card background, to mimic the Home grid look
    tints = [(215, 239, 236), (252, 231, 210), (227, 239, 217),
             (221, 233, 242), (241, 226, 239)]
    cell, pad = 150, 16
    cols = 3
    rows = (len(PARTS) + cols - 1) // cols
    sheet = Image.new("RGB", (cols * cell, rows * cell), (246, 248, 248))
    sd = ImageDraw.Draw(sheet)
    try:
        font = ImageFont.truetype(
            "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 16)
    except Exception:
        font = ImageFont.load_default()
    for i, (pid, label, _fn) in enumerate(PARTS):
        cx = (i % cols) * cell
        cy = (i // cols) * cell
        tint = tints[i % len(tints)]
        sd.rounded_rectangle(
            [cx + pad, cy + pad, cx + cell - pad, cy + cell - pad],
            radius=20, fill=tint)
        icon = imgs[i].resize((84, 84), Image.LANCZOS)
        sheet.paste(icon, (cx + (cell - 84) // 2, cy + 22), icon)
        sd.text((cx + cell // 2, cy + cell - 24), label, fill=(40, 60, 58),
                font=font, anchor="mm")
    preview = os.path.join(HERE, "_bodypart_preview.png")
    sheet.save(preview)
    print(f"Wrote preview {preview}")


if __name__ == "__main__":
    main()
