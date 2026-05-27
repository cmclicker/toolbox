# Remotes, tracking branches, and fetch/pull/push

**TL;DR:** A *remote* is a named URL (`origin`). *Remote-tracking branches* (`origin/main`) are local read-only bookmarks recording where the remote's branches were at your last `fetch`. A local branch can have an *upstream* — the remote-tracking branch it compares and syncs against. `fetch` updates the bookmarks; `pull` fetches then integrates; `push` sends your commits up.

## The three kinds of branch

- **Local branch** — `main`. The one you commit on. Lives in `refs/heads/`.
- **Remote-tracking branch** — `origin/main`. A read-only mirror of the remote's `main` as of your last fetch. Lives in `refs/remotes/origin/`. You never commit on it; Git moves it for you on fetch.
- **Remote branch** — the actual `main` on the server. You only affect it through `push`.

`origin/main` can be stale: it reflects the last fetch, not the live server. This is why `git status` says "up to date with origin/main" right before a fetch reveals new commits — it was comparing against the cached bookmark.

## Upstream (the tracking relationship)

A local branch's **upstream** is the remote-tracking branch it's associated with. Setting it enables bare `git pull`/`git push`, the ahead/behind counts in `git status`, and the `@{u}` shorthand.

```bash
git push -u origin main         # push AND set origin/main as main's upstream
git branch --set-upstream-to=origin/main   # set upstream without pushing
git rev-parse --abbrev-ref @{u} # show the current branch's upstream
git status -sb                  # "## main...origin/main [ahead 2, behind 1]"
```

With `push.autoSetupRemote = true` (in [../../configs/git/gitconfig](../../configs/git/gitconfig)), the first `git push` of a new branch sets its upstream automatically.

## fetch vs. pull

- **`git fetch`** downloads new objects and updates remote-tracking branches. It changes *nothing* in your working tree or local branches — it's always safe.
- **`git pull`** = `git fetch` + integrate the upstream into your current branch (merge by default, or rebase). It *does* change your branch, so it can produce merge commits or conflicts.

```bash
git fetch --all --prune    # update all remotes' bookmarks; drop deleted ones
git log --oneline ..@{u}   # commits upstream has that you don't (incoming)
git log --oneline @{u}..   # commits you have that upstream doesn't (outgoing)
```

The two-dot `A..B` means "reachable from B but not A." `..@{u}` therefore lists what a pull would bring in; `@{u}..` lists what a push would send.

For why `pull.ff = only` is the safest default and the merge-vs-rebase choice it surfaces, see [merge-vs-rebase.md](merge-vs-rebase.md).

## push

```bash
git push                    # current branch to its upstream (with push.default=simple)
git push origin feature     # push local feature to origin/feature
git push --force-with-lease # overwrite remote history, but only if it hasn't moved since fetch
git push origin --delete old-branch   # delete a remote branch
git push --tags             # (or follow tags automatically; see gitconfig)
```

Never plain `--force` a shared branch — it overwrites whatever's there with no check. `--force-with-lease` refuses if the remote advanced since your last fetch, which is the difference between "I rewrote my own history" and "I clobbered a teammate's push." See [../../playbooks/git/undo-published-commit.md](../../playbooks/git/undo-published-commit.md).

## Pruning

Remote branches deleted on the server leave stale `origin/*` bookmarks locally until pruned. `fetch.prune = true` and `fetch.pruneTags = true` (in the shipped gitconfig) prune automatically; otherwise `git fetch --prune`.

## How I use it

- `git fetch` first whenever I want the truth about the remote; treat `origin/*` as a cache.
- `incoming`/`outgoing` aliases (in [../../snippets/git/aliases.gitconfig](../../snippets/git/aliases.gitconfig)) to see what a pull/push would do before doing it.
- `push -u` (or autoSetupRemote) on a branch's first push; bare `git push` thereafter.

## Links

- [Pro Git — Working with Remotes](https://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes)
- [Pro Git — Remote Branches](https://git-scm.com/book/en/v2/Git-Branching-Remote-Branches)
