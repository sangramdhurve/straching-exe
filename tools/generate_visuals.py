#!/usr/bin/env python3
"""
Generate consistent, modern flat illustrations for every stretch, plus the app icon.
Output: assets/visuals/<id>.png (1080x1080) and assets/icon/app_icon*.png

These are stylized placeholder visuals (clean vector-style figures) so the app looks
finished before real photos/MP4s exist. Re-run any time: python3 tools/generate_visuals.py
"""
import json, os, math
from PIL import Image, ImageDraw, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SS = 3                      # supersample factor for smooth edges
SIZE = 1080
S = SIZE * SS

# ---- palette (matches app theme) ----
TEAL = (42, 157, 143)
TEAL_DK = (33, 134, 122)
FIGURE = (38, 110, 103)
FIGURE_DK = (26, 78, 73)
ACCENT = (244, 162, 97)     # warm amber
INK = (21, 48, 46)
WHITE = (255, 255, 255)
PROP = (150, 170, 166)

# soft background tint per body part
TINTS = {
    "neck": (215, 239, 236), "shoulders_upper_back": (221, 233, 242),
    "arms_wrists": (231, 227, 242), "chest": (252, 231, 210),
    "back": (227, 239, 217), "hips_glutes": (241, 226, 239),
    "hamstrings": (224, 238, 233), "quads_hipflexors": (251, 227, 218),
    "calves_ankles": (220, 235, 241),
}

def font(sz, bold=False):
    paths = [
        "/usr/share/fonts/truetype/dejavu/DejaVuSans%s.ttf" % ("-Bold" if bold else ""),
        "/usr/share/fonts/truetype/liberation/LiberationSans%s.ttf" % ("-Bold" if bold else ""),
    ]
    for p in paths:
        if os.path.exists(p):
            return ImageFont.truetype(p, sz)
    try:
        return ImageFont.load_default(sz)
    except Exception:
        return ImageFont.load_default()

# ---------- figure skeleton ----------
# joints in full-card normalized coords (0..1). Bones connect joints.
BONES = [("head", "chest"), ("chest", "pelvis"),
         ("chest", "shL"), ("shL", "elL"), ("elL", "haL"),
         ("chest", "shR"), ("shR", "elR"), ("elR", "haR"),
         ("pelvis", "knL"), ("knL", "ftL"),
         ("pelvis", "knR"), ("knR", "ftR")]

def base_standing():
    return dict(head=(.50, .19), chest=(.50, .30), pelvis=(.50, .52),
                shL=(.43, .32), elL=(.39, .42), haL=(.41, .53),
                shR=(.57, .32), elR=(.61, .42), haR=(.59, .53),
                knL=(.46, .66), ftL=(.46, .79),
                knR=(.54, .66), ftR=(.54, .79))

def pose_for(stretch):
    name = stretch["name"].lower()
    sid = stretch["id"]
    props = stretch["props"]
    j = base_standing()

    if any(k in name for k in ["cat", "thread", "child"]):
        # quadruped / folded
        j = dict(head=(.30, .50), chest=(.42, .50), pelvis=(.63, .50),
                 shL=(.40, .54), elL=(.40, .66), haL=(.40, .74),
                 shR=(.44, .54), elR=(.44, .66), haR=(.44, .74),
                 knL=(.63, .62), ftL=(.70, .74),
                 knR=(.66, .62), ftR=(.73, .74))
        if "child" in name:
            j = dict(head=(.34, .60), chest=(.46, .56), pelvis=(.64, .50),
                     shL=(.40, .60), elL=(.34, .66), haL=(.28, .70),
                     shR=(.42, .60), elR=(.36, .66), haR=(.30, .70),
                     knL=(.66, .60), ftL=(.74, .66),
                     knR=(.68, .60), ftR=(.76, .66))
        return j, "floor"
    if "butterfly" in name:
        j = dict(head=(.50, .30), chest=(.50, .40), pelvis=(.50, .62),
                 shL=(.44, .42), elL=(.40, .54), haL=(.46, .64),
                 shR=(.56, .42), elR=(.60, .54), haR=(.54, .64),
                 knL=(.36, .66), ftL=(.50, .70),
                 knR=(.64, .66), ftR=(.50, .70))
        return j, "floor"
    if "kneeling" in name:
        # half-kneel lunge, torso upright
        j = dict(head=(.50, .22), chest=(.50, .33), pelvis=(.50, .55),
                 shL=(.44, .35), elL=(.42, .46), haL=(.44, .55),
                 shR=(.56, .35), elR=(.58, .46), haR=(.56, .55),
                 knL=(.40, .70), ftL=(.30, .80),
                 knR=(.60, .68), ftR=(.66, .80))
        return j, "floor"
    if any(k in name for k in ["lying", "supine", "side-lying"]) or sid in ("knees_to_chest", "floor_chest_opener", "wall_hamstring", "towel_hamstring"):
        # lying on back, head left, legs raised right
        j = dict(head=(.22, .60), chest=(.34, .60), pelvis=(.56, .60),
                 shL=(.34, .56), elL=(.30, .50), haL=(.30, .44),
                 shR=(.34, .64), elR=(.30, .70), haR=(.30, .76),
                 knL=(.66, .46), ftL=(.74, .40),
                 knR=(.66, .52), ftR=(.76, .48))
        return j, "floor"
    if "fold" in name:
        j = dict(head=(.52, .55), chest=(.50, .44), pelvis=(.50, .34),
                 shL=(.47, .46), elL=(.47, .58), haL=(.48, .70),
                 shR=(.53, .46), elR=(.53, .58), haR=(.52, .70),
                 knL=(.47, .54), ftL=(.47, .80),
                 knR=(.53, .54), ftR=(.53, .80))
        # invert torso so pelvis is up — redo simply: standing bent at hip
        j = dict(head=(.50, .56), chest=(.50, .46), pelvis=(.50, .34),
                 shL=(.45, .48), elL=(.46, .60), haL=(.48, .70),
                 shR=(.55, .48), elR=(.54, .60), haR=(.52, .70),
                 knL=(.46, .52), ftL=(.46, .80),
                 knR=(.54, .52), ftR=(.54, .80))
        return j, "floor"
    if name.startswith("seated") or "seated" in name or sid in ("chair_hamstring", "ankle_circles", "seated_calf_towel"):
        j = dict(head=(.50, .24), chest=(.50, .34), pelvis=(.50, .56),
                 shL=(.44, .36), elL=(.42, .46), haL=(.44, .55),
                 shR=(.56, .36), elR=(.58, .46), haR=(.56, .55),
                 knL=(.46, .60), ftL=(.46, .80),
                 knR=(.62, .60), ftR=(.62, .80))
        if sid in ("chair_hamstring", "seated_calf_towel"):  # one leg extended
            j["knR"], j["ftR"] = (.66, .62), (.80, .68)
        return j, ("chair" if ("chair" in props) else "floor")
    if "overhead" in name or "triceps" in name:
        j["haR"], j["elR"] = (.55, .12), (.60, .22)
        return j, "floor"
    if "cross-body" in name or "cross body" in name:
        j["elR"], j["haR"] = (.50, .34), (.41, .34)
        return j, "floor"
    if "wall" in props:
        # lean toward wall on the left: hands up to wall, back leg straight
        j = dict(head=(.46, .26), chest=(.44, .36), pelvis=(.50, .54),
                 shL=(.40, .36), elL=(.32, .34), haL=(.24, .30),
                 shR=(.44, .38), elR=(.34, .36), haR=(.24, .34),
                 knL=(.60, .66), ftL=(.66, .80),
                 knR=(.46, .66), ftR=(.42, .80))
        return j, "wall"
    return j, "floor"

def draw_figure(d, j, color, outline):
    th = int(0.030 * S)
    def P(pt):
        return (pt[0] * S, pt[1] * S)
    # bones
    for a, b in BONES:
        d.line([P(j[a]), P(j[b])], fill=color, width=th, joint="curve")
    # round caps at joints
    r = th // 2
    for key, pt in j.items():
        if key == "head":
            continue
        x, y = P(pt)
        d.ellipse([x - r, y - r, x + r, y + r], fill=color)
    # head
    hx, hy = P(j["head"])
    hr = int(0.052 * S)
    d.ellipse([hx - hr, hy - hr, hx + hr, hy + hr], fill=color, outline=outline, width=max(2, th // 6))

def draw_prop(d, kind, j):
    def P(x, y):
        return (x * S, y * S)
    if kind == "chair":
        # seat under hips + backrest
        d.rounded_rectangle([P(.40, .57), P(.66, .62)], radius=int(.012 * S), fill=PROP)
        d.rounded_rectangle([P(.62, .34), P(.66, .62)], radius=int(.012 * S), fill=PROP)
        d.rounded_rectangle([P(.42, .62), P(.46, .82)], radius=int(.008 * S), fill=PROP)
        d.rounded_rectangle([P(.62, .62), P(.66, .82)], radius=int(.008 * S), fill=PROP)
    elif kind == "wall":
        d.rounded_rectangle([P(.16, .10), P(.21, .86)], radius=int(.01 * S), fill=PROP)

def floor_line(d):
    y = int(.80 * S)
    d.line([(int(.12 * S), y), (int(.88 * S), y)], fill=(0, 0, 0, 30), width=int(.006 * S))

# highlight region per body part (approx point on figure)
HILITE = {
    "neck": "head", "shoulders_upper_back": "shR", "arms_wrists": "haR",
    "chest": "chest", "back": "pelvis", "hips_glutes": "pelvis",
    "hamstrings": "knR", "quads_hipflexors": "knR", "calves_ankles": "ftR",
}

def draw_highlight(d, j, bodypart):
    key = HILITE.get(bodypart, "chest")
    x, y = j[key][0] * S, j[key][1] * S
    r = int(.075 * S)
    d.ellipse([x - r, y - r, x + r, y + r], outline=ACCENT, width=int(.012 * S))

def wrap(d, text, fnt, maxw):
    words, lines, cur = text.split(), [], ""
    for w in words:
        t = (cur + " " + w).strip()
        if d.textlength(t, font=fnt) <= maxw:
            cur = t
        else:
            if cur:
                lines.append(cur)
            cur = w
    if cur:
        lines.append(cur)
    return lines

def render_stretch(stretch):
    # Unified background tint for ALL stretches (kills the home-grid "patchwork").
    img = Image.new("RGB", (S, S), (236, 242, 241))
    d = ImageDraw.Draw(img, "RGBA")
    # soft inner card
    pad = int(.05 * S)
    d.rounded_rectangle([pad, pad, S - pad, S - pad], radius=int(.06 * S),
                        outline=(255, 255, 255, 120), width=int(.004 * S))
    floor_line(d)
    j, prop = pose_for(stretch)
    if "chair" in stretch["props"]:
        draw_prop(d, "chair", j)
    if "wall" in stretch["props"]:
        draw_prop(d, "wall", j)
    draw_figure(d, j, FIGURE, FIGURE_DK)
    draw_highlight(d, j, stretch["bodyPartId"])

    # label strip
    name_f = font(int(.046 * S), bold=True)
    sub_f = font(int(.030 * S))
    lines = wrap(d, stretch["name"], name_f, S - 2 * int(.10 * S))
    y = int(.845 * S)
    for ln in lines[:2]:
        d.text((int(.10 * S), y), ln, font=name_f, fill=INK)
        y += int(.058 * S)
    # duration pill
    pill = stretch["durationLabel"]
    pw = d.textlength(pill, font=sub_f)
    px0, py0 = int(.10 * S), int(.785 * S)
    d.rounded_rectangle([px0, py0, px0 + pw + int(.05 * S), py0 + int(.05 * S)],
                        radius=int(.025 * S), fill=(42, 157, 143, 235))
    d.text((px0 + int(.025 * S), py0 + int(.009 * S)), pill, font=sub_f, fill=WHITE)

    out = img.resize((SIZE, SIZE), Image.LANCZOS)
    path = os.path.join(ROOT, "assets", "visuals", stretch["id"] + ".png")
    out.save(path)

def render_icon():
    os.makedirs(os.path.join(ROOT, "assets", "icon"), exist_ok=True)
    # full-bleed icon
    img = Image.new("RGB", (S, S), TEAL)
    d = ImageDraw.Draw(img, "RGBA")
    # subtle gradient-ish darker corner
    d.ellipse([int(.55 * S), int(.55 * S), int(1.15 * S), int(1.15 * S)], fill=(33, 134, 122, 120))
    # stylized stretching figure (reaching up + side bend) in white
    j = dict(head=(.50, .26), chest=(.50, .38), pelvis=(.50, .60),
             shL=(.43, .40), elL=(.36, .32), haL=(.30, .24),
             shR=(.57, .40), elR=(.63, .50), haR=(.60, .60),
             knL=(.45, .74), ftL=(.42, .86),
             knR=(.55, .74), ftR=(.58, .86))
    th = int(0.045 * S)
    def P(pt):
        return (pt[0] * S, pt[1] * S)
    for a, b in BONES:
        d.line([P(j[a]), P(j[b])], fill=WHITE, width=th, joint="curve")
    r = th // 2
    for key, pt in j.items():
        if key == "head":
            continue
        x, y = P(pt)
        d.ellipse([x - r, y - r, x + r, y + r], fill=WHITE)
    hx, hy = P(j["head"]); hr = int(.075 * S)
    d.ellipse([hx - hr, hy - hr, hx + hr, hy + hr], fill=WHITE)
    img.resize((1024, 1024), Image.LANCZOS).save(os.path.join(ROOT, "assets", "icon", "app_icon.png"))

    # adaptive foreground (transparent, padded for Android safe zone)
    fg = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d2 = ImageDraw.Draw(fg)
    sc = 0.72
    off = (1 - sc) / 2
    def Pf(pt):
        return ((off + pt[0] * sc) * S, (off + pt[1] * sc) * S)
    for a, b in BONES:
        d2.line([Pf(j[a]), Pf(j[b])], fill=WHITE, width=int(th * sc), joint="curve")
    for key, pt in j.items():
        if key == "head":
            continue
        x, y = Pf(pt); rr = int(r * sc)
        d2.ellipse([x - rr, y - rr, x + rr, y + rr], fill=WHITE)
    hx, hy = Pf(j["head"]); hr = int(.075 * S * sc)
    d2.ellipse([hx - hr, hy - hr, hx + hr, hy + hr], fill=WHITE)
    fg.resize((1024, 1024), Image.LANCZOS).save(os.path.join(ROOT, "assets", "icon", "app_icon_foreground.png"))

def main():
    data = json.load(open(os.path.join(ROOT, "assets", "data", "stretches.json")))
    os.makedirs(os.path.join(ROOT, "assets", "visuals"), exist_ok=True)
    for s in data["stretches"]:
        render_stretch(s)
    render_icon()
    print("Generated %d stretch visuals + app icon." % len(data["stretches"]))

if __name__ == "__main__":
    main()
