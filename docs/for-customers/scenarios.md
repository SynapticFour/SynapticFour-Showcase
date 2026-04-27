# Szenarien — Wie sieht das in der Praxis aus?

*Komposit und anonymisiert — basierend auf realen Anforderungen aus Gesprächen mit Institutionen, aber kein einzelner identifizierbarer Kunde.*

[🇬🇧 English below](#english)

---

## Szenario 1: Uniklinikum mit EHDS-Frist und heterogener Infrastruktur

**Ausgangssituation:** Ein Universitätsklinikum mit einem Bioinformatik-Kern arbeitet mit drei verschiedenen Datenspeichersystemen und zwei Pipeline-Orchestratoren. Die interne Compliance-Abteilung verlangt konkrete technische Nachweise für EHDS-Readiness — in sechs Monaten.

**Was nicht funktioniert hätte:**
- Vollständige Neuarchitektur in sechs Monaten
- Ersetzen laufender Produktionspipelines
- SaaS-Dienst bei dem Patientendaten die Institution verlassen

**Was stattdessen passiert ist:**

*Woche 1–2:* Ferrum als API-Schicht über den bestehenden Datenspeichern deployen. Nur DRS und WES für einen ersten Datenpfad (Variant-Calling für eine laufende Studie). Bestehende Speicher bleiben unberührt.

*Woche 3–4:* HELIOS auf dem bestehenden Nextflow-Lauf dieser Studie ausführen. Audit-Artefakte einsehen, mit dem Compliance-Team besprechen was sie daraus machen können.

*Woche 5–8:* Das Dokumentationspaket (Ferrum-Provenance + HELIOS-Artefakte) für die interne EHDS-Review aufbauen. Lücken identifizieren die organisatorisch geschlossen werden müssen.

**Ergebnis:** Ein nachweisbares technisches Fundament für die EHDS-Readiness-Dokumentation — ohne eine einzige bestehende Pipeline zu verändern.

---

## Szenario 2: DFG-Projekt mit Open-Science-Pflicht und DSGVO

**Ausgangssituation:** Eine Forschungsgruppe mit DFG-Förderung muss genomische Analyseergebnisse publizierbar und nachvollziehbar machen (FAIR-Data), hat aber Daten mit Patientenbezug die nicht öffentlich zugänglich sein dürfen.

**Das Spannungsfeld:** Open Science verlangt Reproduzierbarkeit und Zugänglichkeit. DSGVO verlangt Datenschutz. Beides gleichzeitig ist kein trivialer Widerspruch.

**Was der Stack ermöglicht:**

HELIOS erzeugt einen signierten Audit-Trail der zeigt: Mit diesen Inputs (Hashes, keine Rohdaten), mit diesem Workflow, unter diesen Bedingungen, entstand dieser Output. Dieser Trail ist publishable — ohne die Rohdaten zu exponieren.

Ferrum stellt über Crypt4GH sicher dass Daten für autorisierte Partner zugänglich gemacht werden können ohne im Klartext zu reisen. Zugänge können auf genehmigte Anfragen beschränkt werden (Passports, Beacon v2).

**Ergebnis:** FAIR-Data-konformes Publizieren ohne Patientendaten zu exponieren. Der HELIOS-Audit-Trail ist das Supplement das Reviewer und Prüfer zufriedenstellt.

---

## Szenario 3: RAG auf internen Daten ohne Datenweitergabe

**Ausgangssituation:** Ein Bioinformatik-Institut hat über Jahre interne Dokumentation angesammelt — Pipeline-Protokolle, SOPs, kommentierte Variant-Reports. Forschende können nicht effizient durch diese Masse navigieren. Ein externes KI-Tool ist keine Option weil die Daten das Institut nicht verlassen dürfen.

**Was passiert:**

Mit dem BioResearch-Assistant-Locus-Modul wird eine kuratierte Teilmenge der internen Dokumente in einen lokalen RAG-Index eingelesen. Forschende können in natürlicher Sprache abfragen — „Welche SOP gilt für Trio-Exom-Analysen mit GATK?", „Wie haben wir das VAF-Cutoff in der Leukämie-Kohorte begründet?" — und erhalten Antworten mit direkten Quellenverweisen.

Kein Dokument verlässt die Institution. Kein externes Modell sieht die Anfragen.

**Ergebnis:** Forschungsproduktivität verbessert sich weil internes Wissen zugänglich wird — ohne Governance-Kompromisse.

---

## Haben Sie ein ähnliches Szenario?

[contact@synapticfour.com](mailto:contact@synapticfour.com)

Wir sagen ehrlich ob wir helfen können, und wenn ja wie.

---

---

<a name="english"></a>

# Scenarios — What does this look like in practice? (English)

*Composite and anonymised — based on real requirements from conversations with institutions.*

---

## Scenario 1: University hospital with EHDS deadline and heterogeneous infrastructure

**Starting point:** A university hospital bioinformatics core works with three different data storage systems and two pipeline orchestrators. The internal compliance team demands concrete technical evidence for EHDS readiness — in six months.

**What wouldn't have worked:**
- Complete re-architecture in six months
- Replacing running production pipelines
- A SaaS service where patient data leaves the institution

**What happened instead:**

*Weeks 1–2:* Deploy Ferrum as an API layer over existing data stores. Only DRS and WES for one first data path. Existing stores remain untouched.

*Weeks 3–4:* Run HELIOS on the existing Nextflow run of that study. Review audit artefacts, discuss with the compliance team what they can use them for.

*Weeks 5–8:* Build the documentation package (Ferrum provenance + HELIOS artefacts) for the internal EHDS review. Identify gaps that need to be closed organisationally.

**Result:** A demonstrable technical foundation for EHDS readiness documentation — without changing a single existing pipeline.

---

## Scenario 2: DFG project with open science obligation and GDPR

**The tension:** Open Science requires reproducibility and accessibility. GDPR requires data protection. Both simultaneously is not trivial.

**What the stack enables:**

HELIOS generates a signed audit trail showing: with these inputs (hashes, no raw data), with this workflow, under these conditions, this output was produced. This trail is publishable — without exposing raw data.

Ferrum uses Crypt4GH to ensure data can be made accessible to authorised partners without travelling in plaintext. Access can be restricted to approved requests (Passports, Beacon v2).

**Result:** FAIR-data-compliant publishing without exposing patient data.

---

## Scenario 3: RAG on internal data without data sharing

**Starting point:** A bioinformatics institute has accumulated years of internal documentation — pipeline logs, SOPs, annotated variant reports. Researchers cannot navigate this efficiently. An external AI tool is not an option.

**What happens:**

BioResearch Assistant Locus module ingests a curated subset into a local RAG index. Researchers query in natural language and receive answers with direct source references. No document leaves the institution. No external model sees the queries.

**Result:** Research productivity improves because internal knowledge becomes accessible — without governance compromises.

---

## Do you have a similar scenario?

[contact@synapticfour.com](mailto:contact@synapticfour.com)

---

*Synaptic Four · Stuttgart, Germany · [synapticfour.com](https://synapticfour.com/en)*
