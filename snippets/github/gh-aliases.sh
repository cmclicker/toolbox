# gh CLI aliases + one-liners. Set the aliases with `gh alias set` (they persist
# in gh config), or copy the raw commands. Invoke as `gh <name>`.
# Reference: ../../references/github/gh-cli.md

# --- Aliases (run once to register) ---------------------------------------

# Draft PR from current branch, title/body filled from commits: `gh prc`
gh alias set prc 'pr create --fill --draft'

# Mark current PR ready + enable auto-merge (squash) once checks pass: `gh prgo`
gh alias set prgo '!gh pr ready && gh pr merge --auto --squash --delete-branch'

# This PR's CI status: `gh prx`
gh alias set prx 'pr checks'

# Open the current repo/PR in the browser: `gh o`
gh alias set o 'browse'

# Watch the latest workflow run to completion (non-zero on failure): `gh runw`
gh alias set runw '!gh run watch "$(gh run list --limit 1 --json databaseId -q ".[0].databaseId")" --exit-status'

# My open work across repos (assigned, review-requested): `gh me`
gh alias set me 'status'

# --- One-liners (no alias needed) -----------------------------------------

# Tail only the failed step logs of the most recent run:
#   gh run view "$(gh run list --limit 1 --json databaseId -q '.[0].databaseId')" --log-failed

# List your repos by most-recently pushed:
#   gh repo list --limit 30 --json name,pushedAt -q 'sort_by(.pushedAt) | reverse | .[].name'

# Check out a contributor's PR locally to test it:
#   gh pr checkout <number>

# Create a release with auto-generated notes from merged PRs:
#   gh release create vX.Y.Z --generate-notes

# Read branch protection (JSON) for main:
#   gh api repos/{owner}/{repo}/branches/main/protection
