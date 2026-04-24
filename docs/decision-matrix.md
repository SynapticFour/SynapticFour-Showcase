# Decision Matrix

Use this page in workshops to decide the right adoption path in less than 30 minutes.

## 1) Fast path chooser

| Customer situation | Recommended path | Why first |
|--------------------|------------------|-----------|
| "We need to start small and prove value quickly." | Path A | Minimum scope, fastest proof, low disruption |
| "We already run pipelines and need auditability now." | Path B | Adds evidence without pipeline rewrite |
| "We need an EHDS-oriented technical evidence story." | Path C | Connects provenance + audit artifacts |
| "We need a user-facing assistant on private data." | Path D | Adds controlled RAG and source-grounded answers |

## 2) Buyer-level decision cues

- Choose **Path A** if stakeholder confidence is low and you need a low-risk first commitment.
- Choose **Path B** if governance pressure is immediate but engineering bandwidth is limited.
- Choose **Path C** if compliance and quality teams need concrete technical artifacts for reviews.
- Choose **Path D** if business value depends on knowledge access and analyst productivity.

## 3) Technical prerequisites checklist

### Path A

- Access to one representative dataset
- One target Ferrum API/data flow
- Demo environment (on-prem, cloud, or hybrid) agreed

### Path B

- Existing Nextflow/Snakemake work directory available
- HELIOS execution environment identified
- Output artifact retention location defined

### Path C

- Ferrum provenance/export process selected
- HELIOS evidence outputs included in release process
- Compliance stakeholders aligned on "evidence tooling" framing

### Path D

- Approved source corpus list
- Data classification and access roles defined
- Citation/grounding acceptance criteria agreed

## 4) Typical combined rollout sequence

Most customers adopt in this order:

1. **Path A** for quick technical proof
2. **Path B** for operational integration
3. **Path C** for compliance-facing evidence readiness
4. **Path D** for scaled user-facing knowledge workflows

If governance urgency is highest, start with **Path B + C** and run **Path A** as a scoped technical baseline in parallel.

After selecting a path, use the [Workshop Playbook](workshop-playbook.md) to produce a 2-week proof plan and stakeholder-ready deliverables.
