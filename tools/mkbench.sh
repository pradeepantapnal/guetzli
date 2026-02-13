#!/usr/bin/env bash
set -euo pipefail

in="${1:-bin/Release/in.jpg}"
out="${2:-/tmp/bench_800.jpg}"

if [[ ! -f "$in" ]]; then
  echo "Input not found: $in" >&2
  exit 1
fi

# Prefer ffmpeg if present.
if command -v ffmpeg >/dev/null 2>&1; then
  ffmpeg -y -loglevel error -i "$in" -vf "scale='if(gt(iw,ih),min(iw,800),-2)':'if(gt(ih,iw),min(ih,800),-2)'" "$out"
  echo "Wrote $out using ffmpeg"
  exit 0
fi

# Fallback: if image is already <=800x800, copy as-is.
python - "$in" "$out" <<'PY'
import sys
src,dst=sys.argv[1],sys.argv[2]
with open(src,'rb') as f:
    b=f.read()
if b[:2]!=b'\xff\xd8':
    raise SystemExit('Input is not a JPEG and ffmpeg is unavailable')
i=2
w=h=None
while i+9<len(b):
    if b[i]!=0xFF:
        i+=1; continue
    m=b[i+1]
    i+=2
    if m in (0xD8,0xD9) or (0xD0<=m<=0xD7):
        continue
    if i+2>len(b): break
    l=(b[i]<<8)|b[i+1]
    if l<2 or i+l>len(b): break
    if m in (0xC0,0xC1,0xC2,0xC3,0xC5,0xC6,0xC7,0xC9,0xCA,0xCB,0xCD,0xCE,0xCF):
        h=(b[i+3]<<8)|b[i+4]
        w=(b[i+5]<<8)|b[i+6]
        break
    i+=l
if w is None:
    raise SystemExit('Failed to parse JPEG dimensions')
if w>800 or h>800:
    raise SystemExit('Need ffmpeg (or similar) to resize; current image is larger than 800x800')
open(dst,'wb').write(b)
print(f'Wrote {dst} by copy ({w}x{h})')
PY
