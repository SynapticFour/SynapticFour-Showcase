"""Honesty helpers for HELIOS reports shipped in the Showcase.

The golden-path config (helios.toml) enables a *minimal* check set so the
GRCh37 demo does not fail reference-genome checks. That is not a full
pipeline certification. These helpers make that visible in reports and CI.
"""

from __future__ import annotations

from typing import Any


CLINICAL_CHECK_IDS = frozenset({"CLIN-ACCESS-001"})


def _as_int(value: Any) -> int | None:
    if value is None:
        return None
    try:
        return int(value)
    except (TypeError, ValueError):
        return None


def helios_honesty(data: dict[str, Any] | list[Any] | None) -> dict[str, Any]:
    if not isinstance(data, dict):
        return {
            "present": False,
            "input_files_recorded": False,
            "vacuous_checks": [],
            "clinical_checks": [],
            "note": "No HELIOS report object.",
        }

    checks = data.get("checks") if isinstance(data.get("checks"), list) else []
    inputs = data.get("input_files") if isinstance(data.get("input_files"), list) else []
    vacuous: list[str] = []
    clinical: list[str] = []
    fixture_flagged: list[str] = []

    for check in checks:
        if not isinstance(check, dict):
            continue
        cid = str(check.get("check_id") or "")
        evidence = check.get("evidence") if isinstance(check.get("evidence"), dict) else {}
        if cid in CLINICAL_CHECK_IDS:
            clinical.append(cid)
        if evidence.get("fixture") is True:
            fixture_flagged.append(cid or "unknown")
        if cid == "SEC-CONTAINER-001":
            scanned = _as_int(evidence.get("containers_scanned"))
            # Empty evidence or explicit 0 containers: the check did not inspect images.
            if scanned == 0 or (not evidence and check.get("status") == "pass"):
                vacuous.append(cid)

    input_recorded = len(inputs) > 0
    notes: list[str] = []
    if not input_recorded:
        notes.append(
            "No input_files hashes in this report. Output hashes (if any) are "
            "post-run filesystem hashes, not a complete provenance of pipeline inputs."
        )
    if vacuous:
        notes.append(
            "SEC-CONTAINER-001 passed without scanning container images "
            "(containers_scanned=0 or empty evidence). That is not proof that "
            "images were pinned."
        )
    if clinical:
        notes.append(
            "This genomic HELIOS report includes CLIN-ACCESS-001. Clinical-plane "
            "evidence belongs in the Solum audit export / helios-solum.toml path, "
            "not in the default golden-path report."
        )
    if fixture_flagged:
        notes.append(
            f"Checks flagged as fixtures (not a live run): {', '.join(fixture_flagged)}."
        )
    if not notes:
        notes.append(
            "HELIOS report present. Default Showcase golden path still uses the "
            "minimal check set in helios.toml (GRCh37 demo compatibility)."
        )

    return {
        "present": True,
        "input_files_recorded": input_recorded,
        "input_file_count": len(inputs),
        "output_file_count": len(data.get("output_files") or [])
        if isinstance(data.get("output_files"), list)
        else 0,
        "vacuous_checks": vacuous,
        "clinical_checks": clinical,
        "fixture_flagged_checks": fixture_flagged,
        "pipeline_name": data.get("pipeline_name"),
        "note": " ".join(notes),
    }


def genomic_report_is_honest(data: dict[str, Any] | list[Any] | None) -> tuple[bool, str]:
    """CI gate: the *genomic* HELIOS fixture must not smuggle clinical checks."""
    honesty = helios_honesty(data)
    if honesty.get("clinical_checks"):
        return (
            False,
            "Genomic HELIOS report must not include CLIN-ACCESS-001; "
            "that belongs on the Solum / helios-solum.toml artefact.",
        )
    return True, "ok"


def honesty_sidecar_document(source: str, data: dict[str, Any]) -> dict[str, Any]:
    """Machine-readable honesty next to a signed HELIOS export (do not mutate the export)."""
    honesty = helios_honesty(data)
    return {
        "schema_version": 1,
        "source": source,
        "signed_report_unmodified": True,
        "why_sidecar": (
            "The HELIOS export is Ed25519-signed. Showcase does not add fields to it. "
            "This sidecar is the machine-readable honesty record for evaluators who "
            "only open JSON."
        ),
        "historical_export": True,
        "not_a_provenance_certificate": True,
        "honesty": honesty,
    }
