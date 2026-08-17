# Evidence Pack → auditor / ethics questions (non-cert)

**Audience:** quality, ethics, procurement reviewers
**Status:** 2026-08-12 · org K3
**Related:** [evidence-pack.md](evidence-pack.md) · [compliance-framing.md](compliance-framing.md)

This map shows **which technical artefacts speak to common questions**. It does **not** answer the questions for you, and it is **not** a certificate of compliance.

| Question (examples) | Artefact / field | What it shows | What it does **not** show |
|---------------------|------------------|---------------|---------------------------|
| What software versions ran? | Pack manifest / pinned versions | Reproducible pins | That versions are “approved” by a regulator |
| Did genomic workflows leave an audit trail? | HELIOS signed report (JSON/PDF/RO-Crate) | Signed run context + checks | Lab accreditation |
| Was clinical access / consent evidence exported? | Solum audit export + HELIOS `solum-audit` / CLIN-ACCESS | Hash-chained clinical audit ingest | Legal consent validity |
| Can we join research subject to clinical subject? | `solum_subject_id` / Path E+ asserts | Technical join key present when configured | Correct patient identity in law |
| Who holds encryption keys? | [key-custody.md](key-custody.md) | CustomerHeld vs optional KMS posture | That keys were never mishandled |
| Is this EHDS / ISO / MDR compliant? | — | — | **Nothing in the pack claims this** |

**How to use in a pilot:** attach this page + the locked sales blurb + the pack sample. Ask the reviewer which rows they need live-generated vs fixture.
