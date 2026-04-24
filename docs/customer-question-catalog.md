# Customer Question Catalog

Use this catalog as the primary customer-facing FAQ.  
Each question includes a short intent and a direct "Path to answer."

## A. Scope and Deployment

### 1. How can I deploy only part of Ferrum?

Intent: Start with minimal scope and reduced implementation risk.

Executive answer:

- Start with one customer-critical flow, not the full stack.
- Use this to prove value and de-risk architecture before expansion.

Technical answer:

- Deploy only the Ferrum components needed for one API/data path.
- Validate with one representative dataset and preserve outputs for review.

Path to answer:

- [Deployment and Integration Paths](deployment-integration-paths.md) (Path A section)
- [Decision Matrix](decision-matrix.md)

### 2. What is the minimum viable setup to show value?

Intent: Reach first meaningful result fast.

Executive answer:

- Aim for a 10-day proof focused on one measurable outcome.
- Keep scope fixed: one workflow, one dataset, one stakeholder review loop.

Technical answer:

- Use the baseline demo flow as reference behavior.
- Capture timings, outputs, and integration constraints early.

Path to answer:

- [Deployment and Integration Paths](deployment-integration-paths.md) (Path A section)
- [Reference Use Case: 10-day proof plan](reference-use-case.md#phased-demonstration-plan-manufacturer-view)

### 3. Can we run this on-prem, cloud, or hybrid?

Intent: Fit existing infrastructure and governance model.

Executive answer:

- Yes; choose the model that best matches security, procurement, and latency constraints.
- Start where approvals are fastest, then scale to target architecture.

Technical answer:

- The adoption paths are environment-agnostic when dependencies and data boundaries are explicit.
- Validate networking, storage, and identity assumptions in the first sprint.

Path to answer:

- [Deployment and Integration Paths](deployment-integration-paths.md) (Path A and Path B sections)

## B. Integration with Existing Work

### 4. How can we use HELIOS with our existing pipelines?

Intent: Add auditability and evidence without pipeline rewrite.

Executive answer:

- Keep the current pipeline stack and add evidence generation as an overlay.
- This minimizes disruption and speeds up governance improvements.

Technical answer:

- Point HELIOS at existing work/output directories.
- Publish evidence artifacts into your normal release or QA process.

Path to answer:

- [Deployment and Integration Paths](deployment-integration-paths.md) (Path B section)
- [Decision Matrix](decision-matrix.md)

### 5. Do we have to move from Nextflow/Snakemake to adopt this?

Intent: Avoid migration cost and disruption.

Executive answer:

- No migration is required for initial adoption.
- Prior investments can remain in place while governance maturity improves.

Technical answer:

- Existing orchestrations can be wrapped instead of replaced.
- Re-platforming can be deferred until there is a clear ROI case.

Path to answer:

- [Deployment and Integration Paths](deployment-integration-paths.md) (Path B section)

### 6. How does this connect to our current CI/CD and release process?

Intent: Keep delivery process consistent while improving traceability.

Executive answer:

- Add evidence checkpoints to the current release model, not a parallel process.
- This improves confidence with minimal organizational change.

Technical answer:

- Integrate HELIOS evidence generation and publication as a CI stage.
- Keep artifact links traceable to the same run and release identifiers.

Path to answer:

- [Deployment and Integration Paths](deployment-integration-paths.md) (Path B section)
- [Reference Use Case: technical flow](reference-use-case.md#technical-flow-what-runs-together)

## C. EHDS / Compliance / Risk

### 7. How does Ferrum help with EHDS-oriented requirements?

Intent: Improve structured data handling and evidence posture.

Executive answer:

- Ferrum + HELIOS provides a practical technical evidence backbone for EHDS-oriented programs.
- It supports structured documentation and repeatable review processes.

Technical answer:

- Ferrum covers interoperable data handling and provenance context.
- HELIOS adds run-level audit and evidence artifacts for technical documentation.

Path to answer:

- [Deployment and Integration Paths](deployment-integration-paths.md) (Path C section)

### 8. Is this "certified compliance" out of the box?

Intent: Clarify what the platform provides vs organizational obligations.

Executive answer:

- No; it is not automatic certification.
- It accelerates compliance work by improving the quality and consistency of technical evidence.

Technical answer:

- Treat generated outputs as evidence inputs for compliance workflows.
- Governance, legal interpretation, and formal certification remain organizational responsibilities.

Path to answer:

- [Deployment and Integration Paths](deployment-integration-paths.md) (Path C section)
- [Reference Use Case: compliance framing](reference-use-case.md#compliance-and-evidence-framing)

## D. RAG and Research Assistant

### 9. If we deploy bioresearch-assistant, how can we do RAG on our own data?

Intent: Enable customer-specific knowledge augmentation safely.

Executive answer:

- Start with a curated, approved corpus and expand in controlled waves.
- Measure user value and trust before broader rollout.

Technical answer:

- Define source boundaries, ingest approved data, and enforce access rules.
- Require citation/grounding checks before production use cases.

Path to answer:

- [Deployment and Integration Paths](deployment-integration-paths.md) (Path D section)

### 10. How do we control what data is indexed and exposed in responses?

Intent: Enforce data boundaries and governance.

Executive answer:

- Apply explicit source and role boundaries before indexing.
- Operate under least-privilege principles from day one.

Technical answer:

- Separate approved from non-approved sources at ingestion time.
- Enforce role-based visibility and validate with red-team style prompt tests.

Path to answer:

- [Deployment and Integration Paths](deployment-integration-paths.md) (Path D section)

### 11. How do we prove where an answer came from?

Intent: Support trust and explainability expectations.

Executive answer:

- Require source-grounded answers for user trust and governance reviews.
- Make traceability a non-negotiable acceptance criterion.

Technical answer:

- Store source references and response context metadata.
- Align RAG traces with Ferrum/HELIOS artifact identifiers where possible.

Path to answer:

- [Deployment and Integration Paths](deployment-integration-paths.md) (Path D section)
- [Reference Use Case](reference-use-case.md#technical-flow-what-runs-together)

## E. Validation and Decision-Making

### 12. How quickly can we run an internal proof-of-value?

Intent: Build decision confidence in weeks, not quarters.

Executive answer:

- A focused proof can typically run in 10-30 days depending on environment and data readiness.
- Keep success criteria explicit and measurable before kickoff.

Technical answer:

- Timebox to one path, one dataset family, and one artifact review cycle.
- Defer non-critical integrations until the first decision gate is passed.

Path to answer:

- [Reference Use Case: phased plan](reference-use-case.md#phased-demonstration-plan-manufacturer-view)

### 13. What should business stakeholders review vs what technical teams review?

Intent: Keep evaluation efficient across mixed audiences.

Executive answer:

- Business reviews outcome, cost/risk, and adoption plan.
- Technical reviews integration details, quality controls, and reproducibility.

Technical answer:

- Use separate review templates but shared artifact references.
- Keep a single glossary to prevent terminology drift between groups.

Path to answer:

- [Customer Personas](customer-personas.md)
- [Reference Use Case](reference-use-case.md)

### 14. What is the "all integrated" storyline to present to leadership?

Intent: Show one coherent narrative across tools.

Executive answer:

- "Start small, prove trust, scale responsibly."
- Show phased value with concrete evidence at each stage.

Technical answer:

- Demonstrate Ferrum baseline, HELIOS evidence overlay, and optional RAG downstream in one flow.
- Use repeatable artifacts and pinned versions to make the story defensible.

Path to answer:

- [Reference Use Case](reference-use-case.md)
