# H1 — Execution record (founder rehearsal)

**Status:** **FOUNDER REHEARSAL** (2026-08-06) — not a named customer / hospital site
**Checklist:** [H1-PILOT-CHECKLIST.md](H1-PILOT-CHECKLIST.md)
**Limitations:** [H1-KNOWN-LIMITATIONS.md](H1-KNOWN-LIMITATIONS.md)

---

## Sign-off summary

| Field | Value |
|-------|-------|
| Pilot site / host | Founder workstation (hostname redacted; dedicated H1 window; Ferrum-GA4GH-Demo + Solum-Demo stopped) |
| Operator | Founder (Cursor-assisted) — **not** a customer operator |
| Date | 2026-08-06 |
| Ferrum pin | `d7eb8c86` (`VERSIONS.lock` FERRUM_VERSION=v0.2.0) |
| ga4gh-infra | checkout `a91713f` (compose build); lock tag `ga4gh-infra-v0.1.0` |
| Solum pin | `2aaa033` |
| HELIOS | `673f683` / package `0.1.0` |
| Evidence Pack | `artifacts/evidence-pack-20260806T143613Z` (pack_id `20260806T143613Z`) |
| Restore drill OK? | **yes** — MinIO marker delete→restore + Solum consent/audit; elapsed **9s** |
| Stack | `make`-equivalent: docker-compose base + ga4gh-infra + tes + pilot; `FERRUM_AUTH__REQUIRE_AUTH=true`, `FERRUM_TES_BACKEND=docker` |

---

## Definition of done — evidence

| # | Requirement | Evidence |
|---|-------------|----------|
| 1 | Ferrum `require_auth=true` + real TES | `/admin/config` auth `require_auth=true` `mode=external`; gateway env `TES=docker`; unauthenticated ingest **403**; CWL WES run `01KZBQY6YFXGJ7SAG6FZ84D4A3` → **COMPLETE** under TES docker |
| 2 | One WES + HELIOS | WES COMPLETE (CWL smoke-hello); HELIOS Grade **A** (score 100) on Nextflow GIAB work dir → `helios-reports/a7c591cd-…json` |
| 3 | Solum CustomerHeld | `eu-ehds`, `--keys-dir`, grant→revoke, audit verify `ok` (no ephemeral) |
| 4 | Evidence Pack | pack_id `20260806T143613Z` |
| 5 | Restore Ferrum object store + Solum | MinIO volume tar backup/restore (marker recovered); Solum audit/consent restored to `revoked` + audit `ok` |

Also: `ci-pilot-aai-e2e` passed with `FERRUM_PASSPORT_JWT`; fixture `./scripts/run-integration-suite.sh --fixtures` OK.

Local artefacts (gitignored): `artifacts/h1-pilot-rehearsal/`.

---

## Checklist coverage

Week 0–3 items marked complete in [H1-PILOT-CHECKLIST.md](H1-PILOT-CHECKLIST.md) except optional HelixTest Auth Level (1.7). See [H1-KNOWN-LIMITATIONS.md](H1-KNOWN-LIMITATIONS.md) for WES auth-surface and visa gaps.

---

## Prior rehearsal

Earlier same-day **dev-host soft rehearsal** (demo stack, open auth) is superseded by this sign-off. That rehearsal established Solum CustomerHeld + Evidence Pack patterns reused here.
