"""Make the Bangla digit ১ (U+09E7) render with Noto Sans Bengali, as in Figma.

1. Remove U+09E7 from each Hind Siliguri cmap -> Flutter falls back.
2. Build small static Noto Sans Bengali files (digits + ৳ only) at the
   4 weights the app uses, so the fallback matches the weight.
Originals are kept in assets/fonts/original/.
"""
import os, shutil, sys
from fontTools.ttLib import TTFont
from fontTools.varLib import instancer
from fontTools import subset

root = sys.argv[1]
fonts = os.path.join(root, "assets", "fonts")
orig = os.path.join(fonts, "original")
os.makedirs(orig, exist_ok=True)

ONE = 0x09E7
for w in ["Regular", "Medium", "SemiBold", "Bold"]:
    name = f"HindSiliguri-{w}.ttf"
    src = os.path.join(fonts, name)
    keep = os.path.join(orig, name)
    if not os.path.exists(keep):
        shutil.copy2(src, keep)
    f = TTFont(keep)
    for t in f["cmap"].tables:
        if t.isUnicode() and ONE in t.cmap:
            del t.cmap[ONE]
    f.save(src)
    print("patched", name, ONE in TTFont(src).getBestCmap())

noto_src = os.path.join(fonts, "NotoSansBengali.ttf")
keep = os.path.join(orig, "NotoSansBengali.ttf")
if not os.path.exists(keep):
    shutil.copy2(noto_src, keep)

# Bangla digits ০-৯ + ৳ (only ১ is actually needed, keep the set tiny)
unicodes = list(range(0x09E6, 0x09F0)) + [0x09F3]
for weight, label in [(400, "Regular"), (500, "Medium"), (600, "SemiBold"), (700, "Bold")]:
    v = TTFont(keep)
    st = instancer.instantiateVariableFont(v, {"wght": weight, "wdth": 100})
    opts = subset.Options()
    opts.layout_features = ["*"]
    opts.name_IDs = ["*"]
    sub = subset.Subsetter(opts)
    sub.populate(unicodes=unicodes)
    sub.subset(st)
    out = os.path.join(fonts, f"NotoSansBengaliDigits-{label}.ttf")
    st.save(out)
    print("built", os.path.basename(out), os.path.getsize(out))

os.remove(noto_src)
print("removed full NotoSansBengali.ttf from app assets (kept in original/)")
