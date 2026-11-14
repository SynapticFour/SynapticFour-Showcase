# Getting started

Two evidence layers. Do not mix them.

## Fixture spine (no Docker)

```bash
make integration-suite
```

Same class of check as GitHub Actions. Does not start Ferrum, HELIOS, or Solum.

## Live golden path (Docker)

```bash
make up
```

Default path is Ferrum-GA4GH-Demo + HELIOS (a subset). Sibling checkouts must match [PINNED_VERSIONS.txt](../PINNED_VERSIONS.txt) unless `SHOWCASE_ALLOW_PIN_DRIFT=1`.

Optional Solum stage: `SHOWCASE_ENABLE_SOLUM=1` or `make solum-stage`. Stop: `make down`.

Walkthrough of fixture → golden path → Passports → Solum: [for-customers/start-here.md](for-customers/start-here.md). Evidence: [for-customers/evidence-pack.md](for-customers/evidence-pack.md). Technical notes: [for-evaluators/](for-evaluators/). What a run shows, and what it does not show: [WHAT-A-RUN-SHOWS.md](WHAT-A-RUN-SHOWS.md).

## What you should see

`make integration-suite` is the path that runs from this repository alone. It does not start Docker. The same command is `.github/workflows/ci.yml`.

You should see `demo/verification/SUITE-MANIFEST.json`. The workflow asserts `suite_kind` is `synapticfour-showcase-integration-suite`, `mode` is `fixtures`, and `summary.ok` is true.

`make up` is the second path. It needs Docker and a checkout of [Ferrum-GA4GH-Demo](https://github.com/SynapticFour/Ferrum-GA4GH-Demo) and of [HELIOS](https://github.com/SynapticFour/HELIOS). The script's default directories are beside this clone. Those checkouts must match [PINNED_VERSIONS.txt](../PINNED_VERSIONS.txt) unless `SHOWCASE_ALLOW_PIN_DRIFT=1`. This page does not start that path. Stop a live stack with `make down`.
