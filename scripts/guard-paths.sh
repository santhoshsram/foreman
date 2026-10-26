#!/usr/bin/env bash
# PreToolUse guard for foreman's workers, registered in hooks/hooks.json.
# Plugin agents ignore `hooks` frontmatter, so this one plugin hook sees every
# tool call and acts only inside a foreman worker, named by agent_type.
#   critic: Read of the one file critique recorded with
#   `guard-paths.sh critic-file <path>`. challenger: Read of markdown in the
#   repo only.
#   researcher: reads and searches, writes nothing.
#   test-writer: writes test paths only. implementer: never a test path.
#   Neither writes under foreman/ or .git/, nor runs git beyond reads: track
#   files, the index and HEAD are the orchestrator's.
# A guardrail for honest workers, not a sandbox: the Bash check parses the
# command string. gate.sh diff is the check that sees every change.
# Also sourced by gate.sh, so a test path has one definition: the globs under
# "## Test paths" in the project's foreman/workflow.md.
set -euo pipefail

tick='`'

# Prints the test path globs, one per line.
test_globs() {
  sed -n '/^## Test paths/,/^## /p' "$1/foreman/workflow.md" 2>/dev/null |
    grep -oE "${tick}[^${tick}]+${tick}" | tr -d "$tick" || true
}

# is_test_path <root> <repo-relative path>
is_test_path() {
  local g
  while IFS= read -r g; do
    [[ -n "$g" ]] || continue
    # Unquoted on purpose: the glob must match.
    # shellcheck disable=SC2053
    [[ "$2" == $g ]] && return 0
  done < <(test_globs "$1")
  return 1
}

block() {
  echo "guard-paths ($role): blocked: $1" >&2
  exit 2
}

# Repo-relative form of a path the tool named, absolute or relative to cwd.
rel_path() {
  local p="$1"
  [[ "$p" == /* ]] || p="$cwd/$p"
  p="${p#"$top"/}"
  printf '%s' "${p#./}"
}

# A ".." could step out of the prefix the checks compare against.
no_dotdot() {
  case "/$1/" in */../*) block "$1: no .. in paths" ;; esac
}

# Exits through block() when a write to <path> is off limits for the role.
check_write() {
  local p
  p="$(rel_path "$1")"
  no_dotdot "$p"
  # Lowercased: macOS file systems ignore case, so .GIT/ is .git/.
  case "$(printf '%s' "$p" | tr '[:upper:]' '[:lower:]')" in
    .git | .git/* | */.git/*) block "$p: workers never write git's own files" ;;
  esac
  # Outside the repo, such as a temp dir: not a source or test path.
  [[ "$p" != /* ]] || return 0
  case "$p" in
    foreman/*) block "$p is a track file; workers never write under foreman/" ;;
  esac
  if is_test_path "$top" "$p"; then
    [[ "$role" == implementer ]] && block "$p is a test path; the implementer never edits tests"
  else
    [[ "$role" == test-writer ]] && block "$p is not a test path; the test-writer writes tests only"
  fi
  return 0
}

# Where critique records the file its critics may read: per worktree, in
# git's own dir, which workers cannot write.
critic_file() { git -C "$top" rev-parse --path-format=absolute --git-path foreman-critic-file; }

record_critic_file() {
  cwd="$PWD"
  top="$(git rev-parse --show-toplevel)"
  local p
  p="$(rel_path "${1:-}")"
  case "$p" in /* | */../* | ../*) ;; *.md) [[ -f "$top/$p" ]] && { printf '%s\n' "$p" >"$(critic_file)"; exit 0; } ;; esac
  echo "guard-paths: ${1:-}: not a markdown file in this repo" >&2
  exit 1
}

main() {
  local input
  input="$(cat)"
  # Cheap exit for the main session, which has no agent_type: this hook runs
  # on every tool call in every project with the plugin enabled.
  case "$input" in *'"agent_type"'*) ;; *) exit 0 ;; esac

  local agent tool target
  # python3, not jq: tech-stack.md allows no JSON tool beyond it.
  {
    IFS= read -r -d '' agent
    IFS= read -r -d '' tool
    IFS= read -r -d '' cwd
    IFS= read -r -d '' target
  } < <(python3 -I -c '
import json, sys
d = json.load(sys.stdin)
t = d.get("tool_input") or {}
v = [d.get("agent_type") or "", d.get("tool_name") or "", d.get("cwd") or "",
     t.get("file_path") or t.get("notebook_path") or t.get("command") or ""]
sys.stdout.write("\0".join(v) + "\0")
' <<<"$input")

  role="${agent#foreman:}"
  case "$role" in critic | challenger | researcher | test-writer | implementer) ;; *) exit 0 ;; esac
  # A background worker returns its report only through this tool.
  [[ "$tool" == SubagentHandback ]] && exit 0
  top="$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null || printf '%s' "$cwd")"

  case "$role" in
    critic)
      [[ "$tool" == Read ]] || block "$tool: the critic only reads"
      local p want
      p="$(rel_path "$target")"
      no_dotdot "$p"
      want="$(cat "$(critic_file)" 2>/dev/null || true)"
      [[ -n "$want" && "$p" == "$want" ]] && exit 0
      block "$target: the critic reads only the file critique recorded"
      ;;
    challenger)
      [[ "$tool" == Read ]] || block "$tool: the challenger only reads"
      local p
      p="$(rel_path "$target")"
      no_dotdot "$p"
      case "$p" in /*) ;; *.md) exit 0 ;; esac
      block "$target: the challenger reads markdown in the repo only; code is how, not what"
      ;;
    researcher)
      case "$tool" in Read | Glob | Grep | WebSearch | WebFetch) exit 0 ;; esac
      block "$tool: the researcher writes nothing; shape saves its file"
      ;;
  esac

  case "$tool" in
    Read | Glob | Grep | Edit | Write | MultiEdit | NotebookEdit | Bash | TodoWrite) ;;
    *) block "$tool: not a tool this worker uses" ;;
  esac

  [[ -n "$(test_globs "$top")" ]] ||
    block "foreman/workflow.md has no \"## Test paths\"; the guard cannot tell tests from source"

  case "$tool" in
    Edit | Write | MultiEdit | NotebookEdit)
      [[ -z "$target" ]] || check_write "$target"
      ;;
    Bash)
      # Every git call must be a read-only subcommand with no global options:
      # the orchestrator owns the index, HEAD and the remote, and an option
      # such as -c can make a read run a program.
      local git_re='(^|[^[:alnum:]_.-])git[[:space:]]+([^[:space:]]+)'
      local rest="$target"
      while [[ "$rest" =~ $git_re ]]; do
        case "${BASH_REMATCH[2]}" in
          status | diff | log | show | blame | grep | ls-files | rev-parse | describe) ;;
          *) block "git ${BASH_REMATCH[2]}: workers run read-only git, no global options" ;;
        esac
        rest="${rest#*"${BASH_REMATCH[0]}"}"
      done
      [[ ! "$target" =~ git[[:space:]].*(--output|--ext-diff|--textconv|--open-files-in-pager|[[:space:]]-O) ]] ||
        block "git ${BASH_REMATCH[1]}: writes a file or runs a program"
      local write_re='(^|[^-=>&0-9])>>?([^&]|$)|[0-9]>>?[^&]|(^|[^[:alnum:]_-])(tee|mv|cp|rm|truncate)([^[:alnum:]_-]|$)|sed[[:space:]]+(-[a-zA-Z]*i|--in-place)|git[[:space:]]+(checkout|restore)'
      [[ "$target" =~ $write_re ]] || exit 0
      local tok
      # Word splitting is intended: each token may be a path the command writes.
      # shellcheck disable=SC2086
      for tok in $target; do
        tok="${tok//[\"\'\;\(\)]/}"
        tok="${tok#>>}"
        tok="${tok#>}"
        tok="${tok#[0-9]>}"
        [[ -z "$tok" || "$tok" == -* || "$tok" == /dev/* || "$tok" == \&* ]] && continue
        [[ "$tok" == */* || "$tok" =~ \.[A-Za-z0-9]+$ ]] || continue
        check_write "$tok"
      done
      ;;
  esac
  exit 0
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  if [[ "${1:-}" == critic-file ]]; then record_critic_file "${2:-}"; fi
  main
fi
