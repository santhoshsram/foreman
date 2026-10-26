---
name: ship
description: Land a proven track. Syncs the project files with what the track changed, records learnings, archives the track folder, then asks before opening the PR and before merging. Use for "/foreman:ship", "ship this track", or after prove closes.
---

# Ship

Goal: the track merged to main with its project-file changes, its learnings
recorded and its folder archived. Done when the PR is squash-merged, or the
user stops at a boundary, and the final report says which.

`${CLAUDE_PLUGIN_ROOT}/guideline.md` governs questions and stops. Read it
first. Ship is the one skill that runs push, PR and merge, each only on the
user's yes in this session.

## State

Run `${CLAUDE_PLUGIN_ROOT}/scripts/state.sh`. `phase` must be `ship`. Read
the track's `spec.md`, `decisions.md`, `plan.md` and `proof.md`. A `proof.md`
row not `pass` or `manual`: stop, the track goes back to prove.

## Project files

The track may have changed what is true of the project. For `product.md`,
`tech-stack.md` and `ux.md`, propose the edits the spec and decisions imply.
`product-guidelines.md` only when the spec explicitly changes voice or a
must-never. Show each as a diff and write it only on approval.

## Learnings

- Append to `foreman/learnings.md` what surprised this track, one line each
  in its format: disputes, BLOCKED tasks, spec gaps, adversarial breaks,
  harness friction.

## Archive

`${CLAUDE_PLUGIN_ROOT}/scripts/set-track.sh status=done` first, while
`state.sh` can still find the track; then `git mv` the track folder to
`foreman/archive/<id>/`. Commit the sync, learnings and archive as
`docs(foreman): ship <id>`, staging those paths only. The archive lands on
main with the PR.

## PR

- Title: `<type>(<scope>): <spec title>`, the type matching the branch. It
  becomes the squash commit subject.
- Body: `${CLAUDE_PLUGIN_ROOT}/skills/ship/assets/pr-body.md`, plain labels,
  no headings: it becomes the squash commit body. Review notes list every
  `review:` decision; Not in this PR lists every parked line.
- Show title and body, then ask whether to push and open the PR. On yes:
  push the branch and open it against main with `gh`. No `gh` or no remote:
  print the commands instead.

## Merge

- `workflow.md`'s Done says what landing needs beyond the merge, such as a
  version bump or a release. List what is not done yet.
- When checks pass, ask whether to squash-merge. On yes: merge with the
  title and body above. Then ask whether to remove the worktree and the
  local branch, chained in one script.
