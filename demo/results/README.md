# Demo-Ergebnisse — Was Sie hier sehen

*Sie müssen nichts installieren um diese Artefakte zu lesen. Jede Datei sagt, ob sie aus einem Lauf stammt oder ein Fixture ist.*

[🇬🇧 English below](#english)

---

## Die Artefakte erklärt

### benchmark.json — Precision / Recall / F1

```json
{
  "precision": 1.0,
  "recall": 1.0,
  "f1_score": 1.0
}
```

**Was das bedeutet:** Der Variant-Calling-Lauf im Demo-Datensatz (synthetischer GRCh37-Mini-Callset) erreicht volle Übereinstimmung mit dem Referenz-Callset. **F1=1.0 ist für diesen Datensatz erwartet** — das zeigt, dass die Demo-Pipeline durchläuft, nicht dass ein klinischer Caller validiert wurde.

---

### metrics.json — WES-Run-Metadaten

```json
{
  "wes_run_id": "01KVTCN5H7BRXN1RS4C39PDQJ1",
  "wes_engine": "nextflow",
  "pipeline_elapsed_seconds": 115
}
```

**Was das bedeutet:** Ferrum's WES-Endpunkt hat den Nextflow-Lauf entgegengenommen, ausgeführt und die Run-ID zurückgegeben. Diese ID verknüpft den HELIOS-Audit-Trail mit dem WES-Lauf.

---

### helios-report-example.json — HELIOS-Export (Golden-Path-Minimum)

**Was darin steht (dieses committed Beispiel, 23. Jun. 2026):**
- `run_id` — UUID des Exports
- `pipeline_name`: `unknown-pipeline` (HELIOS hat den Nextflow-Namen nicht aufgelöst)
- `input_files`: **empty** — dieses Beispiel enthält **keine** Input-Hashes
- `output_files` — SHA256 von Dateien unter `results/` und Nextflow-Workdir (inkl. Cache-LOCK)
- `checks`: genau `SEC-CONTAINER-001` mit `"containers_scanned": "0"` — **vacuous pass**, kein Beweis dass Images gepinnt waren
- `signature` — Ed25519 über diesen Export; Schlüssel liegen lokal unter `.cache/` (gitignored)
- Sidecar **[helios-report-example.honesty.json](helios-report-example.honesty.json)** — maschinenlesbare Honesty (das signierte JSON wird nicht verändert)

Default-Golden-Path nutzt [helios.toml](../../helios.toml): nur `SEC-CONTAINER-001`, weil das Demo-Referenzgenom GRCh37 ist. Klinische Checks (`CLIN-ACCESS-001`) gehören zu `helios-solum.toml` / Solum-Audit-Export, nicht in diesen genomischen Report.

**Was das für Sie bedeutet:** Sie sehen, dass ein HELIOS-Export nach dem WES-Lauf geschrieben wurde. Sie sehen **nicht** eine vollständige Input-Provenance und **nicht** einen bestandenen Container-Pin-Scan. Für Stakeholder-Reviews: Honesty-Feld im Showcase-Report lesen.

---

### drs-link-example.json — DRS-Objektreferenz

```json
{
  "object_id": "drs://ferrum-gateway:8080/01KV049TTY664RMPQV3M020HYB/query.vcf.gz",
  "size": 4034,
  "checksums": [{"type": "sha-256", "checksum": "8d5b3933..."}]
}
```

**Was das bedeutet:** Illustratives DRS-URI-Schema. `ferrum-gateway:8080` ist der **Compose-interne** Hostname; vom Host ist das Gateway **:18080**. Automatische DRS-Registrierung des WES-Outputs ist nicht Teil des Default-Golden-Paths.

---

### drs-micro-example.json — DRS `/stream` Micro-Benchmark

Enthält Median/P95-Laufzeiten und Durchsatz für wiederholte `GET .../stream`-Aufrufe (siehe Ferrum-GA4GH-Demo `results/drs_micro.json`). Ergänzt `drs-link-example.json` um Performance-Kennzahlen, nicht um Objekt-Metadaten.

---

### showcase-report-example.md — Menschenlesbare Zusammenfassung

→ [Beispiel ansehen](showcase-report-example.md)

Das ist das Dokument das Sie nach einem Lauf an Stakeholder schicken können — kein technisches Log, eine verständliche Zusammenfassung.

---

### solum-*-example.json — Solum Stage-1 (klinischer Companion)

| Datei | Was sie zeigt |
|-------|----------------|
| `solum-authz-allow-example.json` | Encrypt als Dr. Amina → HTTP 200 |
| `solum-authz-deny-example.json` | Encrypt als Intern ohne Capability → HTTP 403 (fail-closed) |
| `solum-audit-verify-example.json` | Nach Harness-Tamper: `chain_broken` |
| `solum-stage-result-example.json` | Zusammenfassung für den Showcase-Report |

**Was das bedeutet:** Solum bleibt ein eigener regulatorischer Perimeter. Der Showcase orchestriert Solum-Demo nur als Companion-Stage (`make solum-stage`). Ephemeral Demo-Keys — kein Produktions-Deploy.

Live erzeugen: `make solum-stage` (optional `--` → `./scripts/run-solum-stage.sh --publish-examples`).

---

## Demo selbst ausführen

→ [DEMO.md](../../DEMO.md)

---

---

<a name="english"></a>

# Demo results — what you see here (English)

*You don't need to install anything to read these artefacts. Each file states whether it is from a live run or a fixture.*

---

## The artefacts explained

**benchmark.json:** The variant calling run on the demo dataset (synthetic GRCh37) achieves full agreement with the reference callset. Expected for the demo — shows the pipeline runs correctly.

**metrics.json:** Ferrum's WES endpoint accepted the Nextflow run, executed it, and returned the run ID. This ID links the HELIOS audit trail to the WES run.

**helios-report-example.json:** HELIOS export after the Nextflow demo. In this committed file `input_files` is **empty** and `SEC-CONTAINER-001` has `containers_scanned=0` (vacuous pass). Not a full provenance certificate. Machine-readable honesty: [helios-report-example.honesty.json](helios-report-example.honesty.json) (signed JSON is not mutated). Clinical `CLIN-ACCESS-001` is a separate Solum artefact (`helios-solum.toml`).

**drs-link-example.json:** Illustrative DRS URI. `ferrum-gateway:8080` is the Compose hostname; host port is **18080**. Automatic DRS registration of WES outputs is not part of the default golden path.

**drs-micro-example.json:** DRS `/stream` micro-benchmark timings (median/p95 throughput) from the same run.

**showcase-report-example.md:** The document you can send to stakeholders after a run.

**solum-*-example.json:** Stage-1 clinical companion artefacts (allow 200 / deny 403 / `chain_broken` after harness tamper). Orchestrated via `make solum-stage`; ephemeral demo keys only.

**consent-gate-*-example.json / phenopacket-purpose-binding-example.json:** W3 technical purpose-binding gate (Solum consent before WES). Deny path skips WES. Not legal consent.

---

## Run the demo yourself

→ [DEMO.md](../../DEMO.md)

---

*Synaptic Four · Stuttgart, Germany · [synapticfour.com](https://synapticfour.com/en)*
