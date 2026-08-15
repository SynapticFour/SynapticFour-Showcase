## Summary

-

## Honesty check

- [ ] I did not describe fixture CI as a live Ferrum/HELIOS/Solum run
- [ ] I did not add CLIN-ACCESS-001 to `fixtures/ci/helios/report.json` (clinical plane is `fixtures/ci/solum/`)
- [ ] README / demo artefact text still matches the JSON I committed
- [ ] `PINNED_VERSIONS.txt` was updated only if published artefacts changed (golden path is pin-strict)
- [ ] Live Solum commands do not rely on a silent demo token (`SHOWCASE_USE_DEMO_SIDECAR_TOKEN=1` or `SOLUM_SIDECAR_TOKEN`)
