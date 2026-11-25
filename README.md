# 我的专属数学笔记 LaTeX 模板

基于 [tex_template_r_2025_gbk](https://github.com/sulovemel/tex_template_r_2025_gbk) 学习、重构而来：保留了原模板"彩色定理环境 + 章节文件夹 + 中英文通用"的骨架，
修复了旧版 `framed` 方案"定理框内不能放图片、易出错"的问题，改为 `tcolorbox`（可跨页、框内可插图），
并把所有"专属于你"的设置收拢到 **一个文件** `personal.tex`。

## 一分钟上手

1. 修改 `personal.tex`：标题、副标题、姓名、课程、学期、配色、定理环境名称（改成英文即得英文版）。
2. 双击 `compile.bat`，或在终端执行：
   ```bash
   xelatex main.tex
   xelatex main.tex   # 第二遍生成目录与交叉引用
   ```
3. 打开生成的 `main.pdf`。

要求：TeX Live 2022+（已验证 2025），编译引擎 **XeLaTeX**。

## 目录结构

```
数学笔记模板/
├── main.tex              # 主文件：编译全部章节
├── personal.tex          # ★ 唯一需要改的个人配置（标题/姓名/配色/定理名称）
├── compile.bat           # 一键编译脚本（Windows）
├── config/
│   ├── packages.tex      # 宏包与页面设置（一般不用动）
│   ├── mathmacros.tex    # 数学快捷命令库（可追加自己的命令）
│   ├── theorems.tex      # 彩色定理环境（可跨页、可放图）
│   └── cover.tex         # 封面 + 前言 + 目录 + 页眉页脚
├── chapters/
│   ├── 01-demo/chap.tex      # 完整示例章（含所有环境与命令演示）
│   └── 00-template/chap.tex  # 空白章模板（复制即用）
├── figures/              # 图片统一放这里，正文只写文件名
├── preview/              # 示例 PDF 各页预览图 + 配色效果图.png / 配色效果图.pdf
└── main.pdf              # 示例成品
```

## 写新笔记

1. 复制 `chapters/00-template/` 为 `chapters/02-xxx/`，编辑其中的 `chap.tex`。
2. 在 `main.tex` 中取消对应 `\include{chapters/02-xxx/chap}` 的注释。
3. 也可以在该章节目录内单独运行 `xelatex chap.tex` 快速预览（模板已内置判断，不会重复加载导言区）。

## 编号规则

| 环境 | 是否编号 | 说明 |
| --- | --- | --- |
| `definition` 定义 | 独立编号 | 按节编号，如定义 1.2.1 |
| `theorem` 定理 | 共用编号 | 定理 / 引理 / 推论 / 准则共用一套编号 |
| `lemma` 引理 | 共用编号 | 同上 |
| `corollary` 推论 | 共用编号 | 同上 |
| `criterion` 准则 | 共用编号 | 同上 |
| `proposition` 命题 | 独立编号 | 按节编号 |
| `example` 例 | 独立编号 | 按节编号 |
| `remark` 注释 | 不编号 | 可带可选标题 |
| `proof` 证明 | 不编号 | amsthm 环境，自动 \qed |
| `solution` 解 | 不编号 | 标题为"解" |

所有环境都支持可选标题，例如：

```latex
\begin{theorem}[拉格朗日中值定理]
  若 $f$ 在 $[a,b]$ 上连续、在 $(a,b)$ 内可导，则存在 $\xi\in(a,b)$ 使得
  \[ f'(\xi)=\frac{f(b)-f(a)}{b-a}. \]
  \label{thm:lagrange}
\end{theorem}
```

## 数学快捷命令速查

| 类别 | 命令 | 效果 |
| --- | --- | --- |
| 数集 | `\R \Z \N \Q \C` | $\mathbb{R},\mathbb{Z},\mathbb{N},\mathbb{Q},\mathbb{C}$ |
| 向量 | `\bs{A}` / `\ora{AB}` | $\boldsymbol{A}$ / $\overrightarrow{AB}$ |
| 微积分 | `\d` / `\pd{f}{x}` / `\grad` / `\dive` / `\rotn` / `\curl` | $\mathrm{d}$ / 偏导 / $\nabla$ / $\operatorname{div}$ / $\operatorname{rot}$ / $\operatorname{curl}$ |
| 运算符 | `\rank \diag \tr \dist \sgn \Var \Cov` | 对应 operatorname |
| 最值 | `\argmax \argmin \esssup \ceil{} \floor{}` | argmax / argmin / ess sup / 上取整 / 下取整 |
| 范数 | `\abs{} \norm{} \inner{}{}` | $\lvert\cdot\rvert$ / $\lVert\cdot\rVert$ / $\langle\cdot,\cdot\rangle$ |
| 转置 | `A^{\T}` | $A^{\mathsf{T}}$ |
| 记号 | `\defeq` / `\pll` / `\ind{A}` / `\dx{x}` | $:=$ / $\parallel$ / 示性函数 / $\mathrm{d}x$ |
| 分段 | `\begin{ca} ... \end{ca}` | cases（可加行高 `[1.5]`） |
| 矩阵 | `\begin{pmat}` / `\begin{bmat}` / `\begin{vx}` | pmatrix / bmatrix / vmatrix（可加行高） |
| 表格 | `\tabincell{c}{a\\b}` / `\xrowht[20pt]` | 表格内换行 / 加高行距 |
| 提醒 | `\todo{重点}` / `\note{批注}` | 砖红重点标注 / 页边批注 |

自定义新命令：在 `config/mathmacros.tex` 末尾追加 `\newcommand{\你的命令}[参数个数]{定义}` 即可，全篇可用。

## 换色与中英文切换

- **中英文一键切换**：`personal.tex` 第 0 节的 `\Englishfalse` / `\Englishtrue` 是总开关。
  - 默认 `\Englishfalse` = 中文版；改成 `\Englishtrue` = 英文版，编译时**整篇结构文字自动切换**：
    封面/前言文字、日期格式、定理等环境名（`Definition` / `Theorem` …）、标题括号（`(...)`）、
    章节标题（`Chapter 1`）、目录名（`Contents`）、证明与解（`Proof` / `Solution`）。
  - 中英两套文本都写在 `personal.tex` 中，分别位于各 `\ifEnglish ... \else ... \fi` 的两个分支；要改哪版的措辞就改对应分支。
  - **只切换模板结构文字，不会翻译章节正文**——正文请用对应语言撰写。
- **配色体系**：8 个环境合并为 **5 大色系**，用"同色不同形"区分主次（完整色卡见 `preview/配色效果图.png`）：

  | 色系 | 环境 | 盒子样式 |
  | --- | --- | --- |
  | 绿 `defMain/defBg` | 定义 | 实心浅绿底 |
  | 蓝 `thmMain/thmBg/propBg` | 定理 / 命题 / 准则 | 定理实心浅蓝底；命题、准则极浅底 + `0.4pt` 细外框 |
  | 紫 `corMain/corBg` | 推论 / 引理 | 推论浅紫底；引理白底 + `0.4pt` 紫色细外框 |
  | 米灰 `exMain` | 例题 | 纯白底 + `2.5pt` 左竖线（长例题不染花页面） |
  | 砖红 `remMain/remBg` | 注释 | 实心浅红底 |

- **换色**：只需改 `personal.tex` 第 2 节的色值（如 `thmMain`、`propBg`）；主色 `themeMain` 控制封面、页眉、超链接。盒子的边框/底色分级在 `config/theorems.tex`（一般不用动）。
- **英文版**：只需把开关设为 `\Englishtrue`（见上），正文写英文即可，不需要换文档类；`ctexbook` 在英文模式下可正常排版。

## 相比原模板的改进

1. **单一配置入口**：个人信息、配色、定理名称全在 `personal.tex`，正文不再散落配置。
2. **更稳的定理框**：`tcolorbox` 替代 `framed`，支持跨页、框内放图、圆角与左侧色条。
3. **页面更紧凑**：行距 1.45、页眉页脚自动生成、目录与交叉引用可靠。
4. **命令库扩充**：新增 `\argmax`、`\norm`、`\inner`、`\ceil`、`\pmat` 等常用命令。
5. **配套 Skill**：安装后可直接对 WorkBuddy 说"用我的数学笔记模板写一篇 XX 笔记"。

## 许可与致谢

原模板出自 [知乎专栏文章](https://zhuanlan.zhihu.com/p/604236564)（作者：到底），仓库 `tex_template_r_2025_gbk` 声明可供学习使用。
本重构版本仅供个人学习与写作使用。
