# Foreman: workflow

## Commands

| Do | Run |
|---|---|
| Validate the plugin | open: `claude plugin validate` is not a subcommand in this build |
| Install locally | `/plugin marketplace add santhoshsram/foreman` then `/plugin install foreman@foreman` |
| Try a skill | open a sample repo and run `/foreman:<skill>` |
| Test | none yet |
| Lint | none yet |

## Gates

None yet. Foreman is prose and bash. A gate arrives with the first script
that has tests.

## Branches, commits, PRs

- Branch per track, `<type>/<id>`. Never commit to main.
- Conventional Commits. Scope is the skill or folder: `feat(shape)`,
  `fix(scripts)`, `docs(foreman)`.
- Stage explicit paths. Never `git add -A`.
- PR title is the squash commit subject. Body: summary, why, changes, review
  notes, tested, not in this PR, breaking change, `Closes #N`.

## Done

A track is done when its PR is merged to main, `plugin.json` and
`marketplace.json` carry the new version if a user-visible skill changed,
and the track folder is moved to `foreman/archive/`.

## Conventions

- `foreman/` is the same shape in every project. Foreman uses it on itself.
- Comments in scripts say why, never how it got there.
- Secrets never appear anywhere.
