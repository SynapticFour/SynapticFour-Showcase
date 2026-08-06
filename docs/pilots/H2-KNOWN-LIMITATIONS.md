# H2 — Known limitations

**Date:** 2026-08-06
**Companion:** [H2-PILOT-CHECKLIST.md](H2-PILOT-CHECKLIST.md) · [H2-EXECUTION-RECORD.md](H2-EXECUTION-RECORD.md)

H2 **spine v1** + **H2.1 Teeth** + **H2.2 Org CAP** are signed. This is still **not** the full roadmap exit (KMS CLI, observability, HELIOS clinical types).

| Area | Status |
|------|--------|
| WES anonymous list/submit under `require_auth` | **Closed** — HTTP 401 without Bearer |
| Solum revoke → Ferrum DRS/WES deny | **Closed (H2.1)** when `FERRUM_SOLUM__*` enabled — see [ADR 0001](../adr/0001-solum-ferrum-consent-access.md) |
| OIDC groups → Solum capabilities | **Closed (H2.2)** when sidecar `--org-iam-config` + JWKS — see [ADR 0002](../adr/0002-solum-org-iam-cap.md) |
| Ingest without `ferrum:collector` | Still **403** (correct); mock-idp Passports lack collector visa by design |
| Solum KMS CLI/sidecar | **Not wired** — `AwsKmsKeyProvider` library + `aws-kms` feature only |
| Zeroize | **Best-effort** ZeroizeOnDrop on held seeds; not a TEE / not proof against memory dump |
| CLI CAP_* | Still `--capability` (offline); org-IAM is sidecar-only |
| SAML | ga4gh-infra: OIDC bridge only; SAML via Keycloak if demanded |
| HELIOS clinical evidence types | **Deferred** |
| Observability (metrics/alerts) | **Deferred** — structured logs only |
| HelixTest Auth Level live | Optional; not required for this sign-off |

## Claims ban

Do **not** claim: production SoR, EHDS certification, or “HSM-backed Solum” from this pack alone. Consent enforcement across Ferrum applies **only** when Solum integration is configured and bindings resolve. Org CAP applies **only** when sidecar org-IAM is enabled.
