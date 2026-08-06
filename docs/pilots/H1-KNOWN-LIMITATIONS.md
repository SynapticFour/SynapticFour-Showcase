# H1 — Known limitations (pilot sign-off)

**Date:** 2026-08-06
**Companion:** [H1-EXECUTION-RECORD.md](H1-EXECUTION-RECORD.md) · [H1-PILOT-CHECKLIST.md](H1-PILOT-CHECKLIST.md)

These are acceptable for **H1 pilot-ready** claims. They are **not** production SoR / EHDS certification.

| Area | Limitation |
|------|------------|
| Host | Sign-off ran on a **dedicated H1 window** on Synaptic Four ops hardware (demos stopped; pilot-local stack exclusive). Not a separate cloud VM image — operators should still prefer a clean VM for customer sites. |
| Auth surface | `require_auth=true` + external JWKS (mock-idp / aai-broker). **Ingest** rejects unauthenticated calls (HTTP 403). Passport Bearer works for DRS `service-info`. **WES list/submit** still returned HTTP 200 without a Bearer in this build — treat WES auth enforcement as a Ferrum follow-up (H2), not as fully closed. |
| Passport visas | Mock-idp Passport authenticated DRS; **ingest with the same JWT still 403** (likely missing ingest/clearinghouse visas). Operators must issue pilot visas before customer data ingest. |
| TES | `FERRUM_TES_BACKEND=docker` — real containers. Scale / multi-tenant TES not in scope. |
| WES evidence | Auth-on stack: CWL `smoke-hello` → **COMPLETE**. HELIOS Grade A was taken on the Nextflow GIAB-subset work dir (HELIOS audits nextflow/snakemake only). |
| Solum | Stage-1 CustomerHeld sidecar only — **no** openEHR CDR (H3), no Kenya PRODUCTION profile (H4). |
| Keys | CustomerHeld files on disk (0600) — not HSM/KMS. |
| HelixTest | Optional Auth Level without `HELIXTEST_SKIP_AUTH` **not** run (checklist 1.7). |
| Postgres | Object-store (MinIO) restore drilled; Postgres volume backup procedure is the same `docker volume` tar pattern — not separately timed in this drill. |
| Claims | Do **not** claim EHDS/DSGVO/MDR compliance from Evidence Packs. |

## Operator backup procedure (short)

```bash
# MinIO (stop gateway briefly)
docker compose … stop ferrum-gateway
docker run --rm -v deploy_minio-data:/data -v "$PWD/backup":/backup alpine \
  tar czf /backup/minio-data.tar.gz -C /data .
docker compose … start ferrum-gateway

# Solum
cp audit.jsonl consent.jsonl "$BACKUP/"
# keys-dir offline only — not on the same media as plaintext clinical exports
```
