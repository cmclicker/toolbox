# `git reflog` — the local history of where refs have been

**TL;DR:** The reflog records every change to `HEAD` (and to each branch) on your machine — every commit, checkout, reset, rebase, merge, and amend. It's how you get back to a state that no branch points at anymore. It's **local-only**, not pushed or cloned, and entries expire (default ~90 days for reachable, ~30 for unreachable).

## What it records

Whenever a ref moves, Git appends an entry to that ref's reflog with the old position, the new position, and a description of the operation. `HEAD`'s reflog is the union of your navigation; each branch also has its own.

```bash
git reflog                 # HEAD's reflog (most operations show here)
git reflog show main       # a specific branch's reflog
git reflog --date=iso      # with absolute timestamps (the `rl` alias)
```

Two ways to name a past position:

- `HEAD@{n}` — the nth-previous value of HEAD (`HEAD@{2}` = two moves ago).
- `HEAD@{time}` — by time (`HEAD@{yesterday}`, `main@{2.hours.ago}`).

## Why it can recover "lost" commits

A commit is deleted only when it's unreachable *and* garbage-collected. After a `reset`, `rebase`, or `amend`, the old commits are no longer on a branch — but the reflog still references them, which keeps them reachable (and recoverable) until the reflog entry expires. So:

```bash
git reflog                       # find the entry just before the mistake
git reset --hard HEAD@{n}        # move the branch back to it
# or, to save it without moving your branch:
git branch rescue HEAD@{n}
```

This is the mechanism behind [rebase-recovery.md](rebase-recovery.md) and the recovery steps in [reset-modes.md](reset-modes.md). It recovers *committed* work only — changes never committed have no reflog entry.

## Limits

- **Local-only.** A fresh clone has an empty reflog; a teammate's reflog isn't yours. The reflog can't recover something that only ever existed on another machine.
- **Expires.** Entries are pruned by `git gc` per `gc.reflogExpire` (default 90 days) and `gc.reflogExpireUnreachable` (default 30 days). Old mistakes may no longer be recoverable.
- **Per-clone.** Re-cloning a repo gives you a brand-new, empty reflog.

## How I use it

- First command whenever a committed change seems to have vanished — before trying anything else.
- `git reflog --date=iso` (the `rl` alias in [../../snippets/git/aliases.gitconfig](../../snippets/git/aliases.gitconfig)) to match entries to when I remember doing something.
- Park a recovered state on a throwaway branch (`git branch rescue HEAD@{n}`) before deciding, rather than resetting immediately.

## Links

- [`git reflog` docs](https://git-scm.com/docs/git-reflog)
- [Pro Git — Data Recovery](https://git-scm.com/book/en/v2/Git-Internals-Maintenance-and-Data-Recovery)
