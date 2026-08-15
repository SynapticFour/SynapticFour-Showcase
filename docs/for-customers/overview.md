# SynapticFour — what we offer (customer overview)

[🇬🇧 English below](#english)

---

## Kurz

Synaptic Four liefert **vier eigenständige Produkte** (Ferrum, ga4gh-infra, Solum, BioResearch Assistant) plus **freie Botschafter** (HelixTest, HELIOS). Glue ist GA4GH; Solum erweitert in die Klinik. **Kein Bundle-SKU.**
Das **Showcase**-Repository ist ein Evidence-Pack (Demo- und Verifikationspfad) — kein Produkt.

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
| **Ferrum** | GA4GH data/compute (DRS/WES/TES/…) | **Produkt** (BUSL) |
| **ga4gh-infra** | Identity plane (Passports, DUO, ADS) | **Produkt**, Apache open-core — Co-Deploy via Demo `./run --with-infra` |
| **Solum / Solum-Demo** | Klinische Overlay; Demo ist Proof | **Produkt** / Proof-Walkthrough |
| **bioresearch-assistant (BRA)** | Researcher workbench | **Produkt** — optional im Showcase |
| **HELIOS** | Pipeline-Audit (Datei-Ingest, kein Orchester) | **Freier Botschafter** (Apache), nicht SKU |
| **HelixTest** | GA4GH-Conformance CLI | **Freier Botschafter** (Apache) |
| **Ferrum-Lab-Kit** | Subset-Install für Ferrum | **Kommt mit Ferrum**, nicht separat |
| **Ferrum-GA4GH-Demo** | Lokaler `./run` pipeline smoke | **Proof / Outreach** |
| **SynapticFour-Showcase** | Pins, Scripts, Evidence Pack | **Proof**, kein Produkt |

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
| **C8** | ga4gh-infra co-deploy (Passports) | Demo `./run --with-infra` · Showcase `make co-deploy-harvest` | Pack-Rolle `ga4gh_infra_co_deploy` · Demo `results/co_deploy_results.json` |

Details und Ehrlichkeit: [integration-verification.md](integration-verification.md).

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

C0 fixtures → C1 golden path → C2 Solum → C3 consent → C4 Evidence Pack → C5/C6 Alpha sidecars → C7 optional gatk-rs WES → **C8** Demo `./run --with-infra` + Showcase `make co-deploy-harvest` (Passports).
Re-run: [integration-verification.md](integration-verification.md). Published pack: `demo/verification/`.

### Honesty

Fixtures and demos prove **technical** integrations under documented conditions — not certification, legal consent, or gatk-rs clinical equivalence.
