# AI conventions for this math notes template

This file tells any AI assistant how to work with this LaTeX math-notes template. Read it together with `README.md` and `chapters/01-demo/chap.tex` before writing or editing content.

## Project layout

- `main.tex` — root file; starts with `\def\allfiles{}` and `\include`s each chapter. Add a line here when adding a chapter.
- `personal.tex` — the ONLY personal config file: title, author, course, language switch, colors, environment names. Never put personal metadata in chapters.
- `config/packages.tex` — packages, geometry, header/footer (do not edit unless necessary).
- `config/mathmacros.tex` — math shortcuts; append new `\newcommand` definitions here.
- `config/theorems.tex` — colored theorem environments and counters (do not add other theorem-style files).
- `config/cover.tex` — cover, foreword, TOC, page style.
- `chapters/NN-topic/chap.tex` — chapter content; keeps the `\ifx\allfiles\undefined ... \fi` wrapper so it compiles both included and standalone.
- `figures/` — all images; reference by filename only.
- `preview/` — sample pages and color charts.

## Writing rules

1. Use existing environments, never invent boxes:
   - `definition`, `proposition`, `example` — independent numbering (per section).
   - `theorem`, `lemma`, `corollary`, `criterion` — SHARED counter (continuous numbering).
   - `remark`, `proof`, `solution` — unnumbered.
   - All box environments accept an optional bracket title: `\begin{theorem}[Name] ... \end{theorem}`.
2. Boxes are `tcolorbox`-based: page-breakable, figures allowed inside. Do not switch to other box packages.
3. Use `\label` inside environments and `\ref` for cross references. Compile twice.
4. Prefer template macros over verbose LaTeX: `\R \Z \N \Q \C`, `\bs{}`, `\ora{}`, `\d`, `\pd{}{}`, `\grad`, `\dive`, `\rotn`, `\curl`, `\abs{}`, `\norm{}`, `\inner{}{}`, `\argmax`, `\argmin`, `\ceil{}`, `\floor{}`, `\defeq`, `\ind{}`, `\dx{}`, `A^{\T}`; environments `ca` (cases), `pmat`, `bmat`, `vx` (all accept an optional `[row-height]`); `\tabincell{c}{a\\b}`, `\xrowht[20pt]`, `\todo{}`, `\note{}`.
5. Do not redefine built-in commands. Environment names must not collide with commands (`pm`/`bm` collide with `\pm`/`\bm`; use `pmat`/`bmat`).

## Language switch

`personal.tex` line 11: `\Englishfalse` = Chinese, `\Englishtrue` = English. It switches ALL structural text (cover, foreword, date, environment names, title brackets `（...）` vs `(...)`, chapter headings `Chapter N`, TOC `Contents`, Proof/Solution). It does NOT translate body text — when writing English notes, write the body in English too. Keep both language variants in their `\ifEnglish ... \else ... \fi` branches when adding metadata.

## Colors (FINAL — do not change unless asked)

5 color families, "same color, different shape":
- Green (`defMain/defBg`) = definition, solid light fill.
- Blue (`thmMain/thmBg/propBg`) = theorem (solid light fill), proposition & criterion (pale fill + 0.4pt thin border).
- Purple (`corMain/corBg`) = corollary (light fill), lemma (white + 0.4pt thin border).
- Beige-gray (`exMain`) = example, plain white + 2.5pt left bar only.
- Brick red (`remMain/remBg`) = remark, solid light fill.

Color values live in section 2 of `personal.tex`; box style tiers live in `config/theorems.tex`. `themeMain` controls cover, headers and hyperlinks.

## Workflow for AI tasks

- New note: copy `chapters/00-template/` to `chapters/NN-topic/`, set `\chapter{...}`, write body with proper environments, add `\include` to `main.tex`.
- Figures: generate with TikZ `standalone`, compile to PDF, convert with `pdftoppm -png -r 220 -singlefile`, put PNG in `figures/`. Always `\clip` the canvas to avoid oversized bounding boxes.
- Verify: compile twice with `xelatex -interaction=nonstopmode main.tex`; grep log for `^!` or `LaTeX Error`; confirm page count with `pdfinfo`; render previews with `pdftoppm -png -r 110 main.pdf preview/page`.
- Never overwrite personal content in `personal.tex` (title/author/colors) unless the user asks.

## Version control

Repository: https://github.com/fairyland-town/latex-template-for-math-notes
Commit per chapter; chapter files are plain text with readable diffs. Push with `git push origin main`.
