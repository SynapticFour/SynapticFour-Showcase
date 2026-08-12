# Start here — try Synaptic Four in four steps

*One page. Zero fluff. Pick how deep you want to go.*

[🇬🇧 English below](#english)

---

## Übersicht

| Schritt | Was | Zeit | Docker? |
|---------|-----|------|---------|
| **0** | Fixtures / CI-Spine | ~2 Min | Nein |
| **1** | Golden Path (Ferrum + HELIOS) | ~30–90 Min | Ja |
| **2** | Passports / ga4gh-infra | +Stack | Ja |
| **3** | Solum (klinische Plane) | ~10–20 Min | Optional |

Vollständige Clone-Liste und Ports: [DEMO.md](../../DEMO.md) · Portfolio-Karte: [overview.md](overview.md)

**Persona wählen:** [personas/](personas/) · **Beschaffung:** [procurement-short-path.md](procurement-short-path.md) · **Co-Custody:** [co-custody.md](co-custody.md) · **Legal:** [legal/](legal/)

---

## Schritt 0 — Ohne Installation (Empfehlung zum ersten Lesen)

```bash
cd SynapticFour-Showcase
make preflight
make integration-suite-fixtures   # Spine + Evidence Pack + demo/verification/
```

Sie sehen: `demo/verification/` mit `MANIFEST.json`, HELIOS-/Solum-/Consent-/gatk-rs-/S4MP- und **Passports-Co-Deploy**-Fixtures.

→ [Evidence Pack — was es beweist](evidence-pack.md) · [Integration verification](integration-verification.md)

---

## Schritt 1 — Golden Path (genomische Evidenz-Kette)

Sibling-Repos: `Ferrum-GA4GH-Demo`, `HELIOS` (siehe DEMO.md).

```bash
make up                 # = golden-path: Demo --nextflow + HELIOS
make evidence-pack      # nach erfolgreichem Lauf
```

Artefakte: `demo/results/`, `helios-reports/`, optional `artifacts/evidence-pack-*`.

Gateway oft auf **:18080** (nicht 8080).

---

## Schritt 2 — Passports / ga4gh-infra (Identity Plane)

Der Default-Golden-Path bleibt **open-auth** (schnell). Passports beweist der Sibling-Demo-Pfad:

```bash
cd ../Ferrum-GA4GH-Demo
# braucht ../ga4gh-infra
./run --with-infra
make smoke-evidence
```

Dann im Showcase ernten (soft; bricht nichts ab):

```bash
cd ../SynapticFour-Showcase
make co-deploy-harvest
SHOWCASE_ENABLE_EVIDENCE_PACK=1 make evidence-pack
# oder: SHOWCASE_ENABLE_CO_DEPLOY_HARVEST=1 SHOWCASE_ENABLE_EVIDENCE_PACK=1 make golden-path
```

Evidence: `artifacts/ga4gh-infra/co_deploy_results.json` · Rolle im Pack: `ga4gh_infra_co_deploy`.

→ [Ferrum-GA4GH-Demo COVERAGE](https://github.com/SynapticFour/Ferrum-GA4GH-Demo/blob/main/docs/COVERAGE.md)

---

## Schritt 3 — Solum (klinische Plane, Companion)

```bash
make solum-stage
# oder:
make golden-path-with-solum
make consent-gate          # Zweckbindung vor WES
```

Smokes auch direkt in [Solum-Demo](https://github.com/SynapticFour/Solum-Demo) (`make smoke-all`).

→ [Consent gate](consent-gate.md) · [Which path?](which-path.md)

---

## Was absichtlich *nicht* hier startet

| Thema | Wo stattdessen |
|-------|----------------|
| Lab-Kit / Field / Edge (Pi) | Ferrum Field / Lab-Kit-Repos |
| Production IdP / SAML | ga4gh-infra + Kunden-OIDC (H2-Runbook) |
| Multi-Tenant SaaS | H5 deferred — [HORIZON-OPEN-GATES](../pilots/HORIZON-OPEN-GATES.md) |

---

<a name="english"></a>

# Start here — try Synaptic Four in four steps

| Step | What | Time | Docker? |
|------|------|------|---------|
| **0** | Fixtures / CI spine | ~2 min | No |
| **1** | Golden path (Ferrum + HELIOS) | ~30–90 min | Yes |
| **2** | Passports / ga4gh-infra | +stack | Yes |
| **3** | Solum (clinical plane) | ~10–20 min | Optional |

Clone list & ports: [DEMO.md](../../DEMO.md) · Portfolio map: [overview.md](overview.md)

**Pick a persona:** [personas/](personas/) · **Procurement short path:** [procurement-short-path.md](procurement-short-path.md) · **Co-custody:** [co-custody.md](co-custody.md) · **Legal:** [legal/](legal/)

### Step 0 — zero install

```bash
make preflight
make integration-suite-fixtures
```

### Step 1 — golden path

```bash
make up
make evidence-pack
```

### Step 2 — Passports

```bash
cd ../Ferrum-GA4GH-Demo && ./run --with-infra && make smoke-evidence
cd ../SynapticFour-Showcase && make co-deploy-harvest && make evidence-pack
```

### Step 3 — Solum

```bash
make solum-stage   # or make golden-path-with-solum
make consent-gate
```

*Synaptic Four · Stuttgart · contact@synapticfour.com*
