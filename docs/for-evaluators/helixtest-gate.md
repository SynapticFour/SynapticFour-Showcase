# HelixTest gate (optional Evidence Pack input)

HelixTest is a **separate** conformance CLI (`helixtest`). Showcase never vendors it; the Evidence Pack may **optionally** include a HelixTest JSON report.

## Minimal live endpoints (Ferrum-GA4GH-Demo)

With the demo stack up, the gateway is on host port **18080** (see evaluator kit):

| Service | URL |
|---------|-----|
| DRS service-info | `http://127.0.0.1:18080/ga4gh/drs/v1/service-info` |
| WES service-info | `http://127.0.0.1:18080/ga4gh/wes/v1/service-info` |

Smoke check:

```bash
curl -sS http://127.0.0.1:18080/ga4gh/drs/v1/service-info | head
curl -sS http://127.0.0.1:18080/ga4gh/wes/v1/service-info | head
```

## Wiring into Showcase Evidence Pack

```bash
# Sibling checkout
# ../HelixTest  (or SHOWCASE_HELIXTEST_ROOT)

# Best-effort DRS+WES scores (does not fail the pack if HelixTest is missing,
# unless --require-helixtest):
SHOWCASE_RUN_HELIXTEST=1 ./scripts/evidence-pack.sh

# Or supply a pre-generated report:
SHOWCASE_HELIXTEST_JSON=/path/to/scores.json ./scripts/evidence-pack.sh
```

Fixture mode uses `fixtures/ci/helixtest/scores-example.json` (not a live run).

## Full suite (not default in Showcase)

For a full conformance campaign against Ferrum, use HelixTest’s own docs:

```bash
cd ../HelixTest
cargo build --release -p helixtest-cli   # see HelixTest README for exact package name
helixtest --all --mode ferrum --report scores
```

Showcase deliberately does **not** run `--all` inside the Evidence Pack by default (runtime/CI cost). The pack accepts whatever JSON you provide.

## Pin

Optional sibling pin in `PINNED_VERSIONS.txt` as `HelixTest=<sha>` when you refresh pins. Not required for `--fixtures`.
