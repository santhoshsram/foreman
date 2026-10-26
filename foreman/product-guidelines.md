# Foreman: guidelines

## How skill and agent text is written

- Encode goals, done conditions, hard constraints with their why, parsed
  interfaces (file formats, hand-back blocks), known traps.
- Leave out general competence and step-by-step procedure. Test: delete the
  line; if the model still does it right, cut it. Do not cut a useful line to
  hit a length.
- Every line earns its place. Each word costs the reader's attention.
- One term per concept, from `product.md`. No synonyms.
- Say the number. "3 of 40 tests fail", not "some tests fail".
- No mentoring prose, no "explain the strategic value", no repeated
  operational standards per skill. One copy of a rule, read by path.
- No `(Recommended)` prefixes in options. Put the recommended option first
  and say why in one clause.
- Plain hyphens. No em or en dashes.

## How project files are written

- Questions are the output shape, not the interview. Ask for the story,
  draft, iterate, write what is settled, mark what is not.
- Rough answers are written rough and marked open. Tracks sharpen them.
- A project file holds what is true of the project. A track file holds what is
  true of one feature. Nothing lives in both.

## What the user never has to do

- Repeat a project fact already in `foreman/`.
- Read a report to find a decision. The decision is the first line.
- Answer a question cold that needs a draft to react to.
- Remember where a track stands. `metadata.json` and `/status` do.

## What must never happen

- The orchestrator writes source or tests, except `/simplify` and
  `/code-review --fix` at implement close. Workers do.
- The implementer edits a test path. The test-writer edits a non-test path.
  Hooks enforce both.
- A worker's claim counts as proof.
- Implement edits the spec. A spec gap stops the run and goes back to shape.
- Git state mutations run in parallel. Chain them in one script.
- Pushing to main. Every track lands by PR.
- A secret value appears in output, logs, files or tests.
- Track state that exists only in a session. Every sub-step ends with a
  commit.
- A skill pushes, opens a PR or merges unasked. Those are the user's.
