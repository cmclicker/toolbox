# Checklist: before rewriting published history

> Walk this before any `push --force` / `push --force-with-lease`, or any rebase/amend/filter-repo whose result you'll push to a shared branch. Rewriting history that others have is the one Git action that's genuinely disruptive to undo. Each item is yes/no; blocking items must pass.

## Blocking

- [ ] The branch is **not** a protected/shared trunk (`main`, `develop`, a release branch). If it is, stop — use `revert` instead ([../../playbooks/git/undo-published-commit.md](../../playbooks/git/undo-published-commit.md)).
- [ ] No one else is actively building on this branch, or everyone who is has been told and is ready to re-sync.
- [ ] Using `--force-with-lease`, not `--force` — so the push aborts if the remote moved since your last fetch. (`git fetch` first to refresh the lease.)
- [ ] You've confirmed what you're about to overwrite: `git fetch && git log --oneline @{u}..` and `..@{u}` reviewed.
- [ ] A recovery point exists: note the current remote tip hash, or `git branch backup-<date>` before rewriting, so the pre-rewrite state is retrievable.

## If purging a secret (additionally)

- [ ] The secret has already been **rotated/revoked** — the rewrite is hygiene, not the actual fix. ([../../playbooks/git/purge-a-secret-from-history.md](../../playbooks/git/purge-a-secret-from-history.md))
- [ ] You understand forks and CI logs/caches retain the old content independently and need separate handling.

## After

- [ ] Collaborators notified to re-clone or hard-reset to the new history.
- [ ] Open PRs/branches based on the old commits identified for rebasing.
- [ ] CI is green on the rewritten branch.
