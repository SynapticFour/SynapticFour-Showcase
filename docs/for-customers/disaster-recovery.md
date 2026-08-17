# Disaster recovery — customer pack

**Audience:** operators / procurement evaluating on-prem pilots
**Status:** 2026-08-12 · org level-up **D1**
**Honesty:** Synaptic Four products are **customer-operated**. You own RPO/RTO, offsite copies, and restore drills. This pack consolidates what to back up and where the product runbooks live.

---

## Shared responsibility

| Party | Owns |
|-------|------|
| **Customer** | Hosts, volumes, object store, IdP, Crypt4GH keys, backup media, restore drills, RPO/RTO targets |
| **Synaptic Four** (if support contracted) | Product docs, restore *procedures*, paid upgrade/restore assistance per SOW |

Synaptic Four products are customer-operated. You own RPO/RTO, offsite copies, and restore drills. Product restore procedures live in the product repositories.

---

## What to back up (by plane)

### Ferrum — Edge / SQLite field node

| Asset | How |
|-------|-----|
| SQLite + `objects/` | `ferrum backup create` / `restore` / `verify` — [FIELD-OPS.md](https://github.com/SynapticFour/Ferrum/blob/main/docs/FIELD-OPS.md), ADR-023 |
| Crypt4GH node keys | Separate encrypted offsite (loss ⇒ data unreadable) |
| Config / compose | Pin digests; see [IMAGE-PIN-POLICY](https://github.com/SynapticFour/Ferrum-Lab-Kit/blob/main/docs/IMAGE-PIN-POLICY.md) |

### Ferrum — Hub (Postgres + object store)

| Asset | How |
|-------|-----|
| Postgres | Site `pg_dump` / managed DB snapshots (not Edge CLI) |
| Object store (MinIO/S3) | Bucket versioning or volume snapshots |
| Auth / ga4gh-infra | Infra DB + visa signing material if co-deployed |

H1 pilot timed **MinIO + Solum** restore (~9s) on a founder rehearsal host — not a named customer site. Hub Postgres timing: [H1-RESTORE-DRILL-EXTENDED](../pilots/H1-RESTORE-DRILL-EXTENDED.md).

### Solum — Track A (sidecar stores)

| Asset | How |
|-------|-----|
| Consent / audit / subject-link / FHIR JSONL | File copy with sidecar stopped or consistent snapshot |
| CustomerHeld keys | Offsite; never ephemeral in pilots |

### Solum — Track B (EHRbase CDR)

| Asset | How |
|-------|-----|
| EHRbase Postgres **together with** Solum JSONL | [H3-EHRBASE-BACKUP.md](https://github.com/SynapticFour/Solum/blob/main/docs/H3-EHRBASE-BACKUP.md) |
| Drill checklist | [H3-CDR-BACKUP-DRILL.md](https://github.com/SynapticFour/Solum/blob/main/docs/H3-CDR-BACKUP-DRILL.md) |

Restoring EHRbase alone without Solum stores breaks co-custody evidence.

---

## Recommended cadence

| Activity | Cadence |
|----------|---------|
| Automated backups | Daily (site policy) |
| Offsite / immutable copy | At least weekly |
| Restore drill | Quarterly (H2 ops) + before go-live |
| Key rotation drill | On staff change + annually |

---

## Pilot minimum (before production-like data)

1. Named backup owner + offsite location
2. One successful restore of **object store or Edge backup** + **Solum stores** dated in site runbook
3. If Track B: EHRbase+JSONL drill per H3 runbook
4. IR contacts filled in product [INCIDENT_RESPONSE](https://github.com/SynapticFour/Ferrum/blob/main/docs/INCIDENT_RESPONSE.md) templates

---

## Related

- [key-custody.md](key-custody.md) · [co-custody.md](co-custody.md) · [legal/](legal/)
- [observability.md](observability.md)
- H2 ops: [H2-OPS-RUNBOOK.md](../pilots/H2-OPS-RUNBOOK.md)
