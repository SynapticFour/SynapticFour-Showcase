# PINNED_VERSIONS — monthly cadence (G7)

**Owner:** eng / founder
**Cadence:** Align with [`MONTHLY-GATES-CALENDAR`](https://github.com/SynapticFour/synapticfour-business/blob/main/strategy/org-level-up/MONTHLY-GATES-CALENDAR.md) (first business Monday CET).

## Steps

1. From Showcase root: `./scripts/refresh-pinned-versions.sh` (or update SHAs manually).
2. Run `make preflight` (or CI) against refreshed pins when practical.
3. Commit `PINNED_VERSIONS.txt` with message `chore: refresh PINNED_VERSIONS (YYYY-MM)`.
4. Note the month in the business monthly gates log.

## Policy

See [DEPENDENCY-POLICY.md](DEPENDENCY-POLICY.md). Do not pin customer forks or unpublished local commits in the public file.
