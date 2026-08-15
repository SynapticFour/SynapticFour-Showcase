# Evaluate HEAD of `main`

This Showcase is a public git history. **The product surface for due diligence is the tip of `main`**, not archaeology.

## Why this note exists

Commits from before the honesty pass can still contain:

- a genomic HELIOS fixture that listed `CLIN-ACCESS-001`
- CI job names that sounded like a live customer stack
- docs that called horizon checklists “signed off” as if they were customer sites
- a well-known demo sidecar token applied as a silent default

HEAD **rejects** those claims (honesty gates, unit tests, fixture vs live table). We **do not rewrite** public git history: rewriting would destroy reviewable provenance and force every fork to re-clone.

Gitleaks still scans **history**. Finding an old fixture or the well-known demo token string in an old blob is expected; it is not a current default.

## What to run

```bash
git checkout main && git pull
make integration-suite          # fixture spine (= GitHub Actions)
# live stack (Docker + siblings at PINNED_VERSIONS.txt):
#   make checkout-pins && make up
```

Pins, tokens, and HELIOS vacuous-check rules: [DEMO.md](../../DEMO.md) · [SECURITY.md](../../SECURITY.md) · [helios-report-example.honesty.json](../../demo/results/helios-report-example.honesty.json)
