---
name: setup
description: Set up foreman in a project. Drafts the foreman/ project files (product, guidelines, tech stack, ux, workflow, style guides) from the user's story and the repo, iterates until settled, and commits them on a branch for the user to push. Use for "/foreman:setup", "set up foreman here", or when another foreman skill finds foreman/index.md missing.
---

# Setup

Goal: the project files under `foreman/`, each true of the project, drafted
from the user's story and the repo. A fact from anywhere else, such as memory
recall or an earlier session: ask before writing it. Settled lines are
written plain; the rest are written rough under `## Open`, for tracks to
sharpen. Done when
`foreman/index.md` exists, `check-index.sh` prints ok, and every file is
committed on `chore/foreman-setup`.

`${CLAUDE_PLUGIN_ROOT}/guideline.md` governs questions and stops. Read it
first.

## State

- The current directory is the project root.
- Setup work lives on branch `chore/foreman-setup`. If it exists locally or
  on the remote, switch to it before anything else: setup started in another
  session continues there.
- Then run `${CLAUDE_PLUGIN_ROOT}/scripts/state.sh`. `setup_complete: true`
  means setup is done: say so and stop; project files change at ship or by
  hand, not by a second setup. Otherwise resume at the first file in the
  table below that `files` reports missing, and never re-ask what a present
  file settles. A `product.md` without `## Who uses it` holds only the
  product statement: `state.sh` reports it present, but resume at its draft.

## Read the repo first

Read the repo before asking anything, so every draft leads with what it
already answers: docs, manifests, CI and build files, and the directory
tree. Source only when a question needs it; a tree says what the project is
made of. Broad reading of those is fine, because the output files are broad.

Uncommitted changes outside `foreman/` belong to the user: warn once and
never stage them.

No `.git`, greenfield or brownfield: `git init`. The existing code stays
untracked; it is the user's to commit.

## Story first

The questions in the table are the shape of the output, not the interview.
Nobody answers "what is the one test" cold. Ask for the story: what it is,
for whom, what annoyed the user into it, what it must never become. Then
draft the answers yourself, offer candidates where the story has none, and
iterate until the user says that is it.

Before `product.md` comes the product statement: two or three sentences, in
the user's words, on who uses it, the moment they reach for it, and what it
does for them that nothing else does. The project files expand it. The one
test, refusals and vocabulary are derived from it in the `product.md` draft,
not stated in it.

Draft the product statement from the story and the repo, show it, and ask
what is wrong or missing. On a correction, restate that part and ask again,
until the user says that is it.

Once agreed, commit it at once as `product.md`: the title, then the
statement word for word under no heading. That commit is the resume point.
The full draft expands the file in place, below the statement, from
`## Who uses it` on, and is committed again when settled.

## Files, in order

`${CLAUDE_PLUGIN_ROOT}/foreman/` is foreman's own filled set: the reference
for shape and density, not content. A project file holds what is true of the
project; anything about one feature belongs to a track.

| File | Settles |
|---|---|
| `product.md` | Who uses this and what they are doing when they reach for it; the one test a feature must pass to belong; what it refuses to be; vocabulary, words that mean exactly one thing |
| `product-guidelines.md` | Voice and banned words; what the user never has to learn or configure; what must never happen |
| `tech-stack.md` | The stack; which choice was contested and why it won; what is never added without a decision line |
| `ux.md` | UI projects only. Fixed places and navigation; states; the nearest screen or command for each flow; a pointer to root `DESIGN.md` for tokens, open if it does not exist |
| `workflow.md` | From `assets/workflow.md`. Commands, test paths, scopes and conventions come from the repo; a command the repo lacks is `none yet`, never invented. `gate.sh` and the worker guards parse the Commands rows and Test paths, so keep their names. Ask only: what does done mean, and where is it released |
| `code_styleguides/` | Copied, see below |
| `learnings.md`, `tracks.md` | Copied from `assets/` as they are |
| `## Roadmap` in `workflow.md`, `roadmap.md` | Where the roadmap lives, see "Roadmap". `roadmap.md` is copied from `assets/` only when `foreman/roadmap.md` is picked |
| `index.md` | Last, because its presence marks setup complete. From `assets/index.md`, with rows only for files that exist |

Commit each file as soon as it is settled, so `state.sh` can resume from
what exists.

## Roadmap

In a new setup, after `workflow.md` is drafted, ask through
`AskUserQuestion`:

```
Where does this project's roadmap live? The roadmap is the list of future tracks.

1. foreman/roadmap.md
   One line per future track, in the repo. Adding a line takes a commit and a merged PR.
2. GitHub issues
   One open issue labelled `roadmap` per future track. Adding one takes no commit.
```

Record the answer in `workflow.md` as one of two `## Roadmap` forms.

`foreman/roadmap.md`: copy `assets/roadmap.md`, keep the `index.md` row
from the asset, and write:

```
## Roadmap

`foreman/roadmap.md`, one line per future track.
```

GitHub issues: first check gh works: an origin on github.com is set, `gh`
is installed, and `gh auth status` passes. If it does, create the label
with `gh label create roadmap --description "Future track"`; a label that
already exists is success, left as it is. Write no `roadmap.md`. Write:

````
## Roadmap

GitHub issues labelled `roadmap`, one open issue per future track.

| Do | Run |
|---|---|
| List | `gh issue list --label roadmap --state open --limit 1000 --search "sort:created-asc"` |
| Add | `gh issue create --label roadmap --title <title> --body <body>` |
````

and make the `index.md` Future tracks row:

```
| Future tracks: GitHub issues labelled `roadmap` | `workflow.md` |
```

### gh cannot be used

Print the failure and the fix, then ask through `AskUserQuestion`:

```
GitHub issues cannot be used: `gh auth status` failed: You are not logged into any GitHub hosts.
Fix: run `! gh auth login`, then run /foreman:setup again.

1. Stop, fix gh, and run /foreman:setup again
2. Use foreman/roadmap.md
```

Other failures change the first two lines only:

| Failure | First line | Fix line |
|---|---|---|
| No origin | `GitHub issues cannot be used: origin is not set.` | `Fix: add a github.com origin, then run /foreman:setup again.` |
| gh not installed | `GitHub issues cannot be used: gh is not installed.` | `Fix: install gh, then run /foreman:setup again.` |
| Any other gh error | `GitHub issues cannot be used: <gh's first error line>` | none |

When origin is not on GitHub, the first line reads
`GitHub issues cannot be used: origin is git@gitlab.com:me/app.git, not on github.com.`
(with the real origin), the fix line is left out, and the options are:

```
1. Stop setup
2. Use foreman/roadmap.md
```

Record nothing until the user picks. Option 2 goes on as the
`foreman/roadmap.md` form. Option 1 ends setup with every other file
written and committed as usual, no `## Roadmap` section, no `roadmap.md`
and no Future tracks row in `index.md`; the next run asks only the roadmap
question.

## Style guides

Copy `general.md` and one guide per language in `tech-stack.md` from
`${CLAUDE_PLUGIN_ROOT}/skills/setup/assets/code_styleguides/` to
`foreman/code_styleguides/`; JavaScript takes `typescript.md`. Copy only,
never write or edit rules: review treats a guide as law, so every rule must
trace to its source. A language with no asset: fetch conductor's guide at
the commit in `${CLAUDE_PLUGIN_ROOT}/foreman/upstreams.md` if conductor has
one, else mark it open in `tech-stack.md`.

## Index and commits

- `${CLAUDE_PLUGIN_ROOT}/scripts/check-index.sh` must print `check-index: ok`
  before the last commit.
- Commits go on `chore/foreman-setup` off main, never on main: every change
  lands by PR. A repo with no commits gets an empty root commit on main
  first, so the branch has a base.
- One commit per file, `docs(foreman): add <file>`. Stage `foreman/` paths
  only.
- End by printing what is left for the user, in this order: optionally
  `/foreman:critique foreman/product.md`, while still on the branch; push
  `chore/foreman-setup`, open the PR, merge; then `/foreman:new-track`,
  which branches off main and so needs the merge.
