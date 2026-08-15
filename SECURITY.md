# Security

This repository is an **integrator and demo orchestrator**. It is not a
production control plane.

## What we scan

- Gitleaks on push/PR against **git history** (`.github/workflows/secret-scan.yml`)
- Pre-commit `detect-private-key`
- Fixture CI (`.github/workflows/ci.yml`) — syntax, unit tests, honesty gates;
  **not** a live stack

## Demo tokens

Live Solum scripts **do not** default to a sidecar token. Against the published Solum-Demo compose:

```bash
SHOWCASE_USE_DEMO_SIDECAR_TOKEN=1 make solum-stage
```

That well-known local token (`solum-demo-local-token-not-for-production`) is a **shared demo secret**, not a customer credential. Export `SOLUM_SIDECAR_TOKEN` for any other stack.

To refuse the demo token even if someone exports it:

```bash
SHOWCASE_REQUIRE_SIDECAR_TOKEN=1 SOLUM_SIDECAR_TOKEN='…' make solum-stage
```

## Evaluating git

Due diligence should use **HEAD of `main`**. Historical commits can still contain claims that HEAD rejects. We do not rewrite public history. See [docs/for-evaluators/evaluate-at-head.md](docs/for-evaluators/evaluate-at-head.md).

Email **contact@synapticfour.com**. Do not file public issues with live
customer keys, patient data, or production audit exports.

## Keys in this tree

`.cache/` and `*.key` are gitignored. Do not commit HELIOS signing keys or
Solum CustomerHeld material.
