# Part V 机器学习：写作风格指南
**《金融数据分析与建模》| 中山大学岭南学院**  
**版本：v1.1 | 2026-04**  
**适用范围：ml_A 至 ml_F 所有讲义、代码和案例文档**

> **使用说明**：本指南是 Part V 所有章节写作的唯一规范来源。写作任何新内容前，先查阅相关条目；遇到规范未覆盖的情形，在此文件末尾补充，并注明适用章节。

---

## 目录

1. [文件命名规范](#1-文件命名规范)
2. [QMD 讲义文档头设置](#2-qmd-讲义文档头设置)
3. [章节内部结构模板](#3-章节内部结构模板)
4. [术语表与翻译规范](#4-术语表与翻译规范)
5. [数学符号约定](#5-数学符号约定)
6. [公式排版规范](#6-公式排版规范)
7. [Callout 使用规则](#7-callout-使用规则)
8. [交叉引用规范](#8-交叉引用规范)
9. [图形规范](#9-图形规范)
10. [代码规范（ipynb）](#10-代码规范ipynb)
11. [写作语言与文风](#11-写作语言与文风)
12. [各章定位与边界说明](#12-各章定位与边界说明)
13. [版本管理与修订记录](#13-版本管理与修订记录)

---

## 1. 文件命名规范

### 1.1 命名结构

```
ml_{章节字母}_{主题简称}_{文件类型}.{扩展名}
```

| 占位符 | 说明 | 示例 |
|--------|------|------|
| `{章节字母}` | A-F，对应 Part V 各章 | `A`, `B`, `C` |
| `{主题简称}` | 2-6 个英文小写字母 | `intro`, `lasso`, `trees`, `causal` |
| `{文件类型}` | `lec`（讲义）/ `codes`（配图代码）/ `case`（案例）| `lec`, `codes`, `case` |

### 1.2 完整文件清单

```
ml_A_intro_lec.qmd          Chapter A 讲义
ml_A_intro_codes.ipynb      Chapter A 配图代码

ml_B_lasso_lec.qmd          Chapter B 讲义
ml_B_lasso_codes.ipynb      Chapter B 配图代码
ml_B_lasso_case.ipynb       Chapter B 案例

ml_C_trees_lec.qmd          Chapter C 讲义
ml_C_trees_codes.ipynb      Chapter C 配图代码
ml_C_trees_case.ipynb       Chapter C 案例

ml_D_svm_lec.qmd            Chapter D 讲义
ml_D_svm_codes.ipynb        Chapter D 配图代码
ml_D_svm_case.ipynb         Chapter D 案例

ml_E_unsup_lec.qmd          Chapter E 讲义
ml_E_unsup_codes.ipynb      Chapter E 配图代码
ml_E_unsup_case.ipynb       Chapter E 案例

ml_F_causal_lec.qmd         Chapter F 讲义
ml_F_causal_codes.ipynb     Chapter F 配图代码
ml_F_causal_case.ipynb      Chapter F 案例

ml_ref_python.ipynb         Python 实操参考手册（全 Part 共用）
refs_mlV.bib                参考文献库（Part V 专用，写完后并入全书 .bib）
ml_style_guide.md           本文件
```

### 1.3 数据文件命名

```
sim_{章节字母}_{描述}.csv      模拟数据，如 sim_B_sparse_regression.csv
data_{描述}.csv                真实数据，如 data_ashare_monthly_ret.csv
```

---

## 2. QMD 讲义文档头设置

所有 `_lec.qmd` 文件使用以下统一文档头，仅修改 `title`、`subtitle`、`date` 三项：

```yaml
---
title: "Chapter X  标题"
subtitle: "《金融数据分析与建模》Part V · 机器学习"
author: "连玉君（中山大学岭南学院）"
date: today
date-format: "YYYY年MM月DD日"

format:
  html:
    theme: cosmo
    toc: true
    toc-depth: 3
    toc-title: "本章目录"
    toc-location: left
    number-sections: true
    number-depth: 3
    code-fold: true
    code-tools: true
    code-copy: true
    highlight-style: github
    fig-align: center
    fig-cap-location: bottom
    fig-width: 7
    fig-height: 4.5
    embed-resources: false
    smooth-scroll: true
    link-external-newwindow: true
    html-math-method: mathjax

execute:
  echo: true
  eval: false       # 讲义中代码默认不运行，只展示
  warning: false
  message: false

bibliography: refs_mlV.bib
csl: apa-6th-edition.csl
lang: zh

# 章节内部交叉引用前缀
crossref:
  fig-prefix: "图"
  tbl-prefix: "表"
  eq-prefix: "式"
  sec-prefix: "节"
---
```

**说明：**
- `eval: false` 是默认值，确保讲义渲染速度快。若某节需要运行代码生成输出，在该代码块单独设置 `#| eval: true`
- 所有讲义共用同一个参考文献库 `refs_mlV.bib`
- `embed-resources: false` 配合 Quarto 项目统一管理资源文件

---

## 3. 章节内部结构模板

每一章的 `_lec.qmd` 文件必须包含以下固定模块，顺序不可变：

```markdown
## 本章概览 {.unnumbered}

::: {.callout-note appearance="minimal"}
**学习目标**

完成本章学习后，你应该能够：

1. [具体的、可检验的目标，动词开头]
2. ...
3. ...

**与其他章节的关系**

- 前置知识：[列出必须掌握的前序章节，含具体节号]
- 后续章节：[说明本章为哪些后续章节奠定了哪些基础]
- 参考手册：相关 Python 实现见 `ml_ref_python.ipynb` 第 X 节
:::

---

## X.1  [第一节标题]
...

## X.N  本章小结

[3-5 段，概括本章核心内容，重申重要结论，
 并明确说明本章方法的适用边界和局限性]

## 参考文献 {.unnumbered}
```

**关于学习目标的写法：** 用可观测的行为动词，不用"了解"、"理解"，而用"解释"、"推导"、"应用"、"比较"、"判断"。例如：
- ✗ 了解 Lasso 的基本原理
- ✓ 解释为什么 ℓ₁ 范数能产生稀疏解，而 ℓ₂ 范数不能
- ✓ 在给定数据特征（样本量、变量数、稀疏程度）的情况下，判断应选择 CV 还是 Plugin 方法来确定调节参数

---

## 4. 术语表与翻译规范

### 4.1 核心原则

- 每个概念**只有一个**中文译名，全 Part 统一使用
- 首次出现时格式：`中文译名（英文原名，英文缩写）`，例如：`均方误差（Mean Squared Error，MSE）`
- 再次出现时直接用中文译名（或缩写），不再附英文
- 不要在同一文档中混用不同译名

### 4.2 术语对照表

| 英文 | 中文译名 | 禁止使用的其他译法 |
|------|---------|-----------------|
| Machine Learning | 机器学习 | — |
| Supervised Learning | 监督学习 | 有监督学习 |
| Unsupervised Learning | 无监督学习 | 非监督学习 |
| Loss Function | 损失函数 | 代价函数（仅在引用原文时可括注）|
| Regularization | 正则化 | 规则化、正规化 |
| Penalized Regression | 惩罚回归 | 正则化回归 |
| Overfitting | 过拟合 | 过度拟合 |
| Underfitting | 欠拟合 | — |
| Bias-Variance Tradeoff | 偏差-方差权衡 | 方差-偏差权衡（顺序固定：偏差在前）|
| Cross-Validation | 交叉验证 | — |
| Training Set | 训练集 | 训练样本（可接受，但同一文档内统一）|
| Validation Set | 验证集 | 开发集 |
| Test Set | 测试集 | 检验集 |
| Hyperparameter | 超参数 | 调节参数（仅 Lasso 语境中 λ 可称"调节参数"）|
| Feature | 特征 | 变量（两者均可，但同一段落内统一）|
| Label / Target | 标签 / 目标变量 | — |
| Sparsity | 稀疏性 | — |
| Tuning Parameter | 调节参数 | 惩罚参数 |
| Soft Thresholding | 软阈值 | — |
| Hard Thresholding | 硬阈值 | — |
| Coordinate Descent | 坐标下降法 | — |
| Bootstrap | Bootstrap（保留英文）| 自助法（括注说明即可）|
| Out-of-Bag | 袋外（OOB）| — |
| Feature Importance | 特征重要性 | 变量重要性（可接受）|
| SHAP Value | SHAP 值 | — |
| Causal Forest | 因果森林 | — |
| Treatment Effect | 处理效应 | 干预效应 |
| Double Selection Lasso | 双重选择 Lasso（DS-Lasso）| — |
| Partialing-out Lasso | 部分消除 Lasso（PO-Lasso）| — |
| Double/Debiased ML | 双重去偏机器学习（DML）| 双重机器学习 |
| Cross-fitting | 交叉拟合 | — |
| Nuisance Function | 干扰函数 | 冗余函数 |
| Elastic Net | 弹性网 | — |
| Lasso | Lasso（保留英文）| 套索回归（括注说明即可）|
| Ridge Regression | 岭回归 | — |
| Information Criterion | 信息准则 | 信息标准 |
| Norm | 范数 | — |
| Gradient Boosting | 梯度提升 | — |
| Random Forest | 随机森林 | — |
| Decision Tree | 决策树 | — |
| Principal Component Analysis | 主成分分析（PCA）| — |
| Clustering | 聚类 | 聚类分析（可接受）|
| Heterogeneous Treatment Effect | 异质性处理效应 | — |
| Conditional Average Treatment Effect | 条件平均处理效应（CATE）| — |

### 4.3 缩写使用规则

以下缩写**首次出现后**可直接使用，无需每次附全称：
`MSE`、`MAE`、`RMSE`、`AIC`、`BIC`、`CV`、`OLS`、`IV`、`DML`、`DDML`、`SHAP`、`PCA`、`ATE`、`CATE`、`PLR`

---

## 5. 数学符号约定

### 5.1 基础符号

| 符号 | 含义 | 备注 |
|------|------|------|
| $n$ | 样本量 | 全 Part 统一用小写 $n$，不用 $N$ |
| $p$ | 变量（特征）数量 | — |
| $s$ | 稀疏度（非零系数个数）| — |
| $K$ | 交叉验证折数 | 大写 $K$ |
| $y_i$ | 第 $i$ 个观测的目标变量 | 标量 |
| $\mathbf{y}$ | 目标变量向量（$n \times 1$）| 粗体小写 |
| $\mathbf{x}_i$ | 第 $i$ 个观测的特征向量（$p \times 1$）| 粗体小写 |
| $\mathbf{X}$ | 特征矩阵（$n \times p$）| 粗体大写 |
| $\boldsymbol{\beta}$ | 系数向量 | 粗体希腊字母 |
| $\lambda$ | 惩罚回归的调节参数 | — |
| $\alpha$ | 弹性网的混合参数 | 注意与显著性水平区分，上下文明确时可复用 |
| $\hat{\cdot}$ | 估计量 | $\hat{\beta}$、$\hat{y}$ |
| $\tilde{\cdot}$ | 中间估计量（如残差化后的变量）| $\tilde{Y}$、$\tilde{D}$ |
| $\theta$ | 因果推断中的处理效应参数 | Chapter F 专用 |
| $D$ | 处理变量（Treatment）| Chapter F 专用，大写标量 |
| $g(\cdot)$, $m(\cdot)$ | DML 中的干扰函数 | Chapter F 专用 |

### 5.2 范数符号

| 符号 | 含义 |
|------|------|
| $\|\cdot\|_0$ | ℓ₀ 范数（非零元素个数）|
| $\|\cdot\|_1$ | ℓ₁ 范数 |
| $\|\cdot\|_2$ | ℓ₂ 范数（欧氏范数）|
| $\|\cdot\|_2^2$ | ℓ₂ 范数的平方 |
| $\|\cdot\|_\infty$ | ℓ∞ 范数（sup 范数）|

### 5.3 集合与逻辑符号

| 符号 | 含义 |
|------|------|
| $\mathcal{S}_k$ | 第 $k$ 折样本集合 |
| $\mathcal{S}_{-k}$ | 去除第 $k$ 折后的样本集合 |
| $\mathbf{1}\{\cdot\}$ | 示性函数 |
| $\mathbb{E}[\cdot]$ | 期望算子 |
| $\operatorname{Var}(\cdot)$ | 方差算子 |
| $\operatorname{Bias}(\cdot)$ | 偏差算子 |

### 5.4 禁止混用的符号

- `$N$` 和 `$n$` 不得在同一文档中混用表示样本量，统一用 `$n$`
- `$\alpha$` 在弹性网上下文中专指混合参数，在假设检验上下文中专指显著性水平，两者出现在同一节时必须明确说明

---

## 6. 公式排版规范

### 6.1 行内公式 vs. 独立公式块

- **行内公式**（`$...$`）：用于简短的符号说明，如"其中 $\lambda > 0$"
- **独立公式块**（`$$...$$`）：用于需要重点展示的公式，以及所有需要编号的公式

### 6.2 公式编号

- 需要在正文中引用的公式必须编号
- 编号格式：`{#eq-章节字母-序号}`，如 `{#eq-B-lasso-obj}`
- 引用时用 `@eq-B-lasso-obj`，渲染为"式 (B.1)"

```markdown
$$
\min_{\beta} \left\{ \frac{1}{2n} \|\mathbf{y} - \mathbf{X}\boldsymbol{\beta}\|_2^2 + \lambda\|\boldsymbol{\beta}\|_1 \right\}
$$ {#eq-B-lasso-obj}

如式 @eq-B-lasso-obj 所示，Lasso 的目标函数由两部分构成……
```

- **不需要编号的公式**：推导过程中的中间步骤，用 `$$...$$` 不加标签即可

### 6.3 公式前后文字

每个独立公式块前后必须有文字，不允许公式直接跟公式，也不允许公式作为段落的第一个元素。格式：

```
[引导句，说明公式的含义或来源]，

$$...公式...$$  {#eq-xxx}

其中，[逐项解释各符号的含义，每项占一行或用逗号隔开]。
```

---

## 7. Callout 使用规则

### 7.1 五种 Callout 及其用途

Quarto 中使用 `::: {.callout-类型}` 语法。Part V 规定五种类型，**严格按照用途使用，不得随意替换**：

---

**`callout-note`（蓝色）：补充说明与延伸阅读**

用于：不影响主线理解、但有助于深入学习的内容，包括：
- 数学推导细节（如 MSE 分解证明）
- 算法内部机制（如坐标下降法的收敛性证明）
- 与其他章节的关联说明
- 参考文献与扩展阅读

```markdown
::: {.callout-note collapse="true"}
## 推导：MSE 的偏差-方差分解

[推导内容]
:::
```

`collapse="true"` 表示默认折叠，用于较长的数学推导；较短的补充说明不折叠。

---

**`callout-tip`（绿色）：实践技巧与提示词模板**

用于：
- Python 实操技巧
- 提示词（Prompt）模板
- 软件使用注意事项（如"使用 Lasso 前必须标准化"）
- 结果解读要点

```markdown
::: {.callout-tip}
## 💬 提示词模板：[任务名称]

[提示词内容]
:::
```

---

**`callout-important`（红色/橙色）：假设条件与方法边界**

用于：
- 方法的核心假设（违反时结论不成立）
- 方法的适用边界（超出范围时应换用其他方法）
- 容易犯的错误及其后果

```markdown
::: {.callout-important}
## ⚠️ [标题]

[内容]
:::
```

---

**`callout-warning`（黄色）：常见错误警示**

用于：
- 学生在实操中高频出现的错误
- 容易与相似概念混淆的地方
- 数据泄露、时间顺序错误等典型陷阱

```markdown
::: {.callout-warning}
## 🚫 常见错误：[描述]

[内容]
:::
```

---

**`callout-caution`（橙色）：金融应用中的特殊注意事项**

用于：
- 金融数据的特殊性（如时序数据不可随机分割）
- 模型在金融场景中的已知局限
- 实证研究中需要额外报告的稳健性检验

```markdown
::: {.callout-caution}
## 📊 金融应用注意：[描述]

[内容]
:::
```

### 7.2 Callout 使用频率参考

每节（二级标题下）Callout 的建议数量：
- `callout-note`：0-2 个
- `callout-tip`（提示词）：0-1 个
- `callout-important`：0-1 个
- `callout-warning` / `callout-caution`：0-1 个

避免 Callout 密集排列（连续超过 2 个 callout 而无正文段落），否则正文主线会被打断。

---

## 8. 交叉引用规范

### 8.1 章内引用

引用本章的图、表、公式、节，直接用 Quarto 的 `@` 语法：

```markdown
如图 @fig-B-lasso-path 所示……
见 @eq-B-lasso-obj 式……
详见 @sec-B-coordinate-descent 节……
```

### 8.2 跨章引用（同 Part 内）

跨章引用时，明确写出章节标识，不依赖自动链接：

```markdown
偏差-方差权衡已在 Chapter A（@sec-A-bias-variance）中详细介绍，
此处仅引用核心结论：$\text{MSE} = \text{Bias}^2 + \text{Var}$。
```

### 8.3 引用其他 Part 的内容

```markdown
有关 Logit 模型的损失函数，参见第 33 章（二元选择模型）§33.3。
```

**规则**：跨 Part 引用时，用章节编号（33 章）而非文件名，便于印刷版和网页版通用。

### 8.4 标签命名规范

```
图：  #fig-{章节字母}-{描述}       如 #fig-B-lasso-path
表：  #tbl-{章节字母}-{描述}       如 #tbl-A-method-comparison
公式：#eq-{章节字母}-{描述}        如 #eq-B-lasso-obj
节：  #sec-{章节字母}-{描述}       如 #sec-A-bias-variance
```

---

## 9. 图形规范

### 9.1 全局设置代码块

每个 `codes.ipynb` 和 `case.ipynb` 的**第一个代码 Cell** 必须包含以下全局设置，与课程现有讲义（如第 18 章、第 41 章）保持完全一致。**直接复制，不得修改结构**，只在注释允许处按需调整参数：

```python
# ════════════════════════════════════════════════════════════════
# 全局设置（每次使用前必须首先运行此 Cell）
# ════════════════════════════════════════════════════════════════
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib as mpl
import seaborn as sns
from scipy import stats
import warnings
warnings.filterwarnings("ignore")
mpl.set_loglevel("error")

# ── 中文字体支持 ──────────────────────────────────────────────────
plt.rcParams["font.family"]       = "SimHei"   # Windows: SimHei; Mac: Heiti TC
plt.rcParams["axes.unicode_minus"] = False

# ── 全局样式 ──────────────────────────────────────────────────────
plt.rcParams['figure.dpi']        = 120
plt.rcParams['savefig.dpi']       = 300
plt.rcParams['font.size']         = 11
plt.rcParams['axes.titlesize']    = 13
plt.rcParams['axes.labelsize']    = 11
plt.rcParams['xtick.labelsize']   = 10
plt.rcParams['ytick.labelsize']   = 10
plt.rcParams['legend.fontsize']   = 10
plt.rcParams['axes.spines.top']   = False
plt.rcParams['axes.spines.right'] = False

# ── Part V 统一配色常量 ───────────────────────────────────────────
# 在每个图中通过 color=C['primary'] 等方式调用
C = {
    'primary'  : '#2166AC',  # 蓝：主要方法/主曲线
    'secondary': '#D6604D',  # 橙红：对比方法/训练误差
    'tertiary' : '#4DAC26',  # 绿：第三条曲线
    'neutral'  : '#878787',  # 灰：参考线/置信带/次要元素
    'highlight': '#B2182B',  # 深红：最优点/关键标注
    'fill'     : '#D1E5F0',  # 浅蓝填充：置信区间/阴影区域
}

# ── 随机种子（全 Part 统一）───────────────────────────────────────
SEED = 42
np.random.seed(SEED)

print("✅ 全局设置完成")
```

**说明：**

- `C` 字典定义 Part V 的统一配色，**只在此处定义一次**，全文件直接调用
- 颜色来源于 ColorBrewer `RdBu` 配色方案，对色盲友好，打印为灰度时也有区分度
- 若某图需要 5 条以上曲线，使用 `plt.cm.tab10` 调色板补充，不另外硬编码颜色

### 9.2 图形尺寸标准

| 用途 | 宽 × 高（英寸）| 说明 |
|------|--------------|------|
| 单图（全宽）| 7 × 4.5 | 讲义默认 |
| 双图并排 | 每图 3.2 × 4 | 用 `fig-ncol: 2` |
| 三图并排 | 每图 2.2 × 3.5 | 用 `fig-ncol: 3` |
| 系数路径图 | 8 × 5 | 需要更多横向空间 |

### 9.3 图注格式

```markdown
图注格式：[简明标题]。[1-2句说明数据来源或生成方法。]

示例：
- 正确：Lasso 系数路径图。横轴为 ℓ₁ 范数比率，纵轴为标准化系数值。数据由 `sim_B_sparse.csv` 生成（n=200, p=50, s=10）。
- 错误：图1（太简短，无说明）
- 错误：本图展示了在不同λ值下各个变量的系数随着惩罚强度增加而逐渐收缩至零的过程，体现了Lasso的变量筛选功能（太长，改为注释）
```

### 9.4 图形输出规范（codes.ipynb）

```python
# 标准保存格式：同时输出 PNG（讲义用）和 SVG（矢量图备用）
fig.savefig('fig_B_lasso_path.png', dpi=150, bbox_inches='tight',
            facecolor='white')
fig.savefig('fig_B_lasso_path.svg', bbox_inches='tight')
```

所有图形文件保存至 `figs/` 子目录，命名规则：`fig_{章节字母}_{描述}.png`。

---

## 10. 代码规范（ipynb）

### 10.1 Notebook 文件结构

每个 `.ipynb` 文件的固定结构：

```
Cell 1（Markdown）：文件说明块（见下方模板）
Cell 2（Code）：   环境导入（所有 import 集中在此）
Cell 3（Code）：   配置与常量（颜色、随机种子、路径等）
Cell 4+（交替）：  Markdown 小节标题 + Code 实现
最后一格（Markdown）：运行环境说明
```

**文件说明块模板（Cell 1）：**

```markdown
# ml_{章节字母}_{主题}_{类型}.ipynb

**文件类型**：[配图代码 / 案例分析 / 实操手册]  
**所属章节**：Chapter {字母}  {章节标题}  
**课程**：《金融数据分析与建模》Part V · 机器学习  
**作者**：连玉君（中山大学岭南学院）  
**最后更新**：{日期}  

**本文件的用途**：
- [一句话说明主要目的]
- [列出生成的主要输出：图形文件名、数据文件名]

**依赖文件**：
- 输入：[列出依赖的数据文件，若无则写"无，全部自生成"]
- 输出：[列出生成的文件]

**运行说明**：按顺序执行所有 Cell，预计耗时约 {X} 分钟。
```

### 10.2 代码注释规范

注释密度：**关键步骤每行或每2-3行一条注释**，不是每行都写，也不是大段代码无注释。

注释语言：**中文**，专业术语附英文（第一次出现时）。

```python
# 正确示例
# Step 1: 数据标准化（Standardization）
# Lasso 对变量量纲敏感，必须在拟合前标准化
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)  # 只在训练集上 fit
X_test_scaled  = scaler.transform(X_test)        # 测试集用训练集的参数

# 错误示例 1：无注释
X_train_scaled = scaler.fit_transform(X_train)

# 错误示例 2：注释过于冗余
# 使用 StandardScaler 对象的 fit_transform 方法对训练集 X_train 进行拟合和变换
X_train_scaled = scaler.fit_transform(X_train)
```

### 10.3 变量命名规范

```python
# 数据变量
X_train, X_test        # 特征矩阵
y_train, y_test        # 目标变量
X_train_scaled         # 标准化后的特征矩阵

# 模型对象
lasso_cv               # LassoCV 模型
ridge_model            # Ridge 模型
rf_model               # RandomForestRegressor

# 结果变量
y_pred_train           # 训练集预测值
y_pred_test            # 测试集预测值
mse_train, mse_test    # MSE
r2_train, r2_test      # R²

# 模拟数据生成
np.random.seed(42)     # 固定随机种子，写在代码块开头
n, p, s = 200, 50, 10  # 样本量、特征数、真实非零特征数
```

### 10.4 随机种子规范

- 所有涉及随机性的代码（数据生成、CV 分折、RF 等）必须设置随机种子
- **全 Part 统一使用 `seed=42`**（数据生成）和 `random_state=42`（sklearn 对象）
- 在需要展示随机性影响的代码中（如 DML 重复实验），使用 `seed=0, 1, 2, ...` 递增序列，并在注释中说明

### 10.5 输出格式规范

数值结果的打印格式：

```python
# 统一使用 f-string，保留4位小数（系数）或2位小数（指标）
print(f"最优 λ = {lasso_cv.alpha_:.4f}")
print(f"非零系数个数：{np.sum(lasso_cv.coef_ != 0)}")
print(f"测试集 MSE = {mse_test:.4f}")
print(f"测试集 R²  = {r2_test:.4f}")

# 结果汇总表使用 pandas DataFrame
results = pd.DataFrame({
    '方法':    ['OLS', 'Ridge', 'Lasso', '弹性网'],
    '测试MSE': [mse_ols, mse_ridge, mse_lasso, mse_enet],
    '测试R²':  [r2_ols,  r2_ridge,  r2_lasso,  r2_enet],
    '非零系数': [p, p, n_lasso, n_enet],
})
print(results.to_string(index=False, float_format='{:.4f}'.format))
```

---

## 11. 写作语言与文风

### 11.1 基本原则

- **主要语言**：中文，流畅自然，不逐字翻译英文原文
- **技术术语**：首次出现附英文，之后只用中文（见第 4 节）
- **句子长度**：单句不超过 50 字，复杂概念拆成多句
- **段落长度**：每段 3-6 句，聚焦一个核心意思

### 11.2 叙事风格

采用**"问题驱动"**的叙事结构，每个概念的引入方式：

1. **先提问**：这个方法要解决什么问题？（1-2句）
2. **给直觉**：核心思路是什么？用类比或图形说明（2-4句）
3. **写公式**：形式化表达（公式 + 符号说明）
4. **连接实践**：这个性质在实际中意味着什么？（1-2句）

例如（节选自 Chapter A 风格示范）：
> 模型越复杂，对训练数据的拟合越好——这听起来像是好事，但实际上暗藏风险。一个极端的例子是：用 $n$ 次多项式去拟合 $n$ 个数据点，训练误差必然为零，但这样的模型对新数据几乎毫无预测能力。这种现象叫做**过拟合（Overfitting）**。

### 11.3 禁止使用的表达

- "众所周知"、"显然"、"不难看出"（这些往往掩盖了真正需要解释的地方）
- "非常重要"、"极其关键"（改为说清楚为什么重要）
- "略"、"读者可自行验证"（讲义不是论文，该写的要写）
- 大量连续的项目列表（超过 5 个并列项目，考虑改为分节叙述）

### 11.4 金融语境的叙事习惯

每介绍一个统计/机器学习概念，尽量在**一个段落内**给出金融场景的对应：

| 统计概念 | 优先使用的金融类比 |
|---------|-----------------|
| 过拟合 | 策略回测中的曲线拟合（curve fitting）|
| 偏差-方差权衡 | 因子模型：简单模型 vs 高维特征 |
| 交叉验证 | 滚动窗口样本外检验 |
| 稀疏性 | Fama-French 因子定价：少数因子解释大部分收益 |
| 特征重要性 | 哪些财务指标对收益率预测贡献最大 |

---

## 12. 各章定位与边界说明

### 12.1 Chapter A（导论）：概念在此，后续不再重复

以下概念**只在 Chapter A 讲**，B-F 章直接引用，不重复推导：

- MSE 的偏差-方差分解（证明）
- 过拟合的定义与示意图
- K 折交叉验证的算法步骤
- Bootstrap 的基本思想
- ℓ₀/ℓ₁/ℓ₂/ℓ∞ 范数的定义与几何含义
- 训练集/验证集/测试集的划分逻辑
- 分类评估指标（混淆矩阵、AUC-ROC）

后续章节引用方式：
```markdown
有关交叉验证的算法步骤，参见 @sec-A-cross-validation。
此处直接使用 K 折 CV 的结论：选取使验证集 MSE 最小的超参数值。
```

### 12.2 Chapter B（Lasso）：不重复 Chapter A 的内容

损失函数、范数、偏差-方差权衡：Chapter A 已讲，直接引用  
调节参数选择（CV、BIC、Plugin）：**在 Chapter B 详讲**，因为与 Lasso 具体性质深度绑定  
因果推断应用（DS-Lasso 等）：**不在 Chapter B 讲**，统一放入 Chapter F  

### 12.3 Chapter C（树模型）：SHAP 在此详讲

可解释性（SHAP、PDP、ICE）：**只在 Chapter C 详讲**，其他章节需要时引用此处  
Bootstrap 与 OOB：Chapter A 已讲基本思想，Chapter C 说明如何应用于随机森林  

### 12.4 Chapter D（SVM）：完整独立章节，可单独使用

Chapter D 是完整章节，配套三个文件（`_lec`、`_codes`、`_case`），**不依赖 Chapter C**，可在其他课程中独立抽出使用。内容边界：

- 核心思想（最大间隔、支持向量、软间隔）**讲透**，推导控制在必要范围内
- 核方法（Kernel Trick）是本章重点，用几何直觉说明而非纯推导
- 案例题目与 B、C 章不重叠（建议用金融文本情感分类或信用评分场景）
- SVM 的超参数调优（C、kernel、gamma）在本章讲，不在 Chapter A 中预先介绍

### 12.5 Chapter E（无监督学习）：降维与聚类

PCA 的数学推导：**在本章讲**，不在 Chapter A 中预先介绍（Chapter A 只介绍有监督学习的评估框架）  
聚类评估指标（轮廓系数等）：在本章讲  

### 12.6 Chapter F（因果推断）：所有"ML + 因果"方法汇集于此

### 12.6 Chapter F（因果推断）：所有"ML + 因果"方法汇集于此

DS-Lasso、PO-Lasso、DML、DDML、Lasso-IV、因果森林：**全部在 Chapter F 讲**  
DML 中用到的 Lasso 第一阶段：引用 Chapter B；用到的随机森林第一阶段：引用 Chapter C  
这样 Chapter F 是方法论的综合，而非重复之前的内容

---

## 13. 版本管理与修订记录

| 版本 | 日期 | 修改内容 | 适用章节 |
|------|------|---------|---------|
| v1.0 | 2026-04 | 初始版本 | 全 Part |
| v1.1 | 2026-04 | ①图形规范改为与现有讲义一致的全局设置代码；②Chapter D 升级为完整章节（含 codes+case）；③文件清单补充 refs_mlV.bib；④第12节补充 D、E 章定位并重新编号 | 全 Part |

**修订规则**：
- 修改任何规范前，先在此文件中记录原因
- 若某章确有特殊需要偏离本指南，在该章文件头部的 YAML 注释中说明偏离之处及原因
- 不得在未修改本指南的情况下"悄悄"偏离规范

---

*本指南由连玉君起草，适用于《金融数据分析与建模》Part V 机器学习所有章节。*
*如有疑问或建议，请在本文件末尾添加注释，下次修订时统一处理。*
