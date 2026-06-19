#!/usr/bin/env python3
"""StretchHome store marketing graphics — feature graphic + device-framed,
captioned screenshots at every required Google Play + Apple size.

Outputs under store-assets/:
  feature/play_feature_graphic_1024x500.png
  screenshots/play/*.png            (1080x1920, 9:16)
  screenshots/apple_6_7/*.png       (1290x2796)
  screenshots/apple_6_9/*.png       (1320x2868)
  tools/_screens_preview.png

Deps: Pillow
"""
import os
from PIL import Image, ImageDraw, ImageFont

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
MOCK = os.path.join(ROOT, "store-assets", "mockups")
ICON = os.path.join(ROOT, "store-assets", "icon", "play_icon_512.png")
SA = os.path.join(ROOT, "store-assets")

INK = (21, 48, 46)
MUTED = (74, 105, 102)
TEAL = (42, 157, 143)
WHITE = (255, 255, 255)
F = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
FB = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"


def font(sz, bold=True):
    return ImageFont.truetype(FB if bold else F, sz)


def vgrad(w, h, top, bot):
    img = Image.new("RGB", (w, h), top)
    d = ImageDraw.Draw(img)
    for y in range(h):
        t = y / max(1, h - 1)
        d.line([(0, y), (w, y)],
               fill=tuple(int(top[i] + (bot[i] - top[i]) * t) for i in range(3)))
    return img


def dgrad(w, h, c1, c2):
    """diagonal gradient"""
    img = Image.new("RGB", (w, h), c1)
    d = ImageDraw.Draw(img)
    for y in range(h):
        t = y / max(1, h - 1)
        d.line([(0, y), (w, y)],
               fill=tuple(int(c1[i] + (c2[i] - c1[i]) * t) for i in range(3)))
    return img


def phone(mock_path, screen_w, corner=70, bezel=18, notch=True):
    """Return an RGBA phone with the mockup inside a dark bezel."""
    m = Image.open(mock_path).convert("RGB")
    sw = screen_w
    sh = int(sw * m.height / m.width)
    screen = m.resize((sw, sh), Image.LANCZOS).convert("RGBA")
    # round screen corners
    sc = corner - bezel
    mask = Image.new("L", (sw, sh), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, sw, sh], radius=sc, fill=255)
    screen.putalpha(mask)
    pw, ph = sw + bezel * 2, sh + bezel * 2
    ph_img = Image.new("RGBA", (pw, ph), (0, 0, 0, 0))
    body = Image.new("RGBA", (pw, ph), (0, 0, 0, 0))
    ImageDraw.Draw(body).rounded_rectangle([0, 0, pw, ph], radius=corner,
                                           fill=(18, 28, 27, 255))
    ph_img.alpha_composite(body)
    ph_img.alpha_composite(screen, (bezel, bezel))
    if notch:
        d = ImageDraw.Draw(ph_img)
        cx = pw // 2
        d.rounded_rectangle([cx - 70, bezel + 14, cx + 70, bezel + 40],
                            radius=13, fill=(18, 28, 27, 255))
    # subtle shadow
    shadow = Image.new("RGBA", (pw + 80, ph + 80), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        [40, 52, pw + 40, ph + 52], radius=corner, fill=(10, 30, 28, 70))
    shadow = shadow.filter(__import__("PIL.ImageFilter", fromlist=["GaussianBlur"])
                           .GaussianBlur(26))
    out = Image.new("RGBA", (pw + 80, ph + 80), (0, 0, 0, 0))
    out.alpha_composite(shadow)
    out.alpha_composite(ph_img, (40, 40))
    return out


def wrap(draw, txt, fnt, maxw):
    words, lines, cur = txt.split(), [], ""
    for w in words:
        t = (cur + " " + w).strip()
        if draw.textlength(t, font=fnt) <= maxw:
            cur = t
        else:
            lines.append(cur)
            cur = w
    if cur:
        lines.append(cur)
    return lines


SHOTS = [
    ("01_home.png", "Full-body stretches,", "made for home", (224, 242, 238)),
    ("02_detail.png", "Follow a calm", "hold-timer", (252, 240, 226)),
    ("03_player.png", "Guided routines that", "flow hands-free", (224, 242, 238)),
    ("04_bodylist.png", "Target exactly where", "you feel tight", (226, 240, 220)),
    ("05_completion.png", "Build a gentle", "daily streak", (224, 242, 238)),
]


def screenshot(cw, ch, mock, line1, line2, tint, scale_phone=0.82):
    bg = vgrad(cw, ch, tint, (248, 250, 250))
    d = ImageDraw.Draw(bg)
    # soft accent circle
    acc = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    ImageDraw.Draw(acc).ellipse([cw - int(cw * 0.5), -int(cw * 0.2),
                                 cw + int(cw * 0.35), int(cw * 0.45)],
                                fill=(42, 157, 143, 28))
    bg = Image.alpha_composite(bg.convert("RGBA"), acc).convert("RGB")
    d = ImageDraw.Draw(bg)
    # caption
    pad = int(cw * 0.085)
    ts = int(cw * 0.072)
    fnt = font(ts, True)
    y = int(ch * 0.06)
    d.text((pad, y), line1, font=fnt, fill=INK)
    d.text((pad, y + int(ts * 1.12)), line2, font=fnt, fill=TEAL)
    # phone
    ph = phone(os.path.join(MOCK, mock), screen_w=int(cw * scale_phone))
    px = (cw - ph.width) // 2
    py = int(ch * 0.255)
    bg.paste(ph, (px, py), ph)
    return bg


def feature_graphic():
    cw, ch = 1024, 500
    bg = dgrad(cw, ch, (51, 182, 166), (28, 126, 114))
    # faint reaching figure motif (reuse icon foreground silhouette feel) — soft circle
    acc = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    ImageDraw.Draw(acc).ellipse([560, -120, 1060, 380], fill=(127, 224, 210, 40))
    bg = Image.alpha_composite(bg.convert("RGBA"), acc)
    d = ImageDraw.Draw(bg)
    # text block (left)
    d.text((70, 150), "StretchHome", font=font(78, True), fill=WHITE)
    for i, ln in enumerate(["Gentle full-body stretches", "you can do at home."]):
        d.text((74, 270 + i * 50), ln, font=font(34, False), fill=(226, 244, 240))
    # pill
    pill = "FREE  •  ALL AGES  •  NO GYM"
    pw = d.textlength(pill, font=font(24, True)) + 56
    d.rounded_rectangle([74, 388, 74 + pw, 446], radius=29,
                        outline=(255, 255, 255), width=3)
    d.text((74 + pw / 2, 417), pill, font=font(24, True), fill=WHITE, anchor="mm")
    # phone (home) on the right, bleeding off bottom
    ph = phone(os.path.join(MOCK, "01_home.png"), screen_w=300, corner=54, bezel=14)
    ph = ph.rotate(-8, expand=True, resample=Image.BICUBIC)
    bg.alpha_composite(ph, (690, 70))
    # app icon badge
    ic = Image.open(ICON).convert("RGBA").resize((132, 132), Image.LANCZOS)
    mask = Image.new("L", ic.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, 132, 132], radius=30, fill=255)
    bg.paste(ic, (610, 40), mask)
    out = os.path.join(SA, "feature")
    os.makedirs(out, exist_ok=True)
    bg.convert("RGB").save(os.path.join(out, "play_feature_graphic_1024x500.png"))


def main():
    feature_graphic()
    sizes = [("play", 1080, 1920), ("apple_6_7", 1290, 2796), ("apple_6_9", 1320, 2868)]
    for folder, cw, ch in sizes:
        outdir = os.path.join(SA, "screenshots", folder)
        os.makedirs(outdir, exist_ok=True)
        for i, (mock, l1, l2, tint) in enumerate(SHOTS):
            img = screenshot(cw, ch, mock, l1, l2, tint)
            img.save(os.path.join(outdir, f"{i+1:02d}_{folder}.png"))
    # preview row (play set)
    pv = [Image.open(os.path.join(SA, "screenshots", "play", f"{i+1:02d}_play.png"))
          .resize((324, 576), Image.LANCZOS) for i in range(5)]
    sheet = Image.new("RGB", (324 * 5 + 16 * 6, 576 + 32), (235, 238, 238))
    for i, t in enumerate(pv):
        sheet.paste(t, (16 + i * (324 + 16), 16))
    sheet.save(os.path.join(HERE, "_screens_preview.png"))
    fg = Image.open(os.path.join(SA, "feature", "play_feature_graphic_1024x500.png"))
    fg.save(os.path.join(HERE, "_feature_preview.png"))
    print("Store graphics written.")


if __name__ == "__main__":
    main()
