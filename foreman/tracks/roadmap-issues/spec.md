# Roadmap in GitHub issues as a setup option

## Goal

A project can keep its roadmap as GitHub issues labelled `roadmap`
instead of `foreman/roadmap.md`, chosen at setup. With markdown, every new
roadmap line costs a commit and a merged PR; with issues, it costs one
issue. `foreman/roadmap.md` stays the default. Tracks, specs and decisions
never leave the repo.

## Users and journeys

The solo developer of `product.md`, on a GitHub-hosted project.

- J1 New project. Given a project without `foreman/`, when the user runs
  `/foreman:setup`, then setup asks whether the roadmap lives in
  `foreman/roadmap.md` or in GitHub issues, and records the answer in
  `foreman/workflow.md` under `## Roadmap`.
- J2 Existing project. Given a set-up project whose `workflow.md` has no
  `## Roadmap` section, when the user runs `/foreman:setup`, then setup
  asks only the roadmap question. If the user picks GitHub issues, each
  `roadmap.md` line becomes an open issue labelled `roadmap`, and
  `roadmap.md` is deleted.
- J3 Add an item. Given a project on GitHub issues, when the user asks for
  a new roadmap item, then an issue labelled `roadmap` is opened and no
  commit is made.
- J4 Start a track. Given open issue #N, labelled `roadmap` or `bug`, when
  the user runs `/foreman:new-track #N`, then the track starts from that
  issue, the issue stays open, and the track's PR body carries
  `Closes #N`, so the merge closes it.
- J5 See the roadmap. Given a project on GitHub issues, when the user runs
  `/foreman:status all`, then the Roadmap part lists the open issues
  labelled `roadmap`.
- J6 Defer a part. Given shape on a project on GitHub issues, when the user
  wants an out-of-scope part later, then shape opens it as an issue
  labelled `roadmap`.

## Experience

open

## Acceptance criteria

open

## Contracts

open

## Alternatives considered

open

## Non-functional

open

## Reuse and untouched

open

## Out of scope

- Tracks, specs or decisions in issues.
- Listing bug issues in `/foreman:status`.
- Hosts other than GitHub.
- Switching back from issues to `roadmap.md`.
- Keeping `roadmap.md` and issues both, or syncing them.
- Milestones, project boards, assignees.
