# For evaluators

**Status: No public status is recorded** for this showcase. The claims registry has no stage for it. "Reference demo" describes the repository. It is not one of the four public status labels.

## What a run shows

A successful `make integration-suite` shows that the fixture spine passed: syntax, unit tests, honesty gates, and the committed JSON shapes. A successful `make up` shows the pinned Ferrum-GA4GH-Demo and HELIOS subset on a machine that has Docker and those checkouts.

The two layers are in [WHAT-A-RUN-SHOWS.md](WHAT-A-RUN-SHOWS.md). The pin file is [PINNED_VERSIONS.txt](../PINNED_VERSIONS.txt).

## What a run does not show

- A green fixture job is not live proof of product `main`.
- The pins were last refreshed on 2026-08-24. They are not live sibling HEAD.
- A green run is not a certificate and not a clinical pilot.
- The evidence-chain implementation plan and the coordinated portfolio roadmap are not published in this repository. The runnable Solum step that is in this clone is `make solum-stage`.

The longer kit is [for-evaluators/](for-evaluators/): the FAQ, the evaluation steps, deployment paths, and the HelixTest gate. Procurement notes are under [for-customers/](for-customers/).
