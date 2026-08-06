# H2 — Execution record (spine v1 + H2.1 Teeth)

**Status:** **SIGNED OFF** — H2 spine v1 (2026-08-06) + **H2.1 Teeth** (2026-08-06)
**Checklist:** [H2-PILOT-CHECKLIST.md](H2-PILOT-CHECKLIST.md)
**Limitations:** [H2-KNOWN-LIMITATIONS.md](H2-KNOWN-LIMITATIONS.md)
**Ops:** [H2-OPS-RUNBOOK.md](H2-OPS-RUNBOOK.md)
**Contract:** [ADR 0001 — Solum↔Ferrum consent access](../adr/0001-solum-ferrum-consent-access.md)

Not the full roadmap exit (OIDC→CAP, KMS CLI, observability). See limitations.

---

## Sign-off summary

| Field | Value |
|-------|-------|
| Host | Synaptic Four ops — MacBook-Air-von-Alexander (pilot-local + docker TES) |
| Operator | Synaptic Four eng |
| Date | 2026-08-06 |
| Ferrum (spine) | `49aab603` — WES fail-closed + pilot issuer fix |
| Ferrum (H2.1) | `e638214b` — `SolumConsentClient` + DRS/WES hooks |
| Solum | `9b8ce7f` — H2.1 consumer docs |
| Showcase | ADR 0001 + `scripts/run-h21-teeth.sh` (this pack) |

---

## Evidence — spine v1

| Check | Result |
|-------|--------|
| Unauthenticated `GET /ga4gh/wes/v1/runs` | **401** |
| Unauthenticated `POST /ga4gh/wes/v1/runs` | **401** |
| Bearer Passport `GET /runs` | **200** |
| Bearer Passport CWL submit | **200** → run `01KZBTZ72XFKDHF8C5N429KXET` **COMPLETE** |
| Bearer ingest without `ferrum:collector` | **403** |
| Solum crypto tests | `cargo test -p solum-crypto --lib` 9 passed |

---

## Evidence — H2.1 Teeth

| Check | Result |
|-------|--------|
| Ferrum `ferrum-core` solum_consent unit tests | **6 passed** (wiremock) |
| Ferrum `ferrum-drs` solum_consent tests | **4 passed** (granted / revoked / defaults / unbound) |
| Live DRS (pilot gateway + Solum-Demo `:8787`) | grant → **200**; revoke → **403** `solum consent denied: status=revoked` (`test-object-1`, defaults) |
| Live WES | requires Bearer under `require_auth`; covered by unit + handler hook; anon remains **401** before Solum |
| `make h21-teeth` | script ready (needs Bearer for WES on auth-on stacks) |

---

## Code / docs landed

- Ferrum: `[solum]` config, `SolumConsentClient`, DRS `check_object_byte_access` + WES `post_runs` hooks
- Solum: Ferrum documented as status consumer
- Showcase: ADR 0001, `make h21-teeth`, H2 honesty updates

---

## Explicitly still open (not this sign-off)

- Solum KMS CLI/sidecar wiring
- OIDC groups → Solum CAP_*
- HELIOS clinical evidence types + observability baseline
- HelixTest Auth Level live (optional)
