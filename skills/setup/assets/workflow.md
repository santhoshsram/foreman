# Workflow

## Commands
| Do | Run |
|---|---|
| Build | `just build` |
| Test | `just test` |
| Test files | `just test {files}` |
| Lint | `just lint` |
| Run | `just run <args>` |
| Everything CI runs | `just ci` |

Read by `gate.sh`: a Run cell is exactly one code span, or the row is
skipped. A `|` inside a command is written `\|`.

## Test paths
`tests/*`, `*_test.go`, `*.test.ts`

Globs on repo-relative paths; `*` crosses `/`. The test-writer may write only
these, the implementer never.

## Principles
- The user's experience decides ties. The one test is in product.md.
- The tech stack is deliberate. A new dependency gets a decision line before code.
- Non-interactive, CI-aware commands. `CI=true` for watch-mode tools.

## Quality gates (per task)
- Tests red before the implementer, green after. Failure cases covered.
- Lint clean. Style guides in code_styleguides/ followed.
- User-visible change has its docs and spec change in the same task.
- No secret value in output, logs, files or tests.

## Branches, commits, PRs
- Branch per track, `<type>/<id>`. Never commit to main.
- Conventional Commits. Scopes: <from the repo>.
- Stage explicit paths.
- PR title is the squash subject. Body: summary, why, changes, review notes,
  tested, not in this PR, breaking change, Closes #N.

## Done
Merged to main. Released: <where, or "nothing to release">. Track archived.
