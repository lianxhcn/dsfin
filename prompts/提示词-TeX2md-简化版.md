
帮我转换成 .md 格式。要求如下：

1. 数学公式采用 `$$` 格式。单行公式上下各空一行；
2. list 格式块上下各空一行；
3. 代码块采用 ```stata 格式，且上下各空一行；
4. 其它不确定的问题，可以询问我，确认后继续输出
5. 'stverbatim' 环境是自定义的，只需转换成 ```stata 即可。
6. '\boxtext[...]{...}{...}{% ... }' 转换成 callout 提示框即可，格式如下：
```
::: {.callout-note}
### {title}
{---text---}
:::
```
7. \chapter{} 转换成一级标题，\section{} 转换成二级标题，\subsection{} 转换成三级标题；\subsubsection{<Title4>} 转换成 '**<Title4>**'，且上下各空一行。章节无需编号
8. `\footnote{}` 格式转换成 markdown 的脚注格式，即 `[^1]`，并在文末添加对应的脚注内容。
9. 图片格式转换成 markdown 的图片格式，即 `![alt text](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/{filename.png})`，其中 `{filename.png}` 是图片的完整文件名 (包括后缀)。
10. 交叉引用 '\href{URL}{Abowd et al. (1999)}' 转换为 Markdown 超链接格式，即 `[Abowd et al. (1999)](URL)`。
11. 数学公式中的自定义字符
   - 将自定义宏 `\x` 转为 `\mathbf{x}`
   - 将自定义宏 `\betaz` 转为 `\boldsymbol{\beta}`
12. 数学公式编号：'(\ref{eq:xt-FWL-trend-01})' 源自 Latex 自动生成的公式编号；你需要在 '$${equation}$$' 格式单行公式末尾加上 '\tag{#}' 标记，其中 '#' 是公式的编号，例如 '1'、'2' 等等，按出现顺序标注。完成后，再将 '(\ref{eq:xt-FWL-trend-01})' 替换成 '(#)'，以此类推。