# SynapticFour Showcase

Customer-facing landing and technical integration showcase for Synaptic Four capabilities.

This repository is built to answer two questions at once:

- "What value do I get as a customer, and how fast can I start?"
- "How does this really work end-to-end when my technical team validates it?"

## Start Here

- **Understand customer fit first:** [Customer Personas](docs/customer-personas.md)
- **Browse practical customer questions:** [Question Catalog](docs/customer-question-catalog.md)
- **Jump to implementation paths:** [Deployment and Integration Paths](docs/deployment-integration-paths.md)
- **Pick the right path quickly in workshops:** [Decision Matrix](docs/decision-matrix.md)
- **Run customer discovery sessions consistently:** [Workshop Playbook (90 Minutes)](docs/workshop-playbook.md)
- **See the full integrated manufacturer reference flow:** [Reference Use Case](docs/reference-use-case.md)

If you only need one answer quickly, start with the question catalog and follow the "Path to answer" links.

## What This Showcase Covers

The showcase composes the core Synaptic Four building blocks into one guided customer journey:

| Capability | Primary repo | Showcase role |
|------------|--------------|---------------|
| Data platform, APIs, provenance, RO-Crate | [Ferrum](https://github.com/SynapticFour/Ferrum) | Data plane and core interoperability |
| Gold-standard GA4GH flow with reference benchmarking | [Ferrum-GA4GH-Demo](https://github.com/SynapticFour/Ferrum-GA4GH-Demo) | Demonstrable baseline with measurable outputs |
| GA4GH API behavior and conformance checks | [HelixTest](https://github.com/SynapticFour/HelixTest) | Technical trust and regression confidence |
| Pipeline evidence, signing, and auditability | [HELIOS](https://github.com/SynapticFour/HELIOS) | Compliance-ready technical evidence layer |
| Research-assistant and downstream clinical/research UX | [bioresearch-assistant](https://github.com/SynapticFour/bioresearch-assistant) | Optional RAG/interpretation-facing experience |

## Quick Paths by Common Customer Intent

- **"I only want one part of Ferrum deployed."**  
  Go to the Path A section in [Deployment and Integration Paths](docs/deployment-integration-paths.md).

- **"I need HELIOS with my existing pipelines."**  
  Go to the Path B section in [Deployment and Integration Paths](docs/deployment-integration-paths.md).

- **"How does Ferrum help with EHDS?"**  
  Go to the Path C section in [Deployment and Integration Paths](docs/deployment-integration-paths.md).

- **"If I deploy bioresearch-assistant, how do I do RAG on my own data?"**  
  Go to the Path D section in [Deployment and Integration Paths](docs/deployment-integration-paths.md).

## For Technical Teams

- **Full demo runbook (commands, artifacts, cleanup):** [DEMO.md](DEMO.md)
- **Pinned sibling revisions for reproducibility:** [PINNED_VERSIONS.txt](PINNED_VERSIONS.txt)
- **Preflight checks before live demos:** `./scripts/preflight.sh`
- **Golden path runner:** `./scripts/run-golden-path.sh`
- **Light CI checks:** `./scripts/ci-check.sh`

## Positioning

- `Ferrum-GA4GH-Demo` remains benchmark-centric and reference-measurement focused.
- `SynapticFour-Showcase` is the customer conversation layer: questions, decision paths, and end-to-end integration story.

## License

Apache-2.0.
