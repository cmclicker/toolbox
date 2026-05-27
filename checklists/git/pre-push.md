# Checklist: before `git push`

> Walk this before pushing a branch you intend others (or future-you) to pull. Each item is yes/no. Blocking items must pass.

## Blocking

- [ ] Tests pass locally (`npm test` / project equivalent) — not "should pass," actually ran.
- [ ] Lint / typecheck clean (`npm run lint`, `npm run typecheck` if present).
- [ ] No secrets, tokens, API keys, or `.env` contents staged. (`git diff --cached` to eyeball.)
- [ ] No stray debug output left in (`console.log`, `print`, `dbg!`, commented-out blocks).
- [ ] Pushing the intended branch, not `main`/`master` directly. (`git branch --show-current`)
- [ ] Commit messages are meaningful — they say *why*, not "wip"/"fix"/"stuff".
- [ ] No accidental large/binary files staged (`git status` — check for build output, archives, media).

## Advisory

- [ ] Rebased / squashed noise commits if the branch is going up for review.
- [ ] Branch is up to date with its base (`git fetch && git rebase origin/main`) to surface conflicts now, not in CI.
- [ ] If this opens/updates a PR, the description still matches what the branch does.
