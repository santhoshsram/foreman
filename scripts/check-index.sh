#!/usr/bin/env bash
# Checks that every file foreman/index.md names exists. Usage: check-index.sh [dir]
# Paths are the backticked tokens in the last column of the index's tables,
# relative to foreman/. Placeholders such as `tracks/<id>/` are skipped.
set -euo pipefail

cd "${1:-.}"
if top="$(git rev-parse --show-toplevel 2>/dev/null)"; then cd "$top"; fi

idx=foreman/index.md
if [[ ! -f "$idx" ]]; then
  echo "check-index: FAILED (no $idx)"
  exit 1
fi

tick='`'
missing=()
while IFS= read -r p; do
  [[ -z "$p" || "$p" == *"<"* ]] && continue
  [[ -e "foreman/$p" ]] || missing+=("$p")
done < <(grep '^|' "$idx" | awk -F'|' '{print $(NF-1)}' | grep -oE "${tick}[^${tick}]+${tick}" | tr -d "$tick" | sort -u)

if ((${#missing[@]})); then
  printf 'missing: %s\n' "${missing[@]}"
  echo "check-index: FAILED (${#missing[@]} missing)"
  exit 1
fi
echo "check-index: ok"
