#!/usr/bin/env bash
# Bash "strict mode" header. Paste directly below the shebang.
#
#   set -e          exit with the command's status the first time any command exits non-zero
#   set -u          exit when an unset variable is referenced
#   set -o pipefail a pipeline's exit status is the last non-zero stage, not just the final stage
#   IFS=$'\n\t'     word-split unquoted expansions on newline and tab only, not space
#
# Caveats worth knowing:
#   - `set -e` does NOT trigger inside `if`, `&&`, `||`, or `!` conditions —
#     that's intended, so test commands don't abort the script.
#   - For a command you expect to sometimes fail, guard it:  cmd || true
#   - `set -u` breaks `$1` defaults; use `${1:-default}` instead.

set -euo pipefail
IFS=$'\n\t'

# Optional: print each command (after expansion) before executing it.
# set -x

# Optional: on a non-zero exit under `set -e`, print the line number and status.
trap 'echo "error: line $LINENO exited with status $?" >&2' ERR
