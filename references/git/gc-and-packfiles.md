# Garbage collection and packfiles

**TL;DR:** Git initially writes each object as its own zlib-compressed "loose" file. Periodically `git gc` packs many objects into a single compressed *packfile* with delta compression, and deletes unreachable objects whose grace period has passed. This is housekeeping — it runs automatically and you rarely invoke it by hand, but it explains repo size, the occasional "Auto packing" message, and when recovery stops being possible.

## Loose objects vs. packfiles

- A new object (blob/tree/commit/tag) is written **loose**: one file in `.git/objects/xx/yyyy…`, zlib-compressed but stored whole.
- `git gc` rewrites groups of loose objects into a **packfile** (`.git/objects/pack/*.pack` + `.idx`). Packfiles use **delta compression** — similar objects are stored as deltas against one another — so a packed repo is dramatically smaller than the sum of its loose objects.

This is why a freshly-committed repo can look large and then shrink after gc, and why network transfer (clone/fetch) sends packs, not loose objects.

## What `git gc` does

```bash
git gc              # pack loose objects, prune old unreachable ones, tidy refs
git gc --aggressive # spend more CPU for better delta compression (occasional, not routine)
git count-objects -vH   # how many loose objects / packs, and sizes
```

Git triggers `gc --auto` automatically after operations that create many loose objects (e.g. when loose objects exceed `gc.auto`, default 6700), so manual `gc` is seldom necessary.

## Reachability and pruning (the recovery connection)

`gc` only deletes objects that are **unreachable** — not reachable from any branch, tag, HEAD, *or* reflog entry — and only after a grace period (`gc.pruneExpire`, default 2 weeks; reflog expiry governs how long unreachable commits stay referenced). This grace period is exactly what makes [reflog.md](reflog.md) recovery possible: a commit dropped by a reset survives until both its reflog entry expires and gc runs.

To force immediate cleanup (e.g. after purging a secret — see [../../playbooks/git/purge-a-secret-from-history.md](../../playbooks/git/purge-a-secret-from-history.md)):

```bash
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

This removes the safety net deliberately — only do it when you *want* the old objects gone (and remember other clones/forks still have them).

## Maintenance on large repos

Modern Git can run maintenance in the background:

```bash
git maintenance start    # schedule periodic prefetch/gc/commit-graph upkeep
```

The commit-graph file (maintained by gc/maintenance) speeds up history walks (`git log --graph`, merge-base) on large repos.

## How I use it

- Let `gc --auto` do its thing; I almost never run `gc` manually.
- `git count-objects -vH` when a repo feels unexpectedly large, before assuming something's wrong.
- The aggressive `reflog expire` + `gc --prune=now` combo only as the final step of a deliberate history purge, understanding it ends recoverability.

## Links

- [Pro Git — Packfiles](https://git-scm.com/book/en/v2/Git-Internals-Packfiles)
- [Pro Git — Maintenance and Data Recovery](https://git-scm.com/book/en/v2/Git-Internals-Maintenance-and-Data-Recovery)
