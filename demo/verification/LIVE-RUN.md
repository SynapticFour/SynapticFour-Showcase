# Live verification run (2026-08-06)

Record of an honest end-to-end exercise of SynapticFour Showcase claims on a
developer workstation. **Not a certificate.** Soft-skips are intentional for Alpha paths.

## Outcomes

| Constellation | Result | Notes |
|---------------|--------|-------|
| C0 Fixture suite | **ok** | Published into this directory |
| C1 Ferrum Nextflow + Broad GATK + hap.py | **ok** | precision/recall/F1 = 1.0 on demo subset; ~650s cold build |
| C1 HELIOS audit | **ok** | Grade A, 1/1 checks passed |
| C2 Solum Stage-1 | **ok** | allow 200 / deny 403 / tamper detect |
| C3 Consent allow | **ok** | `wes_may_proceed=true` |
| C4 Evidence Pack | **ok** | Live pack under `artifacts/` (gitignored) |
| C5 gatk-rs smoke | **ok** | Local release binary |
| C6 S4MP sidecar | **ok** | Fixture fallback |
| C7 Ferrum `--gatk-rs` WES | **skipped** | Soft-skip: image missing |

See `docs/for-customers/integration-verification.md` to reproduce.
