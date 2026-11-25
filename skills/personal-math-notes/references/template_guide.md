# 数学笔记模板详细指南

## 文件职责

| 文件 | 作用 | 用户可否修改 |
| --- | --- | --- |
| `main.tex` | 主文件；第一行为 `\def\allfiles{}`；按顺序 `\include` 章节 | 增删 `\include` 行 |
| `personal.tex` | 标题、副标题、作者、课程、学期、日期、前言、**5 色系颜色值**、定理名称 | ★ 主要修改点 |
| `config/packages.tex` | 宏包、几何、行距、页眉页脚、hyperref（使用 `themeMain`） | 一般不动 |
| `config/mathmacros.tex` | 数学快捷命令与自定义环境 | 追加 `\newcommand` |
| `config/theorems.tex` | tcolorbox 三级盒子样式（`*style`）、计数器、证明/解 | 一般不动 |
| `config/cover.tex` | 封面、前言、目录、正文页码初始化 | 一般不动 |
| `chapters/NN-*/chap.tex` | 章节内容；带 `\ifx\allfiles\undefined` 包装 | ★ 写作点 |
| `figures/` | 图片；正文 `\includegraphics{文件名}` | 放图片 |
| `compile.bat` | Windows 一键编译（两遍 xelatex） | 直接用 |

## 环境编号规则

- `definition`：按 section 独立编号（定义 1.2.1）。
- `theorem` / `lemma` / `corollary` / `criterion`：共用 `noteThm` 计数器，按 section 重置。
- `proposition`、`example`：各自独立，按 section 编号。
- `remark`、`proof`、`solution`：不编号。
- 所有 box 环境支持可选标题：`\begin{theorem}[名称] ... \end{theorem}`。
- box 内可放 `figure`、公式、`\label`；可跨页（tcolorbox `breakable`）。

## 配色体系（已定稿：5 大色系 + 同色不同形）

颜色值定义在 `personal.tex` 第 2 节（后缀 `*Main` 主色 / `*Bg` 底色）；盒子的边框与底色分级定义在 `config/theorems.tex` 的 `defstyle/thmstyle/corstyle/remstyle/propstyle/critstyle/lemstyle/exstyle`。换色只改 `personal.tex`，样式一般不动。

| 色系 | 环境 | 盒子样式 |
| --- | --- | --- |
| 绿 `defMain/defBg` | 定义 | 实心浅底 |
| 蓝 `thmMain/thmBg/propBg` | 定理 / 命题 / 准则 | 定理实心浅蓝底；命题、准则极浅蓝底 + `0.4pt` 细外框 |
| 紫 `corMain/corBg` | 推论 / 引理 | 推论浅紫底；引理白底 + `0.4pt` 紫色细外框 |
| 米灰 `exMain`（`exBg` 备用） | 例题 | 纯白底 + `2.5pt` 左竖线，其余三边 `0pt` 完全敞开（Evan Chen 风格） |
| 砖红 `remMain/remBg` | 注释 | 实心浅底 |

- proof / solution 标题色统一指向 `thmMain`（蓝色无框）。
- 配色示意图：`preview/配色效果图.png` / `.pdf`，源文件 `preview/color-scheme.tex`；改色后在该目录执行 `xelatex color-scheme.tex` 即可刷新。色卡表中白底显示为 `FFFFFF`（底层仍用颜色名 `white`）。

## 宏命令速查

数集：`\R \Z \N \Q \C`
向量/箭头：`\bs{}` `\ora{}`
微积分：`\d`（直体 d）`\pd{f}{x}` `\grad` `\dive` `\rotn` `\curl`
运算符：`\rank \diag \tr \dist \sgn \Var \Cov \argmax \argmin \esssup`
上下取整/绝对值：`\ceil{} \floor{} \abs{} \norm{} \inner{}{}`
记号：`\defeq` `\pll` `\ind{}` `\dx{}` `A^{\T}`
环境：`ca`(cases) `pmat`(pmatrix) `bmat`(bmatrix) `vx`(vmatrix)，都可带 `[行高倍数]`
表格：`\tabincell{c}{a\\b}` `\xrowht[20pt]`
提醒：`\todo{文字}`（砖红） `\note{页边批注}`
布局：`\myspace{n}`（空 n 行）

## 编译流程

```bash
xelatex -interaction=nonstopmode main.tex
xelatex -interaction=nonstopmode main.tex
# 检查：grep -E "^!|LaTeX Error" main.log
# 预览：pdftoppm -png -r 110 main.pdf preview/page
```

单章预览：在该章目录执行 `xelatex chap.tex`（模板自动判断，不重复加载导言区），完成后清理中间文件。

## 关键约定与坑

1. `personal.tex` 必须在 `config/packages.tex` 之前 `\input`，否则 hyperref 的 `linkcolor=themeMain` 找不到颜色。也因此 **tcolorbox 样式不能写进 `personal.tex`**（读入时 tcolorbox 尚未加载，会报样式未定义），样式必须留在 `config/theorems.tex`。
2. `main.tex` 必须有 `\def\allfiles{}`；否则被包含的章节会误判为独立编译，重复 `\documentclass` 并因相对路径错误而失败。
3. 环境名不能与已有命令冲突：`pm`/`bm` 会与 `\pm`/`\bm` 冲突；模板已用 `pmat`/`bmat`。
4. 定理环境统一用 `config/theorems.tex`（tcolorbox），不要另建其他定理样式文件。
5. 生成插图：TikZ `standalone` 编译为 PDF 后转 PNG；一定要 `\clip` 限定画布，否则 `pdftoppm` 得到的图片会被曲线包围盒拉成长条。
6. 中英文切换：`personal.tex` 第 0 节的 `\Englishfalse` / `\Englishtrue` 是总开关。切到 `\Englishtrue` 即整篇结构文字变英文（封面/前言/日期、环境名、括号、章节标题 `Chapter N`、目录名 `Contents`、证明/解），中英两套文本都在各 `\ifEnglish ... \else ... \fi` 分支里。开关**不翻译正文**，正文需自己写对应语言。不需要改 `ctexbook` 文档类。
7. 目录/引用需编译两遍；若出现 `??` 引用，再跑一遍 xelatex。

## 生成图片的可靠命令

```bash
cat > fig.tex <<'EOF'
\documentclass[tikz,border=8pt]{standalone}
\begin{document}
\begin{tikzpicture}
  \clip (-6.6,-1.55) rectangle (6.9,1.55);
  \draw[->] (-6.6,0)--(6.8,0) node[right]{$x$};
  \draw[->] (0,-1.6)--(0,1.6) node[above]{$y$};
  \draw[domain=-6.3:6.3,samples=160] plot (\x,{sin(\x r)});
\end{tikzpicture}
\end{document}
EOF
xelatex -interaction=nonstopmode fig.tex
pdftoppm -png -r 220 -singlefile fig.pdf figures/my-figure
```
