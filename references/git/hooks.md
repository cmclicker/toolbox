# Git hooks

**TL;DR:** Hooks are scripts Git runs automatically at points in its lifecycle (before a commit, before a push, after a merge…). They live in `.git/hooks/`, are **not committed** and **not shared** by default, and a non-zero exit from a "pre-" hook aborts the operation. To share hooks across a team, point `core.hooksPath` at a tracked directory or use a manager.

## How they work

Each hook is an executable file in `.git/hooks/` named exactly for its trigger (no extension). Git ships `.sample` versions there; remove the suffix to activate. The script's exit status matters for "pre-" hooks: **non-zero aborts** the action.

Common client-side hooks:

| Hook | Fires | Typical use | Abort on non-zero? |
|---|---|---|---|
| `pre-commit` | before the commit message is requested | lint, format, run fast tests, block secrets | yes |
| `prepare-commit-msg` | before the editor opens | insert a template / ticket number | yes |
| `commit-msg` | after the message is written | validate message format (e.g. Conventional Commits) | yes |
| `pre-push` | before objects are sent | run tests, block pushing to protected branches | yes |
| `post-merge` / `post-checkout` | after the action | reinstall deps if lockfile changed | no |

A sample `pre-commit` hook is in [../../snippets/git/hooks/pre-commit.sh](../../snippets/git/hooks/pre-commit.sh).

## The sharing problem

`.git/hooks/` is inside `.git/`, so hooks are **not** version-controlled and a fresh clone has none. Three ways to share them:

1. **`core.hooksPath`** — commit a `.githooks/` directory and point Git at it:
   ```bash
   git config core.hooksPath .githooks
   ```
   Simple and dependency-free, but each clone must run that `config` once (or your setup script does).
2. **A hook manager** — e.g. Husky (Node) or pre-commit (Python). These wire up `core.hooksPath` automatically on install and manage hook definitions in a config file. Worth it for teams; overkill for solo scripts.
3. **A repo setup script** that installs hooks — the manual version of (2).

## Important limits

- **Hooks are not a security boundary.** They run on the author's machine and anyone can bypass them with `--no-verify` (`git commit -n`, `git push --no-verify`). Treat them as convenience/early-warning, not enforcement.
- **Real enforcement lives server-side** — branch protection rules and required CI checks on the remote (GitHub) cannot be bypassed locally. Use hooks to catch problems early; rely on CI/branch protection to actually block them. See the repo-hardening items in [../../checklists/git/new-repo-setup.md](../../checklists/git/new-repo-setup.md).
- Keep `pre-commit` **fast** (lint/format/secret-scan, not the full test suite) or people will `--no-verify` it. Put slower checks in `pre-push` or CI.

## How I use it

- A fast `pre-commit` for formatting + secret scanning; heavier checks in CI.
- `core.hooksPath = .githooks` with committed hooks for shared repos, so a fresh clone is one config command (run by setup) away from protected.
- Never rely on a hook for anything that *must* hold — that's a server-side branch-protection / CI job.

## Links

- [Pro Git — Git Hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)
- [`githooks` docs](https://git-scm.com/docs/githooks)
