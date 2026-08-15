# Demo — SynapticFour Showcase

[🇬🇧 Jump to English intro](#english-intro) · [⚙️ Technische Ausführung](#technical)

---

## Was diese Demo zeigt

Der SynapticFour-Showcase demonstriert wie Bausteine in einer realen Pipeline zusammenspielen:

1. **Ferrum** nimmt einen Variant-Calling-Job über seine WES-Schnittstelle entgegen und führt ihn aus
2. **HELIOS** erzeugt dabei automatisch einen **signierten** Audit-Export. Das committed Beispiel `demo/results/helios-report-example.json` hasht Nextflow-Config/Log in `input_files` und **warnt** bei GATK `4.4.0.0` ohne Digest — siehe Sidecar [helios-report-example.honesty.json](demo/results/helios-report-example.honesty.json). Live-Läufe schreiben nach `helios-reports/`.
3. **BioResearch Assistant** (optional, M2) bekommt das Ergebnis-VCF und die Run-Metadaten übergeben — bereit für Downstream-Analyse
4. **Solum** (optional, `make solum-stage` / `make golden-path-with-solum`) zeigt fail-closed Autorisierung und tamper-evident Audit als klinischen Companion

Am Ende haben Sie: einen Benchmark-Report, eine HELIOS-Audit-Datei, einen DRS-Objektlink, optional Solum-Artefakte und eine menschenlesbare Zusammenfassung für Stakeholder-Reviews.

**Sie müssen nichts installieren um die Ergebnisse zu sehen.**

→ **[demo/results/](demo/results/)** — Benchmark, Metrics, HELIOS-Report, DRS-Link, Zusammenfassung — alles direkt lesbar

---

<a name="english-intro"></a>

## What this demo shows (English)

The SynapticFour Showcase demonstrates how building blocks work together in a real pipeline:

1. **Ferrum** accepts a variant calling job via its WES interface and executes it
2. **HELIOS** automatically generates a **signed** audit export. The committed example `demo/results/helios-report-example.json` hashes Nextflow config/log in `input_files` and **warns** on GATK `4.4.0.0` without a digest — see [helios-report-example.honesty.json](demo/results/helios-report-example.honesty.json). Live runs write to `helios-reports/`.
3. **BioResearch Assistant** (optional, M2) receives the result VCF and run metadata — ready for downstream analysis
4. **Solum** (optional, `make solum-stage` / `make golden-path-with-solum`) demonstrates fail-closed authorization and tamper-evident audit as a clinical companion

**You don't need to install anything to see the results.**

→ **[demo/results/](demo/results/)** — committed examples (live, fixture, or historical export — each README says which), directly readable

---

<a name="technical"></a>

---

# Für technische Teams — Lokale Demo-Ausführung

---

## Voraussetzungen / Prerequisites

| Anforderung | Hinweis |
|-------------|---------|
| Docker Desktop | 8–12 GB RAM empfohlen |
| Python 3.11+ | Für HELIOS und Report-Assembler (`pip install helios-audit` oder Projekt-`.venv`) |
| Git-Checkouts | Siehe Clone-Rezept unten |
| Netzwerk | Erster Lauf: Image-Pulls und ggf. öffentliche Testdaten |
| Gateway-Port | Ferrum-Demo nutzt **:18080** (nicht 8080) |

### Clone-Rezept (Sibling-Layout)

```bash
# Parent folder (example)
mkdir -p ~/devel/SynapticFour && cd ~/devel/SynapticFour

# Required for make up
git clone https://github.com/SynapticFour/SynapticFour-Showcase.git
git clone https://github.com/SynapticFour/Ferrum-GA4GH-Demo.git
git clone https://github.com/SynapticFour/HELIOS.git

# Optional (match PINNED_VERSIONS.txt when reproducing a published run)
git clone https://github.com/SynapticFour/Solum-Demo.git
git clone https://github.com/SynapticFour/ga4gh-infra.git   # Passports co-deploy
git clone https://github.com/SynapticFour/bioresearch-assistant.git
# HelixTest / gatk-rs / S4MP / Ferrum / Solum — as needed

cd SynapticFour-Showcase
./scripts/checkout-pins.sh    # detach siblings to published artefact SHAs (needed for make up)
make preflight                # strict Docker/Python; pin drift is informational here
make up                       # fails if Ferrum/HELIOS HEAD drifted unless SHOWCASE_ALLOW_PIN_DRIFT=1
```

Reproduzierbare Stände: [PINNED_VERSIONS.txt](PINNED_VERSIONS.txt) sind die SHAs der **zuletzt committeden** Artefakte. `make up` verlangt, dass Ferrum-GA4GH-Demo und HELIOS auf genau diesen SHAs stehen (`make checkout-pins`). Entwicklung auf Sibling-HEAD: `SHOWCASE_ALLOW_PIN_DRIFT=1 make up`.

**Schnellcheck vor dem Termin:**
```bash
make preflight
make checkout-pins
./scripts/check-pins.sh --strict
```

Solum-Live-Skripte setzen **kein** Demo-Token still. Lokal gegen Solum-Demo compose:

```bash
SHOWCASE_USE_DEMO_SIDECAR_TOKEN=1 make solum-stage
SHOWCASE_USE_DEMO_SIDECAR_TOKEN=1 make consent-gate
```

---

## Ein Befehl (Happy Path)

```bash
make checkout-pins
make up
# or, to run on sibling HEAD instead of published pins:
# SHOWCASE_ALLOW_PIN_DRIFT=1 make up
# Optional: local venv with HELIOS (recommended on macOS/Homebrew Python)
python3.12 -m venv .venv && .venv/bin/pip install -e ../HELIOS
SHOWCASE_PYTHON="$(pwd)/.venv/bin/python" \
SHOWCASE_HELIOS_ROOT=/path/to/HELIOS \
./scripts/run-golden-path.sh
```

**Aufräumen:** `make down` · `make destroy` (Volumes + hängende Container)

### Optional: Solum Stage-1

```bash
SHOWCASE_USE_DEMO_SIDECAR_TOKEN=1 make solum-stage
# oder zusammen mit dem genomic golden path:
SHOWCASE_USE_DEMO_SIDECAR_TOKEN=1 make golden-path-with-solum
```

Siehe [docs/for-customers/start-here.md](docs/for-customers/start-here.md) und [PINNED_VERSIONS.txt](PINNED_VERSIONS.txt) (`Solum-Demo`, `Solum-tag`).

### Optional: Evidence Pack

```bash
make evidence-pack-fixtures   # CI / ohne Docker
make evidence-pack            # nach golden path / mit lokalen Artefakten
SHOWCASE_ENABLE_EVIDENCE_PACK=1 make golden-path
```

Ausgabe: `artifacts/evidence-pack-<id>/` mit `MANIFEST.json` + `README.md`.
→ [Was das Pack beweist](docs/for-customers/evidence-pack.md)

### Optional: Consent gate (before WES)

```bash
make consent-gate
make consent-gate-deny
SHOWCASE_ENABLE_CONSENT_GATE=1 make golden-path
SHOWCASE_ENABLE_CONSENT_GATE=1 SHOWCASE_CONSENT_GATE_MODE=deny make golden-path
```

→ [Consent gate honesty](docs/for-customers/consent-gate.md)

### Optional: gatk-rs / S4MP (W4 — soft-fail)

```bash
make gatk-rs-smoke-fixtures
make s4mp-evidence-fixtures
make gatk-rs-smoke          # live Alpha smoke if binary present
make s4mp-evidence          # attach .s4 report or fixture
SHOWCASE_ENABLE_GATK_RS=1 SHOWCASE_ENABLE_S4MP=1 make golden-path
```

Default Nextflow GIAB path unchanged. Optional Demo `./run --gatk-rs` (soft-skip if image missing) is available; Showcase `make gatk-rs-wes` soft-stages the same Alpha path.
→ [gatk-rs / S4MP honesty](docs/for-customers/gatk-rs-s4mp.md)

### Optional: ga4gh-infra / Passports co-deploy

Default Showcase golden path is **open-auth** (fast). Identity plane (broker + Passports on DRS) is proven in the sibling Demo:

```bash
cd ../Ferrum-GA4GH-Demo
# needs ../ga4gh-infra (or GA4GH_INFRA_SRC)
./run --with-infra
# or: make up-with-infra
make smoke-evidence
```

Then harvest into Showcase Evidence Pack inputs (soft; does not start infra):

```bash
cd ../SynapticFour-Showcase
make co-deploy-harvest          # live Demo results if ran>0; else fixture
make co-deploy-harvest-fixtures # CI shape
make evidence-pack
# or: SHOWCASE_ENABLE_CO_DEPLOY_HARVEST=1 SHOWCASE_ENABLE_EVIDENCE_PACK=1 make golden-path
```

Evidence: Demo `results/co_deploy_results.json` → Showcase `artifacts/ga4gh-infra/` · pack role `ga4gh_infra_co_deploy`.
Coverage: [Ferrum-GA4GH-Demo COVERAGE](https://github.com/SynapticFour/Ferrum-GA4GH-Demo/blob/main/docs/COVERAGE.md).
Try map: [docs/for-customers/start-here.md](docs/for-customers/start-here.md).
Advanced: `SHOWCASE_DEMO_EXTRA=--with-infra make golden-path` (undocumented edge; prefer Demo recipe above).

### Customer verification suite (claims / integrations)

```bash
# No Docker — same checks CI runs; publishes demo/verification/
make integration-suite

# Opt-in live soft stages (gatk-rs smoke, S4MP, Solum, consent, …)
./scripts/run-integration-suite.sh --live

# Full genomic golden path (long)
./scripts/run-integration-suite.sh --live golden-path
```

→ [Overview](docs/for-customers/overview.md) · [Integration verification](docs/for-customers/integration-verification.md) · [`demo/verification/`](demo/verification/)

**Ergebnisse:**

| Artefakt | Bedeutung |
|----------|-----------|
| `../Ferrum-GA4GH-Demo/results/metrics.json` | Demo-Kennzahlen, WES Run ID |
| `../Ferrum-GA4GH-Demo/results/benchmark.json` | Precision / Recall / F1 |
| Demo `make smoke-evidence` | Artefakt-Gate nach `./run` ([COVERAGE](https://github.com/SynapticFour/Ferrum-GA4GH-Demo/blob/main/docs/COVERAGE.md)) |
| `helios-reports/<uuid>.json` | HELIOS-Audit-Export |
| `showcase-report.json` | Zusammenführung Demo + HELIOS |
| `showcase-report.md` | Kurztext für Slides / E-Mail |

**Typische Laufzeit:** erste Ausführung 10–20+ Minuten (Image-Pulls); Folgeläufe schneller.

**Für eingecheckte Demo-Artefakte aktualisieren:**
```bash
./scripts/publish-demo-results.sh
```
(kopiert `benchmark.json`, `metrics.json`, HELIOS-Report und DRS-Beispiel nach `demo/results/` — ohne absolute Host-Pfade)

---

## Nur HELIOS + Report (Demo schon gelaufen)

```bash
SHOWCASE_SKIP_DEMO=1 ./scripts/run-golden-path.sh
```

---

## M2 Downstream (BioResearch Assistant)

```bash
# Nur Handoff (VCF + m2-handoff.json):
./scripts/run-m2-bioresearch.sh

# Volle Kette (erfordert laufendes Backend):
./scripts/run-m2-bioresearch-downstream.sh

# Integriert in golden-path:
SHOWCASE_ENABLE_M2=1 SHOWCASE_M2_PIPELINE=full ./scripts/run-golden-path.sh
```

---

## Aufräumen

```bash
make down
make destroy     # Volumes + --hard cleanup
# oder:
./scripts/stop-showcase.sh
./scripts/stop-showcase.sh --hard
```

---

## Troubleshooting

| Problem | Lösung |
|---------|--------|
| Docker nicht genug RAM | Docker Desktop → Settings → Resources → Memory auf 12 GB |
| Python-Version zu alt / HELIOS-Deps fehlen | `python3.12 -m venv .venv && .venv/bin/pip install -e ../HELIOS` dann `SHOWCASE_PYTHON=./.venv/bin/python ./scripts/run-golden-path.sh` |
| Port bereits belegt (18080) | Ferrum-Demo nutzt Gateway **18080** — `./scripts/stop-showcase.sh --hard` oder `make down` im Ferrum-GA4GH-Demo, dann neu starten |
| Nachbar-Repos fehlen | Checkouts neben dem Showcase-Ordner anlegen |

---

## Weiterführendes

- [README.md](README.md) — Kundenorientierter Einstieg
- [demo/results/](demo/results/) — Vorgeneriete Artefakte
- [docs/for-evaluators/technical-evaluation-kit.md](docs/for-evaluators/technical-evaluation-kit.md)
