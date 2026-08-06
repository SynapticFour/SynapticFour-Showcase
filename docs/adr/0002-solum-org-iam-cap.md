# ADR 0002 — Solum org IAM: OIDC groups → CAP_* (H2.2)

**Status:** Accepted
**Date:** 2026-08-06
**Horizon:** H2.2 Org CAP; CLI decision closed as **wontfix** for H2 exit (2026-08-06)

## Context

Solum mutating APIs required clients to supply `capability[]` (trust whoever holds the sidecar token). ADS already maps OIDC groups to **dataset** grants, not Solum CAP_*. Roadmap asked for institutional groups → Solum capabilities.

## Decision

Optional **org-IAM mode** on `solum-sidecar`:

| Rule | Behaviour |
|------|-----------|
| Off (default) | Body `capability[]` + sidecar token (unchanged) |
| On (`--org-iam-config`) | Require Bearer JWT; verify JWKS; map claim path values → CAP_*; **ignore** body `capability` |
| Mapping | Local TOML (`claim_path` + `[[map]]` rows) — ADS pattern, not ADS tables |
| Fail-closed | Missing Bearer / bad JWT / no matching groups → 401/403 |
| Transport | Sidecar token still required |
| CLI | Keeps `--capability` (offline ops) — **intentional**; no CLI JWT/org-IAM for H2 |

### CLI org-IAM (H2 exit decision)

**wontfix / intentional:** production IdP-backed CAP_* lives on the sidecar only. Offline CLI remains explicit `--capability` for break-glass and air-gapped ops. Sites that need fail-closed org IAM use the HTTP sidecar path.

## Consequences

- Integrators must issue IdP groups that match the site mapping file.
- ADS dataset grants and Solum CAP_* remain separate planes.
- Full H2 exit does **not** require CLI JWT wiring.

## Links

- Solum pin: `545711c` — [SIDECAR-INTEGRATION.md](https://github.com/SynapticFour/Solum/blob/545711c3c431612320f15ccd5da7d780c1061acf/docs/customer/SIDECAR-INTEGRATION.md)
- Pilots: [H2-KNOWN-LIMITATIONS.md](../pilots/H2-KNOWN-LIMITATIONS.md) · [H2-SECOND-PASS.md](../pilots/H2-SECOND-PASS.md) §D
