#!/usr/bin/env bash
# Bash "strict mode" header. Paste at the top of any non-trivial script.
# Makes the shell fail loudly instead of limping on after an error.
#
#   set -e          exit on any command that returns non-zero
#   set -u          error on use of an unset variable (catches typos)
#   set -o pipefail a pipeline fails if ANY stage fails, not just the last
#   IFS=$'\n\t'     split words on newline/tab only, not spaces (safer loops)
#
# Caveats worth knowing:
#   - `set -e` does NOT trigger inside `if`, `&&`, `||`, or `!` conditions —
#     that's intended, so test commands don't abort the script.
#   - For a command you expect to sometimes fail, guard it:  cmd || true
#   - `set -u` breaks `$1` defaults; use `${1:-default}` instead.

set -euo pipefail
IFS=$'\n\t'

# Optional: print each command before running it (debugging).
# set -x

# Optional: a trap that reports which line died.
trap 'echo "error: line $LINENO exited with status $?" >&2' ERR
