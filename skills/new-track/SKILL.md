---
name: new-track
description: Start a track, one feature or fix, on its own worktree and branch. Writes the track folder under foreman/tracks/ with a seeded question list and a registry row, commits, then starts shape. Use for "/foreman:new-track <description>", "start a feature", or "new track for X".
argument-hint: "[description | roadmap id]"
---

# New track

Goal: a track ready for shape. Done when a worktree is on the track's branch,
`foreman/tracks/<id>/` holds `metadata.json`, `index.md`, `spec.md` and
`decisions.md`, `foreman/tracks.md` has its row, all of it is committed, and
shape has started in this session.

`${CLAUDE_PLUGIN_ROOT}/guideline.md` governs questions and stops. Read it
first.

## State

- Run `${CLAUDE_PLUGIN_ROOT}/scripts/state.sh`. `setup_complete: false`:
  setup is not on this branch yet. Say to run `/foreman:setup`, or to merge
  `chore/foreman-setup` if it exists, and stop.
- `track` not null: this branch already has a track. Name it, point to
  `/foreman:status`, and stop.
- Read the project files `foreman/index.md` lists.

## The track

- Description: `$ARGUMENTS`, else ask for it, offering the lines in
  `foreman/roadmap.md`. A roadmap id such as `R3` takes that line.
- From it, propose the title, the type and the id, and confirm all three in
  one batch. The type is a Conventional Commits type (feat, fix, refactor,
  perf, docs, chore), because it prefixes the branch and the PR title.
- The id is short kebab case, without a date: the branch `<type>/<id>`
  carries it. It collides when it exists under `foreman/tracks/` or
  `foreman/archive/`, or the branch exists locally or on the remote. On a
  collision, ask: another id, or resume the existing track.

## Worktree and branch

- Already in a worktree (`worktree: true`): ask whether the track uses it.
  Yes: the track lives on that worktree's current branch, recorded as it is.
- Otherwise create one off the latest main, `origin/main` after a fetch when
  a remote exists: `git worktree add .claude/worktrees/<id> -b <type>/<id>
  <base>`. First, unless `git check-ignore -q .claude/worktrees/<id>`
  succeeds, append `.claude/worktrees/` to `.git/info/exclude`: not
  `.gitignore`, because the track branch's commits reach main only at merge,
  and the main checkout would show the worktree as untracked until then.
  Then EnterWorktree with that `path`, so this session and shape
  after it work there. Trap: EnterWorktree with `name` makes its own branch,
  `worktree-<name>`, off its own base.
- A session without EnterWorktree, such as a cloud session on an assigned
  branch, works on that branch directly.

## Files

From `${CLAUDE_PLUGIN_ROOT}/skills/new-track/assets/` into
`foreman/tracks/<id>/`, placeholders filled:

| File | Holds |
|---|---|
| `metadata.json` | phase `shape`, sub_step `user`, status `active`, UTC timestamps. Keep the asset's shape: one key per line, each string value on its key's line, because `state.sh` parses it with sed. Every later change goes through `${CLAUDE_PLUGIN_ROOT}/scripts/set-track.sh`, never by hand |
| `index.md` | Links to the track files |
| `spec.md` | Every heading, `open` under each |
| `decisions.md` | The shape question list. A line the project files already answer is settled by reference, its evidence the file and section (`ux.md#states`), and shape never re-asks it |

Append `| <id> | <title> | shape | <branch> |` to `foreman/tracks.md`. A
description taken from a `foreman/roadmap.md` line removes that line.

## Commit

One commit, `chore(foreman): start track <id>`, staging
`foreman/tracks/<id>/`, `foreman/tracks.md` and `foreman/roadmap.md` only.
A web session resumes the track only once the branch is pushed.

## Hand off

Start shape in this session through the Skill tool, `foreman:shape`.
