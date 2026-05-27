# Forks and upstream (contributing to others' repos)

**TL;DR:** A fork is your own server-side copy of someone else's repo. The standard open-source contribution flow is fork → clone your fork → branch → push to your fork → open a PR against the original ("upstream"). Because the upstream keeps moving, you periodically sync your fork. The key local detail: configure **two remotes** — `origin` (your fork) and `upstream` (the original).

## The model

```
upstream  (original repo, you can't push to it)
   │ fork
   ▼
origin    (your fork, you own it)
   │ clone
   ▼
local clone  → branch → push to origin → PR to upstream
```

## Setup

```bash
gh repo fork OWNER/REPO --clone        # fork + clone + auto-add the upstream remote
# or manually after cloning your fork:
git remote add upstream https://github.com/OWNER/REPO.git
git remote -v                          # expect: origin = your fork, upstream = original
```

`gh repo fork --clone` is the shortcut: it forks, clones your fork as `origin`, and adds `upstream` pointing at the original.

## Making a contribution

```bash
git switch -c fix-typo                  # branch off your synced main
# ...edit, commit...
git push -u origin fix-typo             # push to YOUR fork
gh pr create --repo OWNER/REPO --fill   # open the PR against upstream
```

Always work on a branch, never on `main` of your fork — it keeps `main` clean for syncing and lets you have multiple PRs in flight.

## Keeping the fork in sync

Upstream advances while your fork sits still. Sync before starting new work so you branch off current code:

```bash
# Easiest (CLI, no local clone needed):
gh repo sync OWNER/your-fork --branch main

# Or locally:
git fetch upstream
git switch main
git merge --ff-only upstream/main       # fast-forward your main to match upstream
git push origin main                    # update your fork's main
```

`--ff-only` keeps your `main` an exact mirror of upstream (no divergent merge commits). If it refuses to fast-forward, your fork's `main` has commits of its own — rebase or reset it to `upstream/main`. The full procedure with the diverged case is in [../../playbooks/github/sync-a-fork.md](../../playbooks/github/sync-a-fork.md).

## Notes

- **PRs from forks have limited CI secrets** by default (a security measure) — maintainers' workflows handle untrusted contributions carefully. See [repo-security.md](repo-security.md).
- **Forks retain history independently.** A secret purged from upstream still exists in forks ([../../playbooks/git/purge-a-secret-from-history.md](../../playbooks/git/purge-a-secret-from-history.md)).
- Distinguish a **fork** (contribution / divergent copy on GitHub) from vendoring code into your own repo ([../git/submodules-vs-subtree.md](../git/submodules-vs-subtree.md)).

## How I use it

- `gh repo fork --clone` to start; confirm `origin`=fork, `upstream`=original.
- Sync `main` to `upstream/main` (ff-only) *before* branching for new work.
- Branch per contribution, push to `origin`, `gh pr create --repo upstream`.

## Links

- [GitHub Docs — Fork a repo](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo)
- [Syncing a fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork)
