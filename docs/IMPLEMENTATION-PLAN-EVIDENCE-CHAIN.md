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

### W2 — Evidence Pack CLI — **done 2026-08-06**

**Goal:** One command that packs HelixTest scores + HELIOS report + DRS object hashes (+ optional Solum audit digest) into a reviewable bundle.

| Step | Where | Work | Status |
|------|-------|------|--------|
| 1 | Showcase | `scripts/evidence-pack.sh` + `evidence_pack.py` | Done |
| 2 | Showcase | Optional HelixTest sibling (`SHOWCASE_HELIXTEST_ROOT` / `SHOWCASE_RUN_HELIXTEST=1`) | Done |
| 3 | Showcase docs | `docs/for-evaluators/helixtest-gate.md` (gateway :18080) | Done |
| 4 | Showcase | `artifacts/evidence-pack-<id>/` with `MANIFEST.json` + `README.md` | Done |
| 5 | Docs | `docs/for-customers/evidence-pack.md` honesty one-pager | Done |

**Exit:** `./scripts/evidence-pack.sh --fixtures` (CI) and live `make evidence-pack` after a golden path. ✅

**Estimate:** ~4–6 days for MVP pack + fixture CI; HelixTest live gate can follow as hard-fail later.

---

### W3 — PhenoFlow → Solum consent (before WES) — **done 2026-08-06**

**Goal:** Purpose-bound consent check gate before WES fan-out — product work in BRA + Solum; Showcase only sequences.

| Step | Where | Work | Status |
|------|-------|------|--------|
| 1 | BRA | PhenoFlow purpose binding artefact (+ optional BRA POST) | Done (binding JSON; BRA soft-optional) |
| 2 | Solum | Sidecar consent grant/status (already shipped) | Done |
| 3 | Showcase | `scripts/run-consent-gate.sh` + golden-path wiring | Done |
| 4 | Showcase | Deny path skips WES/HELIOS; blocked report | Done |
| 5 | Docs | `docs/for-customers/consent-gate.md` honesty | Done |

**Exit:** `SHOWCASE_ENABLE_CONSENT_GATE=1` allow/deny demos; fixtures for CI. ✅

Note: script name is `run-consent-gate.sh` (plan typo “phenofloat” corrected).

---

### W4 — gatk-rs / S4MP via Ferrum WES

**Goal:** Optional stress / port-evidence path — **not** the default Nextflow GIAB story.

| Piece | Role | Showcase fit |
|-------|------|--------------|
| **gatk-rs** | Rust HC / calling engine | Package as TRS tool or WES workflow **in Ferrum-GA4GH-Demo** (or a demo overlay), then pin sibling from Showcase |
| **S4MP** | Method / knowledge / port-verification platform | Better as **sidecar evidence** (“port certification” narrative) than as WES runtime — don’t force S4MP into the executor |

| Step | Where | Work | Status |
|------|-------|------|--------|
| 1 | Decision memo | Default path stays Nextflow GIAB; gatk-rs is `SHOWCASE_ENABLE_GATK_RS=1` optional | Done — `docs/for-customers/gatk-rs-s4mp.md` |
| 2 | Ferrum-GA4GH-Demo | Workflow/TRS entry that invokes gatk-rs binary or container at pin | Done (Phase B) — `./run --gatk-rs` + `tiny_hc_gatk_rs.nf`; soft-skip if image missing |
| 3 | Showcase | Script stage + pin `gatk-rs=<sha>`; soft-fail smoke; optional WES wrapper | Done — `run-gatk-rs-smoke.sh`, `run-gatk-rs-wes.sh` |
| 4 | S4MP | Optional: attach S4MP method report into Evidence Pack MANIFEST (link/hash), not execute as WES | Done — `attach-s4mp-evidence.sh`, fixtures |

**Exit (Phase A):** Optional soft-fail path documented; Evidence Pack roles `gatk_rs_smoke` / `s4mp_port_diff`; default Nextflow untouched. ✅

**Exit (Phase B):** Optional Ferrum `./run --gatk-rs` under Showcase soft wrapper; integration suite + `demo/verification/` for customer re-run. ✅

Also: `scripts/run-integration-suite.sh` + customer overview (`docs/for-customers/overview.md`).

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
