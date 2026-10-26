# Foreman: product

## Who uses it

A solo developer building several projects at once in Claude Code, terminal
and web: products, CLIs, plugins and scripts. Foreman is reached for at three moments: starting a project, starting a
feature, and coming back after days away asking "where am I".

Built for that one developer and shared as is. Generic across their
projects, not across all projects.

## The one test

Does this make the next track more repeatable without adding a step the model
would do right unprompted?

## What it refuses to be

- A factory with an agent per role. Modes are smart; roles are prose.
- A prescriptive procedure. Skills encode goals, constraints and interfaces,
  not steps.
- A system of record outside the repo. Everything is markdown on the branch.
  GitHub holds PRs only.
- A generic product. If a choice serves that developer's projects and nobody else,
  it is the right choice.

## Vocabulary

One word per concept. No synonyms.

- **project**: a repo with a `foreman/` folder.
- **track**: one feature or fix, one branch, one PR, one folder under
  `foreman/tracks/`.
- **phase**: setup, new-track, shape, implement, prove, ship. A track is
  always in exactly one.
- **sub-step**: user, ux, eng. The parts of shape. Resume points.
- **question**: one line in `decisions.md`. Tagged user, ux or eng.
- **decision**: a settled question. Has evidence.
- **evidence**: a path or section ref on a decision line, or a one-screen
  file under `research/`.
- **spec**: what and why for one feature. Never how.
- **plan**: the tasks implement runs, with gates.
- **gate**: a script check that a worker's output must pass: red, green,
  diff tests-only, diff no-tests.
- **orchestrator**: the session running a skill. Writes no code and no tests.
- **worker**: a fresh-context agent doing one job: critic, challenger,
  researcher, test-writer, implementer.
- **proof**: evidence per acceptance criterion, produced by the orchestrator.
- **learning**: one line in `learnings.md`.
- **roadmap**: `roadmap.md`, one line per future track.
- **upstream**: a repo foreman copied material from.
- **guideline**: the autonomy rules that decide when a worker stops.

## Open

- Whether foreman ever serves a second person. Decided no for now.
