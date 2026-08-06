# Demo-Ergebnisse — Was Sie hier sehen

*Sie müssen nichts installieren um diese Artefakte zu lesen. Sie stammen aus einem echten Showcase-Lauf.*

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

**Was das bedeutet:** Der Variant-Calling-Lauf im Demo-Datensatz (synthetischer GRCh37-Datensatz) erreicht volle Übereinstimmung mit dem Referenz-Callset. Dieser Wert ist für den Demo-Datensatz erwartet — er zeigt dass die Pipeline korrekt ausgeführt wird.

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

### helios-report-example.json — Signierter Audit-Trail

**Was darin steht:**
- `run_id` — eindeutige UUID des Laufs
- `pipeline_name` und `executor` — was ausgeführt wurde
- `start_time` / `end_time` — reproduzierbare Zeitstempel
- `input_files` — mit SHA256-Hash jeder Input-Datei
- `output_files` — mit SHA256-Hash jeder Output-Datei
- `checks` — welche Checks liefen und was das Ergebnis war

**Was das für Sie bedeutet:** Jeder Lauf ist unveränderlich dokumentiert. Wenn jemand sechs Monate später fragt „Mit welchen Daten und welchem Code wurde Ergebnis X erzeugt?", gibt es eine maschinenlesbare Antwort.

---

### drs-link-example.json — DRS-Objektreferenz

```json
{
  "object_id": "drs://ferrum-gateway:8080/01KV049TTY664RMPQV3M020HYB/query.vcf.gz",
  "size": 4034,
  "checksums": [{"type": "sha-256", "checksum": "8d5b3933..."}]
}
```

**Was das bedeutet:** Illustratives Beispiel, wie ein Ergebnis-VCF als adressierbares DRS-Objekt referenziert werden kann (URI-Schema und Checksummen aus einem echten Lauf). Der Demo-Workflow kopiert `query.vcf.gz` nach `results/`; automatische DRS-Registrierung des Outputs ist nicht Teil des Standard-Golden-Paths — Partner-Institutionen nutzen ingest/import oder WES-Provenance je nach Deployment.

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

*You don't need to install anything to read these artefacts. They come from a real showcase run.*

---

## The artefacts explained

**benchmark.json:** The variant calling run on the demo dataset (synthetic GRCh37) achieves full agreement with the reference callset. Expected for the demo — shows the pipeline runs correctly.

**metrics.json:** Ferrum's WES endpoint accepted the Nextflow run, executed it, and returned the run ID. This ID links the HELIOS audit trail to the WES run.

**helios-report-example.json:** Contains run_id, pipeline_name, executor, timestamps, input file hashes, output file hashes, and check results. Every run is immutably documented.

**drs-link-example.json:** Illustrative DRS object reference for the result VCF (URI scheme and checksums from a real run). The demo copies `query.vcf.gz` to `results/`; automatic DRS registration of outputs is not part of the default golden path.

**drs-micro-example.json:** DRS `/stream` micro-benchmark timings (median/p95 throughput) from the same run.

**showcase-report-example.md:** The document you can send to stakeholders after a run.

**solum-*-example.json:** Stage-1 clinical companion artefacts (allow 200 / deny 403 / `chain_broken` after harness tamper). Orchestrated via `make solum-stage`; ephemeral demo keys only.

**consent-gate-*-example.json / phenopacket-purpose-binding-example.json:** W3 technical purpose-binding gate (Solum consent before WES). Deny path skips WES. Not legal consent.

---

## Run the demo yourself

→ [DEMO.md](../../DEMO.md)

---

*Synaptic Four · Stuttgart, Germany · [synapticfour.com](https://synapticfour.com/en)*
