# ADR 0001 — Solum ↔ Ferrum consent access (H2.1 Teeth)

**Status:** Accepted
**Date:** 2026-08-06
**Horizon:** H2.1 (not full H2 exit)

## Context

Solum already exposes grant / revoke / status on the sidecar. Showcase’s consent-gate only skips WES in the orchestrator. Production on-prem needs **withdrawal with teeth**: after revoke, Ferrum itself must deny bound DRS and WES calls.

## Decision

Ferrum optionally integrates with Solum via `[solum]` / `FERRUM_SOLUM__*`.

| Rule | Behaviour |
|------|-----------|
| Feature off | `base_url` unset → no Solum calls (H1 / H2 spine unchanged) |
| Feature on + binding resolved | `GET {base}/v1/consent/status?subject=&purpose=` with `X-Solum-Sidecar-Token` |
| Allow | Only JSON `{"status":"granted"}` |
| Deny | `revoked`, `unknown`, non-2xx, or transport error → Ferrum **403** (fail-closed) |
| Binding (DRS) | Metadata keys `solum_subject` + `solum_purpose`, else config defaults, else skip Solum |
| Binding (WES submit) | Run tags `solum_subject` + `solum_purpose`, else config defaults, else skip Solum |
| Surfaces | DRS byte access (`check_object_byte_access`); WES `POST /runs` only |
| Admin | Passport admin does **not** bypass the Solum purpose check |

Dataset / workspace / ADS / outbreak checks run first and are unchanged.

## Consequences

- Operators must co-deploy Solum sidecar (or reachable status URL) and share the sidecar token with Ferrum when enabling the feature.
- Unbound objects/runs are outside the consent plane until tagged or defaults are set.
- No webhook/push revoke in H2.1 — Ferrum polls status per request (short timeout).
- OIDC → Solum `CAP_*` and KMS CLI remain separate H2 backlog items.

## Evidence

Showcase `scripts/run-h21-teeth.sh`: grant → DRS GET / WES POST allow; revoke → both **403**.

## Links

- Solum sidecar: `GET /v1/consent/status` ([SIDECAR-INTEGRATION.md](https://github.com/SynapticFour/Solum/blob/main/docs/customer/SIDECAR-INTEGRATION.md))
- Ferrum: `[solum]` config + `SolumConsentClient` in `ferrum-core`
- Pilots: [H2-KNOWN-LIMITATIONS.md](../pilots/H2-KNOWN-LIMITATIONS.md)
