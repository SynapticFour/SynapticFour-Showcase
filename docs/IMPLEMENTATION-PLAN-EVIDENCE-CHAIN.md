# Implementation plan — Sovereign evidence chain

**Date:** 2026-08-06
**Owner surface:** this repo (`SynapticFour-Showcase`) as **integrator**, not monorepo
**Products stay separate:** Ferrum / Ferrum-GA4GH-Demo, HELIOS, bioresearch-assistant, Solum / Solum-Demo, HelixTest, gatk-rs, S4MP

---

## Verdict: can Showcase become the monorepo for all of this?

**No — and it should not.** Showcase already enables the right pattern: thin orchestration of **sibling checkouts** via `Makefile`, `scripts/`, `PINNED_VERSIONS.txt`, and path overrides (`SHOWCASE_*_ROOT`). There is no Cargo/pnpm workspace, no git submodules, and CI uses fixtures rather than building Ferrum/HELIOS from source in-tree.

Folding Ferrum, HELIOS, BRA, Solum, HelixTest, and gatk-rs into one monorepo would:

- Explode CI and release cadence across BUSL / Apache / AGPL-adjacent surfaces
- Violate Solum’s deliberate **separate regulatory perimeter** (`Solum/docs/ECOSYSTEM.md`)
- Fight Ferrum’s five-repo GA4GH ownership map (`Ferrum/docs/ECOSYSTEM.md`)
- Duplicate what `Solum-Demo` already proves: consume **pinned product tags**, don’t vendor product trees

**Keep Showcase as the conductor.** Add stages, pins, docs, and committed example artefacts — same as today’s M2 BioResearch path.

```
Today:     Ferrum-GA4GH-Demo  →  HELIOS  →  (optional) BRA M2
Target:    + Solum stage  +  Evidence Pack CLI  +  (later) PhenoFlow→consent  +  (optional) gatk-rs/S4MP path
```

---

## Workstreams

### W0 — Narrative & pins (docs-only foundation) — **done 2026-08-06**

| Task | Status | Notes |
|------|--------|-------|
| README DE/EN: Solum companion + chain honesty | Done | Orchestrated today vs next called out |
| `which-path` Scenario E (Solum) | Done | Points at Solum-Demo |
| ROADMAP links this plan | Done | |
| `PINNED_VERSIONS.txt`: add Solum-Demo (and/or Solum tag) | Done | `Solum-Demo=<sha>` + `Solum-tag=stage1-…` |
| Evaluator kit: link Solum-Demo + this plan | Done | Path E + resources + deployment-paths |
| Preflight: optional Solum-Demo sibling check | Done | Soft warn; hard-fail only if `SHOWCASE_ENABLE_SOLUM=1` |

**Exit:** Evaluators see a four-product story without claiming Solum is already in the default `run-golden-path.sh`. ✅

---

### W1 — Showcase as Ferrum + HELIOS + BRA + Solum evidence chain — **done 2026-08-06**

**Goal:** One documented golden path that produces genomic + audit + (optional) BRA + clinical Stage-1 artefacts side-by-side.

| Step | Where | Work | Status |
|------|-------|------|--------|
| 1 | Showcase | `scripts/run-solum-stage.sh` | Done |
| 2 | Showcase | `make solum-stage` / `make golden-path-with-solum` | Done |
| 3 | Showcase | `demo/results/solum-*-example.json` + CI fixture | Done (live-verified) |
| 4 | Showcase | Assembler Solum section | Done |
| 5 | Solum-Demo | No product change needed — Showcase curls APIs | Done |

**Exit:** `make solum-stage` and `SHOWCASE_ENABLE_SOLUM=1` path produce Solum artefacts; report assembler includes Solum when present. ✅

---

### W2 — Evidence Pack CLI

**Goal:** One command that packs HelixTest scores + HELIOS report + DRS object hashes (+ optional Solum audit digest) into a reviewable bundle.

| Step | Where | Work |
|------|-------|------|
| 1 | Showcase | `scripts/evidence-pack.sh` (or `python -m` thin CLI) — inputs: HELIOS report path, DRS JSON, optional HelixTest JSON, optional Solum digest |
| 2 | Showcase | Wire HelixTest as **optional** sibling (`SHOWCASE_HELIXTEST_ROOT` / pinned binary) — ROADMAP already lists HelixTest-Gate |
| 3 | HelixTest / Ferrum-GA4GH-Demo | Document the minimal live endpoints the gate needs (gateway already on **18080** in evaluator docs) |
| 4 | Showcase | Output: `artifacts/evidence-pack-<run-id>/` with `MANIFEST.json` + `README.md` + copied reports |
| 5 | Docs | Customer one-pager: “what this pack proves / does not prove” (reuse compliance-framing honesty) |

**Exit:** Evaluator can run Evidence Pack against a live golden path **or** against committed fixtures (CI stays fixture-based).

**Estimate:** ~4–6 days for MVP pack + fixture CI; HelixTest live gate can follow as hard-fail later.

---

### W3 — PhenoFlow → Solum consent (before WES)

**Goal:** Purpose-bound consent check gate before WES fan-out — product work in BRA + Solum; Showcase only sequences.

| Step | Where | Work |
|------|-------|------|
| 1 | BRA | Confirm PhenoFlow API surface for “submit / attach consent purpose” (`docs/PHENOFLOW.md`) |
| 2 | Solum | Consent/authorize API on sidecar suitable for machine gate (fail-closed) |
| 3 | Showcase | `scripts/run-phenofloat-consent-gate.sh` — create phenopacket (existing M2 pieces) → Solum authorize → only then trigger Demo WES |
| 4 | Showcase | Negative demo: deny path leaves HELIOS/WES unrun; artefacts show blocked decision |
| 5 | Docs | Explicit: not a legal consent substitute; technical purpose-binding demo |

**Risk:** Highest integration risk of the four themes — depends on BRA + Solum API readiness, not Showcase scripts.

**Exit:** Documented happy-path + deny-path demos; not required for every golden path (flag `SHOWCASE_ENABLE_CONSENT_GATE=1`).

**Estimate:** Product-dependent (1–3 weeks). Showcase orchestration alone ~2–3 days once APIs exist.

---

### W4 — gatk-rs / S4MP via Ferrum WES

**Goal:** Optional stress / port-evidence path — **not** the default Nextflow GIAB story.

| Piece | Role | Showcase fit |
|-------|------|--------------|
| **gatk-rs** | Rust HC / calling engine | Package as TRS tool or WES workflow **in Ferrum-GA4GH-Demo** (or a demo overlay), then pin sibling from Showcase |
| **S4MP** | Method / knowledge / port-verification platform | Better as **sidecar evidence** (“port certification” narrative) than as WES runtime — don’t force S4MP into the executor |

| Step | Where | Work |
|------|-------|------|
| 1 | Decision memo | Default path stays Nextflow GIAB; gatk-rs is `SHOWCASE_ENABLE_GATK_RS=1` optional |
| 2 | Ferrum-GA4GH-Demo | Workflow/TRS entry that invokes gatk-rs binary or container at pin |
| 3 | Showcase | Script stage + pin `gatk-rs=<tag>`; HELIOS wraps the run like today |
| 4 | S4MP | Optional: attach S4MP method report artefact into Evidence Pack MANIFEST (link/hash), not execute S4MP as WES |

**Exit:** One optional path documented for “Rust caller under Ferrum WES + HELIOS”; S4MP linked as method evidence when available.

**Estimate:** Demo/Ferrum-side heavier (~1–2 weeks); Showcase wiring ~2 days after Demo exposes the workflow.

---

## Suggested sequence

```text
W0 (docs/pins)  →  W1 (Solum stage)  →  W2 (Evidence Pack)
                         ↘
                    W3 when BRA+Solum APIs ready
W4 parallel / later (optional path; don’t block W1–W2)
```

Do **not** start W3 or W4 before W1/W2 produce a repeatable four-plane report story.

---

## Explicit non-goals

- Merging product repos into Showcase
- Replacing Ferrum Lab Kit or Open-Source-GA4GH-Stack with Showcase
- Claiming certified compliance from Evidence Pack output
- Making S4MP a required runtime for demos
- Kinode or Mycelium in this chain

---

## Success metrics

| Metric | Target |
|--------|--------|
| Sibling checkouts required for full chain | Documented in `PINNED_VERSIONS.txt` + preflight |
| Time to stakeholder pack (fixture mode) | Minutes (no install) via `demo/results/` |
| Time to live golden path + Solum | Same order of magnitude as today’s DEMO.md, plus Solum-Demo cold build |
| CI | Still fixture-based; no mandatory multi-Rust workspace build in Showcase CI |

---

## Related docs

- [`README.md`](../README.md) — public evidence-chain narrative
- [`DEMO.md`](../DEMO.md) — how to run today
- [`ROADMAP.md`](../ROADMAP.md)
- [`docs/for-customers/compliance-framing.md`](for-customers/compliance-framing.md)
- Solum: [ECOSYSTEM](https://github.com/SynapticFour/Solum/blob/main/docs/ECOSYSTEM.md) · [Solum-Demo](https://github.com/SynapticFour/Solum-Demo)
- SynaptiSec (out of this chain): [Products migration](https://github.com/SynapticFour/SynapticProducts/blob/main/docs/synaptisec-migration.md)
