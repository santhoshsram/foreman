---
name: catch-up
description: Bring this session up to speed on the project after a gap, before work outside a foreman skill. Reads the project files foreman/index.md lists, the track on this branch and recent commits, then replies with a short briefing. Changes nothing. Use for "/foreman:catch-up", "catch up", "bring yourself up to speed", or "where were we".
---

# Catch up

Goal: this session knows the project as its foreman files describe it, and
the user sees what changed since. Done when the briefing is out. Changes
nothing.

## Read

- `${CLAUDE_PLUGIN_ROOT}/scripts/state.sh`. `setup_complete` false: say
  setup has not run, and stop.
- Every file `foreman/index.md` lists, in its order.
- The track on this branch, when there is one: `spec.md`, `decisions.md`,
  `plan.md`, `proof.md`.
- `git log --oneline -20`, and off the default branch, `git diff --stat`
  from its merge base.

No source: the foreman files say what the project is, and a large repo
fills the context before the briefing.

## Reply

The user knows the project. Under about 200 words:

- **Branch**: its name, and what it adds over the default branch in one
  line.
- **Track**: id, phase, the next command as `/foreman:status` gives it, and
  the first open question in `decisions.md`. None: say so.
- **Since**: commits no foreman skill made. A skill's commit subject has a
  `(foreman)` scope, is a task heading from `plan.md`, is implement's
  `refactor(<scope>): simplify` or `fix(<scope>): code review`, or reverts
  one of those. Any other is hand work the foreman files may not reflect.
- **Missing**: files `foreman/index.md` lists that do not exist.

End by asking what to start on.
