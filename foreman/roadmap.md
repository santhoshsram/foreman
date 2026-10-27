# Roadmap

One line per future track: its id, the line worded as its
`/foreman:new-track` description, then where the idea came from. An id is
`R<n>` and is never reused, so a removed line leaves a gap. new-track
removes the line it starts.

Next id: R14

- R1: Multi-session planning above tracks: a map of decision tickets resolved
  one per session. From Matt Pocock's `wayfinder` skill,
  https://github.com/mattpocock/skills
- R2: Research skill: settle one question outside a track with the
  researcher agent, saved as a one-screen file headed by its decision. Today
  research runs only inside shape, against one `decisions.md` line.
  Deferred from iteration 1.
- R3: Security review of a track's diff before ship: supply-chain risk in
  new dependencies, secrets, and common appsec flaws, each finding settled
  like a review fix. Deferred from iteration 1.
- R4: Drift report: compare the code with the archived specs and the
  project files, and list each place they disagree. From the
  `egm_drift_report` skill in https://github.com/google/elephant-goldfish-model
- R5: Resolve: in the session that wrote a file, take the findings of
  several reviewers at once, defend what is right, apply the fixes the user
  picks, and negotiate the rest with them. Shape and critique each do a
  narrower version today. From the `egm_resolve` skill in
  https://github.com/google/elephant-goldfish-model
- R6: Upstream-diff skill: diff each upstream from the commit taken. From
  `foreman/upstreams.md`.
- R7: Gate modes `ask | notify | auto`, flipped one at a time as trust grows.
  Deferred from iteration 1.
- R9: Self-improve skill in this repo's `.claude/skills/`, not shipped:
  reads every Claude Code transcript, foreman or not, and proposes
  `harness` lines for `foreman/learnings.md` and lines for this roadmap,
  each accepted by the user. A checkpoint per transcript records the last
  message read, so a continued conversation is read from there on. It
  extracts user corrections and tool errors, never secrets. From a
  2026-10-26 session on a cold-read agent seen outside foreman.
- R10: Make phase switches visible: a skill that hands off to the next
  phase first says its own phase is done, then asks the user whether to
  start the next one, for example new-track before shape. From a 2026-10-26
  session in focus mode, where new-track's hand-off to shape went unseen.
- R13: Sandbox foreman workers, so a worker that writes code to defeat the
  guard and gate is still contained. The guard and gate are guardrails for
  honest workers: the test command runs the worker's own code, which can
  overwrite the gate's "before" snapshot, write outside the repo, or hide a
  file behind an ignore line, and the guard misreads Bash such as
  `cp a "$f"`. Start from Claude Code's sandbox mode for Bash. From a
  2026-10-26 security review of the first public commit; hardening the
  guard and gate in bash instead (R12) was dropped on 2026-10-27 as
  over-engineering for a solo-developer harness.
