# Changelog

All notable changes to SynapticFour-Showcase are documented in this file.

## [Unreleased]

### Added

- **Start-here map** — [docs/for-customers/start-here.md](docs/for-customers/start-here.md): fixtures → golden path → Passports → Solum.
- **Passports co-deploy harvest (soft)** — `scripts/harvest-co-deploy.sh`, `make co-deploy-harvest` / `-fixtures`, Evidence Pack roles `ga4gh_infra_co_deploy` / `ga4gh_infra_co_deploy_harvest`, golden-path opt-in `SHOWCASE_ENABLE_CO_DEPLOY_HARVEST`.
- **H5 SaaS-ready preparedness (optional)** — [H5-SAAS-READY-CHECKLIST](docs/internal/pilots/H5-SAAS-READY-CHECKLIST.md) · [H5-MANAGED-SINGLE-TENANT](docs/pilots/H5-MANAGED-SINGLE-TENANT.md) · [ADR 0003 tenant boundaries](docs/adr/0003-tenant-boundaries.md); not a SaaS launch.
- **Horizon open gates** — [HORIZON-OPEN-GATES.md](docs/pilots/HORIZON-OPEN-GATES.md) lists remaining counsel/site/deferred items after H1–H5 eng exits.
- **H3 full engineering exit** — Path E+ CDR + subject-link fixtures; [H3-PILOT-CHECKLIST](docs/pilots/H3-PILOT-CHECKLIST.md) / [H3-EXECUTION-RECORD](docs/internal/pilots/H3-EXECUTION-RECORD.md); evidence-pack roles `solum_cdr` / `solum_subject_link`.
- **H2.4 AWS KMS CLI/sidecar signed off** — optional `aws-kms` feature; second-pass §A closed; not HSM.
- **Kenya K1 Vorprüfung applied (non-counsel)** — Solum `kenya-dpa` → PROVISIONAL-PRODUCTION-CANDIDATE; H4 docs updated; real counsel still required.
- **H2.2 Org CAP signed off** — sidecar OIDC groups → CAP_*; [ADR 0002](docs/adr/0002-solum-org-iam-cap.md); `make h22-org-cap`.
- **H2.1 Teeth signed off** — Solum revoke → Ferrum DRS/WES 403 when configured; [ADR 0001](docs/adr/0001-solum-ferrum-consent-access.md); `make h21-teeth`.
- **H2 spine v1 signed off** — WES fail-closed under `require_auth`, visa/ops honesty, Solum zeroize cross-links; see `docs/pilots/H2-*.md · docs/internal/pilots/`.
- **H1 signed off** — checklist + [H1-EXECUTION-RECORD.md](docs/internal/pilots/H1-EXECUTION-RECORD.md) + [H1-KNOWN-LIMITATIONS.md](docs/pilots/H1-KNOWN-LIMITATIONS.md) (auth-on Ferrum + docker TES + Solum CustomerHeld + Evidence Pack + MinIO/Solum restore, 2026-08-06).
- **H1 / H4 pilot packs** — `docs/pilots/H1-PILOT-CHECKLIST.md`, `H4-GEOGRAPHY-DECISION.md` (Kenya first).
- **Coordinated portfolio roadmap** — `docs/internal/COORDINATED-PORTFOLIO-ROADMAP.md` (H0–H5 on-prem first; Solum dual-track; SaaS-ready backseat).
- **Customer integration suite** — `scripts/run-integration-suite.sh`, `make integration-suite`, published `demo/verification/`, overview + verification docs.
- **W4 Phase B** — optional Ferrum `--gatk-rs` via `run-gatk-rs-wes.sh` / `SHOWCASE_ENABLE_GATK_RS_WES` (soft-fail; does not replace Broad Nextflow).
- **W4 gatk-rs / S4MP (Phase A)** — soft-fail `run-gatk-rs-smoke.sh` + `attach-s4mp-evidence.sh`, fixtures, Evidence Pack roles, honesty doc; opt-in via `SHOWCASE_ENABLE_GATK_RS` / `SHOWCASE_ENABLE_S4MP`.
- **W3 Consent gate** — `scripts/run-consent-gate.sh`, allow/deny before WES, fixtures, customer honesty doc; golden-path opt-in via `SHOWCASE_ENABLE_CONSENT_GATE`.
- **W2 Evidence Pack** — `scripts/evidence-pack.sh` / `evidence_pack.py`, `make evidence-pack` / `evidence-pack-fixtures`, customer honesty doc, HelixTest gate doc, CI fixture pack.
- **W0 complete / W1 landed** — Solum pins, evaluator Path E, preflight Solum-Demo check, `scripts/run-solum-stage.sh`, `make solum-stage` / `make golden-path-with-solum`, example Solum artefacts, report assembler Solum section.
- **Evidence-chain plan** — `docs/internal/IMPLEMENTATION-PLAN-EVIDENCE-CHAIN.md`.
- **Solum companion narrative** — README DE/EN, `which-path` Scenario E, ROADMAP links.

### Changed

- **Showcase entry honesty** — README “orchestrated today / next” matches W1–W4 Done; ga4gh-infra / Passports via Demo `--with-infra`; clone recipe in DEMO; overview C8 + Lab-Kit/Field row; pin `ga4gh-infra`; preflight soft-check.
- **Ferrum-GA4GH-Demo pointers** — Demo `docs/COVERAGE.md` / `make smoke-evidence`; gatk-rs Phase B via Demo `--gatk-rs` (soft-skip); `FERUM_SRC`/`FERRUM_SRC` alias honesty in Ferrum ECOSYSTEM cross-links.
- **Horizon open gates** — pointer to Solum-Demo `make smoke-all` / H3 `make smoke-h3` as the local verification surface beside Showcase `make solum-stage`.
- **PINNED_VERSIONS.txt** — added optional `gatk-rs`, `S4MP` (W4); Ferrum/HELIOS/BRA/Solum pins retained.
- **PINNED_VERSIONS.txt** — added `Solum-Demo`, `Solum-tag`, optional `HelixTest` (Ferrum/HELIOS/BRA pins retained for committed demo artefacts).
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
