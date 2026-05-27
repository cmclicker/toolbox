# Checklist: before shipping a Bash script

> Walk this before committing or relying on a non-trivial Bash script. Each item is yes/no. Background lives in [../../references/bash/](../../references/bash/).

## Blocking

- [ ] [ShellCheck](../../resources/bash/README.md) run and clean (or every remaining warning consciously justified). This catches most of the items below automatically.
- [ ] Strict mode header present: `set -euo pipefail` (+ `IFS=$'\n\t'`). See [../../snippets/bash/strict-mode.sh](../../snippets/bash/strict-mode.sh).
- [ ] Every variable expansion is quoted (`"$var"`, `"$@"`, `"${arr[@]}"`) unless glob/splitting is intended.
- [ ] No parsing of `ls` output and no unquoted `$(...)` used as a list — use globs/arrays/`mapfile` instead.
- [ ] Required arguments/inputs validated up front (`${1:?usage}`), with a usage message on misuse.
- [ ] External dependencies checked (`command -v tool >/dev/null || die`) rather than failing cryptically mid-run.
- [ ] Temp files/dirs created with `mktemp` and removed via a `trap ... EXIT` ([../../snippets/bash/tempdir-cleanup.sh](../../snippets/bash/tempdir-cleanup.sh)).
- [ ] Exits non-zero on failure; pipelines protected by `pipefail`.

## Safety

- [ ] No `rm -rf "$var/..."` without guaranteeing `$var` is non-empty (`set -u` + `[[ -n $var ]]`).
- [ ] No secrets hard-coded; no secrets echoed to logs.
- [ ] Functions declare working variables `local`; results returned via stdout, status via `return`.

## Portability (if it must run beyond your machine)

- [ ] Correct shebang (`#!/usr/bin/env bash`), and Bash-only features aren't used in a script claiming `#!/bin/sh`.
- [ ] Aware of GNU vs. BSD/macOS differences for `sed`, `grep`, `date`, `readlink` if targeting both.

## Advisory

- [ ] Run with `bash -n script` (syntax check) and, when debugging, `bash -x` — see [../../playbooks/bash/debug-a-script.md](../../playbooks/bash/debug-a-script.md).
- [ ] Comments explain the non-obvious; usage/`-h` documents how to run it.
