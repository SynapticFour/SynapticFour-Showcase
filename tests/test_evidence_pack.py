"""Evidence pack required-file behaviour."""

from __future__ import annotations

import json
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

import evidence_pack as ep  # noqa: E402


class LoadJsonTests(unittest.TestCase):
    def test_missing_optional_is_none(self) -> None:
        self.assertIsNone(ep._load_json(Path("/no/such/file.json"), required=False))

    def test_invalid_required_raises(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            p = Path(tmp) / "bad.json"
            p.write_text("{not json", encoding="utf-8")
            with self.assertRaises(SystemExit):
                ep._load_json(p, required=True)

    def test_valid_required(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            p = Path(tmp) / "ok.json"
            p.write_text('{"a": 1}\n', encoding="utf-8")
            self.assertEqual(ep._load_json(p, required=True), {"a": 1})


class HarvestAllPassedTests(unittest.TestCase):
    def test_missing_all_passed_is_unknown_not_true(self) -> None:
        sys.path.insert(0, str(ROOT / "scripts"))
        # Replicate the Python snippet contract used by harvest-co-deploy.sh
        data = {"summary": {"ran": 0, "skipped": 1, "errors": 0}}
        s = data.get("summary") if isinstance(data.get("summary"), dict) else {}
        ap = s.get("all_passed")
        if ap is True:
            label = "true"
        elif ap is False:
            label = "false"
        else:
            label = "unknown"
        self.assertEqual(label, "unknown")


class PinFileTests(unittest.TestCase):
    def test_pinned_versions_parseable(self) -> None:
        text = (ROOT / "PINNED_VERSIONS.txt").read_text(encoding="utf-8")
        keys = []
        for line in text.splitlines():
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            k, v = line.split("=", 1)
            keys.append(k.strip())
            self.assertTrue(v.strip(), f"empty pin for {k}")
        for required in (
            "Ferrum-GA4GH-Demo",
            "HELIOS",
            "Solum-Demo",
            "Solum-tag",
        ):
            self.assertIn(required, keys)


if __name__ == "__main__":
    unittest.main()
