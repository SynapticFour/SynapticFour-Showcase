# H1 — Pilot-ready on-prem checklist (week-by-week)

**Horizon:** H1 from [COORDINATED-PORTFOLIO-ROADMAP.md](../COORDINATED-PORTFOLIO-ROADMAP.md)
**Goal:** One site can run **Ferrum (auth on, real TES) + HELIOS + optional Solum sidecar** with customer-held keys and a restore drill — without Synaptic Four inventing a monorepo.

**Not H1:** openEHR CDR (H3), Kenya production profile (H4), SaaS (H5).

---

## Definition of done

A named pilot operator (not the founder’s laptop alone) can:

1. Install Ferrum with `require_auth=true` and **real** TES (not noop)
2. Run one WES workflow; collect a HELIOS report
3. Run Solum sidecar with CustomerHeld keys (no ephemeral); grant/revoke/status + audit verify
4. Produce a Showcase Evidence Pack from the live artefacts
5. Restore Ferrum object store + Solum consent/audit from backup once

Sign-off: operator name + date at bottom.

**Latest rehearsal:** [H1-EXECUTION-RECORD.md](H1-EXECUTION-RECORD.md) (2026-08-06) — Solum CustomerHeld + HELIOS + Evidence Pack + restore on a **dev host**; Ferrum `require_auth` / fresh VM **not** closed.

---

## Week 0 — Prep (1–2 days)

| # | Task | Owner repo | Done? |
|---|------|------------|-------|
| 0.1 | Pick pilot host (fresh VM / dedicated hardware) — not daily dev laptop | Ops | [ ] |
| 0.2 | Record pins: Showcase `PINNED_VERSIONS.txt` + Ferrum `VERSIONS.lock` | Showcase / Ferrum | [ ] |
| 0.3 | Confirm IdP/JWKS path (ga4gh-infra or customer OIDC) | ga4gh-infra | [ ] |
| 0.4 | Generate Solum CustomerHeld keypairs (`solum crypto keygen`); store offline | Solum | [ ] |
| 0.5 | Read Ferrum [customer-runbook.md](https://github.com/SynapticFour/Ferrum/blob/main/docs/customer-runbook.md) + [first-release-checklist.md](https://github.com/SynapticFour/Ferrum/blob/main/docs/first-release-checklist.md) | Ferrum | [ ] |

---

## Week 1 — Ferrum guided pilot stack

| # | Task | Command / note | Done? |
|---|------|----------------|-------|
| 1.1 | Deploy with **pilot** config | `FERRUM_CONFIG=deploy/configs/pilot.toml` (`require_auth=true`) | [ ] |
| 1.2 | Wire JWKS to IdP / ga4gh-infra | Per runbook; unset demo open auth | [ ] |
| 1.3 | Enable **real TES** (not noop) | `make up-tes` / documented pilot compute path | [ ] |
| 1.4 | Health checks | Gateway + DRS + WES/TES service-info | [ ] |
| 1.5 | One Nextflow (or WDL) GIAB/subset run | Prefer Ferrum-GA4GH-Demo `./run --nextflow` against this stack **or** Lab Kit recipe | [ ] |
| 1.6 | Confirm outputs on DRS / work dir | metrics + query VCF present | [ ] |
| 1.7 | Optional: HelixTest **without** `HELIXTEST_SKIP_AUTH` | Auth Level evidence for pilot only | [ ] |

**Blockers to escalate:** missing sibling tags on origin (ga4gh-infra / HelixTest) — track in Ferrum first-release checklist.

---

## Week 2 — HELIOS + Solum sidecar

| # | Task | Command / note | Done? |
|---|------|----------------|-------|
| 2.1 | Python 3.11+ venv; `pip install -e HELIOS` | Document `SHOWCASE_PYTHON` if using Showcase | [ ] |
| 2.2 | HELIOS audit on Week-1 WES work dir | `helios run --pipeline nextflow …` | [ ] |
| 2.3 | Keep signed/JSON report | Path recorded for Evidence Pack | [ ] |
| 2.4 | Solum sidecar with `--keys-dir` (CustomerHeld) | Profile `eu-ehds` (or agreed pilot profile); **no** `--ephemeral` | [ ] |
| 2.5 | Grant + status + revoke smoke | Purpose from Solum profile; fail-closed checks | [ ] |
| 2.6 | Audit export + verify (tamper detect) | Chain unbroken until deliberate break test | [ ] |
| 2.7 | Optional: Showcase consent-gate against this sidecar | `make consent-gate` with `SHOWCASE_SOLUM_*` overrides | [ ] |

---

## Week 3 — Evidence, backup, sign-off

| # | Task | Command / note | Done? |
|---|------|----------------|-------|
| 3.1 | Showcase Evidence Pack from live artefacts | `SHOWCASE_ENABLE_EVIDENCE_PACK=1` or `make evidence-pack` | [ ] |
| 3.2 | Fixture suite still green | `make integration-suite` (CI honesty) | [ ] |
| 3.3 | Backup: Ferrum object backend + DB/volumes | Operator procedure written | [ ] |
| 3.4 | Backup: Solum `--audit` + `--consent-store` + keys-dir (keys offline) | | [ ] |
| 3.5 | Restore drill once on spare host/dir | Document time-to-restore | [ ] |
| 3.6 | Known limitations page for pilot | Auth gaps, TES scale, Solum Stage-1 only, no CDR yet | [ ] |
| 3.7 | Sign-off | Below | [ ] |

---

## Showcase pilot recipe (commands)

```bash
# After Ferrum pilot stack + Solum sidecar are up:
cd SynapticFour-Showcase
./scripts/preflight.sh
SHOWCASE_ENABLE_CONSENT_GATE=1 SHOWCASE_ENABLE_SOLUM=1 \
  SHOWCASE_ENABLE_EVIDENCE_PACK=1 \
  SHOWCASE_PYTHON=/path/to/venv/bin/python \
  ./scripts/run-golden-path.sh
# Or skip re-demo if metrics already exist:
SHOWCASE_SKIP_DEMO=1 SHOWCASE_ENABLE_EVIDENCE_PACK=1 ./scripts/run-golden-path.sh
```

Pins: keep `PINNED_VERSIONS.txt` aligned with the pilot host checkouts.

---

## Cross-links (do not duplicate)

| Concern | Canonical doc |
|---------|----------------|
| Ferrum tag / offline / install | [Ferrum first-release-checklist](https://github.com/SynapticFour/Ferrum/blob/main/docs/first-release-checklist.md) |
| Auth / TES honesty | [Ferrum customer-runbook](https://github.com/SynapticFour/Ferrum/blob/main/docs/customer-runbook.md) |
| Solum sidecar | [SIDECAR-INTEGRATION](https://github.com/SynapticFour/Solum/blob/main/docs/customer/SIDECAR-INTEGRATION.md) |
| Solum Stage-1 boundary | [BASELINE](https://github.com/SynapticFour/Solum/blob/main/docs/BASELINE.md) |
| Verification suite | [integration-verification](../for-customers/integration-verification.md) |

---

## Sign-off

| Field | Value |
|-------|-------|
| Pilot site / host | |
| Operator | |
| Date | |
| Ferrum pin / tag | |
| Solum tag / pin | |
| HELIOS version | |
| Evidence Pack path / id | |
| Restore drill OK? | yes / no |
| Notes | |

---

## Exit → H2

When this checklist is signed: start H2 (KMS/HSM CLI, IAM bridge, consent→DRS enforcement). Do **not** block H3 design docs on H1 sign-off — architecture can proceed in parallel.
