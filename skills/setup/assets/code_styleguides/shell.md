# Shell Style Guide Summary

This document summarizes key rules from the Google Shell Style Guide, plus
ShellCheck.

## 1. When to Use Shell

-   **Bash only.** Executables start with `#!/usr/bin/env bash`.
-   **Small tools only.** Past about 100 lines, or once it needs data
    structures beyond arrays, consider another language.
-   **Target the bash that runs it.** macOS ships bash 3.2: no associative
    arrays, `mapfile` or `${var,,}` in scripts that run there.

## 2. Safety

-   **`set -euo pipefail`** at the top of every script.
-   **ShellCheck clean.** Disable a check only on the line that needs it, with
    a comment saying why.
-   **Quote every expansion:** `"$var"`, `"$(cmd)"`, `"${arr[@]}"`.
-   **Temp files:** Create with `mktemp`, remove with a `trap ... EXIT`.
-   **No `eval`.**
-   **Errors go to stderr:** `echo "msg" >&2`. Exit non-zero on failure.

## 3. Syntax

-   **Tests:** `[[ ... ]]`, not `[ ... ]` or `test`.
-   **Command substitution:** `$(...)`, never backticks.
-   **Arithmetic:** `(( ... ))` and `$(( ... ))`, never `let` or `expr`.
-   **Builtins over external commands** where one exists, such as parameter
    expansion over `sed` for simple string edits.
-   **Do not parse `ls`.** Use globs or `find`.

## 4. Formatting

-   **Indentation:** 2 spaces. No tabs.
-   **Line length:** Maximum 80 characters.
-   **Pipelines:** One per line when they do not fit, with the pipe at the
    start of each continuation line.
-   **`then` and `do`** on the same line as `if`, `for` and `while`.

## 5. Naming and Structure

-   **Functions and variables:** `lower_case_with_underscores`.
-   **Constants and exported variables:** `UPPER_CASE`, declared at the top.
-   **`local`** for every function variable.
-   **`main`:** Scripts with more than a few functions put the logic in `main`
    and end with `main "$@"`.
-   **Header comment:** What the script does and its usage line.

*Source: [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html),
[ShellCheck](https://www.shellcheck.net/)*
