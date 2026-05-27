# Playbook: debug a Bash script

> **Trigger:** a script misbehaves — wrong output, silent failure, or it stops unexpectedly. Est. time: 5–30 min. Concepts: [../../references/bash/error-handling.md](../../references/bash/error-handling.md), [../../references/bash/quoting-and-word-splitting.md](../../references/bash/quoting-and-word-splitting.md).

## Step 1 — Rule out syntax and obvious smells (seconds)

```bash
bash -n script.sh        # parse without executing: catches syntax errors
shellcheck script.sh     # static analysis: quoting bugs, misuse, pitfalls
```

ShellCheck finds a large share of real bugs before you ever run the script. If it's not installed, get it ([../../resources/bash/README.md](../../resources/bash/README.md)). Fix everything it flags (or justify it) first.

## Step 2 — Make failures loud

If the script "just stops" or charges past errors, add strict mode at the top:

```bash
set -euo pipefail
```

Now it exits at the first failing command and at the first unset variable, so the failure point is where the script *actually* stops — not three steps later. (Remember `set -e`'s exceptions in [../../references/bash/error-handling.md](../../references/bash/error-handling.md): failures inside `if`/`&&`/`||` don't trigger it.)

## Step 3 — Trace execution with `-x`

`set -x` prints each command (after expansion) before running it — the single most useful debugging tool, because it shows what the variables *actually* expanded to:

```bash
bash -x script.sh                 # trace the whole run
# or trace just a section:
set -x; suspect_block; set +x
```

A richer trace with file:line:function on every line:

```bash
export PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]:-main}: '
bash -x script.sh
```

`PS4` is the prefix `-x` prints; enriching it turns the trace into a line-by-line map.

## Step 4 — Pinpoint where it dies

Add an `ERR` trap to report the failing line and status:

```bash
trap 'echo "FAILED at line $LINENO (exit $?)" >&2' ERR
```

Then read the expanded values around that line in the `-x` trace. Most bugs are now obvious: an empty variable (unquoted, split into nothing), a glob that didn't match, a path with a space, or a command that returned non-zero you assumed succeeded.

## Step 5 — Inspect state at the failure

- Print suspect variables: `declare -p var arr` (shows type and exact contents, quoting visible).
- Check the *actual* exit status you're branching on: `cmd; echo "status=$?"`.
- For a pipeline, recall only the last stage's status counts without `pipefail`; check `${PIPESTATUS[@]}` to see each stage.

## Common root causes (check these first)

| Symptom | Usual cause |
|---|---|
| "command not found" / splits oddly | unquoted expansion with spaces ([quoting](../../references/bash/quoting-and-word-splitting.md)) |
| Variable empty when it shouldn't be | set in a pipe/subshell that doesn't persist ([redirection](../../references/bash/redirection-and-pipes.md)) |
| Script continues after an error | missing `set -e`, or failure was in an `if`/`&&` condition |
| `unbound variable` | `set -u` + a real typo, or an optional var needing `${var:-}` |
| Works in terminal, fails in cron/CI | relied on interactive startup files / PATH not exported ([startup files](../../references/bash/shell-startup-files.md)) |

## How I use it

`shellcheck` → `bash -n` → add `set -euo pipefail` → `bash -x` with an enriched `PS4`. That sequence resolves the large majority of script bugs without guesswork.
