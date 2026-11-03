# Roadmap in GitHub issues as a setup option

## Goal

A project can keep its roadmap as GitHub issues labelled `roadmap`
instead of `foreman/roadmap.md`, chosen at setup. With markdown, every new
future track costs a commit and a merged PR; with issues, it costs one
issue. `foreman/roadmap.md` stays the default. Tracks, specs and decisions
never leave the repo.

Also: the hand-off to implement stops telling a user already on Opus in
auto mode to switch again. Shape and status suggest only the `/goal`
line; implement itself checks the model.

## Users and journeys

The solo developer of `product.md`, on a GitHub-hosted project.

- J1 New project. Given a project without `foreman/`, when the user runs
  `/foreman:setup`, then setup asks whether the roadmap lives in
  `foreman/roadmap.md` or in GitHub issues, and records the answer in
  `foreman/workflow.md` under `## Roadmap`.
- J2 Existing project. Given a set-up project whose `workflow.md` has no
  `## Roadmap` section, when the user runs `/foreman:setup`, then setup
  asks only the roadmap question. If the user picks GitHub issues, each
  `roadmap.md` line becomes an open issue labelled `roadmap`, and
  `roadmap.md` is deleted.
- J3 Add a future track. Given a project on GitHub issues, when the user
  asks for a new future track, then an issue labelled `roadmap` is opened
  and no commit is made.
- J4 Start a track. Given any open issue #N, such as one labelled
  `roadmap` or `bug`, on either roadmap choice, when the user runs
  `/foreman:new-track #N`, then the track starts from that issue, the issue
  stays open, and the track's PR body carries `Closes #N`, so the merge
  closes it.
- J5 See the roadmap. Given a project on GitHub issues, when the user runs
  `/foreman:status all`, then the Roadmap part lists the open issues
  labelled `roadmap`.
- J6 Defer a part. Given shape on a project on GitHub issues, when the user
  wants an out-of-scope part later, then shape opens it as an issue
  labelled `roadmap`.
- J7 Start implement. Given shape closing, or `/foreman:status` on a
  track in implement, then the skill suggests only the `/goal` line, with
  no `/model opus` line and no "turn on auto mode" line.
- J8 Wrong model. Given `/foreman:implement` started on a model other than
  Opus, then implement does no work and asks the user to switch to Opus.

## Experience

Foreman has no UI; the experience is the text a skill prints in the
session. Nearest existing commands: setup's own questions,
`/foreman:new-track R<n>`, and the Roadmap part of `/foreman:status all`.

### Setup asks the roadmap question

Asked through `AskUserQuestion`, in a new setup after `workflow.md` is
drafted, and alone in J2:

```
Where does this project's roadmap live? The roadmap is the list of future tracks.

1. foreman/roadmap.md
   One line per future track, in the repo. Adding a line takes a commit and a merged PR.
2. GitHub issues
   One open issue labelled `roadmap` per future track. Adding one takes no commit.
```

### GitHub issues picked, but gh cannot be used

Setup prints the failure and the fix, then asks:

```
GitHub issues cannot be used: `gh auth status` failed: You are not logged into any GitHub hosts.
Fix: run `! gh auth login`, then run /foreman:setup again.

1. Stop, fix gh, and run /foreman:setup again
2. Use foreman/roadmap.md
```

The other failures change the first two lines only:

| Failure | First line | Fix line |
|---|---|---|
| No origin | `GitHub issues cannot be used: origin is not set.` | `Fix: add a github.com origin, then run /foreman:setup again.` |
| gh not installed | `GitHub issues cannot be used: gh is not installed.` | `Fix: install gh, then run /foreman:setup again.` |
| Any other gh error | `GitHub issues cannot be used: <gh's first error line>` | none |

When origin is not on GitHub, the first line reads:

```
GitHub issues cannot be used: origin is git@gitlab.com:me/app.git, not on github.com.
```

and the fix line is left out, because no fix makes GitHub issues work
there. The options become:

```
1. Stop setup
2. Use foreman/roadmap.md
```

Option 1 in a new setup ends setup with every other file written and
committed as usual, no `## Roadmap` section, no `roadmap.md` and no
Future tracks row in `index.md`, so the next run asks only the roadmap
question, as in J2.

Once migration has opened its first issue, a gh failure prints the
failure and its Fix line and stops setup, with no fallback offered,
because the moved lines are already gone from `roadmap.md`. The next run
continues the migration.

### gh fails outside setup

Whenever gh fails in `/foreman:new-track #N`, an added future track,
shape's defer, or status, the skill prints two lines, opens nothing,
commits nothing and stops:

```
GitHub issues cannot be used: <failure>.
Fix: <fix>.
```

The failure and fix come from the setup table, with ", then run
/foreman:setup again" dropped from each Fix line. A failure with no Fix
line in that table prints only the first line. Status puts `Roadmap: ` in
front of the first line.

### Existing roadmap moved to issues (J2)

```
Moved 12 roadmap lines to GitHub issues labelled `roadmap`: #5 to #16.
Deleted foreman/roadmap.md. Recorded the choice in foreman/workflow.md under ## Roadmap.
Merge branch chore/foreman-roadmap to finish: push it and open a PR.
```

- The Moved line counts and lists only the issues opened in this run.
- 1 line: `Moved 1 roadmap line to GitHub issue #5 labelled `roadmap`.`
- Numbers not consecutive, when other issues were opened meanwhile: each
  number is listed, `#5, #6, #9`.
- 0 lines: the Moved line is left out.
- No `roadmap.md`: the Moved and Deleted lines are left out.

J2 with `foreman/roadmap.md` picked prints:

```
Recorded the choice in foreman/workflow.md under ## Roadmap.
Merge branch chore/foreman-roadmap to finish: push it and open a PR.
```

### Future track added (J3, J6)

As today with `roadmap.md`, no skill owns this and no reply text is
fixed: Claude runs the Add command in `workflow.md` `## Roadmap` and
reports the issue number. The title is the description's first sentence;
the body is the rest, then where it came from, as a `roadmap.md` line
holds. Shape names the track the part was deferred from.

### Track started from an issue (J4)

`/foreman:new-track #42` reads issue 42's title and body, then goes on
exactly as when the user types a description. Any open issue works,
whatever its labels and whatever the roadmap choice. Otherwise new-track
stops:

```
Issue #42 is closed. Start from an open issue, or type a description.
```

```
Issue #42 does not exist. Start from an open issue, or type a description.
```

A number that is a pull request counts as missing.

On a project using GitHub issues, `/foreman:new-track R<n>` stops,
because migration dropped every `R<n>` id:

```
This project's roadmap is in GitHub issues. Start from an open issue, or type a description.
```

### Roadmap in `/foreman:status all` (J5)

```
Roadmap
#42 Security review of a track's diff before ship: supply-chain risk in new dependencies, secrets, and common appsec flaws, each finding settled like a review fix.
#43 Drift report: compare the code with the archived specs and the project files, and list each place they disagree.
```

Each line is the issue number and its title, oldest first. An issue whose
track is in progress is listed like any other. No open
`roadmap` issue prints `Roadmap: none`. When `gh` fails, status prints the
failure and the fix in place of the list:

```
Roadmap: GitHub issues cannot be used: `gh auth status` failed: You are not logged into any GitHub hosts.
Fix: run `! gh auth login`.
```

### Implement hand-off (J7, J8)

Shape's close and status print:

```
Start implement with:

/goal Follow /foreman:implement for the track on this branch until every task in its plan.md is checked or BLOCKED and gate.sh all prints ok, then /foreman:prove until proof.md has a line per acceptance criterion; or stop after 200 turns.
```

Implement on a model other than Opus stops before any work:

```
Implement runs on Opus. This session runs on Sonnet 5.5.
Run `/model opus`, then send the /goal line again.
```

## Acceptance criteria

- AC1: When `/foreman:setup` runs on a new project, it asks the roadmap
  question as in §Experience and records the answer in `workflow.md` under
  `## Roadmap`. With GitHub issues picked, no `roadmap.md` is written, the
  index row reads as in §Contracts, and the `roadmap` label exists; an
  existing `roadmap` label is left unchanged and setup goes on. Proof:
  command output.
- AC2: When `/foreman:setup` runs on a set-up project whose `workflow.md`
  has no `## Roadmap` section, it asks only the roadmap question. Picking
  `foreman/roadmap.md` commits `docs(foreman): record roadmap choice` on
  `chore/foreman-roadmap` and prints the lines in §Experience. Proof:
  command output.
- AC3: When GitHub issues is picked on a project with N `roadmap.md`
  lines, N open issues labelled `roadmap` exist, each titled with its
  line's first sentence and without its `R<n>` id, and `roadmap.md` is
  gone, on branch `chore/foreman-roadmap`, in one commit
  `docs(foreman): move roadmap to GitHub issues`, with the index row
  rewritten and the summary as in §Experience. A rerun after a failure on
  a line continues on `chore/foreman-roadmap` and opens issues only for
  the lines left. Proof: command output.
- AC4: When GitHub issues is picked and gh cannot be used, setup prints
  the failure as in §Experience, offers `foreman/roadmap.md`, and records
  nothing until the user picks. Proof: command output.
- AC5: When the user asks for a future track on a project using issues, an
  issue labelled `roadmap` is opened and no commit is made. Proof: command
  output.
- AC6: When `/foreman:new-track #N` runs on an open issue, whatever its
  labels and whatever the roadmap choice, the track description is the
  issue's title and body, and the issue stays open. Proof: command output.
- AC7: When `/foreman:new-track #N` runs on a closed or missing issue, or
  a pull request, or `/foreman:new-track R<n>` runs on a project using
  GitHub issues, it stops with the message in §Experience. Proof: command
  output.
- AC8: When a track started from issue #N ships, its PR body carries
  `Closes #N`. Proof: command output.
- AC9: When `/foreman:status all` runs on a project using issues, the
  Roadmap part lists open `roadmap` issues, oldest first, prints
  `Roadmap: none` when there are none, and prints the gh failure and fix
  when `gh` fails. Proof: command output.
- AC10: When shape defers an out-of-scope part on a project using issues,
  it opens an issue labelled `roadmap` instead of editing `roadmap.md`.
  Proof: command output.
- AC11: On a project whose `workflow.md` records `foreman/roadmap.md`, or
  has no `## Roadmap` section, new-track `R<n>`, status and shape behave as
  today. On a set-up project whose `workflow.md` has a `## Roadmap`
  section, in either form, setup behaves as today. Proof: command output.
- AC12: When gh fails in new-track `#N`, an added future track, or shape's
  defer, the skill prints the failure as in §Experience, opens nothing and
  commits nothing. Proof: command output.
- AC13: When shape closes, or status runs on a track in implement, the
  output holds the `/goal` line as in §Experience and no `/model` or auto
  mode line. Proof: command output.
- AC14: When `/foreman:implement` starts on a model other than Opus, it
  prints the message in §Experience and writes, commits and spawns
  nothing. Proof: command output.

## Contracts

### `workflow.md` `## Roadmap`

Setup writes one of two forms. Skills read this section to learn where the
roadmap lives. A project with no such section uses `foreman/roadmap.md`,
as today, until setup asks.

```
## Roadmap

`foreman/roadmap.md`, one line per future track.
```

```
## Roadmap

GitHub issues labelled `roadmap`, one open issue per future track.

| Do | Run |
|---|---|
| List | `gh issue list --label roadmap --state open --limit 1000 --search "sort:created-asc"` |
| Add | `gh issue create --label roadmap --title <title> --body <body>` |
```

### `foreman/index.md` row

With issues, the "Future tracks" row points to `workflow.md`, so
`check-index.sh` still finds a file:

```
| Future tracks: GitHub issues labelled `roadmap` | `workflow.md` |
```

### `metadata.json`

A track started from an issue has one more key, written by new-track on
its own line, a string like every other value:

```
  "issue": "42",
```

Ship fills `Closes #42` in the PR body from it. A track without the key
gets no `Closes` line from it.

### The `roadmap` label

Setup creates it whenever GitHub issues is picked, in J1 and J2, with
`gh label create roadmap --description "Future track"`. If the label
already exists, that error counts as success and the label is left as it
is.

### Migration (J2)

- A `roadmap.md` line is one `- R<n>:` item, however many lines it wraps
  to. The preamble and `Next id` are not lines.
- The item's wrapped lines are joined with single spaces first. The
  issue title is then the first sentence without `R<n>: `: the text up to
  and including the period of the first `. ` outside backticks, or the
  whole line when it has none. The rest of the line is the body.
- Runs on branch `chore/foreman-roadmap` off main, because the setup
  branch of a set-up project was merged long ago. When that branch already
  exists, setup continues on it and reads its `roadmap.md`.
- Setup opens one issue per line, in file order, and removes each line
  from `roadmap.md` as soon as its issue exists. A run that fails halfway
  leaves only the lines not yet moved, so the next run opens no duplicate.
- When no line is left: delete `roadmap.md`, write `## Roadmap` in
  `workflow.md`, rewrite the index row, and commit once,
  `docs(foreman): move roadmap to GitHub issues`.
- A J2 pick of `foreman/roadmap.md` writes the section on the same branch
  and commits once, `docs(foreman): record roadmap choice`. When the
  project has no `roadmap.md`, as after option 1 "Stop" in a new setup,
  the same commit writes it with the preamble and `Next id: R1`.
- J2 writes the `index.md` Future tracks row in either choice.
- The issues exist on GitHub before that branch merges. The summary says
  to merge it.

### Project files this track changes

- `product.md`, the refusal, exactly: "A system of record outside the
  repo. Tracks, specs and decisions are markdown on the branch. GitHub
  holds PRs and issues:
  roadmap issues when setup chose them, and any issue a track starts from.
  Markdown in the repo stays the default."
- `product.md`, the vocabulary line: "**roadmap**: the future tracks, one
  line each in `roadmap.md` or one open issue labelled `roadmap` each, as
  `workflow.md` records."
- `tech-stack.md`: the contested choice becomes "Markdown state in the
  repo, not GitHub issues or a database. It travels with the branch,
  survives session death, and works on web. The roadmap alone may live in
  GitHub issues, chosen at setup, because a future track needs no branch
  until it starts."
- `tech-stack.md`, the State line gains "; the roadmap in GitHub issues
  when setup chose them."

## Alternatives considered

- `roadmap.md` kept as a pointer file: rejected by the user; the choice
  lives in `workflow.md`.
- A new `/foreman:roadmap` skill to list, add and switch: rejected; setup
  asks once and every other skill reads `workflow.md`.
- Closing the issue when the track starts: rejected; `Closes #N` closes it
  at merge, so an abandoned track leaves the issue open.
- GitHub Projects or milestones: out of scope.

## Non-functional

- No dependency beyond `gh`, which `tech-stack.md` already allows.
- A session where `gh` is not logged in, such as some web sessions, sees
  the gh error from §Experience, never a silent empty roadmap.

## Reuse and untouched

Reused: new-track's `R<n>` path for `#N`; the `Closes #N` line already in
ship's `pr-body.md`; `gh`, already allowed.

Untouched: `state.sh`, `set-track.sh`, `check-index.sh`, the gate and
guard scripts, the agents, prove and review. Implement changes only by
the model check. Tracks, specs and
decisions stay markdown on the branch.

## Out of scope

- Tracks, specs or decisions in issues.
- Listing bug issues in `/foreman:status`.
- Hosts other than GitHub.
- Switching back from issues to `roadmap.md`.
- Keeping `roadmap.md` and issues both, or syncing them.
- Milestones, project boards, assignees.
