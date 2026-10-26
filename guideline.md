# Guideline

The autonomy rules: whether a choice is yours to make or the user's. Every
skill and worker reads this file by path; it is never copied. A stop should
be a question only the user can answer, never one you could have settled.

## Stop or proceed

Check in this order. The first rule that fires decides.

1. Carve-outs stop, however sure you are:
   - Scope creep: the right fix touches something outside the spec, such as
     another feature, a shared contract or an unrelated module. Growing a
     track is a product call.
   - A new dependency, or anything else the project's `tech-stack.md` lists
     under "never added without a decision line". Reusing a dependency already
     present is an ordinary HOW choice.
2. WHAT stops. A question about what to build that the spec does not settle:
   user-facing behaviour, a state, an output, what an empty list shows.
   Implement never fills a spec gap; it stops and the track goes back to shape.
3. HOW proceeds, unless high stakes and low confidence both hold after a search.
   - Stakes first. Reversible and contained (a loop, a private helper, an
     internal name): decide, no search, never stop.
   - High stakes means irreversible or wide blast radius: schema, file format,
     public contract, data on disk. Search the codebase's own patterns, then
     the web.
   - Low confidence means the search left no clear answer, or two equal
     options. Uncertainty that has not survived a search never justifies a stop.

| HOW | Clear answer | No clear answer |
|---|---|---|
| Low stakes | Proceed | Proceed, pick one, mark `review:` |
| High stakes | Proceed, mark `review:` | Stop |

Tie-break: on the fence between stop and proceed, stop. This loosens toward
proceed as decisions prove reliable.

| Situation | Class | Action |
|---|---|---|
| Spec does not say what invalid input does, or what a screen shows when empty | WHAT | Stop |
| Which data structure holds a list | HOW, low stakes | Proceed |
| Irreversible schema with a clear best practice | HOW, high stakes, clear | Proceed, `review:` |
| Same schema, two equal options after search | HOW, high stakes, unclear | Stop |
| The clean fix changes a contract another service depends on | Scope creep | Stop |
| Adding a validation library | New dependency | Stop |

## Log every decision

Every decision this file governs is logged. Minor ones in a few words.
Consequential ones (contract, data, security, reading of the spec) carry
enough that the user could overturn them.

- In a track: a settled question in `decisions.md`, tagged user, ux or eng.
- Mark `review:` at the start of the decision where the table says so. Ship
  lists every `review:` decision under Review notes in the PR body.
- Outside a track: list them in the final report.

## Stop report

```
Stopped: <phase, sub-step or task>
Decision needed: <one or two lines>
Why not decided: <carve-out | WHAT | high-stakes HOW, unclear after search: what was searched>
Options:
- <option, recommended first, why in one clause>
- <option>
On answer: <what runs next>
```

The question also goes into `decisions.md` as open and is committed, so a
later session resumes from it. A worker never asks the user; the stop
report goes in its hand-back.

## Asking the user

- Batch only short-answer questions (yes, no, pick one), at most four,
  through `AskUserQuestion`. A question whose answer depends on another open
  question waits for the next batch.
- A question that needs discussion is asked alone and resolved before the next.
- Recommended option first, why in one clause. No `(Recommended)` label.
- When referring to a question or its answer, quote the question's words,
  never only its number.
- A file you wrote is read in the editor, not in chat. Give its path and a
  one-line summary, then ask what to change. On later rounds say what
  changed, one line per edit.

## Git boundary

Commit your own work without asking. Push, open a PR or merge only when the
user asks in this session. Where a push matters (a track start, a
checkpoint, ship), remind the user to push in one line and go on.

## Errors

Escalate instead of working around. No band-aid fix to get past a failing
step. A failed command or tool call: diagnose and retry once. A second failure
stops with a stop report.
