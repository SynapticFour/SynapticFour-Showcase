# SynapticFour — what we offer (customer overview)

[🇬🇧 English below](#english)

---

## Kurz

SynapticFour liefert **on-premise-first** Bausteine für genomische / biomedizinische Workflows mit GA4GH-Schnittstellen, Audit und (optional) klinischer Consent-/Authz-Begleitung.
Das **Showcase**-Repository orchestriert die Produkte als Demo- und Verifikationspfad — ohne Produkte in ein Monorepo zu zwingen.

**Sofort starten (ohne Docker):**

```bash
cd SynapticFour-Showcase
./scripts/run-integration-suite.sh --fixtures --publish-verification
open docs/for-customers/overview.md   # diese Seite
open demo/verification/README.md      # eingefrorene Evidenz im Repo
```

---

## Komponenten und Zweck

| Produkt / Repo | Zweck (eine Zeile) | Reife / Hinweis |
|----------------|--------------------|-----------------|
| **Ferrum** | GA4GH Gateway (TRS/DRS/WES/TES u. a.) | Kernprodukt |
| **Ferrum-GA4GH-Demo** | Ein-Kommando GIAB-/Benchmark-Demo über Ferrum (+ optional `--with-infra`) | Referenzpfad WES+hap.py · [COVERAGE](https://github.com/SynapticFour/Ferrum-GA4GH-Demo/blob/main/docs/COVERAGE.md) |
| **ga4gh-infra** | Identity plane (Broker, Passports/Visas, ADS) | Co-Deploy via Demo `./run --with-infra` — nicht Default-Golden-Path |
| **HELIOS** | Post-run Audit (Container-Pinning, Report) | Kernprodukt |
| **bioresearch-assistant (BRA)** | PhenoFlow / Research-Assistenz, Phenopackets | Optional M2 im Showcase |
| **Solum / Solum-Demo** | Klinischer Companion: Authz + Audit + Consent; optional Track B CDR | Stage-1 Demo + `make smoke-all` ([COVERAGE](https://github.com/SynapticFour/Solum-Demo/blob/main/docs/COVERAGE.md)) |
| **Ferrum-Lab-Kit / Field / Edge** | Ops-Install, Pi/Edge, field sync | **Nicht** Showcase-Stage — siehe Ferrum Field-Docs / Lab-Kit; H4 pilots |
| **HelixTest** | Conformance-/Service-Info Scores (optional) | Evidence Pack optional |
| **gatk-rs** | Alpha Rust-HaplotypeCaller | Soft-fail / optional |
| **S4MP** | Method-/Port-Diff-Wissen (nicht Executor) | Sidecar-Evidenz |
| **SynapticFour-Showcase** | Integrator: Pins, Scripts, Evidence Pack, Suite | Demo + Verifikation |

---

## Getestete Konstellationen

| ID | Was | Wie verifizieren | Evidenz im Repo |
|----|-----|------------------|-----------------|
| **C0** | Fixture-Spine (Scripts + Pack-Rollen) | `./scripts/run-integration-suite.sh --fixtures` | `demo/verification/` |
| **C1** | Ferrum Nextflow + Broad GATK + HELIOS | `make golden-path` | `demo/results/` (Beispiele) |
| **C2** | Solum Stage-1 (Authz + Audit + Consent) | `make solum-stage` · Demo `make smoke-all` | `demo/results/solum-*-example.json` |
| **C3** | Consent-Gate vor WES (allow/deny) | `make consent-gate` / `consent-gate-deny` | `demo/results/consent-gate-*-example.json` |
| **C4** | Evidence Pack (MANIFEST + SHA-256) | `make evidence-pack-fixtures` | Pack in `demo/verification/` |
| **C5** | gatk-rs Smoke (lokal/Docker) | `make gatk-rs-smoke` | `demo/results/gatk-rs-smoke-result-example.json` |
| **C6** | S4MP Port-Diff Sidecar | `make s4mp-evidence` | `demo/results/s4mp-evidence-example.json` |
| **C7** | Optional Ferrum `--gatk-rs` WES (Alpha) | `./scripts/run-gatk-rs-wes.sh` | Soft-skip wenn Image fehlt |
| **C8** | ga4gh-infra co-deploy (Passports) | Sibling Demo `./run --with-infra` | `Ferrum-GA4GH-Demo/results/co_deploy_results.json` |

Details und Ehrlichkeit: [integration-verification.md](integration-verification.md).

**Wohin die Produkte gemeinsam steuern:** [Coordinated portfolio roadmap](../COORDINATED-PORTFOLIO-ROADMAP.md) (On-Prem zuerst; Solum Sidecar + optionale openEHR-Datenebene; SaaS nur vorbereitet).

---

## Welcher Pfad passt?

→ [which-path.md](which-path.md) (Szenarien A–E).

---

## Was wir **nicht** behaupten

- Keine formale Zertifizierung / EHDS- / DSGVO-Compliance aus Demo-Artefakten
- Kein Ersatz für rechtliche Einwilligung (Solum = technische Purpose-Bindung)
- gatk-rs ≠ klinische / genomeweite Äquivalenz zu GATK4
- S4MP ≠ Zertifikat (`s4 certify` ist Stub)

→ [compliance-framing.md](compliance-framing.md) · [evidence-pack.md](evidence-pack.md)

---

<a id="english"></a>

## English — overview

SynapticFour ships **on-premise-first** building blocks for genomic / biomedical workflows with GA4GH APIs, audit, and optional clinical authz/consent companion tooling.
**Showcase** orchestrates sibling product checkouts for demos and claim verification — products stay separate repos.

**Start without Docker:**

```bash
cd SynapticFour-Showcase
./scripts/run-integration-suite.sh --fixtures --publish-verification
```

### Components

Same table as above (Ferrum, Ferrum-GA4GH-Demo, **ga4gh-infra**, HELIOS, BRA, Solum, Lab-Kit/Field/Edge, HelixTest, gatk-rs, S4MP, Showcase).

### Tested constellations

C0 fixtures → C1 golden path → C2 Solum → C3 consent → C4 Evidence Pack → C5/C6 Alpha sidecars → C7 optional gatk-rs WES → **C8** Demo `./run --with-infra` (Passports).
Re-run: [integration-verification.md](integration-verification.md). Published pack: `demo/verification/`.

**Where the portfolio is heading together:** [Coordinated portfolio roadmap](../COORDINATED-PORTFOLIO-ROADMAP.md).

### Honesty

Fixtures and demos prove **technical** integrations under documented conditions — not certification, legal consent, or gatk-rs clinical equivalence.
