# Workshop Playbook (90 Minutes)

Use this playbook for first customer discovery sessions where business and technical stakeholders join together.

## Outcomes of the session

By the end of the workshop, you should have:

- a selected primary adoption path (A, B, C, or D),
- a 2-week proof scope with clear success criteria,
- named owners for business, platform, and compliance tracks,
- a list of required artifacts and decision gates.

## Suggested participant mix

- Executive sponsor or business owner
- CTO/platform lead
- Data/bioinformatics/MLOps representative
- Compliance/quality representative
- Solution architect or technical evaluator

## 90-minute agenda

### 0-10 min: business framing

- What outcome must improve in the next 90 days?
- What is the highest-risk assumption today?
- Which stakeholder signs off on proof success?

Deliverable:

- one-sentence target outcome and one quantified success metric.

### 10-25 min: current-state architecture snapshot

- Existing pipeline/orchestration model (Nextflow, Snakemake, mixed)
- Data environment model (on-prem, cloud, hybrid)
- Current evidence/compliance workflow

Deliverable:

- baseline architecture sketch and constraints list.

### 25-45 min: path selection (A/B/C/D)

- Use [Which path fits me?](../for-customers/which-path.md) to choose initial path.
- Confirm why this path is first and what is out of scope.

Deliverable:

- selected path and rejected alternatives (with reason).

### 45-70 min: technical proof design

- Select one representative dataset family.
- Define interfaces, artifacts, and checkpoints.
- Assign run ownership and review ownership.

Deliverable:

- 2-week technical proof plan with owners and dates.

### 70-85 min: evidence and stakeholder review plan

- Identify required artifacts for technical and non-technical audiences.
- Define review cadence and acceptance criteria.

Deliverable:

- decision-ready review package checklist.

### 85-90 min: close and next actions

- Confirm first run date, review date, and go/no-go gate.

Deliverable:

- agreed next-step timeline.

## Path-specific workshop guides

## Path A guide: partial Ferrum deployment

Focus question:

- Which single API/data flow best proves value with lowest deployment risk?

Required decisions:

- first flow scope,
- environment target,
- proof metric (latency, throughput, interoperability, or reproducibility).

Week 1 deliverables:

- scoped deployment plan,
- first run with baseline outputs.

Week 2 deliverables:

- stakeholder-ready findings summary,
- decision on scale-up to Path B/C.

## Path B guide: HELIOS with existing pipelines

Focus question:

- Which production-like pipeline run should be wrapped first for evidence value?

Required decisions:

- target pipeline run,
- artifact retention policy,
- CI integration point for evidence checks.

Week 1 deliverables:

- HELIOS overlay run against existing work/output directories,
- evidence artifact sample pack.

Week 2 deliverables:

- CI/release integration proposal,
- quality/compliance review notes.

## Path C guide: EHDS-oriented evidence readiness

Focus question:

- What technical documentation package is required for internal EHDS-oriented review?

Required decisions:

- minimum evidence bundle content,
- provenance and traceability linkage approach,
- reviewer sign-off template.

Week 1 deliverables:

- first integrated Ferrum + HELIOS evidence package.

Week 2 deliverables:

- reviewed documentation package with open gaps and remediation plan.

## Path D guide: RAG on customer data

Focus question:

- Which approved corpus and user roles should define the first RAG pilot?

Required decisions:

- source allowlist,
- role-based access boundaries,
- citation/grounding acceptance criteria.

Week 1 deliverables:

- curated pilot corpus and ingestion boundary definition.

Week 2 deliverables:

- pilot results with trust metrics (grounded answer rate, reviewer confidence).

## Reusable workshop output template

- **Selected path:** A / B / C / D
- **Business objective:** one sentence
- **Success criteria:** 2-4 measurable checks
- **Technical scope:** included/excluded systems
- **Evidence artifacts:** what will be shown to whom
- **Decision date:** go/no-go checkpoint

## Related pages

- [Internal personas](internal-personas.md)
- [FAQ](../for-customers/faq.md)
- [Deployment and Integration Paths](../deployment-integration-paths.md)
- [Which path fits me?](../for-customers/which-path.md)
- [Scenarios](../for-customers/scenarios.md)
