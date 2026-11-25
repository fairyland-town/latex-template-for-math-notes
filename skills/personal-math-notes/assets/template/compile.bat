@echo off
chcp 65001 >nul
echo ============================================
echo   正在编译数学笔记（XeLaTeX，共两遍）...
echo ============================================
xelatex -interaction=nonstopmode main.tex > compile.log 2>&1
xelatex -interaction=nonstopmode main.tex >> compile.log 2>&1
findstr /C:"^!" compile.log > errors.log 2>&1
if exist errors.log (
  for %%F in (errors.log) do if %%~zF GTR 0 (
    echo [警告] 编译中出现错误，请查看 errors.log
  ) else (
    echo [完成] main.pdf 已生成
  )
) else (
  echo [完成] main.pdf 已生成
)
echo 提示：也可在 VS Code 中用 LaTeX Workshop 直接编译 main.tex
pause
