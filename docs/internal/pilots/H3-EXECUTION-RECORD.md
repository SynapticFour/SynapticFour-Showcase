# H3 — Execution record

**Status:** **H3 engineering exit (founder rehearsal)** 2026-08-10 — not a customer EHR site
**Checklist:** [H3-PILOT-CHECKLIST.md](H3-PILOT-CHECKLIST.md)

---

## Sign-off summary

| Field | Value |
|-------|-------|
| Host | Founder workstation — local Docker Desktop |
| Operator | Synaptic Four eng |
| Date | 2026-08-10 |
| EHRbase pin | `ehrbase/ehrbase:2.34.0` |
| Evidence | Automated tests + fixtures below |
| Notes | External RA counsel / MDR claims still open; no Synaptic Four EHR UI |

---

## H3.0

| # | Result |
|---|--------|
| Compose + pins + façade + audit | Signed earlier same day; live smoke through Solum → EHRbase |

## H3.1 — FHIR + AQL

| Evidence | Detail |
|----------|--------|
| Code | `POST/GET /v1/fhir/{type}`, `POST /v1/cdr/aql` + allowlist |
| Tests | Sidecar HTTP suite includes FHIR create/get, AQL reject/allow (21 tests total) |
| Docs | SIDECAR-INTEGRATION Track B section |

## H3.2 — Migration

| Evidence | Detail |
|----------|--------|
| CLI | `solum migrate fhir-import`, `solum migrate dual-write-stub` |
| Docs | [MIGRATION-CUTOVER-CHECKLIST.md](https://github.com/SynapticFour/Solum/blob/main/docs/MIGRATION-CUTOVER-CHECKLIST.md) |
| Unit | `solum-core` migrate extract tests |

## H3.3 — Subject bridge

| Evidence | Detail |
|----------|--------|
| ADR | Solum `docs/adr/0003-subject-bridge.md` |
| API | `/v1/cdr/subject-link` (+ HTTP test) |
| Ferrum | `docs/customer-runbook.md` note: align `solum_subject` ↔ `solum_subject_id` |

## H3.4 — Partner API

| Evidence | Detail |
|----------|--------|
| Doc | Solum `docs/customer/PARTNER-EHR-API.md` |

## H3.5 — Path E+

| Evidence | Detail |
|----------|--------|
| Fixtures | `fixtures/ci/solum-cdr/cdr-composition-fixture.json`, `subject-link-fixture.json` |
| Pack | `evidence-pack.sh --fixtures` includes `--solum-cdr` / `--solum-subject-link` |
| Docs | `docs/for-evaluators/deployment-paths.md` Path E+ |

## H3.6 — MDCG internal review

| Evidence | Detail |
|----------|--------|
| Package | Solum `docs/counsel/H3-MDCG-INTERNAL-REVIEW.md` **SIGNED** (internal) |
| Bound | External RA still required before marketing clinical claims |
