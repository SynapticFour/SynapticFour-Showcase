# Evidence Pack — what it proves (and what it does not)

[🇬🇧 English below](#english)

> Evidence Packs and HELIOS reports are **technical artefacts**, not certificates. Do not describe them as certification, accreditation, or a legal determination.

---

## Kurz

Das **Evidence Pack** ist ein Ordner mit technischen Artefakten aus einem Showcase-Lauf (oder aus Fixtures): HELIOS-Report, DRS-Checksummen, optional HelixTest-Scores, optional Solum Stage-1, optional Consent-Gate, optional gatk-rs-Smoke / S4MP-Sidecar, optional **ga4gh-infra / Passports Co-Deploy**. Dazu `MANIFEST.json` mit SHA-256 jeder Datei und eine `README.md` für Stakeholder.

```bash
# Ohne Installation / CI:
./scripts/evidence-pack.sh --fixtures

# Nach golden path (nutzt helios-reports/ + Demo-Results):
./scripts/evidence-pack.sh

# Optional: Passports-Artefakt aus Demo ernten, dann packen:
make co-deploy-harvest
./scripts/evidence-pack.sh

# Optional live HelixTest (Gateway :18080 muss laufen):
SHOWCASE_RUN_HELIXTEST=1 ./scripts/evidence-pack.sh
```

Ausgabe: `artifacts/evidence-pack-<id>/` (Symlink `artifacts/evidence-pack-latest` wenn möglich).

Einstiegskarte: [start-here.md](start-here.md)

---

## Was das Pack beweist (technisch)

- Ein HELIOS-Audit-Artefakt ist vorhanden (Checks, ggf. Output-Hashes)
- DRS-Objektmetadaten inkl. deklarierter Checksummen (wenn mitgeliefert)
- Optional: HelixTest-Conformance-JSON
- Optional: Solum Stage-1 (fail-closed Authz + Tamper-Detect)
- Optional: ga4gh-infra Co-Deploy / Passports (`co_deploy_results.json`, Rolle `ga4gh_infra_co_deploy`)
- Integrität der Dateien **innerhalb** des Packs über SHA-256 in `MANIFEST.json`

## Was das Pack **nicht** beweist

- Formale Zertifizierung oder EHDS-/DSGVO-„Compliance“
- Gleichheit mit Ihrer Produktionsumgebung
- Rechtliche Wirksamkeit von Consent (Solum-Demos sind rein technisch)
- Produktions-IdP / AAI (Demo-Broker + Passports ≠ Kunden-IAM)
- Dauerhafte Überwachung nach Erzeugung des Packs

→ Ausführlicher Kontext: [compliance-framing.md](compliance-framing.md)

---

## Für Evaluatoren

- HelixTest-Live-Gate: [../for-evaluators/helixtest-gate.md](../for-evaluators/helixtest-gate.md)
- Try map: [start-here.md](start-here.md)

---

<a name="english"></a>

# Evidence Pack — what it proves (and does not)

## Short version

The **Evidence Pack** is a directory of technical artefacts from a Showcase run (or fixtures): HELIOS report, DRS checksums, optional HelixTest scores, optional Solum Stage-1, optional ga4gh-infra / Passports co-deploy — plus `MANIFEST.json` (SHA-256 of each file) and a stakeholder `README.md`.

```bash
./scripts/evidence-pack.sh --fixtures
make co-deploy-harvest && ./scripts/evidence-pack.sh
SHOWCASE_RUN_HELIXTEST=1 ./scripts/evidence-pack.sh
```

Output: `artifacts/evidence-pack-<id>/`.

Start map: [start-here.md](start-here.md)

## What it proves (technical)

- A HELIOS audit artefact is present (checks, optional output hashes)
- DRS object metadata with declared checksums (when included)
- Optional HelixTest conformance JSON
- Optional Solum Stage-1 (fail-closed authz + tamper detect)
- Optional ga4gh-infra / Passports co-deploy (`role: ga4gh_infra_co_deploy`)
- Integrity of files **inside** the pack via SHA-256 in `MANIFEST.json`

## What it does **not** prove

- Formal certification or EHDS/GDPR “compliance”
- Equivalence with your production environment
- Legal validity of consent (Solum demos are technical only)
- Production IdP / AAI equivalence (demo broker + Passports only)
- Continuous monitoring after the pack was generated

→ See [compliance-framing.md](compliance-framing.md)

---

*Synaptic Four · Stuttgart · contact@synapticfour.com*
