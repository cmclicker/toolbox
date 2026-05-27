# `checklists/`

> Binary "before-X-do-these" verification lists. Each item is a yes/no check. Walked top-to-bottom when forgetting a step is expensive.

## What lives here

Short lists of discrete, verifiable items — for the recurring moments where skipping something hurts: before a push, before a release, before publishing a package, before calling a UI accessible.

Examples:
- `checklists/git/pre-push.md` — before pushing: tests pass, no secrets, branch correct, commit message sane.
- `checklists/npm/pre-publish.md` — before `npm publish`: version bumped, `files` field correct, dry-run clean.
- `checklists/web/a11y-quick-pass.md` — before shipping a UI: contrast, focus order, alt text, keyboard nav.
- `checklists/release/pre-release.md` — before tagging a release.

Each item is binary (did / didn't). No narrative — narrative is a [playbook](../playbooks/).

## What does NOT live here

| Type | Where it goes | Why |
|---|---|---|
| A procedure with branches or judgment | [playbooks/](../playbooks/) | Narrative, not pure verification |
| An explanation of *why* you check this | [references/](../references/) | Doctrine, not the check |

The test: **is each item a discrete yes/no verification?** Yes → checklist. If items have multi-step narratives or branches → playbook.

## Shape of a file

- `- [ ]` checkbox items, each independently verifiable.
- Grouped by phase if there are stages.
- Mark non-blocking items `(advisory)` or put them in a separate section.

## Keeping them honest

- **Items rot** — re-walk after tooling changes; cut stale items.
- **Keep them short** — a 7-item list that always gets walked beats a 30-item one nobody finishes.

## Sharding

By domain/event, lazily: `checklists/git/`, `checklists/npm/`, `checklists/release/`, `checklists/web/`, `checklists/security/`. File names describe the trigger event (`pre-push.md`, `pre-publish.md`).

## See also

- [ARTIFACTS.md](../ARTIFACTS.md) — taxonomy.
- [playbooks/](../playbooks/) — for multi-step narrative procedures.
