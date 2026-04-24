# Reference Use Case

This is the manufacturer-side integrated narrative: one coherent flow showing how all key pieces work together.

## Scenario

A healthcare research organization wants:

- interoperable data access and exchange,
- reproducible and auditable pipeline execution,
- a practical path to EHDS-oriented technical evidence,
- optional user-facing research assistant capabilities.

## Technical flow (what runs together)

1. **Ferrum + Ferrum-GA4GH-Demo**  
   Execute the baseline interoperable data and WES/TES flow with measurable outputs.

2. **HELIOS evidence overlay**  
   Run HELIOS on the same pipeline work/output directories to create audit and documentation artifacts.

3. **bioresearch-assistant downstream (optional)**  
   Import selected result artifacts and enable guided analysis plus RAG-assisted interpretation workflows.

4. **Provenance packaging**  
   Bundle outputs and provenance for sharing, review, and internal governance records.

## What to show in a customer meeting

- **For decision makers:** one slide on business outcome, one on risk reduction, one on phased adoption.
- **For technical evaluators:** reproducible run path, artifacts, validation checkpoints, and integration boundaries.
- **For compliance stakeholders:** what evidence is generated automatically and what remains process responsibility.

## Compliance and evidence framing

The reference use case should always state:

- generated outputs are technical evidence and traceability assets,
- they support compliance programs and audits,
- they do not replace formal legal/compliance obligations.

## Phased demonstration plan (manufacturer view)

### Phase 1 (Days 1-10): prove technical fit quickly

- Run baseline flow and capture timing + key artifacts.
- Confirm customer-specific constraints (environment, data boundaries, ownership).

### Phase 2 (Days 10-30): prove operational compatibility

- Integrate HELIOS with one real customer pipeline.
- Define evidence handoff into existing QA/release workflow.

### Phase 3 (Days 30-60): prove stakeholder readiness

- Build the EHDS-oriented technical documentation pack.
- Run a cross-functional review (engineering + quality + compliance).

### Phase 4 (Optional): deploy user-facing research assistant value

- Introduce controlled RAG on approved customer datasets.
- Validate quality and governance before wider rollout.

## Related operational docs

- Runbook and commands: [DEMO.md](../DEMO.md)
- Version pinning and reproducibility: [PINNED_VERSIONS.txt](../PINNED_VERSIONS.txt)
