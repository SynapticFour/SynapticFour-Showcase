# H1 restore drill — extended (hub Postgres path)

**Status:** Procedure pack + operator execution log
**Date opened:** 2026-08-12 · org level-up **D2**
**Extends:** [H1-KNOWN-LIMITATIONS.md](H1-KNOWN-LIMITATIONS.md). The H1 execution record is not published in this repository.

---

## Prior H1 result (already signed)

| Item | Result (2026-08-06) |
|------|---------------------|
| MinIO marker backup/restore | OK |
| Solum consent/audit restore | OK |
| Elapsed (MinIO + Solum) | **9s** |
| Hub Postgres separately timed | **Not done** (limitation) |

---

## Goal of this extension

Time a **hub Postgres** logical dump → wipe → restore cycle for Ferrum metadata DB (or Demo compose Postgres), documenting commands and elapsed time so H1-KNOWN-LIMITATIONS can be closed for future pilots.

---

## Procedure (Demo / Lab compose with Postgres)

Adjust service/db names to your compose file (`postgres`, `ferrum-db`, etc.).

```bash
# 0) Preflight — stack healthy
curl -sf http://127.0.0.1:8080/health

# 1) Marker row / note current WES or DRS count (site-specific)
# 2) Logical dump
docker compose exec -T postgres \
  pg_dump -U ferrum -Fc ferrum > "ferrum-pg-$(date -u +%Y%m%dT%H%M%SZ).dump"

# 3) Stop writers (gateway / WES)
docker compose stop ferrum-gateway   # names vary

# 4) Restore into empty DB (destructive — use disposable volume)
docker compose exec -T postgres \
  pg_restore -U ferrum -d ferrum --clean --if-exists < ferrum-pg-….dump

# 5) Start gateway; smoke /health + one authenticated DRS list
# 6) Record wall-clock from step 2 start → step 5 smoke OK
```

Also verify object-store still matches DB IDs (MinIO/S3). Orphan objects after partial restore are an ops finding — document them.

---

## Execution log

| Field | Value |
|-------|-------|
| Operator | |
| Host | |
| Date (UTC) | |
| Compose / pins | |
| Dump size | |
| Elapsed (dump→smoke) | |
| Smoke results | |
| Issues | |

### 2026-08-12 — procedure authored

| Field | Value |
|-------|-------|
| Operator | Synaptic Four eng (Cursor-assisted) |
| Status | **Procedure pack published**; live hub Postgres timing deferred to next dedicated ops window with a disposable Demo stack (avoids destroying developer volumes mid-level-up). |
| Prior evidence retained | H1 MinIO+Solum **9s** (2026-08-06) |
| Next action | Run table above on disposable compose; paste elapsed into this log; then update H1-KNOWN-LIMITATIONS. |

---

## Exit criteria

- [x] Written Postgres restore procedure linked from customer [disaster-recovery.md](../for-customers/disaster-recovery.md)
- [ ] Live timed drill on disposable hub stack
- [ ] H1-KNOWN-LIMITATIONS updated with Postgres elapsed time
