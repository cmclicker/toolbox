# Checklist: reviewing a pull request

> Walk this when reviewing someone else's PR (or self-reviewing before marking ready). Each item is yes/no. Authoring side: [../../references/github/pull-requests.md](../../references/github/pull-requests.md).

## Understand it first

- [ ] The description explains *why*, not just what; if it doesn't, ask before reviewing line-by-line.
- [ ] The change is in scope — it does the one thing the PR claims, with no unrelated drive-by edits.
- [ ] It's a reviewable size; if it's huge, ask to split rather than rubber-stamping.

## Correctness

- [ ] The logic does what the description says; edge cases and error paths considered.
- [ ] Tests cover the new/changed behavior and actually assert the contract (not just that code runs).
- [ ] CI is green — and the required checks are the ones that matter, not skipped.
- [ ] No debug output, commented-out code, or leftover TODOs without context.

## Safety

- [ ] No secrets, credentials, or sensitive data in the diff.
- [ ] No obvious security issues (injection, unvalidated input, broadened permissions, risky new dependency).
- [ ] Dependency additions are justified and from a trustworthy source.

## Maintainability

- [ ] Names and structure match the surrounding code; nothing needlessly clever.
- [ ] Public API / interface changes are intentional and documented.
- [ ] Docs/changelog updated if behavior or usage changed.

## Closing

- [ ] Feedback distinguishes blocking issues from suggestions (prefix nits clearly).
- [ ] Approve / request changes / comment chosen deliberately — don't approve with unaddressed blocking concerns.
