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
| 2.4 | KMS/HSM honesty + rotation runbook | [x] | Library KMS remains; CLI/sidecar unwired — see [H2-OPS-RUNBOOK.md](H2-OPS-RUNBOOK.md) |
| 2.5 | Org IAM bridge (H2.2 Org CAP) | [x] | Sidecar `--org-iam-config` + JWKS → groups→CAP_*; ADR 0002; `make h22-org-cap` |
| 2.6 | Consent propagation (H2.1 Teeth) | [x] | Ferrum polls Solum status on bound DRS/WES; ADR 0001; `make h21-teeth` |
| 2.7 | Observability / HELIOS clinical evidence | [ ] second pass | Thin health curls in H2.3; Prometheus + HELIOS types → [H2-SECOND-PASS.md](H2-SECOND-PASS.md) |
| 2.8 | HelixTest Auth Level live | [ ] optional | Fixture gate remains required via Showcase suite |
| 2.9 | Ops pack (TLS + backup + H2.3 polish) | [x] | [H2-OPS-RUNBOOK.md](H2-OPS-RUNBOOK.md) — collector visa path + thin metrics |
| 2.10 | Sign-off | [x] | Spine v1 + H2.1 + H2.2 + H2.3 |

**Honest scope:** H2 **spine v1** + **H2.1 Teeth** + **H2.2 Org CAP** + **H2.3 Ops polish**. Full roadmap exit → [H2-SECOND-PASS.md](H2-SECOND-PASS.md) (KMS, Prometheus, HELIOS clinical types, CLI org-IAM decision).

---

## Sign-off

| Field | Value |
|-------|-------|
| Host | Synaptic Four ops — MacBook-Air-von-Alexander (pilot-local stack) |
| Operator | Synaptic Four eng |
| Date | 2026-08-06 |
| Ferrum pin | `e638214b` |
| Solum pin | `545711c` (H2.2 org-IAM) |
| Evidence | [H2-EXECUTION-RECORD.md](H2-EXECUTION-RECORD.md) |
| Notes | Do not claim full roadmap H2 exit |

---

## Exit → H3 / remaining H2

- **H3** architecture (EHRbase) may proceed in parallel.
- **Second pass** (full H2 exit): [H2-SECOND-PASS.md](H2-SECOND-PASS.md).
- Kenya K1: send counsel brief — Solum [KENYA-K1-SEND-CHECKLIST.md](https://github.com/SynapticFour/Solum/blob/main/docs/counsel/KENYA-K1-SEND-CHECKLIST.md).
