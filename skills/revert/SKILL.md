---
name: revert
description: Undo a task of the track on this branch, or a whole merged track, with git revert only; history is never rewritten. Use for "/foreman:revert <task>", "revert task 03", "undo that track".
argument-hint: "[task NN | track <id>]"
---

# Revert

Goal: the chosen unit of work undone by new commits, with the plan in step.
Done when the reverts are committed, or the user declines the list.

`${CLAUDE_PLUGIN_ROOT}/guideline.md` governs questions and stops. Read it
first.

## Rules

- `git revert` only. Never `git reset --hard` or a rebase: both destroy
  work, and a pushed branch would need a force push.
- Show the exact commits, newest first, and revert only on the user's yes.
- Chain the reverts in one script, newest first. On a conflict, `git revert
  --abort` and stop.

## A task

`NN`, `P<n>` or `R<n>` of the track on this branch: its code commit is the
`[<sha>]` at the end of its `plan.md` line. Revert that commit, then uncheck
the box and drop the SHA in `plan.md` as a new commit, `docs(foreman): plan
<id> <NN> reverted`. Never revert the plan commit: later tasks checked the
lines beside it, so it conflicts. Tasks whose deps include it are listed as
at risk before asking.

After the revert, if the track's phase is past implement:
`${CLAUDE_PLUGIN_ROOT}/scripts/set-track.sh phase=implement`, committed, so
the task is built again.

## A merged track

Its squash commit on main: the commit that added `foreman/archive/<id>/`.
The revert lands on a new branch `revert/<id>` off main, never on main,
committed; the PR is the user's. A track not merged yet needs no revert:
its branch is the user's to drop.
