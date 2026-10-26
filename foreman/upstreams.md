# Upstreams

Repos foreman copied material from. Each entry records the commit taken and
what was taken, so a later diff from that commit shows what changed upstream
and whether it touches anything here. Bump the commit only after reviewing
the diff.

## conductor

- Repo: https://github.com/gemini-cli-extensions/conductor
- License: Apache 2.0, Google LLC
- Commit taken: `6e8f9a860bcdd6a2c423473c12e745200688c633` (2026-09-01, version 0.3.0)
- Taken: `LICENSE`. The `foreman/` folder shape and file names: `index.md`,
  `product.md`, `product-guidelines.md`, `tech-stack.md`, `workflow.md`,
  `tracks.md`, `tracks/<id>/{spec,plan,metadata,index}`, `archive/`.
  Skill `setup`, rewritten per the review verdicts; `resume.py` became
  `scripts/state.sh`. Skill `new-track`: id, collision check, metadata,
  track index, registry and commit; the spec interview moved to shape, plan
  generation to implement; worktree added. `code_styleguides/`
  `python.md`, `typescript.md`, `go.md`, `html-css.md` verbatim;
  `general.md` trimmed to two rules.
  Skill `implement`: the name, track resume, checkbox per task; the body
  is foreman's own. Project-file sync from `implement` and the archive step
  from `review`, both moved into the added skill `ship`.
  Skill `status`: reads `metadata.json` on this branch instead of the
  registry on main.
  Skill `review`: scope detection, style guides as law, running the tests,
  the findings format, fixes tracked as Review Fixes.
  Skill `revert`: target confirmation, commit list before acting, `git
  revert` newest first, commits found by the SHA in `plan.md`; hard reset
  dropped.
- Not taken: skill catalog and detection signals, Antigravity rules, the
  440-line `workflow.md` template beyond four sections.

## elephant-goldfish-model

- Repo: https://github.com/google/elephant-goldfish-model
- License: Apache 2.0, Google LLC
- Commit taken: `d651fe86c12dccc5272274e002674fb8eec4c547` (2026-10-23)
- Taken: patterns only, no files. Brainstorm shape (hypothesis, then lens
  critique), Given/When/Then journeys, Alternatives Considered with reason
  rejected, naive-reader check, CONTEST or FIX triage.
- Not taken: every skill, per-section gates, one question per turn,
  zero-decision plan, banned-word lists, README contracts, harness shims.
