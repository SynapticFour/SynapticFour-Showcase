# Observability baseline — pilot one-pager

**Audience:** operators standing up Ferrum ± Solum pilots
**Status:** 2026-08-12 · org level-up **D8**
**Depth pack:** [H2 observability README](../internal/pilots/observability/README.md) · [prometheus-alerts.yml](../internal/pilots/observability/prometheus-alerts.yml)

---

## What exists today

Ferrum does **not** ship a Prometheus `/metrics` exporter as a product surface. The supported baseline is:

1. **HTTP health probes** (`/health`, `/ready` where exposed)
2. Optional **Prometheus blackbox** scraping those URLs
3. Thin **curl checks** from [H2-OPS-RUNBOOK](../pilots/H2-OPS-RUNBOOK.md) §5
4. Solum sidecar **consent status** probe (authenticated)

Same pattern works on bare metal, Hetzner, Azure, Alibaba, AWS VPC, or air-gapped LAN.

---

## Minimum probes

| Target | Check | Fail when |
|--------|-------|-----------|
| Ferrum gateway | `GET /health` | non-200 or `status` not ok for 2m |
| Ferrum ready | `GET /ready` | non-200 (if routed) |
| Solum sidecar | consent status healthcheck | non-200 for 2m |
| Reverse proxy | 5xx rate | above site threshold |

---

## Minimum alerts

| Alert | Severity |
|-------|----------|
| Gateway down | critical |
| Health degraded (disk/clock) | warning |
| Solum unreachable | critical |
| Proxy 5xx high | warning |
| Disk low (from health JSON) | warning |

---

## Pilot checklist

- [ ] Health URLs documented for the site
- [ ] Blackbox **or** cron curls installed
- [ ] Alert destination (email/PagerDuty/…) named
- [ ] On-call = customer unless Enterprise SOW says otherwise ([support-tiers.md](support-tiers.md))

---

## Explicit non-goals (until a buyer pays for them)

- Full APM / distributed tracing product
- Synaptic Four–hosted Grafana
- Inventing Ferrum `/metrics` before a contractual need

---

## Related

- [disaster-recovery.md](disaster-recovery.md) · H2 [H2-OPS-RUNBOOK.md](../pilots/H2-OPS-RUNBOOK.md)
