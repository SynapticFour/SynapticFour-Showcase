# Synaptic Four — Showcase

**GA4GH-konforme Bioinformatik-Infrastruktur. On-Premise. Ohne Vendor Lock-in.**

[🌐 synapticfour.com](https://synapticfour.com/de) · [📬 contact@synapticfour.com](mailto:contact@synapticfour.com) · [🇬🇧 English below](#english)

---

## Was Sie hier sehen

Dieses Repository zeigt, wie die Kernbausteine von Synaptic Four **in einer echten, durchgängigen Pipeline zusammenspielen** — von der Daten-API bis zum signierten Audit-Report. Kein Marketing-Deck. Kein Versprechen. Echte Artefakte aus echten Läufen.

Wenn Sie evaluieren möchten ob diese Infrastruktur zu Ihrer Institution passt, sind Sie hier richtig.

---

## Das Problem, das wir lösen

Ihr Institut arbeitet mit genomischen Daten. Sie haben:

- Anforderungen nach GA4GH-Interoperabilität (EHDS, MII, nationale Netzwerke)
- Daten die **nicht** in eine kommerzielle Cloud dürfen
- Pipelines die heute laufen — und die niemand neu schreiben will
- Compliance-Druck, der konkrete technische Nachweise verlangt, nicht Policy-Folien

Ferrum, HELIOS und der BioResearch Assistant sind drei Bausteine die diesen Knoten lösen — einzeln einsetzbar, zusammen stärker.

---

## Was dieser Stack konkret tut

### 🦀 Ferrum — Das Daten- und API-Rückgrat

Ferrum bündelt die GA4GH-Schnittstellen die Ihr Institut für Interoperabilität braucht (TRS, DRS, WES, TES, htsget, Beacon v2, Passports, Crypt4GH) hinter einem gemeinsamen Gateway — auf Ihrem Server, in Rust gebaut, ohne erzwungenes SaaS-Modell.

**Was das für Sie bedeutet:** Ihre Daten bleiben wo sie hingehören. Partner-Institute, nationale Programme und internationale Netzwerke können trotzdem sauber angebunden werden — ohne endlose Sonderintegrationen.

→ [Ferrum auf GitHub](https://github.com/SynapticFour/Ferrum) · [Produktseite](https://synapticfour.com/de/ferrum)

### 🧪 HELIOS — Audit-Trails und technische Nachweise

HELIOS umschließt Ihre bestehenden Nextflow- oder Snakemake-Pipelines und erzeugt bei jedem Lauf automatisch signierte, unveränderliche Audit-Artefakte — ohne dass Sie Ihre Pipelines neu schreiben müssen.

**Was das für Sie bedeutet:** Wenn Ihr Compliance-Team oder ein Prüfer fragt „Wie wurde dieses Ergebnis erzeugt?", haben Sie eine nachvollziehbare, maschinenlesbare Antwort. Kein manuelles Protokollieren mehr.

→ [Beispiel-HELIOS-Report](demo/results/helios-report-example.json) · [HELIOS auf GitHub](https://github.com/SynapticFour/HELIOS)

### 🧬 BioResearch Assistant — On-Premise RAG für Forschung und Klinik

Der BioResearch Assistant ermöglicht Literature Mining, Pseudonymisierung, MII-Kerndatensatz-Export und — über das Locus-Modul — domänenspezifische RAG-Abfragen auf Ihren eigenen Daten. Alles on-premise, keine Daten verlassen Ihre Infrastruktur.

**Was das für Sie bedeutet:** Ihre Forschenden können über interne Pipelines, Leitlinien und PubMed-gefilterte Literatur abfragen — mit Quellenangaben, nicht Halluzinationen.

→ [BioResearch Assistant auf GitHub](https://github.com/SynapticFour/bioresearch-assistant) · [Produktseite](https://synapticfour.com/de/software)

---

## Was passiert wenn alles zusammenläuft

[→ Vollständige Ergebnis-Beispiele ansehen](demo/results/)

Ein typischer Durchlauf erzeugt:

| Artefakt | Was es zeigt |
|----------|-------------|
| `benchmark.json` | Precision / Recall / F1 des Variant-Calling-Laufs |
| `metrics.json` | WES-Run-ID, Engine, Laufzeit |
| `helios-report-*.json` | Signierter Audit-Trail: Input-Hashes, Output-Hashes, Check-Ergebnisse |
| `showcase-report.md` | Menschenlesbare Zusammenfassung für Stakeholder-Reviews |
| `drs-link-example.json` | Wie ein DRS-Objekt nach dem Import aussieht |

Sie müssen nichts installieren um diese Artefakte zu lesen — sie liegen bereits im Repository.

---

## Häufige Fragen

**„Müssen wir unsere bestehenden Nextflow/Snakemake-Pipelines ersetzen?"**
Nein. HELIOS legt sich als Overlay darüber. Kein Rewrite nötig.

**„Können wir nur einen Teil des Stacks einsetzen?"**
Ja. Ferrum, HELIOS und BioResearch Assistant sind unabhängig deploybar. Die meisten Institutionen starten mit einem Baustein.

**„Wie schnell kann ein erster Proof-of-Value stehen?"**
Realistisch: 10–30 Tage, abhängig von Ihrer Infrastruktur und Daten-Readiness. Wir benennen das transparent.

**„Ist das ‚zertifiziert compliant'?"**
Nein. Wir sagen das offen: Ferrum und HELIOS erzeugen technische Evidenz-Artefakte, die Compliance-Prozesse unterstützen. Die formale Compliance-Verantwortung liegt beim Betreiber. [Details dazu](docs/for-customers/compliance-framing.md).

**„Was kostet das?"**
Ferrum: BUSL-1.1 (für zulässige nicht-kommerzielle Forschung kostenfrei nutzbar, nach 4 Jahren Apache-2.0). BioResearch Assistant: Institutionslizenz ab €5.000 einmalig + €3.000/Jahr. HELIOS-Kern: Apache-2.0, kostenfrei. [Vollständige Preisinformation](https://synapticfour.com/de/software).

**„Wer steht dahinter?"**
Ein kleines Team aus Stuttgart, spezialisiert auf Bioinformatik-Infrastruktur, mit gelebtem Engagement für Neurodiversität und Inklusion. Keine VC-Finanzierung, kein Cloud-Abhängigkeits-Geschäftsmodell.

→ [Alle Fragen und Antworten](docs/for-customers/faq.md)

---

## Wie Sie als nächstes vorgehen

| Ich möchte… | →  |
|-------------|-----|
| Ergebnisse sehen, ohne etwas zu installieren | [demo/results/](demo/results/) |
| Die Demo lokal laufen lassen | [DEMO.md](DEMO.md) |
| Verstehen welcher Teil des Stacks zu mir passt | [Welcher Einstieg passt zu mir?](docs/for-customers/which-path.md) |
| Als Technical Lead tief evaluieren | [Technical Evaluation Kit](docs/for-evaluators/technical-evaluation-kit.md) |
| Direkt sprechen | [contact@synapticfour.com](mailto:contact@synapticfour.com) |

---

## Warum Synaptic Four und nicht ein größerer Anbieter?

Weil größere Anbieter ein Cloud-Geschäftsmodell haben, das im Widerspruch zu Ihrer Datensouveränität steht. Wir nicht.

Wir sind klein genug, dass Sie mit dem Entwickler sprechen — nicht mit einem Account Manager. Und wir haben keine finanziellen Anreize, Sie in ein Abo zu locken das Sie nicht brauchen.

Was wir nicht sind: ein Team mit hundert Referenzkunden und zertifizierten Installationen weltweit. Wir sind präzise in dem was wir anbieten, und ehrlich über was wir noch nicht sind.

→ [Über uns](https://synapticfour.com/de/about)

---

---

<a name="english"></a>

# Synaptic Four — Showcase (English)

**GA4GH-compliant bioinformatics infrastructure. On-premise. No vendor lock-in.**

[🌐 synapticfour.com](https://synapticfour.com/en) · [📬 contact@synapticfour.com](mailto:contact@synapticfour.com)

---

## What you'll find here

This repository shows how the core building blocks of Synaptic Four **work together in a real, end-to-end pipeline** — from the data API to a signed audit report. No marketing deck. No promises. Real artefacts from real runs.

If you're evaluating whether this infrastructure fits your institution, you're in the right place.

---

## The problem we solve

Your institution works with genomic data. You have:

- Requirements for GA4GH interoperability (EHDS, MII, national networks)
- Data that **must not** go to a commercial cloud
- Pipelines that run today — that nobody wants to rewrite
- Compliance pressure that demands concrete technical evidence, not policy slides

Ferrum, HELIOS, and BioResearch Assistant are three building blocks that untangle this. Deployable individually. Stronger together.

---

## What this stack concretely does

### 🦀 Ferrum — The data and API backbone

Ferrum bundles the GA4GH interfaces your institution needs for interoperability (TRS, DRS, WES, TES, htsget, Beacon v2, Passports, Crypt4GH) behind a shared gateway — on your server, built in Rust, with no forced SaaS model.

**What this means for you:** Your data stays where it belongs. Partner institutions, national programmes, and international networks can still connect cleanly — without endless custom integrations.

→ [Ferrum on GitHub](https://github.com/SynapticFour/Ferrum) · [Product page](https://synapticfour.com/en/ferrum)

### 🧪 HELIOS — Audit trails and technical evidence

HELIOS wraps your existing Nextflow or Snakemake pipelines and automatically generates signed, immutable audit artefacts on every run — without requiring you to rewrite your pipelines.

**What this means for you:** When your compliance team or an auditor asks "how was this result produced?", you have a traceable, machine-readable answer. No more manual logging.

→ [Example HELIOS report](demo/results/helios-report-example.json) · [HELIOS on GitHub](https://github.com/SynapticFour/HELIOS)

### 🧬 BioResearch Assistant — On-premise RAG for research and clinical settings

BioResearch Assistant enables literature mining, pseudonymisation, MII core dataset export, and — via the Locus module — domain-specific RAG queries over your own data. All on-premise; no data leaves your infrastructure.

**What this means for you:** Your researchers can query internal pipelines, guidelines, and PubMed-filtered literature — with citations, not hallucinations.

→ [BioResearch Assistant on GitHub](https://github.com/SynapticFour/bioresearch-assistant) · [Product page](https://synapticfour.com/en/software)

---

## What happens when everything runs together

[→ View complete result examples](demo/results/)

A typical run produces:

| Artefact | What it shows |
|----------|--------------|
| `benchmark.json` | Precision / Recall / F1 of the variant calling run |
| `metrics.json` | WES run ID, engine, elapsed time |
| `helios-report-*.json` | Signed audit trail: input hashes, output hashes, check results |
| `showcase-report.md` | Human-readable summary for stakeholder reviews |
| `drs-link-example.json` | What a DRS object looks like after import |

You don't need to install anything to read these artefacts — they're already in the repository.

---

## Common questions

**"Do we have to replace our existing Nextflow/Snakemake pipelines?"**
No. HELIOS wraps what you have as an overlay. No rewrite needed.

**"Can we deploy only part of the stack?"**
Yes. Ferrum, HELIOS, and BioResearch Assistant are independently deployable. Most institutions start with one building block.

**"How quickly can a first proof-of-value be set up?"**
Realistically: 10–30 days, depending on your infrastructure and data readiness. We state this transparently.

**"Is this 'certified compliant'?"**
No. We say this openly: Ferrum and HELIOS generate technical evidence artefacts that support compliance processes. Formal compliance responsibility rests with the operator. [Details here](docs/for-customers/compliance-framing.md).

**"What does it cost?"**
Ferrum: BUSL-1.1 (free for permitted non-commercial research, Apache-2.0 after 4 years). BioResearch Assistant: institutional licence from €5,000 one-time + €3,000/year. HELIOS core: Apache-2.0, free. [Full pricing](https://synapticfour.com/en/software).

→ [All questions and answers](docs/for-customers/faq.md)

---

## Next steps

| I want to… | →  |
|------------|-----|
| See results without installing anything | [demo/results/](demo/results/) |
| Run the demo locally | [DEMO.md](DEMO.md) |
| Understand which part of the stack fits my problem | [Which path fits me?](docs/for-customers/which-path.md) |
| Evaluate deeply as technical lead | [Technical Evaluation Kit](docs/for-evaluators/technical-evaluation-kit.md) |
| Talk directly | [contact@synapticfour.com](mailto:contact@synapticfour.com) |

---

## Why Synaptic Four and not a larger provider?

Because larger providers have a cloud business model that conflicts with your data sovereignty. We don't.

We're small enough that you speak with the developer — not with an account manager. And we have no financial incentive to lock you into a subscription you don't need.

What we're not: a team with a hundred reference customers and certified installations worldwide. We are precise about what we offer, and honest about what we're not yet.

→ [About us](https://synapticfour.com/en/about)

---

*Synaptic Four · Stuttgart, Germany · [synapticfour.com](https://synapticfour.com/en)*
