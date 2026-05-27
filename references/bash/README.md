# Bash — references

> My authored explainers for Bash scripting and the Unix shell. For curated external Bash material (the manual, ShellCheck, Greg's Wiki), see [../../resources/bash/](../../resources/bash/). For a reusable strict-mode header and templates, see [../../snippets/bash/](../../snippets/bash/).

## Foundations

- [quoting-and-word-splitting.md](quoting-and-word-splitting.md) — why unquoted expansions cause most bugs, and the "quote everything" rule. Read this first.
- [shell-startup-files.md](shell-startup-files.md) — `.bashrc` vs `.bash_profile` vs `.profile`, login vs interactive, what loads when.

## Language

- [parameter-expansion.md](parameter-expansion.md) — defaults, substring removal, search/replace, length, case — without `sed`/`basename`.
- [test-and-conditionals.md](test-and-conditionals.md) — `[[ ]]` vs `[ ]`, `(( ))`, `if`/`case`, regex and glob matching.
- [arrays.md](arrays.md) — indexed and associative arrays, and why they beat space-separated strings.
- [functions.md](functions.md) — args via `"$@"`, `local` scoping, returning data via stdout vs. exit status.
- [redirection-and-pipes.md](redirection-and-pipes.md) — stdin/stdout/stderr, `2>&1` ordering, here-docs, process substitution.

## Robustness

- [error-handling.md](error-handling.md) — exit codes, `set -euo pipefail` (and where `set -e` doesn't fire), traps and cleanup.

## See also

- [../../snippets/bash/](../../snippets/bash/) — strict-mode header, getopts and temp-dir templates.
- [../../resources/bash/](../../resources/bash/) · [../../configs/bash/](../../configs/bash/) · [../../checklists/bash/](../../checklists/bash/) · [../../playbooks/bash/](../../playbooks/bash/)
