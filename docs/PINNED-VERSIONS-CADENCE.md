# PINNED_VERSIONS — monthly cadence (G7)

**Owner:** eng / founder
**Cadence:** First business Monday CET, aligned with the operator pin refresh.

## Steps

1. From Showcase root: `./scripts/refresh-pinned-versions.sh` **after** a published artefact refresh (or update SHAs to match `demo/verification/`).
2. Run `make check-pins` (warn) and `make preflight` (strict) against sibling checkouts.
3. Commit `PINNED_VERSIONS.txt` with message `chore: refresh PINNED_VERSIONS (YYYY-MM)` only when artefacts were regenerated.
4. Note the month in the business monthly gates log.

`make up` **fails** if Ferrum-GA4GH-Demo or HELIOS HEAD drifted from these SHAs, unless `SHOWCASE_ALLOW_PIN_DRIFT=1`. Use `make checkout-pins` to reproduce published artefacts. `make check-pins --strict` is the same gate. `make preflight` still reports drift as informational (so fixture-only evaluators are not blocked).

## Policy

See [DEPENDENCY-POLICY.md](DEPENDENCY-POLICY.md). Do not pin customer forks or unpublished local commits in the public file.
