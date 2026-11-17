#!/usr/bin/env bash
# Benchmark reply length at each tldr level using headless Claude Code.
# Usage: bench/run.sh [model]     (from the repo root; ~40 calls, roughly $1)
# Each prompt runs with no tools, once with no style (base) and once per level.
set -euo pipefail
cd "$(dirname "$0")"
model=${1:-}
root=$(cd .. && pwd)
mkdir -p out cfg
for l in min normal max; do
  echo "{\"default\":\"$l\"}" > cfg/$l.json
  { echo "Reply in tldr style by default, unless I say \"tldr off\", change level, or ask for detail. Applies to prose only; code, tool calls, files and commit messages stay full quality."; cat "$root/tldr/skills/tldr/levels/$l.md"; } > cfg/$l.txt
done

one() {
  i=$1; lvl=$2; p=$(sed -n "${i}p" prompts.txt)
  args=(-p --tools "" --strict-mcp-config --disable-slash-commands --setting-sources "" --no-session-persistence --output-format json)
  [ -n "$model" ] && args+=(--model "$model")
  [ "$lvl" != base ] && args+=(--append-system-prompt "$(cat cfg/$lvl.txt)")
  timeout 300 claude "${args[@]}" "$p" > out/$i.$lvl.json
}
export -f one; export model
n=$(wc -l < prompts.txt)
for i in $(seq 1 "$n"); do for l in base min normal max; do echo "$i $l"; done; done \
  | xargs -P 6 -n 2 bash -c 'one "$0" "$1"'

python3 -I - <<'PY'
import json, glob, statistics as st
R = {}
for f in glob.glob("out/*.json"):
    i, l = f.split("/")[-1].split(".")[:2]
    u = list(json.load(open(f))["modelUsage"].values())[0]
    R.setdefault(l, []).append(u["outputTokens"])
b = st.mean(R["base"])
for l in ("base", "min", "normal", "max"):
    m = st.mean(R[l]); print(f"{l:7} avg {m:6.0f} output tokens   saved {1 - m / b:6.1%}")
PY
