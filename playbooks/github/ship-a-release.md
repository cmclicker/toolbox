# Playbook: ship a release

> **Trigger:** a version is ready to publish. Est. time: 5–15 min. Tag mechanics: [../../references/git/tags-and-signing.md](../../references/git/tags-and-signing.md); the version-control side of undoing a bad release: [../../references/git/branching-models.md](../../references/git/branching-models.md).

## Step 1 — Confirm `main` is releasable

```bash
git switch main && git pull
gh run list --limit 1            # latest CI on main is green
```

Release from a known-green commit. If you maintain older versions, cut from the appropriate release branch instead of `main`.

## Step 2 — Pick the version

Use semver: `MAJOR.MINOR.PATCH`. Breaking change → MAJOR; backward-compatible feature → MINOR; fix only → PATCH. Decide the number now; it drives the tag and notes.

## Step 3 — Bump version metadata (if the project tracks it)

For a Node package, bump `package.json` and let the tooling tag:

```bash
npm version minor               # updates package.json, commits, and creates tag vX.Y.Z
git push --follow-tags          # push the commit AND the tag
```

For projects without `npm version`, edit the version file, commit, and tag manually:

```bash
git tag -a vX.Y.Z -m "Release X.Y.Z"
git push --follow-tags
```

Use annotated (`-a`) tags for releases. With `push.followTags` set ([../../configs/git/gitconfig](../../configs/git/gitconfig)), a plain `git push` also sends the tag.

## Step 4 — Create the GitHub Release

```bash
gh release create vX.Y.Z --generate-notes
# attach build artifacts if you produce them:
gh release create vX.Y.Z --generate-notes ./dist/*.tgz
```

`--generate-notes` auto-writes release notes from the PRs/commits since the last tag. Review and edit the notes before publishing — auto-notes are a draft, not the final word. Add a `--title` if you want something other than the tag.

For a pre-release or draft:

```bash
gh release create vX.Y.Z --generate-notes --prerelease   # or --draft to stage it
```

## Step 5 — Verify and announce

```bash
gh release view vX.Y.Z --web
```

- Confirm the tag, notes, and any assets are correct.
- If a publish pipeline (npm publish, container push) runs on release, confirm that workflow went green.

## If the release is wrong

- **Bad notes / metadata:** `gh release edit vX.Y.Z ...` — no history impact.
- **Shipped a broken build:** prefer rolling forward with a new patch release. If you must pull it, `gh release delete vX.Y.Z` and delete the tag (`git push origin --delete vX.Y.Z`) — but anyone who already pulled the tag/artifact still has it, so a forward fix is usually safer.
- A published bad **commit** (not just the release) → [../../playbooks/git/undo-published-commit.md](../../playbooks/git/undo-published-commit.md).
