# Line endings: CRLF, LF, and `.gitattributes` (Windows-relevant)

**TL;DR:** Windows tools tend to write CRLF (`\r\n`) line endings; Linux/macOS and most repos use LF (`\n`). Left unmanaged, this produces spurious whole-file diffs and "the working copy will be replaced" warnings. The portable fix is a committed `.gitattributes` with `* text=auto`, which normalizes line endings to LF *in the repository* regardless of each contributor's `core.autocrlf` setting. Prefer `.gitattributes` over relying on `core.autocrlf`.

## The two controls

**`core.autocrlf`** — a per-machine config setting:

- `true` — convert CRLF→LF on commit (into the repo), LF→CRLF on checkout (onto disk). The Git for Windows installer sets this at the **system** level by default.
- `input` — convert CRLF→LF on commit, no conversion on checkout. Common on Linux/macOS.
- `false` — no conversion in either direction.

**`.gitattributes`** — a file committed to the repo, so it applies to every clone and overrides per-machine `core.autocrlf` for the paths it matches:

```gitattributes
# Normalize all text files to LF in the repository; Git detects text vs binary.
* text=auto

# Force specific types (don't rely on detection) — examples:
*.sh   text eol=lf      # shell scripts must stay LF even when checked out on Windows
*.bat  text eol=crlf    # Windows batch files need CRLF
*.png  binary           # never touch binary files
```

`text=auto` means "treat as text if Git detects text content, and store it with LF." `eol=lf`/`eol=crlf` force the working-tree ending for matched files regardless of platform. `binary` is shorthand for `-text -diff` (no conversion, no textual diff).

## Why `.gitattributes` is preferred over `core.autocrlf`

`core.autocrlf` is set independently on each contributor's machine, so the repository's stored line endings depend on who committed and how their Git was configured — inconsistent and invisible. `.gitattributes` is committed and version-controlled, so normalization is identical for everyone and survives a fresh clone. With `* text=auto` in place, a contributor's `core.autocrlf` value stops mattering for the repository's stored content.

## The warning you will see, and what it means

```
warning: in the working copy of 'f.txt', LF will be replaced by CRLF the next time Git touches it
```

This is informational, not an error. It means: this machine's config (e.g. `core.autocrlf=true`) will check the file out with CRLF, but the repository stores it with LF. The repository content is correct; only your on-disk copy differs. It is safe.

## Fixing a repo that already has mixed/CRLF content

Adding `.gitattributes` does not rewrite files already committed. Re-normalize once after adding it:

```bash
# After committing .gitattributes with `* text=auto`:
git add --renormalize .
git status        # shows files whose stored line endings changed
git commit -m "Normalize line endings to LF via .gitattributes"
```

`--renormalize` re-applies the attributes to every tracked file and stages only those whose stored form changes.

## Diagnosing

```bash
git config --show-origin --get core.autocrlf   # effective value AND which config file set it
git ls-files --eol                             # per-file: index eol (i/) and working-tree eol (w/)
git check-attr text eol -- path/to/file        # what attributes apply to a path
```

`git ls-files --eol` is the definitive check: `i/lf` means the stored (index) copy is LF; `w/crlf` means the on-disk copy is CRLF. With normalization done correctly, the index column should be `lf` for text files.

## How I use it

- Commit `* text=auto` in `.gitattributes` to every repo, plus `eol=lf` for shell scripts and `eol=crlf` for `.bat`/`.cmd`. A reusable template is in [../../configs/git/gitattributes](../../configs/git/gitattributes).
- Treat the CRLF warning as informational once `.gitattributes` is in place.
- Don't depend on `core.autocrlf` for correctness; it's a per-machine convenience, while `.gitattributes` is the contract.

## Links

- [GitHub Docs — Configuring Git to handle line endings](https://docs.github.com/en/get-started/git-basics/configuring-git-to-handle-line-endings)
- [Pro Git — Git Attributes](https://git-scm.com/book/en/v2/Customizing-Git-Git-Attributes)
