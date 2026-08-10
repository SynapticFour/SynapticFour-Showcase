# Roadmap — SynapticFour Showcase

*Eine Orientierung was kommt — keine vertragliche Zusage.*

[🇬🇧 English below](#english)

---

## Was gerade in Arbeit ist

🔨 **In Arbeit:**
- One-command Demo-Setup (`showcase` CLI-Wrapper)
- Strukturiertes Run-Log (`artifacts/run.jsonl`)

📋 **Geplant:**
- Coordinated portfolio H1–H4 — siehe [`docs/internal/COORDINATED-PORTFOLIO-ROADMAP.md`](docs/internal/COORDINATED-PORTFOLIO-ROADMAP.md)
- PDF/HTML-Export des Showcase-Reports (pandoc-basiert, optional)
- Erweiterung der vorgenerierten Demo-Artefakte (mehr Szenarien, mehr Produkte)
- Beacon v2 Demo-Szenario als eigenständiger Showcase-Pfad

💡 **Wird evaluiert:**
- Interaktiver Setup-Guide für erste Demo-Ausführung

---

## Was zuletzt fertig wurde

- ✅ Evidence-Chain W4 Phase B — Ferrum `--gatk-rs` Soft-Path + Integration Suite + `demo/verification/` (Aug 2026)
- ✅ Evidence-Chain W4 Phase A — gatk-rs smoke + S4MP sidecar (soft-fail; Ferrum WES deferred) (Aug 2026)
- ✅ Evidence-Chain W3 — Consent gate (PhenoFlow purpose → Solum before WES; allow/deny) (Aug 2026)
- ✅ Evidence-Chain W2 — Evidence Pack CLI (`make evidence-pack` / `--fixtures`) (Aug 2026)
- ✅ Evidence-Chain W0 + W1 — Solum pins, Path E, `make solum-stage` / `golden-path-with-solum` (Aug 2026)
- ✅ Sync mit Nachbar-Repos (Ferrum-GA4GH-Demo, HELIOS, bioresearch-assistant) — Juni 2026 (23.06.)
- ✅ `demo/results/` Host-Pfade bereinigt; `scripts/publish-demo-results.sh` für künftige Golden-Path-Läufe
- ✅ `demo/results/` Artefakte neu generiert (Nextflow-Golden-Path, HELIOS-Audit)
- ✅ `PINNED_VERSIONS.txt` auf aktuelle Git-HEADs
- ✅ Evaluator-Docs: Ferrum-Gateway-Port **18080**, HELIOS-CLI (`helios run`)
- ✅ Kunden-orientiertes README mit DE/EN (April 2026)
- ✅ Neue Dokumentenstruktur: `for-customers/` / `for-evaluators/` / `internal/` (April 2026)
- ✅ Zweisprachige Docs (DE/EN in einer Datei) (April 2026)
- ✅ PINNED_VERSIONS.txt + Preflight-Skript

---

## Was wir NICHT vorhaben

- **Kein SaaS-Modell** für Ferrum oder HELIOS. On-Premise-first bleibt die Architektur.
- **Keine automatischen Updates** die Ihre On-Premise-Instanz ohne Ihre Kontrolle verändern.
- **Kein Vendor-Lock-in** durch proprietäre Datenformate. Alle Export-Formate sind offen spezifiziert.
- **Keine Cloud-Abhängigkeit als Default.**

---

## Feedback geben

[contact@synapticfour.com](mailto:contact@synapticfour.com)

Wenn Sie evaluiert haben — egal ob positiv, negativ, oder „hat nicht gepasst" — schreiben Sie uns. Wir sind klein genug dass das wirklich die Roadmap beeinflusst.

---

## Stabilitäts-Versprechen

- **BUSL-1.1 → Apache-2.0:** Ferrum und BioResearch Assistant wechseln nach vier Jahren automatisch zu Apache-2.0. Im Lizenztext festgelegt.
- **HELIOS-Kern:** Bleibt Apache-2.0.
- **Breaking Changes:** Werden in den Upstream-Repos angekündigt, nicht still eingespielt.

---

---

<a name="english"></a>

# Roadmap (English)

*An orientation of what's coming — not a contractual commitment.*

---

## What's currently in progress

🔨 **In progress:**
- One-command demo setup (`showcase` CLI wrapper)
- Structured run log (`artifacts/run.jsonl`)

📋 **Planned:**
- Coordinated portfolio H1–H4 — see [`docs/internal/COORDINATED-PORTFOLIO-ROADMAP.md`](docs/internal/COORDINATED-PORTFOLIO-ROADMAP.md)
- PDF/HTML export of showcase report
- Expanded pre-generated demo artefacts
- Beacon v2 demo scenario as standalone showcase path

---

## Recently completed

- ✅ Evidence-chain W4 Phase B — Ferrum `--gatk-rs` soft path + integration suite + `demo/verification/` (Aug 2026)
- ✅ Evidence-chain W4 Phase A — gatk-rs smoke + S4MP sidecar (soft-fail; Ferrum WES deferred) (Aug 2026)
- ✅ Evidence-chain W3 — Consent gate (PhenoFlow purpose → Solum before WES; allow/deny) (Aug 2026)
- ✅ Evidence-chain W2 — Evidence Pack CLI (`make evidence-pack` / `--fixtures`) (Aug 2026)
- ✅ Evidence-chain W0 + W1 — Solum pins, Path E, `make solum-stage` / `golden-path-with-solum` (Aug 2026)
- ✅ Neighbor-repo sync (Ferrum-GA4GH-Demo, HELIOS, bioresearch-assistant) — June 2026 (23 Jun)
- ✅ Sanitized `demo/results/` host paths; added `scripts/publish-demo-results.sh` for future golden-path runs
- ✅ Regenerated `demo/results/` artefacts (Nextflow golden path + HELIOS audit)
- ✅ Updated `PINNED_VERSIONS.txt` to current Git HEADs
- ✅ Evaluator docs: Ferrum gateway port **18080**, HELIOS CLI (`helios run`)

---

## What we will NOT do

- **No SaaS model** for Ferrum or HELIOS. On-premise-first remains the architecture.
- **No automatic updates** that change your on-premise instance without your control.
- **No vendor lock-in** through proprietary data formats.
- **No cloud dependency as default.**

---

## How to give feedback

[contact@synapticfour.com](mailto:contact@synapticfour.com)

If you've evaluated — positive, negative, or "didn't fit" — write to us. We're small enough that it genuinely influences the roadmap.

---

## Stability commitments

- **BUSL-1.1 → Apache-2.0:** Ferrum and BioResearch Assistant switch to Apache-2.0 after four years. Stated in the licence text.
- **HELIOS core:** Stays Apache-2.0.
- **Breaking changes:** Announced in upstream repos, never silently introduced.

---

*Synaptic Four · Stuttgart, Germany · synapticfour.com*
