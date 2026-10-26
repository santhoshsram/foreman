---
name: review
description: On-demand alignment review of a change against the project's style guides, product guidelines and, for a track, its spec. Not a bug hunt: that is /code-review. Fixes the user accepts are tracked as Review Fixes in plan.md. Use for "/foreman:review [scope]", "review this against the style guides", or for hand-written changes, someone else's PR, or a pre-foreman branch.
argument-hint: "[uncommitted | <branch> | <PR number> | <path>]"
---

# Review

Goal: every place the change breaks a style guide, a product guideline or
its spec, found and handled. Done when each finding is fixed, rejected by the
user, or left for the user, and the report says which.

`${CLAUDE_PLUGIN_ROOT}/guideline.md` governs questions and stops. Read it
first. Bugs, races and security are `/code-review`'s; report none here.

## Scope

`$ARGUMENTS`: `uncommitted`, a branch (its diff from the merge base with
main), a PR number (`gh pr diff`), or a path. None: the track on this branch,
its commits from the merge base with main, else uncommitted changes. Track
files under `foreman/` are out of the diff.

## Law

- `foreman/code_styleguides/*.md`: a violation is High. Cite the guide and
  rule.
- `foreman/product-guidelines.md`: voice, banned words, must-nevers. A
  must-never is High; the rest Medium.
- A track's `spec.md` and `plan.md`: behaviour that differs from the spec,
  or a task the diff does not do, is High. Out-of-scope work is Medium.

## Read

When the change is checked out here, run
`${CLAUDE_PLUGIN_ROOT}/scripts/gate.sh all` and report its line.

## Findings

One block per finding, most severe first:

```
<High|Medium|Low> <file>:<lines> <rule, cited: guide §, guideline line, spec §>
<what breaks the rule, one line>
<the fix, as a short diff or one line>
```

Then ask which to fix. Someone else's PR: the report is the output; never
push to their branch.

## Fixes

Never written by you. Each accepted fix goes to a `foreman:implementer`
with `Gap: <finding>` as its task, under the gates as implement runs them.
Run `${CLAUDE_PLUGIN_ROOT}/scripts/gate.sh base` right before each spawn:
the implementer's stop hook diffs against the tree it records.

- In a track: append `## Review Fixes` to `plan.md` with one line per fix,
  `- [ ] R<n> <type>(<scope>): <finding> | file: <path>`. Each fix gets
  implement's two commits: the code, then `plan.md` with its box checked
  and the code commit's short SHA appended.
- No track: commit each fix with the finding as the subject, after asking.
