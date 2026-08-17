# H2 — Known limitations

**Date:** 2026-08-06
**Companion:** [H2-PILOT-CHECKLIST.md](H2-PILOT-CHECKLIST.md). The H2 execution record is not published in this repository.

**Founder rehearsal** of the H2 engineering pack (spine v1 + H2.1–H2.4 + second-pass B–D) on a developer host — **not** a named customer site. Outstanding items below are **documented**, not silent gaps.

| Area | Status |
|------|--------|
| WES anonymous list/submit under `require_auth` | **Closed** — HTTP 401 without Bearer |
| Solum revoke → Ferrum DRS/WES deny | **Closed (H2.1)** when `FERRUM_SOLUM__*` enabled — see [ADR 0001](../adr/0001-solum-ferrum-consent-access.md) |
| OIDC groups → Solum capabilities | **Closed (H2.2)** when sidecar `--org-iam-config` + JWKS — see [ADR 0002](../adr/0002-solum-org-iam-cap.md) |
| Collector visa operator how-to | **Closed (H2.3)** — Edge account + IdP paths in [H2-OPS-RUNBOOK.md](H2-OPS-RUNBOOK.md) §2.1 |
| Ingest without `ferrum:collector` | Still **403** (correct); mock-idp Passports lack collector visa by design |
| Thin health checks | **Closed (H2.3)** — gateway `/health` + optional Solum status curl |
| Observability (Prometheus/alerts) | **Closed** — blackbox + alert pack in [observability/](observability/) (not Ferrum `/metrics`) |
| HELIOS clinical evidence | **Closed** — `CLIN-ACCESS-001` over Solum chain export |
| Solum KMS CLI/sidecar | **Closed (H2.4)** optional `--features aws-kms` — AWS CMK envelope only; **on-prem CustomerHeld remains default** |
| CLI CAP_* / org-IAM | **Intentional** — CLI `--capability` offline; org-IAM **sidecar-only** (ADR 0002 wontfix) |
| Zeroize | **Best-effort** ZeroizeOnDrop on held seeds; not a TEE / not proof against memory dump |
| SAML | ga4gh-infra: OIDC bridge only; SAML via Keycloak if demanded |
| HelixTest Auth Level live | Optional; not required for this founder rehearsal |
| Kenya counsel / ODPC PRODUCTION | **Outstanding (H4)** — Vorprüfung is engineering prior art; real counsel still required |
| Non-AWS cloud KMS adapters | **Outstanding** — Azure/Alibaba/Hetzner/custom use CustomerHeld files |
| KMS EncryptionContext / IRSA | **Outstanding** — env credentials only; no AAD binding |

## Claims ban

Do **not** claim: production SoR, EHDS/ODPC certification, or “HSM-backed Solum” from this pack alone. Consent enforcement across Ferrum applies **only** when Solum integration is configured and bindings resolve. Org CAP applies **only** when sidecar org-IAM is enabled. AWS KMS does **not** make Solum AWS-only — on-prem CustomerHeld is the default/target.
