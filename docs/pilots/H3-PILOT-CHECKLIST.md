# H3 — Clinical + genomic co-custody checklist

**Horizon:** H3 from [COORDINATED-PORTFOLIO-ROADMAP.md](../internal/COORDINATED-PORTFOLIO-ROADMAP.md)
**Depends on:** [H2 founder rehearsal](../internal/pilots/H2-EXECUTION-RECORD.md)
**Not H3:** Kenya PRODUCTION profile (H4), SaaS launch (H5), full Synaptic Four EHR UI

Architecture (Solum): [ADR 0001](https://github.com/SynapticFour/Solum/blob/main/docs/adr/0001-openehr-cdr-and-migration.md) · [ADR 0002 EHRbase](https://github.com/SynapticFour/Solum/blob/main/docs/adr/0002-cdr-engine-ehrbase.md) · [ADR 0003 subject bridge](https://github.com/SynapticFour/Solum/blob/main/docs/adr/0003-subject-bridge.md) · [H3-EHRBASE-SPIKE.md](https://github.com/SynapticFour/Solum/blob/main/docs/H3-EHRBASE-SPIKE.md)

---

## Definition of done

### H3.0 — First slice (ADR 0002 steps 1–4)

| # | Workstream | Done? | Notes |
|---|------------|-------|-------|
| 3.0.1 | EHRbase + Postgres compose (dev-local) | [x] | Solum-Demo `docker-compose.ehrbase.yml` |
| 3.0.2 | Image pins in Solum `VERSIONS` | [x] | `ehrbase:2.34.0` + `ehrbase-v2-postgres:16.2` |
| 3.0.3 | Minimal Solum façade write/read (one pinned template) | [x] | `solum-openehr` + sidecar `/v1/cdr/*` |
| 3.0.4 | Audit on façade write | [x] | `cdr.ehr.created` / `cdr.composition.committed` |
| 3.0.5 | H3.0 sign-off | [x] | [H3-EXECUTION-RECORD.md](../internal/pilots/H3-EXECUTION-RECORD.md) |

### Full H3 MVP

| # | Workstream | Done? | Notes |
|---|------------|-------|-------|
| 3.1 | FHIR façade subset + AQL read proxy | [x] | `/v1/fhir/*`, `/v1/cdr/aql` |
| 3.2 | Migration toolkit (import + dual-write + cutover checklist) | [x] | `solum migrate` + cutover doc |
| 3.3 | Subject bridge (pseudonym / Phenopacket ↔ Ferrum DRS) | [x] | ADR 0003 + `/v1/cdr/subject-link` |
| 3.4 | Partner “build EHR UI on Solum” API docs | [x] | PARTNER-EHR-API.md |
| 3.5 | Showcase Path E+ (CDR fixture + genomic link) | [x] | `fixtures/ci/solum-cdr/` |
| 3.6 | MDCG guardrails review before clinical claims | [x] | Internal package signed; external RA send pack ready; clearance still open |

### H3 depth harden (post engineering-exit)

| # | Workstream | Done? | Notes |
|---|------------|-------|-------|
| 3.h1 | Clinical modelling honesty + Patient→subject-link | [x] | [H3-CLINICAL-MODELLING.md](https://github.com/SynapticFour/Solum/blob/main/docs/H3-CLINICAL-MODELLING.md); still `minimal_observation` pin |
| 3.h2 | Live dual-write webhook | [x] | `POST /v1/migrate/dual-write` → 201 / 202+dead-letter |
| 3.h3 | Ferrum subject key constants + runbook | [x] | `SOLUM_SUBJECT_METADATA_KEY` aligned to Patient.id |
| 3.h4 | Live Path E+ smoke | [x] | Showcase `make path-eplus-smoke` (soft-fail) |
| 3.h5 | Backup runbook + MDCG send checklist | [x] | [H3-EHRBASE-BACKUP.md](https://github.com/SynapticFour/Solum/blob/main/docs/H3-EHRBASE-BACKUP.md) · counsel package (contact Synaptic Four — not published in the public Solum tree) |

**Honest scope:** Full H3 **engineering exit** + depth harden — greenfield clinic can store clinical + link genomic via APIs; brownfield can start mirror with live dual-write. Still **no** Synaptic Four EHR UI, **no** patient-summary OPT pin, and **no** MDR/external counsel clearance.

---

## Sign-off (full H3 engineering)

| Field | Value |
|-------|-------|
| Host | Synaptic Four ops — local Docker Desktop |
| Operator | Synaptic Four eng |
| Date | 2026-08-10 |
| Solum | H3.0–H3.6 working tree |
| EHRbase pin | `ehrbase/ehrbase:2.34.0` |
| Evidence | [H3-EXECUTION-RECORD.md](../internal/pilots/H3-EXECUTION-RECORD.md) |
| Notes | External RA counsel before marketing clinical claims remains open |

---

## Exit → next

- After **full H3:** H4 geography / Kenya counsel remains independent ([H4-GEOGRAPHY-DECISION.md](H4-GEOGRAPHY-DECISION.md)).
