# Spine freeze — commercial platform

**Status:** Accepted
**Date:** 2026-08-12
**Audience:** founders, eng, ops, agents
**Related:** [COORDINATED-PORTFOLIO-ROADMAP](./COORDINATED-PORTFOLIO-ROADMAP.md) · [HORIZON-OPEN-GATES](../pilots/HORIZON-OPEN-GATES.md) · workspace [`ORG-LEVEL-UP-IMPLEMENTATION-PLAN.md`](../../../ORG-LEVEL-UP-IMPLEMENTATION-PLAN.md)

## Decision

Until the org level-up exit criteria are met, **net-new feature work on the commercial spine is frozen**.

Engineering exits for **H1**, **H2**, **H3** (incl. depth harden), **H4 K2**, and optional **H5 preparedness** are already signed off. Remaining horizon work is mostly **human / commercial** (counsel, RA, MoU, reference customer).

### Freeze-ok (allowed)

| Category | Examples |
|----------|----------|
| Trust & security docs | Threat models, IR runbooks, key-custody one-pagers |
| Supply-chain honesty | cargo-deny/audit in CI, SBOM, fix COMPLIANCE claims |
| Ops / DR | Restore drills, customer DR packs, compatibility policy |
| Commercial packaging | DPA/pilot attach, persona kits, support tiers, co-custody buyer docs |
| Narrow synergy eng | BRA → `solum_subject_id` wire; HELIOS ingest of Solum audit → signed report |
| Bugfixes / security patches | CVEs, pilot-blocking defects |
| Open gates that are human | Kenya counsel send, external RA — tracked, not “new product” |

### Backlog-only (do not start unless a paying customer or signed pilot requires it)

| Item | Notes |
|------|-------|
| Non-AWS KMS / IRSA depth | Documented outstanding; AWS optional path exists |
| HelixTest auth-on live (optional) | Not required for H1/H2 exit |
| Patient-summary OPT pin | Follow-on modelling |
| Synaptic Four EHR UI | **Never** in horizon scope |
| Multi-tenant shared CDR/DRS | H5 deferred |
| TEE / confidential computing | Sketch only |
| Nigeria / SA Solum profiles | Queued after Kenya PRODUCTION or paid reorder |
| New genomic / clinical platform features | Out of freeze |

### Explicit non-goals during freeze

- New satellite GTM (Mycelium, SecureCollab, CLRP, NeuroAttune mixed into hospital decks)
- Merging product repos into a monorepo
- Claiming EHDS/MDR/ISO compliance from Evidence Packs alone

## Exit

See org plan success criteria. When trust pack + commercial pack + persona kits + co-custody story + reference path + HELIOS Solum recipe + website fencing + CI honesty are done, founder may thaw selected backlog items deliberately.
