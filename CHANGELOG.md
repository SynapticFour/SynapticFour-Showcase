# Changelog

All notable changes to SynapticFour-Showcase are documented in this file.

## [Unreleased]

### Changed

- **PINNED_VERSIONS.txt** — Ferrum-GA4GH-Demo pin `41d7b89` (benchmark artefacts committed upstream after showcase run).

### Changed (June 2026 sync #2)

- **PINNED_VERSIONS.txt** — Updated sibling Git HEADs (June 2026 sync #2):
  - Ferrum-GA4GH-Demo: `0e487af` (paper bundle redaction; benchmark refresh `d00744b`)
  - HELIOS: `af1c5a5` (dependabot hygiene; no CLI/API changes)
  - bioresearch-assistant: `08cefef` (cryptography security bump; compose ports unchanged)
- **demo/results/** — Regenerated from golden path (23 Jun 2026); sanitized host paths; added `drs-micro-example.json`.
- **scripts/publish-demo-results.sh** — New helper to copy golden-path outputs into `demo/results/` with portable paths after `./scripts/run-golden-path.sh` (stakeholder report + illustrative DRS object).

### Changed (June 2026 sync #1)

- **PINNED_VERSIONS.txt** — Updated sibling Git HEADs (June 2026):
  - Ferrum-GA4GH-Demo: `115ebe0` (ferrum-field link update)
  - HELIOS: `a519e03` (includes `python -m helios.cli` fix)
  - bioresearch-assistant: `a2a1827` (unified lifecycle/docs)
- **demo/results/** — Regenerated from golden path (Nextflow engine, Ferrum gateway on port 18080):
  - `metrics.json`, `benchmark.json`, `helios-report-example.json`
  - `drs-link-example.json` (DRS URI scheme `drs://ferrum-gateway:8080/…`)
  - `showcase-report-example.md`
- **docs/for-evaluators/technical-evaluation-kit.md** — Ferrum service-info via gateway `127.0.0.1:18080`; HELIOS commands aligned with `helios run` CLI (replaces obsolete `helios-audit run --workdir`).
- **DEMO.md** — Documented `.venv` + `pip install -e ../HELIOS` for local HELIOS dependencies; troubleshooting for missing Python deps.
- **ROADMAP.md** — Marked neighbor-repo sync and artefact refresh as completed (June 2026).

### Notes

- Ferrum-GA4GH-Demo now defaults to host gateway port **18080** (not 8080/8090 on separate services).
- HELIOS showcase config (`helios.toml`) still uses minimal check set `SEC-CONTAINER-001` for GRCh37 demo compatibility.
- Upstream HELIOS: `python -m helios.cli` fix merged (move `if __name__` after helper definitions).

## [2026-04] — Customer-facing showcase launch

- Customer README (DE/EN), `demo/results/` pre-generated artefacts
- Docs split: `for-customers/`, `for-evaluators/`
- `PINNED_VERSIONS.txt`, `scripts/preflight.sh`, golden-path orchestration
