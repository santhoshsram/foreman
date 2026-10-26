# Learnings

Append-only. One line per surprise. The note is a tag, not a description.
Types: pitfall, pattern, decision, harness. Harness lines are what we read
when tuning foreman.

```
date | track | phase | type | note | pointer
```

2026-10-23 | - | setup | harness | Research briefed as a topic becomes an encyclopedia; brief it as a decision | agents/researcher.md
2026-10-23 | - | setup | harness | Decisions need a home before research starts, or they land in the research doc | skills/shape/SKILL.md#sub-steps
2026-10-23 | - | setup | harness | Setup questions are the output shape, not the interview; ask for the story first | skills/setup/SKILL.md#story-first
2026-10-23 | - | shape | decision | Spec sections split by sub-step; acceptance criteria grown by all three, each naming its proof kind | skills/shape/SKILL.md
2026-10-23 | - | shape | decision | Challenger findings are decisions.md lines tagged by sub-step; FIX applied by shape, CONTEST settled by the user; three rounds, then parked | skills/shape/SKILL.md
2026-10-23 | - | prove | decision | Prove runs once per track, at the end of implement; no per-phase prove | skills/prove/SKILL.md
2026-10-23 | - | review | decision | foreman:review keeps the style guides; /code-review is not fed them | skills/review/SKILL.md
2026-10-23 | - | new-track | decision | No skill pushes, opens a PR or merges unasked; commit is the skill's, the rest the user's | guideline.md#git-boundary
2026-10-24 | - | review | decision | Review sends accepted fixes to the implementer under the gates; only implement close applies /code-review --fix in place | skills/review/SKILL.md
