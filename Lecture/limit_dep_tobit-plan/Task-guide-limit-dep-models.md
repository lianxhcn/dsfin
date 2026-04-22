# Task Guide: 章节写作任务书

> **文档用途**：供 agent 自动完成「金融数据分析与建模」课程 Part III 第一章（最大似然估计）的全部写作任务。  
> **输出文件**：`limit_dep_models_lec.qmd`、`limit_dep_models_codes.ipynb`、`limit_dep_models_case.ipynb`  
> **课程主页**：https://lianxhcn.github.io/dsfin/  
> **作者定位**：中山大学岭南学院，金融数据分析与建模课程，副教授  
> **写作语言**：中文为主，专业术语首次出现时附英文  

任务步骤：

1. 先制作一个写作提纲，涵盖 2-3 小时的讲课内容，提纲要具体到每个小节的标题和内容要点，提纲完成后提交给我审核
2. 我审核后开始生成讲义内容，生成过程中我会随时提供反馈和修改意见，你需要根据我的反馈进行调整和完善讲义内容，直到我满意为止
3. 讲义内容完成后，你需要对讲义进行润色和修改，使其更符合人类读者的阅读习惯和理解方式，确保讲义内容的完整性和准确性

---


## 1. 任务总览

### 1.1 前面已经介绍的内容

- 受限因变量概览：各类受限因变量的数据形态，分布特征，以及生成过程简介。https://lianxhcn.github.io/dsfin/Lecture/limit_dep_intro/01_overview_lec.html
- Logit 模型：https://lianxhcn.github.io/dsfin/Lecture/limit_dep_logit/02_a_binary_lec.html
- MLE 估计方法：https://lianxhcn.github.io/dsfin/Lecture/method_MLE/MLE_lec.html

### 1.2 本讲义将要涵盖的内容

接下来要介绍 Tobit 模型, Two-part model，hurdle model 和 Heckman Sample selection model，Treatment effect model (模型右侧的处理变量 $D$ 存在样本选择或自选择)，PPMLHDFE。这些模型都是为了处理因变量存在截断或者选择性偏差的问题而提出的。

这些模型的介绍无需讲解估计过程，要以应用为导向，重点说明这些模型的适用场景、模型设定和结果解释。可以通过一些实际案例来说明这些模型的应用，比如在金融和公司金融领域，

- Tobit 模型可以用来分析投资金额的决定因素，
- Two-part model 可以用来分析公司在数字化转型中的投资决策，
- hurdle model 可以用来分析企业创新活动的决策过程，
- Heckman Sample selection model 可以用来分析企业的捐赠行为或数字化创新投入 (有一定比例的企业的 $y$ 是缺失值)
- ppmlhdfe 模型可以用来分析企业的贸易流量或者投资流量，处理零值和高维固定效应的问题。

### 1.3 学生背景

- 已学过线性回归与 OLS，但部分学生统计基础较弱
- 未必具备完整的「总体 → 样本 → 分布 → 参数 → 推断」框架
- 未来职业：金融分析、风险管理、量化研究、政府机关，关注实用性
- 编程能力参差不齐，讲义主文**不应**要求学生读懂代码
- 讲义中可以提供 5-10 个关键的 callout 提示词框，帮助学生使用 AI 自动生成估计某类模型的 Python/stata 代码，或是生成一些关键图形（如似然函数曲线、参数化示意图），帮助学生理解关键概念。callout 的格式为：

```markdown
::: {.callout-tip}
### 提示词：xxx

……
:::
```



### 1.4 文件与路径约定

| 文件              | 路径                               | 用途                                    |
| ----------------- | ---------------------------------- | --------------------------------------- |
| `limit_dep_models_lec.qmd`     | `./limit_dep_models_lec.qmd`                    | 主讲义，插入图片，不含可运行代码        |
| `limit_dep_models_codes.ipynb` | `./limit_dep_models_codes.ipynb`                | 生成模拟数据和图形的素材工厂            |
| `limit_dep_models_case.ipynb`  | `./limit_dep_models_case.ipynb`                 | 实际应用案例展示                        |
| 数据文件          | `./data/limit_dep_models_data0N_xxx.csv` | 模拟数据，供后续章节复用                |
| 图形文件          | `./figs/limit_dep_models_fig0N_xxx.png`  | 讲义引用图形，300 dpi，宽度 1200px 以上 |

- 若 `data/` 或 `figs/` 文件夹不存在，代码自动创建
- 图形编号从 `01` 开始连续编号
- 讲义中引用图形路径统一为 `./figs/limit_dep_models_fig0N_xxx.png`

### 1.5 Stata 代码的模块化原则（重要）

`limit_dep_models_case.ipynb` 中所有 Stata 代码以独立模块的形式呈现，具体要求：

- Python 代码与 Stata 代码**分属不同的 Markdown cell**，不混排
- 每个 Case 的 Stata 命令集中放在该 Case 最后一个 Markdown cell 中，标题为「**Stata 对应代码**」
- Stata 代码 cell 使用如下统一格式，方便整体删除：

```markdown
::: {.callout-note collapse="true"}
### Stata 对应代码

​```stata
* [Case N] 模型名称
* 数据读入
import delimited "./data/limit_dep_models_dataN_xxx.csv", clear

* 核心估计命令
...

* 边际效应
...
​```

> **说明**：以上 Stata 代码与上方 Python 代码完成相同的分析任务，结果应高度一致。
:::
```

- 这样设计的好处：若需要纯 Python 版本的讲义，只需删除所有 `{.callout-note collapse="true"}` 块即可，不影响 Python 代码和 Markdown 解读内容

---


### 1.6 章节结构和格式要求



章节编号和交叉引用：

1. 所有章节不加编号，我随后会用 quarto render 自动编译生成 online book，并通过 github pages 发布，届时章节会自动编号
2. 每个小节，尤其是 '### xxx' 的小节内部内容不能太少，以免生成的在线版本看起来像「目录」而不是「内容」。如果某个小节内容较少，可以考虑合并到上一个小节，或者增加一些补充内容。
3. 有些简短的内容可以用 `**A. 四级标题**, **B. 四级标题**` 的形式呈现，不必设置为 `#### xxx`，以免过度分割内容。
4. 每个小节 (尤其是 '## xxx') 的开头都要有一两段文字介绍本节内容，不能直接以定义或公式开头。要用自然语言把逻辑讲清楚，再给公式；不要让公式先于直觉出现。
5. Markdown 格式的 list 文本前要空一行，以免渲染成一行的文本而不是列表。
6. 本章内容尽量避免跨 Chapter 进行交叉引用，主要以 Chapter 内部的 section 或 subsection 之间的引用。因为我后会根据讲课的需要自由组合章节内容。如果一定要涉及跨 Chapter 的引用，建议用「后续章节」或「前面章节」这样的模糊指代，而不是具体的章节编号。