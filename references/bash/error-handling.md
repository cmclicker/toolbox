# Error handling: exit codes, `set -euo pipefail`, traps

**TL;DR:** Every command returns an exit status (`$?`): 0 = success, non-zero = failure. By default Bash ignores failures and keeps going. The strict-mode trio — `set -e` (exit on error), `set -u` (error on unset variable), `set -o pipefail` (a pipeline fails if any stage fails) — makes scripts stop at the first problem instead of charging ahead on bad state. A `trap` runs cleanup or reports the failing line.

## Exit status

```bash
cmd; echo "$?"        # 0 = success, non-zero = failure
cmd && echo ok        # runs only if cmd succeeded
cmd || echo failed    # runs only if cmd failed
```

By convention: 0 success; 1 general error; 2 misuse; 126 not executable; 127 command not found; 130 interrupted (Ctrl-C). Your script should `exit` with a meaningful non-zero on failure.

## Strict mode

```bash
set -euo pipefail
```

- **`set -e`** — exit immediately if a command returns non-zero (with exceptions below).
- **`set -u`** — referencing an unset variable is an error, catching typos like `$flie`. Use `${var:-}` for intentionally-optional vars.
- **`set -o pipefail`** — a pipeline's status is the last *non-zero* stage, so `grep x file | sort` fails if `grep` fails, not just `sort`.

The ready-to-paste header (with `IFS` and a line-number trap) is [../../snippets/bash/strict-mode.sh](../../snippets/bash/strict-mode.sh).

### `set -e` doesn't fire everywhere (by design)

It does **not** abort when the failing command is:

- the condition of `if`, `while`, `until`;
- any but the last command in `&&` / `||`;
- negated with `!`.

So `if grep -q x file; then` won't exit just because `grep` found nothing — intended. The trap: `set -e` also won't catch a failure inside a function called in a condition the way you might expect, and `local x=$(failing-cmd)` hides the failure (the `local` succeeds). When you need a command's status, run it on its own line or guard with `|| return`/`|| exit`.

### Deliberately allowing a command to fail

```bash
some-optional-cmd || true        # don't let a tolerated failure abort under set -e
if ! some-cmd; then handle; fi   # handle failure explicitly
```

## Traps: cleanup and reporting

`trap 'cmd' SIGNAL` runs `cmd` when the signal/event fires:

```bash
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT          # cleanup runs no matter how the script ends
trap 'echo "failed at line $LINENO (status $?)" >&2' ERR   # report on error
```

- **`EXIT`** — runs on any exit (success, error, or `exit`). The place for cleanup (temp files, locks). See [../../snippets/bash/tempdir-cleanup.sh](../../snippets/bash/tempdir-cleanup.sh).
- **`ERR`** — runs when a command triggers `set -e`. Good for a diagnostic showing where it died.
- **`INT`/`TERM`** — handle Ctrl-C / termination if you need graceful shutdown.

## How I use it

- `set -euo pipefail` + `IFS=$'\n\t'` at the top of every non-trivial script ([strict-mode.sh](../../snippets/bash/strict-mode.sh)).
- `trap 'rm -rf "$tmp"' EXIT` for any temp resource, so cleanup is guaranteed.
- `${var:-}` for optional vars under `set -u`; `cmd || true` for tolerated failures.
- Validate with [ShellCheck](../../resources/bash/README.md) and the [script-review checklist](../../checklists/bash/script-review.md) before shipping.

## Links

- [Bash manual — The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)
- [BashFAQ 105 — Why doesn't `set -e` do what I expected?](https://mywiki.wooledge.org/BashFAQ/105)
