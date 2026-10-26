# Foreman

A light development harness for Claude Code. One routine for every project and
every feature: setup once, then per track shape, implement, prove, ship.

Project knowledge and track state live as markdown in the repo, under
`foreman/`. Stop at any phase boundary and resume in another session or on
another machine. Learnings accumulate and compound within the project.

Built on [conductor](https://github.com/gemini-cli-extensions/conductor)
(Apache 2.0), with patterns from
[elephant-goldfish-model](https://github.com/google/elephant-goldfish-model)
(Apache 2.0). Sources and the commits taken are listed in
`foreman/upstreams.md`.

## Install

```
/plugin marketplace add santhoshsram/foreman
/plugin install foreman@foreman
```

### Cloud sessions

A cloud session loads neither your user plugins nor plugins a repo declares
in `.claude/settings.json`. Install foreman from the cloud environment's
setup script instead: open the environment's settings, then **Setup
script**, and paste:

```bash
#!/bin/bash
claude plugin marketplace add santhoshsram/foreman
claude plugin install foreman@foreman
```

The environment cache keeps the install, so the script runs again only when
the cache is rebuilt. To pick up a new foreman version sooner, edit the
script, which rebuilds the cache.

## Status

0.1.0: every v0 skill and agent is built, not yet run end to end.

- Skills: setup, new-track, shape, critique, implement, prove, ship, status,
  review, revert, catch-up.
- Agents: critic, challenger, researcher, test-writer, implementer.

## Author

Santhosh Sundararaman, [github.com/santhoshsram](https://github.com/santhoshsram)
