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
| user | How roadmap issues are labelled | settled | `roadmap` only. A roadmap item is an enhancement or a large chunk of work; bugs are not roadmap | user: "bugs dont need roadmap label. roadmap is only for enhancements and large chunks for work"; user: "roadmap only" |
| user | What foreman does with bug issues | settled | `/foreman:new-track #N` takes a bug issue as it takes a roadmap issue; `/foreman:status all` lists the roadmap only | user: "Start tracks, unlisted" |
| user | What happens to roadmap issue #N when a track starts from it | settled | The issue stays open; the track's PR body carries `Closes #N`, so the merge closes it | user: "Close on merge"; `workflow.md#branches-commits-prs` |
| user | Is switching an existing project's roadmap.md to issues in this track | settled | In scope: each roadmap.md line becomes an issue, then roadmap.md is deleted | user: "In scope" |
| user | When setup offers the GitHub-issues choice | settled | Always asked, whatever the remote | user: "Always ask" |
| user | How an existing project, already set up, starts the switch | settled | On a set-up project with no roadmap choice recorded, `/foreman:setup` asks only the roadmap question, then migrates if issues is picked. No new skill | user: "Setup asks if unrecorded"; `skills/setup/SKILL.md#state` |
| ux | What happens when the user picks GitHub issues but origin is not on GitHub or `gh` is not authenticated | settled | Setup names the failure and its fix, such as `gh auth login`, then offers `foreman/roadmap.md` as the fallback. No choice is recorded unless the user takes one | user: "Stop say the fix. and present roadmap as fall back if gh does not work" |
| ux | Does `/foreman:new-track #N` accept an open issue with neither `roadmap` nor `bug` label | settled | Yes: any open issue starts a track; a closed or missing issue stops new-track | user: "yes"; spec §Experience |
| ux | Exact setup output when gh fails: the failure, the fix, the fallback offer | settled | As in the spec; a non-GitHub origin leaves out the fix line | user: "Approve as written"; spec §Experience |
| user | The smallest version that passes the one test | settled | Setup choice recorded in `workflow.md`; setup asks it alone on a set-up project with no choice; migration of roadmap.md lines to `roadmap` issues; adding an item is an issue; new-track takes `#N`; status all lists open `roadmap` issues; shape files out-of-scope parts as `roadmap` issues | user: "Accept"; spec §Goal |
| user | What is out | settled | Tracks, specs, decisions in issues; listing bugs in status; hosts other than GitHub; switching back; keeping or syncing both; milestones, project boards, assignees | user: "Accept"; spec §Out of scope |
| user | How product.md's vocabulary line "roadmap: `roadmap.md`, one line per future track" is reworded | settled | "roadmap: the future tracks, one line each in `roadmap.md` or one open issue labelled `roadmap` each, as `workflow.md` records." | user: "Use the draft" |
| user | Does a GitHub issue need a vocabulary word, apart from roadmap | settled | No new word; "GitHub issue" is used plain | user: "No new word" |
| user | How product.md's refusal "A system of record outside the repo. GitHub holds PRs only" changes | settled | Roadmap-only exception: GitHub holds PRs, and roadmap issues when setup chose them. Tracks never leave the repo. Markdown in the repo stays the default | `product.md#what-it-refuses-to-be`; user: "The default is still markdown in the repo. But use can choose to use gh" |
| ux | First thing seen, done, seen after | settled | Seen: setup's roadmap question. Done: the choice recorded, and the lines moved if issues. After: the migration summary; later, issue numbers in status and new-track | user: "Approve as written"; spec §Experience |
| ux | Title and body of an issue migrated from a roadmap.md line: is the `R<n>` id kept | settled | Dropped. Title is the line's first sentence, body the rest; issue #N replaces the R id | user: "Dropped" |
| ux | Where a new track's description comes from when it starts from issue #N | settled | New-track reads the issue's title and its description (the issue body), together, as the track description | user: "it shoudl read title and description" |
| ux | Nearest existing screen or command | settled | Setup's own questions, `/foreman:new-track R<n>`, the Roadmap part of `/foreman:status all` | user: "Approve as written"; spec §Experience |
| ux | States: empty, loading, error, done | settled | Empty: `Roadmap: none`. Loading: none, gh calls are short. Error: the gh failure plus its fix; a closed or missing issue stops new-track. Done: the migration summary, the `Opened #N` line | user: "Approve as written"; spec §Experience |
| ux | Mockup or exact output | settled | The exact output in the spec is the mockup | user: "Approve as written"; spec §Experience |
| eng | Options, the winner, and what flips it | open | | |
| eng | Contracts that change: CLI output, API, schema, file format | open | | |
| eng | Where the roadmap choice is recorded: `workflow.md` or elsewhere | settled | A `## Roadmap` section in `workflow.md`: `foreman/roadmap.md`, or GitHub issues labelled `roadmap` with the `gh issue list --label roadmap` command. roadmap.md is deleted on switch | user: "workflow.md row" |
| eng | How tech-stack.md's contested choice "Markdown state in the repo, not GitHub issues" changes | open | | `tech-stack.md#contested-choices` |
| eng | Who creates the `roadmap` label when the repo lacks it | open | | |
| eng | Order of migration: issues are created before the setup branch that deletes roadmap.md merges | open | | |
| eng | What `state.sh` reports for `roadmap.md` once issues hold the roadmap | open | | `scripts/state.sh` |
| eng | What is reused | open | | |
| eng | What stays untouched | open | | |
