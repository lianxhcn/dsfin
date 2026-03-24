# Markdown

## 何谓 Markdown？

Markdown 是一种轻量级的标记语言，允许你使用易读易写的纯文本格式编写文档，然后转换成结构化的 HTML, PDF, Word 等多种格式的文档。Markdown 语法简单易学，适合用来撰写笔记、文档、幻灯片等。

大家在网上看到的很多[博客文章](https://www.lianxh.cn/details/1456.html)，程序[说明文档](https://docs.python.org/3/tutorial/index.html)，甚至是在线书籍 ([Python for Data Analysis, 3E](https://wesmckinney.com/book/))，都是用 Markdown 写的。

## 语法速览

![Markdown 语法对照](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/md-syntax-5mins-codes-preview.png){#fig-md-syntax-quick}

你可以在如下网站按部就班地学习 Markdown 的基本用法，大概五分钟后你就可以掌握常用 Markdown 语法规则了：

- <https://www.markdowntutorial.com/zh-cn>
- <https://md.doocs.org/>


## Markdown 基本语法

> Source: [markdownguide.org/cheat-sheet/](https://www.markdownguide.org/cheat-sheet/)

这份 Markdown 备忘单介绍了常用的 Markdown 语法。为了便于您快速了解基本的语法规则，这里略去了很多细节信息，详情参见：[基础语法](https://www.markdownguide.org/basic-syntax/) 和 [扩展语法](https://www.markdownguide.org/extended-syntax/)。

以下是 [John Gruber](https://en.wikipedia.org/wiki/John_Gruber) 原始设计文档中列出的基本元素，所有 Markdown 应用程序都支持这些元素。

| 元素         | Markdown 语法                                                  |
| :----------- | :------------------------------------------------------------- |
| 标题         | `# 一级标题`<br>`## 二级标题`<br>`### 三级标题`                |
| 粗体         | `**粗体文本**`                                                 |
| 斜体         | `*斜体文本*`                                                   |
| 引用块       | `> 引用内容`                                                   |
| 有序列表     | `1. 第一项`<br>`2. 第二项`<br>`3. 第三项`                      |
| 无序列表     | `- 第一项`<br>&emsp; `  -  第一条`<br>`- 第二项`<br>`- 第三项` |
| 代码高亮显示 | \`代码\` (\`xtreg\` &rarr; `xtreg`)                            |
| 水平线       | `---`                                                          |
| 链接         | `[连享会主页](https://www.lianxh.cn)`                          |
| 图片         | `![图片标题](/Fig/image.jpg)` 或 `![](图片网址)`               |

### 表格

```md
| 命令    | 范例                 |
| :------ | :------------------- |
| xtreg   | `xtreg y x, fe`      |
| reghdfe | `reghdfe y x, a(id)` |
```

| 命令    | 范例                 |
| :------ | :------------------- |
| xtreg   | `xtreg y x, fe`      |
| reghdfe | `reghdfe y x, a(id)` |


### 数学公式

- 单行数学公式用 `$$` 符号包围起来；
- 行内数学公式用 `$` 符号包围起来；
- 包围符号内侧不要有空格，否则在有些 Markdown 编辑器中无法正常显示公式
  - 正确：`$y = f(x)$`
  - 错误：`$ y = f(x) $` 或 `$y = f(x) $`
- 有关 LaTeX 数学公式的语法和工具，参见：
  - [Markdown常用LaTex数学公式](https://www.lianxh.cn/details/243.html)
  - [神器-数学公式识别工具-mathpix](https://www.lianxh.cn/details/284.html)

```markdown
模型设定为：

$$y_{it} = \alpha_i + x_{it}\beta + u_{it}$$

其中，$y_{it}$ 为被解释变量，$\alpha_i$ 为个体效应。
```

模型设定为：

$$y_{it} = \alpha_i + x_{it}\beta + u_{it}$$

其中，$y_{it}$ 为被解释变量，$\alpha_i$ 为个体效应。

### 代码块

````markdown
```python
import pandas as pd

df = pd.DataFrame({
    'A': [1, 2, 3],
    'B': [4, 5, 6]
})
```

```stata
sysuse "auto.dta", clear
regress mpg weight
display "Results: " 2 + 3
```
````

渲染效果：

```python
import pandas as pd

df = pd.DataFrame({
    'A': [1, 2, 3],
    'B': [4, 5, 6]
})
```

```stata
sysuse "auto.dta", clear
regress mpg weight
display "Results: " 2 + 3
```

### 输出为 PDF 或 HTML 文档

虽然 VScode 中有些插件 (如 `Markdown PDF`) 可以将 Markdown 文档直接导出为 PDF 或 HTML，但不够美观。我建议两种方法：

- 使用 <https://md.doocs.org/>：你只需把 Markdown 文档复制粘贴到该网站的编辑器中，就可以一键导出 PDF 或 HTML 文档了。点击右上角的「样式」按钮，你还可以选择不同的文档样式，满足不同的需求。
- 对于排版要求较高的用户，可以考虑使用 [Quarto](https://quarto.org/)，它是一个功能强大的文档编译工具，支持将 Markdown 文档转换为多种格式，包括 PDF、HTML、Word 等。使用 Quarto，你可以轻松地将 Markdown 文档编译成专业的报告、论文或幻灯片。

### 扩展阅读

  - 初虹, 2024, [让「记录」变得简单：Markdown使用详解](https://www.lianxh.cn/details/1456.html), 连享会 No.1456.
  - 初虹, 2021, [学术论文写作新武器：Markdown-上篇](https://www.lianxh.cn/details/603.html), 连享会 No.603.
  - 初虹, 2021, [学术论文写作新武器：Markdown-下篇](https://www.lianxh.cn/details/604.html), 连享会 No.604.
  - 初虹, 2021, [学术论文写作新武器：Markdown-中篇](https://www.lianxh.cn/details/605.html), 连享会 No.605.
  - 连玉君, 2024, [VScode插件：安装、配置和使用](https://www.lianxh.cn/details/1490.html), 连享会 No.1490.
  - 连玉君, 2024, [VScode：实用 Markdown 插件推荐](https://www.lianxh.cn/details/1390.html), 连享会 No.1390.


## Marp 幻灯片

> 有关 Marp 幻灯片的详情可以参考：
> 连玉君，2026. Marp 幻灯片指南. [在线版](https://lianxhcn.github.io/marp-book/), [PDF](https://lianxhcn.github.io/marp-book/Marp-book.pdf), [GitHub](https://github.com/lianxhcn/marp-book)

在 VScode 中安装 `Marp` 插件后，你可以使用 Markdown 语法来创建幻灯片。使用 Marp 最大的好处是你可以专注于内容，而不必担心幻灯片的格式和样式。Marp 会自动将你的 Markdown 文档转换为美观的幻灯片。

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20220525154453.png)

### 安装

1\. VScode 编辑器    

2\. Marp 插件 
   - 在 VScode 中打开扩展市场，搜索 `Marp for VS Code`，点击安装。  
    
3\. 如需使用 PDF 导出功能，还需要安装 `Marp CLI`：
  - **打开终端 (TERMINAL)**：在 VScode 中，点击左侧活动栏的终端图标，或使用快捷键 `Ctrl + ~`（反引号）打开终端。
  - 在终端中运行以下命令安装 Marp CLI：
     ```bash
     npm install -g @marp-team/marp-cli
     ```

扩展阅读：

  - 连玉君, 2024, [VScode插件：安装、配置和使用](https://www.lianxh.cn/details/1490.html), 连享会 No.1490.
  - 连玉君, 2024, [VScode：实用 Markdown 插件推荐](https://www.lianxh.cn/details/1390.html), 连享会 No.1390.



## 用 Markdown 编写个人网站和简历

使用 Markdown 语法，你可以轻松地创建个人网站和简历。

你可以参考如下推文，轻松创建个人主页 (无需购买域名，也无需学习 HTML 和 CSS)：

- 连小白, 2025, [50 分钟搞定个人主页：Fork 模板 + GitHub Pages + Quarto 完整教程](https://www.lianxh.cn/details/1644.html)

Markdown 也可以用来制作简历，参见：

- [lapis-cv.bingyan.net](https://lapis-cv.bingyan.net)，[github](https://github.com/BingyanStudio/LapisCV)
- [resume.todev.cc/](https://resume.todev.cc/)，[github](https://github.com/Dunqing/resume)
