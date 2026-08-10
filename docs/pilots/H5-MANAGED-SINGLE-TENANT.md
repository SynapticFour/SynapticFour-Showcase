# H5 — Managed single-tenant recipe (“hosted on-prem”)

**Status:** Preparedness runbook (optional H5) — **not** a public SaaS product
**Contracts:** [ADR 0003 — tenant boundaries](../adr/0003-tenant-boundaries.md) · Solum [H5-KEY-CUSTODY-MANAGED.md](https://github.com/SynapticFour/Solum/blob/main/docs/H5-KEY-CUSTODY-MANAGED.md)
**Lab Kit:** [DEPLOYMENT-TARGETS.md](https://github.com/SynapticFour/Ferrum-Lab-Kit/blob/main/docs/DEPLOYMENT-TARGETS.md)

## What we offer when a customer asks “can you host it?”

Run a **dedicated** stack for that customer only:

- Isolated VPC / project / subscription (or dedicated bare metal)
- One Ferrum gateway (+ optional UI), one Solum sidecar, optional EHRbase (hub-class), dedicated Postgres volumes
- Customer-controlled keys (preferred) or customer CMK
- Jurisdiction profile matching the site (`eu-ehds`, provisional `kenya-dpa`, …)
- Unique secrets: `SOLUM_SIDECAR_TOKEN`, DB passwords, JWT signing, Crypt4GH key dirs

That is **managed single-tenant** = hosted on-prem. It is **not** multi-tenant shared CDR/DRS.

## Bring-up outline

1. Agree residency region + Solum profile; set `SOLUM_STORAGE_REGION` accordingly.
2. Provision dedicated compose/Helm (Lab Kit `lab-kit generate compose|helm` or Showcase golden-path pins).
3. Generate CustomerHeld keys (`solum crypto keygen`); store outside the image.
4. Set `SOLUM_TENANT_ID=<opaque-customer-id>` for audit correlation (optional).
5. Wire Ferrum `[solum]` if consent teeth are required.
6. Backup: Ferrum FIELD-OPS / Solum audit+consent+CDR dumps — per tenant, never pooled.
7. Support boundary: Synaptic Four ops reach the tenant stack only under contract; customer remains controller for ODPC/DPIA obligations.

## Multi-tenant

**Deferred.** Do not share Solum JSONL stores or one EHRbase across customers. Reopen only after single-tenant managed is operationally boring.

## Non-claims

- Not MDR / ODPC / EHDS certification
- Not TEE / confidential computing
- Not “SaaS-default” commercial model
