# Checklist: repository hardening

> Walk this after creating a repo that others can see or contribute to (especially public). Each item is yes/no. Concepts: [../../references/github/branch-protection-and-rulesets.md](../../references/github/branch-protection-and-rulesets.md), [../../references/github/repo-security.md](../../references/github/repo-security.md).

## Branch protection (blocking for shared repos)

- [ ] A ruleset (or branch protection) on `main` requires a pull request before merging.
- [ ] Required status check set to the CI job name (e.g. `validate`/`ci`), and the name **matches exactly** — a typo means it silently never gates.
- [ ] Force pushes to `main` blocked; branch deletion blocked.
- [ ] (With collaborators) at least one approval required; stale approvals dismissed on new commits; `CODEOWNERS` review required if used.
- [ ] Conversation resolution required before merge.

## Secrets & dependencies (blocking)

- [ ] Secret scanning + push protection enabled (default on for public; confirm).
- [ ] No secrets currently in the repo or its history (`git grep` + check past commits); any found are rotated, not just deleted.
- [ ] `dependabot.yml` present for dependency + Actions updates ([../../configs/github/dependabot.yml](../../configs/github/dependabot.yml)).
- [ ] Dependabot security alerts enabled.

## Actions security (blocking if the repo uses Actions)

- [ ] Workflows set a least-privilege top-level `permissions:` block (default `contents: read`).
- [ ] Third-party actions pinned to a version (or SHA), not a floating branch.
- [ ] Workflows don't expose secrets to untrusted (forked-PR) runs.

## Hygiene (advisory)

- [ ] Description and topics set (discoverability).
- [ ] `LICENSE` present (or deliberately omitted).
- [ ] PR + issue templates present ([../../configs/github/](../../configs/github/)).
- [ ] `SECURITY.md` present if the project warrants private vulnerability reporting.
- [ ] Unused features disabled (wiki/projects) if you won't use them.
