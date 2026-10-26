#!/usr/bin/env bash
# Verification gate, run by implement's orchestrator and by SubagentStop hooks.
# Usage: gate.sh base | diff <tests-only|no-tests> | red <test files> | green <test files> | all
# Knows no language: commands come from the "## Commands" table in the
# project's foreman/workflow.md, rows "Test files" ({files} replaced), "Test",
# "Lint", "Build", "Everything CI runs". A missing row is skipped; a row
# whose Run cell is not exactly one code span is skipped with a warning.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source-path=SCRIPTDIR source=guard-paths.sh
source "$here/guard-paths.sh"

root="$(git rev-parse --show-toplevel)"
cd "$root"
export CI=true

mode="${1:-}"
label="$mode"

fail() {
  echo "gate $label: FAILED ($1)"
  echo "gate $label: FAILED ($1)" >&2
  exit 2
}

ok() {
  echo "gate $label: ok"
  exit 0
}

# The command in the Commands row named $1, or nothing. The Run cell must be
# exactly one code span: text from a prose cell is never run. A "|" in a
# cell is written "\|", so it is masked before the row is split on "|".
cmd_for() {
  local cell re="^${tick}([^${tick}]+)${tick}\$"
  cell="$(awk -v k="$1" '
    /^## Commands/ { on = 1; next }
    /^## / { on = 0 }
    on {
      gsub(/\\\|/, "\001")
      split($0, f, "|")
      c = f[2]; gsub(/^[ \t]+|[ \t]+$/, "", c)
      if (c == k) { r = f[3]; gsub(/^[ \t]+|[ \t]+$/, "", r); gsub(/\001/, "|", r); print "=" r; exit }
    }
  ' foreman/workflow.md 2>/dev/null || true)"
  [[ -n "$cell" ]] || return 0
  cell="${cell#=}"
  if [[ "$cell" =~ $re ]]; then
    printf '%s' "${BASH_REMATCH[1]}"
  else
    echo "workflow.md: $1 row is not a single command" >&2
  fi
}

# run <name> <command>: prints the output tail on failure. Returns its status.
run() {
  local out rc=0
  out="$(bash -c "$2" 2>&1)" || rc=$?
  if ((rc != 0)); then
    echo "--- $1 failed ($2), last 40 lines:"
    printf '%s\n' "$out" | tail -n 40
  fi
  return "$rc"
}

need_globs() {
  [[ -n "$(test_globs "$root")" ]] || fail "foreman/workflow.md has no \"## Test paths\""
}

# The tree a worker's changes are measured against, recorded by `gate.sh base`
# before each worker runs. Per worktree, in git's own dir, which workers
# cannot write. A tree, not HEAD: implement stages the red tests before the
# implementer runs.
base_file() { git rev-parse --git-path foreman-gate-base; }

do_base() {
  label="base"
  git write-tree >"$(base_file)"
  ok
}

# Files changed against the recorded tree, untracked included. Fails when the
# index moved since: a worker that stages can hide a change from a diff.
changed_files() {
  local base
  [[ -f "$(base_file)" ]] || fail "no recorded tree; run gate.sh base before the worker"
  base="$(cat "$(base_file)")"
  [[ "$(git write-tree)" == "$base" ]] || fail "the index changed since gate.sh base"
  # Flagged entries are skipped by git diff, so a change behind them is unseen.
  ! git ls-files -v | grep -qE '^([a-z]|S) ' || fail "an index entry is assume-unchanged or skip-worktree"
  {
    git -c core.quotePath=false diff --name-only "$base"
    git -c core.quotePath=false ls-files --others --exclude-standard
  } | sort -u
}

# The test command for the given files: "Test files" with {files}, else "Test".
test_cmd() {
  local c q=""
  c="$(cmd_for "Test files")"
  if [[ -n "$c" ]] && (($#)); then
    q="$(printf '%q ' "$@")"
    printf '%s' "${c//\{files\}/${q% }}"
    return
  fi
  cmd_for Test
}

need_test_files() {
  (($#)) || fail "name the test files"
  local f
  for f in "$@"; do
    [[ -e "$f" ]] || fail "no such file: $f"
    is_test_path "$root" "$f" || fail "not a test path: $f"
  done
}

do_diff() {
  local want="${1:-}" f files bad=()
  label="diff $want"
  case "$want" in tests-only | no-tests) ;; *) fail "usage: gate.sh diff <tests-only|no-tests>" ;; esac
  need_globs
  # A fail() inside the substitution exits only the subshell: pass it on.
  files="$(changed_files)" || { printf '%s\n' "$files"; exit 2; }
  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    case "$f" in foreman/*) bad+=("$f"); continue ;; esac
    if is_test_path "$root" "$f"; then
      [[ "$want" == no-tests ]] && bad+=("$f")
    else
      [[ "$want" == tests-only ]] && bad+=("$f")
    fi
  done <<<"$files"
  if ((${#bad[@]})); then
    printf '%s\n' "${bad[@]}" >&2
    [[ "$want" == tests-only ]] && fail "non-test or track files changed: ${bad[*]}"
    fail "test or track files changed: ${bad[*]}"
  fi
  ok
}

do_red() {
  need_globs
  need_test_files "$@"
  local c
  c="$(test_cmd "$@")"
  [[ -n "$c" ]] || fail "no Test files or Test command in foreman/workflow.md"
  # Red is a non-zero exit. The orchestrator reads the tail to confirm the
  # failure is the missing behaviour, not a broken test.
  if run tests "$c"; then fail "tests pass, expected failures"; fi
  ok
}

do_green() {
  need_globs
  need_test_files "$@"
  local c
  c="$(cmd_for Lint)"
  if [[ -n "$c" ]]; then run lint "$c" || fail "lint"; fi
  c="$(test_cmd "$@")"
  [[ -n "$c" ]] || fail "no Test files or Test command in foreman/workflow.md"
  run tests "$c" || fail "tests"
  ok
}

do_all() {
  local c ran=0 k
  c="$(cmd_for "Everything CI runs")"
  if [[ -n "$c" ]]; then
    run ci "$c" || fail "everything CI runs"
    ok
  fi
  for k in Build Lint Test; do
    c="$(cmd_for "$k")"
    [[ -n "$c" ]] || continue
    ran=1
    run "$k" "$c" || fail "$k"
  done
  ((ran)) || fail "no Build, Lint or Test command in foreman/workflow.md"
  ok
}

case "$mode" in
  base) do_base ;;
  diff) do_diff "${2:-}" ;;
  red) shift; do_red "$@" ;;
  green) shift; do_green "$@" ;;
  all) do_all ;;
  *) echo "usage: gate.sh base | diff <tests-only|no-tests> | red <test files> | green <test files> | all" >&2; exit 1 ;;
esac
