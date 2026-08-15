# Published verification evidence

This directory is a **frozen fixture Evidence Pack** plus `SUITE-MANIFEST.json` from
`./scripts/run-integration-suite.sh --fixtures --publish-verification`.

GitHub Actions runs this same command. It does **not** start Docker, Ferrum, HELIOS, or Solum.

The genomic `helios-report.json` here matches default `helios.toml` (`SEC-CONTAINER-001` only).
Clinical-plane evidence is `solum-audit-helios-chain.json`, not mixed into the genomic report.

## Re-run locally

```bash
./scripts/run-integration-suite.sh --fixtures --publish-verification
# Opt-in live (Docker / siblings):
./scripts/run-integration-suite.sh --live
```

See `docs/for-customers/integration-verification.md` and `docs/for-customers/overview.md`.

## Honesty

This is **not** a certificate. Soft stages (gatk-rs / S4MP) may skip or soft-fail when Alpha
binaries/images are missing. Default genomic evidence remains Ferrum Nextflow + Broad GATK + HELIOS.
