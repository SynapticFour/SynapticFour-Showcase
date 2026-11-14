# What a run shows

Two layers. Do not mix them.

| Layer | What it is | What it is not |
|-------|------------|----------------|
| Fixture spine (`make integration-suite`) | Syntax, unit tests, honesty gates, committed JSON shapes. GitHub Actions runs this without Docker. | A running live product stack |
| Live golden path (`make up`) | Docker, sibling checkouts at [PINNED_VERSIONS.txt](../PINNED_VERSIONS.txt) (or `SHOWCASE_ALLOW_PIN_DRIFT=1`), real Nextflow WES + HELIOS | Not GitHub-hosted. Not production proof. |

The default golden path is a subset: [Ferrum-GA4GH-Demo](https://github.com/SynapticFour/Ferrum-GA4GH-Demo) and [HELIOS](https://github.com/SynapticFour/HELIOS). Solum and BioResearch Assistant are opt-in (`SHOWCASE_ENABLE_SOLUM=1` or `make solum-stage`).

Checked-in files under `demo/results/` and `demo/verification/` are from runs or labelled fixtures. The HELIOS example hashes Nextflow config and log (not BAM) and warns on GATK `4.4.0.0` without a digest.

## What a run does not show

- A green fixture job is not live proof of product `main`.
- The pins in [PINNED_VERSIONS.txt](../PINNED_VERSIONS.txt) were last refreshed on 2026-08-24. They are the published demo, not live sibling HEAD. HELIOS is pinned at tag `v0.1.1`. That pin is the published demo. It is not a statement that the current HELIOS release is `v0.1.1`.
- A green run is a technical signal for this orchestrator and those pins. It is not a certificate and not a clinical pilot.
- Passports are not on the default golden path. The optional harvest is `make co-deploy-harvest`, through Ferrum-GA4GH-Demo.

The longer customer notes stay in [for-customers/evidence-pack.md](for-customers/evidence-pack.md). The evaluator kit stays in [for-evaluators/](for-evaluators/).
