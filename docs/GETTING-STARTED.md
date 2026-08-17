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

Walkthrough of fixture → golden path → Passports → Solum: [for-customers/start-here.md](for-customers/start-here.md). Evidence: [for-customers/evidence-pack.md](for-customers/evidence-pack.md). Technical notes: [for-evaluators/](for-evaluators/).
