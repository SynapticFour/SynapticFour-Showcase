# Welcher Einstieg passt zu mir?

*Fünf Szenarien. Klare Empfehlung. Kein Verkaufsgespräch.*

[🇬🇧 English below](#english)

---

## Szenario A — „Wir müssen mit anderen Institutionen interoperabel werden"

**Typische Ausgangssituation:** EHDS-Anforderungen kommen auf Sie zu. Ein Partnernetzwerk verlangt GA4GH-Schnittstellen. Die MII-Anbindung steht auf der Roadmap.

**Empfohlener Einstieg: Ferrum**

Was das konkret bedeutet:
- Nur die Ferrum-Dienste deployen, die Sie für einen ersten Datenpfad brauchen (z.B. DRS + WES)
- Einen repräsentativen Datensatz und eine Workflow-Übergabe validieren
- Baseline-Outputs für Stakeholder-Review festhalten

Was Sie danach wissen: Ob Ferrum in Ihre Infrastruktur passt und welcher Aufwand eine vollständigere Integration bedeutet.

**Zeitrahmen:** 10–14 Tage bis erste Ergebnisse.

---

## Szenario B — „Wir brauchen Audit-Trails für unsere bestehenden Pipelines"

**Typische Ausgangssituation:** Compliance-Druck steigt. Prüfungen werden anspruchsvoller. Ihr Team dokumentiert Pipeline-Läufe manuell oder gar nicht. Sie wollen das verbessern ohne alles neu zu bauen.

**Empfohlener Einstieg: HELIOS**

Was das konkret bedeutet:
- Bestehende Nextflow- oder Snakemake-Pipeline unverändert lassen
- HELIOS als Overlay ausführen, das bei jedem Lauf signierte Audit-Artefakte erzeugt
- Artefakte in Ihren Release- oder QA-Prozess einbinden

Was Sie danach wissen: Wie HELIOS-Artefakte aussehen, wie sie in Ihre bestehenden Prozesse passen, und ob der Aufwand für eine breitere Einführung gerechtfertigt ist.

**Zeitrahmen:** 7–14 Tage bis erste signierte Artefakte.

---

## Szenario C — „Wir brauchen eine technische Evidenz-Story für EHDS / Compliance-Reviews"

**Typische Ausgangssituation:** Ihr Institut steht vor EHDS-Fristen. Compliance-Stakeholder brauchen keine theoretischen Dokumente, sondern nachweisbare technische Artefakte. Sie wollen sowohl Interoperabilität als auch Dokumentierbarkeit.

**Empfohlener Einstieg: Ferrum + HELIOS**

Was das konkret bedeutet:
- Ferrum für strukturierten Datenzugang und Provenance
- HELIOS für Audit-Artefakte aus echten Pipeline-Läufen
- Beides kombiniert zu einem wiederverwendbaren Dokumentationspaket pro Studie oder Release

Was Sie danach wissen: Wie ein EHDS-orientiertes technisches Evidenz-Paket für Ihre Institution aussehen kann.

**Zeitrahmen:** 20–30 Tage bis zum ersten Review-fähigen Paket.

---

## Szenario D — „Wir wollen RAG auf unseren eigenen Daten — on-premise"

**Typische Ausgangssituation:** Ihre Forschenden wollen über interne Pipeline-Outputs, Leitlinien oder gefilterte Literatur abfragen. Sie wollen keine Daten in eine externe KI schicken. Sie brauchen Quellenangaben, keine Halluzinationen.

**Empfohlener Einstieg: BioResearch Assistant**

Was das konkret bedeutet:
- Erlaubte interne Quellen definieren (Dokumente, Pipeline-Outputs, Metadaten)
- Kuratierte Teilmenge in den RAG-Workflow einlesen
- Antwortqualität mit Quellenprüfungen validieren
- Rollenbasierte Zugriffsgrenzen setzen

Was Sie danach wissen: Ob RAG auf Ihren spezifischen Daten die Forschungsproduktivität verbessert — und welche Governance-Anforderungen das stellt.

**Zeitrahmen:** 14–21 Tage bis erste validierte Antworten.

---

## Szenario E — „Wir brauchen klinische Autorisierung und Audit — getrennt von der Genomic Plane"

**Typische Ausgangslage:** EHDS / nationale Vorgaben verlangen nachweisbare Zugriffsentscheidungen und unveränderliche Audit-Trails für klinische Daten. Sie wollen das **nicht** in denselben Deploy wie Ferrum mischen.

**Empfohlener Einstieg: Solum** (lokal zuerst [Solum-Demo](https://github.com/SynapticFour/Solum-Demo))

Was das konkret bedeutet:
- Fail-closed Autorisierung, Consent grant/revoke und tamper-evident Audit als Stage-1-Nachweis erleben (`make smoke-all` / UI Szenarien 1–3)
- Jurisdiction-/Consent-Story getrennt von GA4GH-Genomics halten; optional Track B CDR live (`make up-h3`)
- Später an die Showcase-Evidenzkette anbinden (siehe [Implementation Plan](../IMPLEMENTATION-PLAN-EVIDENCE-CHAIN.md))

Was Sie danach wissen: Ob Solums Perimeter zu Ihrer klinischen Compliance-Lage passt — ohne Genomic-Stack-Rewrite.

**Zeitrahmen:** Stunden (Demo) bis 10–20 Tage (Pilot-Framing).

---

## Was ist Ihr nächster Schritt?

| Situation | Empfehlung |
|-----------|-----------|
| Ergebnisse sehen ohne Installation | → [demo/results/](../../demo/results/) |
| Demo selbst ausführen | → [DEMO.md](../../DEMO.md) |
| Als Technical Lead tief evaluieren | → [Technical Evaluation Kit](../for-evaluators/technical-evaluation-kit.md) |
| Direkt sprechen | → [contact@synapticfour.com](mailto:contact@synapticfour.com) |

---

---

<a name="english"></a>

# Which path fits me? (English)

*Five scenarios. Clear recommendation. No sales conversation.*

---

## Scenario A — "We need to become interoperable with other institutions"

**Typical starting point:** EHDS requirements are approaching. A partner network requires GA4GH interfaces. MII integration is on the roadmap.

**Recommended entry: Ferrum**

What this means in practice:
- Deploy only the Ferrum services needed for one first data path (e.g. DRS + WES)
- Validate one representative dataset and one workflow handoff
- Capture baseline outputs for stakeholder review

What you'll know afterwards: whether Ferrum fits your infrastructure and what effort a more complete integration would mean.

**Timeframe:** 10–14 days to first results.

---

## Scenario B — "We need audit trails for our existing pipelines"

**Typical starting point:** Compliance pressure is increasing. Reviews are becoming more demanding. Your team logs pipeline runs manually or not at all. You want to improve this without rebuilding everything.

**Recommended entry: HELIOS**

What this means in practice:
- Keep existing Nextflow or Snakemake pipelines unchanged
- Run HELIOS as an overlay generating signed audit artefacts on every run
- Embed artefacts in your release or QA process

**Timeframe:** 7–14 days to first signed artefacts.

---

## Scenario C — "We need a technical evidence story for EHDS / compliance reviews"

**Typical starting point:** Your institution faces EHDS deadlines. Compliance stakeholders need demonstrable technical artefacts, not theoretical documents.

**Recommended entry: Ferrum + HELIOS**

What this means in practice:
- Ferrum for structured data access and provenance
- HELIOS for audit artefacts from real pipeline runs
- Both combined into a reusable documentation package per study or release

**Timeframe:** 20–30 days to first reviewable package.

---

## Scenario D — "We want RAG on our own data — on-premise"

**Typical starting point:** Your researchers want to query internal pipeline outputs, guidelines, or filtered literature. You don't want data going to an external AI. You need citations, not hallucinations.

**Recommended entry: BioResearch Assistant**

**Timeframe:** 14–21 days to first validated responses.

---

## Scenario E — "We need clinical authorization and audit — separate from the genomic plane"

**Typical starting point:** EHDS / national rules demand provable access decisions and tamper-evident audit for clinical data. You do **not** want that mixed into the same deploy as Ferrum.

**Recommended entry: Solum** (start local with [Solum-Demo](https://github.com/SynapticFour/Solum-Demo))

What this means in practice:
- Experience fail-closed authorization, consent grant/revoke, and tamper-evident audit as Stage-1 proof (`make smoke-all` / UI Scenarios 1–3)
- Keep jurisdiction/consent story separate from GA4GH genomics; optional Track B CDR live (`make up-h3`)
- Later attach to the Showcase evidence chain ([Implementation Plan](../IMPLEMENTATION-PLAN-EVIDENCE-CHAIN.md))

**Timeframe:** Hours (demo) to 10–20 days (pilot framing).

---

## What is your next step?

| Situation | Recommendation |
|-----------|---------------|
| See results without installing anything | → [demo/results/](../../demo/results/) |
| Run the demo yourself | → [DEMO.md](../../DEMO.md) |
| Evaluate deeply as technical lead | → [Technical Evaluation Kit](../for-evaluators/technical-evaluation-kit.md) |
| Talk directly | → [contact@synapticfour.com](mailto:contact@synapticfour.com) |

---

*Synaptic Four · Stuttgart, Germany · [synapticfour.com](https://synapticfour.com/en)*
