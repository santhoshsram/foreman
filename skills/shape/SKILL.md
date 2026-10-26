---
name: shape
description: Shape a track's spec with the user, sub-step by sub-step (user, ux, eng), settling its questions in decisions.md, then let the challenger attack it. Interactive. Use for "/foreman:shape", "continue shaping", or when new-track hands off. Resumes at the open sub-step.
---

# Shape

Goal: a spec that says what and why for one feature, never how, that a
reader with only that file builds right. Done when every `spec.md` section is
filled or says `none: <why>`, every `decisions.md` line is settled or parked,
the challenger finds nothing, and the user says the spec is done.

`${CLAUDE_PLUGIN_ROOT}/guideline.md` governs questions and stops. Read it
first. Shape is the interactive phase: here the user is asked, not stopped
for.

## State

- Run `${CLAUDE_PLUGIN_ROOT}/scripts/state.sh`. No track, or `phase` not
  `shape`: say where the track is and stop.
- Read the track's `decisions.md` and `spec.md`, and the project files
  `foreman/index.md` lists. Never re-ask what they settle.
- Resume at the open line that comes first, in sub-step order user, ux, eng.
  An open line before the current `sub_step` was reopened, by implement on a
  spec gap or by the challenger, and is settled before going on.

## Sub-steps

A sub-step with nothing to ask for this track, such as ux for an internal
refactor, is skipped: its lines settled `nothing to ask: <why>`, its
sections `none: <why>`.

| Sub-step | Fills |
|---|---|
| user | Goal. Users and journeys, each journey Given/When/Then. Out of scope |
| ux | Experience: first thing seen, done, seen after; states (empty, loading, error, done); the nearest existing screen, or the exact output for a CLI; `mockup.html` when one exists |
| eng | Contracts, exact: CLI output verbatim, API, schema, file format. Alternatives considered, each with the reason rejected. Non-functional, when any. Reuse and untouched |

- Acceptance criteria is one section, grown by all three. One line per
  criterion: `AC<n>: <when, then>. Proof: <test | command output |
  screenshot | video>`. Never a test name: implement picks those. Plan
  tasks and `proof.md` cite the `AC<n>` ids, so an id is never reused.
- Eng settles what crosses a boundary and which approach wins. Everything
  behind the boundary is implement's.
- No status prose and no milestones in the spec.
- Settle each `decisions.md` line as it is answered: decision, plus evidence
  (the user's words, a file section, `spec §<section>`). A question only
  research can settle gets one `foreman:researcher` agent with that line
  alone. Save its file text as `research/<slug>.md` and settle the line with
  that path; a user or ux decision is confirmed with the user first. A line the user wants to leave is parked with why.
- After each answer, add an open line for each thing a builder with only
  the spec would have to guess.
- A word in an answer that conflicts with the vocabulary in `product.md`:
  ask which is meant before settling the line.
- An out-of-scope part the user still wants later becomes a line in
  `foreman/roadmap.md`, under its next id, which then goes up by one.
- A UI track that needs a mockup gets `mockup.html` in the track folder:
  self-contained, a state switcher, built from root `DESIGN.md` tokens and
  the nearest screens; a missing token or screen is flagged, never invented.
  The user approves it before the Experience section is written from it. For
  a CLI, the exact output in the spec is the mockup.

## Checkpoints

After every sub-step: `${CLAUDE_PLUGIN_ROOT}/scripts/set-track.sh
sub_step=<next>`, commit `docs(foreman): shape <id> <sub-step>` staging the
track folder, `foreman/tracks.md` and `foreman/roadmap.md`. A web session
resumes from the last pushed checkpoint. Ship squashes these.

After user: offer `/foreman:critique foreman/tracks/<id>/spec.md`.

## Challenger

After eng, spawn one `foreman:challenger` agent. The prompt holds the paths
to `spec.md`, `decisions.md` and `foreman/index.md`, nothing else.

- Each finding becomes a `decisions.md` line: the tag of the sub-step it
  hits, question `challenger r<round> <FIX|CONTEST> §<section>: <what
  breaks>`, status open. The round in the question is how a resumed session
  counts rounds.
- FIX: edit the spec, settle the line with `spec §<section>`.
- CONTEST: show all of them to the user as one list. The user decides each;
  settle it with their words.
- Commit the round, then rerun with a fresh agent until a round
  finds nothing. After round 3, park what is left.

## Close

Ask whether the spec is done. On yes: `set-track.sh phase=implement
sub_step=`, commit `docs(foreman): shape <id> done`, and print the next
steps for the user, who alone can switch model and mode: the block in
`${CLAUDE_PLUGIN_ROOT}/skills/shape/assets/run-unattended.md`, verbatim.
