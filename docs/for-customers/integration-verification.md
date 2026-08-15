# Integration verification — re-run what we claim

[🇬🇧 English below](#english)

---

## Zweck

Dieses Dokument beschreibt die **Integrations- / Claim-Verifikations-Suite** im Showcase:

1. What we tested (constellations) — **fixture spine vs live golden path are separate**
2. Welche Evidenz im Repo liegt (`demo/verification/`, `demo/results/`)
3. Wie Sie **dieselben Tests lokal** wiederholen

Es ist bewusst **rigoros und ehrlich**: Soft-Fails und Skips bei Alpha-Komponenten (gatk-rs, S4MP) sind erwartbar und werden protokolliert — kein „grün um jeden Preis“.

---

## Schnellstart

```bash
# 1) Ohne Docker — CI-äquivalent, Minuten
./scripts/run-integration-suite.sh --fixtures --publish-verification

# 2) Live-Opt-ins (Docker / Sibling-Checkouts; soft-fail wo nötig)
./scripts/run-integration-suite.sh --live

# 3) Voller genomischer Golden Path (lang, 10–20+ Min Erstlauf)
./scripts/run-integration-suite.sh --live golden-path
# oder: make golden-path
```

Make-Aliase: `make integration-suite` · `make integration-suite-fixtures` · `make verification-publish`.

---

## Suite-Modi

| Modus | Docker? | Hard-Fail | Soft-Fail |
|-------|---------|-----------|-----------|
| `--fixtures` | Nein | Script-Syntax, Unit-Tests, Honesty-Gates, Pack-Rollen | — |
| `--live` (Default-Stufen) | Teilweise | Nur wenn Stage hard und fehlschlägt | gatk-rs, S4MP, gatk-rs-wes, Solum/Consent wenn Stack fehlt |
| `--live golden-path` | Ja, schwer | Demo + HELIOS | W4-Stufen weiterhin soft im Golden Path |

Ausgabe: `artifacts/integration-suite/SUITE-MANIFEST.json` (Pins, Stages, Honesty).

---

## Konstellationen (Claims → Test)

| Claim (kurz) | Test | Erwartetes Ergebnis |
|--------------|------|---------------------|
| Showcase pins vs sibling HEAD | `make check-pins` / `checkout-pins.sh` | `make up` requires Ferrum + HELIOS pins unless `SHOWCASE_ALLOW_PIN_DRIFT=1` |
| HELIOS after Nextflow WES | Golden path (live) / fixtures (shape only) | Live: report on disk. Fixture: `SEC-CONTAINER-001` only; empty inputs documented |
| Solum fail-closed Authz + Tamper | `make solum-stage` / fixtures | allow 200 / deny 403 / chain_broken |
| Consent-Gate kann WES blockieren | allow vs deny | deny → `wes_may_proceed=false` |
| Evidence Pack ist reviewbar | `evidence-pack --fixtures` | MANIFEST + README, keine Zertifikatsprache |
| gatk-rs läuft als Smoke | `gatk-rs-smoke` | ok / skipped / failed (soft) |
| S4MP als Sidecar, nicht Executor | `s4mp-evidence` | Hash im Pack; kein WES |
| Optional gatk-rs unter Ferrum WES | `run-gatk-rs-wes.sh` / Demo `--gatk-rs` | Soft-skip ohne Image; Alpha |

---

## Evidenz im Repository

| Pfad | Inhalt |
|------|--------|
| [`demo/verification/`](../../demo/verification/) | Eingefrorenes Fixture-Evidence-Pack + `SUITE-MANIFEST.json` |
| [`demo/results/`](../../demo/results/) | Stakeholder-Beispiele je Stage |
| [`fixtures/ci/`](../../fixtures/ci/) | CI-Quellen für Fixture-Mode |

Nach einem Live-Lauf: `artifacts/` (gitignored) + optional erneut `--publish-verification` nur für Fixture-Pack.

---

## Ehrlichkeit

- Fixture-Pack **≠** Ihr Produktions-Deployment
- Solum-Artefakte **≠** rechtliche Einwilligung
- gatk-rs **≠** Broad-GATK-Äquivalenz / Klinik
- S4MP-Diff **≠** Zertifizierung
- Soft-skip bei fehlendem Docker-Image ist **kein** Ferrum-Produktfehler

Siehe [overview.md](overview.md), [evidence-pack.md](evidence-pack.md), [gatk-rs-s4mp.md](gatk-rs-s4mp.md), [compliance-framing.md](compliance-framing.md).

---

<a id="english"></a>

## English

The Showcase **integration suite** lets anyone re-run the same technical checks we use to stress our claims:

```bash
./scripts/run-integration-suite.sh --fixtures --publish-verification
./scripts/run-integration-suite.sh --live
./scripts/run-integration-suite.sh --live golden-path   # long
```

Published evidence: `demo/verification/`. Per-stage examples: `demo/results/`.
Soft-fail for Alpha gatk-rs / S4MP is intentional. This is not a certificate.
