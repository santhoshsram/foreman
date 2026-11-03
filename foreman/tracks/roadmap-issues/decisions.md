# Decisions: Roadmap in GitHub issues as a setup option

One line per question, tagged user, ux or eng. Status is open, settled or
parked. A settled line has its decision and its evidence: a file section,
`research/<slug>.md`, `spec §<section>`, or the user's words. A decision
starting `review:` is listed under Review notes in the PR. A `|` inside a
cell is written `\|`.

| tag | question | status | decision | evidence |
|---|---|---|---|---|
| user | Who uses this, and what are they trying to do | settled | The solo developer, choosing at setup where a project's roadmap lives | `product.md#who-uses-it`; user: "during foreman setup ask user if they want to use roadmap.md or github issues" |
| user | What do they do today instead | settled | Edit `foreman/roadmap.md`, which costs a commit and a PR merge per roadmap line | `roadmap.md`; user: "maintaining roadmap in repo as markdown requires a commit and pr merge for each new roadmap item. seems heavy weight" |
| user | The smallest version that passes the one test | open | | |
| user | What is out | open | | |
| user | How product.md's refusal "A system of record outside the repo. GitHub holds PRs only" changes | open | | `product.md#what-it-refuses-to-be` |
| ux | First thing seen, done, seen after | open | | |
| ux | Nearest existing screen or command | open | | |
| ux | States: empty, loading, error, done | open | | |
| ux | Mockup or exact output | open | | |
| eng | Options, the winner, and what flips it | open | | |
| eng | Contracts that change: CLI output, API, schema, file format | open | | |
| eng | Where the roadmap choice is recorded: `workflow.md` or elsewhere | open | | user: "This should be saved in workflows.md or whichever is the right place" |
| eng | How tech-stack.md's contested choice "Markdown state in the repo, not GitHub issues" changes | open | | `tech-stack.md#contested-choices` |
| eng | What is reused | open | | |
| eng | What stays untouched | open | | |
