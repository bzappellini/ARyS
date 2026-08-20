#!/usr/bin/env bash
# Genera las filminas HTML de todas las unidades con Marp.
# Marp autocarga marp.config.mjs (HTML habilitado + tema arys) desde la raíz.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
MARP="${MARP_BIN:-marp}"
for md in unidades/*/filminas.md; do
  out="${md%.md}.html"
  echo "→ $md"
  "$MARP" --no-stdin "$md" -o "$out" < /dev/null
done
echo "✓ Filminas generadas."
