# Proof: <title>

Built at `<short sha>`. Commands that touch `$HOME` ran with HOME set to a
fresh temp dir.
Media live under `proof/`, which git ignores: each line says what its file
shows, so the line stands without it.

| AC | Proof | Evidence | Result |
|---|---|---|---|
| AC1 | test | `<command>`: `<the pass line>` | pass |
| AC2 | command output | `<command>` printed the spec §Contracts block byte for byte; full output `proof/ac2.txt` | pass |
| AC3 | screenshot | `proof/ac3-empty.png`: <what the screen shows that the criterion asks for> | pass |
| AC4 | video | see Manual | manual |

## Manual

For the user to run; prove could not.

- AC4: <steps>. Holds when <what to look for>. Not run here because <why>.

## Adversarial

- <case tried, against which AC> -> held
- <case tried> -> broke: filed as task <Pn> in `plan.md`
