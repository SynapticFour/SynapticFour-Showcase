# H4 — Edge / Pi + Kenya jurisdiction checklist

**Horizon:** H4 from [COORDINATED-PORTFOLIO-ROADMAP.md](../internal/COORDINATED-PORTFOLIO-ROADMAP.md)
**Depends on:** [H3 engineering exit](../internal/pilots/H3-EXECUTION-RECORD.md)
**Geography decision:** [H4-GEOGRAPHY-DECISION.md](H4-GEOGRAPHY-DECISION.md)
**Not H4:** Nigeria/SA profiles (queued), PRODUCTION flip without counsel, SaaS (H5), EHRbase on Pi

Solum: [`kenya-dpa.toml`](https://github.com/SynapticFour/Solum/blob/main/config/profiles/kenya-dpa.toml) · [H4-OFFLINE-SYNC-POLICY.md](https://github.com/SynapticFour/Solum/blob/main/docs/H4-OFFLINE-SYNC-POLICY.md) · counsel package (contact Synaptic Four — not published in the public Solum tree)
Architecture: [H4-HUB-PI-ARCHITECTURE.md](H4-HUB-PI-ARCHITECTURE.md)

---

## Definition of done

### K1 — Legal (counsel-driven; human gate)

| # | Workstream | Done? | Notes |
|---|------------|-------|-------|
| 4.1.1 | Counsel brief + send checklist ready | [x] | Solum `KENYA-K1-*` pack |
| 4.1.2 | Non-counsel Vorprüfung applied | [x] | Profile PROVISIONAL-PRODUCTION-CANDIDATE |
| 4.1.3 | Brief **sent** to external Kenya counsel | [ ] | Operator executes send checklist — **open** |
| 4.1.4 | Counsel answers applied to TOML + STATUS | [ ] | Blocks PRODUCTION / patient SoR |

### K2 — Technical (engineering)

| # | Workstream | Done? | Notes |
|---|------------|-------|-------|
| 4.2.1 | KE `validate_startup` + `validate_transfer` fixtures | [x] | Empty destinations fail-closed |
| 4.2.2 | `solum check --profile kenya-dpa.toml` documented | [x] | `SOLUM_STORAGE_REGION=KE`, CustomerHeld |
| 4.2.3 | Sidecar refuse wrong region / ephemeral under KE | [x] | Sidecar HTTP / build_state tests |
| 4.2.4 | Showcase KE evaluation-only fixture | [x] | `fixtures/ci/kenya-eval/` — **not** certified |
| 4.2.5 | Ferrum Edge residency notes ↔ KE profile | [x] | FIELD-REGULATORY / sync / offline cross-links |
| 4.2.6 | Offline sync / residency policy written | [x] | Solum H4-OFFLINE-SYNC-POLICY.md (unblocks Pi no-go) |

### K3 — Field pilot (site-driven)

| # | Workstream | Done? | Notes |
|---|------------|-------|-------|
| 4.3.1 | Named site MoU / pilot agreement | [ ] | Not invented in-repo |
| 4.3.2 | Hub vs Pi architecture written | [x] | [H4-HUB-PI-ARCHITECTURE.md](H4-HUB-PI-ARCHITECTURE.md) |
| 4.3.3 | H1 checklist (or subset) on hub before KE SoR | [ ] | Site-gated |
| 4.3.4 | Offline consent reconcile wired in field | [ ] | Policy written (K2); field wiring after site |

---

## Honest exit (this pack)

**K2 engineering exit** — Kenya profile is testable, fail-closed on transfer/residency/ephemeral, offline/hub-Pi policy documented, Edge docs linked. Still **PROVISIONAL**; **no** ODPC claim; **no** patient SoR; **no** named site.

Full H4 production-ready exit additionally requires **K1.3–K1.4** (counsel) and **K3.1** (named site).

---

## Sign-off (K2 engineering)

| Field | Value |
|-------|-------|
| Host | Synaptic Four eng |
| Date | 2026-08-10 |
| Evidence | [H4-EXECUTION-RECORD.md](../internal/pilots/H4-EXECUTION-RECORD.md) |
| Profile | `kenya-dpa` PROVISIONAL-PRODUCTION-CANDIDATE |
| Notes | Counsel send + named site remain open |
