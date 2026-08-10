# H5 — SaaS-*ready* checklist (optional / backseat)

**Horizon:** H5 from [COORDINATED-PORTFOLIO-ROADMAP.md](../COORDINATED-PORTFOLIO-ROADMAP.md)
**Depends on:** On-prem H1–H3 usable; H4 counsel/site gates independent
**Posture:** **Optional.** On-prem first remains the product story. H5 prepares a short path to **managed single-tenant** hosting — **not** a SaaS launch or commercial default.

**Contracts:** [ADR 0003 — tenant boundaries](../adr/0003-tenant-boundaries.md) · [H5-MANAGED-SINGLE-TENANT.md](H5-MANAGED-SINGLE-TENANT.md) · Solum [H5-KEY-CUSTODY-MANAGED.md](https://github.com/SynapticFour/Solum/blob/main/docs/H5-KEY-CUSTODY-MANAGED.md)

---

## Explicit non-goals

- Public multi-tenant SaaS or shared Solum/Ferrum SoR across customers
- Flipping GTM to “SaaS-default”
- MDR / ODPC / EHDS claims from “we can host it”
- Implementing TEE / confidential computing in this horizon
- Nigeria/SA jurisdiction packs (still H4 queue)

---

## Definition of done

### H5.0 — Honesty spine

| # | Workstream | Done? | Notes |
|---|------------|-------|-------|
| 5.0.1 | This checklist + execution record | [x] | Optional horizon labelled |
| 5.0.2 | Roadmap links H5 artefacts | [x] | COORDINATED-PORTFOLIO-ROADMAP |

### H5.1 — Tenancy boundaries

| # | Workstream | Done? | Notes |
|---|------------|-------|-------|
| 5.1.1 | Portfolio `tenant_id` convention (ADR) | [x] | [ADR 0003](../adr/0003-tenant-boundaries.md) |
| 5.1.2 | Solum: one deployment = one tenant; optional `SOLUM_TENANT_ID` audit stamp | [x] | Metadata only — no cross-tenant routing |
| 5.1.3 | Ferrum: managed install = deployment/workspace boundary | [x] | customer-runbook note |
| 5.1.4 | ga4gh-infra / HELIOS honesty | [x] | Tenant-scoped IdP / reports = future; one deployment per customer today |

### H5.2 — Key custody + attestation sketch

| # | Workstream | Done? | Notes |
|---|------------|-------|-------|
| 5.2.1 | Managed key-custody doc | [x] | Solum H5-KEY-CUSTODY-MANAGED.md |
| 5.2.2 | TEE / honest-ZK sketch | [x] | Docs only — not claimed, not coded |

### H5.3 — Single-tenant managed recipe

| # | Workstream | Done? | Notes |
|---|------------|-------|-------|
| 5.3.1 | Managed single-tenant runbook | [x] | [H5-MANAGED-SINGLE-TENANT.md](H5-MANAGED-SINGLE-TENANT.md) |
| 5.3.2 | Lab Kit / compose = hosted on-prem note | [x] | Ferrum-Lab-Kit DEPLOYMENT-TARGETS |
| 5.3.3 | Multi-tenant shared CDR | [ ] | **Deferred** until single-tenant managed is boring |

---

## Honest exit

**H5 preparedness exit** — a customer asking “can you host it?” gets a **documented managed single-tenant** path (dedicated stack = hosted on-prem) without redesigning products. Still **no** SaaS product, **no** multi-tenant SoR, **no** compliance claims from hosting alone.

---

## Sign-off (optional horizon)

| Field | Value |
|-------|-------|
| Host | Synaptic Four eng |
| Date | 2026-08-10 |
| Evidence | [H5-EXECUTION-RECORD.md](H5-EXECUTION-RECORD.md) |
| Priority | Backseat — H4 counsel / paid on-prem outrank |
