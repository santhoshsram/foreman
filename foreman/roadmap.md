# Roadmap

One line per future track: its id, the line worded as its
`/foreman:new-track` description, then where the idea came from. An id is
`R<n>` and is never reused, so a removed line leaves a gap. new-track
removes the line it starts.

Next id: R13

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
- R12: Harden the guard and gates so a worker cannot slip past them. Today
  they keep honest workers in their lanes, but each check below fails open:
  - `gate.sh` keeps its base tree under `.git/`, which a worker can
    overwrite before the diff check runs.
  - `gate.sh` lists untracked files with `--exclude-standard`, so a file
    hidden by `.gitignore`, `.git/info/exclude` or `core.excludesFile`
    escapes the diff check, and a worker can add such a rule.
  - `guard-paths.sh` allows any write outside the repo, such as
    `~/.gitconfig` or the plugin's own scripts, and does not resolve
    symlinks.
  - The Bash check matches writes and `git` calls by regex and allows
    whatever it does not match: quotes, backslashes, `$(...)` and variables
    get past it.
  - A hook that exits with anything but 2, such as a crash or a missing
    script, lets the tool call through with no warning.
  Fail closed for foreman workers instead. From a 2026-10-26 security review
  of the first public commit.
