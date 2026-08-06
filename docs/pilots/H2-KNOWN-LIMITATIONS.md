# H2 — Known limitations

**Date:** 2026-08-06
**Companion:** [H2-PILOT-CHECKLIST.md](H2-PILOT-CHECKLIST.md) · [H2-EXECUTION-RECORD.md](H2-EXECUTION-RECORD.md)

This sign-off is **H2 spine v1**, not the full roadmap exit (“withdrawal has teeth across planes”).

| Area | Status |
|------|--------|
| WES anonymous list/submit under `require_auth` | **Closed** — HTTP 401 without Bearer |
| Ingest without `ferrum:collector` | Still **403** (correct); mock-idp Passports lack collector visa by design |
| Solum KMS CLI/sidecar | **Not wired** — `AwsKmsKeyProvider` library + `aws-kms` feature only |
| Zeroize | **Best-effort** ZeroizeOnDrop on held seeds; not a TEE / not proof against memory dump |
| OIDC groups → Solum capabilities | **Open** — ADS maps groups → **dataset** grants; Solum CAP_* still supplied by clients |
| Solum revoke → Ferrum DRS/WES deny | **Open** — Showcase consent-gate skips WES in the orchestrator only |
| SAML | ga4gh-infra: OIDC bridge only; SAML via Keycloak if demanded |
| HELIOS clinical evidence types | **Deferred** |
| Observability (metrics/alerts) | **Deferred** — structured logs only |
| HelixTest Auth Level live | Optional; not required for this sign-off |

## Claims ban

Do **not** claim: production SoR, EHDS certification, “consent enforcement across Ferrum”, or “HSM-backed Solum” from this pack alone.
