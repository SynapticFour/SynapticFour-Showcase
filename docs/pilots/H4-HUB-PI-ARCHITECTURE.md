# H4 — Hub vs Pi architecture (Kenya pack)

**Status:** Engineering artefact (K3.2) — **no named customer site**
**Checklist:** [H4-PILOT-CHECKLIST.md](H4-PILOT-CHECKLIST.md)
**Offline policy:** [Solum H4-OFFLINE-SYNC-POLICY.md](https://github.com/SynapticFour/Solum/blob/main/docs/H4-OFFLINE-SYNC-POLICY.md)
**Ferrum Edge:** [FIELD-GA4GH-DEMO-PI.md](https://github.com/SynapticFour/Ferrum/blob/main/docs/FIELD-GA4GH-DEMO-PI.md) · [FIELD-OPS.md](https://github.com/SynapticFour/Ferrum/blob/main/docs/FIELD-OPS.md)

```text
┌──────────────────────────┐         sync / sneakernet        ┌──────────────────────────────┐
│  Pi 5 (field Edge)       │ ────────────────────────────────► │  Hub (clinic / lab / NGO)    │
│  Ferrum Edge (SQLite)    │                                   │  Ferrum (WES/TES as needed)  │
│  Solum Track A sidecar   │                                   │  Solum Track A + Track B     │
│  Capture, consent, local │                                   │  EHRbase (hub-class only)    │
│  DRS objects             │                                   │  Subject-link SoR            │
└──────────────────────────┘                                   └──────────────────────────────┘
```

## Placement rules

| Workload | Where | Why |
|----------|-------|-----|
| MinION / file capture | Pi | Field custody |
| Consent grant/revoke | Pi (local) → hub merge | Offline-first; hub authoritative on conflict |
| Crypt4GH field encrypt | Pi or hub | CustomerHeld; no master keys left on Pi long-term |
| Heavy WES / GIAB Demo | Hub | Pi is not Demo compose |
| EHRbase / FHIR CDR | Hub only | Track B hub-class (ADR 0002) |
| Subject bridge upsert | Hub after sync (or Pi cache → hub) | Join clinical ↔ genomic ids |
| Dual-write migration | Hub | Legacy HIS beside hub Sidecar |

## Stolen device / wipe

Follow Ferrum [FIELD-OPS.md](https://github.com/SynapticFour/Ferrum/blob/main/docs/FIELD-OPS.md): backup before rotation, wipe procedure, sealed storage. Revoke Edge visas; treat Pi consent store as potentially compromised until hub reconcile.

## Site gates (not done here)

- Named MoU / pilot agreement (K3.1)
- H1 checklist subset on hub before KE SoR claims (K3.3)
- Field consent reconcile drill (K3.4)
