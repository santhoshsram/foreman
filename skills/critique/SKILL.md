---
name: critique
description: Lens critique of one foreman file, such as foreman/product.md or a track's spec.md. Parallel subagents each read the file through one lens and report what breaks and what is missing; the user accepts, rejects or files each finding open. Use for "/foreman:critique [file]", "critique product.md", or "attack this spec".
argument-hint: "[file] [what it describes]"
---

# Critique

Goal: one file attacked from 2 to 4 lenses, every finding applied, rejected,
or filed open. Done when no finding is left unhandled and the result is
committed.

`${CLAUDE_PLUGIN_ROOT}/guideline.md` governs questions and stops. Read it
first.

## Input

`$ARGUMENTS`: a file path, default `foreman/product.md`, then optionally one
sentence on what the file claims to describe. `product.md` describes the
product; a `spec.md` describes one feature. Any other file without that
sentence: ask for it.

## Lenses

Chosen from `foreman/product.md`, not invented, so two runs on the same file
attack it the same way:

1. A first-time reader with no context. Always.
2. The refusals in `product.md`: where the file drifts into what the project
   refuses to be. When `product.md` has refusals.
3. One per user `product.md` names, in the order named, until there are four
   lenses.

## Subagents

First record the file, `${CLAUDE_PLUGIN_ROOT}/scripts/guard-paths.sh
critic-file <path>`: the guard lets critics read that file only. Then one
`foreman:critic` agent per lens, all in parallel. The prompt holds the lens,
the one-sentence description and the file's path, nothing else.

## Findings

- One line per finding, with its lens.
- A finding only the user can settle, not settled now, is filed open: under
  `## Open` in that file, or as an open question in the track's
  `decisions.md` when the file is a spec.
- Commit on the current branch, never main, as
  `docs(foreman): critique of <file>`. Stage that file and `decisions.md`
  only. On main, leave the edits uncommitted and say so.
