#!/usr/bin/env python3
"""StretchHome data/integration contract tests (api-tester pass).

The app has no HTTP backend; its "API" is ContentRepository.load() parsing
bundled JSON into models, plus asset + platform-config bindings. This harness
mirrors the Dart parser's strictness and the repository logic, and asserts the
data/integration contract holds. Exit code != 0 on any failure.

Run: python3 tools/test_app_contract.py
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
P = 0
F = 0
WARN = []


def ok(cond, name, detail=""):
    global P, F
    if cond:
        P += 1
    else:
        F += 1
        print(f"  ✗ FAIL: {name}" + (f" — {detail}" if detail else ""))


def warn(msg):
    WARN.append(msg)


def load(rel):
    with open(os.path.join(ROOT, rel)) as fh:
        return json.load(fh)


SECTIONS = {"neck", "shoulders_upper_back", "arms_wrists", "chest", "back",
            "hips_glutes", "hamstrings", "quads_hipflexors", "calves_ankles"}
PROPS = {"none", "chair", "wall", "table", "towel", "bag"}
LEVELS = {"gentle", "standard", "deeper"}
ASSET_TYPES = {"illustration", "video", "lottie"}

stretches = load("assets/data/stretches.json")["stretches"]
routines = load("assets/data/routines.json")["routines"]
by_id = {s["id"]: s for s in stretches}

print("== A. Parse contract (mirrors Stretch.fromJson hard casts) ==")
for s in stretches:
    sid = s.get("id")
    # fields cast `as String` with NO fallback -> must be present, non-null str
    for k in ("id", "name", "bodyPartId", "bodyPart"):
        ok(isinstance(s.get(k), str) and s.get(k) != "",
           f"stretch[{sid}].{k} is non-empty String", repr(s.get(k)))
    # cast `as int` -> must be a real int (not float/str) or parse throws
    ok(isinstance(s.get("holdSeconds", 30), int) and not isinstance(s.get("holdSeconds"), bool),
       f"stretch[{sid}].holdSeconds is int", repr(s.get("holdSeconds")))
    ok(isinstance(s.get("sides", 1), int),
       f"stretch[{sid}].sides is int", repr(s.get("sides")))
    ok(isinstance(s.get("props", []), list),
       f"stretch[{sid}].props is list")

for r in routines:
    rid = r.get("id")
    for k in ("id", "name"):
        ok(isinstance(r.get(k), str) and r.get(k) != "",
           f"routine[{rid}].{k} is non-empty String", repr(r.get(k)))
    ok(isinstance(r.get("minutes", 5), int),
       f"routine[{rid}].minutes is int", repr(r.get("minutes")))
    ok(isinstance(r.get("stretchIds", []), list),
       f"routine[{rid}].stretchIds is list")

print("== B. Referential integrity & uniqueness ==")
ids = [s["id"] for s in stretches]
ok(len(ids) == len(set(ids)), "no duplicate stretch ids",
   f"{len(ids)-len(set(ids))} dupes")
rids = [r["id"] for r in routines]
ok(len(rids) == len(set(rids)), "no duplicate routine ids")
for r in routines:
    for sid in r.get("stretchIds", []):
        ok(sid in by_id, f"routine[{r['id']}] references existing '{sid}'")
    ok(len(r.get("stretchIds", [])) > 0, f"routine[{r['id']}] is non-empty")

print("== C. Domain/enum validity ==")
for s in stretches:
    ok(s["bodyPartId"] in SECTIONS, f"stretch[{s['id']}].bodyPartId valid", s["bodyPartId"])
    ok(s.get("level", "standard") in LEVELS, f"stretch[{s['id']}].level valid", s.get("level"))
    ok(s.get("sides", 1) in (1, 2), f"stretch[{s['id']}].sides in (1,2)", s.get("sides"))
    ok(set(s.get("props", [])) <= PROPS, f"stretch[{s['id']}].props in vocab", s.get("props"))
    ok(s.get("assetType", "illustration") in ASSET_TYPES,
       f"stretch[{s['id']}].assetType valid", s.get("assetType"))

print("== D. Asset & platform-config integration ==")
for s in stretches:
    af = s.get("assetFile", "")
    if af:
        if os.path.exists(os.path.join(ROOT, af)):
            P += 1
        else:
            warn(f"assetFile missing on disk (runtime fallback will show): {af}")
for sec in SECTIONS:
    ok(os.path.exists(os.path.join(ROOT, "assets/icons/bodyparts", sec + ".png")),
       f"body-part icon exists: {sec}.png")
pub = open(os.path.join(ROOT, "pubspec.yaml")).read()
for decl in ("assets/data/", "assets/visuals/", "assets/icons/bodyparts/"):
    ok(decl in pub, f"pubspec declares {decl}")
manifest = open(os.path.join(ROOT, "android/app/src/main/AndroidManifest.xml")).read()
ok("com.google.android.gms.ads.APPLICATION_ID" in manifest, "Android AdMob APPLICATION_ID present")
ok("android.permission.INTERNET" in manifest, "INTERNET permission present (ads)")
plist = open(os.path.join(ROOT, "ios/Runner/Info.plist")).read()
ok("GADApplicationIdentifier" in plist, "iOS GADApplicationIdentifier present")

print("== E. Repository logic (replicated) ==")
def props_for_routine(r):
    out = set()
    for sid in r["stretchIds"]:
        out |= set(x for x in by_id[sid].get("props", []) if x != "none")
    return out

def daily_for(available):  # mirrors ContentRepository.dailySuggestionFor
    if not routines:
        return None
    pool = routines
    if available is not None:
        have = set(available) | {"none"}
        doable = [r for r in routines if props_for_routine(r) <= have]
        if doable:
            pool = doable
        else:
            def missing(r):
                return len([p for p in props_for_routine(r) if p not in have])
            fewest = min(missing(r) for r in routines)
            pool = [r for r in routines if missing(r) == fewest]
    return pool[__import__("datetime").datetime.now().day % len(pool)]

ok(daily_for(None) is not None, "dailySuggestionFor(null) returns a routine")
ok(daily_for(set()) is not None, "dailySuggestionFor(floor-only) never returns null")
for combo in [set(), {"chair"}, {"chair", "wall"}, PROPS - {"none"}]:
    ok(daily_for(combo) is not None, f"dailySuggestionFor({sorted(combo)}) non-null")
# Floor-only users now always get the closest (fewest-missing-prop) routine.
if not any(props_for_routine(r) <= {"none"} for r in routines):
    warn("No fully floor-only routine; floor-only users get the closest (fewest-prop) pick.")

def search(q):  # mirrors ContentRepository.search
    q = q.strip().lower()
    if not q:
        return []
    return [s for s in stretches if q in s["name"].lower()
            or q in s["bodyPart"].lower()
            or any(q in t.lower() for t in s.get("tags", []))]

ok(len(search("neck")) > 0, "search('neck') returns results")
ok(search("") == [], "search('') returns empty (browse-all handled separately)")
ok(len(search("zzzzz")) == 0, "search(nonsense) returns empty (empty-state path)")
for sec in SECTIONS:
    n = len([s for s in stretches if s["bodyPartId"] == sec])
    ok(n > 0, f"byBodyPart('{sec}') non-empty", str(n))

print("== F. Data quality ==")
for s in stretches:
    ok(len(s.get("steps", [])) >= 1, f"stretch[{s['id']}] has >=1 step")
    ok(5 <= s.get("holdSeconds", 30) <= 120, f"stretch[{s['id']}] holdSeconds sane", s.get("holdSeconds"))
    if not s.get("breathingCue"):
        warn(f"stretch[{s['id']}] has empty breathingCue")

# release-readiness flags (not failures)
gradle = os.path.join(ROOT, "android/app/build.gradle")
if os.path.exists(gradle) and "com.example" in open(gradle).read():
    warn("Android applicationId still com.example.* — must change before publishing.")

print()
print(f"RESULTS: {P} passed, {F} failed, {len(WARN)} warning(s)")
for w in WARN:
    print(f"  ⚠ {w}")
sys.exit(1 if F else 0)
