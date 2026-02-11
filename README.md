# md2pdf

Ferramenta simples para converter Markdown (`.md`) em PDF com visual parecido com o preview do VSCode.

## Arquivos

- `md2pdf.sh`: script principal de conversão.
- `vscode-preview.css`: estilo aplicado ao HTML antes da impressão em PDF.

## Requisitos

- `pandoc`
- `google-chrome` (modo headless)

## Instalação (Ubuntu/Debian)

```bash
sudo apt-get install pandoc texlive-latex-base texlive-fonts-recommended texlive-extra-utils texlive-latex-extra
```

Observação: neste projeto, o PDF é gerado com `pandoc + google-chrome --headless` (não depende do LaTeX para o fluxo principal), mas manter os pacotes TeX instalados pode ser útil para fallback.

## Uso

No diretório raiz do projeto:

```bash
./md2pdf/md2pdf.sh caminho/arquivo.md
```

Isso gera o PDF no mesmo diretório do `.md`, com o mesmo nome.

Para definir saída customizada:

```bash
./md2pdf/md2pdf.sh caminho/arquivo.md caminho/saida.pdf
```

## Exemplo

```bash
./md2pdf/md2pdf.sh planning/infrastructure-migration/requisitos/requisitos-migracao-infraestrutura.md
```

## Personalização de estilo

Edite `md2pdf/vscode-preview.css` para ajustar fonte, margens, tamanhos e cores.

## Observações

- O script remove cabeçalho/rodapé padrão de impressão do navegador.
- Se o `google-chrome` não estiver no `PATH`, ajuste o comando no `md2pdf.sh`.
