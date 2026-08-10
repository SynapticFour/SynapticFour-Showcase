# gatk-rs / S4MP (optional W4 path)

Optional **stress / port-evidence** stages for SynapticFour-Showcase. They do **not** replace the default Ferrum Nextflow GIAB story (Broad GATK via WES + HELIOS).

## Decision (memo)

| Path | Default? | Role |
|------|----------|------|
| Ferrum-GA4GH-Demo `./run --nextflow` + Broad GATK | **Yes** | Primary WES evidence chain |
| gatk-rs smoke (`SHOWCASE_ENABLE_GATK_RS=1`) | Opt-in | Tiny local HC smoke; Alpha / soft-fail |
| S4MP attach (`SHOWCASE_ENABLE_S4MP=1`) | Opt-in | Sidecar Markdown port-diff (link/hash) |
| Ferrum WES workflow with gatk-rs container | Opt-in Alpha | Demo `./run --gatk-rs` (`tiny_hc_gatk_rs.nf`); soft-skips if image missing |

## What this proves

- **gatk-rs:** A pinned (or local) `gatk-rs` binary/image can run HaplotypeCaller on a **tiny** parity fixture and emit a VCF (often header-only). Reproducibility of a smoke command — not genome-wide / GIAB / clinical claims. See gatk-rs `docs/CLAIM_MATRIX.md`.
- **S4MP:** A port-diff Markdown artefact (fixture or pre-built `.s4/reports/diff-report.md`) can be hashed into an Evidence Pack. Heuristic method/port narrative — **not** certification (`s4 certify` is a stub).

## What it does **not** prove

- That gatk-rs is production-ready or equivalent to GATK4
- That the default Showcase golden path runs gatk-rs under Ferrum WES (opt-in only; soft-skip without image)
- That S4MP executed the pipeline or certified the port
- Regulatory / clinical validity

## Commands

```bash
# Soft stages alone (exit 0 even on skip/fail unless STRICT=1)
make gatk-rs-smoke
make gatk-rs-smoke-fixtures
make s4mp-evidence
make s4mp-evidence-fixtures

# Opt-in on golden path (default Nextflow WES unchanged)
SHOWCASE_ENABLE_GATK_RS=1 SHOWCASE_ENABLE_S4MP=1 make golden-path

# Evidence Pack picks up artefacts when present
SHOWCASE_ENABLE_GATK_RS=1 SHOWCASE_ENABLE_S4MP=1 SHOWCASE_ENABLE_EVIDENCE_PACK=1 make golden-path
# or after stages:
make evidence-pack
make evidence-pack-fixtures   # includes gatk-rs + S4MP fixtures
```

## Environment

| Variable | Default | Meaning |
|----------|---------|---------|
| `SHOWCASE_ENABLE_GATK_RS` | `0` | Run smoke after HELIOS |
| `SHOWCASE_ENABLE_S4MP` | `0` | Attach S4MP sidecar after HELIOS |
| `SHOWCASE_GATK_RS_ROOT` | `../gatk-rs` | Sibling checkout |
| `SHOWCASE_S4MP_ROOT` | `../S4MP` | Sibling checkout |
| `SHOWCASE_GATK_RS_IMAGE` | unset | Optional Docker image for smoke |
| `SHOWCASE_GATK_RS_STRICT` / `SHOWCASE_S4MP_STRICT` | `0` | Hard-fail on skip/fail |

Pins: `gatk-rs=` and `S4MP=` in `PINNED_VERSIONS.txt`.

## Phase B (Ferrum WES)

Ferrum-GA4GH-Demo supports `./run --gatk-rs` → `workflows/tiny_hc_gatk_rs.nf`. Soft-skips if `gatkr/gatk-rs` (or `FERRUM_GA4GH_GATK_RS_IMAGE`) is missing.

```bash
# From Showcase (does not replace default golden path):
make gatk-rs-wes
# or after Broad path:
SHOWCASE_ENABLE_GATK_RS_WES=1 make golden-path
```

`wes_integration` is optional and Alpha — soft-fail/skip is success for honesty, not a greenwash.

## Phase A reminder

Local smoke + S4MP sidecar remain the lightweight path; see commands above.
