# H2 — Ops runbook (TLS, keys, backup rotation, H2.3 polish)

**Audience:** on-prem operators after H1
**Related:** Ferrum [customer-runbook](https://github.com/SynapticFour/Ferrum/blob/main/docs/customer-runbook.md) · Solum [DEPLOYMENT-RUNBOOK](https://github.com/SynapticFour/Solum/blob/main/docs/customer/DEPLOYMENT-RUNBOOK.md)
**Second pass (KMS / full metrics / HELIOS):** [H2-SECOND-PASS.md](H2-SECOND-PASS.md)

---

## 1. TLS

Terminate TLS at the reverse proxy (nginx/Caddy/Traefik). Ferrum ships examples under `Ferrum/deploy/reverse-proxy/`.

- Public: UI + gateway HTTPS only
- Internal: aai-broker / ADS / postgres / minio on Docker network
- Rotate proxy certs per site policy (Let’s Encrypt or enterprise PKI)

---

## 2. Identity / visas

| Need | How |
|------|-----|
| Pilot auth | `require_auth=true` + JWKS to ga4gh-infra / IdP |
| WES / DRS with Bearer | Passport or JWT from broker login |
| **Ingest** | Passport must include AffiliationAndRole / scope **`ferrum:collector`** (or admin). Mock-idp default tokens do **not** include it — use Edge local accounts (`ferrum auth account`) or IdP visa issuance. See Ferrum [INSTALLATION.md](https://github.com/SynapticFour/Ferrum/blob/main/docs/INSTALLATION.md) visa table. |

Quick check (auth surface):

```bash
# Expect 401 when require_auth (H2):
curl -sS -o /dev/null -w '%{http_code}\n' http://localhost:8080/ga4gh/wes/v1/runs

# Expect 403 without collector visa:
curl -sS -o /dev/null -w '%{http_code}\n' -F 'file=@./sample.bin' \
  http://localhost:8080/api/v1/ingest/upload
```

### 2.1 Collector visa demo path (H2.3)

Mock-idp Passports are enough for WES/DRS demos; **ingest** needs a collector (or admin) visa. Two operator paths:

**A — Edge local account (shared device / no broker UI)**

Requires `auth.jwt_secret` (or equivalent) in Ferrum config. See [FIELD-AUTH-OFFLINE.md](https://github.com/SynapticFour/Ferrum/blob/main/docs/FIELD-AUTH-OFFLINE.md).

```bash
ferrum auth account add --username alice --role collector --pin '****'
TOKEN=$(ferrum auth login --username alice --pin '****')   # capture Bearer

# Ingest must succeed with collector; plain Passport without visa stays 403
curl -sS -o /dev/null -w '%{http_code}\n' \
  -H "Authorization: Bearer $TOKEN" \
  -F 'file=@./sample.bin' \
  http://localhost:8080/api/v1/ingest/upload
```

**B — ga4gh-infra / IdP**

Issue a Passport visa / scope `ferrum:collector` (or admin) for the operator account; log in via broker; use that Bearer on ingest. Do not expect default mock-idp tokens to gain collector.

**Honesty:** Demonstrating path A or B on a site closes the *operator how-to* gap. It does not change mock-idp defaults.

---

## 3. Solum CustomerHeld key rotation

1. `solum crypto keygen --key-ref customer/… --out new.json` (0600)
2. Place under sidecar `--keys-dir`
3. Re-encrypt fields that must move to the new `key_ref` (application-driven)
4. Retire old key file offline; do **not** leave retired privkeys on the host

**AWS KMS:** library API only (`AwsKmsKeyProvider::wrap_seed` / `from_wrapped_seed`). CLI/sidecar KMS wiring is **second pass** — see [H2-SECOND-PASS.md](H2-SECOND-PASS.md) §A. Prefer CustomerHeld files until then.

**Zeroize:** private seeds use `ZeroizeOnDrop` in process memory — best-effort, not HSM.

**Org-IAM (H2.2):** when sidecar runs with `--org-iam-config` + JWKS, mutating CAP_* come from JWT groups; body `capability[]` is ignored. Status stays token-only.

---

## 4. Backup rotation

| Store | Cadence (suggested) | Method |
|-------|---------------------|--------|
| MinIO (`deploy_minio-data`) | Daily + weekly offline | `docker run … tar czf minio-data.tar.gz` (stop gateway briefly) |
| Postgres (`deploy_pgdata`) | Daily | Volume tar or `pg_dump` |
| Solum `audit.jsonl` + `consent.jsonl` | Continuous copy / hourly | File copy; verify chain after restore |
| Solum keys-dir | Offline only | Never on same media as bulk clinical export |
| Ferrum Crypt4GH node keys | On rotation event | `crypt4gh-keys` volume; document seal |

Retain ≥ 3 generations; test restore quarterly (H1 drilled MinIO + Solum once).

---

## 5. Thin metrics / health (H2.3)

**Baseline (ship now — curl / cron, not full Prometheus):**

| Check | Expect | Action if bad |
|-------|--------|---------------|
| `GET http://<gateway>:8080/health` | **200**; note `status` / `clock` / `disk` if present | Restart gateway; fix NTP if `clock` degraded; free disk |
| `GET http://<gateway>:8080/ready` (if exposed) | **200** | Do not route traffic until ready |
| Sidecar up + token | `GET /v1/consent/status?subject=…&purpose=…` with `X-Solum-Sidecar-Token` → **200** (status may be `unknown`) | Restart sidecar; check token / listen bind |
| Proxy access logs | 5xx rate low | Inspect gateway + upstream |
| Solum audit verify | Site cron on `audit.jsonl` chain | Restore from last good backup |

Example cron-friendly smoke:

```bash
set -euo pipefail
GW="${FERRUM_GATEWAY:-http://127.0.0.1:8080}"
curl -sfS "$GW/health" >/dev/null
# Optional Solum (set SOLUM_SIDECAR + SOLUM_TOKEN):
if [[ -n "${SOLUM_SIDECAR:-}" && -n "${SOLUM_TOKEN:-}" ]]; then
  curl -sfS -H "X-Solum-Sidecar-Token: $SOLUM_TOKEN" \
    "$SOLUM_SIDECAR/v1/consent/status?subject=healthcheck&purpose=care_provision" >/dev/null
fi
```

**Full Prometheus / alert pack:** deferred to second pass ([H2-SECOND-PASS.md](H2-SECOND-PASS.md) §B). Do not claim SRE-grade observability from health curls alone.
