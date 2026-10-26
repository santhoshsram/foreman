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

## Status

0.1.0: every v0 skill and agent is built, not yet run end to end.

- Skills: setup, new-track, shape, critique, implement, prove, ship, status,
  review, revert, catch-up.
- Agents: critic, challenger, researcher, test-writer, implementer.

## Author

Santhosh Sundararaman, [github.com/santhoshsram](https://github.com/santhoshsram)
