# Demo-Ergebnisse — Was Sie hier sehen

*Sie müssen nichts installieren um diese Artefakte zu lesen. Jede Datei sagt, ob sie aus einem Lauf stammt oder ein Fixture ist.*

[🇬🇧 English below](#english)

---

## Die Artefakte erklärt

### benchmark.json — Precision / Recall / F1

```json
{
  "precision": 0.0,
  "recall": 0.0,
  "f1_score": 0.0
}
```

**Was das bedeutet:** hap.py auf diesem synthetischen Mini-Slice (15 Aug 2026). `claim_scope` ist `pipeline_smoke`. QUERY hatte keine Calls (`QUERY.TOTAL=0`), daher F1=0. Das zeigt, dass WES→TES→GATK→hap.py durchlief — **nicht**, dass der Caller klinisch stimmt, und **nicht** F1=1.0.

---

### metrics.json — WES-Run-Metadaten

```json
{
  "wes_run_id": "01M03CB216RJ2R4T2G5N1JX3X3",
  "wes_engine": "nextflow",
  "pipeline_elapsed_seconds": 51
}
```

**Was das bedeutet:** Ferrum's WES-Endpunkt hat den Nextflow-Lauf entgegengenommen, ausgeführt und die Run-ID zurückgegeben. Diese ID verknüpft den HELIOS-Audit-Trail mit dem WES-Lauf.

---

### helios-report-example.json — HELIOS-Export (Golden-Path-Minimum)

**Was darin steht (Live-Regen 15. Aug. 2026):**
- `run_id` — UUID des Exports
- `pipeline_name`: `unknown-pipeline` (HELIOS hat den Nextflow-Namen nicht aufgelöst)
- `input_files` — Nextflow-Config und `.nextflow.log` (nicht BAM/FASTA)
- `output_files` — SHA256 von Dateien unter `results/` und Nextflow-Workdir
- `checks`: genau `SEC-CONTAINER-001` mit `"containers_scanned": "1"` — **warn**, weil `broadinstitute/gatk:4.4.0.0` ein Versions-Tag ohne `@sha256:` ist (`container_digest_required = false` in [helios.toml](../../helios.toml))
- `signature` — Ed25519 über diesen Export; Schlüssel liegen lokal unter `.cache/` (gitignored)
- Sidecar **[helios-report-example.honesty.json](helios-report-example.honesty.json)** — maschinenlesbare Honesty (das signierte JSON wird nicht verändert)

Default-Golden-Path nutzt [helios.toml](../../helios.toml): nur `SEC-CONTAINER-001`, weil das Demo-Referenzgenom GRCh37 ist. Klinische Checks (`CLIN-ACCESS-001`) gehören zu `helios-solum.toml` / Solum-Audit-Export, nicht in diesen genomischen Report.

**Was das für Sie bedeutet:** Sie sehen, dass ein HELIOS-Export nach dem WES-Lauf geschrieben wurde. GATK ist per **Versions-Tag** gepinnt, nicht per Digest. Das ist kein vollständiges Provenance-Zertifikat. Für Stakeholder-Reviews: Honesty-Sidecar lesen.

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

**benchmark.json:** hap.py on the 15 Aug synthetic mini-slice. `claim_scope` is `pipeline_smoke`. Query VCF had no calls (`QUERY.TOTAL=0`), so F1=0. That shows WES→TES→GATK→hap.py ran — not a clinical caller score, and not F1=1.0.

**metrics.json:** Ferrum's WES endpoint accepted the Nextflow run, executed it, and returned the run ID. This ID links the HELIOS audit trail to the WES run.

**helios-report-example.json:** HELIOS export after the Nextflow demo. This committed file records Nextflow config/log in `input_files` (not BAM/FASTA). `SEC-CONTAINER-001` **warns** on `broadinstitute/gatk:4.4.0.0` (version tag, no `@sha256:`). Not a provenance certificate. Machine-readable honesty: [helios-report-example.honesty.json](helios-report-example.honesty.json) (signed JSON is not mutated). Clinical `CLIN-ACCESS-001` is a separate Solum artefact (`helios-solum.toml`).

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
