# Portfolio horizons — open gates (what is still missing)

**Date:** 2026-08-10
**Audience:** founders, eng, ops, website/content
**Source of truth for execution packs:** this folder’s H1–H5 checklists
**Roadmap:** [COORDINATED-PORTFOLIO-ROADMAP.md](../internal/COORDINATED-PORTFOLIO-ROADMAP.md)

Engineering packs for **H1**, **H2**, **H3** (incl. depth harden), **H4 K2**, and optional **H5 preparedness** are **founder rehearsals on a developer host**, not named customer sites. Remaining work is mostly **human / commercial**, plus deliberate product follow-ons that are **not** required to claim those engineering packs.

---

## Summary

| Horizon | Eng status | Still missing |
|---------|------------|---------------|
| **H1** | Founder rehearsal | Optional HelixTest auth-on live (not required) |
| **H2** | Founder rehearsal | Optional HelixTest Auth Level; non-AWS KMS |
| **H3** | Full eng + depth harden | External RA before *marketing* clinical claims; patient-summary OPT pin; Synaptic Four EHR UI (**never** in H) |
| **H4** | K2 eng exit | Counsel send + PRODUCTION flip; named site; field reconcile wiring |
| **H5** | Optional preparedness exit | Paying managed-host customer; multi-tenant (**deferred**); TEE (**sketch only**) |

**Next concrete human action:** send Kenya K1 brief (counsel package (contact Synaptic Four — not published in the public Solum tree)).

**Spine freeze (2026-08-12):** Net-new spine features are frozen. See [SPINE-FREEZE.md](../internal/SPINE-FREEZE.md) and [`synapticfour-business/strategy/org-level-up/ORG-LEVEL-UP-IMPLEMENTATION-PLAN.md`](../../../synapticfour-business/strategy/org-level-up/ORG-LEVEL-UP-IMPLEMENTATION-PLAN.md). Tag legend below: **freeze-ok** = allowed during freeze; **backlog-only** = do not start unless a paying customer / signed pilot requires it; **human** = counsel/commercial, not eng feature work.

---

## Freeze tags (open items)

| Item | Tag | Notes |
|------|-----|-------|
| Optional HelixTest without `HELIXTEST_SKIP_AUTH` | backlog-only | Not required for H1 exit |
| HelixTest Auth Level live | backlog-only | Optional ops gate |
| Non-AWS / EncryptionContext / IRSA depth | backlog-only | AWS optional path exists |
| Kenya K1 brief **sent** + PRODUCTION TOML | human | Counsel + operator |
| Named site MoU / hub H1 at site | human | Commercial |
| Field consent reconcile wiring | freeze-ok | After named site only |
| External RA / MDCG before marketing clinical claims | human | Counsel |
| Patient-summary OPT pin | backlog-only | Modelling follow-on |
| Synaptic Four EHR UI | backlog-only | **Never** in horizon |
| Multi-tenant shared CDR/DRS | backlog-only | H5 deferred |
| TEE / confidential computing | backlog-only | Sketch only |
| Paying managed-host customer | human | Commercial |
| Trust/CI/legal/persona/HELIOS-ingest level-up work | freeze-ok | Org implementation plan |

---

## H1 — Pilot-ready

| Item | Status | Owner |
|------|--------|-------|
| Pilot checklist / execution record | Done | — |
| Optional HelixTest without `HELIXTEST_SKIP_AUTH` | Open (optional) · **backlog-only** | Ops |

## H2 — Production on-prem

| Item | Status | Owner |
|------|--------|-------|
| H2 engineering pack (teeth, org-IAM, ops, KMS optional) | Founder rehearsal | — |
| HelixTest Auth Level live | Open (optional) · **backlog-only** | Ops |
| Non-AWS / EncryptionContext / IRSA depth | Documented outstanding · **backlog-only** | Eng backlog |
| Kenya PRODUCTION | Moved to H4 · **human** | Counsel |

See [H2-KNOWN-LIMITATIONS.md](H2-KNOWN-LIMITATIONS.md).

## H3 — Clinical + genomic co-custody

| Item | Status | Owner |
|------|--------|-------|
| H3.0–H3.6 + depth harden (dual-write, Path E+ smoke, backup/MDCG send pack) | Done | — |
| External RA / MDCG clearance before marketing clinical claims | Open · **human** | Counsel (counsel package (contact Synaptic Four — not published in the public Solum tree)) |
| Patient-summary OPT pin (still `minimal_observation`) | Follow-on · **backlog-only** | Eng ([H3-CLINICAL-MODELLING](https://github.com/SynapticFour/Solum/blob/main/docs/H3-CLINICAL-MODELLING.md)) |
| Synaptic Four hospital EHR UI | Out of scope · **backlog-only (never)** | — |

## H4 — Edge / Kenya

| Item | Status | Owner |
|------|--------|-------|
| K2 technical (tests, offline policy, Edge links, KE fixture) | Done | — |
| K1.3 Brief **sent** to Kenya counsel | Open · **human** | Operator |
| K1.4 Counsel answers → TOML / PRODUCTION | Open · **human** | Counsel + eng |
| K3.1 Named site MoU | Open · **human** | Commercial |
| K3.3 Hub H1 checklist at site | Open · **human** | Site ops |
| K3.4 Field consent reconcile wiring | Open (policy written) · **freeze-ok** after site | Eng after site |
| Nigeria / South Africa profiles | Queued · **backlog-only** | Eng after Kenya K1 or paid reorder |

See [H4-PILOT-CHECKLIST.md](H4-PILOT-CHECKLIST.md).

## H5 — SaaS-*ready* (optional)

| Item | Status | Owner |
|------|--------|-------|
| Checklist, tenant ADR, managed recipe, `SOLUM_TENANT_ID` stamp | Done | — |
| Multi-tenant shared CDR/DRS | Deferred · **backlog-only** | — |
| TEE / confidential computing | Sketch only · **backlog-only** | Future programme |
| Actual managed hosting for a customer | Open · **human** | Commercial |

See [H5-SAAS-READY-CHECKLIST.md](../internal/pilots/H5-SAAS-READY-CHECKLIST.md).

---

## Public / website honesty

When updating [synapticfour-website](https://github.com/SynapticFour/synapticfour-website) Solum copy:

- Kenya profile: **PROVISIONAL** (engineering Vorprüfung) — **not** PRODUCTION / **not** ODPC-certified — pending real counsel. Avoid “draft” if that understates eng status; avoid “production-ready.”
- Do **not** claim MDR, EHDS certification, or SaaS product launch from H3–H5 eng exits.
- Track B / openEHR: optional façade engineering-available; not “Solum is an EHR.”

## Related verification

| Layer | Command |
|-------|---------|
| Solum-Demo interactive + smokes | Sibling: `make up` · `make smoke-all` ([COVERAGE](https://github.com/SynapticFour/Solum-Demo/blob/main/docs/COVERAGE.md)) |
| Showcase Stage-1 orchestration | `make solum-stage` / `scripts/run-solum-stage.sh` |
| H3 Track B live | Solum-Demo `make up-h3` · `make smoke-h3` |

---

## Related checklists

| Pack | Link |
|------|------|
| H3 | [H3-PILOT-CHECKLIST.md](H3-PILOT-CHECKLIST.md) |
| H4 | [H4-PILOT-CHECKLIST.md](H4-PILOT-CHECKLIST.md) |
| H5 | [H5-SAAS-READY-CHECKLIST.md](../internal/pilots/H5-SAAS-READY-CHECKLIST.md) |
