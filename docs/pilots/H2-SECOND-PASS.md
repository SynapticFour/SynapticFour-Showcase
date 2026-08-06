# H2 — Second pass (unblock remaining exit items)

**Purpose:** Single backlog so a later eng pass can close full roadmap H2 without rediscovering scope.
**Status:** Documented 2026-08-06 — **not** started as implementation.
**Depends on:** H2 spine v1 + H2.1 Teeth + H2.2 Org CAP + **H2.3 Ops polish** (docs).
**Not this pass:** H3 CDR coding, Kenya PRODUCTION flip (H4 / counsel), SaaS (H5).

Nothing here is blocked by an external gate except where noted. Items are **deferred by priority**.

---

## Order of attack (recommended)

| # | Workstream | Owner | Unblocks | Effort (rough) |
|---|------------|-------|----------|----------------|
| A | Solum KMS CLI + sidecar wiring | Solum | Honest “KMS path” for buyers who require AWS KMS | **Done (H2.4)** |
| B | Observability baseline (metrics + alerts) | Ferrum + Solum sidecar | Unsupervised on-prem without Synaptic Four on laptop | Few days |
| C | HELIOS clinical access evidence types | HELIOS + Solum export | Continuous clinical-plane evidence in packs | 1–2 weeks (design + ship) |
| D | CLI org-IAM (optional) | Solum | Same CAP authority on offline CLI as sidecar | Days — **product decision first** |

Optional / pull-only: HelixTest Auth Level live; SAML (Keycloak if demanded).

---

## A — Solum KMS CLI / sidecar — **DONE (H2.4)**

| Fact | Detail |
|------|--------|
| Shipped | Feature `aws-kms`: CLI `wrap-seed` / `--wrapped-keypair`; sidecar `--wrapped-keys-dir`; `WrappedSeedFile` + mocked `load_aws_kms_from_dir` tests |
| Toolchain | Feature build needs **rustc ≥ 1.94.1**; default Solum MSRV stays 1.91.1 without the feature |
| Credentials | Env keys (`AWS_REGION`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`); not full IRSA/`aws-config` |
| Honesty | Envelope + in-process unwrap (`ZeroizeOnDrop`); **not** HSM/TEE/FIPS |

Remaining second-pass items: B–D below.

---

## B — Observability baseline

| Fact | Detail |
|------|--------|
| Today | Gateway `/health` (+ clock/disk fields); sidecar stdout + audit files; reverse-proxy access logs |
| Gap | No Prometheus scrape contract, no alert pack, no documented “red/yellow” for consent/KMS failures |
| Done when | Documented scrape targets + 3–5 alerts (gateway down, health degraded, sidecar unreachable, consent status errors rate, disk low); optional `/metrics` if already cheap — prefer thin over perfect |
| Parallel with | H2.3 thin-metrics section already lists curl checks; second pass adds scrape + alert YAML or Compose sidecar |

**Entry points:** Ferrum `GET /health`; Solum sidecar token-gated status; Showcase ops runbook § Observability.

---

## C — HELIOS clinical evidence types

| Fact | Detail |
|------|--------|
| Today | HELIOS genomic / pipeline evidence; Solum Stage-1 artefacts optional in Evidence Pack |
| Gap | No versioned “clinical access / consent decision” evidence type exported from Solum into HELIOS/Showcase packs |
| Done when | Schema + Solum export (grant/revoke/status decision events) + Showcase Evidence Pack role; honesty: technical evidence ≠ certification |
| Prefer after | H3 export schemas stabilize — can start design now, avoid double rewrite |

**Entry points:** HELIOS check/report schemas; Solum audit.jsonl; Showcase `evidence_pack.py`.

---

## D — CLI org-IAM (product decision)

| Fact | Detail |
|------|--------|
| Today | Sidecar org-IAM (H2.2) maps OIDC groups → CAP_*; CLI keeps `--capability` for offline |
| Gap | Offline CLI can still assert CAP without JWT |
| Decision gate | Do operators need fail-closed JWT on CLI, or is sidecar-only enough for production spine? |
| Done when | If yes: CLI accepts `--org-iam-config` + Bearer/JWKS (or refuses CAP flags when config set); tests + docs. If no: close this row as **wontfix / intentional** in limitations |

---

## Sign-off criteria for “full H2 exit”

Update [H2-PILOT-CHECKLIST.md](H2-PILOT-CHECKLIST.md) 2.7 / remaining notes and [H2-KNOWN-LIMITATIONS.md](H2-KNOWN-LIMITATIONS.md) only when:

1. A shipped (or explicit “CustomerHeld-only sites OK” customer waiver recorded), **and**
2. B shipped (thin metrics + alerts), **and**
3. C either shipped **or** deferred with a dated HELIOS ticket and limitations row updated, **and**
4. D decided (shipped or wontfix).

Claim language: **full H2 exit** — operator runbook + pack with teeth across planes. Still do **not** claim EHDS/ODPC certification or HSM.

---

## Related

- [H2-OPS-RUNBOOK.md](H2-OPS-RUNBOOK.md) — H2.3 collector path + thin metrics
- [H2-KNOWN-LIMITATIONS.md](H2-KNOWN-LIMITATIONS.md)
- [COORDINATED-PORTFOLIO-ROADMAP.md](../COORDINATED-PORTFOLIO-ROADMAP.md) §7
- Kenya counsel (parallel, not H2): Solum [KENYA-K1-BRIEF.md](https://github.com/SynapticFour/Solum/blob/main/docs/counsel/KENYA-K1-BRIEF.md)
