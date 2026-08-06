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
| 2.5 | Org IAM bridge honesty | [x] | ADS OIDC→dataset grants exist; Solum CAP_* still client-supplied — see limitations |
| 2.6 | Consent propagation (H2.1 Teeth) | [x] | Ferrum polls Solum status on bound DRS/WES; ADR 0001; `make h21-teeth` |
| 2.7 | Observability / HELIOS clinical evidence | [ ] deferred | Baseline logs only; clinical HELIOS types → later |
| 2.8 | HelixTest Auth Level live | [ ] optional | Fixture gate remains required via Showcase suite |
| 2.9 | Ops pack (TLS + backup rotation) | [x] | [H2-OPS-RUNBOOK.md](H2-OPS-RUNBOOK.md) |
| 2.10 | Sign-off | [x] | Spine v1 + H2.1 Teeth |

**Honest scope:** H2 **spine v1** + **H2.1 Teeth**. Full roadmap exit still needs OIDC→Solum CAP, sidecar KMS, observability — see [H2-KNOWN-LIMITATIONS.md](H2-KNOWN-LIMITATIONS.md).

---

## Sign-off

| Field | Value |
|-------|-------|
| Host | Synaptic Four ops — MacBook-Air-von-Alexander (pilot-local stack) |
| Operator | Synaptic Four eng |
| Date | 2026-08-06 |
| Ferrum pin | `e638214b` |
| Solum pin | `9b8ce7f` |
| Evidence | [H2-EXECUTION-RECORD.md](H2-EXECUTION-RECORD.md) |
| Notes | Do not claim full roadmap H2 exit |

---

## Exit → H3 / remaining H2

- **H3** architecture (EHRbase) may proceed in parallel.
- Remaining H2 product work: Solum KMS CLI/sidecar, OIDC→Solum CAP mapping, observability baseline.
