# Rust Style Guide Summary

This document summarizes key rules from the Rust Style Guide, the Rust API
Guidelines and Clippy's defaults.

## 1. Formatting and Lints

-   **`rustfmt`:** All code is formatted with `cargo fmt`. Do not hand-format
    against it.
-   **Clippy:** `cargo clippy --all-targets -- -D warnings` is clean. Silence a
    lint only with `#[allow(...)]` on the smallest item, with a comment saying
    why.

## 2. Naming

-   **`UpperCamelCase`:** Types, traits, enum variants.
-   **`snake_case`:** Functions, methods, variables, modules, crates.
-   **`SCREAMING_SNAKE_CASE`:** Constants and statics.
-   **Conversions:** `as_` is a cheap borrow, `to_` is an expensive copy,
    `into_` consumes `self`.
-   **Getters:** No `get_` prefix. A getter for `owner` is `owner()`.

## 3. Errors

-   **`Result`:** Fallible functions return `Result`. Propagate with `?`.
-   **No `unwrap()` in library code.** Use `expect("<invariant that holds>")`
    only where the invariant is guaranteed, and say which.
-   **Error types:** A library exposes typed errors that implement
    `std::error::Error`. Binaries may wrap them at the top level.
-   **`panic!`:** Only for bugs, never for expected failures such as bad input
    or a missing file.

## 4. Ownership and Types

-   **Borrow in parameters:** Take `&str`, `&[T]` or `&Path` rather than
    `String`, `Vec<T>` or `PathBuf` unless the function stores the value.
-   **No needless `clone()`.** A clone to satisfy the borrow checker is a sign
    the ownership is wrong.
-   **Iterators:** Prefer iterator chains to index loops for transforms and
    filters.
-   **Common traits:** Public types derive `Debug`, and `Clone`, `PartialEq`,
    `Eq`, `Hash`, `Default` where they make sense.
-   **Newtypes:** Wrap primitive values that carry meaning (ids, units) in a
    newtype instead of passing bare `String` or `u64`.

## 5. Unsafe

-   **Avoid `unsafe`.** Where it is required, keep the block minimal and put a
    `// SAFETY:` comment above it stating why the invariants hold.

## 6. Documentation and Tests

-   **`///` docs:** Every public item has a doc comment. Fallible functions
    have an `# Errors` section, functions that can panic a `# Panics` section.
-   **Unit tests:** In a `#[cfg(test)] mod tests` at the bottom of the file.
    Integration tests in `tests/`.

*Sources: [Rust Style Guide](https://doc.rust-lang.org/style-guide/),
[Rust API Guidelines](https://rust-lang.github.io/api-guidelines/),
[Clippy](https://doc.rust-lang.org/clippy/)*
