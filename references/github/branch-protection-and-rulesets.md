# Branch protection and rulesets

**TL;DR:** Branch protection enforces rules on important branches (`main`) that *cannot* be bypassed locally — require PRs, require passing checks, require reviews, block force-pushes and deletion. This is the real enforcement layer ([git hooks are not](../git/hooks.md)). GitHub has two systems: classic **branch protection rules** (per-branch, older) and **rulesets** (newer, more flexible, layerable, support tags and orgs). Use rulesets for new repos.

## Why this is the enforcement layer

Local hooks run on the author's machine and anyone can `--no-verify` past them. Branch protection / rulesets run **server-side**, so a rule like "PRs into `main` must pass CI and have one approval" genuinely cannot be skipped by a contributor. If a rule must hold, it belongs here — not in a hook.

## What you can require

- **Require a pull request before merging** — no direct pushes to `main`; changes go through PRs. Optionally require N approvals, dismiss stale approvals on new commits, require review from `CODEOWNERS`.
- **Require status checks to pass** — name the CI checks (e.g. `validate`) that must be green before merge. Optionally require the branch be up to date with base first.
- **Require conversation resolution** — all PR comments resolved before merge.
- **Require signed commits** — only signed commits ([../git/tags-and-signing.md](../git/tags-and-signing.md)) may be pushed.
- **Block force pushes** and **block deletion** of the branch.
- **Require linear history** — disallow merge commits (forces squash/rebase merges).

## Classic branch protection vs. rulesets

| | Branch protection rules | Rulesets |
|---|---|---|
| Scope | one branch pattern per rule | layered rules; branches **and** tags; org-wide |
| Stacking | one rule wins | multiple rulesets combine (most restrictive applies) |
| Bypass list | limited | granular bypass actors |
| Status | older, still supported | recommended for new setups |

Rulesets can also run in **evaluate** mode (report what *would* be blocked without enforcing) — useful for rolling out a policy without breaking everyone immediately.

## Setting them up

Branch protection (classic) is configurable via the API/CLI:

```bash
# read current protection
gh api repos/{owner}/{repo}/branches/main/protection
```

**Rulesets, however, are created in the web UI (Settings → Rules → Rulesets) or via `gh api`** — the `gh ruleset` command only *views* existing rulesets, it doesn't create them:

```bash
gh ruleset list                         # view rulesets on the repo
gh ruleset view <id>                     # details
gh api repos/{owner}/{repo}/rulesets     # create/manage via raw API (POST with JSON)
```

For a solo public repo, the web UI is the quickest path; script via `gh api` when you want the same policy across many repos.

## A sensible baseline for `main`

- Require a PR before merging (1 approval if you have collaborators; for solo repos, requiring a PR + green CI still enforces the check gate).
- Require status check `validate` (or your CI job name) to pass.
- Block force pushes and deletion.
- Require conversation resolution.

The operational steps are in [../../playbooks/github/set-up-new-repo.md](../../playbooks/github/set-up-new-repo.md); the hardening checklist is [../../checklists/github/repo-hardening.md](../../checklists/github/repo-hardening.md).

## How I use it

- Rulesets (not classic) for new repos, starting with the baseline above.
- The required status check name must exactly match the CI job/check name, or "required check" silently never passes.
- Solo repos still benefit: requiring a PR + green CI catches my own mistakes before they hit `main`.

## Links

- [About rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)
- [About protected branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
