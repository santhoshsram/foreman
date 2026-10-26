---
name: implement
description: Build a shaped track. Drafts plan.md from the spec, then runs a test-writer and an implementer per task under script gates, each task committed with its SHA in plan.md, then /simplify and /code-review --fix, then hands to prove. Runs unattended. Use for "/foreman:implement", "build this track", or after shape closes.
---

# Implement

Goal: every task in the track's `plan.md` built and committed, or marked
BLOCKED, with `gate.sh all` printing ok. Done when that holds after
`/simplify` and `/code-review --fix`, and prove has started.

`${CLAUDE_PLUGIN_ROOT}/guideline.md` governs stops. Read it first.
`${CLAUDE_PLUGIN_ROOT}/scripts/gate.sh` is the gate, run from the worktree.
Run `gate.sh base` right before every worker spawn and before `/simplify`:
it records the tree that `gate.sh diff` measures changes against, here and
in the worker's own stop hook.

Runs under `/goal` on Opus in auto mode; shape and status print the
commands.

## Rules

- Never write source or tests. Workers do; you plan, gate, commit and judge.
  `/simplify` and `/code-review --fix` at close are the exceptions, below.
- Never edit `spec.md`. A spec gap stops the run, below.
- One task at a time. Read hand-backs only, never worker transcripts; use
  `git diff --stat`, not full diffs.
- Worker prompts are self-contained: the blocks below filled in, nothing
  from this conversation.

## State

Run `${CLAUDE_PLUGIN_ROOT}/scripts/state.sh`. `phase` must be `implement`.
No `plan.md` yet: draft it. Otherwise resume at the first task neither
checked nor BLOCKED. Uncommitted changes at the start mean a task died
mid-way: discard them when every changed path is in that task's Files or
Tests, else stop. HEAD whose subject is that task's heading means it died
between its two commits: write the plan commit, then go on.

`spec.md` committed after the last `plan.md` commit (`git log <that
commit>..HEAD -- spec.md` lists any) means a spec gap came back from shape.
Before resuming, redraft the unchecked tasks from the new spec as in Plan,
plus a task for any checked one it contradicts, and commit `docs(foreman):
replan <id>`.

## Plan

Draft `plan.md` in the track folder from the spec, the format in
`${CLAUDE_PLUGIN_ROOT}/skills/implement/assets/plan.md`, density as in
`task-example.md` there.

- Each task: one behaviour, one test file, a diff under about 300 lines.
- Every task cites the `AC<n>` it builds, and every acceptance criterion is
  cited by a task.
- Contract output is copied from the spec verbatim. Output the spec does not
  give is a spec gap, never invented.
- A task with nothing to test, such as docs only, has `Tests: none` and skips
  the test-writer.

Commit it, `docs(foreman): plan <id>`.

## Per task

a. Spawn `foreman:test-writer`:
   ```
   Task: foreman/tracks/<id>/plan.md, section "## <NN> <heading>"
   Write tests only, for the Behaviour items, named as the task names them.
   ```
   Contract ambiguity or a stop the spec settles: clarify in the task
   section, discard its test edits, respawn once. One the spec does not
   settle is a spec gap.

b. `gate.sh diff tests-only`, then `gate.sh red <test files>`, must print ok.
   Red is a non-zero exit: read the tail to confirm the failure is the
   missing behaviour, not a broken test. Tests that pass: respawn once with
   `Correction: tests pass already; make them fail without the new
   behaviour`. Then `git add` the test files: staged, they are what the
   implementer's gate diff is measured against.

c. Spawn `foreman:implementer`:
   ```
   Task: foreman/tracks/<id>/plan.md, section "## <NN> <heading>"
   Tests are staged: <test files>. Never edit a test path.
   ```

d. Judge each dispute against the spec, not the code.
   - Test wrong: stage the implementer's files so far, respawn the
     test-writer with `Correction: <file>:<test> <fix>`, `gate.sh diff
     tests-only` must print ok, stage the fix, rerun c. Red is not rerun:
     the code under test now exists.
   - Test right: respawn the implementer with `Clarification: <one line>`.
   - Gate not ok and no dispute: respawn the implementer with the failing
     gate line.
   - Out-of-scope edits in "Outside named files" count as a round.
   Two rounds per task, then BLOCKED: discard the task's staged and
   unstaged work, so later tasks start green.

e. `gate.sh diff no-tests` and `gate.sh green <test files>` yourself; a
   worker's gate line is not proof. Two commits per task:
   - code: the test files and the hand-back's files, the task heading as
     the subject;
   - plan: the task's box checked and the code commit's short SHA appended
     to its line, `- [x] 01 ... | deps: none [<sha>]`, `plan.md` alone,
     `docs(foreman): plan <id> <NN> done`.
   Revert and review find a task's commit by that SHA: a commit cannot hold
   its own.

f. A BLOCKED task gets `| BLOCKED: <reason>` on its line, committed with
   `plan.md`; a task whose dep is BLOCKED is `BLOCKED: dep <NN>`. Next task.

## Spec gap

A worker's or your own WHAT question the spec does not answer. Add it to
`decisions.md` as open, tagged with the sub-step it belongs to; run
`${CLAUDE_PLUGIN_ROOT}/scripts/set-track.sh phase=shape sub_step=<tag>`;
commit; print the stop report. Shape settles it and closes back here, and
the unchecked tasks are redrafted from the changed spec.

## Close

1. `/simplify` on the branch's changes. Source changes outside a worker:
   it changes no behaviour, and the gate proves it. Afterwards
   `gate.sh diff no-tests` must print ok (discard any test edit it made) and
   `gate.sh all` ok; commit `refactor(<scope>): simplify`.
2. `/code-review --fix` on the branch's changes: it applies its own
   findings. Then `gate.sh all` must print ok; commit `fix(<scope>): code
   review`. Not ok: discard its edits, which leaves the branch as green as
   step 1 did, and list the failing line in the report.
3. Any task BLOCKED: `set-track.sh status=blocked`, commit, print a stop
   report listing them, and stop. Otherwise `set-track.sh phase=prove`,
   commit `docs(foreman): implement <id> done`, and start prove in this
   session through the Skill tool, `foreman:prove`.
