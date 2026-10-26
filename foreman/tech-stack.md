# Foreman: tech stack

## What it is made of

- A Claude Code plugin: `.claude-plugin/plugin.json`, with a self-listing
  `marketplace.json` so the repo installs directly.
- Skills: `skills/<name>/SKILL.md`, invoked as `/foreman:<name>`.
- Agents: `agents/<name>.md`. Frontmatter pins model, tools, turn cap and
  hooks. Critic, challenger and researcher run on Opus: each weighs evidence
  into a judgment, and a wrong one costs more than the tokens. Test-writer and
  implementer run on Sonnet.
- Hooks and gates: bash scripts under `scripts/`, registered in
  `hooks/hooks.json`, because plugin agents ignore `hooks` frontmatter.
  `guard-paths.sh` runs at PreToolUse on every tool call and acts only when
  `agent_type` names a foreman worker; `gate.sh diff` runs at SubagentStop.
  Which `agent_type` a plugin agent reports, `critic` or `foreman:critic`, is
  unverified, so both match. `${CLAUDE_PLUGIN_ROOT}` expands anywhere in a
  skill's or agent's markdown body, not in frontmatter, per the plugin
  manifest reference; not yet seen in a live spawn.
- Test paths and gate commands are project data in `foreman/workflow.md`,
  so the scripts know no language.
- State: markdown and one JSON file per track under `foreman/` in each
  project repo.
- Python 3 only for a script that bash makes unreadable. None yet.

## Contested choices

- **Copy conductor, not fork.** A fork's merge is manual anyway, since most
  skill text is rewritten. `upstreams.md` records the commit taken; a later
  skill diffs from it.
- **Markdown state in the repo, not GitHub issues or a database.** It travels
  with the branch, survives session death, and works on web.
- **Workers as agents, not inline.** The split between test-writer and
  implementer is what makes red and green mean something, and each worker
  runs on a pinned model with a turn cap.
- **No spec-conformance reviewer agent.** Prove checks every criterion
  against the built thing with evidence. `/simplify` cleans and `/code-review
  --fix` fixes bugs, both automatic at the end of implement. `foreman:review` is on
  demand only, for alignment with spec, style guides and product guidelines.
- **Deterministic checks are scripts.** `scripts/state.sh` reports project
  and track state; skills read it instead of inferring. `scripts/set-track.sh`
  is the one writer of track phase, sub-step and status, and keeps the
  `tracks.md` row in step.
- **`/goal` is Claude Code's.** Implement and prove say how to run under it.
  No goal skill.

## Never added without a decision line

- A new agent.
  - critic agent: exists to pin Opus, a 3-turn cap and a Read of the one
    file it judges; a prompt alone does not hold a subagent to that.
  - challenger agent: a fresh context that never saw the shaping
    conversation, so it reads the spec as a stranger; pinned to Opus and to
    reading markdown.
  - test-writer and implementer agents: the split is what makes red and
    green mean something; each starts fresh per task, so the orchestrator
    survives a long track, and the guard tells them apart by name.
  - researcher agent: one question per fresh context keeps research a
    decision, not a topic; pinned to Opus, and writes nothing.
- A new state file under `foreman/`.
- A dependency beyond bash, python3, git and gh.

## Open

- How plugin skills are tested: `claude plugin eval` or hand runs on a sample
  repo.
