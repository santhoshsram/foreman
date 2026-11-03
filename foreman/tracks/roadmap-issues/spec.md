# Roadmap in GitHub issues as a setup option

## Goal

A project can keep its roadmap as GitHub issues labelled `roadmap`
instead of `foreman/roadmap.md`, chosen at setup. With markdown, every new
roadmap line costs a commit and a merged PR; with issues, it costs one
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
- J3 Add an item. Given a project on GitHub issues, when the user asks for
  a new roadmap item, then an issue labelled `roadmap` is opened and no
  commit is made.
- J4 Start a track. Given open issue #N, labelled `roadmap` or `bug`, when
  the user runs `/foreman:new-track #N`, then the track starts from that
  issue, the issue stays open, and the track's PR body carries
  `Closes #N`, so the merge closes it.
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

When origin is not on GitHub, the first line reads:

```
GitHub issues cannot be used: origin is git@gitlab.com:me/app.git, not on github.com.
```

and the fix line is left out, because only option 2 can work.

### Existing roadmap moved to issues (J2)

```
Moved 12 roadmap lines to GitHub issues labelled `roadmap`: #5 to #16.
Deleted foreman/roadmap.md. Recorded the choice in foreman/workflow.md under ## Roadmap.
```

### Roadmap item added (J3, J6)

When the user asks for a roadmap item, or shape defers a part:

```
Opened #44 "Upstream-diff skill", labelled `roadmap`.
```

### Track started from an issue (J4)

`/foreman:new-track #42` reads issue 42's title and description, then goes
on exactly as when the user types a description. Any open issue works,
whatever its labels. When issue 42 is closed or
does not exist, new-track stops:

```
Issue #42 is closed. Start from an open issue, or type a description.
```

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
  `## Roadmap`. Proof: command output.
- AC2: When `/foreman:setup` runs on a set-up project whose `workflow.md`
  has no `## Roadmap` section, it asks only the roadmap question. Proof:
  command output.
- AC3: When GitHub issues is picked on a project with N `roadmap.md`
  lines, N open issues labelled `roadmap` exist, each titled with its
  line's first sentence and without its `R<n>` id, and `roadmap.md` is
  gone. Proof: command output.
- AC4: When GitHub issues is picked and `gh auth status` fails, or origin
  is not on github.com, setup prints the failure as in §Experience, offers
  `foreman/roadmap.md`, and records nothing until the user picks. Proof:
  command output.
- AC5: When the user asks for a roadmap item on a project using issues, an
  issue labelled `roadmap` is opened, no commit is made, and the
  `Opened #N` line prints. Proof: command output.
- AC6: When `/foreman:new-track #N` runs on an open issue, whatever its
  labels, the track description is the issue's title and description, and
  the issue stays open. Proof: command output.
- AC7: When `/foreman:new-track #N` runs on a closed or missing issue, it
  stops with the message in §Experience. Proof: command output.
- AC8: When a track started from issue #N ships, its PR body carries
  `Closes #N`. Proof: command output.
- AC9: When `/foreman:status all` runs on a project using issues, the
  Roadmap part lists open `roadmap` issues, oldest first, prints
  `Roadmap: none` when there are none, and prints the gh failure and fix
  when `gh` fails. Proof: command output.
- AC10: When shape defers an out-of-scope part on a project using issues,
  it opens an issue labelled `roadmap` instead of editing `roadmap.md`.
  Proof: command output.
- AC11: On a project whose `workflow.md` records `foreman/roadmap.md`,
  setup, new-track `R<n>`, status and shape behave as today. Proof:
  command output.

## Contracts

### `workflow.md` `## Roadmap`

Setup writes one of two forms. Skills read this section to learn where the
roadmap lives; a project with no such section is one setup has not asked.

```
## Roadmap

`foreman/roadmap.md`, one line per future track.
```

```
## Roadmap

GitHub issues labelled `roadmap`, one open issue per future track.

| Do | Run |
|---|---|
| List | `gh issue list --label roadmap --state open` |
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

Setup creates it before the first issue, with
`gh label create roadmap --description "Future track" --force`, so a repo
that already has the label is left as it is.

### Migration (J2)

- Runs on branch `chore/foreman-roadmap` off main, because the setup
  branch of a set-up project was merged long ago.
- Setup opens one issue per `roadmap.md` line, in file order, and removes
  each line from `roadmap.md` as soon as its issue exists. A run that fails
  halfway leaves only the lines not yet moved, so the next run opens no
  duplicate.
- When no line is left: delete `roadmap.md`, write `## Roadmap` in
  `workflow.md`, rewrite the index row, and commit once,
  `docs(foreman): move roadmap to GitHub issues`.
- The issues exist on GitHub before that branch merges. The summary says
  to merge it.

### Project files this track changes

- `product.md`: the refusal and the `roadmap` vocabulary line, as in
  `decisions.md`.
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
