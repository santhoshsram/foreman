#!/usr/bin/env bash
# Sets phase, sub_step or status on the current branch's track, bumps
# updated_at, and mirrors the result into the track's tracks.md row.
# Usage: set-track.sh key=value ...   (keys: phase, sub_step, status)
# Skills change track state only through this script, so metadata.json keeps
# the one-key-per-line shape state.sh parses, and the registry never drifts.
# Does not commit: the caller commits it with the work it records.
set -euo pipefail

usage() {
  echo "usage: set-track.sh key=value ... (phase: shape|implement|prove|ship, sub_step: user|ux|eng|'', status: active|blocked|done)" >&2
  exit 2
}
(($#)) || usage

for kv in "$@"; do
  [[ "$kv" == *=* ]] || usage
  v="${kv#*=}"
  case "${kv%%=*}" in
    phase) case "$v" in shape | implement | prove | ship) ;; *) usage ;; esac ;;
    sub_step) case "$v" in user | ux | eng | "") ;; *) usage ;; esac ;;
    status) case "$v" in active | blocked | done) ;; *) usage ;; esac ;;
    *) usage ;;
  esac
done

state="$("$(dirname "${BASH_SOURCE[0]}")/state.sh")"
root="$(printf '%s\n' "$state" | sed -n 's/^  "root": "\(.*\)",$/\1/p')"
dir="$(printf '%s\n' "$state" | sed -n 's/^    "dir": "\(.*\)",$/\1/p')"
id="$(printf '%s\n' "$state" | sed -n 's/^    "id": "\(.*\)",$/\1/p')"
if [[ -z "$dir" ]]; then
  echo "set-track: no track claims this branch" >&2
  exit 1
fi
cd "$root"
meta="$dir/metadata.json"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

set_key() {
  grep -q "^[[:space:]]*\"$1\"[[:space:]]*:" "$meta" || {
    echo "set-track: $meta has no \"$1\" line" >&2
    exit 1
  }
  sed "s/^\([[:space:]]*\"$1\"[[:space:]]*:[[:space:]]*\"\)[^\"]*\"/\1$2\"/" "$meta" >"$tmp"
  cat "$tmp" >"$meta"
}

for kv in "$@"; do
  set_key "${kv%%=*}" "${kv#*=}"
done
set_key updated_at "$(date -u +%Y-%m-%dT%H:%M:%SZ)"

get() { sed -n "s/^[[:space:]]*\"$1\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" "$meta" | head -n 1; }
phase="$(get phase)"
status="$(get status)"
shown="$phase"
[[ "$status" != "done" ]] || shown="done"

awk -F'|' -v OFS='|' -v id="$id" -v shown="$shown" '
  { k = $2; gsub(/^[ \t]+|[ \t]+$/, "", k) }
  NF >= 6 && k == id { $4 = " " shown " "; hit = 1 }
  { print }
  END { exit hit ? 0 : 3 }
' foreman/tracks.md >"$tmp" || {
  echo "set-track: no row for $id in foreman/tracks.md" >&2
  exit 1
}
cat "$tmp" >foreman/tracks.md

echo "set-track: $id phase=$phase sub_step=$(get sub_step) status=$status"
