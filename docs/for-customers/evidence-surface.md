# Evidence surface (Ferrum · Solum · BRA → HELIOS → Showcase)

**Status:** 2026-08-12 · org plan **F7** (canonical diagram for evidence notes)

```mermaid
flowchart LR
  subgraph Custody
    F[Ferrum DRS/WES<br/>solum_subject metadata]
    S[Solum sidecar<br/>consent + subject-link + audit]
    B[BRA Phenopacket<br/>phenopacket_id]
  end
  subgraph Evidence
    H[HELIOS<br/>SEC-CONTAINER + CLIN-ACCESS]
    P[Showcase Evidence Pack<br/>MANIFEST SHA-256]
  end
  B -->|optional subject-link| S
  F -->|consent poll H2.1| S
  S -->|solum-audit-helios-chain-v1| H
  F -->|demo artefacts| H
  H --> P
  S -->|stage / CDR / subject-link fixtures| P
```

**Honesty:** Evidence Packs and HELIOS reports are **technical artefacts**, not certificates.

**Operator join key:** [Ferrum subject-bridge runbook](https://github.com/SynapticFour/Ferrum/blob/main/docs/solum-subject-bridge-runbook.md)
