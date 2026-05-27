# Playbook: sync a fork with upstream

> **Trigger:** your fork has fallen behind the original repo and you want it current (before starting new work, or before opening a PR). Est. time: 1–5 min. Model: [../../references/github/forks-and-upstream.md](../../references/github/forks-and-upstream.md).

## Fast path — `gh repo sync`

```bash
gh repo sync <owner>/<your-fork> --branch main
```

This updates your fork's `main` from upstream server-side, no local clone required. If your fork's `main` has diverged (you committed to it directly), `gh` will refuse unless you pass `--force` — and `--force` discards your fork's divergent commits on that branch. If you have such commits, use the local path below instead.

## Local path (and the diverged case)

```bash
git remote -v                       # confirm: origin = your fork, upstream = original
git fetch upstream
git switch main
git merge --ff-only upstream/main   # fast-forward main to match upstream
git push origin main                # update your fork's main
```

If `--ff-only` refuses with "not possible to fast-forward," your `main` has commits that aren't upstream. Decide:

- **Those commits were a mistake** (you meant to branch) → move them to a branch, then hard-reset main:
  ```bash
  git branch my-work               # save the commits on a branch
  git reset --hard upstream/main   # make main an exact mirror of upstream
  git push --force-with-lease origin main
  ```
  (See [../../references/git/reset-modes.md](../../references/git/reset-modes.md) and [../../checklists/git/before-rewriting-history.md](../../checklists/git/before-rewriting-history.md).)
- **You intend to keep them on main** → `git rebase upstream/main` instead of merge, resolve any conflicts ([../../playbooks/git/resolve-merge-conflict.md](../../playbooks/git/resolve-merge-conflict.md)), then force-push.

## Then branch for new work

Always branch off the freshly-synced `main` rather than committing to it — keeps `main` a clean mirror and future syncs trivial:

```bash
git switch -c my-feature
```

## Note

Syncing `main` does not update feature branches you already started. To bring an in-progress branch up to date, rebase it onto the synced `main`: `git switch my-feature && git rebase main`.
