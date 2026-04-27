# Häufige Fragen — Synaptic Four Showcase

*Diese Seite ist direkt für Sie als potentielle:n Kunden geschrieben.*

[🇬🇧 English below](#english)

---

## Einstieg und Scope

### Können wir wirklich nur einen Teil einsetzen?

Ja. Ferrum, HELIOS und BioResearch Assistant sind unabhängige Bausteine. Sie müssen nicht alles auf einmal deployen.

Typische Einstiege:
- **Nur Ferrum:** Sie brauchen GA4GH-Interoperabilität für ein Partnernetzwerk, aber keine Pipeline-Änderungen.
- **Nur HELIOS:** Ihre Pipelines laufen schon, Sie brauchen Audit-Trails und technische Dokumentation.
- **Ferrum + HELIOS:** Sie wollen sowohl Interoperabilität als auch Evidenz für Compliance-Prüfungen.
- **Alles inkl. BioResearch Assistant:** Vollständiger Stack mit RAG auf Ihren eigenen Daten.

→ [Welcher Einstieg passt zu mir?](which-path.md)

### Wie schnell sehen wir erste Ergebnisse?

Realistisch: **10–30 Tage** bis zum ersten nachweisbaren Ergebnis, abhängig von:
- Ihrer Infrastruktur (on-prem Setup, Docker-Verfügbarkeit, Netzwerkzugang)
- Ihrer Daten-Readiness (ein repräsentativer Datensatz, der für den Test verwendet werden kann)
- Ihrem internen Genehmigungsprozess

Ein erster, eingegrenzter Proof-of-Value kann und sollte in zwei Wochen stehen.

### Müssen wir unsere bestehenden Pipelines ersetzen?

Nein. HELIOS ist als Overlay konzipiert: Es legt sich über Ihre bestehenden Nextflow- oder Snakemake-Workflows und erzeugt Audit-Artefakte ohne dass Sie Ihre Ausführungslogik ändern.

---

## Daten und Compliance

### Verlassen unsere Daten die Institution?

Nein — wenn Sie on-premise deployen, bleiben alle Daten in Ihrer kontrollierten Infrastruktur. Das ist keine Marketing-Aussage sondern technische Architektur: Ferrum ist für on-premise-first ausgelegt.

### Ist das „certified compliant" (EHDS, DSGVO, NIS2, HIPAA)?

Nein, und wir sagen das offen. Ferrum und HELIOS erzeugen **technische Evidenz-Artefakte** — signierte Audit-Trails, Provenance-Daten, maschinenlesbare Run-Dokumentation. Diese Artefakte unterstützen Ihre Compliance-Prozesse und erleichtern interne und externe Prüfungen.

Die formale Compliance-Verantwortung liegt beim Betreiber. Wir versprechen keine Zertifizierungen, weil ein Werkzeug allein keine Zertifizierung ersetzen kann.

→ [Detailliertes Compliance-Framing](compliance-framing.md)

### Was ist GA4GH — müssen wir das kennen?

Nein, Sie müssen GA4GH nicht im Detail kennen um Ferrum zu evaluieren. Kurz: GA4GH (Global Alliance for Genomics and Health) ist ein internationaler Standard für Schnittstellen rund um genomische Daten. Wenn Ihr Institut mit anderen Institutionen oder Netzwerken (EHDS, MII, EGA, Horizon-Projekte) zusammenarbeiten will, ist GA4GH-Kompatibilität die technische Grundlage dafür.

---

## Technik und Integration

### Welche technischen Voraussetzungen brauchen wir?

Für eine erste Demo-Ausführung:
- Docker Desktop (8–12 GB RAM empfohlen)
- Python 3.11 oder neuer (für HELIOS)
- Git (für den Checkout)

Für einen produktiven Einsatz: Ferrum unterstützt PostgreSQL, S3-kompatiblen Objektspeicher (inkl. MinIO), SLURM/LSF für HPC-Cluster und Kubernetes. Das klären wir in einem ersten Gespräch.

### Wie sieht ein typischer Evaluationsprozess aus?

1. **Demo ansehen oder laufen lassen** — Artefakte in [demo/results/](../../demo/results/) oder selbst ausführen
2. **Einstiegspfad wählen** — welcher Baustein passt zu Ihrem dringendsten Problem
3. **Eingegrenzter Pilot** — zwei Wochen, ein Datensatz, ein definiertes Erfolgskriterium
4. **Stakeholder-Review** — technische und organisatorische Entscheidung

→ [Technical Evaluation Kit](../for-evaluators/technical-evaluation-kit.md)

---

## Kosten und Lizenz

### Was kostet das?

**Ferrum:** BUSL-1.1 Lizenz. Für zulässige nicht-kommerzielle Forschung und Evaluierung kostenfrei nutzbar; nach vier Jahren automatischer Wechsel zu Apache-2.0. Kommerzielle Nutzung erfordert Lizenzvereinbarung.

**HELIOS-Kern:** Apache-2.0, kostenfrei. Synaptic Four bietet kostenpflichtigen Support und optionales Dashboard-Hosting.

**BioResearch Assistant:**
- Institutionslizenz: €5.000 einmalig + €3.000/Jahr
- Onboarding: €2.000–5.000
- Support: €500–1.000/Monat

Diese Zahlen stehen offen auf der Website. Wir verstecken keine Preise hinter Verkaufsgesprächen.

### Was passiert wenn Synaptic Four aufhört zu existieren?

Eine berechtigte Frage. Ferrum und HELIOS wechseln nach vier Jahren zu Apache-2.0 — im Lizenztext festgelegt. Der Code ist öffentlich auf GitHub. Sie sind nicht auf uns angewiesen um die Software zu betreiben.

---

## Über Synaptic Four

### Wer sind Sie?

Ein kleines Bioinformatik-Infrastruktur-Team aus Stuttgart. Keine VC-Finanzierung, kein Cloud-Abhängigkeits-Geschäftsmodell. Sie sprechen mit den Entwicklern — nicht mit Account Managern.

Neurodiversität und Inklusion sind kein „CSR-Anhängsel" für uns — Kolleg:innen im Autismus-Spektrum arbeiten in zentralen technischen Rollen.

→ [Über uns](https://synapticfour.com/de/about)

### Warum Synaptic Four und nicht ein größerer Anbieter?

Weil größere Anbieter ein Cloud-Geschäftsmodell haben, das im Widerspruch zu Ihrer Datensouveränität steht. Wir haben diesen Interessenkonflikt nicht.

Was wir nicht sind: ein Team mit hundert Referenzkunden und zertifizierten Installationen weltweit. Wir sind präzise in dem was wir anbieten, und ehrlich über was wir noch nicht sind.

### Wie nehme ich Kontakt auf?

[contact@synapticfour.com](mailto:contact@synapticfour.com)

Kein automatisches CRM, keine SDR-Pipeline. Sie schildern Ihr Anliegen, wir antworten ehrlich ob und wie wir helfen können.

---

---

<a name="english"></a>

# Frequently Asked Questions (English)

*This page is written directly for you as a prospective customer.*

---

## Getting started and scope

### Can we really deploy only part of the stack?

Yes. Ferrum, HELIOS, and BioResearch Assistant are independent building blocks. You don't need to deploy everything at once.

Typical starting points:
- **Ferrum only:** You need GA4GH interoperability for a partner network, but no pipeline changes.
- **HELIOS only:** Your pipelines are already running; you need audit trails and technical documentation.
- **Ferrum + HELIOS:** You want both interoperability and evidence for compliance reviews.
- **Full stack including BioResearch Assistant:** Complete stack with RAG over your own data.

→ [Which path fits me?](which-path.md)

### How quickly do we see first results?

Realistically: **10–30 days** to a first demonstrable result, depending on your infrastructure, data readiness, and internal approval process.

A first, scoped proof-of-value can and should be standing in two weeks.

### Do we have to replace our existing pipelines?

No. HELIOS is designed as an overlay: it wraps your existing Nextflow or Snakemake workflows and generates audit artefacts without requiring changes to your execution logic.

---

## Data and compliance

### Does our data leave the institution?

No — if you deploy on-premise, all data stays in your controlled infrastructure. This is a technical architecture choice, not a marketing claim: Ferrum is designed on-premise-first.

### Is this "certified compliant" (EHDS, GDPR, NIS2, HIPAA)?

No, and we say so openly. Ferrum and HELIOS generate **technical evidence artefacts** — signed audit trails, provenance data, machine-readable run documentation. These artefacts support your compliance processes and ease internal and external reviews.

Formal compliance responsibility rests with the operator. We don't promise certifications because a tool alone cannot replace a certification.

→ [Detailed compliance framing](compliance-framing.md)

---

## Cost and licensing

### What does it cost?

**Ferrum:** BUSL-1.1 licence. Free for permitted non-commercial research and evaluation; after four years, automatic switch to Apache-2.0.

**HELIOS core:** Apache-2.0, free. Synaptic Four offers paid support and optional dashboard hosting.

**BioResearch Assistant:**
- Institutional licence: €5,000 one-time + €3,000/year
- Onboarding: €2,000–5,000
- Support: €500–1,000/month

These figures are openly listed on the website. We don't hide prices behind sales conversations.

### What happens if Synaptic Four ceases to exist?

A legitimate question. Ferrum and HELIOS switch to Apache-2.0 after four years — stated in the licence text. The code is publicly on GitHub. You are not dependent on us to operate the software.

---

## About Synaptic Four

### Why Synaptic Four and not a larger established provider?

Because larger providers have a cloud business model that conflicts with your data sovereignty. We don't have that conflict of interest.

What we're not: a team with a hundred reference customers and certified installations worldwide. We are precise about what we offer and honest about what we're not yet.

### How do I get in touch?

[contact@synapticfour.com](mailto:contact@synapticfour.com)

No automated CRM, no SDR pipeline. You describe your situation; we respond honestly about whether and how we can help.

---

*Synaptic Four · Stuttgart, Germany · [synapticfour.com](https://synapticfour.com/en)*
