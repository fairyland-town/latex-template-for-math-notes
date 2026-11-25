---
name: personal-math-notes
description: This skill should be used when the user asks to write, continue, or compile math notes in LaTeX — e.g. "用我的数学笔记模板写一篇 XX 笔记", "帮我把这段讲义整理成 LaTeX 笔记", "给我的笔记加一个定理/例题", "编译我的数学笔记", or requests in English such as "write math notes with my LaTeX template". It applies a personal math-notes template with colored theorem boxes, shared numbering, a Chinese/English toggle, and a single-file config (personal.tex); a portable full copy is bundled in assets/template/.
agent_created: true
---

# Personal Math Notes（专属数学笔记模板）

## Overview

Maintain and extend the user's personal LaTeX math-notes system. It features colored `tcolorbox` theorem environments (page-breakable, images allowed), one-file personal configuration, an expanded math macro library, a Chinese/English language toggle, and chapter folders that compile both together and standalone.

## Template locations

- **Current project (preferred):** if the user is already inside a project that has `main.tex` and `personal.tex`, work there directly.
- **Portable copy (fallback):** `assets/template/` inside this skill — copy the whole directory to a new working folder and compile there when no project is present.

Before writing, read `personal.tex` (title, author, colors, theorem-name macros) and `config/mathmacros.tex` (available shortcuts). Respect the user's existing choices; do not overwrite personal content.

## Workflow

### 1. Decide the target

- User wants to start a new topic → copy `chapters/00-template/chap.tex` into a new folder `chapters/NN-shortname/chap.tex`, set the chapter title, add `\include{chapters/NN-shortname/chap}` to `main.tex` at the right position.
- User wants to edit existing notes → locate the chapter under `chapters/`, read it first, then make targeted edits.
- User only wants a preview/PDF → skip to step 4.

### 2. Write content using the template conventions

- Prefer the template's environments over raw `\textbf`: `definition`, `theorem`, `lemma`, `corollary`, `criterion`, `proposition`, `remark`, `example`, `proof`, `solution`. All accept an optional bracket title, e.g. `\begin{theorem}[拉格朗日中值定理]`.
- Numbering: definition independent; theorem/lemma/corollary/criterion share one counter; proposition and example independent; remark/proof/solution unnumbered. Add `\label{...}` inside an environment for cross references.
- Use macros from `config/mathmacros.tex` instead of verbose LaTeX: `\R \Z \N \Q \C`, `\bs{}`, `\ora{}`, `\d`, `\pd{}{}`, `\grad`, `\dive`, `\rotn`, `\curl`, `\abs{}`, `\norm{}`, `\inner{}{}`, `\argmax`, `\argmin`, `\ceil{}`, `\floor{}`, `\defeq`, `\ind{}`, `\dx{}`, `\T`, `ca`/`pmat`/`bmat`/`vx` environments, `\tabincell`, `\xrowht`, `\todo{}`, `\note{}`.
- Put images in `figures/` and reference by filename only. For new plots, generate via TikZ `standalone` → PDF → `pdftoppm -png -r 220 -singlefile` (remember `\clip` to keep the bounding box tight).
- To add reusable shortcuts, append `\newcommand` definitions to `config/mathmacros.tex`; do not redefine built-in commands — check for collisions (e.g. never name an environment `pm` or `bm`, which collide with `\pm`/`\bm`). A working `pmat`/`bmat` naming is already in place.
- Keep personal metadata out of chapters: title/author/colors/theorem names belong in `personal.tex`.
- Colors are FINAL (5 color families: green=definition, blue=theorem/proposition/criterion, purple=corollary/lemma, beige-gray=example, brick-red=remark) with "same color, different shape" styling. Do not change or add colors unless the user explicitly asks; color values live in `personal.tex`, box styles in `config/theorems.tex`. See `references/template_guide.md` → 配色体系.
- Language toggle: `\Englishfalse` / `\Englishtrue` at the top of `personal.tex` switches all structural text (cover, foreword, dates, environment names, title brackets, chapter headings `Chapter N`, TOC `Contents`, Proof/Solution) between Chinese and English. It does NOT translate body text — write chapters in the target language. Keep both language variants in their `\ifEnglish ... \else ... \fi` branches when adding metadata.

### 3. Verify the LaTeX source

- Ensure `main.tex` starts with `\def\allfiles{}`; each chapter's `\ifx\allfiles\undefined ... \else ... \fi` wrapper must be intact so it works both included and standalone.
- Ensure `personal.tex` is `\input` before `config/packages.tex` (hyperref uses `themeMain` from personal config).
- Use `config/theorems.tex` (tcolorbox) for theorem environments; do not add other theorem-style files.

### 4. Compile and check

```bash
cd <template-root>
xelatex -interaction=nonstopmode main.tex
xelatex -interaction=nonstopmode main.tex     # second pass: TOC + refs
```

- Check exit status and grep the log for `^!` or `LaTeX Error`.
- Confirm `main.pdf` exists and its page count is plausible via `pdfinfo`.
- To render previews: `pdftoppm -png -r 110 main.pdf preview/page`.
- To preview a single chapter, run `xelatex chap.tex` inside that chapter folder; clean its `.aux/.log/.out/.pdf` afterwards unless the user wants them kept.
- Windows users can double-click `compile.bat`.

## Detailed reference

For the full environment table, macro cheat sheet, config instructions, and known pitfalls, read `references/template_guide.md` when needed. Keep SKILL.md lean; load the reference on demand.

## Bundled resources

- `assets/template/` — portable full copy of the LaTeX template (tex sources, figures, README, compile.bat). Copy this directory to bootstrap a new math-notes project.
- `references/template_guide.md` — detailed conventions, macro list, and troubleshooting notes.
