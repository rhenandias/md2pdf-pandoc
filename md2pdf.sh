#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Uso: $0 <arquivo.md> [saida.pdf]"
  echo "Exemplo:"
  echo "  $0 requisitos-migracao-infraestrutura.md"
}

if [ "${1:-}" = "" ]; then
  usage
  exit 1
fi

if ! command -v pandoc >/dev/null 2>&1; then
  echo "Erro: pandoc nao encontrado no PATH."
  exit 1
fi

if ! command -v google-chrome >/dev/null 2>&1; then
  echo "Erro: google-chrome nao encontrado no PATH."
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CSS_FILE="$SCRIPT_DIR/vscode-preview.css"
INPUT_MD="$1"

if [ ! -f "$INPUT_MD" ]; then
  INPUT_MD="$SCRIPT_DIR/$INPUT_MD"
fi

if [ ! -f "$INPUT_MD" ]; then
  echo "Erro: arquivo markdown nao encontrado: $1"
  exit 1
fi

if [ "${2:-}" = "" ]; then
  OUTPUT_PDF="${INPUT_MD%.md}.pdf"
else
  OUTPUT_PDF="$2"
fi

if [ ! -f "$CSS_FILE" ]; then
  echo "Erro: CSS nao encontrado: $CSS_FILE"
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT_PDF")"

TMP_HTML="$(mktemp "${TMPDIR:-/tmp}/md2pdf-vscode.XXXXXX.html")"
trap 'rm -f "$TMP_HTML"' EXIT
DOC_TITLE="$(basename "${INPUT_MD%.md}")"

pandoc "$INPUT_MD" \
  --from=gfm \
  --to=html5 \
  --standalone \
  --metadata "title=$DOC_TITLE" \
  --css "$CSS_FILE" \
  --output "$TMP_HTML"

HTML_URI="file://$(realpath "$TMP_HTML")"
OUTPUT_ABS="$(realpath -m "$OUTPUT_PDF")"

google-chrome \
  --headless \
  --disable-gpu \
  --allow-file-access-from-files \
  --no-sandbox \
  --no-pdf-header-footer \
  --print-to-pdf="$OUTPUT_ABS" \
  "$HTML_URI" >/dev/null 2>&1

echo "PDF gerado em: $OUTPUT_ABS"
