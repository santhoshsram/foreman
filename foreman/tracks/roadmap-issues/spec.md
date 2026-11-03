# Roadmap in GitHub issues as a setup option

## Goal

A project can keep its roadmap as GitHub issues labelled `roadmap`
instead of `foreman/roadmap.md`, chosen at setup. With markdown, every new
future track costs a commit and a merged PR; with issues, it costs one
issue. `foreman/roadmap.md` stays the default. Tracks, specs and decisions
never leave the repo.

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

and the fix line is left out, because only option 2 can work.

Option 1 in a new setup ends setup with every other file written and
committed as usual, no `## Roadmap` section and no `roadmap.md`, so the
next run asks only the roadmap question, as in J2.

### gh fails outside setup

Whenever gh fails in `/foreman:new-track #N`, an added future track,
shape's defer, or status, the skill prints the failure and its fix in the
form status uses below, opens nothing, commits nothing and stops. For an
error other than auth, it prints gh's first error line and no Fix line.

### Existing roadmap moved to issues (J2)

```
Moved 12 roadmap lines to GitHub issues labelled `roadmap`: #5 to #16.
Deleted foreman/roadmap.md. Recorded the choice in foreman/workflow.md under ## Roadmap.
Merge branch chore/foreman-roadmap to finish: push it and open a PR.
```

- 1 line: `Moved 1 roadmap line to GitHub issue #5 labelled `roadmap`.`
- Numbers not consecutive, such as after a rerun: each number is listed,
  `#5, #6, #9`.
- 0 lines, or no `roadmap.md`: the Moved and Deleted lines are left out.

### Future track added (J3, J6)

When the user asks for a future track, or shape defers a part:

```
Opened #44 "Upstream-diff skill", labelled `roadmap`.
```

The issue body is the future track's description, then where it came
from, as a `roadmap.md` line holds. Shape names the track the part was
deferred from.

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

### Roadmap in `/foreman:status all` (J5)

```
Roadmap
#42 Security review of a track's diff before ship
#43 Drift report
```

Each line is the issue number and its title, oldest first. No open
`roadmap` issue prints `Roadmap: none`. When `gh` fails, status prints the
failure and the fix in place of the list:

```
Roadmap: cannot read GitHub issues: `gh auth status` failed: You are not logged into any GitHub hosts.
Fix: run `! gh auth login`.
```

## Acceptance criteria

- AC1: When `/foreman:setup` runs on a new project, it asks the roadmap
  question as in §Experience and records the answer in `workflow.md` under
  `## Roadmap`. With GitHub issues picked, no `roadmap.md` is written, the
  index row reads as in §Contracts, and the `roadmap` label exists. Proof:
  command output.
- AC2: When `/foreman:setup` runs on a set-up project whose `workflow.md`
  has no `## Roadmap` section, it asks only the roadmap question. Proof:
  command output.
- AC3: When GitHub issues is picked on a project with N `roadmap.md`
  lines, N open issues labelled `roadmap` exist, each titled with its
  line's first sentence and without its `R<n>` id, and `roadmap.md` is
  gone, on branch `chore/foreman-roadmap`, in one commit
  `docs(foreman): move roadmap to GitHub issues`, with the index row
  rewritten and the summary as in §Experience. Proof: command output.
- AC4: When GitHub issues is picked and gh cannot be used, setup prints
  the failure as in §Experience, offers `foreman/roadmap.md`, and records
  nothing until the user picks. Proof: command output.
- AC5: When the user asks for a future track on a project using issues, an
  issue labelled `roadmap` is opened, no commit is made, and the
  `Opened #N` line prints. Proof: command output.
- AC6: When `/foreman:new-track #N` runs on an open issue, whatever its
  labels and whatever the roadmap choice, the track description is the
  issue's title and body, and the issue stays open. Proof: command output.
- AC7: When `/foreman:new-track #N` runs on a closed or missing issue, or
  a pull request, it stops with the message in §Experience. Proof: command
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
  has no `## Roadmap` section, setup, new-track `R<n>`, status and shape
  behave as today. Proof: command output.
- AC12: When gh fails in new-track `#N`, an added future track, or shape's
  defer, the skill prints the failure as in §Experience, opens nothing and
  commits nothing. Proof: command output.

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
  and commits once, `docs(foreman): record roadmap choice`.
- The issues exist on GitHub before that branch merges. The summary says
  to merge it.

### Project files this track changes

- `product.md`, the refusal, exactly: "A system of record outside the
  repo. Everything is markdown on the branch. GitHub holds PRs and issues:
  roadmap issues when setup chose them, and any issue a track starts from.
  Markdown in the repo stays the default."
- `product.md`, the vocabulary line: "**roadmap**: the future tracks, one
  line each in `roadmap.md` or one open issue labelled `roadmap` each, as
  `workflow.md` records."
- `tech-stack.md`: the contested choice becomes "Markdown state in the
  repo, not GitHub issues or a database. It travels with the branch,
  survives session death, and works on web. The roadmap alone may live in
  GitHub issues, chosen at setup, because a roadmap line needs no branch."

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
guard scripts, the agents, implement, prove and review. Tracks, specs and
decisions stay markdown on the branch.

## Out of scope

- Tracks, specs or decisions in issues.
- Listing bug issues in `/foreman:status`.
- Hosts other than GitHub.
- Switching back from issues to `roadmap.md`.
- Keeping `roadmap.md` and issues both, or syncing them.
- Milestones, project boards, assignees.
