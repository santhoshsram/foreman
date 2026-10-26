#!/usr/bin/env bash
# Prints project and track state as JSON. Usage: state.sh [dir]
# Read by setup, new-track, shape and status instead of inferring state.
# Bash 3.2 compatible and no jq: macOS ships bash 3.2, and tech-stack.md
# allows no dependency beyond bash, python3, git and gh.
#
# Trap: metadata.json is parsed line by line with sed, because there is no jq.
# New-track must write it one key per line, string values on the key's line.
# If that proves too brittle, rewrite the parse in python3, which tech-stack.md
# allows for exactly this case.
set -euo pipefail

cd "${1:-.}"

git_repo=false
branch=""
worktree=false
if top="$(git rev-parse --show-toplevel 2>/dev/null)"; then
  git_repo=true
  cd "$top"
  branch="$(git branch --show-current)"
  gd="$(git rev-parse --path-format=absolute --git-dir)"
  gcd="$(git rev-parse --path-format=absolute --git-common-dir)"
  [[ "$gd" == "$gcd" ]] || worktree=true
fi

json_str() {
  local s="${1//\\/\\\\}"
  printf '"%s"' "${s//\"/\\\"}"
}

# Prints the raw, still JSON-escaped string value of a top-level key, or
# nothing when the key is absent or not a string.
meta_get() {
  sed -n "s/^[[:space:]]*\"$1\"[[:space:]]*:[[:space:]]*\"\(.*\)\"[[:space:]]*,\{0,1\}[[:space:]]*\$/\1/p" "$2" | head -n 1
}

meta_field() {
  local v
  v="$(meta_get "$1" "$2")"
  if [[ -n "$v" ]]; then printf '"%s"' "$v"; else printf 'null'; fi
}

files=(index.md product.md product-guidelines.md tech-stack.md ux.md workflow.md code_styleguides learnings.md tracks.md roadmap.md)

track_dir=""
if [[ -n "$branch" ]]; then
  # meta_get returns the escaped form, so compare escaped to escaped.
  want="$(json_str "$branch")"
  want="${want:1:${#want}-2}"
  for m in foreman/tracks/*/metadata.json; do
    [[ -f "$m" ]] || continue
    [[ "$(meta_get branch "$m")" == "$want" ]] || continue
    if [[ -n "$track_dir" ]]; then
      echo "state.sh: branch $branch is claimed by both $track_dir and ${m%/metadata.json}" >&2
      exit 1
    fi
    track_dir="${m%/metadata.json}"
  done
fi

printf '{\n'
printf '  "root": %s,\n' "$(json_str "$PWD")"
printf '  "git": %s,\n' "$git_repo"
if [[ -n "$branch" ]]; then
  printf '  "branch": %s,\n' "$(json_str "$branch")"
else
  printf '  "branch": null,\n'
fi
printf '  "worktree": %s,\n' "$worktree"
printf '  "files": {\n'
n=${#files[@]}
for ((i = 0; i < n; i++)); do
  f="${files[$i]}"
  sep=","
  ((i == n - 1)) && sep=""
  if [[ -e "foreman/$f" ]]; then present=true; else present=false; fi
  printf '    %s: %s%s\n' "$(json_str "$f")" "$present" "$sep"
done
printf '  },\n'
# index.md is written last by setup, so its presence means setup finished.
if [[ -f foreman/index.md ]]; then
  printf '  "setup_complete": true,\n'
else
  printf '  "setup_complete": false,\n'
fi
if [[ -z "$track_dir" ]]; then
  printf '  "track": null\n'
else
  m="$track_dir/metadata.json"
  id="$(meta_field id "$m")"
  [[ "$id" != null ]] || id="$(json_str "${track_dir##*/}")"
  printf '  "track": {\n'
  printf '    "id": %s,\n' "$id"
  printf '    "dir": %s,\n' "$(json_str "$track_dir")"
  printf '    "type": %s,\n' "$(meta_field type "$m")"
  printf '    "status": %s,\n' "$(meta_field status "$m")"
  printf '    "phase": %s,\n' "$(meta_field phase "$m")"
  printf '    "sub_step": %s\n' "$(meta_field sub_step "$m")"
  printf '  }\n'
fi
printf '}\n'
