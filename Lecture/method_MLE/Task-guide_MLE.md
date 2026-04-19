# Task Guide: MLE 章节写作任务书（v2.0）

> **文档用途**：供 agent 自动完成「金融数据分析与建模」课程 Part III 第一章（最大似然估计）的全部写作任务。  
> **输出文件**：`MLE_lec.qmd`、`MLE_codes.ipynb`、`MLE_case.ipynb`  
> **课程主页**：https://lianxhcn.github.io/dsfin/  
> **作者定位**：中山大学岭南学院，金融数据分析与建模课程，副教授  
> **写作语言**：中文为主，专业术语首次出现时附英文  
> **版本说明**：v2.0 在 v1.0 基础上，精简案例数量，补充关键教学内容，调整 Stata 代码结构以便模块化复用

---

## Part 0：全局说明

### 0.1 本章在课程中的定位

本章是 Part III「估计方法」的第一章，核心任务是为后续所有非线性模型（Probit、Tobit、Poisson、Heckman 等）的学习奠定「估计语言」基础。

本章**不是**：
- MLE 的数理统计推导课
- 要求学生自己编程实现 MLE 的编程课
- 覆盖所有 MLE 理论细节的参考手册

本章**是**：
- 帮助学生建立从「数据 → 分布假设 → 参数化 → 似然函数 → 估计 → 推断」这条完整分析链条的直觉课
- 让学生理解「为什么后续模型都说用 MLE 估计」的背景理解课
- 让学生看懂软件输出（log likelihood、LR test、AIC/BIC、边际效应）的应用准备课

### 0.2 学生背景假设

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


### 0.3 全章核心主线（贯穿始终）

$$
\text{sample data} \;\rightarrow\; \text{distributional assumption} \;\rightarrow\; \text{parameterization} \;\rightarrow\; \text{likelihood} \;\rightarrow\; \hat{\theta}_{MLE} \;\rightarrow\; \text{inference / prediction / comparison}
$$

两句总纲式表述，应在导言和小结中各呼应一次（不必字面重复，但含义必须出现）：

> **第一句**：MLE 的核心不是求导本身，而是先设定 $y_i \mid x_i$ 的分布，再用参数化方式把分布参数与 $x_i$ 连接起来。

> **第二句**：后续许多看起来彼此不同的模型（Logit、Probit、Tobit、Poisson、Heckman），其实共享同一套估计逻辑——分布设定不同，参数化方式不同，但估计原则仍然是极大化对数似然。

### 0.4 文件与路径约定

| 文件 | 路径 | 用途 |
|------|------|------|
| `MLE_lec.qmd` | `./MLE_lec.qmd` | 主讲义，插入图片，不含可运行代码 |
| `MLE_codes.ipynb` | `./MLE_codes.ipynb` | 生成模拟数据和图形的素材工厂 |
| `MLE_case.ipynb` | `./MLE_case.ipynb` | 实际应用案例展示 |
| 数据文件 | `./data/method_MLE_data0N_xxx.csv` | 模拟数据，供后续章节复用 |
| 图形文件 | `./figs/method_MLE_fig0N_xxx.png` | 讲义引用图形，300 dpi，宽度 1200px 以上 |

- 若 `data/` 或 `figs/` 文件夹不存在，代码自动创建
- 图形编号从 `01` 开始连续编号
- 讲义中引用图形路径统一为 `./figs/method_MLE_fig0N_xxx.png`

### 0.5 Stata 代码的模块化原则（重要）

`MLE_case.ipynb` 中所有 Stata 代码以独立模块的形式呈现，具体要求：

- Python 代码与 Stata 代码**分属不同的 Markdown cell**，不混排
- 每个 Case 的 Stata 命令集中放在该 Case 最后一个 Markdown cell 中，标题为「**Stata 对应代码**」
- Stata 代码 cell 使用如下统一格式，方便整体删除：

```markdown
::: {.callout-note collapse="true"}
### Stata 对应代码

​```stata
* [Case N] 模型名称
* 数据读入
import delimited "./data/method_MLE_dataN_xxx.csv", clear

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

## Part 1：`MLE_lec.qmd` 写作任务

### 1.1 文档头部（YAML frontmatter）

```yaml
---
title: "最大似然估计"
subtitle: "从建模假设到参数估计"
author: "连享会"
date: today
format:
  html:
    toc: true
    toc-depth: 3
    number-sections: true
    code-fold: true
    theme: cosmo
    fig-cap-location: bottom
    crossref:
      fig-title: "图"
      tbl-title: "表"
      eq-title: "式"
execute:
  echo: false
  warning: false
---
```

### 1.2 章节结构总览和格式要求

共 9 节 + 导言 + 小结：

```
导言
第 1 节：为什么需要最大似然估计
第 2 节：MLE 的基本思想：概率、似然与参数评分
第 3 节：一个最简单的例子：Bernoulli 模型
第 4 节：从单参数到回归模型：参数如何与数据连接
第 5 节：正态模型、线性回归与 OLS 的关系
第 6 节：MLE 的一般工作流程
第 7 节：如何解读软件输出中的似然指标
第 8 节：使用 MLE 时的常见问题
第 9 节：小结：MLE 为后续各类模型提供统一语言
```

章节编号和交叉引用：

1. 所有章节不加编号，我随后会用 quarto render 自动编译生成 online book，并通过 github pages 发布，届时章节会自动编号
2. 每个小节，尤其是 '### xxx' 的小节内部内容不能太少，以免生成的在线版本看起来像「目录」而不是「内容」。如果某个小节内容较少，可以考虑合并到上一个小节，或者增加一些补充内容。
3. 有些简短的内容可以用 `**A. 四级标题**, **B. 四级标题**` 的形式呈现，不必设置为 `#### xxx`，以免过度分割内容。
4. 每个小节 (尤其是 '## xxx') 的开头都要有一两段文字介绍本节内容，不能直接以定义或公式开头。要用自然语言把逻辑讲清楚，再给公式；不要让公式先于直觉出现。
5. Markdown 格式的 list 文本前要空一行，以免渲染成一行的文本而不是列表。
6. 本章内容尽量避免跨 Chapter 进行交叉引用，主要以 Chapter 内部的 section 或 subsection 之间的引用。因为我后会根据讲课的需要自由组合章节内容。如果一定要涉及跨 Chapter 的引用，建议用「后续章节」或「前面章节」这样的模糊指代，而不是具体的章节编号。

---

### 1.3 导言

**写作目标**：激发学习动机，交代本章在课程中的位置，给出全章核心主线，让学生知道读完本章能做什么。

**内容要点**：

1. **开篇情境**（不要以定义开头，以具体问题开头）：
   - 你已经学会了线性回归和 OLS，但如果因变量是「是否违约」（0/1），或者「月度交易次数」（0,1,2,...），OLS 还适用吗？如果不适用，应该用什么方法来估计这类模型的参数？
   - 答案是：这类模型几乎都依赖一种叫「最大似然估计」的统计方法。

2. **本章定位**：
   - 学习 MLE，不是为了手推公式，而是为了理解后续每个模型「在做什么」
   - 给出全章核心主线图（引用 `fig01_flowchart`）

3. **阅读导引**（1-2 句，不是跳读菜单）：
   - 本章按「动机 → 概念 → 例子 → 流程 → 读懂输出 → 注意事项」逐步推进，建议顺序阅读前 6 节；第 7、8 节在遇到实际软件操作时按需查阅。

4. **本章学完后你能做什么**（用 `.callout-note` 呈现）：
   - 理解「Logit 模型用 MLE 估计」是什么意思
   - 看懂 Python/Stata 输出中的 `Log-Likelihood`、`LR chi2`、`AIC`
   - 理解边际效应和预测概率是从哪里来的
   - 为后续 Probit、Tobit、Poisson、Heckman 的学习做好准备

**写作风格**：口语化，像在上课。第一段不能以「MLE 是……」这样的定义开头。

---

### 1.4 第 1 节：为什么需要最大似然估计

**写作目标**：从学生熟悉的 OLS 出发，通过展示其局限，建立学习 MLE 的动机。

**内容要点**：

**1.1 OLS 的舒适区**
- 线性回归：$y_i = x_i^\top\beta + \varepsilon_i$，估计条件均值 $E(y_i \mid x_i)$
- OLS 在因变量连续、误差大致正态时，给我们一条「最优直线」，这在很多场景下已经足够

**1.2 OLS 的边界**

用简洁的对照表，说明三类因变量 OLS 为何力不从心：

| 因变量类型 | 金融/经济中的典型例子 | OLS 的问题 |
|-----------|-------------------|-----------|
| 二元 0/1 | 是否违约、是否购买理财产品 | 预测值可能超出 $[0,1]$，无法解释为概率 |
| 非负计数 | 月度交易次数、年内发债次数 | 预测值可能为负，不符合数据的物理性质 |
| 截断/删失 | 只观测到申请通过的贷款金额 | 忽略截断机制会导致系数估计偏误 |

**1.3 MLE 的角色**
- MLE 不规定因变量必须连续、误差必须正态
- MLE 的核心思想是：给数据选一个合适的分布，然后找出最能解释这份数据的参数
- 后面将要讲的 Logit、Probit、Tobit、Poisson、Heckman，本质上只是**分布设定不同**，但估计原则都是 MLE

**图形**：引用 `fig01_flowchart`

**Callout**：
```
::: {.callout-tip}
### 本章学习目标
本章不要求手推 MLE 的一阶条件，也不要求自己编程实现。  
核心目标是理解「MLE 在做什么」，以及为什么后续各类模型都离不开它。
:::
```

---

### 1.5 第 2 节：MLE 的基本思想：概率、似然与参数评分

**写作目标**：这是全章概念上最重要的一节。必须把「似然 ≠ 概率」讲清楚，用出行方式例子建立直觉，并说明「提问方向的反转」是理解 MLE 的关键。

**内容要点**：

**2.1 概率 vs. 似然：提问方向反转**

用出行方式例子引入（先文字，后公式）：

> 某城市居民只有两种出行方式：步行（$y=1$）和开车（$y=0$）。设步行的概率为 $\theta$。

从同一个场景出发，两种完全不同的提问方式：

- **概率的提问方式**：我已经知道 $\theta = 0.6$（步行概率是 60%），随机询问 5 个人，请问「恰好 3 人步行」的概率是多少？
  → 参数已知，对数据提问。

- **似然的提问方式**：我已经看到了调查结果——5 个人中恰好 3 人选择步行。那么哪个 $\theta$ 值最能解释这个结果？$\theta=0.3$？$\theta=0.6$？还是 $\theta=0.9$？
  → 数据已知，对参数提问。

这个「提问方向的反转」，就是概率与似然最根本的区别。用一张对照表帮助学生固化：

| | 概率（Probability） | 似然（Likelihood） |
|--|--|--|
| 固定的 | 参数 $\theta$ | 数据 $\{y_i\}$ |
| 变化的 | 数据（在数据空间上） | 参数（在参数空间上） |
| 回答的问题 | 给定参数，数据多常见？ | 给定数据，哪个参数更合理？ |

用 `.callout-warning` 强调：

```
::: {.callout-warning}
### 常见误解：似然不是概率
似然函数的值**不是概率**。它是一个「参数评分规则」——
用来比较不同参数值对观测数据的解释能力。
似然值可以大于 1，也不需要对参数空间积分等于 1。
它唯一的作用是：**哪个 $\theta$ 对应的似然值更大，那个 $\theta$ 就更能解释数据。**
:::
```

引用 `fig02_prob_vs_likelihood`，图示两种视角的对比。

**2.2 似然函数的构造**

- i.i.d. 假设的直觉：每个人的出行选择是独立的，因此 5 个人同时出现某个结果的概率 = 各自概率之积
- 对于离散变量：$L(\theta) = \prod_{i=1}^n P(y_i \mid \theta)$
- 对于连续变量：$L(\theta) = \prod_{i=1}^n f(y_i \mid \theta)$（密度函数，不是概率）
- 再次点明：似然 ≠ 概率。对连续变量，$f(y_i \mid \theta)$ 是密度值，可以大于 1

**2.3 为什么取对数**

- 乘积 → 加总：便于求导，也便于理解（对数似然 = 每个观测对「解释能力」的贡献之和）
- 数值稳定性：$n$ 个很小的概率相乘会导致数值下溢（趋近于机器零），取对数后变为求和，稳定得多
- 关键性质：对数函数单调递增，极值点不变

$$
\ell(\theta) = \ln L(\theta) = \sum_{i=1}^n \ln f(y_i \mid \theta)
$$

引用 `fig03_bernoulli_likelihood`（此处仅展示对数变换不改变峰值位置）。

**2.4 MLE 与机器学习中的损失函数**

用一个 `.callout-note` 做简短桥接：

```
::: {.callout-note}
### 与机器学习语言的对应
机器学习中经常把「最大化对数似然」等价地写成「最小化负对数似然损失」（Negative Log-Likelihood Loss）。
两者完全等价——加上负号，最大化变最小化而已。
因此，你在深度学习框架中看到的交叉熵损失（Cross-Entropy Loss），  
本质上就是 Bernoulli 分布的负对数似然。
:::
```

**写作风格提示**：
- 「似然 ≠ 概率」这个区分至少出现两次，第一次在 2.1 结尾的 callout-warning，第二次在 2.2 正文中
- 先用自然语言把逻辑讲清楚，再给公式；不要让公式先于直觉出现

---

### 1.6 第 3 节：一个最简单的例子：Bernoulli 模型

**写作目标**：用出行方式例子让学生第一次完整走完 MLE 的三步，建立具体直觉，并展示网格搜索的思想。

**内容要点**：

**3.1 设定与数据**

继续出行方式场景：

> 随机询问 5 人出行方式，得到数据：$\{1, 0, 0, 1, 1\}$（1=步行，0=开车）。  
> 假设每个人步行的概率独立且均为 $\theta$。如何用 MLE 估计 $\theta$？

**3.2 构造似然函数**

逐步展示：

$$
L(\theta) = \theta \cdot (1-\theta) \cdot (1-\theta) \cdot \theta \cdot \theta = \theta^3(1-\theta)^2
$$

取对数：

$$
\ell(\theta) = 3\ln\theta + 2\ln(1-\theta)
$$

**3.3 求最大值**

一阶条件：

$$
\frac{d\ell}{d\theta} = \frac{3}{\theta} - \frac{2}{1-\theta} = 0 \quad\Longrightarrow\quad \hat{\theta} = \frac{3}{5} = 0.6
$$

用 `.callout-note` 点出结果的含义：

```
::: {.callout-note}
### 结果有点出乎意料吗？
$\hat{\theta} = 3/5$ 正好等于样本中「步行」的比例，即样本均值 $\bar{y}$。  
这不是巧合——对于 Bernoulli 分布，MLE 估计量等于样本频率。  
这给了我们一个直觉：MLE 在做的事情，是找到「和样本最像」的参数值。
:::
```

**3.4 网格搜索的直观展示**

引用 `fig03_bernoulli_likelihood`（$L(\theta)$ 与 $\ell(\theta)$ 对比曲线）和 `fig04_bernoulli_grid`（网格搜索示意）。

说明：很多复杂模型没有解析解，软件用的就是「在参数空间中搜索最大值」的思路，这就是数值优化的基本思想，后续「最优化方法」章节会详细介绍。

**3.5 小结：MLE 的三个基本步骤**

```
::: {.callout-tip}
### MLE 的三个基本步骤（以本例为示范）

**Step 1**：设定随机变量的分布。本例中 $y_i \sim \text{Bernoulli}(\theta)$。

**Step 2**：写出联合对数似然函数 $\ell(\theta) = \sum_{i=1}^n \ln f(y_i \mid \theta)$。

**Step 3**：极大化 $\ell(\theta)$，得到参数估计值 $\hat{\theta}$。
:::
```

---

### 1.7 第 4 节：从单参数到回归模型：参数如何与数据连接

**写作目标**：这是全章理论上最关键的一节。讲清楚「参数化」的核心思想，特别是从「常数参数」到「条件参数」的跨越，为后续所有模型做铺垫。

**内容要点**：

**4.1 单参数模型的局限**

- 上一节的 $\theta$ 是一个常数，意味着所有人的步行概率相同
- 但现实中，步行概率显然与个人收入、居住距离、年龄等变量有关
- 核心问题：**如何把个体差异引入分布参数？**

**4.2 一个具体的跨越：从 $\theta$ 到 $p_i$**

这是本节最重要的一步，必须用具体例子演示，而不只是用表格带过：

> 设违约概率 $p_i$ 与收入 $\text{income}_i$ 和年龄 $\text{age}_i$ 有关，参数化为：
>
> $$p_i = \Lambda(-1 + 0.8 \cdot \text{income}_i - 0.5 \cdot \text{age}_i)$$
>
> 其中 $\Lambda(\cdot)$ 是 Logistic 函数，保证 $p_i \in (0,1)$。

这个设定有三层含义，需要逐层说清楚：

1. **个体不同**：每个人的 $p_i$ 不同，因为他们的 income 和 age 不同
2. **降维**：$n$ 个不同的 $p_i$，全部由 3 个共同参数 $(-1, 0.8, -0.5)$ 生成——这就是「降维」
3. **可估计**：正因为参数只有 3 个（远少于样本量 $n$），我们才能用数据把它们识别出来

用 `.callout-important` 突出这一核心思想：

```
::: {.callout-important}
### 参数化的本质
我们不是直接估计每个人的违约概率 $p_i$，而是估计一组共同参数 $\beta$，  
再由这组参数生成每个人的概率。  
**这组共同参数，就是 MLE 要估计的对象。**
:::
```

**4.3 正态分布中的参数化**

以 $y_i \sim N(\mu_i, \sigma^2)$ 为例展示两种参数化：

均值方程：$\mu_i = x_i^\top\beta$（将 $n$ 个均值降维为 $p$ 个参数）

方差方程（异方差情形）：$\sigma_i^2 = \exp(z_i^\top\gamma)$（$\exp$ 保证方差为正）

**4.4 连接函数的统一视角**

用一张表格展示从「常数参数」到「条件参数」的进化，这张表是后续各章模型的「骨架」：

| 模型 | 分布假设 | 参数化方式 | 连接函数 | 参数约束 |
|------|---------|-----------|---------|---------|
| Bernoulli（简单） | $y_i \sim \text{Bern}(\theta)$ | $\theta$ 为常数 | — | $\theta \in (0,1)$ |
| Logit | $y_i \sim \text{Bern}(p_i)$ | $p_i = \Lambda(x_i^\top\beta)$ | Logistic | $p_i \in (0,1)$ |
| 正态线性 | $y_i \sim N(\mu_i, \sigma^2)$ | $\mu_i = x_i^\top\beta$ | 恒等 | 无 |
| Poisson | $y_i \sim \text{Pois}(\lambda_i)$ | $\lambda_i = \exp(x_i^\top\beta)$ | 指数 | $\lambda_i > 0$ |

在表格下方加注：**连接函数的作用是保证参数化后的分布参数满足其数学约束**——概率在 $[0,1]$、期望计数为正，等等。

**4.5 独立性假设的简短说明**

用一个 `.callout-note` 简短提醒：

```
::: {.callout-note}
### 关于独立性假设
本章的似然函数均假设观测之间**条件独立**，即在给定 $x_i$ 的条件下，  
$y_i$ 与 $y_j$（$i \neq j$）相互独立。  
若数据存在时间序列相关、面板相关或聚类相关，似然函数和推断方式需要相应调整，  
这些情形将在后续相关章节中讨论。
:::
```

**图形**：引用 `fig05_parameterization`

---

### 1.8 第 5 节：正态模型、线性回归与 OLS 的关系

**写作目标**：通过「OLS 是 MLE 特例」这一结论，消除学生对 MLE 的陌生感，建立两个估计框架之间的桥梁。

**内容要点**：

**5.1 正态均值模型的 MLE**

设 $y_i \sim N(\mu, \sigma^2)$，$\sigma^2$ 已知，估计 $\mu$。对数似然：

$$
\ell(\mu) = -\frac{n}{2}\ln(2\pi\sigma^2) - \frac{1}{2\sigma^2}\sum_{i=1}^n(y_i - \mu)^2
$$

最大化等价于最小化 $\sum(y_i - \mu)^2$，因此 $\hat{\mu}_{MLE} = \bar{y}$。

引用 `fig06_normal_fit_mu`（三条正态密度曲线对比）和 `fig07_loglik_mu_curve`（对数似然曲线）。

**5.2 正态线性模型与 OLS 的等价性**

设 $y_i \mid x_i \sim N(x_i^\top\beta, \sigma^2)$：

$$
\ell(\beta, \sigma^2) = -\frac{n}{2}\ln(2\pi\sigma^2) - \frac{1}{2\sigma^2}\sum_{i=1}^n(y_i - x_i^\top\beta)^2
$$

关于 $\beta$ 最大化，等价于最小化残差平方和。

用 `.callout-important` 突出：

```
::: {.callout-important}
### OLS 是 MLE 的特例

在**正态误差 + 同方差**假设下，OLS 估计量等价于 MLE 估计量。  

换句话说：你每次做线性回归，其实已经在用 MLE 的思路了——  
只是正态假设使得「极大化似然」与「最小化残差平方和」碰巧给出了同样的结果。  

OLS 之所以显得「简单」，不是因为它和 MLE 无关，  
恰恰相反，是因为在正态同方差假设下，MLE 化简成了最小二乘。
:::
```

引用 `fig08_ols_is_mle`（RSS 与负对数似然的对应关系）。

**5.3 为什么 Logit 不能用 OLS**

- 强行用 OLS 估计 0/1 因变量（线性概率模型）会得到预测概率超出 $[0,1]$ 的结果
- 更根本的原因：Bernoulli 分布的对数似然与正态分布完全不同，极大化 Bernoulli 似然不等价于 OLS
- 因此 Logit 必须用 MLE，而不是 OLS

---

### 1.9 第 6 节：MLE 的一般工作流程

**写作目标**：给学生一个可操作的「菜谱」，后续章节遇到任何 MLE 模型时都能套用这个框架来理解。

**内容要点**：

**Step 1：识别因变量类型与研究目标**

| 因变量类型 | 分布假设候选 | 常见模型 |
|-----------|------------|---------|
| 连续型（近似对称）| 正态分布 | 线性回归 |
| 二元 0/1 | 伯努利分布 | Logit、Probit |
| 有序多类别 | 有序分布 | 有序 Logit |
| 无序多类别 | 多项分布 | 多项 Logit |
| 非负计数 | 泊松、负二项分布 | Poisson、NegBin |
| 截断/删失连续 | 截断正态 | Tobit |
| 存在样本选择 | 二元正态 | Heckman |

**Step 2：设定条件分布 $f(y_i \mid x_i, \theta)$**

- 这是建模最重要的假设，错误的分布设定会导致参数估计偏误

**Step 3：参数化**

- 选择连接函数，将分布参数写成 $x_i$ 的函数
- 决定哪些解释变量进入模型

**Step 4：写出对数似然函数**

$$
\ell(\theta) = \sum_{i=1}^n \ln f(y_i \mid x_i, \theta)
$$

**Step 5：极大化，进行推断**

- 若有解析解：令一阶条件为零
- 若无解析解（大多数非线性模型）：由软件的数值优化算法处理

用 `.callout-note` 说明数值优化的角色：

```
::: {.callout-note}
### 关于数值优化
Logit、Probit、Tobit 等模型的对数似然函数通常没有解析解。  
软件（Python 的 `statsmodels`、Stata）背后运行的是迭代优化算法（如 Newton-Raphson、BFGS），  
通过反复更新参数猜测值，直到找到使对数似然最大的参数。  
这些算法的细节将在「最优化方法」一章中详细介绍。
:::
```

在本节末尾加入「3 个核心问题」callout，帮助学生在后续章节中举一反三：

```
::: {.callout-tip}
### 遇到「某模型用 MLE 估计」时，问自己这三个问题

1. **因变量是什么类型？** → 决定分布假设
2. **假定了什么条件分布？** → 决定似然函数的形式
3. **分布参数是如何写成 $x_i$ 的函数的？** → 决定模型的具体结构

能回答这三个问题，你就理解了这个模型的估计逻辑。
:::
```

---

### 1.10 第 7 节：如何解读软件输出中的似然指标

**写作目标**：面向实际操作，帮助学生看懂 Python/Stata 给出的估计结果输出。以 Python（statsmodels）为主，Stata 作为对照补充。

**内容要点**：

本节以一个 Logit 模型的完整输出为主线，逐一解读各个指标。先展示 Python 输出（主），再在结尾给出 Stata 输出对照（辅）。

**7.1 Log-Likelihood**

- Python/Stata 输出中均报告收敛时的 $\ell(\hat{\theta})$ 值
- 对于同一数据集，$\ell$ 越大说明模型对数据的解释能力越强
- **注意**：不同数据集之间的 $\ell$ 不可比较（因为数据规模不同）

**7.2 似然比检验（LR Test）**

类比 OLS 中的 F 检验：F 检验比较「加入某些变量是否显著改善」，LR test 做同样的事：

$$
LR = -2[\ell(\hat{\theta}_R) - \ell(\hat{\theta}_U)] \sim \chi^2(q)
$$

- $q$ = 约束数量（被检验的参数个数）
- Python 输出中的 `LLR p-value` 是这个检验的 p 值

**7.3 AIC 与 BIC**

$$
AIC = -2\ell(\hat{\theta}) + 2k, \qquad BIC = -2\ell(\hat{\theta}) + k\ln n
$$

- $k$ = 参数个数，越小越好
- 用途：比较非嵌套模型（如 Logit vs. Probit），LR test 无法处理这种情况
- BIC 对参数数量惩罚更重，在大样本下更倾向选择简单模型

**7.4 Pseudo R²**

$$
R^2_{McFadden} = 1 - \frac{\ell(\hat{\theta})}{\ell(\hat{\theta}_0)}
$$

- $\ell(\hat{\theta}_0)$ = 只含截距的零模型的对数似然
- 取值范围 $[0,1)$，但**不能类比 OLS 的 $R^2$**，不代表「方差解释比例」
- 只作为辅助参考指标，不宜对其赋予过强的实质含义

**7.5 系数解释与边际效应**

- 在线性回归中，$\hat{\beta}_j$ 可以直接解释为「$x_j$ 变化一单位，$y$ 的平均变化量」
- 在 Logit、Poisson 等非线性模型中，$\hat{\beta}_j$ **不能**直接当作「单位变化效应」来读——因为连接函数是非线性的
- 需要通过进一步计算（边际效应、预测概率）才能得到可解释的效应量
- 这些计算方法在后续 Logit/Probit 章节会详细展开

**Python 软件输出示例**（展示 `statsmodels.Logit` 的典型输出，并逐行注释）：

```
Optimization terminated successfully.
         Current function value: 0.523104       ← 负对数似然（除以 n）

                           Logit Regression Results
==============================================================================
Dep. Variable:                default   No. Observations:                 1000
Model:                          Logit   Df Residuals:                      997
Method:                           MLE   Df Model:                            2
Date:                        ...       Pseudo R-squ.:                  0.0754  ← McFadden R²
Time:                        ...       Log-Likelihood:                -523.10  ← 对数似然值
converged:                       True   LL-Null:                       -565.67  ← 零模型对数似然
Covariance Type:            nonrobust   LLR p-value:                 1.23e-19  ← 似然比检验 p 值
==============================================================================
                 coef    std err          z      P>|z|      [0.025      0.975]
------------------------------------------------------------------------------
const         -7.2341      0.821     -8.811      0.000      -8.843      -5.625
income         1.3752      0.159      8.648      0.000       1.063       1.687
age_std       -0.8203      0.097     -8.449      0.000      -1.011      -0.630
==============================================================================
```

在代码块下方加 Markdown 说明：
- `Log-Likelihood`：MLE 迭代收敛后的对数似然值
- `LL-Null`：只含截距的零模型的对数似然，Pseudo R² 由此计算
- `LLR p-value`：对「所有系数均为零」的似然比检验，p 值越小说明模型越显著
- `converged: True`：优化算法已收敛，若为 False 则结果不可靠

**Stata 软件输出对照**（置于独立的 callout 中，可整体删除）：

```
::: {.callout-note collapse="true"}
### Stata 输出对照

​```stata
. logit default income age_std

Logistic regression                             Number of obs   =       1000
                                                LR chi2(2)      =      85.14  ← 同 LLR p-value
                                                Prob > chi2     =     0.0000
Log likelihood = -523.104                       Pseudo R2       =     0.0751  ← McFadden R²
------------------------------------------------------------------------------
     default |      Coef.   Std. Err.       z    P>|z|   [95% Conf. Interval]
-------------+----------------------------------------------------------------
      income |   1.375204   .1590619     8.65   0.000    1.063448    1.686959
     age_std |  -.8202597   .0971019    -8.45   0.000   -1.010576   -.6299432
       _cons |  -7.234052   .8209012    -8.81   0.000   -8.842989   -5.625115
------------------------------------------------------------------------------
​```

> Stata 中 `LR chi2(2)` 对应 Python 输出中 `LLR p-value` 所依据的 $\chi^2$ 统计量，自由度 = 2（模型有 2 个解释变量）。`Pseudo R2` 与 Python 的 `Pseudo R-squ.` 含义相同。
:::
```

---

### 1.11 第 8 节：使用 MLE 时的常见问题

**写作目标**：面向实际操作，提供「踩坑指南」，每个问题用 2-3 句话说明症状和处理思路。

**内容要点**：

**8.1 模型设定偏误（最重要）**
- MLE 的结果高度依赖分布假设。若分布设定与真实数据生成过程不符，参数估计可能严重偏误。
- 例：对计数数据（交易次数）强行套用正态分布，会忽略计数变量非负的性质，导致预测出现负值。

**8.2 小样本偏误**
- MLE 的优良性质（一致性、渐近正态性）均为**大样本渐近**结论。
- 小样本（通常指 $n < 100$）时，MLE 可能有偏，置信区间覆盖率可能不准确。

**8.3 完全分离**
- Logit/Probit 中：若某个变量能完美区分 $y=0$ 和 $y=1$，似然函数在边界处没有最大值。
- 症状：软件给出极大的系数（如 $\hat{\beta} > 50$）和极大的标准误，或发出不收敛警告。
- 处理：检查变量是否存在完美预测关系，必要时删除该变量或减少分组数量。

**8.4 收敛失败**
- 软件报告「did not converge」或「Hessian is not positive definite」。
- 常见原因：多重共线性、变量量纲差异过大、初始值选择不当。
- 处理：标准化变量（均值为 0、标准差为 1），检查共线性，尝试多个初始值。

**8.5 局部极大值**
- 复杂模型的对数似然函数可能存在多个局部最大值，数值优化可能只找到其中一个。
- 处理：从多个不同初始值出发分别优化，比较最终收敛结果是否一致。

---

### 1.12 第 9 节：小结——MLE 为后续各类模型提供统一语言

**写作目标**：回扣全章核心主线，给出统一框架表，为后续章节的学习做铺垫。

**内容要点**：

**9.1 回顾核心主线**

再次引用 `fig01_flowchart`，并用两句总纲式表述呼应导言：

- MLE 的核心在于「分布假设 + 参数化」，而不在于求导本身
- 后续模型的差异只在于分布设定和连接函数，估计原则完全相同

**9.2 统一框架表**

| 模型 | 因变量类型 | 分布假设 | 参数化方式 | 连接函数 | 待讲章节 |
|------|-----------|---------|-----------|---------|---------|
| 线性回归（OLS） | 连续型 | 正态 $N(\mu_i, \sigma^2)$ | $\mu_i = x_i^\top\beta$ | 恒等 | 已讲 |
| Logit | 二元 0/1 | 伯努利 $\text{Bern}(p_i)$ | $p_i = \Lambda(x_i^\top\beta)$ | Logistic | 下一章 |
| Probit | 二元 0/1 | 伯努利 $\text{Bern}(p_i)$ | $p_i = \Phi(x_i^\top\beta)$ | 正态 CDF | 下一章 |
| Tobit | 截断连续 | 截断正态 | $y_i^* = x_i^\top\beta + \varepsilon_i$ | 恒等（带截断） | 后续章节 |
| Poisson | 非负计数 | 泊松 $\text{Pois}(\lambda_i)$ | $\lambda_i = \exp(x_i^\top\beta)$ | 指数 | 后续章节 |
| Heckman | 有选择偏误 | 二元正态 | 两方程联立 | 两阶段 | 后续章节 |

在表格下方加一句总结：**分布不同 → 似然函数不同 → 估计结果不同；但「极大化对数似然」这一步，对所有模型都是一样的。**

**9.3 延伸阅读**

用 `.callout-tip` 给出参考资料，见 Part 5。

---

## Part 2：`MLE_codes.ipynb` 写作任务

### 2.1 文件整体结构

```
[Markdown Cell] 文件说明与用途
[Code Cell]     导入库与全局设置
──────────────────────────────────────────
[Section 1] fig01：总流程图
[Section 2] fig02：概率 vs. 似然对比图
[Section 3] fig03, fig04：Bernoulli 例子图形
[Section 4] fig05：参数化示意图
[Section 5] fig06, fig07：正态模型图形
[Section 6] fig08：OLS 与 MLE 等价性图
──────────────────────────────────────────
[Section 7] 生成模拟数据并保存（data01~data03）
```

> **注意**：v1.0 中的 fig09（工作流程图）与 fig01（总流程图）功能高度重叠，v2.0 删除 fig09。数据集从 4 个减少为 3 个（删除 MLogit 数据，MLogit 相关内容移至后续章节）。图形总数从 9 张压缩为 8 张。

### 2.2 环境设置

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from scipy import stats
from scipy.optimize import minimize
import os

# 创建输出文件夹
os.makedirs('./figs', exist_ok=True)
os.makedirs('./data', exist_ok=True)

# 全局绘图设置
plt.rcParams.update({
    'font.family': 'SimHei',          # Windows：SimHei；Linux：Noto Sans CJK SC
    'axes.unicode_minus': False,
    'figure.dpi': 150,
    'savefig.dpi': 300,
    'figure.figsize': (6, 4),
    'axes.spines.top': False,
    'axes.spines.right': False,
})

# 颜色方案
COLOR_PRIMARY   = '#2C6BAC'   # 主色：蓝色
COLOR_SECONDARY = '#f0da0ef4'   # 辅色：黄绿色
COLOR_NEUTRAL   = '#888888'   # 中性：灰色
COLOR_FILL      = '#D6E8F7'   # 填充：淡蓝
```

- 线宽：1.5
- 标记大小：9-10
- 字体大小：标题 12-14，坐标轴标签 10-11，图例 9-10
- 图像尺寸：宽 6 英寸，高 4 英寸（适合讲义排版）
- 颜色方案：主色为蓝色，辅色为黄绿色，填充色为淡蓝，灰色用于辅助元素
- 保存格式：PNG，分辨率 300 dpi，确保清晰度
  

### 2.3 各图形的详细规格

---

#### 图 01：`method_MLE_fig01_flowchart.png`
**总流程图：数据 → 分布假设 → 参数化 → 似然 → MLE → 推断**

**Markdown cell 内容**：

> 本图展示 MLE 的完整分析链条，是本章的「导航图」，在导言和小结中均需引用。横向流程图，圆角矩形节点，箭头连接。

**代码要求**：
- 用 `matplotlib.patches` 绘制
- 节点内容（从左到右，共 6 个）：
  1. 样本数据 $\{y_i, x_i\}$
  2. 分布假设 $f(y_i \mid x_i, \theta)$
  3. 参数化 $\theta_i = h(x_i, \beta)$
  4. 对数似然 $\ell(\beta) = \sum \ln f$
  5. $\hat{\beta} = \arg\max\, \ell$
  6. 推断 / 预测 / 比较
- 节点填充色 `COLOR_FILL`，箭头颜色 `COLOR_PRIMARY`
- 图注：「图：MLE 的完整分析链条」

---

#### 图 02：`method_MLE_fig02_prob_vs_likelihood.png`
**概率 vs. 似然的直觉对比图（出行方式例子）**

**Markdown cell 内容**：

> 本图用于第 2 节，用出行方式例子直观说明概率与似然的根本区别：概率是参数固定时数据的函数；似然是数据固定时参数的函数。

**代码要求**：
- 左图（概率视角）：
  - 横轴：5 次调查中步行人数 $k$（取值 0-5）
  - 纵轴：$P(Y=k \mid \theta=0.6)$，二项分布
  - 条形图，用不同颜色（`COLOR_SECONDARY`）标注 $k=3$ 那一栏，并加文字标注「已观测到」
  - 标题：「概率视角：$\theta=0.6$ 固定，数据在变」
- 右图（似然视角）：
  - 横轴：$\theta \in (0,1)$
  - 纵轴：$L(\theta) = \theta^3(1-\theta)^2$
  - 连续曲线（`COLOR_PRIMARY`），用竖虚线（`COLOR_SECONDARY`）标注 $\hat{\theta}=0.6$ 处，并加文字标注「最大似然估计值」
  - 标题：「似然视角：数据 $\{1,0,0,1,1\}$ 固定，$\theta$ 在变」
- 图注：「图：概率与似然的根本区别——出行方式例子」

---

#### 图 03：`method_MLE_fig03_bernoulli_likelihood.png`
**$L(\theta)$ 与 $\ln L(\theta)$ 的形状对比**

**Markdown cell 内容**：

> 本图对应讲义第 3 节。展示 Bernoulli 例子（$n=5$，3 人步行）的似然函数与对数似然函数，说明两者峰值位置相同，但对数形式在数值计算上更稳定。

**代码要求**：
- 上图：$L(\theta) = \theta^3(1-\theta)^2$，$\theta \in (0.01, 0.99)$
- 下图：$\ell(\theta) = 3\ln\theta + 2\ln(1-\theta)$，$\theta \in (0.01, 0.99)$
- 两图均用竖虚线标注 $\hat{\theta} = 0.6$，并在峰值处标注坐标
- 曲线颜色 `COLOR_PRIMARY`，虚线颜色 `COLOR_SECONDARY`
- 图注：「图：似然函数与对数似然函数的形状对比——峰值位置相同」

---

#### 图 04：`method_MLE_fig04_bernoulli_grid.png`
**网格搜索示意图**

**Markdown cell 内容**：

> 本图用于讲义第 3 节，展示网格搜索的思路：在 $\theta$ 的可能取值上均匀取点，计算每个点的对数似然值，直观说明「参数估计 = 在参数空间中寻找最优点」，为后续数值优化章节做铺垫。

**代码要求**：
- 在 $\theta \in [0.1, 0.9]$ 内取 17 个等距点
- 计算每点的 $\ell(\theta)$
- 用带竖线的散点图展示（竖线从点垂到 $x$ 轴），最大值点用 `COLOR_SECONDARY` 单独标色
- 在最大值点旁标注坐标 $(\hat{\theta}=0.60,\; \ell=-3.365)$
- 背景叠加灰色连续曲线，方便读者看到网格点与真实函数的关系
- 图注：「图：网格搜索示意——在参数空间中寻找对数似然最大值」

---

#### 图 05：`method_MLE_fig05_parameterization.png`
**参数化变换链示意图**

**Markdown cell 内容**：

> 本图用于讲义第 4 节，展示「线性预测器 → 连接函数 → 分布参数」的变换链。这是正态线性模型、Logit 模型和 Poisson 模型共同骨架的可视化。

**代码要求**：
- 绘制三行三栏的示意图（用文字框 + 箭头）：
  - 左栏：「线性预测器 $\eta_i = x_i^\top\beta$，范围 $(-\infty, +\infty)$」
  - 中栏（箭头上方）：三行分别写「恒等」「Logistic」「指数」
  - 右栏：三行分别写「$\mu_i \in \mathbb{R}$（正态均值）」「$p_i \in (0,1)$（Logit 概率）」「$\lambda_i > 0$（Poisson 强度）」
- 三行分别用三种颜色区分（蓝/橙/绿）
- 图注：「图：参数化变换链——连接函数的作用」

---

#### 图 06：`method_MLE_fig06_normal_fit_mu.png`
**正态模型：不同 $\mu$ 对数据的拟合效果**

**Markdown cell 内容**：

> 本图用于讲义第 5 节。生成 30 个来自 $N(170, 5^2)$ 的模拟数据，展示三条不同均值的正态密度曲线，直观说明「合适的参数才能让分布曲线更好地覆盖数据」。这是正态 MLE 的图形直觉。

**代码要求**：
- 数据：`np.random.seed(42); data = np.random.normal(170, 5, 30)`
- 底部用 rug plot（`|` 形标记，颜色 `COLOR_NEUTRAL`）展示数据位置
- 三条正态密度曲线，$\sigma=5$：
  - $\mu=160$：`COLOR_NEUTRAL`，虚线，标注「$\mu=160$（偏低）」
  - $\mu=170$：`COLOR_PRIMARY`，实线，线宽 2.5，标注「$\mu=170$（MLE 估计值）」
  - $\mu=180$：`COLOR_NEUTRAL`，虚线，标注「$\mu=180$（偏高）」
- 图注：「图：不同 $\mu$ 下的正态密度曲线——$\mu=170$ 时曲线最好地覆盖数据」

---

#### 图 07：`method_MLE_fig07_loglik_mu_curve.png`
**正态模型：对数似然关于 $\mu$ 的曲线**

**Markdown cell 内容**：

> 本图与 fig06 配合使用。展示对数似然 $\ell(\mu)$ 关于 $\mu$ 的变化曲线，峰值恰好在样本均值处，直观验证「MLE 估计量 = 样本均值」。

**代码要求**：
- 使用与 fig06 相同的数据（`np.random.seed(42)`，同一份数据）
- 在 $\mu \in [155, 185]$ 上计算 $\ell(\mu)$（$\sigma=5$，已知）
- 曲线颜色 `COLOR_PRIMARY`
- 用竖虚线（`COLOR_SECONDARY`）标注 $\hat{\mu} = \bar{y}$，并标注「样本均值 $\bar{y}=\cdots$」
- 图注：「图：对数似然 $\ell(\mu)$ 的形状——峰值在样本均值处」

---

#### 图 08：`method_MLE_fig08_ols_is_mle.png`
**OLS 与 MLE 等价性的直观展示**

**Markdown cell 内容**：

> 本图用于讲义第 5 节。生成简单线性回归数据，分别绘制残差平方和 RSS 和负对数似然 $-\ell$ 关于斜率参数 $\beta_1$ 的曲线，说明两者形状相同、极值位置相同——这正是「OLS 是正态假设下 MLE 特例」的直观证明。

**代码要求**：
- 数据：`np.random.seed(42)`，$x_i \sim N(0,1)$，$y_i = 1 + 2x_i + \varepsilon_i$，$\varepsilon_i \sim N(0,1)$，$n=50$
- 固定截距为真值（用 OLS 估计截距固定后），在 $\beta_1 \in [0, 4]$ 上绘制：
  - 左图：$\text{RSS}(\beta_1)$，标题「最小化残差平方和（OLS）」
  - 右图：$-\ell(\beta_1)$（负对数似然，$\sigma^2=1$），标题「最小化负对数似然（MLE）」
- 两图均用竖虚线（`COLOR_SECONDARY`）标注 $\hat{\beta}_1 \approx 2$
- 图注：「图：OLS 与 MLE 给出相同的参数估计——两条曲线极值位置完全一致」

---

### 2.4 模拟数据生成任务

每个数据集生成前须有 Markdown cell，说明：数据内容、DGP 假设、后续用途。

---

#### 数据 01：`method_MLE_data01_normal_linear.csv`

**Markdown cell 内容**：

> **数据说明**：正态线性模型的模拟数据，用于演示 OLS 与 MLE 的等价性。  
> **DGP**：$y_i = 1 + 2x_{1i} - 0.5x_{2i} + \varepsilon_i$，$\varepsilon_i \sim N(0, 1.5^2)$，$n=500$  
> **后续用途**：`MLE_case.ipynb` Case 1，以及后续章节有需要时复用。

```python
np.random.seed(2024)
n = 500
x1  = np.random.normal(0, 1, n)
x2  = np.random.normal(0, 1, n)
eps = np.random.normal(0, 1.5, n)
y   = 1 + 2*x1 - 0.5*x2 + eps

df1 = pd.DataFrame({'y': y, 'x1': x1, 'x2': x2})
df1.to_csv('./data/method_MLE_data01_normal_linear.csv', index=False)
print(f"数据已保存，形状：{df1.shape}")
print(df1.describe().round(3))
```

---

#### 数据 02：`method_MLE_data02_logit.csv`

**Markdown cell 内容**：

> **数据说明**：Logit 模型的模拟数据，模拟「信用卡违约」场景。  
> **DGP**：潜变量 $y_i^* = -2 + 1.5 \cdot \text{income}_i - 0.8 \cdot \text{age\_std}_i + u_i$，$u_i \sim \text{Logistic}(0,1)$，$y_i = \mathbf{1}[y_i^* > 0]$  
> 其中 $\text{income}_i \sim N(5,1)$（万元/月），$\text{age\_std}_i$ 为年龄的标准化值  
> **后续用途**：`MLE_case.ipynb` Case 2，以及后续 Logit/Probit 章节。

```python
np.random.seed(2024)
n       = 1000
income  = np.random.normal(5, 1, n)
age_std = (np.random.normal(35, 8, n) - 35) / 8
u       = np.random.logistic(0, 1, n)
y_star  = -2 + 1.5*income - 0.8*age_std + u
y       = (y_star > 0).astype(int)

df2 = pd.DataFrame({'default': y, 'income': income, 'age_std': age_std})
df2.to_csv('./data/method_MLE_data02_logit.csv', index=False)
print(f"数据已保存，违约率：{y.mean():.3f}")
print(df2.describe().round(3))
```

---

#### 数据 03：`method_MLE_data03_poisson.csv`

**Markdown cell 内容**：

> **数据说明**：Poisson 模型的模拟数据，模拟「月度交易次数」场景。  
> **DGP**：$y_i \sim \text{Poisson}(\lambda_i)$，$\ln\lambda_i = 0.5 + 0.3 \cdot \text{income}_i + 0.2 \cdot \text{experience}_i$，其中 income 和 experience 均来自标准正态分布  
> **后续用途**：`MLE_case.ipynb` Case 3，以及后续 Poisson/计数数据模型章节。

```python
np.random.seed(2024)
n          = 800
income     = np.random.normal(0, 1, n)
experience = np.random.normal(0, 1, n)
lam        = np.exp(0.5 + 0.3*income + 0.2*experience)
y          = np.random.poisson(lam)

df3 = pd.DataFrame({'trade_count': y, 'income': income, 'experience': experience})
df3.to_csv('./data/method_MLE_data03_poisson.csv', index=False)
print(f"数据已保存，交易次数均值：{y.mean():.3f}，最大值：{y.max()}")
print(df3.describe().round(3))
```

---

## Part 3：`MLE_case.ipynb` 写作任务

### 3.1 文件整体结构

```
[Markdown Cell] 案例说明：背景、数据、分析目标
──────────────────────────────────────────────
[Case 1] 正态线性模型：MLE vs. OLS
[Case 2] Logit 模型：二元违约预测
[Case 3] Poisson 模型：计数数据
──────────────────────────────────────────────
[Markdown Cell] 综合小结与模型比较
```

> **说明**：相比 v1.0，删除了 Case 3（MNLogit）。MLogit 认知负担较大，且对理解 MLE 原理帮助有限，移至后续「多项选择模型」章节单独处理。现有 3 个案例已足以覆盖连续、二元、计数三类最重要的因变量类型。

### 3.2 文件开头说明（Markdown Cell）

内容包括：
- 本笔记的教学目标：通过完整的估计过程，理解 MLE 的基本原理
- 数据来源：均使用 `MLE_codes.ipynb` 中生成的模拟数据（不在此处重新生成）
- 分析工具：Python（`statsmodels`、`scipy`）；每个 Case 末尾的 Stata 对应代码置于可折叠 callout 中

### 3.3 Case 1：正态线性模型——MLE vs. OLS

**开头 Markdown cell**：

> **背景**：使用模拟数据 `method_MLE_data01_normal_linear.csv`。在正态误差假设下，MLE 和 OLS 给出数值上高度一致的参数估计——这一节用数值计算来验证「OLS 是 MLE 特例」的理论结论。  
> **数据 DGP**：$y_i = 1 + 2x_{1i} - 0.5x_{2i} + \varepsilon_i$，$\varepsilon_i \sim N(0, 1.5^2)$，$n=500$  
> **分析目标**：对比 OLS 和手动实现的 MLE，观察参数估计值和对数似然。

**代码步骤**：

1. 读入数据，查看描述性统计
2. OLS 估计（`statsmodels.OLS`），记录系数
3. 手动构造正态对数似然，用 `scipy.optimize.minimize` 最大化（最小化负对数似然）
4. 对比两种方法的参数估计值

**结果解读 Markdown cell**（不少于 4 句）：

- 说明两种方法的系数估计值数值上高度一致
- 解释其数学原因：正态假设下极大化似然等价于最小化 RSS
- 指出这意味着每次用 OLS 做线性回归，背后其实就是 MLE 的逻辑
- 说明对数似然值的含义（收敛值越大，说明模型对数据解释能力越强）

**输出格式**：一个对比表格，列为「参数名」「真实值」「OLS 估计」「MLE 估计」；两列估计值应高度一致。

**Stata 对应代码**（独立 callout，可整体删除）：

```
::: {.callout-note collapse="true"}
### Stata 对应代码

​```stata
* Case 1：正态线性模型
import delimited "./data/method_MLE_data01_normal_linear.csv", clear

* OLS 估计
regress y x1 x2

* MLE 估计（正态假设下与 OLS 等价）
* Stata 的 regress 命令已经是正态 MLE，结果完全一致
* 若要显示对数似然，可用：
ml model lf mynormal (y = x1 x2) (lnsigma:)
ml maximize
​```

> 在 Stata 中，`regress` 命令在正态同方差假设下给出与 MLE 完全一致的系数估计。对数似然值可通过 `e(ll)` 调取。
:::
```

---

### 3.4 Case 2：Logit 模型——二元信用违约预测

**开头 Markdown cell**：

> **背景**：使用模拟数据 `method_MLE_data02_logit.csv`，模拟银行信用评分场景。  
> **研究问题**：客户收入和年龄如何影响信用卡违约概率？  
> **方法**：Logit 模型，用 MLE 估计参数；重点展示如何解读软件输出，计算边际效应，并绘制预测概率曲线。

**代码步骤**：

1. 读入数据，计算整体违约率，绘制 income 分组下的违约率条形图
2. 用 `statsmodels.Logit` 估计完整模型，展示完整输出
3. 紧接着的 Markdown cell 逐行解读输出（参照第 7 节的说明格式）：
   - `Log-Likelihood` 是什么
   - `LLR p-value` 是什么
   - `Pseudo R-squ.` 是什么，以及为何不能类比 OLS 的 $R^2$
   - 为何系数不能直接当作「边际效应」读
4. 计算平均边际效应（`result.get_margeff()`），并解读
5. 绘制预测概率曲线：固定 `age_std=0`，展示 income 从 2 到 8 变化时的预测违约概率
6. 模型比较：零模型（只含截距）vs. 完整模型，比较 log likelihood 和 AIC

**结果解读 Markdown cell**：
- 解读收入的边际效应（AME）：income 每增加 1 单位，违约概率平均变化多少个百分点
- 解读预测概率曲线的经济含义
- 说明 AIC 如何判断完整模型优于零模型

**Stata 对应代码**（独立 callout，可整体删除）：

```
::: {.callout-note collapse="true"}
### Stata 对应代码

​```stata
* Case 2：Logit 模型
import delimited "./data/method_MLE_data02_logit.csv", clear

* 估计 Logit 模型
logit default income age_std

* 平均边际效应（AME）
margins, dydx(*)

* 预测概率
predict p_hat, pr
summarize p_hat

* 固定 age_std=0，预测不同 income 下的概率
margins, at(income=(2(0.5)8) age_std=0)
marginsplot, noci
​```

> `margins, dydx(*)` 对应 Python 中的 `result.get_margeff()`。Stata 默认计算 AME（平均边际效应）。
:::
```

---

### 3.5 Case 3：Poisson 模型——月度交易计数

**开头 Markdown cell**：

> **背景**：使用模拟数据 `method_MLE_data03_poisson.csv`，模拟客户月度交易次数。  
> **研究问题**：收入和从业年限如何影响交易次数的期望值？  
> **方法**：Poisson 回归；重点展示计数数据与正态假设的对比，以及指数形式连接函数的含义。

**代码步骤**：

1. 读入数据，绘制交易次数的分布直方图，叠加同均值的正态密度曲线进行对比，用 Markdown cell 说明「为什么计数数据不适合正态假设」
2. 用 `statsmodels.Poisson` 估计模型，展示输出
3. 紧接着的 Markdown cell 解读：
   - Poisson 回归的系数含义：$\hat{\beta}_j$ 表示 $x_j$ 增加 1 单位，期望计数的**对数**变化，即 $\exp(\hat{\beta}_j)$ 是期望计数的乘数倍率
   - 边际效应（AME）的含义：$x_j$ 增加 1 单位，期望交易次数平均变化多少次
4. 计算边际效应（`result.get_margeff()`）
5. 绘制预测均值曲线：固定 `experience=0`，展示 income 从 -2 到 2 变化时的预测交易次数

**Stata 对应代码**（独立 callout，可整体删除）：

```
::: {.callout-note collapse="true"}
### Stata 对应代码

​```stata
* Case 3：Poisson 模型
import delimited "./data/method_MLE_data03_poisson.csv", clear

* 估计 Poisson 回归
poisson trade_count income experience

* 发生率比（Incidence Rate Ratio，即 exp(beta)）
poisson trade_count income experience, irr

* 平均边际效应
margins, dydx(*)

* 预测均值曲线
margins, at(income=(-2(0.25)2) experience=0)
marginsplot, noci
​```

> `poisson` 的 `irr` 选项输出 $\exp(\hat{\beta})$，即「每增加 1 单位 $x$，期望计数变为原来的多少倍」。
:::
```

---

### 3.6 综合小结（Markdown Cell）

制作对比表格：

| 案例 | 模型 | 因变量类型 | 分布假设 | 对数似然 | AIC | 核心发现 |
|------|------|-----------|---------|---------|-----|---------|
| Case 1 | 正态线性 | 连续 | 正态 | （从输出填入）| （从输出填入）| OLS 系数 = MLE 系数 |
| Case 2 | Logit | 二元 0/1 | Bernoulli | （从输出填入）| （从输出填入）| 收入正向影响违约概率 |
| Case 3 | Poisson | 非负计数 | 泊松 | （从输出填入）| （从输出填入）| 收入提升交易期望频率 |

表格下方加一段回扣核心主线的文字：

> 三个案例，三种不同的因变量类型，三种不同的分布假设，三个不同的似然函数——但估计的过程完全相同：设定分布，参数化，写出对数似然，交给软件极大化。这正是 MLE 作为「统一估计语言」的价值所在。

---

## Part 4：质量检查清单

### 4.1 `MLE_lec.qmd` 检查项

- [ ] YAML 头部格式正确，`date: today` 有效
- [ ] 所有图形路径均为 `./figs/method_MLE_fig0N_xxx.png`，且对应文件实际存在
- [ ] 所有图形均有 Quarto 交叉引用标签（如 `{#fig-MLE-flowchart}`）且在正文中至少引用一次
- [ ] 所有公式编号格式正确（`{#eq-xxx}`）
- [ ] 导言和小结均呼应了两句总纲式表述（可改写，含义必须出现）
- [ ] 「统一框架表」出现在第 9 节小结中
- [ ] callout 块类型使用区分合理：`tip` 用于步骤/建议，`note` 用于扩展说明，`warning` 用于常见误解，`important` 用于核心结论
- [ ] 「OLS 是 MLE 特例」用 `.callout-important` 呈现
- [ ] 「似然 ≠ 概率」至少强调两次，其中一次在 `.callout-warning` 中
- [ ] 第 7 节包含 Python 软件输出示例（主）及 Stata 输出对照（在可折叠 callout 中）
- [ ] 「3 个核心问题」callout 出现在第 6 节末
- [ ] 全文专业术语首次出现时附英文，之后只用中文
- [ ] 第 8 节不包含「incidental parameters problem」

### 4.2 `MLE_codes.ipynb` 检查项

- [ ] `figs/` 和 `data/` 文件夹在代码中自动创建（`os.makedirs(..., exist_ok=True)`）
- [ ] 所有图形均以 300 dpi 保存到 `./figs/`，命名规则符合 `method_MLE_fig0N_xxx.png`
- [ ] 所有数据均保存到 `./data/`，命名规则符合 `method_MLE_data0N_xxx.csv`
- [ ] 每个代码 cell 前均有 Markdown cell 说明该 cell 的内容、对应的讲义章节和用途
- [ ] 图形中文标签不乱码（字体设置正确）
- [ ] 所有随机数均使用 `np.random.seed(2024)` 确保可重现（fig06/fig07 的身高数据用 `np.random.seed(42)` 以与讲义叙述一致）
- [ ] 三个数据集均有 `print(df.describe())` 输出
- [ ] 不包含 fig09（已删除）

### 4.3 `MLE_case.ipynb` 检查项

- [ ] 文件开头有完整的案例说明 Markdown cell
- [ ] 三个 Case 均从 `./data/` 读取数据，不在此处重新生成数据
- [ ] 每个 Case 的估计结果后均有 Markdown cell 解读输出（不少于 4 句）
- [ ] 每个 Case 的 Stata 代码置于独立的 `{.callout-note collapse="true"}` 块中，标题为「Stata 对应代码」
- [ ] Stata 代码 cell 与 Python 代码 cell 不混排，各自独立
- [ ] 综合小结包含完整的三行对比表格
- [ ] 图形风格与 `MLE_codes.ipynb` 使用相同的颜色变量和全局设置
- [ ] 不包含 MLogit 案例（已删除）

---

## Part 5：参考资料与延伸阅读

以下资料供 agent 写作时参考，也可作为讲义第 9 节「延伸阅读」的来源。

### 教材
- Greene, W. H. (2012). *Econometric Analysis* (7th ed.). Pearson. Ch. 14: Maximum Likelihood Estimation.
- Cameron, A. C., & Trivedi, P. K. (2005). *Microeconometrics: Methods and Applications*. Cambridge University Press. Ch. 5.
- Wooldridge, J. M. (2010). *Econometric Analysis of Cross Section and Panel Data* (2nd ed.). MIT Press.


### 在线资源
- DataCamp Tutorial: [What is Maximum Likelihood Estimation (MLE)?](https://www.datacamp.com/tutorial/maximum-likelihood-estimation-mle)
- StatQuest (YouTube): [Maximum Likelihood, clearly explained!!!](https://www.youtube.com/watch?v=XepXtl9YKwc)
- 课程主页：https://lianxhcn.github.io/dsfin/

---

*Task-guide 版本：v2.0 | 课程：金融数据分析与建模 · Part III · 最大似然估计*

--- 

### 给 Agent 的提示

你根据这个 Task-guide 生成我要求的文档。
开始之前请确认你是否理解任务清单中的要求？是否有疑问或建议？
你只需执行和验证生成的 Python 代码即可，无需执行生成的 Stata 代码。