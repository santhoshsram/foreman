# Plan: <title>

Spec: `spec.md`. Tasks run in order; a task runs once its deps are done.

## Tasks

- [ ] 01 <type>(<scope>): <title> | AC: AC1, AC2 | deps: none
- [ ] 02 <type>(<scope>): <title> | AC: AC3 | deps: 01

## 01 <type>(<scope>): <title>

### Goal
<One paragraph: what the user can now do or see.>
Spec: §<section>, AC<n>

### Context
- Read first: <paths, spec sections>
- Mirror: <one path whose pattern to follow>

### Contract
<Signatures, or CLI command, flags, exit codes.>
<Exact output block or JSON shape, copied from the spec verbatim.>
Pin only what tests touch.
Free choice: <everything else>

### Behaviour
- B1 <the system> shall <y> -> <test_name>
- B2 When <x>, <the system> shall <y> -> <test_name>

### Tests
- File: <one test file> (test-writer owns; implementer never edits)
- Invariants: <e.g. no secret value in stdout, stderr or logs>

### Files
- <source files expected to change; guidance, not a gate>

### Out of scope
- <what this task must not do>
