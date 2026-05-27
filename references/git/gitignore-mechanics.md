# `.gitignore` pattern mechanics

**TL;DR:** `.gitignore` controls which **untracked** files Git ignores. Patterns use glob syntax with a few special rules: a trailing `/` matches directories only, a leading `/` anchors to the `.gitignore`'s location, `**` spans directories, and `!` negates. Two rules cause most confusion: the **last matching pattern wins**, and **a file cannot be re-included with `!` if a parent directory is excluded**. `.gitignore` does nothing to files Git already tracks.

## Pattern syntax

| Pattern | Matches |
|---|---|
| `build` | any file or dir named `build`, at any depth |
| `build/` | only a **directory** named `build` (and its contents), any depth |
| `/build` | `build` only in the **same dir** as this `.gitignore` (anchored) |
| `*.log` | any file ending `.log`, any depth |
| `doc/*.md` | `.md` files directly in `doc/` (one level, because the pattern contains a `/`) |
| `doc/**/*.md` | `.md` files anywhere under `doc/` (`**` spans directories) |
| `!keep.log` | re-include `keep.log` that an earlier pattern ignored |

A pattern with a `/` anywhere except a trailing one is matched relative to the `.gitignore` location, not at every depth. A pattern with no `/` (or only trailing) matches by name at any depth.

## The two rules that trip people up

**1. Last match wins.** Patterns are evaluated top to bottom; the final pattern that matches a path decides. Order negations *after* the broad pattern they carve out:

```gitignore
*.log
!keep.log        # correct: re-includes keep.log (verified: keep.log tracked, other.log ignored)
```

Reverse the order and `*.log` (now last) wins and `keep.log` stays ignored.

**2. A negation can't rescue a file inside an excluded directory.** If a parent directory is ignored, Git never descends into it, so `!` on a file within it has no effect:

```gitignore
logs/
!logs/keep.log   # has NO effect — logs/ is excluded, so keep.log stays ignored (verified)
```

To keep one file out of an otherwise-ignored directory, ignore the directory's *contents* with a wildcard instead of the directory itself, then negate:

```gitignore
logs/*
!logs/keep.log   # works: the dir is entered, contents ignored, keep.log re-included
```

Both behaviors above are verified with `git check-ignore` / `git status --ignored`.

## `.gitignore` only affects untracked files

Adding a pattern does **not** remove a file Git already tracks. To stop tracking a now-ignored file while keeping it on disk:

```bash
git rm --cached path/to/file      # untrack but keep the working-tree copy
git rm -r --cached .              # untrack everything, then re-add to apply .gitignore wholesale
```

## Where ignore rules live (precedence, low to high)

1. `~/.config/git/ignore` (global; set via `core.excludesfile`) — machine/editor cruft. See [../../configs/git/global-gitignore](../../configs/git/global-gitignore).
2. `.gitignore` files in the repo (committed; nearer-to-file wins) — project artifacts.
3. `.git/info/exclude` — local, uncommitted, repo-specific ignores.

A nested `.gitignore` deeper in the tree overrides a higher one for paths under it.

## Diagnosing

```bash
git check-ignore -v path/to/file   # prints the file:line of the pattern that decides (or nothing)
git status --ignored               # list ignored files alongside status
```

`git check-ignore -v` is the definitive answer to "why is this file (not) ignored" — it names the exact pattern and its source.

## How I use it

- Project-specific ignores in the repo's `.gitignore` ([Node starter](../../configs/gitignore/node.gitignore)); machine/editor cruft in the global ignore so it never clutters project files.
- When a file "won't ignore," it's almost always already tracked → `git rm --cached`.
- When a negation "doesn't work," it's almost always the excluded-parent rule → switch to `dir/*` + `!dir/keep`.

## Links

- [`gitignore` docs](https://git-scm.com/docs/gitignore)
