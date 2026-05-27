#!/usr/bin/env bash
# Create a temp directory that is ALWAYS cleaned up, however the script exits
# (success, error, or Ctrl-C). The EXIT trap is the reliable place for cleanup.
# Reference: ../../references/bash/error-handling.md

set -euo pipefail

# mktemp -d creates a unique dir under $TMPDIR and prints its path.
tmp="$(mktemp -d)"

# Runs on ANY exit. Quoted, and guarded so an empty/unset var can't rm -rf "/".
cleanup() { [[ -n "${tmp:-}" && -d "$tmp" ]] && rm -rf "$tmp"; }
trap cleanup EXIT

# --- use $tmp freely; no manual cleanup needed anywhere below ---
echo "scratch dir: $tmp"
: > "$tmp/work.txt"
# ... do work ...

# On return/exit/error/interrupt, `cleanup` runs automatically.
