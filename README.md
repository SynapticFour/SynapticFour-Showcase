# Synaptic Four — Showcase

Public evidence pack and pin checkout for the Ferrum / GA4GH repositories. **Reference / demo** — not a product and not a SKU.

**Maturity: Reference / demo.** A green fixture job is not live proof of product `main`. The default golden path is a **Subset**: Ferrum-GA4GH-Demo + HELIOS.

> This README describes technical capabilities, not legal advice. It is not GA4GH certification.

## Ferrum / GA4GH suite

These ten public repositories are from the same organisation and can be composed. They are not a fifth product and not a bundle SKU. Each repository keeps its own version and license. Roles, maturity, and who consumes whom: [SUITE-OVERVIEW](https://github.com/SynapticFour/Ferrum/blob/main/docs/SUITE-OVERVIEW.md).

## Quick start

```bash
make integration-suite    # fixture spine (no Docker; same class as GitHub Actions)
make up                   # live golden path (Docker; Demo + HELIOS subset)
```

Pins: [PINNED_VERSIONS.txt](PINNED_VERSIONS.txt). Stop: `make down`. Solum and BRA paths are opt-in (`SHOWCASE_ENABLE_SOLUM=1` / `make solum-stage`).

Two layers — do not mix them:

| Layer | What it is | What it is not |
|-------|------------|----------------|
| Fixture spine (`make integration-suite`) | Syntax, unit tests, honesty gates, committed JSON shapes. GitHub Actions runs this without Docker. | A running Ferrum / HELIOS / Solum stack |
| Live golden path (`make up`) | Docker, sibling checkouts at PINNED_VERSIONS.txt (or `SHOWCASE_ALLOW_PIN_DRIFT=1`), real Nextflow WES + HELIOS | Not GitHub-hosted. Not production proof. |

Checked-in files under `demo/results/` and `demo/verification/` are from runs **or** labelled fixtures. The HELIOS example hashes Nextflow config/log (not BAM) and warns on GATK `4.4.0.0` without a digest.

## Documentation

- [Getting started](docs/GETTING-STARTED.md)
- [DEMO.md](DEMO.md) · [Evidence pack](docs/for-customers/evidence-pack.md)

## License

Apache License 2.0 — see [LICENSE](LICENSE). Product repositories keep their own licenses (Ferrum / Solum / BRA: BUSL-1.1).
