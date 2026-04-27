# Demo — SynapticFour Showcase

[🇬🇧 Jump to English intro](#english-intro) · [⚙️ Technische Ausführung](#technical)

---

## Was diese Demo zeigt

Der SynapticFour-Showcase demonstriert wie drei Bausteine in einer realen Pipeline zusammenspielen:

1. **Ferrum** nimmt einen Variant-Calling-Job über seine WES-Schnittstelle entgegen und führt ihn aus
2. **HELIOS** erzeugt dabei automatisch einen signierten Audit-Trail mit SHA256-Hashes aller Input- und Output-Dateien
3. **BioResearch Assistant** bekommt das Ergebnis-VCF und die Run-Metadaten übergeben — bereit für Downstream-Analyse

Am Ende haben Sie: einen Benchmark-Report, eine HELIOS-Audit-Datei, einen DRS-Objektlink und eine menschenlesbare Zusammenfassung für Stakeholder-Reviews.

**Sie müssen nichts installieren um die Ergebnisse zu sehen.**

→ **[demo/results/](demo/results/)** — Benchmark, Metrics, HELIOS-Report, DRS-Link, Zusammenfassung — alles direkt lesbar

---

<a name="english-intro"></a>

## What this demo shows (English)

The SynapticFour Showcase demonstrates how three building blocks work together in a real pipeline:

1. **Ferrum** accepts a variant calling job via its WES interface and executes it
2. **HELIOS** automatically generates a signed audit trail with SHA256 hashes of all input and output files
3. **BioResearch Assistant** receives the result VCF and run metadata — ready for downstream analysis

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
| Python 3.11+ | Für HELIOS und Report-Assembler |
| Git-Checkouts | `Ferrum-GA4GH-Demo`, `HELIOS`, optional `bioresearch-assistant` nebeneinander zum Showcase |
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
chmod +x scripts/run-golden-path.sh
SHOWCASE_PYTHON="$(command -v python3.12 || command -v python3.11)" \
SHOWCASE_HELIOS_ROOT=/path/to/HELIOS \
./scripts/run-golden-path.sh
```

**Ergebnisse:**

| Artefakt | Bedeutung |
|----------|-----------| 
| `../Ferrum-GA4GH-Demo/results/metrics.json` | Demo-Kennzahlen, WES Run ID |
| `../Ferrum-GA4GH-Demo/results/benchmark.json` | Precision / Recall / F1 |
| `helios-reports/<uuid>.json` | HELIOS-Audit-Export |
| `showcase-report.json` | Zusammenführung Demo + HELIOS |
| `showcase-report.md` | Kurztext für Slides / E-Mail |

**Typische Laufzeit:** erste Ausführung 10–20+ Minuten (Image-Pulls); Folgeläufe schneller.

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
./scripts/stop-showcase.sh
# Bei hängenden Containern:
./scripts/stop-showcase.sh --hard
```

---

## Troubleshooting

| Problem | Lösung |
|---------|--------|
| Docker nicht genug RAM | Docker Desktop → Settings → Resources → Memory auf 12 GB |
| Python-Version zu alt | `SHOWCASE_PYTHON=/path/to/python3.12 ./scripts/run-golden-path.sh` |
| Port bereits belegt | `./scripts/stop-showcase.sh --hard` dann neu starten |
| Nachbar-Repos fehlen | Checkouts neben dem Showcase-Ordner anlegen |

---

## Weiterführendes

- [README.md](README.md) — Kundenorientierter Einstieg
- [demo/results/](demo/results/) — Vorgeneriete Artefakte
- [docs/for-evaluators/technical-evaluation-kit.md](docs/for-evaluators/technical-evaluation-kit.md)
