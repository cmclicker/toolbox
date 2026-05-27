# Git's object model and refs

**TL;DR:** Git stores history as four immutable object types (blob, tree, commit, tag) addressed by the SHA-1/SHA-256 hash of their content. A "branch" is not a container of commits — it is a file containing one commit hash. Almost every Git operation is either creating objects or moving a ref to point at a different object.

## The four object types

Every object is stored in `.git/objects/`, keyed by the hash of its content. Identical content produces an identical hash, so storage is automatically de-duplicated.

| Object | Holds | Points to |
|---|---|---|
| **blob** | The bytes of one file. No filename, no mode — just content. | nothing |
| **tree** | One directory level: a list of (mode, name, hash) entries. | blobs (files) and other trees (subdirectories) |
| **commit** | A snapshot: one root tree hash, zero or more parent commit hashes, author/committer, message. | one tree + its parent commit(s) |
| **tag** | An annotated tag: a target hash, a tagger, a message. | usually a commit |

A commit references a complete **tree** (the entire snapshot of the project at that point), not a diff. Diffs are computed on demand by comparing two trees. The de-duplication of unchanged blobs and trees is what makes storing full snapshots cheap.

Inspect any object directly:

```bash
git cat-file -t <hash>     # print the type
git cat-file -p <hash>     # pretty-print the content
git cat-file -p HEAD       # the current commit object
git cat-file -p HEAD^{tree} # the tree that commit points at
```

## Refs: names that point at hashes

A **ref** is a name mapping to a hash. Branches and tags are both refs; the difference is location and behavior, not type.

- A branch ref lives in `.git/refs/heads/<name>` (or packed into `.git/packed-refs`) and contains a single commit hash. `git commit` updates the current branch ref to the new commit. That is the entire mechanism of "advancing a branch."
- A tag ref lives in `.git/refs/tags/<name>`. A lightweight tag points straight at a commit; an annotated tag points at a tag object (which points at the commit).
- A remote-tracking ref (`refs/remotes/origin/main`) records where a branch was on the remote at the last fetch. It is updated by `git fetch`, not by your local commits.

```bash
git rev-parse main           # the hash main points at
git symbolic-ref HEAD        # which branch HEAD currently names
cat .git/refs/heads/main     # the ref is literally a file with a hash
```

## HEAD

`HEAD` is a ref that names "where you are." Normally it is *symbolic* — it contains `ref: refs/heads/main`, meaning "I am on `main`." A commit in this state advances `main` and HEAD follows it.

When `HEAD` instead contains a commit hash directly, you are in **detached HEAD**: commits you make are not on any branch, so they become unreachable once you check out something else (recoverable via reflog until garbage-collected). `git checkout <commit>`, `git checkout <tag>`, and `git rebase` (internally) all detach HEAD.

## Reachability and garbage collection

A commit is **reachable** if you can reach it by starting from some ref (branch, tag, HEAD, or a reflog entry) and walking parent links. Reachable objects are never deleted. Unreachable objects survive until `git gc` removes them, which is also why the reflog can recover "lost" commits for a while (default expiry ~90 days for reachable-via-reflog, ~30 for unreachable). See [rebase-recovery.md](rebase-recovery.md).

## How I use it

This model explains why the everyday operations behave as they do:

- **Branching is cheap** because creating a branch writes one 40-character file; it copies nothing.
- **`reset` "loses" nothing** because it only moves a ref; the old commits stay reachable through the reflog. See [reset-modes.md](reset-modes.md).
- **`rebase` rewrites history** because it creates *new* commit objects (new hashes) with the same trees but different parents; the originals become unreachable.
- **Hashes are content addresses**, so the same commit can never have two different hashes, and any change anywhere in history changes every descendant hash.

## Links

- [Pro Git — Git Internals: Git Objects](https://git-scm.com/book/en/v2/Git-Internals-Git-Objects)
- [Pro Git — Git References](https://git-scm.com/book/en/v2/Git-Internals-Git-References)
