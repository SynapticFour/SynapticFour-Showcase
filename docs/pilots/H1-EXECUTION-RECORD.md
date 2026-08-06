# H1 — Execution record (dev-host rehearsal)

**Date:** 2026-08-06
**Host:** founder Mac (Darwin) — **not** a fresh pilot VM
**Operator:** Synaptic Four eng (Cursor-assisted)
**Checklist:** [H1-PILOT-CHECKLIST.md](H1-PILOT-CHECKLIST.md)

This record is honest about gaps. It does **not** close H1 sign-off for a named pilot site.

---

## What ran successfully

| Area | Result | Notes |
|------|--------|-------|
| Pins snapshot | Recorded | Showcase `045fab5` (pre-this-commit); Solum `a54a8ae`; Ferrum `d7eb8c86`; HELIOS `673f683`; Ferrum-GA4GH-Demo `f1a0436` |
| Ferrum WES (demo stack) | OK | Nextflow GIAB-subset path already green earlier today; hap.py F1=1.0 in live metrics |
| HELIOS | Grade **A** (score 100) | `helios run --pipeline nextflow` with Showcase `helios.toml` + `.venv-helios`; report `helios-reports/2c21e945-…json` |
| Solum CustomerHeld sidecar | OK | Release binaries; `eu-ehds`; `--keys-dir` (no ephemeral); bind `127.0.0.1:8787` |
| Consent grant → status → revoke | OK | Purpose `care_provision`; status after revoke `revoked` |
| Crypt4GH encrypt/decrypt | OK | `key_ref=customer/h1-pilot-1`; plaintext round-trip asserted (not logged) |
| Audit verify | OK | HTTP `/v1/audit/verify` → `{"status":"ok"}`; CLI `solum audit verify` → `ok` |
| Backup + restore drill | OK | Copied audit/consent JSONL; wiped live; restored; sidecar restart; consent still `revoked`; audit chain ok; restore probe under 1s |
| Evidence Pack | OK | `artifacts/evidence-pack-20260806T134233Z` (pack_id `20260806T134233Z`) |
| Fixture integration suite | OK | `./scripts/run-integration-suite.sh --fixtures` |

Local rehearsal artefacts (gitignored): `artifacts/h1-pilot-rehearsal/` (keys, solum stores, logs, helios copy).

---

## What did **not** run (H1 still open)

| Gap | Why it matters |
|-----|----------------|
| Fresh VM / dedicated pilot host (0.1) | Checklist DoD requires a named pilot operator path, not only the founder laptop |
| `require_auth=true` + JWKS (1.1–1.2) | Running stack is **Ferrum-GA4GH-Demo** (`require_auth` open): `GET /ga4gh/wes/v1/runs` → **200 without token** on `:18080` |
| Guided `make up-pilot-local` / real TES pilot path | Demo compute ≠ Ferrum `deploy/configs/pilot.toml` pilot stack |
| Ferrum object-store backup/restore (3.3) | Only Solum consent/audit restore drilled |
| HelixTest without `HELIXTEST_SKIP_AUTH` (1.7) | Optional; skipped |
| Operator sign-off table | Left blank until gaps above close |

---

## Operator notes for next attempt

1. Prefer a clean VM; install sibling checkouts to Showcase `PINNED_VERSIONS.txt`.
2. Bring up Ferrum with `FERRUM_CONFIG=deploy/configs/pilot.toml` + ga4gh-infra JWKS; confirm WES **rejects** unauthenticated `GET /runs`.
3. Re-run Solum CustomerHeld path (commands in [SIDECAR-INTEGRATION](https://github.com/SynapticFour/Solum/blob/main/docs/customer/SIDECAR-INTEGRATION.md)); keep keys offline.
4. Set `SHOWCASE_PYTHON` to a 3.11+ venv with `pip install -e HELIOS` (Homebrew system Python is PEP 668-blocked).
5. Fill the sign-off table in the checklist.

---

## Related horizon work done same day

- H3 CDR engine spike → Solum [ADR 0002 (EHRbase)](https://github.com/SynapticFour/Solum/blob/main/docs/adr/0002-cdr-engine-ehrbase.md)
- H4 Kenya K1 → Solum [counsel brief](https://github.com/SynapticFour/Solum/blob/main/docs/counsel/KENYA-K1-BRIEF.md)
