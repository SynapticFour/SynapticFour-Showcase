# H2 — Execution record (signed off — spine v1)

**Status:** **SIGNED OFF** (2026-08-06) as **H2 spine v1**
**Checklist:** [H2-PILOT-CHECKLIST.md](H2-PILOT-CHECKLIST.md)
**Limitations:** [H2-KNOWN-LIMITATIONS.md](H2-KNOWN-LIMITATIONS.md)
**Ops:** [H2-OPS-RUNBOOK.md](H2-OPS-RUNBOOK.md)

This is **not** the full roadmap exit (“withdrawal has teeth across planes”). See limitations.

---

## Sign-off summary

| Field | Value |
|-------|-------|
| Host | Synaptic Four ops — MacBook-Air-von-Alexander (pilot-local + docker TES) |
| Operator | Synaptic Four eng |
| Date | 2026-08-06 |
| Ferrum | `49aab603` — WES fail-closed + pilot issuer fix |
| Solum | `8808f91` — ZeroizeOnDrop on held Crypt4GH seeds |
| Showcase |  — H2 checklist / ops / limitations pack |

---

## Evidence

| Check | Result |
|-------|--------|
| Unauthenticated `GET /ga4gh/wes/v1/runs` | **401** |
| Unauthenticated `POST /ga4gh/wes/v1/runs` | **401** |
| Bearer Passport `GET /runs` | **200** |
| Bearer Passport CWL submit | **200** → run `01KZBTZ72XFKDHF8C5N429KXET` **COMPLETE** |
| Bearer ingest without `ferrum:collector` | **403** `ingest requires ferrum:collector or admin role` |
| Pilot issuer | `FERRUM_AUTH__ISSUER=http://localhost:8180` (matches token `iss`); JWKS via `aai-broker` |
| Solum crypto tests | `cargo test -p solum-crypto --lib` 9 passed |
| Ferrum | `require_auth_enabled_reads_env` unit test |

---

## Code / docs landed

- Ferrum: `require_auth_enabled()`, WES anonymous reject → 401, pilot compose issuer fix, customer-runbook notes
- Solum: `zeroize` on CustomerHeld + AwsKms held keypairs; BASELINE / SECURITY / DEPLOYMENT honesty
- Showcase: H2 checklist, execution, limitations, ops runbook; roadmap updated

---

## Explicitly still open (not this sign-off)

- Solum KMS CLI/sidecar wiring
- OIDC groups → Solum CAP_*
- Solum revoke → Ferrum DRS/WES middleware
- HELIOS clinical evidence types + observability baseline
- HelixTest Auth Level live (optional)
