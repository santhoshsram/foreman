# Proof: Roadmap in GitHub issues as a setup option

Built at `4f1afac`. The built thing is skill prose, run by a model. Runs
used fresh subagents following the skill files of this worktree, in a
throwaway copy of the repo with a github.com origin and the GitHub issues
form of `## Roadmap`. Every `gh` call ran with `GH_CONFIG_DIR` set to an
empty temp dir, so gh was logged out and no real client config was read.
A static check (`grep -F` of each spec output string in the skill that
prints it) found 38 of 38 strings; it shows the contract text is there, not
that a run prints it.

| AC | Proof | Evidence | Result |
|---|---|---|---|
| AC1 | command output | Static only: question, both `## Roadmap` forms, index row and label command present in `skills/setup/SKILL.md`. A run needs a new project and a GitHub repo; see Manual | manual |
| AC2 | command output | Static only: `docs(foreman): record roadmap choice` and its two output lines present. See Manual | manual |
| AC3 | command output | Static only: migration rules, summary lines and commit subject present. A run opens real issues; see Manual | manual |
| AC4 | command output | Static only: failure screen, table rows and non-GitHub options present. See Manual | manual |
| AC5 | command output | Add row present in the issues form of `## Roadmap`. A run opens a real issue; see Manual | manual |
| AC6 | command output | Not run: needs an open issue readable by a logged-in gh. See Manual | manual |
| AC7 | command output | new-track run with `R3` on the issues-form sample printed `This project's roadmap is in GitHub issues. Start from an open issue, or type a description.`, byte for byte the spec line, and wrote nothing. Closed, missing and pull request cases not run; see Manual | pass |
| AC8 | command output | Static only: `skills/ship/assets/pr-body.md` ends `Closes #<N, the track's "issue" in metadata.json. Omit if none.>` and ship reads `"issue"`. See Manual | manual |
| AC9 | command output | status `all` run on the sample, gh logged out, printed `Roadmap: GitHub issues cannot be used: \`gh auth status\` failed: You are not logged into any GitHub hosts.` then `Fix: run \`! gh auth login\`.`, byte for byte the spec block. List and `Roadmap: none` states need a logged-in gh; see Manual | manual |
| AC10 | command output | Static only: shape's defer runs the Add command, body ending `Deferred from <id>.`. See Manual | manual |
| AC11 | command output | Static only: setup, new-track, status and shape fall back to `roadmap.md` without a GitHub issues `## Roadmap`. See Manual | manual |
| AC12 | command output | new-track `#1` run, gh logged out, printed the two gh failure lines of spec §Experience and wrote nothing. Added future track and shape's defer not run; see Manual | manual |
| AC13 | command output | `diff` of the spec §Experience block against `skills/shape/assets/run-unattended.md`: identical. Shape and status print that file verbatim; `grep -E '/model\|auto mode'` finds nothing in it, in `skills/shape/SKILL.md` or in `skills/status/SKILL.md` | pass |
| AC14 | command output | implement run by a Sonnet subagent printed `Implement runs on Opus. This session runs on Sonnet 5.5.` then ``Run `/model opus`, then send the /goal line again.``, byte for byte the spec block; `git status --porcelain` stayed empty afterwards | pass |

## Manual

For the user to run; prove could not, because each needs a logged-in gh on
a GitHub repo that may get real issues and a `roadmap` label. Use a
throwaway GitHub repo, with this branch's plugin loaded.

- AC1, AC4: in a new repo, run `/foreman:setup`. Holds when the roadmap
  question appears as in spec §Experience; picking GitHub issues writes the
  issues form of `## Roadmap`, the index row, no `roadmap.md`, and creates
  the `roadmap` label. Repeat logged out of gh: the failure screen and its
  two options appear and nothing is recorded until a pick.
- AC2, AC3: in a set-up repo with a `roadmap.md` of 3 lines and no
  `## Roadmap`, run `/foreman:setup`. Holds when only the roadmap question
  is asked; GitHub issues opens 3 `roadmap` issues titled by first sentence
  without `R<n>`, deletes `roadmap.md` on `chore/foreman-roadmap` in one
  commit, and prints the summary. `foreman/roadmap.md` instead commits
  `docs(foreman): record roadmap choice` and prints its two lines.
- AC5: ask "add a future track: X". Holds when a `roadmap` issue exists and
  `git status` shows no commit.
- AC6, AC7: `/foreman:new-track #N` on an open issue: the description is
  its title and body, the issue stays open, `metadata.json` has `"issue"`.
  On a closed issue, a missing number and a pull request number: the spec
  messages.
- AC8: `/foreman:ship` that track: the PR body ends `Closes #N`.
- AC9: `/foreman:status all` with 2 open `roadmap` issues lists them oldest
  first; with none prints `Roadmap: none`.
- AC10, AC12: in `/foreman:shape`, defer a part: a `roadmap` issue whose
  body ends `Deferred from <id>.`; logged out, the two failure lines and no
  issue.
- AC11: in this repo, which has no `## Roadmap`: `/foreman:status all`
  lists the `R<n>` lines as before.

## Adversarial

- AC7: `R3` on an issues-form project that still has a `roadmap.md` with
  an `R3:` line -> held: new-track decided by `## Roadmap`, not by the file.
- AC9, AC12: gh logged out, so `gh issue list` and `gh issue view` fail
  with gh's own "To get started with GitHub CLI" text, not `gh auth status`
  -> held: both runs printed the not-logged-in lines, but each ran
  `gh auth status` on its own to pick the table row; a literal reader could
  print the "Any other gh error" row instead, which the spec also allows.
- AC14: implement on Sonnet with this track's real state, phase `prove`
  -> held: the model check ran before the state check and nothing changed.
- AC3: migration rerun from a different checkout after a halfway failure
  -> outside AC3 as written: removed lines are uncommitted until the final
  commit, so another checkout sees the full `roadmap.md` and would open
  duplicates. Not filed: a solo developer reruns in the same checkout,
  where AC3 holds. Listed as a `review:` decision.
- AC13: a `/model` or auto mode line surviving anywhere in the hand-off
  path -> held: none in the asset, shape or status.
