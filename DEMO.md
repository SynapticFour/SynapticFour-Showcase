# Demo-Runbook — SynapticFour Showcase

Kurzanleitung für **Live-Demo**, **Kunden-Termin** oder **lokales Durchtesten**. Technische Details zu einzelnen Komponenten bleiben in den jeweiligen Upstream-Repos; hier geht es um **Reihenfolge**, **Artefakte** und **typische Laufzeiten**.

---

## Voraussetzungen

| Requirement | Notes |
|-------------|--------|
| Docker Desktop | Ausreichend RAM (oft **8–12 GB** für Ferrum-Demo) |
| Python **3.11+** | Für HELIOS und Report-Assembler (`python3.12` empfohlen auf macOS) |
| Git-Checkouts | `Ferrum-GA4GH-Demo`, `HELIOS`, optional `bioresearch-assistant` **nebeneinander** zum Showcase-Ordner (siehe Defaults in `README.md`) |
| Netzwerk | Erster Lauf: Image-Pulls und ggf. öffentliche Testdaten |

Optional: `pip install helios-audit` **oder** `pip install -e ../HELIOS` mit demselben Python 3.11+.

**Schnellcheck vor dem Termin:**

```bash
./scripts/preflight.sh
# Streng (Exit-Code bei Problem): ./scripts/preflight.sh --strict
```

**Reproduzierbare Stände:** [PINNED_VERSIONS.txt](PINNED_VERSIONS.txt) enthält die Git-HEADs der Nachbar-Repos; aktualisieren mit `./scripts/refresh-pinned-versions.sh`.

---

## Ein Befehl (Happy Path)

Aus dem **Showcase-Repo-Root**:

```bash
chmod +x scripts/run-golden-path.sh
SHOWCASE_PYTHON="$(command -v python3.12 || command -v python3.11)" \
SHOWCASE_HELIOS_ROOT=/path/to/HELIOS \
./scripts/run-golden-path.sh
```

Ergebnis:

| Artefakt | Bedeutung |
|----------|-----------|
| `../Ferrum-GA4GH-Demo/results/metrics.json` | Demo-Kennzahlen, `wes_run_id` |
| `../Ferrum-GA4GH-Demo/results/benchmark.json` | hap.py-Kurzsummary (Precision / Recall / F1) |
| `../Ferrum-GA4GH-Demo/results/query.vcf.gz` | Abfrage-VCF |
| `helios-reports/<uuid>.json` | HELIOS-Audit-Export |
| `showcase-report.json` | **Zusammenführung** Demo + HELIOS + Timings |
| `showcase-report.md` | Kurztext für Slides / E-Mail |

**Typische Wall-Clock:** erste Ausführung oft **10–20+ Minuten** (Build/Pulls); Folgeläufe schneller.

**Heartbeat** (optional): `SHOWCASE_HEARTBEAT_SECONDS=20 ./scripts/run-golden-path.sh`

---

## Nur HELIOS + Report (Demo schon gelaufen)

Wenn `Ferrum-GA4GH-Demo/results/metrics.json` bereits existiert:

```bash
SHOWCASE_SKIP_DEMO=1 ./scripts/run-golden-path.sh
```

---

## M2 Downstream (bioresearch-assistant)

### Variante A — nur Handoff (VCF kopieren + `m2-handoff.json`)

```bash
./scripts/run-m2-bioresearch.sh
```

Artefakte unter `artifacts/m2/`: `m2-handoff.json`, `input/query.vcf.gz`.

### Variante B — volle Kette (Handoff → DRS-Import → Phenopacket + VCF-Link)

Erfordert erreichbares Backend (`http://localhost:8000`) oder Auto-Start (siehe `README.md`).

```bash
./scripts/run-m2-bioresearch-downstream.sh
```

Zusätzlich: `artifacts/m2/m2-import-result.json`, `m2-link-result.json`.

### In `run-golden-path.sh` integriert

```bash
SHOWCASE_ENABLE_M2=1 SHOWCASE_M2_PIPELINE=full ./scripts/run-golden-path.sh
```

**Postgres-Parallelbetrieb** mit Ferrum: Showcase nutzt standardmäßig `contrib/bioresearch-assistant-postgres-override.yml` (Host-Port **15432**). Details: `README.md` → *bioresearch-assistant + Ferrum in parallel*.

---

## Aufräumen / Stop

Normales Herunterfahren der Showcase-Stacks:

```bash
./scripts/stop-showcase.sh
```

Wenn Container „hängen“ bleiben:

```bash
./scripts/stop-showcase.sh --hard
```

---

## CI / Qualität lokal

```bash
./scripts/ci-check.sh
```

---

## Weitere Optimierungsideen

Dinge, die sich beim Zusammenbau aufgefallen haben — **nicht** alle müssen umgesetzt werden; Priorität nach Teambedarf.

1. ~~**Versionen pinnen**~~ — **Erledigt:** [PINNED_VERSIONS.txt](PINNED_VERSIONS.txt), Pflege via `./scripts/refresh-pinned-versions.sh`.
2. ~~**Preflight-Skript**~~ — **Erledigt:** `./scripts/preflight.sh` (Docker, Python ≥3.11, Nachbar-Ordner, Speicher, Ports; in GitHub Actions werden Docker-Checks übersprungen).
3. **Wartezeit BRA** — Statt fester Sleep-Schleifen in M2.1: `curl`-Retry auf `/ga4gh/drs/v1/service-info` bis HTTP 200 (teilweise schon vorhanden).
4. **Ein CLI-Einstieg** — Dünner Wrapper `showcase` (z. B. `showcase run`, `showcase stop`, `showcase m2`) reduziert dokumentierte Env-Variablen.
5. **Strukturiertes Log** — Optionales Append in `artifacts/run.jsonl` (Timestamp, Schritt, Exit-Code) für Post-Mortem nach Demos.
6. **HelixTest-Gate** — Separater dokumentierter Schritt oder Job: `HelixTest` gegen laufendes Ferrum-Profil, ohne es ins gleiche Shell-Skript zu verzwängen.
7. **Sicherheit** — Auto-kopierte `bioresearch-assistant/.env` nie committen; `.gitignore` in BRA prüfen; keine Secrets in Showcase-Artefakten.
8. **Schwere CI** — Nightly-Workflow mit Docker (nur wenn Runner-Ressourcen da sind); PR bleibt bei leichtem `ci-check` wie heute.
9. **UX** — Einseitige PDF/HTML aus `showcase-report.md` (später: pandoc o. Ä., optional).

---

## Siehe auch

- [README.md](README.md) — Env-Variablen, Troubleshooting-Tabelle, M1–M3
- [contrib/bioresearch-assistant-postgres-override.yml](contrib/bioresearch-assistant-postgres-override.yml) — Postgres-Host-Port für Parallelbetrieb
