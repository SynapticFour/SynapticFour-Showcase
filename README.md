# Synaptic Four — Showcase

**GA4GH-konforme Bioinformatik-Infrastruktur. On-Premise. Ohne Vendor Lock-in.**

[🌐 synapticfour.com](https://synapticfour.com/de) · [📬 contact@synapticfour.com](mailto:contact@synapticfour.com) · [🇬🇧 English below](#english)

---

## Was Sie hier sehen

Dieses Repository zeigt, wie die Kernbausteine von Synaptic Four **in einer echten, durchgängigen Pipeline zusammenspielen** — von der Daten-API bis zum signierten Audit-Report. Kein Marketing-Deck. Kein Versprechen. Echte Artefakte aus echten Läufen.

Wenn Sie evaluieren möchten ob diese Infrastruktur zu Ihrer Institution passt, sind Sie hier richtig.

**Einstieg in vier Schritten:** [docs/for-customers/start-here.md](docs/for-customers/start-here.md) (Fixtures → Golden Path → Passports → Solum).

---

## Das Problem, das wir lösen

Ihr Institut arbeitet mit genomischen Daten. Sie haben:

- Anforderungen nach GA4GH-Interoperabilität (EHDS, MII, nationale Netzwerke)
- Daten die **nicht** in eine kommerzielle Cloud dürfen
- Pipelines die heute laufen — und die niemand neu schreiben will
- Compliance-Druck, der konkrete technische Nachweise verlangt, nicht Policy-Folien

Ferrum, HELIOS, BioResearch Assistant und Solum sind Bausteine die diesen Knoten lösen — einzeln einsetzbar, zusammen stärker. Die durchgängige Evidenz-Kette (Genomic + Audit + Research AI + Clinical) ist der Zielzustand dieses Showcase; Solum ist über [Solum-Demo](https://github.com/SynapticFour/Solum-Demo) lokal erlebbar (Stage-1 Authz/Audit/Consent + optionales Track-B-Overlay, `make smoke-all`) — orchestrierte Integration: [DEMO.md](DEMO.md) und [Start here](docs/for-customers/start-here.md).

---

## Einordnung im deutschen Ökosystem

Ferrum ist komplementär zu bestehenden nationalen Infrastrukturen —
kein Ersatz, sondern die lokale Schicht die davor fehlt.

| Infrastruktur | Rolle | Ferrum-Verhältnis |
|---------------|-------|-------------------|
| GHGA | Nationales Genomdaten-Archiv | Ferrum ist die lokale GA4GH-Schicht vor der Übermittlung zu GHGA. Crypt4GH und DRS sind kompatibel. |
| FDPG / MII | Klinische Routinedaten, FHIR-basiert | Ferrum ergänzt mit GA4GH-Workflow-Execution und Genomik-Infrastruktur. MII Connect für FHIR-Profilprüfung. |
| genomDE Datenknoten | Dezentrale Sequenzierungsdaten | Ferrum ist für genau diesen Use Case gebaut: on-premise, GA4GH-konform, ohne Cloud-Zwischenschritt. |
| ELIXIR / de.NBI | Europäische Forschungsinfrastruktur | GA4GH-Schnittstellen ermöglichen Interoperabilität ohne Datentransfer. |

Wenn Sie bereits Teil dieser Ökosysteme sind: Ferrum fügt sich ein,
es ersetzt nicht.

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

### 🏥 Solum — Klinische Compliance-Schicht (Companion)

Solum adressiert fail-closed Autorisierung, Jurisdiction-Profile und tamper-evident Audit für klinische Daten (FHIR/openEHR, EHDS-orientiert) — als **eigenes Produkt und regulatorischer Perimeter**, nicht als Ferrum-Modul. Crypt4GH- und Evidenz-Ideen teilen die Philosophie mit Ferrum/HELIOS; der Code bleibt getrennt.

**Was das für Sie bedeutet:** Genomic Plane (Ferrum) und Clinical Plane (Solum) können dieselbe Souveränitätsgeschichte erzählen, ohne Compliance-Grenzen zu vermischen.

→ [Solum auf GitHub](https://github.com/SynapticFour/Solum) · [Solum-Demo (lokal)](https://github.com/SynapticFour/Solum-Demo) · [Produktseite](https://synapticfour.com/de/solum)

### 🪪 ga4gh-infra — Identity plane (Passports / Broker)

Die Identity-Schicht (OIDC-Broker, Passports/Visas, ADS) liegt in [ga4gh-infra](https://github.com/SynapticFour/ga4gh-infra). Der **Standard-Showcase-Golden-Path** läuft bewusst open-auth (schnell evaluierbar). Co-Deploy mit Passports: Sibling [Ferrum-GA4GH-Demo](https://github.com/SynapticFour/Ferrum-GA4GH-Demo) `./run --with-infra` · danach `make co-deploy-harvest` · [COVERAGE](https://github.com/SynapticFour/Ferrum-GA4GH-Demo/blob/main/docs/COVERAGE.md) · [Start here](docs/for-customers/start-here.md).

**Heute im Showcase orchestriert:** Ferrum-GA4GH-Demo → HELIOS · optional Solum-Stage · Consent-Gate · Evidence Pack · Passports-Harvest (soft) · BRA (M2) · gatk-rs/S4MP (soft) · Path E+.
**Als Nächstes (human / optional):** Kenya-Counsel (H4), named field site, Beacon-Tiefe, Showcase-CLI — siehe [Start here](docs/for-customers/start-here.md) und [DEMO.md](DEMO.md).

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
Ja. Ferrum, HELIOS, BioResearch Assistant und Solum sind unabhängig deploybar. Die meisten Institutionen starten mit einem Baustein.

**„Wie schnell kann ein erster Proof-of-Value stehen?"**
Realistisch: 10–30 Tage, abhängig von Ihrer Infrastruktur und Daten-Readiness. Wir benennen das transparent.

**„Ist das ‚zertifiziert compliant'?"**
Nein. Wir sagen das offen: Ferrum und HELIOS erzeugen technische Evidenz-Artefakte, die Compliance-Prozesse unterstützen. Die formale Compliance-Verantwortung liegt beim Betreiber. [Details dazu](docs/for-customers/compliance-framing.md).

**„Was kostet das?"**
Ferrum: BUSL-1.1 (für zulässige nicht-kommerzielle Forschung kostenfrei nutzbar, nach 4 Jahren Apache-2.0). BioResearch Assistant: Pilot (erster Kunde) kostenlos oder symbolisch. Ab zweitem Kunden: €3.500–4.000/Jahr all-in. Onboarding: €2.500 einmalig. HELIOS-Kern: Apache-2.0, kostenfrei. [Vollständige Preisinformation](https://synapticfour.com/de/software).

**„Wer steht dahinter?"**
Ein kleines Team aus Stuttgart, spezialisiert auf Bioinformatik-Infrastruktur, mit gelebtem Engagement für Neurodiversität und Inklusion. Keine VC-Finanzierung, kein Cloud-Abhängigkeits-Geschäftsmodell.

→ [Alle Fragen und Antworten](docs/for-customers/faq.md)

---

## Wie Sie als nächstes vorgehen

| Ich möchte… | →  |
|-------------|-----|
| Überblick: Angebote, Komponenten, getestete Konstellationen | [Kunden-Übersicht](docs/for-customers/overview.md) |
| Claims lokal nachprüfen (Fixture-Suite + Repo-Evidenz) | [Integration verification](docs/for-customers/integration-verification.md) · [`demo/verification/`](demo/verification/) |
| Ergebnisse sehen, ohne etwas zu installieren | [demo/results/](demo/results/) · [demo/verification/](demo/verification/) |
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

**Für genomDE und MII-Standorte:** Wir suchen aktiv einen ersten
produktiven Piloten an einem DIZ-Standort oder genomDE-Datenknoten.
Kein klassischer Software-Kauf — eine echte Zusammenarbeit mit
transparenten Schritten und einem prüfbaren Ergebnis.
[Direkt schreiben →](mailto:contact@synapticfour.com?subject=Ferrum%20Pilot)

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

**Try it in four steps:** [docs/for-customers/start-here.md](docs/for-customers/start-here.md) (fixtures → golden path → Passports → Solum).

---

## The problem we solve

Your institution works with genomic data. You have:

- Requirements for GA4GH interoperability (EHDS, MII, national networks)
- Data that **must not** go to a commercial cloud
- Pipelines that run today — that nobody wants to rewrite
- Compliance pressure that demands concrete technical evidence, not policy slides

Ferrum, HELIOS, BioResearch Assistant, and Solum are building blocks that untangle this. Deployable individually. Stronger together. The end-to-end evidence chain (genomic + audit + research AI + clinical) is this Showcase’s target; Solum is runnable via [Solum-Demo](https://github.com/SynapticFour/Solum-Demo) (Stage-1 authz/audit/consent + optional Track B overlay, `make smoke-all`) — orchestrated integration: [DEMO.md](DEMO.md) and [Start here](docs/for-customers/start-here.md).

---

## Positioning within the German ecosystem

Ferrum is complementary to existing national infrastructures —
not a replacement, but the local layer that precedes them.

| Infrastructure | Role | Ferrum relationship |
|----------------|------|---------------------|
| GHGA | National genomic data archive | Ferrum is the local GA4GH layer before submission to GHGA. Crypt4GH and DRS are compatible. |
| FDPG / MII | Clinical routine data, FHIR-based | Ferrum adds GA4GH workflow execution and genomics infrastructure. MII Connect for FHIR profile checks. |
| genomDE data nodes | Decentralised sequencing data | Ferrum is built exactly for this use case: on-premise, GA4GH-compliant, no cloud intermediary. |
| ELIXIR / de.NBI | European research infrastructure | GA4GH interfaces enable interoperability without data transfer. |

If you are already part of these ecosystems: Ferrum fits in,
it does not replace.

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

### 🏥 Solum — Clinical compliance layer (companion)

Solum covers fail-closed authorization, jurisdiction profiles, and tamper-evident audit for clinical data (FHIR/openEHR, EHDS-oriented) — as a **separate product and regulatory perimeter**, not a Ferrum module. It shares sovereignty philosophy with Ferrum/HELIOS; codebases stay separate.

**What this means for you:** Genomic plane (Ferrum) and clinical plane (Solum) can tell one sovereignty story without mixing compliance boundaries.

→ [Solum on GitHub](https://github.com/SynapticFour/Solum) · [Solum-Demo (local)](https://github.com/SynapticFour/Solum-Demo) · [Product page](https://synapticfour.com/en/solum)

### 🪪 ga4gh-infra — Identity plane (Passports / broker)

The identity layer (OIDC broker, Passports/visas, ADS) lives in [ga4gh-infra](https://github.com/SynapticFour/ga4gh-infra). The **default Showcase golden path** stays open-auth (fast to evaluate). Co-deploy with Passports: sibling [Ferrum-GA4GH-Demo](https://github.com/SynapticFour/Ferrum-GA4GH-Demo) `./run --with-infra` · then `make co-deploy-harvest` · [COVERAGE](https://github.com/SynapticFour/Ferrum-GA4GH-Demo/blob/main/docs/COVERAGE.md) · [Start here](docs/for-customers/start-here.md).

**Orchestrated in Showcase today:** Ferrum-GA4GH-Demo → HELIOS · optional Solum stage · consent gate · Evidence Pack · Passports harvest (soft) · BRA (M2) · gatk-rs/S4MP (soft) · Path E+.
**Next (human / optional):** Kenya counsel (H4), named field site, Beacon depth, Showcase CLI — see [Start here](docs/for-customers/start-here.md) and [DEMO.md](DEMO.md).

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
Yes. Ferrum, HELIOS, BioResearch Assistant, and Solum are independently deployable. Most institutions start with one building block.

**"How quickly can a first proof-of-value be set up?"**
Realistically: 10–30 days, depending on your infrastructure and data readiness. We state this transparently.

**"Is this 'certified compliant'?"**
No. We say this openly: Ferrum and HELIOS generate technical evidence artefacts that support compliance processes. Formal compliance responsibility rests with the operator. [Details here](docs/for-customers/compliance-framing.md).

**"What does it cost?"**
Ferrum: BUSL-1.1 (free for permitted non-commercial research, Apache-2.0 after 4 years). BioResearch Assistant: pilot (first customer) free or symbolic. From second customer: €3,500–4,000/year all-in. Onboarding: €2,500 one-time. HELIOS core: Apache-2.0, free. [Full pricing](https://synapticfour.com/en/software).

→ [All questions and answers](docs/for-customers/faq.md)

---

## Next steps

| I want to… | →  |
|------------|-----|
| See offerings, components, tested constellations | [Customer overview](docs/for-customers/overview.md) |
| Re-run our claims locally (fixture suite + repo evidence) | [Integration verification](docs/for-customers/integration-verification.md) · [`demo/verification/`](demo/verification/) |
| See results without installing anything | [demo/results/](demo/results/) · [demo/verification/](demo/verification/) |
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

**For genomDE and MII sites:** We are actively looking for a first
productive pilot at a DIC site or genomDE data node. Not a classical
software purchase — a genuine collaboration with transparent steps
and a verifiable result.
[Write directly →](mailto:contact@synapticfour.com?subject=Ferrum%20Pilot)

---

## License / Lizenz

Apache License 2.0 — see [LICENSE](LICENSE).

---

*Synaptic Four · Stuttgart, Germany · [synapticfour.com](https://synapticfour.com/en)*
