# Contributing to SynapticFour-Showcase

## Was diese Repo ist / What this repo is

Dies ist ein kunden-orientierter **Integrator** (Skripte, Pins, Fixtures). Die primäre Zielgruppe sind Evaluator:innen. Produkt-Issues gehören in die Upstream-Repos.

`docs/internal/` sind Founder-Notizen — **kein Vertrag**.

Please open a **pull request** against `main` rather than pushing commits directly. GitHub Actions fixture-spine + secret-scan must be green. Do not describe fixture CI as a live stack.

Evaluators should judge **HEAD of `main`**, not older commits — see [docs/for-evaluators/evaluate-at-head.md](docs/for-evaluators/evaluate-at-head.md). We do not rewrite public git history.

This is a customer-facing showcase. Audience: prospective customers. `docs/internal/` is engineering notes, not a contract.

## Dokumenten-Struktur / Document structure

| Verzeichnis / Directory | Zielgruppe / Audience | Zweck / Purpose |
|-------------|----------|---------|
| `docs/for-customers/` | Potentielle Kunden / Prospective customers | FAQ, Pfadauswahl, Compliance, Szenarien |
| `docs/for-evaluators/` | Technical Leads, Solution Architects | Technische Tiefenevaluation |
| `demo/results/` | Alle / Everyone | Vorgeneriete Artefakte |
| `scripts/` | Technische Teams | Demo-Orchestrierung und CI |

Nach einem lokalen Golden-Path-Lauf: `./scripts/publish-demo-results.sh` aktualisiert `demo/results/` (portable Pfade, keine Host-Identifikatoren).

## Bugs in Ferrum, HELIOS oder BioResearch Assistant?

Bitte Issues in den jeweiligen Upstream-Repos öffnen:

- Ferrum: https://github.com/SynapticFour/Ferrum
- HELIOS: https://github.com/SynapticFour/HELIOS
- BioResearch Assistant: https://github.com/SynapticFour/bioresearch-assistant
- HelixTest: https://github.com/SynapticFour/HelixTest

## Sprache / Language

Kunden-Docs: Deutsch zuerst, Englisch am Ende der Datei.
Technische Scripts und Code: Englisch.
