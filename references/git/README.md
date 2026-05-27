# Git — references

> My authored explainers on how Git works and how I use it. For curated *external* material (Pro Git, interactive learners, cheatsheets), see [../../resources/git/](../../resources/git/). For step-by-step procedures, see the Git [playbooks](../../playbooks/git/) and [checklists](../../checklists/git/).

## Fundamentals (the mental model)

- [objects-and-refs.md](objects-and-refs.md) — the object model (blob/tree/commit/tag) and how branches/HEAD are just refs. Read this first; it makes everything else make sense.
- [reflog.md](reflog.md) — the local log of where refs have been, and why it can recover "lost" commits.
- [gc-and-packfiles.md](gc-and-packfiles.md) — loose objects, packfiles, and when garbage collection ends recoverability.

## Everyday workflow

- [remotes-and-tracking.md](remotes-and-tracking.md) — remotes, remote-tracking branches, upstream, fetch/pull/push.
- [branching-models.md](branching-models.md) — trunk-based vs. GitHub Flow vs. Git Flow, and when each fits.
- [merge-vs-rebase.md](merge-vs-rebase.md) — what each does, the linear-vs-true-history trade-off, and the one rule that prevents pain.
- [stash.md](stash.md) — setting aside uncommitted work, and what it does and doesn't capture.
- [cherry-pick.md](cherry-pick.md) — applying a specific commit's change onto another branch.

## Fixing and recovery

- [reset-modes.md](reset-modes.md) — `--soft`/`--mixed`/`--hard` and exactly what each touches.
- [rebase-recovery.md](rebase-recovery.md) — getting back commits after a bad rebase/reset/amend.

## Configuration and behavior

- [line-endings.md](line-endings.md) — CRLF/LF, `core.autocrlf`, and `.gitattributes` (Windows-relevant).
- [gitignore-mechanics.md](gitignore-mechanics.md) — pattern rules, the two that trip everyone up, and diagnosis.
- [hooks.md](hooks.md) — lifecycle scripts, the sharing problem, and why they aren't enforcement.

## Advanced / occasional

- [bisect.md](bisect.md) — binary-search history to find a regression (manual and automated).
- [worktrees.md](worktrees.md) — multiple branches checked out at once from one repo.
- [tags-and-signing.md](tags-and-signing.md) — annotated tags, pushing tags, and GPG/SSH signing.
- [submodules-vs-subtree.md](submodules-vs-subtree.md) — vendoring another repo, and why a package manager usually beats both.

## See also

- [../../resources/git/](../../resources/git/) — curated external Git learning material.
- [../../configs/git/](../../configs/git/) · [../../snippets/git/](../../snippets/git/) · [../../playbooks/git/](../../playbooks/git/) · [../../checklists/git/](../../checklists/git/)
