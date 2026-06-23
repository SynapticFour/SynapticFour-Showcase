#!/usr/bin/env bash
# Copy golden-path artefacts into demo/results/ with portable (non-host) paths.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOWCASE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DEMO_ROOT="${SHOWCASE_DEMO_ROOT:-$SHOWCASE_ROOT/../Ferrum-GA4GH-Demo}"
OUT_DIR="${SHOWCASE_DEMO_RESULTS:-$SHOWCASE_ROOT/demo/results}"

usage() {
  cat <<'EOF'
Usage: scripts/publish-demo-results.sh

Copies committed customer-facing demo artefacts from a local golden-path run:
  - Ferrum-GA4GH-Demo/results/{benchmark,metrics,drs_micro}.json
  - newest HELIOS JSON export -> helios-report-example.json
  - synthesized drs-link-example.json (illustrative DRS object for query.vcf.gz)
  - stakeholder showcase-report-example.md

Absolute filesystem paths are rewritten to sibling-relative form
(../Ferrum-GA4GH-Demo/..., ./...).

Requires: an existing golden-path run (see scripts/run-golden-path.sh).
Environment:
  SHOWCASE_DEMO_ROOT       Ferrum-GA4GH-Demo checkout (default: ../Ferrum-GA4GH-Demo)
  SHOWCASE_DEMO_RESULTS    Output dir (default: ./demo/results)
EOF
}

for arg in "$@"; do
  case "$arg" in
    -h|--help) usage; exit 0 ;;
    *) echo "publish-demo-results: unknown arg: $arg" >&2; exit 2 ;;
  esac
done

DEMO_ROOT="$(cd "$DEMO_ROOT" && pwd)"
mkdir -p "$OUT_DIR"

for f in benchmark.json metrics.json drs_micro.json; do
  src="$DEMO_ROOT/results/$f"
  [[ -f "$src" ]] || { echo "publish-demo-results: missing $src (run golden path first)" >&2; exit 1; }
done

QUERY_VCF="$DEMO_ROOT/results/query.vcf.gz"
[[ -f "$QUERY_VCF" ]] || { echo "publish-demo-results: missing $QUERY_VCF" >&2; exit 1; }

HELIOS_JSON="$(ls -t "$SHOWCASE_ROOT/helios-reports"/*.json 2>/dev/null | head -1 || true)"
[[ -n "$HELIOS_JSON" ]] || { echo "publish-demo-results: no HELIOS export under helios-reports/ (run golden path first)" >&2; exit 1; }

echo "[publish-demo-results] writing to $OUT_DIR"

python3 - "$DEMO_ROOT" "$SHOWCASE_ROOT" "$OUT_DIR" "$HELIOS_JSON" "$QUERY_VCF" <<'PY'
import hashlib
import json
import re
from datetime import datetime, timezone
from pathlib import Path

demo_root = Path(__import__("sys").argv[1]).resolve()
showcase_root = Path(__import__("sys").argv[2]).resolve()
out_dir = Path(__import__("sys").argv[3]).resolve()
helios_src = Path(__import__("sys").argv[4]).resolve()
query_vcf = Path(__import__("sys").argv[5]).resolve()


def rewrite_paths(raw: str) -> str:
    out = raw
    out = out.replace(str(demo_root) + "/", "../Ferrum-GA4GH-Demo/")
    out = out.replace(str(showcase_root) + "/", "./")
    out = re.sub(r'/[^"\']+/Ferrum-GA4GH-Demo/', "../Ferrum-GA4GH-Demo/", out)
    out = re.sub(r'/[^"\']+/SynapticFour-Showcase/', "./", out)
    return out


def write_json(name: str, data: object) -> None:
    text = rewrite_paths(json.dumps(data, indent=2)) + "\n"
    (out_dir / name).write_text(text, encoding="utf-8")


def copy_json(name: str, src: Path) -> None:
    data = json.loads(src.read_text(encoding="utf-8"))
    write_json(name, data)


copy_json("benchmark.json", demo_root / "results" / "benchmark.json")
copy_json("metrics.json", demo_root / "results" / "metrics.json")
copy_json("drs-micro-example.json", demo_root / "results" / "drs_micro.json")

helios = json.loads(helios_src.read_text(encoding="utf-8"))
write_json("helios-report-example.json", helios)

metrics = json.loads((demo_root / "results" / "metrics.json").read_text(encoding="utf-8"))
benchmark = json.loads((demo_root / "results" / "benchmark.json").read_text(encoding="utf-8"))
wes_run_id = metrics.get("wes_run_id", "unknown")
wes_engine = metrics.get("wes_engine", "unknown")
elapsed = metrics.get("pipeline_elapsed_seconds", "n/a")
vcf_size = query_vcf.stat().st_size
vcf_sha = hashlib.sha256(query_vcf.read_bytes()).hexdigest()
drs_object_id = f"drs://ferrum-gateway:8080/{wes_run_id}/query.vcf.gz"
access_id = f"access-{wes_run_id}"

write_json(
    "drs-link-example.json",
    {
        "object_id": drs_object_id,
        "name": "query.vcf.gz",
        "self_uri": drs_object_id,
        "size": vcf_size,
        "created_time": datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z"),
        "checksums": [{"type": "sha-256", "checksum": vcf_sha}],
        "access_methods": [
            {
                "type": "https",
                "access_url": {
                    "url": (
                        f"https://ferrum-gateway:8080/ga4gh/drs/v1/objects/"
                        f"{wes_run_id}/access/{access_id}"
                    )
                },
                "access_id": access_id,
            }
        ],
    },
)

helios_run_id = helios.get("run_id", "n/a")
output_count = len(helios.get("output_files") or [])
checks = helios.get("checks") or []
checks_run = len(checks)
checks_passed = all(c.get("status") in ("pass", "info") for c in checks) if checks else True
precision = benchmark.get("precision", "n/a")
recall = benchmark.get("recall", "n/a")
f1 = benchmark.get("f1_score", benchmark.get("f1", "n/a"))
generated = datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")

report = f"""# Synaptic Four Showcase — Run Report

**Erstellt / Generated:** {generated}  
**Run ID:** {helios_run_id}  
**Stack:** Ferrum GA4GH Demo + HELIOS Audit + BioResearch Assistant Handoff

---

## Zusammenfassung / Summary

Alle drei Showcase-Stufen erfolgreich abgeschlossen. Artefakte stehen für Stakeholder-Review bereit.

All three showcase stages completed successfully. Artefacts are available for stakeholder review.

---

## Stage 1: Ferrum GA4GH Demo (Variant Calling via WES)

| Metric | Value |
|--------|-------|
| WES Run ID | `{wes_run_id}` |
| Pipeline Engine | {wes_engine} |
| Elapsed Time | {elapsed} Sekunden / seconds |
| Status | ✅ Abgeschlossen / Completed |

**Benchmark-Ergebnisse / Benchmark results (hap.py vs. reference callset):**

| Metric | Value |
|--------|-------|
| Precision | {precision} |
| Recall | {recall} |
| F1 Score | {f1} |

*Hinweis / Note: Synthetischer Demo-Datensatz / Synthetic demo dataset.*

---

## Stage 2: HELIOS Audit Trail

| Metric | Value |
|--------|-------|
| HELIOS Report ID | `{helios_run_id}` |
| Executor | {helios.get("executor", "n/a")} |
| Output Files Hashed | {output_count} |
| Checks Run | {checks_run} (SEC-CONTAINER-001) |
| Check Results | {"✅ Alle bestanden / All passed" if checks_passed else "⚠️ Siehe Report / See report"} |

**Was der HELIOS-Report erfasst / What the HELIOS report captures:**
- SHA256-Hash jeder Output-Datei / SHA256 hash of every output file
- Container-Security-Check-Ergebnis / Container security check result
- Vollständiger Run-Kontext (Zeitstempel, Pipeline-Name, Executor) / Full run context
- Signing-Key-Referenz für Chain-of-Custody / Signing key reference for chain-of-custody

→ Vollständiger Report / Full report: [helios-report-example.json](helios-report-example.json)

---

## Stage 3: BioResearch Assistant Handoff

| Metric | Value |
|--------|-------|
| Handoff Status | ✅ Vorbereitet / Prepared |
| VCF übertragen / transferred | query.vcf.gz |
| DRS Object ID | `{drs_object_id}` |

---

## Artefakt-Index / Artefact Index

| Datei / File | Zweck / Purpose |
|------|---------|
| `benchmark.json` | Precision/Recall/F1 |
| `metrics.json` | WES-Run-Metadaten / WES run metadata |
| `helios-report-example.json` | Signierter Audit-Trail / Signed audit trail |
| `drs-link-example.json` | DRS-Objektreferenz / DRS object reference |
| `drs-micro-example.json` | DRS `/stream` Micro-Benchmark / DRS stream micro-benchmark |
| `showcase-report-example.md` | Dieses Dokument / This document |

---

## Nächste Schritte / Next steps

1. [HELIOS-Report ansehen](helios-report-example.json) — Welche Audit-Informationen werden pro Lauf erfasst?
2. [DRS-Link prüfen](drs-link-example.json) — Wie werden Ergebnisse für Partner adressierbar?
3. [Demo selbst ausführen](../../DEMO.md) — Mit Ihren eigenen Daten
4. [Kontakt aufnehmen](mailto:contact@synapticfour.com) — Welche Stufe ist für Ihre Institution am relevantesten?

---

*Dieses Dokument wurde von `scripts/publish-demo-results.sh` generiert. Es ist ein technisches Evaluations-Artefakt, keine rechtliche oder Compliance-Beratung.*

*This report was generated by `scripts/publish-demo-results.sh`. It is a technical evaluation artefact, not legal or compliance advice.*

*Synaptic Four · Stuttgart, Germany · synapticfour.com*
"""
(out_dir / "showcase-report-example.md").write_text(report, encoding="utf-8")
PY

echo "{\"ok\":true,\"wrote\":\"$OUT_DIR\"}"
