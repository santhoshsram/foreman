# A filled task

From a Rust CLI. Shows the density: the Contract is the spec's output byte
for byte, every Behaviour line names its test, Out of scope names the
neighbours this task must leave alone.

````markdown
## 03 feat(cli): todo list prints the canned task table

### Goal
`todo list` prints the spec's task table from canned data, followed by the
summary footer. Nothing is read from or written to disk.
Spec: §Contracts `todo list`, AC2, AC5

### Context
- Read first: spec §Contracts `todo list`, §Experience
- Mirror: crates/todo/src/commands/add.rs (task 02)

### Contract
Command: `todo list`. No arguments. Exit code 0. stderr empty.
stdout when not a TTY, byte for byte (first line is empty):
```

ID  TITLE                DUE          DONE
1   Renew passport       2026-11-02   no
2   Book dentist         -            yes
3   Pay electricity      2026-10-30   no

(3 tasks, 1 done)
```
Pin only what tests touch.
Free choice: canned data location, row type, table helper internals, colour
codes when stdout is a TTY.

### Behaviour
- B1 `todo list` shall print the Contract stdout block and exit 0 -> todo_list_prints_spec_table
- B2 When stdout is not a TTY, `todo list` shall emit no ANSI escape sequences -> todo_list_has_no_ansi_off_tty
- B3 `todo list` shall create no file under HOME -> todo_list_writes_nothing

### Tests
- File: crates/todo/tests/it/list.rs (test-writer owns; implementer never edits)
- Invariants: run with HOME set to an empty temp dir; it stays empty

### Files
- crates/todo/src/commands/list.rs
- crates/todo/src/canned.rs

### Out of scope
- `--json` output: the spec defines no shape for it yet
- `todo show` and other subcommands
````
