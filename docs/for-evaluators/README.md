# For Evaluators

Technical deep-dive materials for **engineering / security reviewers**.

Procurement / purchasing should use the customer short path instead — do not mix the two:

- **Procurement:** [../for-customers/procurement-short-path.md](../for-customers/procurement-short-path.md)
- **This kit:** reproducible checks, deployment paths, HelixTest

---

- [Technical Evaluation Kit](technical-evaluation-kit.md) — steps, checks, resources
- [Evaluate HEAD](evaluate-at-head.md) — due diligence surface is `main` tip, not git archaeology
- [Deployment and integration paths](deployment-paths.md) — Path A–E detail
- [HelixTest gate](helixtest-gate.md) — optional Evidence Pack input (gateway :18080)
- Evidence Pack (customer honesty): [../for-customers/evidence-pack.md](../for-customers/evidence-pack.md)
- Consent gate W3: [../for-customers/consent-gate.md](../for-customers/consent-gate.md)
- Evidence-chain notes (maintainers): [../internal/IMPLEMENTATION-PLAN-EVIDENCE-CHAIN.md](../internal/IMPLEMENTATION-PLAN-EVIDENCE-CHAIN.md)
- Customer context: [Which path fits me?](../for-customers/which-path.md) · [Scenarios](../for-customers/scenarios.md)
- Solum companion (local interactive + smokes): [Solum-Demo](https://github.com/SynapticFour/Solum-Demo) · `make smoke-all` · [COVERAGE](https://github.com/SynapticFour/Solum-Demo/blob/main/docs/COVERAGE.md) · Showcase orchestration: `make solum-stage`
- Identity / Passports co-deploy: sibling [Ferrum-GA4GH-Demo](https://github.com/SynapticFour/Ferrum-GA4GH-Demo) `./run --with-infra` · Showcase `make co-deploy-harvest` · [COVERAGE](https://github.com/SynapticFour/Ferrum-GA4GH-Demo/blob/main/docs/COVERAGE.md) (not default golden path)
- Try map: [../for-customers/start-here.md](../for-customers/start-here.md)
- Genomic Demo evidence: [Ferrum-GA4GH-Demo COVERAGE](https://github.com/SynapticFour/Ferrum-GA4GH-Demo/blob/main/docs/COVERAGE.md) · `make smoke-evidence`
