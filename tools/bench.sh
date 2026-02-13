#!/bin/bash
set -euo pipefail

GUETZLI=${1:-bin/Release/guetzli}
INPUT=${2:-bin/Release/in.jpg}
QUALITY=${QUALITY:-90}
RUNS=${RUNS:-7}

if [[ ! -x "$GUETZLI" ]]; then
  echo "missing executable: $GUETZLI" >&2
  exit 1
fi
if [[ ! -f "$INPUT" ]]; then
  echo "missing input: $INPUT" >&2
  exit 1
fi

TIME_CMD=""
if [[ -x /usr/bin/time ]]; then
  TIME_CMD="/usr/bin/time -f %e"
else
  echo "warning: /usr/bin/time not found, using shell time builtin" >&2
fi

times=()
for i in $(seq 1 "$RUNS"); do
  out="/tmp/guetzli-bench-$i.jpg"
  if [[ -n "$TIME_CMD" ]]; then
    t=$($TIME_CMD "$GUETZLI" --quality "$QUALITY" "$INPUT" "$out" 2>&1 >/dev/null)
  else
    TIMEFORMAT='%R'
    t=$({ time "$GUETZLI" --quality "$QUALITY" "$INPUT" "$out" >/dev/null; } 2>&1)
  fi
  times+=("$t")
  echo "run $i: $t"
done


median=$(printf '%s\n' "${times[@]}" | sort -n | awk 'NR==4{print $1}')
echo "median: $median"
