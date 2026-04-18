# SynapticFour Showcase

End-to-end **orchestration** and **narrative** for demos, sales engineering, and integration tests across Synaptic Four repositories. This repo intentionally **does not** replace specialized benchmarks or GA4GH conformance suites; it **composes** them.

## Why this exists

You already have strong building blocks:

| Piece | Repo | Role for the showcase |
|-------|------|------------------------|
| Ferrum stack + ingest + Crypt4GH + provenance / RO-Crate | [Ferrum](https://github.com/SynapticFour/Ferrum) | Data plane, APIs, export story |
| GIAB-style slice, TRS/DRS/WES/TES, hap.py vs truth, Crypt4GH macro | [Ferrum-GA4GH-Demo](https://github.com/SynapticFour/Ferrum-GA4GH-Demo) | **Public gold-standard** path with documented metrics |
| GA4GH API conformance | [HelixTest](https://github.com/SynapticFour/HelixTest) | Regression / “APIs behave” gate |
| Pipeline audit, signing, ISO/AI-Act-flavoured evidence | [HELIOS](https://github.com/SynapticFour/HELIOS) | Wrap the **same** Nextflow (or Snakemake) workdir the demo uses |
| Research assistant + WES-oriented flows | [bioresearch-assistant](https://github.com/SynapticFour/bioresearch-assistant) | Optional **downstream** step on `query.vcf.gz` (or a tiny derived subset) |
| OSS comparison / teaching stack | [Open-Source-GA4GH-Stack](https://github.com/SynapticFour/Open-Source-GA4GH-Stack) | Optional **contrast** narrative, not required for the happy path |

**SynapticFour-Showcase** is the **glue**: one documented journey, one CI matrix (where feasible), timings and artefacts collected in one place, and explicit versioning of sibling repo pins.

**Demo runbook (commands, artefacts, cleanup):** [DEMO.md](DEMO.md)

Before a live demo, run **`./scripts/preflight.sh`** (add `--strict` or `SHOWCASE_PREFLIGHT_STRICT=1` to fail the script if Docker or Python 3.11+ is missing). Sibling repo revisions for reproducibility live in **[PINNED_VERSIONS.txt](PINNED_VERSIONS.txt)**; refresh with **`./scripts/refresh-pinned-versions.sh`** (uses `../Ferrum-GA4GH-Demo`, `../HELIOS`, `../bioresearch-assistant` by default).

## Suggested golden path (v1)

1. **Data & APIs (Ferrum + demo)** — Run `Ferrum-GA4GH-Demo` (`./run`, optionally `--macro` for Crypt4GH-at-rest). You get public reference data, TRS-resolved tools, WES on TES, and **hap.py**-style truth comparison plus `drs_micro.json` timings.
2. **Compliance / reproducibility evidence (HELIOS)** — Re-run or wrap the **same** Nextflow leg (`workflows/tiny_hc.nf` in the demo) with `helios run --pipeline nextflow --work-dir … --output-dir …` so audit records align with the demo’s workdir layout.
3. **Human-facing research step (optional)** — Feed the resulting VCF (or a thinned tutorial VCF) into **bioresearch-assistant** for interpretation-style UX; keep prompts and file sizes suitable for a **10-minute** demo.
4. **FAIR / publication packaging** — Use Ferrum’s provenance / **RO-Crate** export (see upstream `docs/PROVENANCE.md`) to package “what ran, with which inputs, which outputs” for citation or Zenodo-style deposit.

## Public “gold standard” anchors (examples)

- **GIAB / reference materials** — Already wired in `Ferrum-GA4GH-Demo` (subset + hap.py story).
- **API behaviour** — `HelixTest` Ferrum profile documents expected gateway layout and features.
- **Regulatory / audit narrative** — HELIOS docs map checks to ISO 15189 / EU AI Act *technical documentation* angles (always label as evidence tooling, not certification).

## Roadmap (incremental)

- **M0** — This README + pinned revisions table (submodule or documented SHAs).
- **M1** — `scripts/run-golden-path.sh`: runs **Ferrum-GA4GH-Demo** (`./run --nextflow` plus optional extra flags), then **HELIOS** on the WES work directory and demo `results/` as output dir; writes **`showcase-report.json`** (merged timings + benchmark summary + HELIOS check counts).

### M1 usage

From this repository root (Docker required for the demo leg; **Python 3.11+** required for HELIOS and for `assemble_showcase_report.py`):

```bash
chmod +x scripts/run-golden-path.sh
./scripts/run-golden-path.sh
```

Optional macro / Crypt4GH demo flags (same as `Ferrum-GA4GH-Demo/run`):

```bash
./scripts/run-golden-path.sh -- --macro
```

Environment:

| Variable | Meaning |
|----------|---------|
| `SHOWCASE_DEMO_ROOT` | Path to **Ferrum-GA4GH-Demo** (default: `../Ferrum-GA4GH-Demo` relative to this repo) |
| `SHOWCASE_HELIOS_ROOT` | Path to **HELIOS** sources if `helios` is not on `PATH` |
| `SHOWCASE_REPORT` | Output path for the merged JSON (default: `./showcase-report.json`) |
| `SHOWCASE_SKIP_DEMO` | Set to `1` to skip `./run` and only run HELIOS + report (expects existing `results/metrics.json`) |
| `SHOWCASE_DEMO_EXTRA` | Extra words for `./run` after `--nextflow` (e.g. `--macro`) |
| `FERRUM_GA4GH_WES_HOST_OVERRIDE` | If set, must match the demo’s WES host bind (see Ferrum-GA4GH-Demo docs) |
| `SHOWCASE_PYTHON` | Python 3.11+ binary if `python3` on `PATH` is too old (e.g. `/opt/homebrew/bin/python3.12`) |
| `SHOWCASE_PREFLIGHT_STRICT` | Set to `1` so `scripts/preflight.sh` exits non-zero on failed checks (same as `--strict`) |
| `SHOWCASE_PINNED_OUT` | Override output path for `scripts/refresh-pinned-versions.sh` (default: `./PINNED_VERSIONS.txt`) |
| `SHOWCASE_HEARTBEAT_SECONDS` | Progress heartbeat interval during long steps (default: `30`, set `0` to disable) |
| `SHOWCASE_ENABLE_M2` | Set to `1` to run M2 after HELIOS + refresh the report |
| `SHOWCASE_M2_PIPELINE` | `handoff` (default) or `full` (handoff + DRS import + phenopacket/VCF link) |

HELIOS uses repo-local **`helios.toml`**: audit DB and keys under `.cache/helios/`, reports under `helios-reports/`. Only **`SEC-CONTAINER-001`** is enabled so GRCh37 demo data does not trip the GRCh38 reference check.
M1 also writes a presentation-friendly **`showcase-report.md`** next to the JSON report.

### M1 troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| `need Python 3.11+` or `ImportError: cannot import name 'UTC'` | System `python3` is too old (often 3.9 on macOS) | Run with `SHOWCASE_PYTHON=/opt/homebrew/bin/python3.12 ./scripts/run-golden-path.sh` (or any Python 3.11+) |
| `helios: command not found` | HELIOS CLI not installed in active Python env | Either install with `pip install helios-audit`, or set `SHOWCASE_HELIOS_ROOT` so script uses source fallback |
| `ModuleNotFoundError: No module named 'typer'` | HELIOS source fallback is used, but Python env lacks HELIOS deps | Install once with `"$SHOWCASE_PYTHON" -m pip install -e "$SHOWCASE_HELIOS_ROOT"` (or `python3.12 -m pip install -e ../HELIOS`) |
| Docker build fails at `ferrum-gateway ... --features "tes-docker"` | Overlay `Cargo.toml` and build arg got out of sync | Pull latest workspace changes, then rerun; if needed clear demo cache (`rm -rf ../Ferrum-GA4GH-Demo/.cache/ferrum`) before rerun |
| `missing .../results/metrics.json` | Demo leg did not run or failed early | Run once without `SHOWCASE_SKIP_DEMO`, inspect `Ferrum-GA4GH-Demo` logs, then retry |
| `WES work dir not found` | `FERRUM_GA4GH_WES_HOST_OVERRIDE` mismatch or run id missing | Unset override or point it to same host path used during demo run |
| Long runtime / heavy pulls | First run pulls images and data | Prefer warm reruns with `SHOWCASE_SKIP_DEMO=1` if only HELIOS/report changes are needed |
| `Bind for 0.0.0.0:5432 failed: port is already allocated` | Ferrum demo Postgres and `bioresearch-assistant` Postgres both want host `5432` | Showcase scripts auto-apply [contrib/bioresearch-assistant-postgres-override.yml](contrib/bioresearch-assistant-postgres-override.yml) (host **15432** → container 5432). To use plain `5432` for BRA: `SHOWCASE_BRA_POSTGRES_HOST_PORT_OVERRIDE=0`. Or stop the other stack: `./scripts/stop-showcase.sh --hard` |

- **M2** — Handoff + optional **M2.1** DRS import + **M2.2** Phenopacket + VCF asset link; artefacts under `artifacts/m2/`.
- **M3** — **CI** (light): GitHub Actions runs `bash -n` on all `scripts/*.sh` and `py_compile` on `assemble_showcase_report.py`. Run the same locally: `./scripts/ci-check.sh`. Heavy demo/compose runs stay manual or a separate scheduled workflow.

### M3 (CI)

Workflow: [.github/workflows/ci.yml](.github/workflows/ci.yml)

Local check (matches CI):

```bash
./scripts/ci-check.sh
```

CI also runs `assemble_showcase_report.py` against [fixtures/ci/](fixtures/ci/) (no Docker).

### bioresearch-assistant + Ferrum in parallel

By default, M2 auto-start uses the Postgres override so BRA maps to host port **15432** while Ferrum demo can keep **5432**. Inside Docker networks, services still use `postgres:5432`. Override path: `SHOWCASE_BRA_COMPOSE_OVERRIDE` (optional), or disable with `SHOWCASE_BRA_POSTGRES_HOST_PORT_OVERRIDE=0`.

### M2 usage (downstream handoff)

Run standalone:

```bash
./scripts/run-m2-bioresearch.sh
```

Or as part of the main path:

```bash
SHOWCASE_ENABLE_M2=1 ./scripts/run-golden-path.sh
```

Optional stack start for `bioresearch-assistant`:

```bash
SHOWCASE_M2_START_BRA=1 ./scripts/run-m2-bioresearch.sh
```

M2.1 — optional automated DRS import into `bioresearch-assistant`:

```bash
./scripts/run-m2-bioresearch-import.sh
```

Dry-run (only validates inputs and writes planned request):

```bash
./scripts/run-m2-bioresearch-import.sh --dry-run
```

`run-m2-bioresearch-import.sh` auto-starts `bioresearch-assistant` by default if `http://localhost:8000` is not reachable. Disable with:

```bash
SHOWCASE_M2_AUTO_START_BRA=0 ./scripts/run-m2-bioresearch-import.sh
```

If `bioresearch-assistant/.env` is missing, the script auto-bootstraps it from `.env.example` by default. Disable with:

```bash
SHOWCASE_M2_AUTO_BOOTSTRAP_BRA_ENV=0 ./scripts/run-m2-bioresearch-import.sh
```

When running M2 from `run-golden-path.sh`, BRA auto-start is enabled by default and can be controlled via:

```bash
SHOWCASE_ENABLE_M2=1 SHOWCASE_ENABLE_M2_START_BRA=0 ./scripts/run-golden-path.sh
```

Full M2 pipeline in one go (after HELIOS), including import + link:

```bash
SHOWCASE_ENABLE_M2=1 SHOWCASE_M2_PIPELINE=full ./scripts/run-golden-path.sh
```

M2.2 — create a **Phenopacket** (`showcase-{wes_run_id}`) and link the imported VCF as a DRS asset (requires M2.1 completed with `status: imported`):

```bash
./scripts/run-m2-bioresearch-link.sh
```

Or run the whole M2 chain as a single script:

```bash
./scripts/run-m2-bioresearch-downstream.sh
```

### Stop / cleanup after demo

Stop all showcase-related compose stacks:

```bash
./scripts/stop-showcase.sh
```

This includes stacks that may have been auto-started by M2/M2.1 (notably `bioresearch-assistant`).

Hard cleanup (also remove volumes):

```bash
./scripts/stop-showcase.sh --volumes
```

If containers still linger (orphans, renamed runs), use **hard** mode — same as `--volumes`, then force-stops/removes any container whose name still matches `ferrum-ga4gh-demo` or `bioresearch-assistant`:

```bash
./scripts/stop-showcase.sh --hard
```

For a full Docker reset (all projects), use `docker stop $(docker ps -q)` and `docker system prune` only when you intend to wipe everything.

## Relationship to other “demo” repos

- **Ferrum-GA4GH-Demo** stays the **benchmark-centric** GA4GH demo (do not fork hap.py / ingest logic here).
- **Showcase** owns **cross-product sequencing**, **story**, and **release notes** for “what we showed customer X”.

## License

Apache-2.0 (align with dominant repos in the stack) unless you prefer MIT for this meta-repo only — set explicitly when publishing to GitHub.
