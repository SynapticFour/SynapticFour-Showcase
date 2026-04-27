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
  "wes_run_id": "01CI00SHOWCASE00000000000000",
  "wes_engine": "nextflow",
  "pipeline_elapsed_seconds": 42
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
  "object_id": "drs://ferrum.local/01CI00SHOWCASE00000000000000/query.vcf.gz",
  "size": 901,
  "checksums": [{"type": "sha-256", "checksum": "c332b43a..."}]
}
```

**Was das bedeutet:** Ferrum's DRS-Endpunkt hat das Ergebnis-VCF als adressierbares, verifizierbares Objekt registriert. Partner-Institutionen mit GA4GH-kompatiblen Systemen können dieses Objekt direkt referenzieren.

---

### showcase-report-example.md — Menschenlesbare Zusammenfassung

→ [Beispiel ansehen](showcase-report-example.md)

Das ist das Dokument das Sie nach einem Lauf an Stakeholder schicken können — kein technisches Log, eine verständliche Zusammenfassung.

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

**drs-link-example.json:** Ferrum's DRS endpoint registered the result VCF as an addressable, verifiable object. Partner institutions with GA4GH-compatible systems can reference this directly.

**showcase-report-example.md:** The document you can send to stakeholders after a run.

---

## Run the demo yourself

→ [DEMO.md](../../DEMO.md)

---

*Synaptic Four · Stuttgart, Germany · [synapticfour.com](https://synapticfour.com/en)*
