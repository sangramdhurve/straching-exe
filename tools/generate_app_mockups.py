#!/usr/bin/env python3
"""High-fidelity recreations of StretchHome's key screens, for store screenshots.
Renders 5 phone screens (1080x2280) matching the real Material 3 UI + brand.

Output: store-assets/mockups/<screen>.png  +  tools/_mockups_preview.png
Deps: Pillow
"""
import os
from PIL import Image, ImageDraw, ImageFont

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
VIS = os.path.join(ROOT, "assets", "visuals")
BP = os.path.join(ROOT, "assets", "icons", "bodyparts")
OUT = os.path.join(ROOT, "store-assets", "mockups")
os.makedirs(OUT, exist_ok=True)

W, H = 1080, 2280
BG = (246, 248, 248)
SURF = (255, 255, 255)
SVAR = (233, 240, 239)
INK = (21, 48, 46)
MUTED = (74, 105, 102)
TEAL = (42, 157, 143)
TEALD = (33, 134, 122)
ACCENT = (244, 162, 97)
WHITE = (255, 255, 255)
TINTS = [(215, 239, 236), (252, 231, 210), (227, 239, 217), (221, 233, 242)]

F = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
FB = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"


def font(sz, bold=False):
    return ImageFont.truetype(FB if bold else F, sz)


def rrect(d, box, r, fill=None, outline=None, width=1):
    d.rounded_rectangle(box, radius=r, fill=fill, outline=outline, width=width)


def text(d, xy, s, sz, fill, bold=False, anchor="la"):
    d.text(xy, s, font=font(sz, bold), fill=fill, anchor=anchor)


def fit(path, size):
    im = Image.open(path).convert("RGBA")
    im.thumbnail((size, size), Image.LANCZOS)
    return im


def statusbar(d):
    text(d, (48, 34), "9:41", 30, INK, bold=True)
    # battery + signal hint (top right)
    d.rounded_rectangle([975, 32, 1035, 58], radius=7, outline=INK, width=3)
    d.rectangle([1037, 40, 1042, 50], fill=INK)
    d.rounded_rectangle([979, 36, 1018, 54], radius=4, fill=INK)


def magnifier(d, cx, cy, r, color, w=6):
    d.ellipse([cx - r, cy - r, cx + r, cy + r], outline=color, width=w)
    a = 0.7
    d.line([cx + r * a, cy + r * a, cx + r * a + 16, cy + r * a + 16],
           fill=color, width=w)


def heart(d, cx, cy, s, color, filled=False):
    # two lobes + V — drawn as outline or filled
    r = s * 0.32
    pts = [(cx, cy + s * 0.55), (cx - s * 0.5, cy - s * 0.02),
           (cx - s * 0.5, cy - s * 0.02)]
    if filled:
        d.ellipse([cx - s * 0.52, cy - s * 0.38, cx - s * 0.02, cy + s * 0.12],
                  fill=color)
        d.ellipse([cx + s * 0.02, cy - s * 0.38, cx + s * 0.52, cy + s * 0.12],
                  fill=color)
        d.polygon([(cx - s * 0.46, cy - s * 0.05), (cx + s * 0.46, cy - s * 0.05),
                   (cx, cy + s * 0.55)], fill=color)
    else:
        w = 6
        d.arc([cx - s * 0.52, cy - s * 0.40, cx - s * 0.02, cy + s * 0.14],
              150, 360, fill=color, width=w)
        d.arc([cx + s * 0.02, cy - s * 0.40, cx + s * 0.52, cy + s * 0.14],
              180, 30, fill=color, width=w)
        d.line([cx - s * 0.48, cy - s * 0.02, cx, cy + s * 0.55], fill=color, width=w)
        d.line([cx + s * 0.48, cy - s * 0.02, cx, cy + s * 0.55], fill=color, width=w)


def check(d, cx, cy, s, color, w=14):
    d.line([(cx - s * 0.45, cy + s * 0.02), (cx - s * 0.10, cy + s * 0.38),
            (cx + s * 0.48, cy - s * 0.34)], fill=color, width=w, joint="curve")


def chevron(d, cx, cy, s, color, w=6):
    d.line([(cx - s * 0.3, cy - s * 0.5), (cx + s * 0.3, cy),
            (cx - s * 0.3, cy + s * 0.5)], fill=color, width=w, joint="curve")


def arrow_back(d, cx, cy, s, color, w=7):
    d.line([(cx + s * 0.4, cy), (cx - s * 0.4, cy)], fill=color, width=w)
    d.line([(cx - s * 0.4, cy), (cx - s * 0.02, cy - s * 0.38)], fill=color, width=w)
    d.line([(cx - s * 0.4, cy), (cx - s * 0.02, cy + s * 0.38)], fill=color, width=w)


def ring(d, cx, cy, R, label, sub, track=SVAR, prog=TEAL, frac=0.72):
    wdt = 26
    d.ellipse([cx - R, cy - R, cx + R, cy + R], outline=track, width=wdt)
    d.arc([cx - R, cy - R, cx + R, cy + R], -90, -90 + int(360 * frac),
          fill=prog, width=wdt)
    text(d, (cx, cy - 6), label, 96, INK, bold=True, anchor="mm")
    if sub:
        text(d, (cx, cy + 66), sub, 30, MUTED, anchor="mm")


def bottomnav(d, active=0):
    y0 = H - 150
    d.rectangle([0, y0, W, H], fill=SURF)
    d.line([0, y0, W, y0], fill=(224, 232, 230), width=2)
    items = ["Home", "Routines", "Favorites", "Settings"]
    for i, lab in enumerate(items):
        cx = 135 + i * 270
        col = TEAL if i == active else MUTED
        cy = y0 + 52
        if i == 0:
            d.rounded_rectangle([cx - 22, cy - 18, cx + 22, cy + 18], radius=6,
                                outline=col, width=6)
            d.polygon([(cx - 30, cy - 6), (cx, cy - 32), (cx + 30, cy - 6)], fill=col)
        elif i == 1:
            for k in range(3):
                d.line([cx - 18, cy - 16 + k * 16, cx + 18, cy - 16 + k * 16],
                       fill=col, width=6)
        elif i == 2:
            heart(d, cx, cy, 46, col, filled=(i == active))
        else:
            d.ellipse([cx - 20, cy - 20, cx + 20, cy + 20], outline=col, width=6)
            d.ellipse([cx - 6, cy - 6, cx + 6, cy + 6], fill=col)
        text(d, (cx, y0 + 104), lab, 24, col, anchor="mm")


def base():
    img = Image.new("RGB", (W, H), BG)
    return img, ImageDraw.Draw(img)


# ---------------- Screen 1: Home ----------------
def home():
    img, d = base()
    statusbar(d)
    text(d, (64, 118), "Good morning", 34, MUTED)
    text(d, (64, 162), "Time to stretch", 66, INK, bold=True)
    # streak chip
    rrect(d, [792, 150, 1016, 222], 36, fill=(252, 233, 214))
    d.polygon([(832, 172), (846, 158), (858, 178), (846, 204)], fill=ACCENT)
    text(d, (876, 186), "3 days", 32, INK, bold=True, anchor="lm")
    # search
    rrect(d, [64, 290, 1016, 392], 28, fill=SVAR)
    magnifier(d, 116, 341, 22, MUTED)
    text(d, (168, 341), "Search stretches", 36, MUTED, anchor="lm")
    # today's pick
    rrect(d, [64, 430, 1016, 742], 36, fill=TEAL)
    text(d, (108, 478), "TODAY'S PICK", 28, (220, 240, 237), bold=True)
    text(d, (108, 516), "Morning Wake-Up", 56, WHITE, bold=True)
    text(d, (108, 590), "A gentle 6-minute routine to ease", 32, (224, 242, 239))
    text(d, (108, 632), "into your day.", 32, (224, 242, 239))
    d.ellipse([108, 678, 156, 726], outline=WHITE, width=5)
    d.line([124, 702, 144, 702], fill=WHITE, width=5)
    d.line([138, 694, 146, 702], fill=WHITE, width=5)
    d.line([138, 710, 146, 702], fill=WHITE, width=5)
    text(d, (176, 702), "6 min  •  6 stretches", 32, WHITE, bold=True, anchor="lm")
    # grid
    text(d, (64, 800), "Stretch by body part", 42, INK, bold=True)
    cards = [("neck", "Neck", "5 stretches"),
             ("shoulders_upper_back", "Shoulders &\nUpper Back", "5 stretches"),
             ("hips_glutes", "Hips & Glutes", "5 stretches"),
             ("hamstrings", "Hamstrings", "5 stretches")]
    gx, gy, gw, gh, gap = 64, 880, 460, 300, 32
    for i, (bid, name, meta) in enumerate(cards):
        cx = gx + (i % 2) * (gw + gap)
        cy = gy + (i // 2) * (gh + gap)
        rrect(d, [cx, cy, cx + gw, cy + gh], 28, fill=SURF)
        rrect(d, [cx + 40, cy + 40, cx + 136, cy + 136], 22, fill=TINTS[i])
        ic = fit(os.path.join(BP, bid + ".png"), 84)
        img.paste(ic, (cx + 48 + (88 - ic.width) // 2,
                       cy + 48 + (88 - ic.height) // 2), ic)
        ty = cy + 168
        for line in name.split("\n"):
            text(d, (cx + 40, ty), line, 36, INK, bold=True)
            ty += 44
        text(d, (cx + 40, cy + gh - 50), meta, 28, MUTED)
    bottomnav(d, active=0)
    img.save(os.path.join(OUT, "01_home.png"))


# ---------------- Screen 2: Stretch detail ----------------
def detail():
    img, d = base()
    statusbar(d)
    arrow_back(d, 84, 130, 44, INK)
    heart(d, 1000, 130, 52, TEAL)
    text(d, (64, 210), "Standing Calf Stretch", 56, INK, bold=True)
    text(d, (64, 286), "Calves & Ankles  •  Gastrocnemius", 32, MUTED)
    # illustration card
    rrect(d, [64, 350, 1016, 1130], 32, fill=SVAR)
    vis = fit(os.path.join(VIS, "ankle_dorsiflexion_wall.png"), 720)
    img.paste(vis, ((W - vis.width) // 2, 360 + (760 - vis.height) // 2),
              vis if vis.mode == "RGBA" else None)
    # timer ring
    ring(d, W // 2, 1420, 230, "30s", "tap to pause")
    # level segmented
    rrect(d, [64, 1700, 1016, 1790], 45, fill=SVAR)
    rrect(d, [70, 1706, 388, 1784], 42, fill=TEAL)
    text(d, (229, 1745), "Gentle", 34, WHITE, bold=True, anchor="mm")
    text(d, (546, 1745), "Standard", 34, MUTED, anchor="mm")
    text(d, (864, 1745), "Deeper", 34, MUTED, anchor="mm")
    # steps
    text(d, (64, 1850), "Steps", 40, INK, bold=True)
    steps = ["Stand facing a wall, hands at chest height.",
             "Step one foot back, heel pressed down.",
             "Lean in gently until you feel the calf stretch."]
    for i, s in enumerate(steps):
        yy = 1930 + i * 92
        d.ellipse([64, yy, 112, yy + 48], fill=(215, 239, 236))
        text(d, (88, yy + 24), str(i + 1), 30, TEALD, bold=True, anchor="mm")
        text(d, (140, yy + 24), s, 31, INK, anchor="lm")
    img.save(os.path.join(OUT, "02_detail.png"))


# ---------------- Screen 3: Routine player ----------------
def player():
    img, d = base()
    statusbar(d)
    d.line([64, 150, 64, 150], fill=INK)
    arrow_back(d, 84, 150, 40, INK)  # X-ish close substitute
    d.line([70, 136, 98, 164], fill=INK, width=7)
    d.line([98, 136, 70, 164], fill=INK, width=7)
    rrect(d, [140, 138, 940, 162], 12, fill=SVAR)
    rrect(d, [140, 138, 140 + int(800 * 0.375), 162], 12, fill=TEAL)
    text(d, (1010, 150), "3/8", 32, INK, bold=True, anchor="rm")
    text(d, (W // 2, 360), "Seated Forward Fold", 58, INK, bold=True, anchor="mm")
    text(d, (W // 2, 430), "Hold", 38, TEAL, bold=True, anchor="mm")
    vis = fit(os.path.join(VIS, "chair_hamstring.png"), 560)
    img.paste(vis, ((W - vis.width) // 2, 520), vis if vis.mode == "RGBA" else None)
    ring(d, W // 2, 1340, 250, "25s", None)
    text(d, (W // 2, 1660), "Breathe out as you fold forward", 34, MUTED, anchor="mm")
    # controls
    cy = 1830
    for cx, kind in [(330, "restart"), (W // 2, "pause"), (750, "skip")]:
        if kind == "pause":
            d.ellipse([cx - 70, cy - 70, cx + 70, cy + 70], fill=TEAL)
            d.rectangle([cx - 22, cy - 28, cx - 6, cy + 28], fill=WHITE)
            d.rectangle([cx + 6, cy - 28, cx + 22, cy + 28], fill=WHITE)
        else:
            d.ellipse([cx - 56, cy - 56, cx + 56, cy + 56], fill=SVAR)
            if kind == "restart":
                d.arc([cx - 26, cy - 26, cx + 26, cy + 26], 40, 320, fill=TEALD, width=7)
                d.polygon([(cx + 20, cy - 30), (cx + 34, cy - 12), (cx + 10, cy - 10)],
                          fill=TEALD)
            else:
                d.polygon([(cx - 24, cy - 24), (cx + 4, cy), (cx - 24, cy + 24)], fill=TEALD)
                d.polygon([(cx + 2, cy - 24), (cx + 30, cy), (cx + 2, cy + 24)], fill=TEALD)
    text(d, (330, 1930), "Restart", 26, MUTED, anchor="mm")
    text(d, (W // 2, 1930), "Pause", 26, MUTED, anchor="mm")
    text(d, (750, 1930), "Skip", 26, MUTED, anchor="mm")
    img.save(os.path.join(OUT, "03_player.png"))


# ---------------- Screen 4: Body-part list ----------------
def bodylist():
    img, d = base()
    statusbar(d)
    arrow_back(d, 84, 130, 44, INK)
    text(d, (148, 130), "Hips & Glutes", 50, INK, bold=True, anchor="lm")
    text(d, (64, 210), "Props", 28, MUTED, bold=True)
    chips = [("All", True), ("Chair", False), ("Wall", False), ("Floor", False)]
    x = 64
    for lab, sel in chips:
        w = font(30).getlength(lab) + 76
        rrect(d, [x, 256, x + w, 326], 35, fill=TEAL if sel else SVAR)
        text(d, (x + w / 2, 291), lab, 30, WHITE if sel else MUTED, anchor="mm")
        x += w + 20
    text(d, (64, 366), "Level", 28, MUTED, bold=True)
    chips2 = [("All", True), ("Gentle", False), ("Standard", False), ("Deeper", False)]
    x = 64
    for lab, sel in chips2:
        w = font(30).getlength(lab) + 76
        rrect(d, [x, 412, x + w, 482], 35, fill=TEAL if sel else SVAR)
        text(d, (x + w / 2, 447), lab, 30, WHITE if sel else MUTED, anchor="mm")
        x += w + 20
    rows = [("figure_four_chair", "Figure-Four (Chair)", "Chair  •  30s each side"),
            ("knees_to_chest", "Knees to Chest", "Floor  •  30s"),
            ("butterfly_stretch", "Butterfly Stretch", "Floor  •  40s"),
            ("kneeling_hip_flexor", "Kneeling Hip Flexor", "Floor  •  30s each side")]
    y = 540
    for bid, name, meta in rows:
        rrect(d, [64, y, 1016, y + 200], 28, fill=SURF)
        rrect(d, [88, y + 28, 232, y + 172], 22, fill=(233, 240, 239))
        vis = fit(os.path.join(VIS, bid + ".png"), 138)
        img.paste(vis, (90 + (142 - vis.width) // 2, y + 30 + (142 - vis.height) // 2),
                  vis if vis.mode == "RGBA" else None)
        text(d, (266, y + 70), name, 38, INK, bold=True)
        text(d, (266, y + 124), meta, 30, MUTED)
        heart(d, 904, y + 100, 50, TEAL)
        chevron(d, 968, y + 100, 44, MUTED)
        y += 224
    bottomnav(d, active=0)
    img.save(os.path.join(OUT, "04_bodylist.png"))


# ---------------- Screen 5: Completion ----------------
def completion():
    img, d = base()
    statusbar(d)
    cx, cy = W // 2, 760
    for rr, al in [(230, (215, 239, 236)), (170, (199, 233, 228))]:
        d.ellipse([cx - rr, cy - rr, cx + rr, cy + rr], fill=al)
    d.ellipse([cx - 120, cy - 120, cx + 120, cy + 120], fill=TEAL)
    check(d, cx, cy, 150, WHITE, w=22)
    text(d, (cx, 1080), "Nicely done!", 70, INK, bold=True, anchor="mm")
    text(d, (cx, 1168), "You finished “Morning Wake-Up”.", 36, MUTED, anchor="mm")
    text(d, (cx, 1214), "Your body thanks you.", 36, MUTED, anchor="mm")
    stats = [("6", "stretches"), ("6", "minutes"), ("3", "day streak")]
    for i, (v, l) in enumerate(stats):
        sx = 270 + i * 270
        text(d, (sx, 1400), v, 76, TEAL, bold=True, anchor="mm")
        text(d, (sx, 1470), l, 30, MUTED, anchor="mm")
    rrect(d, [180, 1640, 900, 1748], 54, fill=TEAL)
    text(d, (W // 2, 1694), "Done", 40, WHITE, bold=True, anchor="mm")
    img.save(os.path.join(OUT, "05_completion.png"))


def main():
    home(); detail(); player(); bodylist(); completion()
    files = ["01_home", "02_detail", "03_player", "04_bodylist", "05_completion"]
    thumbs = [Image.open(os.path.join(OUT, f + ".png")).resize((324, 684), Image.LANCZOS)
              for f in files]
    sheet = Image.new("RGB", (324 * 5 + 16 * 6, 684 + 32), (235, 238, 238))
    for i, t in enumerate(thumbs):
        sheet.paste(t, (16 + i * (324 + 16), 16))
    sheet.save(os.path.join(HERE, "_mockups_preview.png"))
    print("Mockups + preview written to", OUT)


if __name__ == "__main__":
    main()
