# Showcase dependency & supply-chain policy

**Status:** 2026-08-12 · org level-up C7
**Repo role:** Integrator (scripts, fixtures, docs) — not a Rust/Node product runtime.

## What this repo ships

- Shell/Python orchestration scripts
- Fixture JSON / evidence pack artefacts
- Customer and pilot documentation
- `PINNED_VERSIONS.txt` for sibling product pins

## Required controls

| Control | Status |
|---------|--------|
| Secret scan (Gitleaks) on push/PR | `.github/workflows/secret-scan.yml` |
| Integration fixture CI | `.github/workflows/ci.yml` |
| Dependency Review (GitHub) | Optional — enable Dependency graph if PR dependency diffs are needed; not mandatory while no lockfile ecosystems dominate |

## Operator expectations

1. Do **not** commit secrets, customer keys, or live audit exports with personal data.
2. When adding Node/Python lockfiles for tooling, add `npm audit` / `pip-audit` (or Dependency Review) in the same PR.
3. Keep `PINNED_VERSIONS.txt` reviewed monthly (org plan G7) — procedure: [PINNED-VERSIONS-CADENCE.md](./PINNED-VERSIONS-CADENCE.md) — alongside sibling cargo-deny / SBOM releases.
4. Follow org cadence: [synapticfour-infra DEPENDENCY-UPDATE-POLICY](https://github.com/SynapticFour/synapticfour-infra/blob/main/docs/DEPENDENCY-UPDATE-POLICY.md) and [MONTHLY-DEPENDENCY-HYGIENE](https://github.com/SynapticFour/synapticfour-infra/blob/main/docs/MONTHLY-DEPENDENCY-HYGIENE.md).

## Explicit non-goals

Showcase does not vendor Ferrum/Solum binaries; supply-chain proof for those products lives in their release SBOMs.
