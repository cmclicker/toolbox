# `playbooks/`

> Multi-step procedures with branches and judgment calls. Narrative shape — distinct from a [checklist](../checklists/), which is pure yes/no verification.

## What lives here

Procedures with shape: "when X happens, do these steps in order; at step 3, depending on Y, branch." The canonical sequence *and* the reasoning, so you can follow it under pressure without re-thinking it.

Examples:
- `playbooks/git/recover-from-bad-rebase.md` — reflog → identify good commit → reset → verify.
- `playbooks/dependency-upgrade.md` — read changelog → assess breaks → update → test → propagate.
- `playbooks/release.md` — bump → changelog → tag → publish → verify → announce.
- `playbooks/incident-response.md` — assess severity → mitigate → communicate → post-mortem.

## What does NOT live here

| Type | Where it goes | Why |
|---|---|---|
| A pure yes/no verification list | [checklists/](../checklists/) | Different shape |
| A one-off runbook for a single project | (that project's repo) | Not reusable |
| Doctrine about *why* the procedure exists | [references/](../references/) | Explanation, not procedure |

The test: **does it have judgment calls or branches?** Yes → playbook. Purely linear yes/no → checklist.

## Shape of a file

1. Trigger — when does this apply?
2. Numbered steps, each with the *why*, not just the *what*.
3. Decision points marked explicitly ("if A → step 4; if B → step 7").
4. Inline templates where the procedure produces an artifact (e.g. a post-mortem).
5. A rough time estimate.

## Keeping them honest

After every real run, update the playbook with whatever was missing or wrong, and note when steps were last verified. A playbook step may invoke a checklist — link to it.

## Sharding

By domain, lazily: `playbooks/git/`, `playbooks/release/`, `playbooks/incident/`, `playbooks/data/`. File names are verb-or-event phrases.

## See also

- [ARTIFACTS.md](../ARTIFACTS.md) — taxonomy.
- [checklists/](../checklists/) — for binary verification lists.
