# H2 observability baseline (Prometheus blackbox + alerts)

**Horizon:** H2 second-pass §B
**Default deployment:** **on-prem** (or customer VPC). This pack does **not** require AWS, Azure, or any public cloud.

Ferrum does **not** expose Prometheus `/metrics` today. Operators scrape **HTTP health** via blackbox (or cron curls from [H2-OPS-RUNBOOK.md](../H2-OPS-RUNBOOK.md) §5).

---

## Scrape targets

| Target | Probe | Success |
|--------|-------|---------|
| Ferrum gateway | `GET http://<gw>:8080/health` | HTTP 200; JSON `status` is `ok` (warn if `degraded`) |
| Ferrum ready | `GET http://<gw>:8080/ready` | HTTP 200 (if route exposed) |
| Solum sidecar | `GET <sidecar>/v1/consent/status?subject=healthcheck&purpose=care_provision` + `X-Solum-Sidecar-Token` | HTTP 200 |
| Reverse proxy | access-log 5xx rate | Site-defined threshold |

Example Prometheus blackbox module (`http_2xx`) + static configs:

```yaml
# snippets/prometheus-scrape.yml — illustrative; adapt to site Prometheus
scrape_configs:
  - job_name: ferrum-health
    metrics_path: /probe
    params:
      module: [http_2xx]
    static_configs:
      - targets: ["http://127.0.0.1:8080/health"]
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackbox-exporter:9115
```

---

## Alerts (minimum set)

| Alert | Condition | Severity |
|-------|-----------|----------|
| `FerrumGatewayDown` | health probe fail for 2m | critical |
| `FerrumHealthDegraded` | `/health` JSON `status==degraded` (clock/disk) for 5m | warning |
| `SolumSidecarUnreachable` | consent status probe fail for 2m | critical |
| `ProxyHttp5xxHigh` | reverse-proxy 5xx rate above site SLO | warning |
| `FerrumDiskLow` | `/health` `disk.warn_low_space` true | warning |

Example alert rules: [prometheus-alerts.yml](prometheus-alerts.yml).

---

## Honesty

- This is a **baseline**, not an SRE platform. Prefer blackbox over inventing Ferrum `/metrics` until a buyer needs counters.
- Works the same on bare metal, Hetzner, Azure, Alibaba, AWS, or air-gapped LAN — only URLs and TLS terminate change.
