#!/usr/bin/env bash
# Exporta las filminas a PDF y PPTX usando la imagen oficial de Marp (incluye Chromium).
# Uso:  ./scripts/export.sh [pdf|pptx]   (por defecto: pdf)
set -eu
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FMT="${1:-pdf}"
mkdir -p "$ROOT/dist"
chmod 777 "$ROOT/dist"
for md in "$ROOT"/unidades/*/filminas.md; do
  unidad="$(basename "$(dirname "$md")")"
  echo "→ $unidad.$FMT"
  docker run --rm --init --cap-add=SYS_ADMIN \
    -v "$ROOT:/home/marp/app" -v "$ROOT/dist:/out" \
    marpteam/marp-cli:latest --no-stdin "unidades/$unidad/filminas.md" \
    "--$FMT" --allow-local-files -o "/out/$unidad.$FMT" < /dev/null
done
echo "✓ Exportado a dist/*.$FMT"
