# Pilot / horizon execution packs

Working checklists and decisions that implement the [coordinated portfolio roadmap](../COORDINATED-PORTFOLIO-ROADMAP.md).

**What’s still open across H1–H5:** [HORIZON-OPEN-GATES.md](HORIZON-OPEN-GATES.md) (2026-08-10).

**Local Solum proofs:** sibling [Solum-Demo](https://github.com/SynapticFour/Solum-Demo) — `make smoke-all` (Stage-1 + consent + optional H3/profile); Showcase orchestration remains `make solum-stage`.

| Doc | Horizon | Purpose |
|-----|---------|---------|
| [HORIZON-OPEN-GATES.md](HORIZON-OPEN-GATES.md) | All | Remaining human / deferred gates |
| [H1-PILOT-CHECKLIST.md](H1-PILOT-CHECKLIST.md) | H1 | Week-by-week on-prem pilot (Ferrum + HELIOS + Solum sidecar) |
| [H1-EXECUTION-RECORD.md](H1-EXECUTION-RECORD.md) | H1 | **SIGNED OFF** 2026-08-06 |
| [H1-KNOWN-LIMITATIONS.md](H1-KNOWN-LIMITATIONS.md) | H1 | Auth/TES/Solum honesty for pilots |
| [H2-PILOT-CHECKLIST.md](H2-PILOT-CHECKLIST.md) | H2 | Production on-prem spine (v1) |
| [H2-EXECUTION-RECORD.md](H2-EXECUTION-RECORD.md) | H2 | **SIGNED OFF** spine v1 2026-08-06 |
| [H2-KNOWN-LIMITATIONS.md](H2-KNOWN-LIMITATIONS.md) | H2 | Remaining full-H2 gaps |
| [H2-OPS-RUNBOOK.md](H2-OPS-RUNBOOK.md) | H2 / H2.3 | TLS, collector visa path, thin metrics, backup |
| [H2-SECOND-PASS.md](H2-SECOND-PASS.md) | H2 exit | Closed B–D; outstanding (counsel, non-AWS KMS, …) documented |
| [observability/](observability/) | H2 exit | Prometheus blackbox + alert baseline |
| [ADR 0001 consent access](../adr/0001-solum-ferrum-consent-access.md) | H2.1 | Solum revoke → Ferrum DRS/WES deny |
| [ADR 0002 org IAM CAP](../adr/0002-solum-org-iam-cap.md) | H2.2 | OIDC groups → Solum CAP_* |
| [H3-PILOT-CHECKLIST.md](H3-PILOT-CHECKLIST.md) | H3 | **FULL H3 ENGINEERING EXIT** 2026-08-10 |
| [H3-EXECUTION-RECORD.md](H3-EXECUTION-RECORD.md) | H3 | Evidence H3.0–H3.6 + depth harden |
| [H4-GEOGRAPHY-DECISION.md](H4-GEOGRAPHY-DECISION.md) | H4 | First non-EU jurisdiction pack (Kenya provisional) |
| [H4-PILOT-CHECKLIST.md](H4-PILOT-CHECKLIST.md) | H4 | K2 eng exit; K1/K3 human gates open |
| [H4-HUB-PI-ARCHITECTURE.md](H4-HUB-PI-ARCHITECTURE.md) | H4 | Pi vs hub placement |
| [H5-SAAS-READY-CHECKLIST.md](H5-SAAS-READY-CHECKLIST.md) | H5 | Optional preparedness (not SaaS launch) |
| [H5-MANAGED-SINGLE-TENANT.md](H5-MANAGED-SINGLE-TENANT.md) | H5 | Hosted on-prem recipe |
| [ADR 0003 tenant boundaries](../adr/0003-tenant-boundaries.md) | H5 | One deployment = one tenant |

H3 / H4 / H5 counsel and Solum artefacts:

- [ADR 0001 — openEHR CDR + migration](https://github.com/SynapticFour/Solum/blob/main/docs/adr/0001-openehr-cdr-and-migration.md)
- [ADR 0002 — CDR engine = EHRbase](https://github.com/SynapticFour/Solum/blob/main/docs/adr/0002-cdr-engine-ehrbase.md)
- [MIGRATION-STRANGLER.md](https://github.com/SynapticFour/Solum/blob/main/docs/MIGRATION-STRANGLER.md)
- [Kenya K1 counsel brief](https://github.com/SynapticFour/Solum/blob/main/docs/counsel/KENYA-K1-BRIEF.md)
- [Kenya K1 Vorprüfung](https://github.com/SynapticFour/Solum/blob/main/docs/counsel/KENYA-K1-VORPRUEFUNG.md) (**not** counsel)
- [Kenya K1 send checklist](https://github.com/SynapticFour/Solum/blob/main/docs/counsel/KENYA-K1-SEND-CHECKLIST.md)
- [H3 MDCG send checklist](https://github.com/SynapticFour/Solum/blob/main/docs/counsel/H3-MDCG-SEND-CHECKLIST.md)
- [H5 key custody managed](https://github.com/SynapticFour/Solum/blob/main/docs/H5-KEY-CUSTODY-MANAGED.md)
