# H2 — Execution record (spine v1 + H2.1 + H2.2)

**Status:** **SIGNED OFF** — H2 spine v1 + **H2.1 Teeth** + **H2.2 Org CAP** (2026-08-06)
**Checklist:** [H2-PILOT-CHECKLIST.md](H2-PILOT-CHECKLIST.md)
**Limitations:** [H2-KNOWN-LIMITATIONS.md](H2-KNOWN-LIMITATIONS.md)
**Ops:** [H2-OPS-RUNBOOK.md](H2-OPS-RUNBOOK.md)
**Contracts:** [ADR 0001](../adr/0001-solum-ferrum-consent-access.md) · [ADR 0002](../adr/0002-solum-org-iam-cap.md)

Not the full roadmap exit (KMS CLI, observability). See limitations.

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
| Showcase | ADR 0001/0002 + `h21-teeth` / `h22-org-cap` scripts |

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

## Code / docs landed

- Solum: org CAP TOML mapper, auth-verify groups, sidecar `--org-iam-config` + JWKS
- Showcase: ADR 0002, H2 honesty updates, `scripts/run-h22-org-cap.sh`

---

## Explicitly still open (not this sign-off)

- Solum KMS CLI/sidecar wiring
- HELIOS clinical evidence types + observability baseline
- HelixTest Auth Level live (optional)
- CLI org-IAM (intentionally sidecar-only)
