# Live verification run (2026-08-06)

Record of an end-to-end exercise on a **developer workstation**. **Not a certificate.** Soft-skips are intentional for Alpha paths.

## Outcomes

| Constellation | Result | Notes |
|---------------|--------|-------|
| C0 Fixture suite | **ok** | Same as GitHub Actions (no Docker) |
| C1 Ferrum Nextflow + Broad GATK + hap.py | **ok** | F1=1.0 on synthetic demo subset (expected) |
| C1 HELIOS audit | **ok** | Minimal `helios.toml` set; do not read as full provenance |
| C2 Solum Stage-1 | **ok** | allow 200 / deny 403 / tamper detect |
| C3 Consent allow | **ok** | `wes_may_proceed=true` (technical, not legal) |
| C4 Evidence Pack | **ok** | Live pack under `artifacts/` (gitignored) |
| C5 gatk-rs smoke | **ok** | Local release binary (Alpha) |
| C6 S4MP sidecar | **fixture fallback** | Not a live `.s4` port-diff |
| C7 Ferrum `--gatk-rs` WES | **skipped** | Image missing |

See `docs/for-customers/integration-verification.md` to reproduce.

**15 Aug 2026 addendum:** Solum Stage-1 artefacts were regenerated (allow 200 / deny 403 / tamper) against SHA `6b4519c`. Golden-path Nextflow WES was **not** re-run. Sheet: [docs/for-customers/persona-evidence.md](../../docs/for-customers/persona-evidence.md).
