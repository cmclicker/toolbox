# Playbook: purge a secret (or large file) from Git history

> **Trigger:** a credential, key, or large/sensitive file was committed and you need it gone from history — not just deleted in a later commit. Est. time: 30 min–few hours including coordination. This rewrites all of history; read fully before starting.

## Step 0 — Rotate first. This is the only step that limits exposure.

If it's a secret (API key, token, password, private key), **revoke and rotate it now**, before any cleanup. Assume it is already compromised the moment it was pushed: it's in clones, forks, CI logs, and possibly already scraped. History rewriting reduces future exposure; **rotation is what actually contains the breach.** Do this even if you decide not to rewrite history at all.

## Step 1 — Decide if a rewrite is worth it

Rewriting history invalidates every existing clone and fork and forces everyone to re-clone. Weigh that against the benefit:

- **Secret, already rotated:** rewriting removes the now-dead secret from history. Often worth it for hygiene, but the rotation already neutralized the risk.
- **Large file bloating the repo:** rewriting genuinely reclaims space; usually worth it.
- **Sensitive non-secret data (PII, proprietary):** rewriting matters because the content itself is the problem and can't be "rotated."

If the repo is private, solo, and the secret is rotated, you may reasonably skip the rewrite. If you proceed, continue.

## Step 2 — Use `git filter-repo` (not `filter-branch`)

`git filter-branch` is slow and officially discouraged. Install [`git-filter-repo`](https://github.com/newren/git-filter-repo). Work on a fresh clone so a mistake doesn't touch your only copy.

Remove a file from all history:

```bash
git filter-repo --path path/to/secret.env --invert-paths
```

Or replace a secret string everywhere it appears (across all commits), leaving the file:

```bash
# expressions.txt: one rule per line, e.g.  literal:AKIA1234567890==>REDACTED
git filter-repo --replace-text expressions.txt
```

`filter-repo` rewrites every affected commit (new hashes for all descendants) and, by design, removes the `origin` remote to make you reconfigure it deliberately.

## Step 3 — Expire and garbage-collect locally

The old objects are now unreachable but still present until gc removes them:

```bash
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

See [../../references/git/gc-and-packfiles.md](../../references/git/gc-and-packfiles.md). Confirm the content is gone: `git log --all -p -- path/to/secret.env` should show nothing, and `git grep <secret> $(git rev-list --all)` should be empty.

## Step 4 — Force-push the rewritten history

```bash
git remote add origin <url>        # filter-repo removed it
git push --force --all
git push --force --tags
```

This overwrites the remote's history. Coordinate timing with anyone who has the repo — their clones are now incompatible.

## Step 5 — Force everyone else to re-sync

Old clones still contain the secret and the old history. Each collaborator must **re-clone** (cleanest) or hard-reset to the new history. Old branches/PRs built on the pre-rewrite commits will need rebasing.

## Step 6 — Handle forks and the platform cache

- **Forks** retain the old objects independently — a fork can still expose the secret. On GitHub, you may need to contact support to purge cached views/PRs that reference old commits.
- **CI logs, artifacts, and caches** may still contain the secret — purge them too.
- This is why Step 0 matters most: you cannot guarantee every copy is gone, so the rotated secret being useless is the real protection.

## Summary

| Step | Action | Skippable? |
|---|---|---|
| 0 | Rotate/revoke the secret | **Never** |
| 1 | Decide if rewrite is worth it | — |
| 2 | `git filter-repo` to remove/redact | if skipping rewrite |
| 3 | Expire reflog + `gc --prune=now` | with step 2 |
| 4 | Force-push rewritten history | with step 2 |
| 5 | Everyone re-clones | with step 2 |
| 6 | Purge forks / CI / platform cache | partially |
