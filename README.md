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

## Estrutura de Diretórios

- `workspace/`: Diretório de trabalho (ignorado pelo Git). Coloque seus arquivos `.md` e pastas de imagens (ex: `assets/`) aqui.
  - `workspace/example/`: Pasta contendo arquivos Markdown de exemplo que servem como suíte de demonstração/teste (esta pasta não é ignorada pelo Git).
- `output/`: Diretório onde os arquivos PDF convertidos são salvos por padrão (ignorado pelo Git).

## Uso

No diretório raiz do projeto:

```bash
./md2pdf.sh workspace/seu_arquivo.md
```

Isso gerará o PDF na pasta `output/`, com o mesmo nome do arquivo original (ex: `output/seu_arquivo.pdf`).

Você também pode passar a flag `--avoid-table-page-break` se quiser que o script tente manter tabelas e títulos sempre unidos na mesma página (inserindo quebras automáticas):

```bash
./md2pdf.sh --avoid-table-page-break workspace/seu_arquivo.md
```

Para definir uma saída customizada (ignorando a pasta `output/`):

```bash
./md2pdf.sh workspace/seu_arquivo.md outro_diretorio/saida_customizada.pdf
```

## Exemplo

Para executar a suíte de exemplo e demonstração (contendo todos os elementos da sintaxe Markdown básica, estendida e fórmulas matemáticas):

```bash
./md2pdf.sh workspace/example/markdown-cheat-sheet.md
```

## Personalização de estilo

Edite `vscode-preview.css` para ajustar fonte, margens, tamanhos e cores.

## Observações

- Imagens locais no Markdown (ex: `![Logo](assets/logo.png)`) são suportadas e serão embutidas automaticamente no PDF final.
- O script remove cabeçalho/rodapé padrão de impressão do navegador.
- Se o `google-chrome` não estiver no `PATH`, ajuste o comando no `md2pdf.sh`.
