# Demo — SynapticFour Showcase

[🇬🇧 Jump to English intro](#english-intro) · [⚙️ Technische Ausführung](#technical)

---

## Was diese Demo zeigt

Der SynapticFour-Showcase demonstriert wie Bausteine in einer realen Pipeline zusammenspielen:

1. **Ferrum** nimmt einen Variant-Calling-Job über seine WES-Schnittstelle entgegen und führt ihn aus
2. **HELIOS** erzeugt dabei automatisch einen signierten Audit-Trail mit SHA256-Hashes aller Input- und Output-Dateien
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
2. **HELIOS** automatically generates a signed audit trail with SHA256 hashes of all input and output files
3. **BioResearch Assistant** (optional, M2) receives the result VCF and run metadata — ready for downstream analysis
4. **Solum** (optional, `make solum-stage` / `make golden-path-with-solum`) demonstrates fail-closed authorization and tamper-evident audit as a clinical companion

**You don't need to install anything to see the results.**

→ **[demo/results/](demo/results/)** — all artefacts from a real run, directly readable

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
| Git-Checkouts | `Ferrum-GA4GH-Demo`, `HELIOS`, optional `bioresearch-assistant`, optional `Solum-Demo` nebeneinander zum Showcase |
| Netzwerk | Erster Lauf: Image-Pulls und ggf. öffentliche Testdaten |

**Schnellcheck vor dem Termin:**
```bash
./scripts/preflight.sh
# Streng (Exit-Code bei Problem):
./scripts/preflight.sh --strict
```

Reproduzierbare Stände: [PINNED_VERSIONS.txt](PINNED_VERSIONS.txt) enthält die Git-HEADs der Nachbar-Repos.

---

## Ein Befehl (Happy Path)

```bash
make up
# oder ausführlich:
chmod +x scripts/run-golden-path.sh
# Optional: lokales venv mit HELIOS (empfohlen auf macOS/Homebrew-Python)
python3.12 -m venv .venv && .venv/bin/pip install -e ../HELIOS
SHOWCASE_PYTHON="$(pwd)/.venv/bin/python" \
SHOWCASE_HELIOS_ROOT=/path/to/HELIOS \
./scripts/run-golden-path.sh
```

**Aufräumen:** `make down` · `make destroy` (Volumes + hängende Container)

### Optional: Solum Stage-1

```bash
make solum-stage
# oder zusammen mit dem genomic golden path:
make golden-path-with-solum
```

Siehe [IMPLEMENTATION-PLAN-EVIDENCE-CHAIN.md](docs/IMPLEMENTATION-PLAN-EVIDENCE-CHAIN.md) und [PINNED_VERSIONS.txt](PINNED_VERSIONS.txt) (`Solum-Demo`, `Solum-tag`).

### Optional: Evidence Pack

```bash
make evidence-pack-fixtures   # CI / ohne Docker
make evidence-pack            # nach golden path / mit lokalen Artefakten
SHOWCASE_ENABLE_EVIDENCE_PACK=1 make golden-path
```

Ausgabe: `artifacts/evidence-pack-<id>/` mit `MANIFEST.json` + `README.md`.
→ [Was das Pack beweist](docs/for-customers/evidence-pack.md)

**Ergebnisse:**

| Artefakt | Bedeutung |
|----------|-----------|
| `../Ferrum-GA4GH-Demo/results/metrics.json` | Demo-Kennzahlen, WES Run ID |
| `../Ferrum-GA4GH-Demo/results/benchmark.json` | Precision / Recall / F1 |
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
