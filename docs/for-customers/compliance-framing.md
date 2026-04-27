# Compliance und technische Evidenz — was Ferrum und HELIOS leisten und was nicht

[🇬🇧 English below](#english)

---

## Was diese Seite klärt

Wenn Sie in einem regulierten Umfeld arbeiten, ist die Compliance-Frage zentral. Diese Seite erklärt ehrlich was Ferrum und HELIOS in diesem Kontext leisten — und wo Ihre organisatorische Verantwortung beginnt.

---

## Was Ferrum erzeugt

Bei jedem Datenzugriff und jeder Workflow-Ausführung erzeugt Ferrum nachvollziehbare Provenance-Daten: Wer hat welche Daten unter welchen Bedingungen abgerufen? Welcher Workflow wurde mit welchen Parametern ausgeführt? Diese Daten werden strukturiert gespeichert und als RO-Crate exportierbar gemacht.

## Was HELIOS erzeugt

Bei jedem Pipeline-Lauf erzeugt HELIOS signierte Audit-Artefakte: Was waren die Input-Dateien (mit SHA256-Hashwerten)? Was sind die Output-Dateien (mit SHA256-Hashwerten)? Welche Checks wurden durchgeführt und was war das Ergebnis?

Diese Artefakte sind **technische Evidenz** — sie dokumentieren was passiert ist, auf eine Weise die nachvollziehbar, maschinenlesbar und unveränderlich ist.

---

## Was das für Compliance-Prozesse bedeutet

Technische Evidenz-Artefakte **unterstützen** Compliance-Prozesse:
- Interne Audits werden einfacher, weil Dokumentation automatisch entsteht
- Externe Prüfungen werden schneller, weil Prüfer keine manuellen Protokolle durchsuchen müssen
- Studien-Dokumentation wird konsistenter, weil jeder Lauf dieselbe Struktur erzeugt

---

## Was Ferrum und HELIOS NICHT ersetzen

**Keine formale Zertifizierung.** Die Werkzeuge können Zertifizierungsprozesse unterstützen — aber die Zertifizierung selbst liegt beim Betreiber und seiner Governance.

**Keine automatische EHDS-Compliance.** EHDS stellt Anforderungen an Prozesse, Governance, Datenzugang-Policies und organisatorische Verantwortlichkeiten — nicht nur an technische Schnittstellen.

**Keine DSGVO-Garantie.** DSGVO-Konformität hängt davon ab wie Sie die Werkzeuge betreiben und in Ihre Daten-Governance einbetten.

**Kein Ersatz für Sicherheits-Reviews.** Penetrationstests, Threat Modeling und Datenschutzfolgenabschätzungen sind organisatorische Prozesse die durch Werkzeuge nicht ersetzt werden.

---

## Empfohlene Sprachformulierungen

✅ **Geeignet:**
- „Ferrum und HELIOS erzeugen technische Evidenz die unsere Compliance-Dokumentation unterstützt"
- „HELIOS automatisiert die Audit-Trail-Erzeugung für unsere Genomik-Pipelines"
- „Ferrum implementiert GA4GH-Schnittstellen, die für EHDS-Interoperabilität relevant sind"

❌ **Zu vermeiden:**
- „Mit Ferrum sind wir EHDS-konform"
- „HELIOS zertifiziert unsere Pipelines"
- „Wir sind compliant weil wir Synaptic-Four-Software verwenden"

Diese Unterscheidung schützt Sie in einem Audit.

---

## Fragen?

[contact@synapticfour.com](mailto:contact@synapticfour.com)

---

---

<a name="english"></a>

# Compliance and technical evidence — what Ferrum and HELIOS do, and what they don't (English)

---

## What Ferrum produces

On every data access and workflow execution, Ferrum produces traceable provenance data: who accessed which data under what conditions, which workflow ran with which parameters. Stored in structured form and exportable as RO-Crate.

## What HELIOS produces

On every pipeline run, HELIOS produces signed audit artefacts: input files (with SHA256 hashes), output files (with SHA256 hashes), checks run and their results.

These artefacts are **technical evidence** — they document what happened in a way that is traceable, machine-readable, and immutable.

---

## What this means for compliance processes

Technical evidence artefacts **support** compliance processes:
- Internal audits become easier because documentation is generated automatically
- External reviews become faster because auditors don't need to search through manual logs
- Study documentation becomes more consistent because every run produces the same structure

---

## What Ferrum and HELIOS do NOT replace

**No formal certification.** The tools can support certification processes — but certification itself rests with the operator and their governance.

**No automatic EHDS compliance.** EHDS places requirements on processes, governance, data access policies, and organisational responsibilities — not just technical interfaces.

**No GDPR guarantee.** GDPR compliance depends on how you operate and embed the tools in your data governance.

**No substitute for security reviews.** Penetration testing, threat modelling, and data protection impact assessments are organisational processes that tools cannot replace.

---

## Recommended language

✅ **Appropriate:**
- "Ferrum and HELIOS generate technical evidence that supports our compliance documentation"
- "HELIOS automates audit trail generation for our genomics pipelines"
- "Ferrum implements GA4GH interfaces relevant for EHDS interoperability"

❌ **Avoid:**
- "With Ferrum we are EHDS-compliant"
- "HELIOS certifies our pipelines"
- "We are compliant because we use Synaptic Four software"

---

*Synaptic Four · Stuttgart, Germany · [synapticfour.com](https://synapticfour.com/en)*
