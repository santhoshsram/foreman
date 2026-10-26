---
name: prove
description: Prove a built track against its spec. One line of evidence per acceptance criterion in proof.md, produced by running the real built thing; adversarial cases that break it are filed as tasks with failing tests, never fixed silently. Runs unattended after implement. Use for "/foreman:prove", "prove this track", or when implement hands off.
---

# Prove

Goal: every acceptance criterion in `spec.md` shown to hold in the built
thing, with evidence produced here. Done when `proof.md` has one line per
`AC<n>`, each `pass` or `manual`, and every adversarial case held.

`${CLAUDE_PLUGIN_ROOT}/guideline.md` governs stops. Read it first. Runs
under the `/goal` shape printed, on Opus in auto mode.

## Rules

- Evidence is what this session ran and saw. A worker's hand-back, a green
  gate from implement or a commit message is a claim, not proof.
- Never write source or tests. A break goes back through implement.
- Real user data and real client configs are never read or written. A
  built thing that touches `$HOME` runs with `HOME` set to a fresh temp dir;
  one that does not runs as is. A criterion that needs real user state is
  manual.

## State

Run `${CLAUDE_PLUGIN_ROOT}/scripts/state.sh`. `phase` must be `prove`.
Read `spec.md`, `plan.md` and `foreman/workflow.md`. An existing `proof.md`
is a resume: re-prove only lines that are not `pass`, plus every line when
commits landed after its `Built at` sha.

## Evidence

`proof.md` from `${CLAUDE_PLUGIN_ROOT}/skills/prove/assets/proof.md`, one
row per criterion, in the kind the criterion names:

- Command output is compared byte for byte where the spec gives a block.
- A screenshot or video the session has no tool to capture makes the
  criterion manual.

`proof/` stays out of git, because media are large and the line carries the
meaning: check `git check-ignore foreman/tracks/<id>/proof/x`, and add
`foreman/tracks/*/proof/` to `.gitignore` when it fails.

## Adversarial

Then try to break each criterion past what its tests cover. Each case tried
is a line under `## Adversarial`.

- Breaks a criterion: append a task `P<n>` to `plan.md` naming the case and
  the AC, as a failing test to write first, in implement's task format:
  the line `- [ ] P1 <type>(<scope>): <title> | AC: AC<n> | deps: none`
  under `## Tasks` and a `## P1 <type>(<scope>): <title>` section. Then `set-track.sh
  phase=implement`, commit, and start implement through the Skill tool,
  `foreman:implement`, which builds it and closes back here.
- The spec does not say what should happen: a spec gap, handled as implement
  handles one.

## Close

Every line `pass` or `manual`, every case held:
`${CLAUDE_PLUGIN_ROOT}/scripts/set-track.sh phase=ship`, commit `proof.md`
and any `.gitignore` change as `docs(foreman): prove <id>`, and print the
next step: `/foreman:ship`, which asks before the PR and the merge.
