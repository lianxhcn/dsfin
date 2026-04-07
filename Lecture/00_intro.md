# 📚课程资料 {.unnumbered}

---

**课程主页**：[lianxhcn.github.io/dsfin](https://lianxhcn.github.io/dsfin/) ｜ **GitHub**：[lianxhcn/dsfin](https://github.com/lianxhcn/dsfin)

---

## 课程概述

本课程面向有志于将数据科学方法应用于金融研究与实践的学习者，系统讲授从数据获取、处理到建模分析的完整工作流。课程最大亮点在于将 **提示词工程（Prompt Engineering）与 AI 辅助分析**深度融入每一个教学环节——学生不仅学习如何写代码，更学习如何借助 AI 工具大幅提升分析效率，真正做到"人机协作"。课程始终以金融理论为牵引，确保每一种技术方法都服务于真实的金融问题。

### 课程结构 {.unnumbered}

课程分为**数据分析**与**建模**两大模块，循序渐进，理论与实操并重。

**Part I：数据分析**

涵盖数据获取（API、网络爬虫、数据库）、数据结构理解（数据框、矩阵、结构化与非结构化数据）、数据清洗（缺失值处理、离群值识别、变量合并与转换）以及多类型可视化（直方图、散点图、三维图、动图）。课程采用 Markdown 与 Jupyter Notebook 进行可复现报告写作，培养严谨的数据分析习惯。

**Part II：建模**

从统计基础与假设检验出发，逐步深入因果推断（反事实框架、随机对照试验、自然实验）、线性与面板数据模型（OLS、高维固定效应、DID）、再抽样方法（Bootstrap、Monte Carlo 模拟）以及机器学习算法（Lasso、随机森林、支持向量机等）。金融应用案例贯穿全程，包括**事件研究法、投资组合分析、风险模型与信用评分模型**，帮助学生将方法论直接对接实际研究场景。

### 课程特色 {.unnumbered}

- 🤖 **AI 辅助驱动**：将大语言模型与提示词设计融入数据分析全流程，显著降低编程门槛，提升研究效率
- 📐 **理论与实证结合**：每一种计量或机器学习方法均结合金融理论背景与真实数据案例加以阐释
- 🔁 **可复现研究范式**：基于 Jupyter Notebook 的分析框架，确保研究过程透明、结果可验证
- 🌉 **贯通因果与预测**：同时涵盖因果推断（DID、匹配、Double ML）与预测建模（机器学习），适应学术研究与业界实践的双重需求


### 课程内容 {.unnumbered}

- **Part I：数据分析**
  - 数据获取：API, 爬虫, 数据库
  - 数据结构：数据框、系列、矩阵、结构化v.s.非结构化
  - 数据清洗：缺失值、离群值、文字变量、合并、纵横变换、变量生成与转换
  - 可视化：直方图、类别变量、散点图、三维图、动图
  - 复现报告：Markdown, Jupyter Notebook

- **Part II：建模**
  - 统计基础和假设检验
  - 因果推断基础：反事实架构、随机对照试验、自然实验
  - 线性回归分析：OLS，虚拟变量，交乘项，高阶项
  - 面板数据模型：高维固定效应模型、DID、面板结构变化模型
  - 再抽样方法：Bootstrap, Jackknife, Cross-validation, Monte Carlo Simulation
  - 因果推断进阶：AB-test, 匹配, Double Machine Learning
  - 机器学习：K 近邻, Lasso，随机森林，支持向量机, Logit
  - 案例：事件研究法、投资组合分析、风险模型、信用评分模型


## 作业和小组报告

### 关于 AI 工具 {.unnumbered}
- 可以使用 AI 工具写作业和报告，可以使用 AI 写代码
- 但要提供提示词链接或提示词原文，如：[豆包-SVM 解读](https://www.doubao.com/thread/w9d7da7ee6fa0bc32)；&emsp;[ChatGPT](https://chatgpt.com/share/67f0a7d3-cbcc-8005-857d-bbcfe4e680cd)；&emsp;[连玉君-UseChatGPT](https://github.com/arlionn/UseChatGPT/tree/main/Examples)

### 软件 {.unnumbered}
- 不限制：用 Stata，R，Python 均可
- 要求：使用 VS Code + Jupyter Notebook 编写代码和报告

### 小组作业 {.unnumbered}
- 6-8 次，每个小组有 2 次展示机会 (每次 20mins)
- 人数：每个小组 3-4 人 
- 报告：需要用 VScode 或 Quarto 写报告
  - 用 [Marp]() 或其他基于 Markdown 语法的工具制作 Slides
  - 不建议使用 PowerPoint 幻灯片



## 参考资料

### AI tools

- [Awesome AI for Economists](https://github.com/hanlulong/awesome-ai-for-economists)
  - A curated list of AI tools, libraries, and resources for economics research, teaching, and policy analysis.
- Gábor Békés. (2026). **Doing Data Analysis with AI**. [Link](https://gabors-data-analysis.com/ai-course/).

- [awesome-claude-code](https://github.com/jqueryscript/awesome-claude-code)
  - A curated list of code examples and resources for using the Claude AI language model in various programming languages and applications.
- [awesome-claude-skills](https://github.com/travisvn/awesome-claude-skills)
  - A curated list of awesome Claude Skills, resources, and tools for customizing Claude AI workflows

### 概率统计基础 

- David Diez, Mine Çetinkaya-Rundel and Johanna Hardin. 2019. OpenIntro Statistics, 4E, [PDF](https://www.biostat.jhsph.edu/~iruczins/teaching/books/2019.openintro.statistics.pdf), [Link](https://open.umn.edu/opentextbooks/textbooks/60). [datasets](https://www.openintro.org/data/), [Slides](https://github.com/OpenIntroStat/openintro-statistics-slides), [中文版-Chp1-6](https://www.openintro.org/go/?id=os4_chinese_translation_ch1-6&referrer=/book/os/index.php)
- Mine Çetinkaya-Rundel and Johanna Hardin, 2024. Introduction to Modern Statistics (2e). [Read Online](https://openintrostat.github.io/ims/), [github](https://github.com/openintrostat/ims)
  
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


### 因果推断和机器学习

* Nick Huntington-Klein. **The Effect**: An Introduction to Research Design and Causality, [Link](https://theeffectbook.net/), [github](https://github.com/NickCH-K/causalbook), [Slides-Causality](https://github.com/NickCH-K/CausalitySlides), [Slides-Econometrics](https://github.com/NickCH-K/EconometricsSlides)
  - 以因果图和反事实框架为基础，介绍了一些常用的因果推断方法，包括：DID，TWFE，SCM，RDD，PSM，Matching，Panel 等；配有在线阅读版本和 GitHub 代码仓库。 
* Facure, Matheus (2022). Causal Inference for The Brave and True. [Link](https://matheusfacure.github.io/python-causality-handbook/landing-page.html). [GitHub](https://github.com/matheusfacure/python-causality-handbook).
  - Note: 覆盖 IV、DID、SDID、PSM、Matching、Panel、SCM、RDD；包含完整 Jupyter Notebook；使用 `causalml` 与 `dowhy`。
* James, G., Witten, D., Hastie, T., & Tibshirani, R. (2023). An Introduction to Statistical Learning: With Applications in Python (ISLP). Springer. [Link](https://www.statlearning.com/). [Python 资源与实验](https://intro-stat-learning.github.io/ISLP/). [GitHub](https://github.com/intro-stat-learning/ISLP_labs). [PDF](https://bayanbox.ir/view/1060725898744657072/An-Introduction-to-Statistical-Learning-with-Applications-in-Python.pdf).
  * Note: 经典入门教材，强调统计学习与 Python 实现；配有在线实验材料、GitHub 代码与 PDF 版本，适合课程教学、自学与 Notebook 演示。
* Tatsat, H., Puri, S., & Lookabaugh, B. (2020). Machine Learning and Data Science Blueprints for Finance. O'Reilly Media. [GitHub](https://github.com/tatsath/fin-ml). [Binder](https://mybinder.org/v2/gh/tatsath/fin-ml/master). [PDF](https://soclibrary.futa.edu.ng/books/Machine%20Learning%20and%20Data%20Science%20Blueprints%20for%20Finance%20%28Hariom%20Tatsat,%20Sahil%20Puri,%20Brad%20Lookabaugh%29%20%28Z-Library%29.pdf).
  * Note: 面向金融场景的机器学习实战书；包含资产定价、风险管理、时间序列与交易策略等案例；配套 GitHub 仓库，且可通过 Binder 在线运行。
* Chollet, François (2021). Deep Learning with Python (2nd ed.). Manning. [Link](https://www.manning.com/books/deep-learning-with-python-second-edition). [GitHub](https://github.com/fchollet/deep-learning-with-python-notebooks).
  * Note: Keras 作者撰写的深度学习教材，偏重实践与代码示例；适合快速上手神经网络、计算机视觉与序列模型。
* Buduma, N., & Papa, J. (2022). Fundamentals of Deep Learning. [PDF](https://webfiles.amrita.edu/2025/02/deep-learning-material-dept-ece-ase-blr-1.pdf).
  * Note: 深度学习基础读物，适合初学者建立整体框架；可作为神经网络、训练机制与常见模型结构的入门材料。
* Goodfellow, I., Bengio, Y., & Courville, A. (2016). Deep Learning. MIT Press. [Link](http://www.deeplearningbook.org). [TensorFlow Exercises](https://www.tensorflow.org/tutorials?hl=zh-cn). [Slides](https://www.deeplearningbook.org/lecture_slides.html). [PDF1](http://alvarestech.com/temp/deep/Deep%20Learning%20by%20Ian%20Goodfellow,%20Yoshua%20Bengio,%20Aaron%20Courville%20%28z-lib.org%29.pdf). [PDF2](https://github.com/janishar/mit-deep-learning-book-pdf/blob/master/complete-book-pdf/Ian%20Goodfellow%2C%20Yoshua%20Bengio%2C%20Aaron%20Courville%20-%20Deep%20Learning%20%282017%2C%20MIT%29.pdf).
  * Note: 深度学习领域的代表性教材，系统覆盖前馈网络、卷积网络、序列模型、优化与概率图模型；配有官网、练习资源与课件。

### 非参数估计方法

- Wasserman (2006)《All of Nonparametric Statistics》, [PDF](https://www.stat.cmu.edu/~brian/valerie/617-2022/0%20-%20books/2006%20-%20Wasserman%20All%20Of%20Nonparametric%20Statistics.pdf)


### 其它

- Rob Hicks, 2022. ECON414 Bayesian Econometrics. [Link](https://econ.pages.code.wm.edu/414/notes/docs/index.html).
  - 介绍了 Bayes 的基本概念，MCMC 方法，贝叶斯线性回归，贝叶斯模型比较等内容；配有在线阅读版本和 GitHub 代码仓库。

---

## 分析工具

- 请预先安装 VScode 编辑器和 Anaconda 套装，并确保相关环境配置正确。详情参见 [软件安装和环境配置](00-setup/01_01_install_anaconda.ipynb)。
- 我们会在 VScode 中使用 Jupyter Notebook (`.ipynb` 文档) 编写 Python 和 Stata 代码，并添加 Markdown 格式的解释文本。参见 [Jupyter Notebook 的使用](00-setup/01_02_jupyter_notebook.ipynb)。若不熟悉 Markdown 语法，可以参考 [Markdown 简介](00-setup/01_04_markdown.md).
