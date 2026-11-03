# Plan: Roadmap in GitHub issues as a setup option

Spec: `spec.md`. Tasks run in order; a task runs once its deps are done.

Every task edits skill prose, which has no test harness: each is
`Tests: none`, skips the test-writer, and is checked by `gate.sh diff
no-tests` and `gate.sh all` (Lint: script syntax and `check-index.sh`).
The `product.md` and `tech-stack.md` edits in spec §Contracts "Project
files this track changes" are ship's, which syncs project files.

## Tasks

- [x] 01 feat(setup): ask where the roadmap lives in a new setup | AC: AC1, AC4, AC5 | deps: none [2dfaefa]
- [x] 02 feat(setup): roadmap question and migration on a set-up project | AC: AC2, AC3, AC11 | deps: 01 [d393cc4]
- [x] 03 feat(new-track): start a track from GitHub issue #N | AC: AC6, AC7, AC12 | deps: 01 [aa80fb4]
- [ ] 04 feat(ship): close the source issue from the PR body | AC: AC8 | deps: 03
- [ ] 05 feat(status): roadmap from issues and goal-only hand-off | AC: AC9, AC11, AC13 | deps: 01
- [ ] 06 feat(shape): defer to a roadmap issue and goal-only close | AC: AC10, AC12, AC13 | deps: 01
- [ ] 07 feat(implement): stop on a model other than Opus | AC: AC14 | deps: none

## 01 feat(setup): ask where the roadmap lives in a new setup

### Goal
A new setup asks whether the roadmap lives in `foreman/roadmap.md` or in
GitHub issues, records the answer in `workflow.md` under `## Roadmap`, and
handles a gh that cannot be used.
Spec: §Users and journeys J1, J3; §Experience "Setup asks the roadmap
question", "GitHub issues picked, but gh cannot be used"; §Contracts
`workflow.md` `## Roadmap`, `foreman/index.md` row, The `roadmap` label;
AC1, AC4, AC5

### Context
- Read first: `foreman/tracks/roadmap-issues/spec.md` (whole file),
  `skills/setup/SKILL.md`, `skills/setup/assets/workflow.md`,
  `skills/setup/assets/index.md`, `skills/setup/assets/roadmap.md`
- Mirror: `skills/setup/SKILL.md` "Files, in order" table for how a file's
  rule is stated

### Contract
The question, asked through `AskUserQuestion` after `workflow.md` is
drafted, verbatim from spec §Experience:
```
Where does this project's roadmap live? The roadmap is the list of future tracks.

1. foreman/roadmap.md
   One line per future track, in the repo. Adding a line takes a commit and a merged PR.
2. GitHub issues
   One open issue labelled `roadmap` per future track. Adding one takes no commit.
```
The gh failure screen, the failure table, the non-GitHub origin form and
its two options, and option 1's state: verbatim from spec §Experience
"GitHub issues picked, but gh cannot be used".
The two `## Roadmap` forms and the index row: verbatim from spec
§Contracts. The label command and its already-exists rule: spec
§Contracts "The `roadmap` label".
With GitHub issues picked, setup writes no `roadmap.md`.
Free choice: where in `SKILL.md` the rules sit, wording of rules that are
not output.

### Behaviour
- B1 Setup shall ask the roadmap question in a new setup and record the
  answer as one of the two `## Roadmap` forms.
- B2 When GitHub issues is picked, setup shall create the `roadmap` label,
  write no `roadmap.md`, and write the index row from spec §Contracts.
- B3 When gh cannot be used, setup shall print the failure as spec
  §Experience gives it and offer the two options; option 1 leaves no
  `## Roadmap`, no `roadmap.md` and no Future tracks row.
- B4 The issues form of `## Roadmap` shall carry the List and Add rows, so
  a session asked for a future track (J3) opens an issue with no commit.

### Tests
- File: none (prose)

### Files
- `skills/setup/SKILL.md`

### Out of scope
- The set-up project path and migration: task 02.
- Editing `skills/setup/assets/*`: setup writes the section and row itself.

## 02 feat(setup): roadmap question and migration on a set-up project

### Goal
On a set-up project whose `workflow.md` has no `## Roadmap` section,
setup asks only the roadmap question and, for GitHub issues, moves every
`roadmap.md` line to an issue on branch `chore/foreman-roadmap`.
Spec: §Users and journeys J2; §Experience "Existing roadmap moved to
issues (J2)", the mid-migration failure paragraph; §Contracts "Migration
(J2)"; AC2, AC3, AC11

### Context
- Read first: spec (whole file), `skills/setup/SKILL.md` after task 01,
  `scripts/state.sh` (read only: `setup_complete`)
- Mirror: task 01's text in `skills/setup/SKILL.md`

### Contract
Today setup stops when `setup_complete: true`. New rule: when
`setup_complete: true` and `workflow.md` has no `## Roadmap` section, run
only the roadmap question; with a `## Roadmap` section in either form,
setup stops as today.
Migration rules, summary lines and their 1-line, non-consecutive, 0-line
and no-`roadmap.md` forms, the `foreman/roadmap.md` pick output, the
commit subjects `docs(foreman): move roadmap to GitHub issues` and
`docs(foreman): record roadmap choice`: verbatim from spec §Experience and
§Contracts.
Free choice: wording of rules that are not output.

### Behaviour
- B1 Setup shall ask only the roadmap question on a set-up project with no
  `## Roadmap` section, and stop as today when one exists.
- B2 Migration shall run on `chore/foreman-roadmap`, continuing on it when
  it exists, open one issue per `- R<n>:` item in file order with the
  title and body rule from spec §Contracts, and remove each item once its
  issue exists.
- B3 After the first issue, a gh failure shall stop setup with no
  fallback.
- B4 When no item is left, setup shall delete `roadmap.md`, write
  `## Roadmap`, rewrite the index row, commit once, and print the summary.
- B5 A `foreman/roadmap.md` pick shall write the section and row, create
  `roadmap.md` with the preamble and `Next id: R1` when missing, commit
  once, and print the two lines from spec §Experience.

### Tests
- File: none (prose)

### Files
- `skills/setup/SKILL.md`

### Out of scope
- New-setup behaviour: task 01.
- Switching back from issues.

## 03 feat(new-track): start a track from GitHub issue #N

### Goal
`/foreman:new-track #N` starts a track from open issue N, on either
roadmap choice, and records the issue number.
Spec: §Users and journeys J4; §Experience "Track started from an issue
(J4)", "gh fails outside setup"; §Contracts `metadata.json`; AC6, AC7,
AC12

### Context
- Read first: spec (whole file), `skills/new-track/SKILL.md`,
  `skills/new-track/assets/metadata.json`
- Mirror: the `R<n>` rule in `skills/new-track/SKILL.md` "The track"

### Contract
Messages, verbatim from spec §Experience:
```
Issue #42 is closed. Start from an open issue, or type a description.
```
```
Issue #42 does not exist. Start from an open issue, or type a description.
```
```
This project's roadmap is in GitHub issues. Start from an open issue, or type a description.
```
A pull request number counts as missing. The gh failure lines: spec
§Experience "gh fails outside setup".
`metadata.json` gains `  "issue": "42",` on its own line, only for a
track started from an issue; the asset's one-key-per-line shape holds.
The issue stays open. The argument hint names `#N`.
Free choice: the `gh` command used to read the issue.

### Behaviour
- B1 New-track `#N` on an open issue, whatever its labels, shall use the
  issue's title and body as the description and write the `issue` key.
- B2 A closed issue, a missing issue or a pull request shall stop with its
  message.
- B3 `R<n>` on a project whose `## Roadmap` is GitHub issues shall stop
  with its message; on any other project `R<n>` works as today.
- B4 A gh failure shall print the failure lines and stop, writing nothing.

### Tests
- File: none (prose)

### Files
- `skills/new-track/SKILL.md`
- `skills/new-track/assets/metadata.json` only if the rule needs it there

### Out of scope
- Closing the issue: the PR does it at merge, task 04.

## 04 feat(ship): close the source issue from the PR body

### Goal
A track started from issue #N ships with `Closes #N` in its PR body.
Spec: §Users and journeys J4; §Contracts `metadata.json`; AC8

### Context
- Read first: spec §Contracts `metadata.json`, `skills/ship/SKILL.md`,
  `skills/ship/assets/pr-body.md`

### Contract
Ship fills `Closes #<issue>` from the track's `metadata.json` `issue` key.
A track without the key gets no `Closes` line from it.
Free choice: wording.

### Behaviour
- B1 Ship shall put `Closes #N` in the PR body when `metadata.json` has
  `"issue": "N"`, and add no `Closes` line from it otherwise.

### Tests
- File: none (prose)

### Files
- `skills/ship/SKILL.md`

### Out of scope
- The project-file sync for this track's own `product.md` and
  `tech-stack.md` text.

## 05 feat(status): roadmap from issues and goal-only hand-off

### Goal
`/foreman:status all` lists open `roadmap` issues when the project uses
GitHub issues, and status suggests only the `/goal` line for a track in
implement.
Spec: §Users and journeys J5, J7; §Experience "Roadmap in
`/foreman:status all` (J5)", "Implement hand-off (J7, J8)"; AC9, AC11,
AC13

### Context
- Read first: spec (whole file), `skills/status/SKILL.md`,
  `skills/shape/assets/run-unattended.md`

### Contract
Verbatim from spec §Experience:
```
Roadmap
#42 Security review of a track's diff before ship: supply-chain risk in new dependencies, secrets, and common appsec flaws, each finding settled like a review fix.
#43 Drift report: compare the code with the archived specs and the project files, and list each place they disagree.
```
Oldest first, from the List row in `workflow.md` `## Roadmap`; an issue
whose track is in progress is listed like any other; none prints
`Roadmap: none`; gh failure prints:
```
Roadmap: GitHub issues cannot be used: `gh auth status` failed: You are not logged into any GitHub hosts.
Fix: run `! gh auth login`.
```
A project whose `## Roadmap` records `foreman/roadmap.md`, or has no such
section, lists `roadmap.md` lines as today.
Implement next command, verbatim:
```
Start implement with:

/goal Follow /foreman:implement for the track on this branch until every task in its plan.md is checked or BLOCKED and gate.sh all prints ok, then /foreman:prove until proof.md has a line per acceptance criterion; or stop after 200 turns.
```
Free choice: wording of rules that are not output.

### Behaviour
- B1 Status `all` shall list open `roadmap` issues as above when
  `## Roadmap` is GitHub issues, `Roadmap: none` when there are none, and
  the gh failure lines when gh fails.
- B2 Status shall list `roadmap.md` lines as today on any other project.
- B3 Status on a track in implement shall print the hand-off block above,
  with no `/model` or auto mode line.

### Tests
- File: none (prose)

### Files
- `skills/status/SKILL.md`
- `skills/shape/assets/run-unattended.md`

### Out of scope
- Listing bug issues.

## 06 feat(shape): defer to a roadmap issue and goal-only close

### Goal
On a project using GitHub issues, shape opens a deferred part as a
`roadmap` issue; shape's close suggests only the `/goal` line.
Spec: §Users and journeys J6, J7; §Experience "Future track added (J3,
J6)", "gh fails outside setup", "Implement hand-off (J7, J8)"; AC10,
AC12, AC13

### Context
- Read first: spec (whole file), `skills/shape/SKILL.md`,
  `skills/shape/assets/run-unattended.md` after task 05

### Contract
Deferred issue: Add row of `workflow.md` `## Roadmap`; title is the
description's first sentence; body is the rest, then where it came from,
naming the track it was deferred from. No `roadmap.md` edit, no commit for
it. gh failure lines: spec §Experience "gh fails outside setup".
Close prints the hand-off block of task 05, verbatim, from
`run-unattended.md`.
A project whose `## Roadmap` records `foreman/roadmap.md`, or has no such
section, edits `roadmap.md` as today.
Free choice: wording of rules that are not output.

### Behaviour
- B1 Shape shall open a deferred part as a `roadmap` issue on a project
  using GitHub issues, and edit `roadmap.md` as today otherwise.
- B2 A gh failure during the defer shall print the failure lines and open
  nothing.
- B3 Shape's close shall print the hand-off block with no `/model` or auto
  mode line.

### Tests
- File: none (prose)

### Files
- `skills/shape/SKILL.md`

### Out of scope
- Shape's checkpoints and the challenger.

## 07 feat(implement): stop on a model other than Opus

### Goal
`/foreman:implement` on a model other than Opus does no work and asks the
user to switch.
Spec: §Users and journeys J8; §Experience "Implement hand-off (J7, J8)";
AC14

### Context
- Read first: spec §Experience "Implement hand-off (J7, J8)",
  `skills/implement/SKILL.md`

### Contract
Verbatim from spec §Experience, with the session's model name in place of
`Sonnet 5.5`:
```
Implement runs on Opus. This session runs on Sonnet 5.5.
Run `/model opus`, then send the /goal line again.
```
Printed before any plan, commit or spawn.
Free choice: wording of the rule.

### Behaviour
- B1 Implement shall check its own model first and, when it is not Opus,
  print the message and write, commit and spawn nothing.
- B2 The line "Runs under `/goal` on Opus in auto mode; shape and status
  print the commands." shall no longer tell the user about auto mode.

### Tests
- File: none (prose)

### Files
- `skills/implement/SKILL.md`

### Out of scope
- Prove's model.
