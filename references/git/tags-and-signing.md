# Tags, releases, and signing

**TL;DR:** A tag is a fixed name for a specific commit, used to mark releases (`v1.4.0`). Prefer **annotated** tags (`-a`) over lightweight ones for releases — they're real objects with a tagger, date, message, and can be signed. Tags are not pushed by default. Commits and tags can be cryptographically signed (GPG or SSH) so others can verify authorship.

## Lightweight vs. annotated

- **Lightweight tag** — just a name pointing at a commit, stored as a plain ref. No metadata. Fine for a private bookmark.
- **Annotated tag** — a full tag *object*: tagger name/email, date, message, optional signature. This is what releases should use.

```bash
git tag v1.4.0                          # lightweight
git tag -a v1.4.0 -m "Release 1.4.0"    # annotated (preferred for releases)
git tag                                 # list tags
git tag -n                              # list with annotation messages
git show v1.4.0                         # tag object + the commit it points at
```

`tag.sort = version:refname` (in [../../configs/git/gitconfig](../../configs/git/gitconfig)) makes `git tag` sort `v1.2.10` after `v1.2.9` instead of lexically.

## Pushing tags

Tags are **not** sent by `git push`. Push them explicitly:

```bash
git push origin v1.4.0     # one tag
git push --tags            # all local tags
```

With `push.followTags = true` (shipped gitconfig), `git push` also sends annotated tags that point at commits being pushed — the usual desired behavior without pushing every stray local tag.

Delete:

```bash
git tag -d v1.4.0                  # delete locally
git push origin --delete v1.4.0    # delete on the remote
```

## Signing commits and tags

Signing proves a commit/tag came from you. Two backends:

```bash
# --- SSH signing (simplest if you already have an SSH key) ---
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
# --- or GPG signing ---
git config --global gpg.format openpgp
git config --global user.signingkey <GPG-key-id>

git config --global commit.gpgsign true   # sign all commits
git config --global tag.gpgsign true       # sign all tags

git commit -S -m "..."     # sign one commit explicitly
git tag -s v1.4.0 -m "..." # signed annotated tag
git verify-tag v1.4.0      # verify a tag's signature
git log --show-signature   # show verification per commit
```

GitHub shows a **Verified** badge once you upload the corresponding public key (SSH or GPG) and the email matches. SSH signing is usually the lowest-friction path since most people already have an SSH key.

> The toolbox's shipped gitconfig does **not** enable signing by default, because it needs a per-machine key. Enable it once your key is set up.

## Releases (the GitHub layer)

A Git tag is the anchor; a GitHub *Release* attaches notes and built artifacts to a tag. That platform layer (the `gh release` flow, release notes, assets) belongs to the GitHub domain — see `resources/github/` when it's built.

## How I use it

- Annotated, semver tags for releases: `git tag -a vMAJOR.MINOR.PATCH -m`.
- `push.followTags` so release tags travel with the release commit, not a separate step to forget.
- SSH commit/tag signing on machines where my key is set up, for the Verified badge and authorship integrity.

## Links

- [Pro Git — Tagging](https://git-scm.com/book/en/v2/Git-Basics-Tagging)
- [Pro Git — Signing Your Work](https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work)
- [GitHub — About commit signature verification](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification)
