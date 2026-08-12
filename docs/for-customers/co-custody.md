# Co-custody contract — clinical + genomic (buyer-facing)

**Audience:** procurement, security, clinical informatics
**Status:** Engineering contract exists (H2.1 consent teeth · H3.3 subject bridge). This page is the **buyer story**.
**Not:** a legal DPA, MDR claim, or guarantee of EHDS compliance.

---

## What “co-custody” means here

| Plane | Product | Holds |
|-------|---------|-------|
| Genomic data / compute | **Ferrum** | DRS objects, WES/TES, Crypt4GH envelopes for genomics |
| Clinical policy / consent / optional CDR | **Solum** | Consent, purpose binding, clinical field crypto, audit, subject links |
| Evidence packaging | **HELIOS** + Showcase | Signed/technical evidence from pipeline + Solum audit export shapes |

Ferrum never becomes Solum’s clinical database. Solum never becomes Ferrum’s WES. They share **contracts**: Crypt4GH family, subject ID string, consent revoke → access deny, audit export shapes.

---

## Subject bridge (already implemented)

Canonical join key: **`solum_subject_id`** (opaque pseudonym).

| Field | Owner |
|-------|-------|
| `solum_subject_id` | Solum (consent subject + subject-link store) |
| Ferrum metadata `solum_subject` | Must **equal** the same string for revoke teeth to work |
| `ferrum_drs_id` | Optional DRS object id on the Solum link |
| `phenopacket_id` | Optional BRA / research id |

Solum APIs: `POST/GET /v1/cdr/subject-link` (capabilities `solum:cdr:write` / `read`).
Engineering: Solum ADR-0003 · Showcase ADR-0001 (consent access) · Ferrum `solum_consent` metadata key.

**Operator rule:** one string everywhere — Solum subject, Ferrum object metadata, and (when used) Phenopacket linkage.

---

## Consent teeth (H2.1)

When configured, Solum revoke/deny for a bound purpose can cause Ferrum **DRS/WES 403** for objects tagged with that subject. Soft-fail demos exist; **pilots must enable the fail-closed profile**.

---

## Cryptography

Same **Crypt4GH** envelope family across planes. Default custody: **customer-held** keys. Optional Solum AWS KMS wraps the seed only — plaintext still briefly exists in process memory (see Solum SECURITY-OVERVIEW / CRYPTO).

→ [key-custody.md](key-custody.md)

---

## What you receive in a pilot

1. Subject-link round-trip demonstrated
2. Consent revoke demonstrated against Ferrum (when co-deployed)
3. Audit export (HELIOS-oriented) from Solum
4. Evidence Pack from Showcase (engineering evidence — **not** a certificate)

---

## What this is not

- Not a cross-org master patient index
- Not “Synaptic Four holds your clinical + genomic SoR”
- Not permission to market clinical claims without external RA/MDCG review

---

## Next docs

- [overview.md](overview.md) · [evidence-pack.md](evidence-pack.md) · [legal/](legal/) · personas under [personas/](personas/)
