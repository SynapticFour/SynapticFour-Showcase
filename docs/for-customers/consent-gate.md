# Consent gate (W3) — PhenoFlow purpose → Solum before WES

[🇬🇧 English below](#english)

---

## Was das ist

Ein **technischer Purpose-Binding-Gate**: bevor der Showcase einen Ferrum-WES-Lauf startet, prüft er bei Solum, ob für `(subject, purpose)` Consent **granted** ist.

- Phenopacket-Zweckbindung als Showcase-Artefakt (PhenoFlow-Narrativ)
- Solum `POST /v1/consent/grant` + `GET /v1/consent/status`
- Bei **deny**: WES/HELIOS werden **nicht** gestartet (Orchestrator)

**H2.1:** Wenn Ferrum mit `FERRUM_SOLUM__*` konfiguriert ist, erzwingt Ferrum selbst Deny auf gebundenen DRS/WES-Aufrufen (HTTP **403**) — siehe [ADR 0001](../adr/0001-solum-ferrum-consent-access.md) und `make h21-teeth`. Der Consent-Gate bleibt Defence-in-Depth.

**Das ist kein rechtliches Consent und kein Ersatz für institutionelle Einwilligungsverfahren.**

---

## Befehle

```bash
make consent-gate              # allow: grant → status=granted
make consent-gate-deny         # deny: kein Grant / revoke → WES blockiert
make consent-gate-fixtures     # CI / ohne Docker

# Im Golden Path:
SHOWCASE_ENABLE_CONSENT_GATE=1 make golden-path
SHOWCASE_ENABLE_CONSENT_GATE=1 SHOWCASE_CONSENT_GATE_MODE=deny make golden-path
```

Artefakte: `artifacts/consent-gate/consent-gate-result.json`
Beispiele: `demo/results/consent-gate-*-example.json`

---

## Default purpose

| Feld | Default |
|------|---------|
| subject | `patient/showcase-phenoflow-001` |
| purpose | `secondary_use_hdab` (must be in Solum jurisdiction `required_purposes`) |

Optional BRA: `SHOWCASE_CONSENT_TRY_BRA=1` versucht `POST /api/v1/phenopackets` wenn BRA erreichbar ist (Gate braucht BRA **nicht**).

---

<a name="english"></a>

# Consent gate (W3) — PhenoFlow purpose → Solum before WES

Technical purpose-binding only — **not legal consent**.

Orchestrator gate: grant/status before starting WES. **H2.1:** when Ferrum has `FERRUM_SOLUM__*` set, Ferrum itself returns **403** on bound DRS/WES after revoke (`make h21-teeth`, [ADR 0001](../adr/0001-solum-ferrum-consent-access.md)).

```bash
make consent-gate
make consent-gate-deny
make h21-teeth
SHOWCASE_ENABLE_CONSENT_GATE=1 make golden-path
SHOWCASE_ENABLE_CONSENT_GATE=1 SHOWCASE_CONSENT_GATE_MODE=deny make golden-path
```

See [start-here.md](start-here.md).
