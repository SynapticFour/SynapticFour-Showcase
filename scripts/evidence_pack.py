#!/usr/bin/env python3
"""Assemble a SynapticFour Showcase Evidence Pack (MANIFEST + copied artefacts).

Packs HELIOS report, DRS object metadata, optional HelixTest JSON, optional
Solum digest, and optional showcase-report into one reviewable directory.
Does not claim certification or legal compliance — see README in the pack.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import shutil
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


def _sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def _load_json(path: Path | None) -> dict[str, Any] | list[Any] | None:
    if path is None or not path.is_file():
        return None
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return None


def _drs_checksums(drs: dict[str, Any] | list[Any] | None) -> list[dict[str, str]]:
    if not isinstance(drs, dict):
        return []
    out: list[dict[str, str]] = []
    for item in drs.get("checksums") or []:
        if isinstance(item, dict) and item.get("checksum"):
            out.append(
                {
                    "type": str(item.get("type") or "sha-256"),
                    "checksum": str(item["checksum"]),
                }
            )
    return out


def _helios_summary(helios: dict[str, Any] | list[Any] | None) -> dict[str, Any]:
    if not isinstance(helios, dict):
        return {}
    checks = helios.get("checks") or []
    if not isinstance(checks, list):
        checks = []
    return {
        "run_id": helios.get("run_id"),
        "pipeline_name": helios.get("pipeline_name"),
        "executor": helios.get("executor"),
        "checks_total": len(checks),
        "checks_passed": sum(1 for c in checks if isinstance(c, dict) and c.get("status") in ("pass", "info")),
        "checks_warned": sum(1 for c in checks if isinstance(c, dict) and c.get("status") == "warn"),
        "checks_failed": sum(1 for c in checks if isinstance(c, dict) and c.get("status") == "fail"),
        "output_file_hashes": [
            {"path": f.get("path"), "sha256": f.get("sha256")}
            for f in (helios.get("output_files") or [])
            if isinstance(f, dict) and f.get("sha256")
        ],
    }


def _helixtest_summary(data: dict[str, Any] | list[Any] | None) -> dict[str, Any]:
    if not isinstance(data, dict):
        return {"present": False}
    # Accept either full --report json or --report scores shapes loosely.
    summary: dict[str, Any] = {"present": True}
    for key in ("overall_level", "overall_score", "mode", "profile", "services"):
        if key in data:
            summary[key] = data[key]
    if "scores" in data:
        summary["scores"] = data["scores"]
    if "results" in data and isinstance(data["results"], list):
        summary["results_count"] = len(data["results"])
    return summary


def _solum_summary(data: dict[str, Any] | list[Any] | None) -> dict[str, Any]:
    if not isinstance(data, dict):
        return {"present": False}
    return {
        "present": True,
        "status": data.get("status"),
        "authz_allow_ok": data.get("authz_allow_ok"),
        "authz_deny_ok": data.get("authz_deny_ok"),
        "audit_tamper_detect_ok": data.get("audit_tamper_detect_ok"),
        "product_tag_consumed_by_demo": data.get("product_tag_consumed_by_demo"),
    }


def _consent_summary(data: dict[str, Any] | list[Any] | None) -> dict[str, Any]:
    if not isinstance(data, dict):
        return {"present": False}
    return {
        "present": True,
        "decision": data.get("decision"),
        "wes_may_proceed": data.get("wes_may_proceed"),
        "consent_status": data.get("consent_status"),
        "purpose": data.get("purpose"),
        "subject": data.get("subject"),
    }


def _write_pack_readme(path: Path, manifest: dict[str, Any]) -> None:
    files = manifest.get("files") or []
    helios = manifest.get("summaries", {}).get("helios") or {}
    drs = manifest.get("summaries", {}).get("drs") or {}
    helix = manifest.get("summaries", {}).get("helixtest") or {}
    solum = manifest.get("summaries", {}).get("solum") or {}
    consent = manifest.get("summaries", {}).get("consent_gate") or {}
    lines = [
        "# Evidence Pack",
        "",
        f"- Generated: `{manifest.get('generated_at', 'n/a')}`",
        f"- Pack ID: `{manifest.get('pack_id', 'n/a')}`",
        f"- Mode: `{manifest.get('mode', 'n/a')}`",
        "",
        "## What this pack is",
        "",
        "A **stakeholder-facing bundle** of technical artefacts from a SynapticFour",
        "Showcase run (or fixtures). It is meant for engineering and compliance",
        "*review conversations* — not as a certificate.",
        "",
        "## What it proves (technical)",
        "",
        "- HELIOS audit report present with check counts and (when available) output SHA-256 hashes",
        "- DRS object metadata and declared checksums (when provided)",
        "- Optional HelixTest conformance JSON (when provided — not required for a valid pack)",
        "- Optional Solum Stage-1 digest (fail-closed authz + tamper-evident audit)",
        "- SHA-256 of every file copied into this directory (see `MANIFEST.json`)",
        "",
        "## What it does **not** prove",
        "",
        "- Formal certification, EHDS compliance, or DSGVO compliance",
        "- That a production deployment matches these demo/fixture conditions",
        "- Legal consent validity (Solum artefacts are technical purpose-binding demos only)",
        "- Continuous monitoring after the pack was generated",
        "",
        "See also: Showcase `docs/for-customers/compliance-framing.md` and",
        "`docs/for-customers/evidence-pack.md`.",
        "",
        "## Contents summary",
        "",
        f"- HELIOS run_id: `{helios.get('run_id', 'n/a')}` · checks P/W/F: "
        f"`{helios.get('checks_passed', 'n/a')}/{helios.get('checks_warned', 'n/a')}/{helios.get('checks_failed', 'n/a')}`",
        f"- DRS checksums declared: `{len(drs.get('checksums') or [])}`",
        f"- HelixTest present: `{helix.get('present', False)}`",
        f"- Solum stage present: `{solum.get('present', False)}` · status `{solum.get('status', 'n/a')}`",
        f"- Consent gate present: `{consent.get('present', False)}` · decision `{consent.get('decision', 'n/a')}`",
        "",
        "## Files",
        "",
    ]
    for entry in files:
        lines.append(
            f"- `{entry.get('name')}` — sha256 `{entry.get('sha256')}`"
            f" ({entry.get('role', 'artefact')})"
        )
    lines.append("")
    path.write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--showcase-root", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--pack-id", type=str, default=None)
    parser.add_argument("--mode", type=str, default="live", help="live | fixtures")
    parser.add_argument("--helios-report", type=Path, default=None)
    parser.add_argument("--drs-json", type=Path, default=None)
    parser.add_argument("--metrics-json", type=Path, default=None)
    parser.add_argument("--benchmark-json", type=Path, default=None)
    parser.add_argument("--helixtest-json", type=Path, default=None)
    parser.add_argument("--solum-result", type=Path, default=None)
    parser.add_argument("--consent-gate", type=Path, default=None)
    parser.add_argument("--showcase-report", type=Path, default=None)
    parser.add_argument("--showcase-report-md", type=Path, default=None)
    args = parser.parse_args()

    root = args.showcase_root.resolve()
    out = args.output_dir.resolve()
    if out.exists():
        shutil.rmtree(out)
    out.mkdir(parents=True, exist_ok=True)

    pack_id = args.pack_id or datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    sources: list[tuple[str, Path, str]] = []

    def add(role: str, path: Path | None, dest_name: str) -> None:
        if path is None:
            return
        path = path.resolve()
        if not path.is_file():
            return
        sources.append((role, path, dest_name))

    add("helios_report", args.helios_report, "helios-report.json")
    add("drs_object", args.drs_json, "drs-object.json")
    add("metrics", args.metrics_json, "metrics.json")
    add("benchmark", args.benchmark_json, "benchmark.json")
    add("helixtest", args.helixtest_json, "helixtest.json")
    add("solum_stage", args.solum_result, "solum-stage-result.json")
    add("consent_gate", args.consent_gate, "consent-gate-result.json")
    add("showcase_report", args.showcase_report, "showcase-report.json")
    add("showcase_report_md", args.showcase_report_md, "showcase-report.md")

    if not any(role == "helios_report" for role, _, _ in sources):
        raise SystemExit("evidence_pack: HELIOS report is required (--helios-report)")

    file_entries: list[dict[str, Any]] = []
    for role, src, dest_name in sources:
        dest = out / dest_name
        shutil.copy2(src, dest)
        digest = _sha256_file(dest)
        file_entries.append(
            {
                "role": role,
                "name": dest_name,
                "source": str(src),
                "sha256": digest,
                "size_bytes": dest.stat().st_size,
            }
        )

    helios_data = _load_json(out / "helios-report.json")
    drs_data = _load_json(out / "drs-object.json") if (out / "drs-object.json").is_file() else None
    helix_data = _load_json(out / "helixtest.json") if (out / "helixtest.json").is_file() else None
    solum_data = (
        _load_json(out / "solum-stage-result.json")
        if (out / "solum-stage-result.json").is_file()
        else None
    )
    consent_data = (
        _load_json(out / "consent-gate-result.json")
        if (out / "consent-gate-result.json").is_file()
        else None
    )

    manifest: dict[str, Any] = {
        "schema_version": 1,
        "pack_kind": "synapticfour-showcase-evidence-pack",
        "pack_id": pack_id,
        "generated_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
        "mode": args.mode,
        "showcase_root": str(root),
        "honesty": {
            "proves": [
                "Presence of signed/structured HELIOS audit artefacts from a run or fixture",
                "Declared DRS checksums when a DRS object JSON is included",
                "Optional HelixTest / Solum Stage-1 digests when included",
                "Integrity of files inside this pack via SHA-256 in MANIFEST.json",
            ],
            "does_not_prove": [
                "Formal certification or regulatory compliance (EHDS, DSGVO, …)",
                "Production equivalence to the demo/fixture environment",
                "Legal validity of consent (Solum demos are technical only)",
            ],
            "docs": [
                "docs/for-customers/compliance-framing.md",
                "docs/for-customers/evidence-pack.md",
            ],
        },
        "summaries": {
            "helios": _helios_summary(helios_data),
            "drs": {
                "object_id": drs_data.get("object_id") if isinstance(drs_data, dict) else None,
                "checksums": _drs_checksums(drs_data),
            },
            "helixtest": _helixtest_summary(helix_data),
            "solum": _solum_summary(solum_data),
            "consent_gate": _consent_summary(consent_data),
        },
        "files": file_entries,
    }

    (out / "MANIFEST.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    # Re-hash MANIFEST after write is intentional omission — MANIFEST describes other files.
    _write_pack_readme(out / "README.md", manifest)

    print(
        json.dumps(
            {
                "ok": True,
                "pack_id": pack_id,
                "output_dir": str(out),
                "files": len(file_entries),
                "manifest": str(out / "MANIFEST.json"),
            }
        )
    )


if __name__ == "__main__":
    main()
