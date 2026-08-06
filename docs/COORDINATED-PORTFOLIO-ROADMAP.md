# Synaptic Four — Coordinated Portfolio Roadmap

*On-premise first. Independent products. Open standards. SaaS as a short prepared path — not the default.*

**Status:** Living strategy (2026-08-06)
**Audience:** founders, product owners, evaluators
**Non-goals:** contractual commitment, certification claims, SynaptiSec/SMB ecommerce

Related: [customer overview](for-customers/overview.md) · [integration verification](for-customers/integration-verification.md) · [Solum product definition](https://github.com/SynapticFour/Solum/blob/main/docs/PRODUCT-DEFINITION.md) · [Ferrum ECOSYSTEM](https://github.com/SynapticFour/Ferrum/blob/main/docs/ECOSYSTEM.md)

---

## 1. Doctrine (non-negotiable)

| Principle | Meaning |
|-----------|---------|
| **On-prem first** | Customer-held deployment is the primary delivery model. Cloud/SaaS is optional later. |
| **Independent products** | Ferrum, HELIOS, Solum, BRA, ga4gh-infra, Showcase stay separate repos and release trains. Coordination is via **contracts** (APIs, profiles, pins), not a monorepo. |
| **Open standards** | GA4GH, Crypt4GH, FHIR, openEHR, OIDC/Passports/DUO, Phenopackets — no proprietary interchange as the system of record. |
| **Honest maturity** | Demos ≠ pilots ≠ production. Soft-fail Alpha paths. Evidence Packs ≠ certificates. |
| **SaaS-ready, not SaaS-default** | Design tenancy boundaries, key custody, and attestation so a **single-tenant managed** or future multi-tenant SaaS is a short path — without shipping SaaS as the product story. |
| **Separate regulatory perimeters** | Genomic platform (Ferrum) ≠ clinical compliance/data plane (Solum) ≠ pipeline audit (HELIOS). Classification risk stays product-local. |

---

## 2. End-state picture (what “complete” means)

```text
┌─────────────────────────────────────────────────────────────────────────┐
│  Identity / policy          ga4gh-infra + Solum capabilities + org IdM   │
├───────────────────────────────┬─────────────────────────────────────────┤
│  Clinical data plane          │  Genomic data plane                     │
│  Solum (sidecar and/or        │  Ferrum (DRS/WES/TES/TRS, Crypt4GH)     │
│  openEHR CDR + FHIR APIs)     │                                         │
├───────────────────────────────┴─────────────────────────────────────────┤
│  Research / phenotyping       BRA (Phenopackets, PhenoFlow, optional AI) │
├─────────────────────────────────────────────────────────────────────────┤
│  Evidence                     HELIOS + Solum audit + Showcase packs      │
├─────────────────────────────────────────────────────────────────────────┤
│  Edge / field                 Ferrum Edge + jurisdiction packs + hub     │
└─────────────────────────────────────────────────────────────────────────┘
         ↑ EHR UIs / lab systems / partners implement on published APIs
```

**Not in end-state:** Synaptic Four as a full hospital EHR UI, or as the certified auditor.

---

## 3. Solum strategy — advice (EHDS catch-up + medical data)

### The risk you named is real

If Solum is **only** an EHDS Annex-II / consent / Crypt4GH **sidecar**, incumbent EHRs and middleware will eventually absorb “enough” of that surface. A pure compliance shim has a **shrinking moat**.

### The durable bet

Keep the sidecar as the **entry ramp** (wrap legacy, prove value fast), and grow an optional **clinical data plane**:

| Track | Role | When customers use it |
|-------|------|------------------------|
| **A — Sidecar / compliance** | Consent, purpose-binding, field Crypt4GH, fail-closed residency, audit | Day 1 beside existing EHR/HMIS |
| **B — Clinical data plane** | openEHR CDR (storage + AQL/FHIR APIs), **not** a full EHR UI | When sites want standards-native clinical + genomic co-custody |

Track B is deliberately **not** “build Epic.” It is: **durable clinical modelling + storage backend + open APIs**, so partners (or a thin Synaptic UI later) can implement EHR *on top*. Genetic data stays in Ferrum; **subject linkage** (pseudonym / passport / local ID) is the bridge.

### Migration as product, not afterthought

Design an explicit **strangler / absorb** path:

1. **Wrap** — sidecar on legacy (today)
2. **Mirror** — dual-write selected resources into Solum CDR (FHIR/openEHR)
3. **Prefer** — new workflows read Solum first
4. **Cut over** — legacy becomes archive; Solum CDR is system of record for covered domains

That answers “will Solum become obsolete?”: **only if it stays a shim.** If it becomes the **open standards home** for clinical data *and* the compliance engine, legacy systems can retire *into* it over years — which is the opposite of Solum retiring.

### Independence

Ferrum never becomes Solum’s database. Solum never becomes Ferrum’s WES. Showcase only orchestrates. Contracts: shared Crypt4GH envelopes, subject IDs, audit export shapes, HELIOS evidence types.

---

## 4. Coordinated phases

Horizon language (not calendar promises): **H0 now**, **H1 pilot-ready**, **H2 production on-prem**, **H3 clinical+genomic co-custody**, **H4 edge-legal**, **H5 SaaS-ready**.

### H0 — Now (baseline)

| Product | State |
|---------|--------|
| Ferrum + Demo + Showcase | Evidence chain W0–W4; GIAB Nextflow path proven |
| Solum Stage-1 | Sidecar consent/crypto/audit; FHIR-first |
| HELIOS | Alpha pipeline audit |
| Edge/Pi | Tech path exists; legal packs incomplete |
| SaaS | Explicitly deferred |

**Exit:** Maintain Showcase verification; no new product inventiveness for its own sake.

---

### H1 — Pilot-ready on-prem (coordinated “first customer”)

**Theme:** one site can run Ferrum + HELIOS (+ optional Solum sidecar) with auth on, real compute, customer-held keys, restore drill.

| Workstream | Owner | Deliverable |
|------------|-------|-------------|
| Ferrum pilot config | Ferrum | Auth required; TES not noop; `pilot.toml` + runbook closed |
| Lab Kit images | Ferrum-Lab-Kit | Published image story (or documented monolith path only) |
| ga4gh-infra hardening | ga4gh-infra | Documented limitations accepted; TLS/proxy; revoke story improved |
| HELIOS install | HELIOS | Documented venv/package path; signed report in pilot pack |
| Solum sidecar pilot | Solum | CustomerHeld keys; no ephemeral in pilot profile; SIDECAR hardening |
| Showcase | Showcase | `SHOWCASE_ENABLE_*` pilot recipe; Evidence Pack from live pilot |
| DR checklist | All | Backup/restore for Ferrum objects + Solum audit/consent stores |

**Coordination contract:** pinned SHAs in Showcase `PINNED_VERSIONS.txt`; shared Crypt4GH; subject ID convention documented once.

**Exit:** First-release checklist green; one external pilot can say “we ran this.”

---

### H2 — Production on-prem spine

**Theme:** ops, keys, identity, continuous evidence — still no full EHR.

| Workstream | Owner | Deliverable |
|------------|-------|-------------|
| KMS/HSM path | Solum (+ Ferrum keys) | CLI/sidecar KMS; rotation runbook; zeroize where feasible |
| Org IAM bridge | ga4gh-infra + Solum | Map institutional OIDC groups → Solum capabilities; SAML if demanded |
| Consent propagation | Solum ↔ Ferrum | Revoke/deny blocks DRS/WES for bound purpose (contracted API) |
| HELIOS maturity | HELIOS | Broader check set; clinical access evidence types (Solum export) |
| Observability | Ferrum (+ others) | Metrics/logs/alerts baseline for gateway + sidecar |
| HelixTest in CI | HelixTest + Showcase | Live gate optional; fixture gate required |

**Exit:** Operator can run without Synaptic Four on the laptop; withdrawal has teeth across planes.

---

### H3 — Clinical + genomic co-custody (Solum Track B)

**Theme:** openEHR CDR + migration; still not a complete EHR product.

| Workstream | Owner | Deliverable |
|------------|-------|-------------|
| openEHR CDR MVP | Solum | Persist compositions; AQL read; FHIR façade for subset |
| Migration toolkit | Solum | FHIR import; dual-write adapter; cutover checklist |
| Subject bridge | Solum + Ferrum + BRA | Stable pseudonym / Phenopacket link to DRS objects |
| Partner API docs | Solum | “Build EHR UI on Solum” contract (REST/FHIR/openEHR) |
| Showcase Path E+ | Showcase | Clinical CDR fixture + genomic link in Evidence Pack |
| MDCG guardrails | Solum | No diagnostic inference; counsel review before claims |

**Exit:** A greenfield small clinic *could* store clinical + link genomic without buying a full EHR from Synaptic Four; a brownfield site can start wrapping and mirroring.

---

### H4 — Edge / Pi + jurisdiction completeness

**Theme:** resource-poor regions get **lawful** offline ops, not only binaries.

| Workstream | Owner | Deliverable |
|------------|-------|-------------|
| Jurisdiction packs | Solum | Kenya → production-ready; Nigeria/SA next; profile tests |
| Offline consent/retention | Solum Edge profile | Works without cloud; sync policy documented |
| Hub offload | Ferrum Edge + hub | Heavy WES on hub; Pi for custody/capture |
| Physical/key runbook | Lab Kit / docs | Stolen device, wipe, sealed storage |
| Village demo → pilot | Ferrum-GA4GH-Demo | One real field pilot checklist |

**Exit:** Honest “Pi + hub” architecture that counsel can review per jurisdiction.

---

### H5 — SaaS-*ready* (backseat; short path)

**Theme:** architecture so managed single-tenant (or later multi-tenant) is weeks/months of work — **not** launch SaaS.

| Workstream | Owner | Deliverable |
|------------|-------|-------------|
| Tenancy boundaries | All | Explicit tenant_id in APIs/storage; no shared secrets |
| Key custody model | Solum + Ferrum | Customer-held or HSM; enclave roadmap documented |
| Attestation sketch | Solum | TEE path as optional “honest ZK” (not claimed until real) |
| Single-tenant managed recipe | Lab Kit | VPC/dedicated cluster install = “hosted on-prem” |
| Multi-tenant | Deferred | Only after single-tenant managed is boring |

**Exit:** A customer asking “can you host it?” gets a **managed single-tenant** offer without redesigning the products.

---

## 5. Per-product contribution map

| Product | H1 | H2 | H3 | H4 | H5 |
|---------|----|----|----|----|-----|
| **Ferrum** | Pilot auth/TES | Consent hook, ops | Subject bridge | Edge hub | Tenancy in DRS/WES |
| **Ferrum-Lab-Kit** | Images/runbooks | Ops profiles | — | Field profiles | Managed recipe |
| **Ferrum-GA4GH-Demo** | Stable pins | — | CDR demo link | Field pilot | — |
| **ga4gh-infra** | Pilot AAI | IAM bridge | — | Offline/visa limits honesty | Tenant IdP |
| **HELIOS** | Pilot install | Clinical evidence types | Pack CDR events | Offline sync of reports | Tenant-scoped reports |
| **Solum** | Sidecar pilot | KMS, revoke↔Ferrum | **CDR + migration** | Jurisdiction packs | Tenancy + TEE prep |
| **Solum-Demo** | Pilot mirror | — | CDR demo | — | — |
| **BRA** | Optional M2 | Phenopacket bridge | Subject bridge | — | — |
| **Showcase** | Pilot recipe | Verification suite | Path E+ | Edge verification | Managed demo notes |
| **HelixTest** | Fixture CI | Live optional | — | Africa mode | — |
| **gatk-rs / S4MP** | Soft-fail only | — | — | — | — |

---

## 6. Coordination mechanisms (keep independence)

1. **`PINNED_VERSIONS.txt` + Showcase suite** — integration truth
2. **Shared crypto** — Crypt4GH envelopes across Ferrum/Solum
3. **Shared subject ID ADR** — one short ADR in Ferrum + Solum ECOSYSTEM links
4. **Evidence shapes** — HELIOS/Solum export schemas versioned
5. **Jurisdiction profiles** — Solum owns TOML; Ferrum Edge consumes residency where relevant
6. **No monorepo** — contracts and pins, not Cargo workspace of everything

---

## 7. Sequencing recommendation (next 3 moves) — artefacts

| Move | Artefact | Status |
|------|----------|--------|
| **1. Close H1** | [pilots/H1-PILOT-CHECKLIST.md](pilots/H1-PILOT-CHECKLIST.md) · [H1-EXECUTION-RECORD.md](pilots/H1-EXECUTION-RECORD.md) · [H1-KNOWN-LIMITATIONS.md](pilots/H1-KNOWN-LIMITATIONS.md) | **SIGNED OFF** 2026-08-06 |
| **1b. H2 spine v1** | [pilots/H2-PILOT-CHECKLIST.md](pilots/H2-PILOT-CHECKLIST.md) · [H2-EXECUTION-RECORD.md](pilots/H2-EXECUTION-RECORD.md) · [H2-OPS-RUNBOOK.md](pilots/H2-OPS-RUNBOOK.md) | **SIGNED OFF** spine v1 |
| **1c. H2.1 Teeth** | [adr/0001-solum-ferrum-consent-access.md](adr/0001-solum-ferrum-consent-access.md) · `make h21-teeth` | **SIGNED OFF** — Solum revoke → Ferrum DRS/WES 403 when configured |
| **1d. H2.2 Org CAP** | [adr/0002-solum-org-iam-cap.md](adr/0002-solum-org-iam-cap.md) · `make h22-org-cap` | **SIGNED OFF** — sidecar OIDC groups → CAP_* when org-IAM enabled |
| **1e. H2.3 Ops polish** | [pilots/H2-OPS-RUNBOOK.md](pilots/H2-OPS-RUNBOOK.md) · `make h23-ops-polish` | **SIGNED OFF** — collector visa path + thin health checks |
| **1f. H2 second pass** | [pilots/H2-SECOND-PASS.md](pilots/H2-SECOND-PASS.md) | Backlog to full H2 exit (KMS, Prometheus, HELIOS clinical, CLI org-IAM decision) |
| **2. H3 design** | Solum [ADR 0001](https://github.com/SynapticFour/Solum/blob/main/docs/adr/0001-openehr-cdr-and-migration.md) + [ADR 0002 EHRbase](https://github.com/SynapticFour/Solum/blob/main/docs/adr/0002-cdr-engine-ehrbase.md) + [MIGRATION-STRANGLER.md](https://github.com/SynapticFour/Solum/blob/main/docs/MIGRATION-STRANGLER.md) | Architecture + engine choice accepted; CDR coding still deferred |
| **3. H4 geography** | [pilots/H4-GEOGRAPHY-DECISION.md](pilots/H4-GEOGRAPHY-DECISION.md) · Solum [KENYA-K1-BRIEF](https://github.com/SynapticFour/Solum/blob/main/docs/counsel/KENYA-K1-BRIEF.md) · [KENYA-K1-SEND-CHECKLIST](https://github.com/SynapticFour/Solum/blob/main/docs/counsel/KENYA-K1-SEND-CHECKLIST.md) | Kenya first; counsel brief ready to send |

SaaS (H5) stays documentation + tenancy hygiene until a customer pays for managed hosting.

**Immediate execution order:** send Kenya K1 brief to counsel ([send checklist](https://github.com/SynapticFour/Solum/blob/main/docs/counsel/KENYA-K1-SEND-CHECKLIST.md)); timebox EHRbase compose spike; full H2 exit via [H2-SECOND-PASS.md](pilots/H2-SECOND-PASS.md) when scheduled.

---

## 8. What we will not do

- Replace partner EHRs with a Synaptic Four mega-EHR
- Claim EHDS/DSGVO/MDR compliance from Evidence Packs
- Make S4MP or gatk-rs required for the spine
- Force SaaS as the default commercial model
- Merge product repos into Showcase

---

## 9. Document ownership

| Artefact | Repo |
|----------|------|
| **This coordinated roadmap** | SynapticFour-Showcase (integrator) |
| H1 pilot checklist + execution record | Showcase `docs/pilots/H1-*.md` |
| H4 geography decision | Showcase `docs/pilots/H4-GEOGRAPHY-DECISION.md` |
| H3 CDR ADRs + migration | Solum `docs/adr/0001-…` · `0002-…` · `docs/MIGRATION-STRANGLER.md` |
| Kenya counsel brief + send checklist | Solum `docs/counsel/KENYA-K1-BRIEF.md` · `KENYA-K1-SEND-CHECKLIST.md` |
| H2 second-pass backlog | Showcase `docs/pilots/H2-SECOND-PASS.md` |
| Product roadmaps | Each product’s `docs/roadmap.md` |
| Solum dual-track product boundary | Solum `PRODUCT-DEFINITION.md` |
| Customer “what exists” | Showcase `docs/for-customers/overview.md` |
