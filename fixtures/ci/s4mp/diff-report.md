# S4MP port-diff (Showcase fixture)

> **Honesty:** This is a committed **fixture** for SynapticFour-Showcase CI and Evidence Pack demos.
> It is **not** a live `s4 diff` / `make diff` run, **not** a certificate, and **not** proof of
> Java↔Rust equivalence. S4MP `s4 certify` remains a stub.

## Scope (narrative)

| Side | Alias (illustrative) | Role |
|------|----------------------|------|
| Java | `gatk-java-hc` | GATK4 HaplotypeCaller slice (reference method) |
| Rust | `hc-rust` / gatk-rs | Alpha Rust HC port under evaluation |

## What a live S4MP report would contain

- Graph summaries for Java and Rust sources
- Heuristic symbol / call-graph mappings
- A Markdown diff of unmatched / partially matched regions

## Showcase attachment policy

- Attach as Evidence Pack sidecar (`role: s4mp_port_diff`) with SHA-256 in `MANIFEST.json`
- Do **not** invoke S4MP as a WES/TES executor
- Prefer fixtures in CI; optional copy of `.s4/reports/diff-report.md` when an evaluator already produced one

## Maturity

`maturity: heuristic-map-not-certified`
