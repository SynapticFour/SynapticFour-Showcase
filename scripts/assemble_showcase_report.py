#!/usr/bin/env python3
"""Merge Ferrum-GA4GH-Demo outputs + HELIOS export into showcase-report.json."""
from __future__ import annotations

import argparse
import json
from datetime import UTC, datetime
from pathlib import Path
from typing import Any


def _read_json(path: Path) -> dict[str, Any] | None:
    if not path.is_file():
        return None
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return None


def _benchmark_summary(bench: dict[str, Any] | None) -> dict[str, Any]:
    if not bench:
        return {}
    out: dict[str, Any] = {}
    for key in ("precision", "recall", "f1_score", "f1", "runtime_seconds", "runtime"):
        if key in bench and bench[key] is not None:
            out[key] = bench[key]
    return out


def _helios_summary(helios_path: Path | None) -> dict[str, Any]:
    if helios_path is None or not helios_path.is_file():
        return {}
    data = _read_json(helios_path)
    if not data:
        return {"report_path": str(helios_path), "parse_error": True}
    checks = data.get("checks") or []
    passed = sum(1 for c in checks if c.get("status") in ("pass", "info"))
    warned = sum(1 for c in checks if c.get("status") == "warn")
    failed = sum(1 for c in checks if c.get("status") == "fail")
    return {
        "report_path": str(helios_path),
        "run_id": data.get("run_id"),
        "pipeline_name": data.get("pipeline_name"),
        "executor": data.get("executor"),
        "checks_total": len(checks),
        "checks_passed": passed,
        "checks_warned": warned,
        "checks_failed": failed,
    }


def _display_pipeline_name(helios: dict[str, Any], wes_engine: str | None) -> str:
    raw = str(helios.get("pipeline_name") or "").strip()
    if raw and raw.lower() != "unknown-pipeline":
        return raw
    if wes_engine:
        return f"tiny_hc_{wes_engine}"
    return "tiny_hc_pipeline"


def _write_markdown_report(path: Path, report: dict[str, Any]) -> None:
    demo = report.get("demo", {})
    helios = report.get("helios", {})
    benchmark = demo.get("benchmark", {})
    lines = [
        "# Showcase Report",
        "",
        f"- Generated: `{report.get('generated_at', 'n/a')}`",
        f"- WES run: `{demo.get('wes_run_id', 'n/a')}`",
        f"- Engine: `{demo.get('wes_engine', 'n/a')}`",
        f"- Pipeline: `{helios.get('pipeline_name_display', helios.get('pipeline_name', 'n/a'))}`",
        "",
        "## Benchmark",
        "",
        f"- Precision: `{benchmark.get('precision', 'n/a')}`",
        f"- Recall: `{benchmark.get('recall', 'n/a')}`",
        f"- F1: `{benchmark.get('f1_score', benchmark.get('f1', 'n/a'))}`",
        f"- Demo elapsed (s): `{demo.get('pipeline_elapsed_seconds', 'n/a')}`",
        "",
        "## HELIOS",
        "",
        f"- Run ID: `{helios.get('run_id', 'n/a')}`",
        f"- Checks total: `{helios.get('checks_total', 'n/a')}`",
        f"- Passed / Warned / Failed: `{helios.get('checks_passed', 'n/a')} / {helios.get('checks_warned', 'n/a')} / {helios.get('checks_failed', 'n/a')}`",
        "",
    ]
    m2 = report.get("m2", {})
    if m2:
        lines.extend(
            [
                "## M2 Downstream (bioresearch-assistant)",
                "",
                f"- Status: `{m2.get('status', 'n/a')}`",
                f"- Handoff file: `{m2.get('handoff_path', 'n/a')}`",
                f"- Query VCF: `{m2.get('query_vcf', 'n/a')}`",
                f"- Import status: `{m2.get('import_status', 'not_run')}`",
                f"- Imported DRS object: `{m2.get('drs_object_id', 'n/a')}`",
                f"- Link status (M2.2): `{m2.get('link_status', 'not_run')}`",
                f"- Phenopacket pseudonym: `{m2.get('phenopacket_pseudonym_id', 'n/a')}`",
                "",
            ]
        )
    path.write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--showcase-root", type=Path, required=True)
    parser.add_argument("--demo-root", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--helios-report", type=Path, default=None)
    parser.add_argument("--demo-seconds", type=float, default=None)
    parser.add_argument("--helios-seconds", type=float, default=None)
    parser.add_argument("--markdown-output", type=Path, default=None)
    args = parser.parse_args()

    demo_root = args.demo_root.resolve()
    metrics = _read_json(demo_root / "results" / "metrics.json")
    benchmark = _read_json(demo_root / "results" / "benchmark.json")
    drs_micro = _read_json(demo_root / "results" / "drs_micro.json")
    m2_root = args.showcase_root.resolve() / "artifacts" / "m2"
    m2_handoff_path = m2_root / "m2-handoff.json"
    m2_import_path = m2_root / "m2-import-result.json"
    m2_link_path = m2_root / "m2-link-result.json"
    m2_handoff = _read_json(m2_handoff_path)
    m2_import = _read_json(m2_import_path)
    m2_link = _read_json(m2_link_path)

    wes_run_id = (metrics or {}).get("wes_run_id")
    wes_engine = (metrics or {}).get("wes_engine")

    helios_summary = _helios_summary(args.helios_report)
    helios_summary["pipeline_name_display"] = _display_pipeline_name(helios_summary, wes_engine)

    report: dict[str, Any] = {
        "schema_version": 1,
        "generated_at": datetime.now(UTC).isoformat().replace("+00:00", "Z"),
        "paths": {
            "showcase_root": str(args.showcase_root.resolve()),
            "demo_root": str(demo_root),
        },
        "demo": {
            "wes_run_id": wes_run_id,
            "wes_engine": wes_engine,
            "pipeline_elapsed_seconds": (metrics or {}).get("pipeline_elapsed_seconds"),
            "metrics_path": str(demo_root / "results" / "metrics.json"),
            "benchmark": _benchmark_summary(benchmark),
            "drs_micro_keys": list(drs_micro.keys()) if isinstance(drs_micro, dict) else None,
        },
        "helios": helios_summary,
        "steps": [],
    }
    if isinstance(m2_handoff, dict):
        report["m2"] = {
            "status": m2_handoff.get("status"),
            "handoff_path": str(m2_handoff_path),
            "query_vcf": (m2_handoff.get("artifacts") or {}).get("query_vcf"),
            "bra_root": (m2_handoff.get("bioresearch_assistant") or {}).get("root"),
            "bra_start_attempted": (m2_handoff.get("bioresearch_assistant") or {}).get(
                "start_attempted"
            ),
        }
    if isinstance(m2_import, dict):
        report.setdefault("m2", {})
        report["m2"]["import_status"] = m2_import.get("status")
        report["m2"]["import_result_path"] = str(m2_import_path)
        report["m2"]["drs_object_id"] = m2_import.get("drs_object_id")
    if isinstance(m2_link, dict):
        report.setdefault("m2", {})
        report["m2"]["link_status"] = m2_link.get("status")
        report["m2"]["link_result_path"] = str(m2_link_path)
        report["m2"]["phenopacket_pseudonym_id"] = m2_link.get("pseudonym_id")

    if args.demo_seconds is not None:
        report["steps"].append(
            {
                "name": "ferrum_ga4gh_demo",
                "status": "ok",
                "elapsed_seconds": round(args.demo_seconds, 3),
            }
        )
    if args.helios_seconds is not None:
        report["steps"].append(
            {
                "name": "helios_audit",
                "status": "ok",
                "elapsed_seconds": round(args.helios_seconds, 3),
            }
        )

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2), encoding="utf-8")
    md_output = args.markdown_output or args.output.with_suffix(".md")
    md_output.parent.mkdir(parents=True, exist_ok=True)
    _write_markdown_report(md_output, report)
    print(
        json.dumps(
            {
                "ok": True,
                "wrote": str(args.output.resolve()),
                "wrote_markdown": str(md_output.resolve()),
            }
        )
    )


if __name__ == "__main__":
    main()
