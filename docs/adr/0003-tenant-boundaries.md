# ADR 0003 — Portfolio tenant boundaries (H5 preparedness)

**Status:** Accepted
**Date:** 2026-08-10
**Horizon:** H5 (optional / backseat) — **not** a multi-tenant SaaS design

## Context

Roadmap H5 asks for tenancy hygiene so managed hosting is a short path. Products today are **one deployment per customer** (on-prem or dedicated VPC). Shared multi-tenant CDR/DRS would be a different product.

## Decision

| Rule | Meaning |
|------|---------|
| `tenant_id` | Opaque string identifying **one customer deployment** |
| Boundary | One Solum sidecar + stores + (optional) EHRbase + one Ferrum stack = **one tenant** |
| Secrets | Never shared across tenants (sidecar tokens, Crypt4GH keys, DB passwords, JWKS signing keys) |
| Storage | Audit / consent / FHIR / subject-link / CDR data paths are **per deployment** — not row-filtered shared DB |
| Solum stamp | Optional env `SOLUM_TENANT_ID` may be copied into audit `details.tenant_id` for evidence correlation only — **no** routing or ACL by tenant_id |
| Ferrum | Managed install uses deployment/config/workspace scope as the tenant boundary; do not invent shared-schema tenancy in H5 |
| ga4gh-infra / HELIOS | One IdP / report stream per managed deployment today; “tenant-scoped” multi-customer IdP remains future |

## Consequences

- “Can you host it?” → run a **dedicated** stack (managed single-tenant = hosted on-prem). See [H5-MANAGED-SINGLE-TENANT.md](../pilots/H5-MANAGED-SINGLE-TENANT.md).
- Multi-tenant shared SoR stays **out of scope** until explicitly reopened.
- Solum ADR 0001 Track B: SaaS may host Track A/B as managed single-tenant; this ADR does not authorize multi-tenant CDR.

## Links

- [H5-SAAS-READY-CHECKLIST.md](../pilots/H5-SAAS-READY-CHECKLIST.md)
- Solum [ADR 0001](https://github.com/SynapticFour/Solum/blob/main/docs/adr/0001-openehr-cdr-and-migration.md) (CDR / SaaS note)
