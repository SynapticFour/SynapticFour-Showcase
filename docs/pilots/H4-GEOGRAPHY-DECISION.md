# H4 — Geography decision (first jurisdiction pack beyond EU)

**Horizon:** H4 from [COORDINATED-PORTFOLIO-ROADMAP.md](../internal/COORDINATED-PORTFOLIO-ROADMAP.md)
**Decision date:** 2026-08-06 (provisional — finalize when a field pilot is contracted)
**Owner:** Solum profiles + Ferrum Edge / Lab Kit field path

---

## Decision (provisional)

**First non-EU jurisdiction pack to drive to production-ready: Kenya (`kenya-dpa`).**

| Factor | Why Kenya first |
|--------|------------------|
| Profile already exists | `Solum/config/profiles/kenya-dpa.toml` (draft) |
| Equal-market doctrine | Solum PRODUCT-DEFINITION: EU and African markets are equal cores |
| Field tech path | Ferrum Edge / village-network demos already use East Africa narratives |
| Legal anchors named | DPA 2019 + Digital Health Act 2023 + ODPC guidance cited in profile |
| Sequencing | Nigeria / South Africa stay **planned** until Kenya pack closes open items |

**Not decided yet:** the *named customer site* (hospital/lab/NGO). Geography pack work can start; Stage 4 cut-over waits for a real site + counsel.

---

## Go / no-go criteria

### Go — start Kenya pack hardening now

- [x] Draft TOML exists with schema_version aligned to `eu-ehds`
- [x] Open legal items listed in `docs/profiles.md` and profile `regulatory.notes`
- [x] Synaptic Four commits eng time to close **technical** gaps (tests, startup validation, transfer checks) — see [H4-PILOT-CHECKLIST.md](H4-PILOT-CHECKLIST.md) K2
- [ ] Counsel path identified (external) — brief + send checklist ready; **non-counsel** Vorprüfung applied (provisional profile); **send to real counsel still open**

### No-go — do not claim production Kenya

- Using `kenya-dpa` on a live patient system while STATUS is not PRODUCTION (still PROVISIONAL)
- Empty `permitted_destinations` treated as “allow all” (must stay fail-closed)
- Pi/Edge offline cut-over without sync/residency policy written — **policy written:** Solum [H4-OFFLINE-SYNC-POLICY.md](https://github.com/SynapticFour/Solum/blob/main/docs/H4-OFFLINE-SYNC-POLICY.md); field reconcile still K3
---

## Kenya pack — work breakdown

### K1 — Legal closure (counsel-driven)

| Item | Source of open question | Target | Eng status |
|------|-------------------------|--------|------------|
| Retention periods | Digital Health Act s.25 vs DPA s.39 private deployments | Single table in profile + notes | **Vorprüfung applied** (conservative default honesty) — counsel confirm |
| Audit-log retention | No ODPC figure found | Document assumption + revisit trigger | **Vorprüfung applied** — counsel confirm |
| `required_purposes` catalogue | Guidance-directed, not statutory list | Versioned list + mapping to Solum purposes | **Vorprüfung applied** (research → optional) — counsel confirm |
| Cross-border destinations | ODPC case-by-case | Populate `permitted_destinations` or keep empty + fail-closed with runbook | Empty + fail-closed kept — counsel confirm |
| Health Data Bank obligations | Outside Solum scope | Explicit non-goal in profile notes | Non-goal strengthened — counsel confirm |

**Profile status:** PROVISIONAL-PRODUCTION-CANDIDATE after **non-counsel** counsel package (contact Synaptic Four — not published in the public Solum tree). Real counsel via counsel package (contact Synaptic Four — not published in the public Solum tree) still required before PRODUCTION / patient SoR.

### K2 — Technical closure (engineering)

| Item | Done when |
|------|-----------|
| Profile tests | `validate_startup` + `validate_transfer` fixtures for KE — **done** (fail-closed destinations) |
| CLI check | `solum check --profile kenya-dpa.toml` documented — **done** (`docs/profiles.md`) |
| Sidecar refuse | Wrong region / ephemeral custody refused under KE profile — **done** |
| Showcase | Optional KE fixture **evaluation-only** — **done** (`fixtures/ci/kenya-eval/`) |
| Edge | Ferrum Edge residency notes link to KE profile — **done** |
| Offline policy | Sync/residency policy written — **done** (Solum `H4-OFFLINE-SYNC-POLICY.md`) |

### K3 — Field pilot (site-driven)

| Item | Done when |
|------|-----------|
| Named site | MoU / pilot agreement — **open** |
| Hub vs Pi | Written architecture — **done** ([H4-HUB-PI-ARCHITECTURE.md](H4-HUB-PI-ARCHITECTURE.md)) |
| H1 checklist | Completed on hub (or agreed subset) before KE SoR claims — **open** |
| Offline consent | Track A works offline; sync policy reviewed — policy **written**; field wiring **open** |
---

## Second and third geographies (queued)

| Order | Profile | Trigger to start |
|-------|---------|------------------|
| 2 | `nigeria-ndpa.toml` | Kenya K1+K2 substantially closed **or** Nigeria pilot signed first |
| 3 | `south-africa-popia.toml` | Same rule |

If a contracted pilot is in Nigeria/SA before Kenya legal closure, **reorder** — this document’s “Kenya first” is the default engineering sequence, not a hard commercial constraint. Update this file when reordering.

---

## Relation to H1 / H3

| Horizon | Kenya relevance |
|---------|-----------------|
| H1 | EU (`eu-ehds`) or `dev-local` for lab pilots; KE draft only in sandboxes |
| H3 | Migration strangler is jurisdiction-agnostic; KE SoR cut-over needs K1+K2 |
| H4 | This geography decision + pack hardening |

---

## Sign-off (when production-ready)

| Field | Value |
|-------|-------|
| Counsel review date | |
| Profile STATUS | DRAFT → PRODUCTION |
| Tag / commit | |
| First site | |
| Notes | |
