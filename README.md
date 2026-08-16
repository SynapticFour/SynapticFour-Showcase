# Synaptic Four — Showcase

**GA4GH-konforme Bioinformatik-Infrastruktur. On-Premise. Ohne Vendor Lock-in.**

[🌐 synapticfour.com](https://synapticfour.com/de) · [📬 contact@synapticfour.com](mailto:contact@synapticfour.com) · [🇬🇧 English below](#english)

---

## Was Sie hier sehen

Dieses Repository ist der **öffentliche Evidence-Pack / Outreach-Integrator** — **kein Produkt, kein SKU**. Skripte, Pins und Artefakte, mit denen Sie nachvollziehen können, wie die **vier Produkte** (Ferrum, ga4gh-infra, Solum, BioResearch Assistant) und die **freien Botschafter** (HelixTest, HELIOS) zusammenspielen. Lab-Kit und ferrum-meta kommen mit Ferrum, sie werden hier nicht verkauft.

Zwei getrennte Nachweis-Ebenen — bitte nicht vermischen:

| Ebene | Was sie ist | Was sie nicht ist |
|-------|-------------|-------------------|
| **Fixture-Spine** (`make integration-suite`) | Syntax, Unit-Tests, Honesty-Gates, committed JSON-Formen. Läuft in GitHub Actions **ohne Docker**. | Kein laufender Ferrum-/HELIOS-/Solum-Stack |
| **Live Golden Path** (`make up` / `make golden-path`) | Docker, Sibling-Checkouts **auf PINNED_VERSIONS.txt** (sonst `SHOWCASE_ALLOW_PIN_DRIFT=1`), echter Nextflow-WES + HELIOS | Nicht GitHub-hosted. `live-golden-path.yml` schlägt auf github-hosted fehl, außer `SHOWCASE_LIVE_SIBLINGS=1` |

Eingecheckte Dateien unter `demo/results/` und `demo/verification/` stammen aus Läufen **oder** sind als Fixtures gekennzeichnet. Der HELIOS-Beispielreport hasht Nextflow-Config/Log (nicht BAM) und **warnt** bei GATK `4.4.0.0` ohne Digest — maschinenlesbar in [helios-report-example.honesty.json](demo/results/helios-report-example.honesty.json) (signiertes JSON unverändert).

**Einstieg:** [docs/for-customers/start-here.md](docs/for-customers/start-here.md).

---

## Das Problem, das wir lösen

Ihr Institut arbeitet mit genomischen Daten. Sie haben:

- Anforderungen nach GA4GH-Interoperabilität (EHDS, MII, nationale Netzwerke)
- Daten die **nicht** in eine kommerzielle Cloud dürfen
- Pipelines die heute laufen — und die niemand neu schreiben will
- Compliance-Druck, der konkrete technische Nachweise verlangt, nicht Policy-Folien

Ferrum, ga4gh-infra, Solum und BioResearch Assistant sind **eigene Produkte** (verschiedene Käufer), komplementär über GA4GH — kein Bundle-SKU. HELIOS und HelixTest sind **freie Botschafter** (Apache), keine Kaufprodukte. Solum ist über [Solum-Demo](https://github.com/SynapticFour/Solum-Demo) lokal erlebbar. Evidence-Kette in diesem Repo: [DEMO.md](DEMO.md) und [Start here](docs/for-customers/start-here.md). Portfolio: [Ferrum PORTFOLIO.md](https://github.com/SynapticFour/Ferrum/blob/main/docs/PORTFOLIO.md).

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

**Heute im Showcase als Evidence-Pfad verdrahtet:** Ferrum-GA4GH-Demo → HELIOS · optional Solum-Stage · Consent-Gate · Evidence Pack · Passports-Harvest (soft) · BRA (M2) · gatk-rs/S4MP (soft). Das ist kein Produkt-Orchester und kein SKU.
**Als Nächstes (human / optional):** Kenya-Counsel (H4), named field site, Beacon-Tiefe, Showcase-CLI — siehe [Start here](docs/for-customers/start-here.md) und [DEMO.md](DEMO.md).

---

## Was passiert wenn alles zusammenläuft

[→ Vollständige Ergebnis-Beispiele ansehen](demo/results/)

Ein typischer Durchlauf erzeugt:

| Artefakt | Was es zeigt |
|----------|-------------|
| `benchmark.json` | Precision / Recall / F1 auf dem **synthetischen Demo-Callset** (15 Aug: F1=0, hap.py ohne Query-Calls — Pipeline-Smoke, keine klinische Güte) |
| `metrics.json` | WES-Run-ID, Engine, Laufzeit |
| `helios-report-example.json` | HELIOS-Export: Nextflow-Config/Log in `input_files`; `SEC-CONTAINER-001` **warn** bei GATK `4.4.0.0` ohne Digest. Default-Config: [helios.toml](helios.toml) (minimale Checks wegen GRCh37) |
| `showcase-report.md` | Menschenlesbare Zusammenfassung inkl. Honesty-Feld |
| `drs-link-example.json` | Illustrative DRS-URI (`ferrum-gateway:8080` = Compose-Hostname; Host-Gateway ist **:18080**) |

Sie können diese Dateien ohne Installation lesen. Ob ein Artefakt ein **Fixture** oder ein **Live-Lauf** ist, steht in der jeweiligen README.

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
Ferrum und Solum: BUSL-1.1 für zulässige nicht-kommerzielle Forschung; **Produktion** siehe [indicative pricing](docs/for-customers/pricing.md) (Ferrum-Knoten typisch €15–35k/Jahr, nicht „gratis"). BioResearch Assistant: Pilot (erster Kunde) kostenlos oder symbolisch; ab zweitem Kunden €3.500–4.000/Jahr plus Onboarding €2.500. HELIOS-Kern: Apache-2.0. Verbindlich ist nur ein schriftliches Angebot.

**„Wer steht dahinter?"**
Synaptic Four ist ein Founder-geführtes Unternehmen in Stuttgart (eine Person im Git dieses Repos). Spezialisiert auf Bioinformatik-Infrastruktur, mit Engagement für Neurodiversität. Keine VC-Finanzierung, kein Cloud-Zwangsmodell. Bus-Faktor 1 — das sagen wir, bevor Sie uns fragen.

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
| Als Technical Lead tief evaluieren | [Technical Evaluation Kit](docs/for-evaluators/technical-evaluation-kit.md) · [Evaluate HEAD](docs/for-evaluators/evaluate-at-head.md) |
| Direkt sprechen | [contact@synapticfour.com](mailto:contact@synapticfour.com) |

---

## Warum Synaptic Four und nicht ein größerer Anbieter?

Weil größere Anbieter ein Cloud-Geschäftsmodell haben, das im Widerspruch zu Ihrer Datensouveränität steht. Wir nicht.

Wir sind klein genug, dass Sie mit dem Entwickler sprechen — nicht mit einem Account Manager. Und wir haben keine finanziellen Anreize, Sie in ein Abo zu locken das Sie nicht brauchen.

Was wir nicht sind: ein Team mit hundert Referenzkunden und zertifizierten Installationen weltweit. Horizon-Checklisten in `docs/internal/` sind **Founder-Rehearsals** auf einer Entwicklermaschine, keine Kundenstandorte.

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

This repository is the **public integrator**: scripts, pins, and artefacts so you can see how Ferrum, HELIOS, optional Solum, and sibling products fit together.

Two evidence layers — do not mix them:

| Layer | What it is | What it is not |
|-------|------------|----------------|
| **Fixture spine** (`make integration-suite`) | Syntax, unit tests, honesty gates, committed JSON shapes. GitHub Actions runs this **without Docker**. | A running Ferrum / HELIOS / Solum stack |
| **Live golden path** (`make up` / `make golden-path`) | Docker, sibling checkouts **at PINNED_VERSIONS.txt** (or `SHOWCASE_ALLOW_PIN_DRIFT=1`), real Nextflow WES + HELIOS | Not GitHub-hosted. `live-golden-path.yml` fails on github-hosted unless `SHOWCASE_LIVE_SIBLINGS=1` |

Checked-in files under `demo/results/` and `demo/verification/` are from runs **or** labeled fixtures. The HELIOS example hashes Nextflow config/log (not BAM) and **warns** on GATK `4.4.0.0` without a digest — machine-readable in [helios-report-example.honesty.json](demo/results/helios-report-example.honesty.json) (signed JSON unmodified).

**Try it:** [docs/for-customers/start-here.md](docs/for-customers/start-here.md).

---

## The problem we solve

Your institution works with genomic data. You have:

- Requirements for GA4GH interoperability (EHDS, MII, national networks)
- Data that **must not** go to a commercial cloud
- Pipelines that run today — that nobody wants to rewrite
- Compliance pressure that demands concrete technical evidence, not policy slides

Ferrum, ga4gh-infra, Solum, and BioResearch Assistant are **separate products** (different buyers), complementary via GA4GH — not a bundle SKU. HELIOS and HelixTest are **free ambassadors** (Apache). Solum is runnable locally via [Solum-Demo](https://github.com/SynapticFour/Solum-Demo). Evidence chain in this repo: [DEMO.md](DEMO.md) and [Start here](docs/for-customers/start-here.md). Portfolio: [Ferrum PORTFOLIO.md](https://github.com/SynapticFour/Ferrum/blob/main/docs/PORTFOLIO.md).

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
| `benchmark.json` | Precision / Recall / F1 on the **synthetic demo callset** (15 Aug: F1=0, hap.py with no query calls — pipeline smoke, not clinical quality) |
| `metrics.json` | WES run ID, engine, elapsed time |
| `helios-report-example.json` | HELIOS export: Nextflow config/log in `input_files`; `SEC-CONTAINER-001` **warns** on GATK `4.4.0.0` without a digest. Default config: [helios.toml](helios.toml) |
| `showcase-report.md` | Human-readable summary including an honesty field |
| `drs-link-example.json` | Illustrative DRS URI (`ferrum-gateway:8080` is the Compose hostname; host gateway is **:18080**) |

You can read these files without installing anything. Whether an artefact is a **fixture** or a **live run** is stated in the local README.

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
Ferrum and Solum: BUSL-1.1 for permitted non-commercial research; **production** figures are in [indicative pricing](docs/for-customers/pricing.md) (Ferrum node typically €15–35k/year, not “free”). BioResearch Assistant: first-customer pilot free or symbolic; from the second customer €3,500–4,000/year plus €2,500 onboarding. HELIOS core: Apache-2.0. Only a written quote is binding.

**"Who is behind this?"**
Synaptic Four is founder-led in Stuttgart (one git author on this repo). Bioinformatics infrastructure, neurodiversity-aware. No VC, no forced-cloud business model. Bus factor 1 — we say that before you ask.

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
| Evaluate deeply as technical lead | [Technical Evaluation Kit](docs/for-evaluators/technical-evaluation-kit.md) · [Evaluate HEAD](docs/for-evaluators/evaluate-at-head.md) |
| Talk directly | [contact@synapticfour.com](mailto:contact@synapticfour.com) |

---

## Why Synaptic Four and not a larger provider?

Because larger providers have a cloud business model that conflicts with your data sovereignty. We don't.

We're small enough that you speak with the developer — not with an account manager. And we have no financial incentive to lock you into a subscription you don't need.

What we're not: a team with a hundred reference customers and certified installations worldwide. Horizon checklists under `docs/internal/` are **founder rehearsals** on a developer workstation, not named customer sites.

→ [About us](https://synapticfour.com/en/about)

---

**For genomDE and MII sites:** We are actively looking for a first
productive pilot at a DIC site or genomDE data node. Not a classical
software purchase — a genuine collaboration with transparent steps
and a verifiable result.
[Write directly →](mailto:contact@synapticfour.com?subject=Ferrum%20Pilot)

---

## License / Lizenz

Apache License 2.0 — see [LICENSE](LICENSE). Sibling products (Ferrum, Solum, BioResearch Assistant) remain under **BUSL-1.1** unless their own LICENSE says otherwise — see [NOTICE](NOTICE).

---

**Synaptic Four** · [contact@synapticfour.com](mailto:contact@synapticfour.com) · [synapticfour.com](https://synapticfour.com) · this repo Apache-2.0; Ferrum/Solum/BRA remain BUSL-1.1
