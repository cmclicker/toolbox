#!/usr/bin/env bash
# Sample pre-commit hook: fast checks that run before each commit.
# Install one of these ways:
#   - copy to .git/hooks/pre-commit and `chmod +x` it (local only, not shared), OR
#   - put in a committed .githooks/ dir and run: git config core.hooksPath .githooks
# Background + the sharing problem: ../../../references/git/hooks.md
#
# Exit non-zero to ABORT the commit. Bypass in an emergency with: git commit -n
# Keep this FAST (formatting/lint/secret-scan); put the test suite in CI.

set -euo pipefail

# Only consider staged, added/copied/modified files (not deleted).
mapfile -t staged < <(git diff --cached --name-only --diff-filter=ACM)
[ ${#staged[@]} -eq 0 ] && exit 0

fail=0

# 1) Block accidental debug/conflict markers and likely secrets.
for f in "${staged[@]}"; do
	[ -f "$f" ] || continue
	# Leftover merge-conflict markers.
	if git show ":$f" | grep -nE '^(<{7}|={7}|>{7})( |$)' >/dev/null; then
		echo "pre-commit: conflict markers in $f" >&2; fail=1
	fi
	# Crude secret heuristics — tune to your stack.
	if git show ":$f" | grep -nEi '(AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----|api[_-]?key\s*[:=]\s*["'"'"'][A-Za-z0-9/_-]{16,})' >/dev/null; then
		echo "pre-commit: possible secret in $f (set commit.gpgsign / use a secret manager)" >&2; fail=1
	fi
done

# 2) Run a formatter/linter if the project defines one (skip silently if not).
if [ -f package.json ] && command -v npm >/dev/null; then
	if npm run | grep -q '^  lint$'; then
		npm run lint --silent || { echo "pre-commit: lint failed" >&2; fail=1; }
	fi
fi

if [ "$fail" -ne 0 ]; then
	echo "pre-commit: checks failed; fix the above or bypass with 'git commit -n'." >&2
	exit 1
fi
