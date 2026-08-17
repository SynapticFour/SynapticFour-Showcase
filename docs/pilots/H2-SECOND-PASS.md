# H2 — Second pass (exit items)

**Purpose:** Track what closed the full roadmap H2 exit vs what remains outstanding.
**Status:** **B–D closed for H2 exit** (2026-08-06). Outstanding non-exit items listed below.
**Depends on:** H2 spine v1 + H2.1–H2.4.
**Not this pass:** H3 CDR coding, Kenya PRODUCTION flip (H4 / counsel), SaaS (H5).

---

## Workstream status

| # | Workstream | Status |
|---|------------|--------|
| A | Solum KMS CLI + sidecar (`aws-kms`) | **Done (H2.4)** — AWS CMK envelope only; on-prem CustomerHeld remains default |
| B | Observability baseline (metrics + alerts) | **Done** — [observability/README.md](observability/README.md) + [prometheus-alerts.yml](observability/prometheus-alerts.yml) |
| C | HELIOS clinical access evidence | **Done** — `CLIN-ACCESS-001` over `solum-audit-helios-chain-v1` |
| D | CLI org-IAM | **wontfix / intentional** — sidecar-only org-IAM; CLI keeps `--capability` (offline) |

Optional / pull-only (not required for H2 exit): HelixTest Auth Level live; SAML (Keycloak if demanded).

---

## A — Solum KMS CLI / sidecar — **DONE (H2.4)**

| Fact | Detail |
|------|--------|
| Shipped | Feature `aws-kms`: CLI `wrap-seed` / `--wrapped-keypair`; sidecar `--wrapped-keys-dir` |
| Default | **On-prem CustomerHeld** files — cloud-agnostic; Azure/Alibaba/Hetzner/custom use files until adapters exist |
| Honesty | Envelope + in-process unwrap; **not** HSM/TEE; not an AWS-only product |

---

## B — Observability baseline — **DONE**

| Fact | Detail |
|------|--------|
| Shipped | Blackbox scrape guidance + 3–5 alert rules in [observability/](observability/) |
| Honesty | Prefer blackbox over inventing Ferrum `/metrics`; not an SRE platform |
| Cloud | Same pack on bare metal / any cloud — only URLs change |

---

## C — HELIOS clinical evidence — **DONE**

| Fact | Detail |
|------|--------|
| Shipped | HELIOS check `CLIN-ACCESS-001` (`helios.checks.clinical_access`) |
| Input | `parameters.solum_audit_export` or artefact matching `*solum-audit*.json` / `*-helios-chain.json` |
| Format | `solum-audit-helios-chain-v1` (Solum `FileAuditStore::export_helios_json`) |
| Honesty | Technical evidence ≠ ODPC/EHDS certification |

---

## D — CLI org-IAM — **wontfix (intentional)**

| Fact | Detail |
|------|--------|
| Decision | Production org CAP lives on the **sidecar** (`--org-iam-config` + JWKS). Offline CLI keeps explicit `--capability`. |
| Rationale | ADR 0002; operators who need IdP-backed CAP use HTTP integration; CLI is break-glass / offline. |
| Closed | Limitations row updated; no CLI JWT work planned for H2. |

---

## Outstanding after H2 exit (documented, not blocking)

| Item | Why still open |
|------|----------------|
| Kenya counsel verification / ODPC PRODUCTION flip | H4 — external counsel; Vorprüfung is engineering prior art only |
| EncryptionContext / AAD on AWS KMS unwrap | Hardening; optional buyers |
| IRSA / `aws-config` credential chain | Env keys only today |
| Ferrum native Prometheus `/metrics` | Prefer blackbox until a buyer needs counters |
| Azure Key Vault / Alibaba KMS / other cloud KMS providers | Use CustomerHeld files; adapters not wired |
| HelixTest Auth Level live | Optional; fixture gate remains via Showcase suite |
| SAML | Keycloak bridge if demanded |

---

## Sign-off criteria for “full H2 exit”

1. ~~A shipped~~ **Done**
2. ~~B shipped~~ **Done**
3. ~~C shipped~~ **Done**
4. ~~D decided~~ **wontfix / intentional**

Claim language: **full H2 exit** — operator runbook + pack with teeth across planes. Still do **not** claim EHDS/ODPC certification or HSM.

---

## Related

- [H2-OPS-RUNBOOK.md](H2-OPS-RUNBOOK.md)
- [H2-KNOWN-LIMITATIONS.md](H2-KNOWN-LIMITATIONS.md)
- [COORDINATED-PORTFOLIO-ROADMAP.md](../COORDINATED-PORTFOLIO-ROADMAP.md) §7
- Kenya counsel: Solum [KENYA-K1-BRIEF.md](https://github.com/SynapticFour/Solum/blob/main/docs/counsel/KENYA-K1-BRIEF.md)
