# Portfolio horizons — open gates (what is still missing)

**Date:** 2026-08-10
**Audience:** founders, eng, ops, website/content
**Source of truth for execution packs:** this folder’s H1–H5 checklists
**Roadmap:** [COORDINATED-PORTFOLIO-ROADMAP.md](../COORDINATED-PORTFOLIO-ROADMAP.md)

Engineering exits for **H1**, **H2**, **H3** (incl. depth harden), **H4 K2**, and optional **H5 preparedness** are done. Remaining work is mostly **human / commercial**, plus deliberate product follow-ons that are **not** required to claim those engineering exits.

---

## Summary

| Horizon | Eng status | Still missing |
|---------|------------|---------------|
| **H1** | Signed off | Optional HelixTest auth-on live (not required) |
| **H2** | Full exit signed | Optional HelixTest Auth Level; non-AWS KMS; Kenya counsel moved to H4 |
| **H3** | Full eng + depth harden | External RA before *marketing* clinical claims; patient-summary OPT pin; Synaptic Four EHR UI (**never** in H) |
| **H4** | K2 eng exit | Counsel send + PRODUCTION flip; named site; field reconcile wiring |
| **H5** | Optional preparedness exit | Paying managed-host customer; multi-tenant (**deferred**); TEE (**sketch only**) |

**Next concrete human action:** send Kenya K1 brief ([Solum KENYA-K1-SEND-CHECKLIST](https://github.com/SynapticFour/Solum/blob/main/docs/counsel/KENYA-K1-SEND-CHECKLIST.md)).

---

## H1 — Pilot-ready

| Item | Status | Owner |
|------|--------|-------|
| Pilot checklist / execution record | Done | — |
| Optional HelixTest without `HELIXTEST_SKIP_AUTH` | Open (optional) | Ops |

## H2 — Production on-prem

| Item | Status | Owner |
|------|--------|-------|
| Full H2 exit (teeth, org-IAM, ops, KMS optional) | Done | — |
| HelixTest Auth Level live | Open (optional) | Ops |
| Non-AWS / EncryptionContext / IRSA depth | Documented outstanding | Eng backlog |
| Kenya PRODUCTION | Moved to H4 | Counsel |

See [H2-KNOWN-LIMITATIONS.md](H2-KNOWN-LIMITATIONS.md).

## H3 — Clinical + genomic co-custody

| Item | Status | Owner |
|------|--------|-------|
| H3.0–H3.6 + depth harden (dual-write, Path E+ smoke, backup/MDCG send pack) | Done | — |
| External RA / MDCG clearance before marketing clinical claims | Open | Counsel ([H3-MDCG-SEND-CHECKLIST](https://github.com/SynapticFour/Solum/blob/main/docs/counsel/H3-MDCG-SEND-CHECKLIST.md)) |
| Patient-summary OPT pin (still `minimal_observation`) | Follow-on | Eng ([H3-CLINICAL-MODELLING](https://github.com/SynapticFour/Solum/blob/main/docs/H3-CLINICAL-MODELLING.md)) |
| Synaptic Four hospital EHR UI | Out of scope | — |

## H4 — Edge / Kenya

| Item | Status | Owner |
|------|--------|-------|
| K2 technical (tests, offline policy, Edge links, KE fixture) | Done | — |
| K1.3 Brief **sent** to Kenya counsel | Open | Operator |
| K1.4 Counsel answers → TOML / PRODUCTION | Open | Counsel + eng |
| K3.1 Named site MoU | Open | Commercial |
| K3.3 Hub H1 checklist at site | Open | Site ops |
| K3.4 Field consent reconcile wiring | Open (policy written) | Eng after site |
| Nigeria / South Africa profiles | Queued | Eng after Kenya K1 or paid reorder |

See [H4-PILOT-CHECKLIST.md](H4-PILOT-CHECKLIST.md).

## H5 — SaaS-*ready* (optional)

| Item | Status | Owner |
|------|--------|-------|
| Checklist, tenant ADR, managed recipe, `SOLUM_TENANT_ID` stamp | Done | — |
| Multi-tenant shared CDR/DRS | Deferred | — |
| TEE / confidential computing | Sketch only | Future programme |
| Actual managed hosting for a customer | Open | Commercial |

See [H5-SAAS-READY-CHECKLIST.md](H5-SAAS-READY-CHECKLIST.md).

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
| H5 | [H5-SAAS-READY-CHECKLIST.md](H5-SAAS-READY-CHECKLIST.md) |
