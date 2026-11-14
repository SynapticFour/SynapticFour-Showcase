# Synaptic Four Showcase

This showcase is a guided path through pinned product revisions, so a reader can see those revisions run together.

For someone checking how the pinned products sit together, and for someone who needs the fixture checks without Docker.

**Status: No public status is recorded.** The claims registry has no stage for this showcase. Calling it a reference demo describes the repository. That phrase is not one of the four public status labels.

## What a run shows

- `make integration-suite` shows the fixture spine: syntax, unit tests, honesty gates, and the committed JSON shapes. GitHub Actions runs that without Docker.
- `make up` shows the default golden path, a subset: [Ferrum-GA4GH-Demo](https://github.com/SynapticFour/Ferrum-GA4GH-Demo) and [HELIOS](https://github.com/SynapticFour/HELIOS), with Docker and those checkouts at the pin file.

## Limits

- A green fixture job is not live proof of product `main`.
- [PINNED_VERSIONS.txt](PINNED_VERSIONS.txt) was last refreshed on 2026-08-24. Those pins are the published demo, not live sibling HEAD. HELIOS is pinned at tag `v0.1.1`. That pin is the published demo. It is not a statement that the current HELIOS release is `v0.1.1`.
- Solum and BioResearch Assistant are opt-in (`SHOWCASE_ENABLE_SOLUM=1` or `make solum-stage`).
- A green run is a technical signal for this orchestrator and those pins. It is not a certificate and not a clinical pilot.
- This repository is not legal advice and not GA4GH certification.

The two layers are in [docs/WHAT-A-RUN-SHOWS.md](docs/WHAT-A-RUN-SHOWS.md).

## Quick start

Prerequisites for the path in this repository: `bash`, `python3`, and `make`. No Docker.

```bash
make integration-suite
```

You should see `demo/verification/SUITE-MANIFEST.json` with `mode` `fixtures` and `summary.ok` true. Details are in [docs/GETTING-STARTED.md](docs/GETTING-STARTED.md).

The live path needs Docker and checkouts of [Ferrum-GA4GH-Demo](https://github.com/SynapticFour/Ferrum-GA4GH-Demo) and [HELIOS](https://github.com/SynapticFour/HELIOS) at the pin file:

```bash
make up
```

Stop with `make down`.

## Documentation

### Tutorial

- [Getting started](docs/GETTING-STARTED.md)
- [Start here](docs/for-customers/start-here.md)

### How-to guides

- [DEMO.md](DEMO.md) — the runbook
- [Evaluation kit](docs/for-evaluators/technical-evaluation-kit.md)
- [Deployment paths](docs/for-evaluators/deployment-paths.md)
- [Which path](docs/for-customers/which-path.md)

### Reference

- [What a run shows](docs/WHAT-A-RUN-SHOWS.md)
- [For evaluators](docs/FOR-EVALUATORS.md)
- Pin file: [PINNED_VERSIONS.txt](PINNED_VERSIONS.txt)
- [Evidence pack](docs/for-customers/evidence-pack.md)
- [FAQ](docs/for-evaluators/faq.md)

### Explanation

- [Tenant boundaries](docs/adr/0003-tenant-boundaries.md)
- [Consent access](docs/adr/0001-solum-ferrum-consent-access.md)
- [Customer overview](docs/for-customers/overview.md)

The complete list is [docs/README.md](docs/README.md).

## Licence

This repository is Apache License 2.0. The file is [LICENSE](LICENSE). Product repositories keep their own licences. The commercial cores are BUSL-1.1.

## Cite

Use [CITATION.cff](CITATION.cff). Prefer that file over a hand-copied line.

## Website

- Open source: [https://synapticfour.com/en/opensource/](https://synapticfour.com/en/opensource/)
- Technical profile: [https://synapticfour.com/en/technical/code/](https://synapticfour.com/en/technical/code/)

The same pages exist in German (`/de/opensource/`, `/de/technik/code/`) and in French (`/fr/opensource/`, `/fr/technique/code/`).

The map of repositories: [profile/README.md](https://github.com/SynapticFour/.github/blob/main/profile/README.md).

Contact: [contact@synapticfour.com](mailto:contact@synapticfour.com)
