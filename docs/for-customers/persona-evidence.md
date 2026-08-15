# Persona evidence — what this Showcase actually ran

**Date:** 2026-08-15
**Honesty:** Sales one-pagers live under [personas/](personas/). This sheet is the **artefact status**: what was regenerated, what was not. It is not a certificate.

One-pagers: [DIC / genomDE](personas/dic-genomde.md) · [EHDS / clinic](personas/ehds-solum.md) · [Kenya NPHI](personas/kenya-nphi.md) · [BRA research](personas/bra-research.md). How to re-run: [integration-verification.md](integration-verification.md). Pins: [`PINNED_VERSIONS.txt`](../../PINNED_VERSIONS.txt).

## 15 Aug 2026 — what changed vs what stayed

| Surface | Status | Cite |
|---------|--------|------|
| Solum Stage-1 (allow 200 / deny 403 / tamper) | **Live regen** against Solum SHA `6b4519c…` | `demo/verification/solum-stage-result.json` (`generated_at` 2026-08-15T17:10Z) |
| Showcase scripts → Solum | Actor + capability headers | `X-Solum-Actor` / `X-Solum-Capability` |
| Consent-gate examples | **Fixtures** (live hung; not silently passed) | `fixtures/ci/consent-gate/` · `demo/results/consent-gate-*-example.json` |
| Golden-path Nextflow WES + HELIOS genomic report | **Not re-run** | Ferrum-GA4GH-Demo + HELIOS pins in `PINNED_VERSIONS.txt` stay on the last golden-path SHAs |
| ga4gh-infra pin (optional Passports) | Stack tag **ga4gh-infra-v0.2.3** (`613bd14`) | Compose / GHCR `:0.2.3` |
| Fixture spine (no Docker) | Same as GitHub Actions | `make integration-suite-fixtures` |

Older workstation log: [demo/verification/LIVE-RUN.md](../../demo/verification/LIVE-RUN.md) (2026-08-06). Do not treat that date as the Solum Stage-1 regen.

## Persona → command → evidence

| Persona | What to run | What you may cite | What you may not cite |
|---------|-------------|-------------------|------------------------|
| Institute / DIC | Sibling [Ferrum-GA4GH-Demo PERSONA](https://github.com/SynapticFour/Ferrum-GA4GH-Demo/blob/main/docs/PERSONA.md) then Showcase `make up` **after** regenerating golden-path | Last committed golden-path pins + `RUN_MANIFEST` from **that** Demo run | “Showcase WES was re-proven on 15 Aug” — it was not |
| Clinic / EHDS | Sibling [Solum-Demo PERSONA](https://github.com/SynapticFour/Solum-Demo/blob/main/docs/PERSONA.md) or Showcase `make solum-stage` on the pin | Stage-1 JSON from 15 Aug (`6b4519c`) | Live HELIOS signing, org-IAM, customer evaluation |
| Kenya / NPHI | Solum `kenya-dpa` profile smokes + H4 docs | Profile `check` + founder rehearsal records | Production SoR, counsel-signed DPA |
| BRA research | BRA + optional Solum subject-link | Subject-link contract (`actor` / `capability` / `purpose`) | BRA wrapping Ferrum |

## Pins that must stay honest

Do **not** rewrite `PINNED_VERSIONS.txt` Ferrum-GA4GH-Demo or HELIOS lines unless you re-run golden-path WES and refresh those artefacts together.

`Solum-tag` may move with a live Stage-1 regen (already done for `6b4519c`). `ga4gh-infra` may follow a published stack tag without a WES re-run.
