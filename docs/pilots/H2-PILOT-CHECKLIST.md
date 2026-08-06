# H2 — Production on-prem spine checklist

**Horizon:** H2 from [COORDINATED-PORTFOLIO-ROADMAP.md](../COORDINATED-PORTFOLIO-ROADMAP.md)
**Depends on:** [H1 signed off](H1-EXECUTION-RECORD.md)
**Not H2:** openEHR CDR (H3), Kenya PRODUCTION profile (H4), SaaS (H5)

---

## Definition of done (roadmap exit)

Operator can run without Synaptic Four on the laptop; **withdrawal has teeth across planes** where contracted.

| # | Workstream | Done? | Notes |
|---|------------|-------|-------|
| 2.1 | WES auth-surface fail-closed under `require_auth` | [x] | Ferrum WES list/submit/cancel/resume/status/log/tasks → **401** without Bearer |
| 2.2 | Ingest visa operator path (`ferrum:collector`) | [x] | Documented + evidenced: mock-idp Passport alone → ingest 403; Edge/IdP must issue collector visa |
| 2.3 | Solum zeroize where feasible | [x] | `ZeroizeOnDrop` on CustomerHeld + AwsKms held seeds |
| 2.4 | KMS/HSM honesty + rotation runbook | [x] | H2.4 optional `aws-kms`; **on-prem CustomerHeld default**; honesty: envelope not HSM |
| 2.5 | Org IAM bridge (H2.2 Org CAP) | [x] | Sidecar `--org-iam-config` + JWKS → groups→CAP_*; ADR 0002; `make h22-org-cap` |
| 2.6 | Consent propagation (H2.1 Teeth) | [x] | Ferrum polls Solum status on bound DRS/WES; ADR 0001; `make h21-teeth` |
| 2.7 | Observability / HELIOS clinical evidence | [x] | Prometheus blackbox + alerts; HELIOS `CLIN-ACCESS-001` |
| 2.8 | HelixTest Auth Level live | [ ] optional | Fixture gate remains required via Showcase suite |
| 2.9 | Ops pack (TLS + backup + H2.3 polish) | [x] | [H2-OPS-RUNBOOK.md](H2-OPS-RUNBOOK.md) — collector visa path + thin metrics |
| 2.10 | Sign-off | [x] | **Full H2 exit** — spine + H2.1–H2.4 + second-pass B–D |

**Honest scope:** **Full H2 exit** with documented outstanding items (Kenya counsel, optional HelixTest Auth Level, non-AWS KMS adapters, EncryptionContext/IRSA). See [H2-KNOWN-LIMITATIONS.md](H2-KNOWN-LIMITATIONS.md).

---

## Sign-off

| Field | Value |
|-------|-------|
| Host | Synaptic Four ops — MacBook-Air-von-Alexander (pilot-local stack) |
| Operator | Synaptic Four eng |
| Date | 2026-08-06 |
| Ferrum pin | `e638214b` (H2.1) / spine `49aab603` |
| Solum pin | H2.4 `c9c7082` / honesty `c3becb4` |
| HELIOS | `bd729a6` (`CLIN-ACCESS-001`) |
| Evidence | [H2-EXECUTION-RECORD.md](H2-EXECUTION-RECORD.md) |
| Notes | Do not claim EHDS/ODPC certification or HSM; Kenya counsel still outstanding |

---

## Exit → H3 / outstanding

- **H3** architecture (EHRbase) may proceed.
- Outstanding (not H2 blockers): [H2-SECOND-PASS.md](H2-SECOND-PASS.md) “Outstanding after H2 exit”.
- Kenya K1: send counsel brief — Solum [KENYA-K1-SEND-CHECKLIST.md](https://github.com/SynapticFour/Solum/blob/main/docs/counsel/KENYA-K1-SEND-CHECKLIST.md).
