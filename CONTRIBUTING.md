# Contributing to SynapticFour-Showcase

This repository is a public **integrator** (scripts, pins, fixtures). Product issues belong in the upstream product repositories.

Please open a **pull request** against `main` rather than pushing commits directly. GitHub Actions fixture-spine + secret-scan must be green. Do not describe fixture CI as a live stack.

Evaluators should judge **HEAD of `main`**, not older commits — see [docs/for-evaluators/evaluate-at-head.md](docs/for-evaluators/evaluate-at-head.md). We do not rewrite public git history.

## Document structure

| Directory | Audience | Purpose |
|-----------|----------|---------|
| `docs/for-customers/` | Operators and evaluators | Evidence notes, FAQ, paths |
| `docs/for-evaluators/` | Technical leads | How to re-run claims |
| `demo/results/` | Everyone | Pre-generated or labelled fixtures |
| `scripts/` | Technical teams | Demo orchestration and CI |

After a local golden-path run: `./scripts/publish-demo-results.sh` updates `demo/results/` (portable paths, no host identifiers).

## Bugs in Ferrum, HELIOS, Solum, or BioResearch Assistant?

Open issues in the respective upstream repositories: [Ferrum](https://github.com/SynapticFour/Ferrum), [HELIOS](https://github.com/SynapticFour/HELIOS), [Solum](https://github.com/SynapticFour/Solum), [BioResearch Assistant](https://github.com/SynapticFour/bioresearch-assistant).
