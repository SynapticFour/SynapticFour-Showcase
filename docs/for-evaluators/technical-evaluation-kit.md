# Technical Evaluation Kit

*Für technische Evaluatoren, Solution Architects und Bioinformatik-Leads die tief validieren wollen.*

[🇬🇧 English below](#english)

---

## Schritt 1: Scope festlegen bevor Sie evaluieren

Definieren Sie diese vier Punkte bevor Sie anfangen:

1. **Gewählter Einstiegspfad:** A (Ferrum), B (HELIOS), C (A+B) oder D (BioResearch Assistant) → [Pfad wählen](../for-customers/which-path.md)
2. **In-Scope-Systeme:** Welche genauen Dienste und Schnittstellen testen Sie?
3. **Out-of-Scope:** Was verschieben Sie bewusst auf später?
4. **Datenschutz der Test-Daten:** Welche Datensätze sind für den Pilot genehmigt?

---

## Schritt 2: Technische Akzeptanzkriterien

### Integrations-Fit
- Bestehende Pipeline-Orchestratoren können mit definiertem Adaptionsaufwand weitergenutzt werden
- Benötigte Schnittstellen und Abhängigkeiten sind bekannt und dokumentiert
- Keine versteckten Blocker in Netzwerk, Storage oder Identity-Annahmen

### Reproduzierbarkeit und Nachvollziehbarkeit
- Läufe können unter denselben Bedingungen mit konsistenten Ergebnissen wiederholt werden
- Inputs, Outputs und Run-Metadaten können verknüpft und reviewed werden

### Evidenz-Qualität
- Audit/Evidenz-Artefakte werden konsistent für ausgewählte Flows erzeugt
- Artefakte sind für Engineering- und Compliance-Reviewer verständlich

### Operationale Readiness
- Runbook-Schritte können von Ihrem Team ausgeführt werden
- Fehlerbilder und Troubleshooting-Wege sind dokumentiert

---

## Schritt 3: Pfad-spezifische Checks

### Path A — Ferrum

```bash
# Service-Info prüfen
curl http://localhost:8080/ga4gh/drs/v1/service-info
curl http://localhost:8090/ga4gh/wes/v1/service-info

# Preflight
./scripts/preflight.sh --strict
```

Erfolgskriterium: Ein API/Datenpfad ist vollständig end-to-end getestet; Output-Artefakte reichen für Stakeholder-Review.

### Path B — HELIOS

```bash
# HELIOS auf bestehendem Nextflow-Workdir
helios-audit run --workdir /path/to/your/nextflow/work --export-dir ./helios-reports

# Report lesen
cat helios-reports/<uuid>.json | jq '.checks'
```

Erfolgskriterium: HELIOS wrappt einen produktions-ähnlichen Lauf; Evidenz-Artefakte sind mit Release-IDs verknüpft.

### Path C — EHDS-Evidenz

Erfolgskriterium: Ferrum-Provenance und HELIOS-Evidenz sind in einem Review-Paket verknüpft; Compliance-Stakeholder bestätigen technische Dokumentierbarkeit.

### Path D — BioResearch Assistant / RAG

Erfolgskriterium: Erlaubte Quell-Grenzen werden bei der Ingestion durchgesetzt; Antworten werden gegen Quellenprüfungs-Kriterien validiert.

---

## Schritt 4: Minimales Artefakt-Set für Go/No-Go

- [ ] Scope- und Architektur-Snapshot
- [ ] Run-Outputs und Evidenz-Artefakte (HELIOS-Report, Benchmark, Metrics)
- [ ] Entscheidungslog (akzeptierte/verworfene Alternativen mit Begründung)
- [ ] Go/No-Go-Empfehlung mit Rationale

**Go/No-Go-Rubrik:**

| Entscheidung | Bedeutung |
|-------------|-----------|
| **Go** | Akzeptanzkriterien erfüllt, verbleibende Risiken handhabbar |
| **Conditional Go** | Wert nachgewiesen, mit spezifischen Remedierungs-Maßnahmen |
| **No-Go für jetzt** | Kern-Blocker ungelöst |

---

## Ressourcen

| Ressource | Zweck |
|-----------|-------|
| [DEMO.md](../../DEMO.md) | Vollständiges Runbook |
| [demo/results/](../../demo/results/) | Vorgeneriete Artefakte ohne Installation |
| [PINNED_VERSIONS.txt](../../PINNED_VERSIONS.txt) | Reproduzierbare Git-HEADs |
| `./scripts/preflight.sh` | Vorab-Check |
| `./scripts/run-golden-path.sh` | Vollständiger Demo-Lauf |

---

## Häufige technische Fragen

**„Wie teste ich ob Ferrum wirklich GA4GH-konform ist?"**
HelixTest ist das Konformitäts-Test-Framework. → https://github.com/SynapticFour/HelixTest

**„Was wenn unsere Umgebung kein Docker hat?"**
HPC-Deployment (SLURM/LSF) ist unterstützt. Sprechen Sie uns an.

**„Können wir die Signing-Keys selbst verwalten?"**
Ja. In `helios.toml` können Sie Ihren eigenen Key-Pfad definieren.

**„Was passiert wenn HELIOS einen Check-Fail hat?"**
Der Report wird trotzdem erzeugt — mit `"status": "fail"` für den entsprechenden Check. Sie sehen was fehlgeschlagen ist und warum.

---

## Nächster Schritt nach der Evaluation

[contact@synapticfour.com](mailto:contact@synapticfour.com)

Teilen Sie uns Ihre Go/No-Go-Entscheidung mit. Wenn es ein No-Go ist, wollen wir das wissen — ehrliches Feedback hilft uns und Ihnen.

---

---

<a name="english"></a>

# Technical Evaluation Kit (English)

*For technical evaluators, solution architects, and bioinformatics leads who want to validate deeply.*

---

## Step 1: Define scope before evaluating

Define these four points before starting:

1. **Chosen entry path:** A (Ferrum), B (HELIOS), C (A+B), or D (BioResearch Assistant) → [Choose a path](../for-customers/which-path.md)
2. **In-scope systems:** Which exact services and interfaces are you testing?
3. **Out-of-scope:** What are you deliberately deferring?
4. **Test data sensitivity:** Which datasets are approved for the pilot?

---

## Step 2: Technical acceptance criteria

### Integration fit
- Existing pipeline orchestrators can continue to be used with defined adaptation effort
- Required interfaces and dependencies are known and documented
- No hidden blockers in network, storage, or identity assumptions

### Reproducibility and traceability
- Runs can be repeated with consistent results under the same conditions
- Inputs, outputs, and run metadata can be linked and reviewed

### Evidence quality
- Audit/evidence artefacts are generated consistently for selected flows
- Artefacts are understandable by both engineering and compliance reviewers

### Operational readiness
- Runbook steps are executable by your team
- Failure modes and troubleshooting routes are documented

---

## Step 3: Go/No-Go rubric

| Decision | Meaning |
|----------|---------|
| **Go** | Acceptance criteria met, remaining risks manageable |
| **Conditional Go** | Value proven, with specific remediation actions and deadlines |
| **No-Go for now** | Core blockers unresolved |

---

## Resources

| Resource | Purpose |
|----------|---------|
| [DEMO.md](../../DEMO.md) | Complete runbook |
| [demo/results/](../../demo/results/) | Pre-generated artefacts, no installation needed |
| [PINNED_VERSIONS.txt](../../PINNED_VERSIONS.txt) | Reproducible Git HEADs |
| `./scripts/preflight.sh` | Pre-check |
| `./scripts/run-golden-path.sh` | Complete demo run |

---

## Common technical questions

**"How do I test whether Ferrum is really GA4GH-conformant?"**
HelixTest is the conformance test framework. → https://github.com/SynapticFour/HelixTest

**"What if our environment has no Docker?"**
HPC deployment (SLURM/LSF) is supported. Contact us.

**"Can we manage signing keys ourselves?"**
Yes. In `helios.toml` you can define your own key path.

**"What happens if HELIOS has a check failure?"**
The report is still generated — with `"status": "fail"` for the relevant check. You see what failed and why.

---

## Next step after evaluation

[contact@synapticfour.com](mailto:contact@synapticfour.com)

Tell us your Go/No-Go decision. If it's a No-Go, we want to know — honest feedback helps us and you.

---

*Synaptic Four · Stuttgart, Germany · [synapticfour.com](https://synapticfour.com/en)*
