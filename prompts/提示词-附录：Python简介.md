
## 任务说明：帮我编写一个提示词导向的 Python 基础教程作为我的讲义的附录

我正在使用 VS Code + quarto render + github pages 来编写和发布课程讲义。

主要包括两大块：数据分析 + 建模。

- 数据分析：包括数据获取、数据清洗、数据分析、数据可视化等内容，重点是实用性和应用性，结合金融领域的实际案例来讲解方法的应用。
- 建模：从统计基础和假设检验出发，逐步深入因果推断（反事实框架、随机对照试验、自然实验）、线性与面板数据模型（OLS、高维固定效应、DID）、再抽样方法（Bootstrap、Monte Carlo 模拟）以及机器学习算法（Lasso、随机森林、支持向量机等）。金融应用案例贯穿全程，包括事件研究法、投资组合分析、风险模型与信用评分模型，帮助学生将方法论直接对接实际研究场景。

### 关键任务
现在，我需要编写一个提示词导向的 Python 基础教程作为讲义的附录。这份讲义不是系统介绍 Python 的语法和库，而是针对我的学生的需求，提供一些实用的提示词，帮助他们使用 AI 工具（如 ChatGPT、Claude code 等）来生成 Python 代码，完成数据分析和建模任务。比如：

- 基础学习类：
  - 中文乱码-尤其是图形中：写一个提示词框，只需要简单的一句话就可以生成解决中文乱码问题的 Python 代码。
  - 屏蔽 warnings 信息：写一个提示词框，只需要简单的一句话就可以生成屏蔽 warnings 信息的 Python 代码。
  - 绘图包的选取：用户说明自己想要的图形风格 (学术风格、商务风格，配色要求等)，让 AI 推荐合适的 Python 绘图包和绘图方案，进而生成代码。
- 项目规划或结构设计
  - 项目结构设计：写一个提示词框，指导 AI 生成一个适合数据分析项目的 Python 项目结构，包括文件夹和文件的命名，以及每个文件的功能说明。
  - 对于复杂的项目，可以先用一个提示词和 AI 讨论项目结构设计，确定好项目结构后，再用一个提示词让 AI 生成每个文件的代码框架。
  - github 同步：写一个提示词框，指导 AI 生成一个 Python 脚本，能够将本地的 Python 项目同步到 GitHub 仓库中，包括初始化 git 仓库、添加远程仓库、提交代码和推送到 GitHub 的步骤。如果有可能，还可以提供 github actions 的配置文件，自动化同步。
  - ……
- 数据分析类： 
  - 生成模拟数据的提示词
  - 数据清洗的提示词
  - 数据分析的提示词
  - 数据在结果窗口中以美观表格方式呈现、可视化的提示词
  - 模型评估的提示词
- 可视化类：
  - 图形尺寸，图形分辨率，图形风格、图形配色等；以及图形中关键元素的名称：图例、坐标轴刻度、坐标轴标签、标题、子图等。
  - 说清楚自己的数据类型和目标，先让 AI 提供几种可视化方案，再让 AI 生成代码。
- 其它你认为比较重要的内容


### 重要说明

我此前从未讲过这样介绍 Python 的讲义，因此我也不太清楚应该提供哪些提示词，或者说哪些提示词是最有用的。我的学生也没有太多 Python 基础，因此我希望这些提示词能够覆盖一些最基础、最常用的 Python 代码生成需求，帮助他们快速上手 Python 进行数据分析和建模。

这个过程中或许还是需要介绍一些基本概念和 Python 语法，但我希望这些介绍能够尽量简洁，重点是有助于学生准确的撰写提示词 (用专业的 Python 术语，如'数据框'，'字典'，'API' 等名词，否则 AI 可能无法理解你的需求)。例如：

- 虚拟环境
- 项目结构文档的自动生成
- 文件路径
- 图形尺寸，图形分辨率，图形风格、图形配色等；以及图形中关键元素的名称：图例、坐标轴刻度、坐标轴标签、标题、子图等。
- ……

由于我也刚学 Python ，了解的还很有限，你可以酌情调整和补充。 

### 输出

- folder: '../appendix_python/'

你可以帮我规划一下这个附录大概需要包括哪些内容？需要拆分成几个 Chapter？每个 Chapter 包括哪些小节？每个小节的内容是什么？每个小节的提示词框是什么样子的？你可以帮我写一些示例的提示词框吗？


--- 

## 附：如下信息有助于你了解我的讲义的风格和我的学生的需求：

## 课程背景

- 课程名称：金融数据分析与建模
- 课程目标：培养学生在金融领域进行数据分析和建模的能力，使他们能够运用数据科学的方法来解决金融领域的实际问题。
- 课程内容：包括数据获取、数据清洗、数据分析、建模方法、模型评估等方面的内容，重点是实用性和应用性，结合金融领域的实际案例来讲解方法的应用。
- 学生未来的职业目标：进入金融行业，尤其是银行、投行、基金、券商等领域，从事金融分析、财务分析、估值、风险管理、量化研究等工作；还有约 1/4 的同学会通过公务员考试进入政府机关。因此，他们更关注课程内容的实用性和应用性，希望能够学到一些能够直接应用到工作中的技能和知识；而不是用来做学术研究的方法。
- 我的听课对象都是没有太多 Python 基础的金融硕士，中山大学，多数学生都会使用 AI 工具，如 ChatGPT，Claude code 等。因此，请在讲义关键处加上相对完整的「提示词框」，以便学生可以使用稍微写改一下提示词就可以借助 AI 生成 Python 代码。 他们都已经有 Anaconda 套装，执行不是问题。 

## 讲义-online lecture 和 github 仓库

- website：<https://lianxhcn.github.io/dsfin/>
- github：<https://github.com/lianxhcn/dsfin>

### 讲义的风格

问题驱动 (界定清楚数据分析中的各类任务和痛点、难点)，拆解 (分步骤)，形成一个个小的「提示词框」，每个提示词框都包含一个相对完整的提示词，学生可以直接使用这个提示词来生成 Python 代码。


1. 提示词框格式如下：

::: {.callout-tip}
### 提示词：xxxx
这组提示词用于指导 AI 生成 xxxx 的 Python 代码。请根据提示词内容，修改提示词中的参数或细节，以适应你的具体分析任务。
```md
{具体提示词内容}先说明任务背景和目标，再给出具体的提示词内容。要求提示词内容清晰、具体，能够指导 AI 生成符合要求的 Python 代码。

1. ……
2. ……
3. ……
```
:::



## 格式要求

这是我的书稿的 .yml 文件 (我会发送 '_quarto.yml' 给你)，你帮我生成的这些章节会放在 '../appendix_python' 文件夹中，与 '../lecutre' 文件夹平级。因此，

1. 附录中的每一章可以不用写 YAML 头信息
2. 标题为 '# A1. xxx {.unnumbered}' 
3. section 及以下的章节序号为: 
    '## A1.1 xxx' 
    '### A1.1.1 xxx'
    '**A. xxx**' (四级标题不再编号，上下各空一行) 
    Note：上面只是一般性原则，如果没某个 章节的内容比较短，或者说某个章节的内容比较长，或者说某个章节的内容比较复杂，那么你可以酌情调整标题的层级和编号方式，以便更好地组织内容。总之，不要让标题层级过多，或者一个带编号的标题下只有几行内容。 

4. list 格式块上下各空一行，否则在 quarto 中渲染时会出错：
'''
xxxx：

1. xxx
2. xxx


'''
5. 文中的双引号都采用 '「」' 格式
6. 在 index.qmd 文档中最好插入 3-5 个引文信息，提供 2-3 本经典的介绍 Python 语法，Python 数据分析的书目的信息，在同等品质前提下，优先选择最近几年出版的书；提供 2-3 个 online book 最好能附带 github 仓库的在线书，方便大家查看，讲解 Python data science, python for finance 之类的信息，比如 ：


### Python 语言
- Allen Downey, 2012. Think Python: How to Think Like a Computer Scientist. [-PDF-](https://greenteapress.com/thinkpython/thinkpython.pdf)
  - Python 入门，通俗易懂
- Johansson, R., 2024, Numerical Python: Scientific Computing and Data Science Applications with Numpy, SciPy and Matplotlib. Apress Berkeley, CA. [Link](https://link.springer.com/book/10.1007/979-8-8688-0413-7), [PDF](https://link.springer.com/content/pdf/10.1007/979-8-8688-0413-7.pdf) (需要用校园 ID 登录), [github](https://github.com/Apress/Numerical-Python-3rd-ed/fork)
  - Python 入门，绘图，科学计算，偏微分方程，统计和机器学习初步
  - CHAPTER 4 Plotting and Visualization, 介绍绘图的基本元素. 
- QuantEcon. [Link](https://quantecon.org/lectures/), [github](https://github.com/QuantEcon)
  - QuantEcon is a nonprofit organization dedicated to development and documentation of open source computational tools for economics, econometrics, and decision making.

### 数据分析

- [Github 仓库：数据分析](https://github.com/search?q=Data+science+created%3A%3E2024-01-01+&type=repositories&p=2)
- Wes McKinney, **2022**. Python for Data Analysis: Data Wrangling with pandas, NumPy, and Jupyter (3E). [Online-Read](https://wesmckinney.com/book/), [github](https://github.com/wesm/pydata-book), [gitee-码云](https://gitee.com/wesmckinn/pydata-book)
  - 专注于数据处理，讲的比较细致 
  - 作者是 pandas 的作者，书中介绍了 pandas 的使用方法
- &#x1F34E; **PDSH** &emsp; VanderPlas, 2023. **Python Data Science Handbook**, [github](https://github.com/jakevdp/PythonDataScienceHandbook), [Online-Read](https://jakevdp.github.io/PythonDataScienceHandbook/index.html), [PDF-2E](https://dokumen.pub/python-data-science-handbook-essential-tools-for-working-with-data-2nbsped-1098121228-9781098121228.html) 
  - 数据分析 + 可视化 + 机器学习
  - 提供了 Colab版本，可以无需安装 Python，直接在线运行
  - 本地已经下载：**VanderPlas_2023_PDSH_Python_Data_Science_Handbook-2E.pdf**
- Adhikari, A., DeNero, J., & Wagner, D. (2015). Computational and inferential thinking: The foundations of data science. Ani Adhikari. [Read](https://inferentialthinking.com/), [github](https://github.com/data-8/textbook)
  - Data 8: Foundations of Data Science, **UC Berkeley**. [website](https://data8.org/sp26/)
- 黄湘云, 2025. R 语言数据分析实战. [Link](https://bookdown.org/xiangyun/data-analysis-in-action/), [PDF](https://bookdown.org/xiangyun/data-analysis-in-action/_main.pdf), [github](https://github.com/XiangyunHuang/data-analysis-in-action/blob/main/index.qmd)

### 金融

- Scheuch, C., Voigt, S., Weiss, P., & Frey, C. (**2024**). **Tidy Finance with Python** (1st ed.). Chapman and Hall/CRC, [Online-Read](https://www.tidy-finance.org/python/index.html), [github](https://github.com/tidy-finance/website/tree/main/python)
  - [tidyfinance package](https://github.com/tidy-finance/py-tidyfinance)
  - 股票回报, CAPM, 投资组合, Fama-French 因子模型等
  - 整体上比较简单，依赖于作者开发的 `tidyfinance` 扩展包。
- Mastering Python for Finance – Second Edition, [github](https://github.com/arlionn/Mastering-Python-for-Finance-Second-Edition)
- Hilpisch Y., **Python for Finance**. 2019. [-PDF-](https://www.sea-stat.com/wp-content/uploads/2021/05/Yves-Hilpisch-Python-for-Finance_-Mastering-Data-Driven-Finance-Book-OReilly-2018.pdf#page=225.11), [github](https://github.com/yhilpisch/py4fi2nd)
- Machine Learning for Algorithmic Trading, 2nd edition. [github](https://github.com/stefan-jansen/machine-learning-for-trading), [Website](https://ml4trading.io/)

