# H2 — Ops runbook (TLS, keys, backup rotation)

**Audience:** on-prem operators after H1
**Related:** Ferrum [customer-runbook](https://github.com/SynapticFour/Ferrum/blob/main/docs/customer-runbook.md) · Solum [DEPLOYMENT-RUNBOOK](https://github.com/SynapticFour/Solum/blob/main/docs/customer/DEPLOYMENT-RUNBOOK.md)

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

Quick check:

```bash
# Expect 401 when require_auth (H2):
curl -sS -o /dev/null -w '%{http_code}\n' http://localhost:8080/ga4gh/wes/v1/runs

# Expect 403 without collector visa:
curl -sS -o /dev/null -w '%{http_code}\n' -F 'file=@./sample.bin' \
  http://localhost:8080/api/v1/ingest/upload
```

---

## 3. Solum CustomerHeld key rotation

1. `solum crypto keygen --key-ref customer/… --out new.json` (0600)
2. Place under sidecar `--keys-dir`
3. Re-encrypt fields that must move to the new `key_ref` (application-driven)
4. Retire old key file offline; do **not** leave retired privkeys on the host

**AWS KMS:** library API only (`AwsKmsKeyProvider::wrap_seed` / `from_wrapped_seed`). CLI/sidecar KMS wiring is **not** in H2 spine v1. Prefer CustomerHeld files or wait for KMS CLI.

**Zeroize:** private seeds use `ZeroizeOnDrop` in process memory — best-effort, not HSM.

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

## 5. Observability (baseline)

- Gateway `/health` + reverse-proxy access logs
- Sidecar stdout/stderr + audit verify cron
- Full Prometheus/alert pack: deferred past H2 spine v1
