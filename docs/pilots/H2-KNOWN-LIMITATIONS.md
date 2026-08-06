# H2 — Known limitations

**Date:** 2026-08-06
**Companion:** [H2-PILOT-CHECKLIST.md](H2-PILOT-CHECKLIST.md) · [H2-EXECUTION-RECORD.md](H2-EXECUTION-RECORD.md)

H2 **spine v1** + **H2.1 Teeth** + **H2.2 Org CAP** + **H2.3 Ops polish** are signed. This is still **not** the full roadmap exit — see [H2-SECOND-PASS.md](H2-SECOND-PASS.md).

| Area | Status |
|------|--------|
| WES anonymous list/submit under `require_auth` | **Closed** — HTTP 401 without Bearer |
| Solum revoke → Ferrum DRS/WES deny | **Closed (H2.1)** when `FERRUM_SOLUM__*` enabled — see [ADR 0001](../adr/0001-solum-ferrum-consent-access.md) |
| OIDC groups → Solum capabilities | **Closed (H2.2)** when sidecar `--org-iam-config` + JWKS — see [ADR 0002](../adr/0002-solum-org-iam-cap.md) |
| Collector visa operator how-to | **Closed (H2.3)** — Edge account + IdP paths in [H2-OPS-RUNBOOK.md](H2-OPS-RUNBOOK.md) §2.1 |
| Ingest without `ferrum:collector` | Still **403** (correct); mock-idp Passports lack collector visa by design |
| Thin health checks | **Closed (H2.3)** — gateway `/health` + optional Solum status curl; not Prometheus |
| Solum KMS CLI/sidecar | **Closed (H2.4)** optional `--features aws-kms` — wrap-seed / `--wrapped-keypair` / `--wrapped-keys-dir`; not HSM |
| Zeroize | **Best-effort** ZeroizeOnDrop on held seeds; not a TEE / not proof against memory dump |
| CLI CAP_* | Still `--capability` (offline); org-IAM is sidecar-only — second pass decision |
| SAML | ga4gh-infra: OIDC bridge only; SAML via Keycloak if demanded |
| HELIOS clinical evidence types | **Second pass** |
| Observability (Prometheus/alerts) | **Second pass** — thin curls only in H2.3 |
| HelixTest Auth Level live | Optional; not required for this sign-off |

## Claims ban

Do **not** claim: production SoR, EHDS certification, or “HSM-backed Solum” from this pack alone. Consent enforcement across Ferrum applies **only** when Solum integration is configured and bindings resolve. Org CAP applies **only** when sidecar org-IAM is enabled.
