# Consent gate (W3) — PhenoFlow purpose → Solum before WES

[🇬🇧 English below](#english)

---

## Was das ist

Ein **technischer Purpose-Binding-Gate**: bevor der Showcase einen Ferrum-WES-Lauf startet, prüft er bei Solum, ob für `(subject, purpose)` Consent **granted** ist.

- Phenopacket-Zweckbindung als Showcase-Artefakt (PhenoFlow-Narrativ)
- Solum `POST /v1/consent/grant` + `GET /v1/consent/status`
- Bei **deny**: WES/HELIOS werden **nicht** gestartet

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

```bash
make consent-gate
make consent-gate-deny
SHOWCASE_ENABLE_CONSENT_GATE=1 make golden-path
SHOWCASE_ENABLE_CONSENT_GATE=1 SHOWCASE_CONSENT_GATE_MODE=deny make golden-path
```

See [IMPLEMENTATION-PLAN-EVIDENCE-CHAIN.md](../IMPLEMENTATION-PLAN-EVIDENCE-CHAIN.md).
