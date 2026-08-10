# H2 — Execution record (full exit)

**Status:** **SIGNED OFF — full H2 exit** (2026-08-06)
**Checklist:** [H2-PILOT-CHECKLIST.md](H2-PILOT-CHECKLIST.md)
**Limitations:** [H2-KNOWN-LIMITATIONS.md](H2-KNOWN-LIMITATIONS.md)
**Ops:** [H2-OPS-RUNBOOK.md](H2-OPS-RUNBOOK.md)
**Second pass (closed B–D):** [H2-SECOND-PASS.md](H2-SECOND-PASS.md)
**Observability:** [observability/README.md](observability/README.md)
**Contracts:** [ADR 0001](../adr/0001-solum-ferrum-consent-access.md) · [ADR 0002](../adr/0002-solum-org-iam-cap.md)

Spine v1 + H2.1 Teeth + H2.2 Org CAP + H2.3 Ops polish + H2.4 KMS + second-pass observability / HELIOS clinical / CLI org-IAM decision.

---

## Sign-off summary

| Field | Value |
|-------|-------|
| Host | Synaptic Four ops — MacBook-Air-von-Alexander (pilot-local + docker TES) |
| Operator | Synaptic Four eng |
| Date | 2026-08-06 |
| Ferrum (spine) | `49aab603` — WES fail-closed + pilot issuer fix |
| Ferrum (H2.1) | `e638214b` — `SolumConsentClient` + DRS/WES hooks |
| Solum (H2.1 docs) | `9b8ce7f` |
| Solum (H2.2) | `545711c` |
| Solum (H2.4) | `c9c7082` (+ multi-cloud honesty `c3becb4`) |
| Showcase (H2.2) | `3f80d94` — ADR 0001/0002 + `h21-teeth` / `h22-org-cap` |
| Showcase (H2.3) | `40c80f9` — ops polish + second-pass backlog |
| Showcase (H2.4) | `050037c` |
| Showcase (H2 exit) | `03caccb` — observability + second-pass B–D + sign-off |
| HELIOS | `bd729a6` — `CLIN-ACCESS-001` |

---

## Evidence — spine v1

| Check | Result |
|-------|--------|
| Unauthenticated `GET /ga4gh/wes/v1/runs` | **401** |
| Unauthenticated `POST /ga4gh/wes/v1/runs` | **401** |
| Bearer Passport CWL submit | **COMPLETE** |
| Bearer ingest without `ferrum:collector` | **403** |

---

## Evidence — H2.1 Teeth

| Check | Result |
|-------|--------|
| Ferrum solum_consent unit/integration tests | **10 passed** |
| Live DRS grant → revoke | **200** → **403** `solum consent denied` |

---

## Evidence — H2.2 Org CAP

| Check | Result |
|-------|--------|
| `solum-identity` org_cap unit tests | **3 passed** |
| `solum-auth-verify` groups claims | **2 passed** |
| `solum-sidecar` `org_iam_*` HTTP tests | **3 passed** (mapped group → 201; capability-only → 403; no Bearer → 401) |
| `make h22-org-cap` | mapping artefact gate |

---

## Evidence — H2.3 Ops polish

| Check | Result |
|-------|--------|
| Collector visa paths documented (Edge + IdP) | **pass** — ops runbook §2.1 |
| Thin health/metrics curls documented | **pass** — ops runbook §5 |
| Second-pass backlog for full H2 exit | **pass** — [H2-SECOND-PASS.md](H2-SECOND-PASS.md) |
| `make h23-ops-polish` | artefact gate |

---

## Evidence — H2.4 KMS + second-pass B–D

| Check | Result |
|-------|--------|
| Solum `aws-kms` CLI/sidecar (mocked tests) | **pass** — feature-gated; on-prem CustomerHeld remains default |
| Multi-cloud honesty (on-prem default; Azure/Alibaba/Hetzner/custom) | **pass** — CRYPTO / SECURITY-OVERVIEW / SIDECAR docs |
| Observability blackbox + alerts | **pass** — [observability/](observability/) |
| HELIOS `CLIN-ACCESS-001` | **pass** — unit tests over Solum chain export |
| CLI org-IAM | **wontfix / intentional** — ADR 0002 |

---

## Code / docs landed

- Solum: org CAP, Kenya counsel packs, H2.4 `aws-kms`, on-prem / multi-cloud custody honesty
- Showcase: ADRs, ops runbook, observability pack, H2 exit docs
- HELIOS: `helios.checks.clinical_access`

---

## Explicitly outstanding (not H2 blockers)

See [H2-SECOND-PASS.md](H2-SECOND-PASS.md) “Outstanding after H2 exit”:

- Kenya counsel verification / ODPC PRODUCTION (H4)
- EncryptionContext / AAD; IRSA/`aws-config`
- Ferrum native `/metrics`; non-AWS KMS providers
- HelixTest Auth Level live (optional); SAML if demanded
