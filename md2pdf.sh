#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Uso: $0 [opcoes] <arquivo.md> [saida.pdf]"
  echo "Opcoes:"
  echo "  --avoid-table-page-break   Evita que tabelas e titulos sejam divididos entre paginas"
  echo "Exemplo:"
  echo "  $0 --avoid-table-page-break requisitos-migracao-infraestrutura.md"
}

AVOID_BREAK=0
INPUT_MD=""
OUTPUT_PDF=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --avoid-table-page-break)
      AVOID_BREAK=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [ -z "$INPUT_MD" ]; then
        INPUT_MD="$1"
      elif [ -z "$OUTPUT_PDF" ]; then
        OUTPUT_PDF="$1"
      else
        echo "Erro: Argumento invalido: $1"
        usage
        exit 1
      fi
      shift
      ;;
  esac
done

if [ -z "$INPUT_MD" ]; then
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

if [ ! -f "$INPUT_MD" ]; then
  INPUT_MD="$SCRIPT_DIR/$INPUT_MD"
fi

if [ ! -f "$INPUT_MD" ]; then
  echo "Erro: arquivo markdown nao encontrado: $INPUT_MD"
  exit 1
fi

if [ -z "$OUTPUT_PDF" ]; then
  BASENAME="$(basename "${INPUT_MD}")"
  OUTPUT_PDF="$SCRIPT_DIR/output/${BASENAME%.md}.pdf"
fi

if [ ! -f "$CSS_FILE" ]; then
  echo "Erro: CSS nao encontrado: $CSS_FILE"
  exit 1
fi

PANDOC_ARGS=(
  "--from=gfm"
  "--to=html5"
  "--standalone"
  "--embed-resources"
  "--resource-path=$(dirname "$INPUT_MD")"
  "--metadata" "title=$(basename "${INPUT_MD%.md}")"
  "--css" "$CSS_FILE"
)

if [ "$AVOID_BREAK" -eq 1 ]; then
  AVOID_CSS="$SCRIPT_DIR/avoid-page-break.css"
  if [ -f "$AVOID_CSS" ]; then
    PANDOC_ARGS+=("--css" "$AVOID_CSS")
  fi
fi

mkdir -p "$(dirname "$OUTPUT_PDF")"

TMP_HTML="$(mktemp "${TMPDIR:-/tmp}/md2pdf-vscode.XXXXXX.html")"
trap 'rm -f "$TMP_HTML"' EXIT

pandoc "$INPUT_MD" "${PANDOC_ARGS[@]}" --output "$TMP_HTML"

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
