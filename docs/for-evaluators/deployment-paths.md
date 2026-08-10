# Deployment and Integration Paths

These paths are designed for customer conversations: practical, scoped, and progressive.

## Path A: Partial Ferrum deployment (minimum viable scope)

Use when a customer says: "We do not want a big-bang rollout."

Suggested scope:

1. Deploy only required Ferrum services for one data/API flow.
2. Validate one representative dataset and one workflow handoff.
3. Capture baseline outputs for operational and stakeholder review.

What this proves:

- Modular adoption is possible.
- Value can be shown without deploying the entire platform.
- Technical debt and migration risk stay constrained.

Technical anchors:

- `Ferrum` core APIs and provenance capabilities
- `Ferrum-GA4GH-Demo` for measurable baseline behavior

## Path B: HELIOS on top of existing pipelines (without replatforming)

Use when a customer says: "We already have pipelines. We need governance and evidence."

Suggested scope:

1. Keep existing Nextflow or Snakemake pipeline as-is.
2. Run HELIOS against the existing work directory and outputs.
3. Generate evidence artifacts and include them in release workflow.

What this proves:

- Existing pipeline investments are preserved.
- Auditability and technical documentation can be added incrementally.
- Teams can strengthen quality posture without rewriting execution logic.

Technical anchors:

- `HELIOS` CLI wrapper approach
- Existing CI process plus evidence publication gate

## Path C: Ferrum + HELIOS for EHDS-oriented evidence readiness

Use when a customer says: "How does this support EHDS-related expectations?"

Suggested scope:

1. Use Ferrum for structured data/API and provenance handling.
2. Use HELIOS to generate technical evidence from real pipeline runs.
3. Build a reusable "documentation package" per release or study.

What this proves:

- A practical evidence workflow can be established now.
- Teams can separate technical evidence generation from legal certification claims.
- Regulatory and technical stakeholders can review the same source artifacts.

Important framing:

- This is evidence tooling and documentation support.
- It is not automatic regulatory certification.

## Path D: bioresearch-assistant RAG on customer data

Use when a customer says: "Can we query our own knowledge and outputs safely?"

Suggested scope:

1. Define allowed internal sources (documents, pipeline outputs, metadata).
2. Ingest a curated subset into the RAG workflow.
3. Validate response quality with citation/grounding checks.
4. Set role-based access boundaries for sensitive content.

What this proves:

- RAG can be customer-specific and operationally controlled.
- Trust can be improved through source-aware responses.
- Teams can iterate from pilot corpus to production corpus safely.

Technical anchors:

- `bioresearch-assistant` downstream flow
- Ferrum/HELIOS artifacts as structured context sources

## Path E: Solum Stage-1 (clinical companion)

Use when a customer says: "We need fail-closed authorization, consent, and tamper-evident audit for clinical data — separate from the genomic plane."

Suggested scope:

1. Run Solum-Demo locally (`make up` · `make smoke-stage1` · `make smoke-consent` · UI Scenarios 1–3) or `make solum-stage` from Showcase.
2. Capture allow/deny encrypt, consent grant/revoke, and `chain_broken` after harness tamper.
3. Optionally attach artefacts to the genomic golden path (`make golden-path-with-solum`).
4. Optional Track B live: Demo `make up-h3` · `make smoke-h3` (builds sibling `../Solum`, not the Stage-1 tag) — [H3-EHRBASE-SPIKE](https://github.com/SynapticFour/Solum/blob/main/docs/H3-EHRBASE-SPIKE.md).

What this proves:

- Clinical perimeter can be demonstrated without merging into Ferrum.
- Stage-1 proofs are machine-readable and reportable alongside HELIOS evidence.

Technical anchors:

- [Solum](https://github.com/SynapticFour/Solum) · [Solum-Demo](https://github.com/SynapticFour/Solum-Demo) · [COVERAGE](https://github.com/SynapticFour/Solum-Demo/blob/main/docs/COVERAGE.md) · [PINNED_VERSIONS](https://github.com/SynapticFour/Solum-Demo/blob/main/PINNED_VERSIONS.txt)
- Showcase: `scripts/run-solum-stage.sh`, [IMPLEMENTATION-PLAN-EVIDENCE-CHAIN.md](../internal/IMPLEMENTATION-PLAN-EVIDENCE-CHAIN.md)

Honesty: ephemeral demo keys only; not a production topology.

## Path E+: Solum Track B CDR + genomic link (H3.5)

Use when evaluating clinical+genomic co-custody: CDR composition fixture plus subject link to a Ferrum DRS id.

- Fixtures: `fixtures/ci/solum-cdr/` (included in `make evidence-pack-fixtures`)
- Subject bridge: Solum [ADR 0003](https://github.com/SynapticFour/Solum/blob/main/docs/adr/0003-subject-bridge.md)
- Partner APIs: Solum [PARTNER-EHR-API.md](https://github.com/SynapticFour/Solum/blob/main/docs/customer/PARTNER-EHR-API.md)

Honesty: fixture digests only — not live EHRbase proof, not MDR certification.

## Path selection guide

- Need fastest starter with low change risk: **Path A**
- Need governance on existing pipelines first: **Path B**
- Need EHDS-oriented evidence story: **Path C**
- Need user-facing research assistant on private data: **Path D**
- Need clinical authz/audit companion (separate perimeter): **Path E**
- Need clinical CDR + genomic subject-link evidence: **Path E+**

Most customers eventually combine **A + B + C**, with **D** and/or **E**/**E+** added where research UX or clinical compliance is in scope.

For workshop-ready decision support, use [Which path fits me?](../for-customers/which-path.md).
