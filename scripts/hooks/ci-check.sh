#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"
echo "ci-check: bash -n scripts"
shopt -s nullglob
for f in scripts/*.sh; do bash -n "$f"; done
echo "ci-check: py_compile smoke"
python3 -m compileall -q . 2>/dev/null || python3 -c "import compileall; compileall.compile_dir('.', quiet=1)"
echo "ci-check: OK"
