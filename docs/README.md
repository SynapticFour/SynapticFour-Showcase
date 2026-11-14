# Documentation

Every document under `docs/`, grouped as a tutorial, how-to guides, reference, and explanation. One line each.

## Tutorial

| Document | What it is |
|----------|------------|
| [GETTING-STARTED.md](GETTING-STARTED.md) | The fixture command that runs here, and the Docker path that needs sibling checkouts |
| [for-customers/start-here.md](for-customers/start-here.md) | A four-step try of the pinned path |

## How-to guides

| Document | What it is |
|----------|------------|
| [for-customers/consent-gate.md](for-customers/consent-gate.md) | How the consent gate sits in front of WES |
| [for-customers/disaster-recovery.md](for-customers/disaster-recovery.md) | Restore notes for the customer pack |
| [for-customers/integration-verification.md](for-customers/integration-verification.md) | How to re-run the checks this repository records |
| [for-customers/observability.md](for-customers/observability.md) | The pilot observability one-pager |
| [for-customers/procurement-short-path.md](for-customers/procurement-short-path.md) | The short evaluation path |
| [for-customers/which-path.md](for-customers/which-path.md) | How to choose an entry path |
| [for-evaluators/deployment-paths.md](for-evaluators/deployment-paths.md) | Paths A through E |
| [for-evaluators/evaluate-at-head.md](for-evaluators/evaluate-at-head.md) | What to read at the default-branch tip |
| [for-evaluators/technical-evaluation-kit.md](for-evaluators/technical-evaluation-kit.md) | Steps, checks, and the go or no-go rubric |
| [PINNED-VERSIONS-CADENCE.md](PINNED-VERSIONS-CADENCE.md) | How the pin file is refreshed |
| [pilots/H1-PILOT-CHECKLIST.md](pilots/H1-PILOT-CHECKLIST.md) | Week-by-week on-prem checklist |
| [pilots/H1-RESTORE-DRILL-EXTENDED.md](pilots/H1-RESTORE-DRILL-EXTENDED.md) | The extended hub Postgres restore drill |
| [pilots/H2-OPS-RUNBOOK.md](pilots/H2-OPS-RUNBOOK.md) | TLS, keys, backup rotation, and the H2.3 polish |
| [pilots/H2-PILOT-CHECKLIST.md](pilots/H2-PILOT-CHECKLIST.md) | On-prem spine checklist |
| [pilots/H2-SECOND-PASS.md](pilots/H2-SECOND-PASS.md) | Second-pass exit items |
| [pilots/H3-PILOT-CHECKLIST.md](pilots/H3-PILOT-CHECKLIST.md) | Clinical and genomic co-custody checklist |
| [pilots/H4-PILOT-CHECKLIST.md](pilots/H4-PILOT-CHECKLIST.md) | Edge, Pi, and Kenya checklist |
| [pilots/observability/README.md](pilots/observability/README.md) | Prometheus blackbox and alerts for H2 |

## Reference

| Document | What it is |
|----------|------------|
| [DEPENDENCY-POLICY.md](DEPENDENCY-POLICY.md) | Dependency and supply-chain policy |
| [FOR-EVALUATORS.md](FOR-EVALUATORS.md) | What a run shows, and what it does not show |
| [WHAT-A-RUN-SHOWS.md](WHAT-A-RUN-SHOWS.md) | The fixture layer and the live golden path |
| [for-customers/README.md](for-customers/README.md) | Index of the customer evidence notes |
| [for-customers/evidence-pack-auditor-map.md](for-customers/evidence-pack-auditor-map.md) | Evidence Pack mapped to auditor questions. Not a certificate |
| [for-customers/evidence-pack.md](for-customers/evidence-pack.md) | What the Evidence Pack proves, and what it does not |
| [for-customers/evidence-surface.md](for-customers/evidence-surface.md) | Ferrum, Solum, and BioResearch Assistant into HELIOS |
| [for-customers/gatk-rs-s4mp.md](for-customers/gatk-rs-s4mp.md) | The optional W4 path |
| [for-customers/key-custody.md](for-customers/key-custody.md) | Key custody, one page |
| [for-customers/legal/README.md](for-customers/legal/README.md) | Legal pointers |
| [for-customers/persona-evidence.md](for-customers/persona-evidence.md) | What this showcase actually ran for the personas |
| [for-customers/personas/README.md](for-customers/personas/README.md) | Persona patterns |
| [for-customers/personas/bra-research.md](for-customers/personas/bra-research.md) | Academic and rare-disease research group |
| [for-customers/personas/dic-genomde.md](for-customers/personas/dic-genomde.md) | Clinic and national-node evaluator |
| [for-customers/personas/ehds-solum.md](for-customers/personas/ehds-solum.md) | EHDS-oriented lab, clinic, or vendor |
| [for-customers/personas/genomde-symposium-one-pager.md](for-customers/personas/genomde-symposium-one-pager.md) | One page: Ferrum beside an archive, Solum beside an EHR |
| [for-customers/personas/kenya-nphi.md](for-customers/personas/kenya-nphi.md) | Kenya or Africa public-health or genomics lab |
| [for-evaluators/README.md](for-evaluators/README.md) | Index of the longer evaluator kit |
| [for-evaluators/faq.md](for-evaluators/faq.md) | Questions about the showcase |
| [for-evaluators/helixtest-gate.md](for-evaluators/helixtest-gate.md) | Optional HelixTest input to the Evidence Pack |
| [pilots/H1-KNOWN-LIMITATIONS.md](pilots/H1-KNOWN-LIMITATIONS.md) | H1 limits for pilot sign-off |
| [pilots/H2-KNOWN-LIMITATIONS.md](pilots/H2-KNOWN-LIMITATIONS.md) | H2 limits |
| [pilots/HORIZON-OPEN-GATES.md](pilots/HORIZON-OPEN-GATES.md) | What the horizon list still marks as missing |
| [pilots/README.md](pilots/README.md) | Index of the pilot checklists |

## Explanation

| Document | What it is |
|----------|------------|
| [adr/0001-solum-ferrum-consent-access.md](adr/0001-solum-ferrum-consent-access.md) | Solum revoke and Ferrum deny |
| [adr/0002-solum-org-iam-cap.md](adr/0002-solum-org-iam-cap.md) | OIDC groups and Solum capabilities |
| [adr/0003-tenant-boundaries.md](adr/0003-tenant-boundaries.md) | Tenant boundaries for a managed single tenant |
| [for-customers/co-custody.md](for-customers/co-custody.md) | Clinical and genomic co-custody |
| [for-customers/compliance-framing.md](for-customers/compliance-framing.md) | What Ferrum and HELIOS do here, in German and English |
| [for-customers/overview.md](for-customers/overview.md) | Customer overview of the pieces |
| [for-customers/scenarios.md](for-customers/scenarios.md) | Scenarios, in German and English |
| [pilots/H4-GEOGRAPHY-DECISION.md](pilots/H4-GEOGRAPHY-DECISION.md) | The provisional Kenya decision |
| [pilots/H4-HUB-PI-ARCHITECTURE.md](pilots/H4-HUB-PI-ARCHITECTURE.md) | Hub and Pi layout for that pack |
| [pilots/H5-MANAGED-SINGLE-TENANT.md](pilots/H5-MANAGED-SINGLE-TENANT.md) | Managed single-tenant recipe |

Files outside `docs/` that the same reading needs: [../README.md](../README.md), [../DEMO.md](../DEMO.md), [../PINNED_VERSIONS.txt](../PINNED_VERSIONS.txt), [../LICENSE](../LICENSE), [../SECURITY.md](../SECURITY.md), [../CITATION.cff](../CITATION.cff).
