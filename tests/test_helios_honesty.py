"""Honesty gates for HELIOS fixtures and committed demo artefacts."""

from __future__ import annotations

import json
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

from lib.helios_honesty import (  # noqa: E402
    genomic_report_is_honest,
    helios_honesty,
    honesty_sidecar_document,
)


class HeliosHonestyTests(unittest.TestCase):
    def test_fixture_genomic_report_has_no_clinical_check(self) -> None:
        path = ROOT / "fixtures/ci/helios/report.json"
        data = json.loads(path.read_text(encoding="utf-8"))
        ok, msg = genomic_report_is_honest(data)
        self.assertTrue(ok, msg)
        self.assertNotIn("CLIN-ACCESS-001", [c.get("check_id") for c in data["checks"]])

    def test_example_report_empty_inputs_are_visible(self) -> None:
        path = ROOT / "demo/results/helios-report-example.json"
        data = json.loads(path.read_text(encoding="utf-8"))
        honesty = helios_honesty(data)
        self.assertFalse(honesty["input_files_recorded"])
        self.assertIn("SEC-CONTAINER-001", honesty["vacuous_checks"])
        readme = (ROOT / "demo/results/README.md").read_text(encoding="utf-8")
        self.assertIn("input_files", readme)
        self.assertIn("empty", readme.lower())
        self.assertIn("containers_scanned", readme)
        sidecar = ROOT / "demo/results/helios-report-example.honesty.json"
        self.assertTrue(sidecar.is_file(), "signed HELIOS example must have an honesty sidecar")
        side = json.loads(sidecar.read_text(encoding="utf-8"))
        self.assertTrue(side.get("signed_report_unmodified"))
        self.assertTrue(side.get("not_a_provenance_certificate"))
        self.assertEqual(side.get("honesty"), honesty)
        # Do not mutate the signed export: honesty lives only in the sidecar.
        self.assertNotIn("not_a_provenance_certificate", data)

    def test_vacuous_zero_containers(self) -> None:
        data = {
            "checks": [
                {
                    "check_id": "SEC-CONTAINER-001",
                    "status": "pass",
                    "evidence": {"containers_scanned": "0"},
                }
            ],
            "input_files": [],
        }
        honesty = helios_honesty(data)
        self.assertEqual(honesty["vacuous_checks"], ["SEC-CONTAINER-001"])
        self.assertFalse(honesty["input_files_recorded"])

    def test_clinical_smuggle_rejected(self) -> None:
        data = {
            "checks": [
                {
                    "check_id": "CLIN-ACCESS-001",
                    "status": "pass",
                    "evidence": {"fixture": True},
                }
            ]
        }
        ok, _ = genomic_report_is_honest(data)
        self.assertFalse(ok)

    def test_sidecar_document_does_not_claim_certificate(self) -> None:
        data = {"checks": [], "input_files": []}
        doc = honesty_sidecar_document("demo/results/helios-report-example.json", data)
        self.assertTrue(doc["signed_report_unmodified"])
        self.assertTrue(doc["not_a_provenance_certificate"])
        self.assertFalse(doc["honesty"]["input_files_recorded"])


if __name__ == "__main__":
    unittest.main()
