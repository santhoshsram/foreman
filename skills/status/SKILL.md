---
name: status
description: Where a track stands and what runs next, read from the track files on this branch; with "all", the same for every worktree, then the roadmap. Read only. Use for "/foreman:status", "where am I", "what's next", or "status of all tracks".
argument-hint: "[all]"
---

# Status

Goal: the user knows where the track stands and the one command that moves
it, without opening a file. Changes nothing.

## This branch

Run `${CLAUDE_PLUGIN_ROOT}/scripts/state.sh`. It reads `metadata.json` on
the branch it runs on, never main: main's copy is stale until the merge.

- A track: id, phase, sub-step, status, then from its folder:
  - open questions in `decisions.md`, the first one quoted;
  - tasks checked and BLOCKED out of the total in `plan.md`;
  - `proof.md` rows by result.
- Next: the command for the phase. shape: `/foreman:shape`. implement: the block in
  `${CLAUDE_PLUGIN_ROOT}/skills/shape/assets/run-unattended.md`, verbatim (the `/goal` line only, no `/model` or auto mode line). prove: `/foreman:prove`. ship:
  `/foreman:ship`. Status `blocked`: each `| BLOCKED: <reason>` task line
  in `plan.md`.

## All tracks

With `all`: run `state.sh <path>` for every path in `git worktree list`, one
line per track: id, phase, sub-step, status, branch, next command. A track
whose branch has no worktree here, such as one a web session created, shows
only in `tracks.md` on that branch.

Then the roadmap, by `foreman/workflow.md` `## Roadmap`:

- GitHub issues: run its List command and print `Roadmap`, then one line per
  open issue, `#<number> <title>`, oldest first. An issue whose track is in
  progress is listed like any other. No open issue prints `Roadmap: none`. If
  the command fails, print in place of the list the two lines every skill
  prints, with `Roadmap: ` in front of the first. The failure and fix come
  from the table in `${CLAUDE_PLUGIN_ROOT}/skills/setup/SKILL.md` under "gh
  cannot be used", with ", then run /foreman:setup again" dropped from each
  Fix line; a failure with no Fix line there prints only the first line.
  For an auth failure:
  ```
  Roadmap: GitHub issues cannot be used: `gh auth status` failed: You are not logged into any GitHub hosts.
  Fix: run `! gh auth login`.
  ```
  Bug issues are not listed.
- `foreman/roadmap.md`, or no `## Roadmap` section: under `Roadmap`, each
  `R<n>` line of `foreman/roadmap.md`. A roadmap line has no status: starting
  it removes it.
