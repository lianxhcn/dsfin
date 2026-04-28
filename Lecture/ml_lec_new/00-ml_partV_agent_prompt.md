# Part V 机器学习：Agent 写作提纲
## 《金融数据分析与建模》| 中山大学岭南学院 | 连玉君

---

## 一、任务总述

你是一位经济计量学领域的资深教材作者助手。你的任务是为《金融数据分析与建模》（中山大学岭南学院，副教授课程）撰写 **Part V：机器学习** 的全部章节文档。

本 Part 共 6 章（A–F）+ 1 个全 Part 共用参考手册，共产出 **18 个文件**。每次执行一个文件的写作任务。

**本文档是你的唯一指令来源。** 写作前，先完整阅读以下所有小节，再开始执行当前任务。

---

## 二、读者与课程定位

- **读者**：中山大学岭南学院金融学研究生及高年级本科生，有计量经济学基础（OLS、MLE、固定效应面板），有 Python 基础（pandas、matplotlib），无机器学习先验知识
- **课程目标**：能将机器学习方法应用于金融数据的预测与因果推断，能用 Python 实现并解读结果
- **教材定位**：教科书风格，中文为主，公式严谨，配图丰富，有完整 Python 实操
- **重要约束**：每章必须**自包含**，不依赖其他章节的知识（因为不同班次可能只讲其中几章）。如需引用前置概念，在本章内用简短段落交代清楚

---

## 三、写作语言与文风规范

### 3.1 基本原则

- 主要语言：**中文**，流畅自然，不逐字翻译英文
- 专业术语：**首次出现**时格式为`中文译名（English Name，缩写）`，之后只用中文
- 单句不超过 50 字；每段 3–6 句，聚焦一个意思
- 叙事结构：**问题驱动**——先提问，再给直觉，再写公式，再连接实践

### 3.2 禁止使用的表达

- "众所周知"、"显然"、"不难看出"
- "非常重要"、"极其关键"（改为说清楚为什么重要）
- "读者可自行验证"（该写的要写）

### 3.3 金融语境叙事

每个统计/ML 概念，在**一段话内**给出金融场景的对应：

| 统计概念 | 优先使用的金融类比 |
|---------|-----------------|
| 过拟合 | 策略回测中的曲线拟合 |
| 偏差-方差权衡 | 简单因子模型 vs 高维特征 |
| 交叉验证 | 滚动窗口样本外检验 |
| 稀疏性 | 少数 Fama-French 因子解释大部分收益 |
| 特征重要性 | 哪些财务指标对收益率预测贡献最大 |

---

## 四、文档格式规范

### 4.1 QMD 文档头（所有 `_lec.qmd` 统一使用）

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
  eval: false
  warning: false
  message: false
bibliography: refs_mlV.bib
csl: apa-6th-edition.csl
lang: zh
crossref:
  fig-prefix: "图"
  tbl-prefix: "表"
  eq-prefix: "式"
  sec-prefix: "节"
---
```

### 4.2 每章固定结构（顺序不可变）

```
## 本章概览 {.unnumbered}
   内含：callout-note，包含"学习目标"（可检验的行为动词）
         + "与其他章节的关系"（前置/后续/参考手册）

## X.1  第一节
...
## X.N  本章小结
   3–5 段，概括核心内容，明确适用边界和局限性

## 参考文献 {.unnumbered}
```

### 4.3 Callout 使用规则

| 类型 | 颜色 | 用途 | 每节上限 |
|------|------|------|---------|
| `callout-note` | 蓝 | 数学推导、延伸阅读、章节关联 | 2 个 |
| `callout-tip` | 绿 | Python 技巧、提示词模板 | 1 个 |
| `callout-important` | 红 | 核心假设、方法边界 | 1 个 |
| `callout-warning` | 黄 | 常见错误警示 | 1 个 |
| `callout-caution` | 橙 | 金融数据特殊注意事项 | 1 个 |

较长的数学推导用 `collapse="true"` 折叠。避免连续 2 个以上 callout 而无正文。

### 4.4 公式规范

- 行内：`$...$`
- 独立块：`$$...$$`，需引用的加标签 `{#eq-章节字母-描述}`
- 公式前必须有引导句，公式后必须逐项解释符号
- 全 Part 样本量统一用小写 `$n$`，不用 `$N$`

### 4.5 交叉引用标签命名

```
图：  #fig-{章节字母}-{描述}    引用：@fig-B-lasso-path
表：  #tbl-{章节字母}-{描述}    引用：@tbl-A-task-taxonomy
公式：#eq-{章节字母}-{描述}     引用：@eq-B-lasso-obj
节：  #sec-{章节字母}-{描述}    引用：@sec-A-bias-variance
```

---

## 五、数学符号约定（全 Part 统一）

| 符号 | 含义 |
|------|------|
| $n$ | 样本量（不用 $N$）|
| $p$ | 变量/特征数量 |
| $s$ | 稀疏度（非零系数个数）|
| $K$ | 交叉验证折数 |
| $\mathbf{y}$ | 目标变量向量（粗体小写）|
| $\mathbf{X}$ | 特征矩阵（粗体大写）|
| $\mathbf{x}_i$ | 第 $i$ 个样本的特征向量 |
| $\boldsymbol{\beta}$ | 系数向量（粗体希腊字母）|
| $\lambda$ | 惩罚回归调节参数 |
| $\alpha$ | 弹性网混合参数 |
| $\hat{\cdot}$ | 估计量 |
| $\tilde{\cdot}$ | 中间估计量（残差化后的变量）|
| $\theta$ | Chapter F 专用：处理效应参数 |
| $D$ | Chapter F 专用：处理变量 |
| $g(\cdot), m(\cdot)$ | Chapter F 专用：干扰函数 |

---

## 六、术语表（中英文对照，全 Part 统一）

以下术语只有一个中文译名，不得混用：

| 英文 | 唯一中文译名 |
|------|------------|
| Machine Learning | 机器学习 |
| Supervised / Unsupervised Learning | 监督 / 无监督学习 |
| Loss Function | 损失函数 |
| Regularization | 正则化 |
| Penalized Regression | 惩罚回归 |
| Overfitting / Underfitting | 过拟合 / 欠拟合 |
| Bias-Variance Tradeoff | 偏差-方差权衡（偏差在前）|
| Cross-Validation | 交叉验证 |
| Training / Validation / Test Set | 训练集 / 验证集 / 测试集 |
| Hyperparameter | 超参数 |
| Tuning Parameter | 调节参数（仅 Lasso 语境中 $\lambda$）|
| Sparsity | 稀疏性 |
| Soft / Hard Thresholding | 软阈值 / 硬阈值 |
| Bootstrap | Bootstrap（保留英文）|
| Feature Importance | 特征重要性 |
| SHAP Value | SHAP 值 |
| Causal Forest | 因果森林 |
| Treatment Effect | 处理效应 |
| DS-Lasso | 双重选择 Lasso（DS-Lasso）|
| PO-Lasso | 部分消除 Lasso（PO-Lasso）|
| DML / DDML | 双重去偏机器学习（DML / DDML）|
| Cross-fitting | 交叉拟合 |
| Elastic Net | 弹性网 |
| Lasso / Ridge Regression | Lasso / 岭回归 |
| Random Forest | 随机森林 |
| Gradient Boosting | 梯度提升 |
| Decision Tree | 决策树 |
| Support Vector Machine | 支持向量机（SVM）|
| Kernel Trick | 核方法 |
| PCA | 主成分分析（PCA）|
| Clustering | 聚类 |
| CATE | 条件平均处理效应（CATE）|

---

## 七、codes.ipynb 全局设置（每个 ipynb 文件的第一个 Cell）

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

# ── 中文字体支持 ─────────────────────────────────────────────────
plt.rcParams["font.family"]        = "SimHei"
plt.rcParams["axes.unicode_minus"] = False

# ── 全局样式 ─────────────────────────────────────────────────────
plt.rcParams['figure.dpi']         = 120
plt.rcParams['savefig.dpi']        = 300
plt.rcParams['font.size']          = 11
plt.rcParams['axes.titlesize']     = 13
plt.rcParams['axes.labelsize']     = 11
plt.rcParams['xtick.labelsize']    = 10
plt.rcParams['ytick.labelsize']    = 10
plt.rcParams['legend.fontsize']    = 10
plt.rcParams['axes.spines.top']    = False
plt.rcParams['axes.spines.right']  = False

# ── Part V 统一配色 ───────────────────────────────────────────────
C = {
    'primary'  : '#2166AC',   # 蓝：主方法/主曲线
    'secondary': '#D6604D',   # 橙红：对比方法/训练误差
    'tertiary' : '#4DAC26',   # 绿：第三曲线
    'neutral'  : '#878787',   # 灰：参考线/次要元素
    'highlight': '#B2182B',   # 深红：最优点/关键标注
    'fill'     : '#D1E5F0',   # 浅蓝：置信区间/阴影
}

# ── 随机种子 ──────────────────────────────────────────────────────
SEED = 42
np.random.seed(SEED)

print("✅ 全局设置完成")
```

### codes.ipynb 文件结构

```
Cell 1 (Markdown)：文件说明（文件名、用途、输入/输出文件、运行说明）
Cell 2 (Code)：    全局设置（上方代码块）
Cell 3 (Code)：    章节专用 import（如 sklearn、doubleml 等）
Cell 4+ (交替)：   Markdown 小节标题 + Code 实现
最后一格 (Code)：  print("✅ 所有图形已生成并保存至 figs/ 目录")
```

### codes.ipynb 图形保存规范

```python
# 每张图保存为 PNG（讲义用）
fig.savefig('figs/fig_{章节字母}_{描述}.png',
            dpi=150, bbox_inches='tight', facecolor='white')
plt.show()
```

### codes.ipynb 代码注释规范

- 关键步骤每 2–3 行一条中文注释
- 专业术语首次出现时附英文
- 数值输出统一格式：

```python
print(f"非零系数个数：{np.sum(coef != 0)}")
print(f"测试集 MSE = {mse:.4f}")
print(f"测试集 R²  = {r2:.4f}")
```

---

## 八、各章内容规格

### Chapter A：机器学习导论

**文件**：`ml_A_intro_lec.qmd`、`ml_A_intro_codes.ipynb`  
**定位**：全 Part 公共基础，所有概念在此讲完，B–F 章直接引用  
**教学深度**：能讲（能解释原理、判断结果、做稳健性检验）  
**建议篇幅**：讲义约 25–35 页，codes 约 200 行代码，生成 4 张图

**讲义结构（已有初稿，以此为准）：**

```
本章概览
A.1  什么是机器学习
     - 从一个问题出发（信贷审核的类比）
     - 三种学习范式：监督/无监督/强化
     - 金融中的典型任务分类表（回归/分类/聚类/降维/因果推断）

A.2  预测与因果：两种截然不同的目标
     - 预测 vs 因果的本质区别
     - callout-important：预测精度 ≠ 因果效应
     - ML 在因果推断中的辅助角色与边界

A.3  损失函数与经验风险最小化
     - 回归损失：MSE、MAE
     - 分类损失：交叉熵（含完整 MLE 推导，不依赖其他章节）
     - callout-note：ERM 统一框架

A.4  偏差-方差权衡
     - 三类误差来源
     - MSE 分解（含完整代数证明，折叠 callout）
     - U 型曲线与模型复杂度
     - 训练集/验证集/测试集划分
     - callout-warning：测试集重复使用

A.5  过拟合与正则化
     - 过拟合的本质
     - 正则化的统一框架：Loss + λΩ(β)
     - 各方法对比表（Lasso/Ridge/弹性网/剪枝/Dropout）

A.6  范数与距离
     - ℓ₀/ℓ₁/ℓ₂/ℓ∞ 定义
     - 约束集几何图示
     - 为什么 ℓ₁ 是"甜点"：尖角（稀疏）+ 凸（可解）
     - callout-tip：直觉总结

A.7  模型选择与交叉验证
     - 超参数选择问题
     - K 折 CV 完整算法步骤（含公式）
     - 1-SE 规则
     - callout-caution：金融时序数据禁止标准 K 折，用前向滚动验证
     - Bootstrap 基本思想

A.8  模型评估指标
     - 回归：MSE、RMSE、MAE、样本外 R²
     - callout-important：样本内 R² 不能衡量预测能力
     - 分类：混淆矩阵、精确率/召回率/F1、AUC-ROC

A.9  金融应用中的常见陷阱
     - 数据泄露（时间错位、前瞻偏差、目标泄露）
     - callout-warning：shift(1) 代码示例（时间范围：2000–2025）
     - 多重检验问题
     - 预测 ≠ 因果（再次强调）

A.10 Part V 方法全景图
     - 方法谱系树（文字版）
     - 各章依赖关系说明

本章小结
参考文献
```

**codes.ipynb 生成的图形：**

| 文件名 | 内容 | 关键参数 |
|--------|------|---------|
| `fig_A_bias_variance_tradeoff.png` | 偏差/方差/测试误差随模型复杂度（多项式次数）变化的三条曲线 | 模拟 n=100 个点，多项式 degree=1–15，重复 200 次取均值 |
| `fig_A_norm_balls.png` | ℓ₀.₅/ℓ₁/ℓ₂/ℓ∞ 四种范数的单位球（2D） | 四图并排，用 `C['primary']` 填充约束集 |
| `fig_A_kfold_cv.png` | K 折交叉验证数据分割示意（K=5） | 色块图：训练集用 `C['primary']`，验证集用 `C['secondary']` |
| `fig_A_walkforward_cv.png` | 前向滚动验证示意（时序数据，扩展窗口）| 时间轴从 2000 到 2025，展示 5 轮 |

---

### Chapter B：惩罚回归

**文件**：`ml_B_lasso_lec.qmd`、`ml_B_lasso_codes.ipynb`、`ml_B_lasso_case.ipynb`  
**定位**：线性正则化方法，从预测和模型筛选两个视角讲 Lasso/Ridge/弹性网  
**教学深度**：能讲  
**建议篇幅**：讲义约 40–55 页，codes 约 300 行，case 约 400 行

**讲义结构：**

```
本章概览
B.1  简介
     - Lasso 的定义与用途（Tibshirani 1996）
     - 高维数据的两类情形
     - 稀疏性与近似稀疏性假设
     - 惩罚回归 vs OLS 的本质区别

B.2  Lasso 回归
     B.2.1 模型设定
           - 约束形式与拉格朗日形式
           - 变量标准化的必要性（含恢复公式）
     B.2.2 直观解释
           - 2D 几何：约束集与等高线
           - Lasso path 图示
     B.2.3 估计
           - 次导数与软阈值算子（含图示）
           - 坐标下降法（直觉 + 步骤，证明折叠）
           - 正交情形的解析解

B.3  岭回归
     - 模型设定（ℓ₂ 约束）
     - 估计量的解析解：(X'X + λI)⁻¹X'y
     - 为何降低共线性（正则化 X'X）
     - 为何不能变量筛选（圆形无尖角）
     - callout-important：岭回归是有偏估计

B.4  弹性网
     - 模型设定（ℓ₁ + ℓ₂ 混合）
     - 适用场景：高共线性 + 需要稀疏解
     - α 参数的作用
     - Lasso/Ridge 作为特例（α=1/α=0）

B.5  三者比较
     - 正交情形的解析解对比表（Best Subset/Lasso/Ridge）
     - 软阈值 vs 硬阈值 vs 等比缩放图示
     - 何时选哪种：决策规则

B.6  调节参数 λ 的选择
     B.6.1 三类方法概述（CV/信息准则/Plugin）与适用场景
     B.6.2 交叉验证（引用 Chapter A 定义，补充 Lasso-CV 细节）
           - λ-MSE 曲线解读
           - 1-SE 规则（重申）
     B.6.3 信息准则
           - AIC/BIC/AICc/EBIC 公式（折叠 callout）
           - 使用建议：BIC/Plugin 用于模型筛选，CV 用于预测
     B.6.4 Plugin λ
           - 同方差/异方差两种公式（折叠 callout）
           - callout-tip：三种方法选择决策树

B.7  扩展模型（简述）
     - 平方根 Lasso（Sqrt-Lasso）
     - 自适应 Lasso（Oracle 性质，两步流程）
     - Post-Lasso（两步估计，含局限说明）

B.8  Python 实操要点
     - sklearn Lasso/Ridge/ElasticNet/LassoCV
     - 系数路径图的生成与解读
     - callout-tip：提示词模板 #1（Lasso 基础回归）
     - callout-tip：提示词模板 #2（CV 误差曲线）

本章小结
参考文献
```

**codes.ipynb 生成的图形（8 张）：**

| 文件名 | 内容 |
|--------|------|
| `fig_B_lasso_constraint.png` | Lasso 约束集与 OLS 等高线（2D，含切点和 Lasso path）|
| `fig_B_ridge_constraint.png` | Ridge 约束集与 OLS 等高线（2D，对比 Lasso）|
| `fig_B_subgradient.png` | 次导数几何图示（光滑函数 vs ｜x｜）|
| `fig_B_soft_threshold.png` | 软阈值/硬阈值/等比缩放三种变换对比 |
| `fig_B_lasso_path.png` | Lasso 系数路径图（横轴 ℓ₁ 范数比，纵轴标准化系数）|
| `fig_B_ridge_path.png` | Ridge 系数路径图 |
| `fig_B_cv_curve.png` | λ-CV_MSE 曲线（含误差带，标注最优 λ 和 1-SE λ）|
| `fig_B_methods_compare.png` | 三种方法系数收缩行为对比（共同坐标系）|

**模拟数据规格（供 codes 和 case 使用）：**

```python
# 生成稀疏线性回归数据
n, p, s = 300, 100, 10   # 样本量、特征数、真实非零特征数
# 真实非零系数：s 个，系数值从 U[-3, -1] ∪ [1, 3] 随机生成
# 特征相关结构：AR(1)，ρ=0.5（模拟金融变量间的相关性）
# 误差：N(0, 1)
# 保存为：data/sim_B_sparse_regression.csv
```

**case.ipynb 分析框架（A 股月度收益率预测）：**

```
数据：A 股沪深 300 成分股月度数据（2000–2025），
     目标变量：个股月度超额收益率，
     特征：~30 个财务因子（PE、PB、ROE、动量等），
     数据来源代码：用 akshare 获取，或加载预处理好的 data/data_ashare_factors.csv

分析流程：
  1. 数据读取与描述性统计（特征分布、缺失值处理）
  2. 时序 CV 框架设计（扩展窗口，训练 10 年，预测 1 年）
  3. 方法一：OLS（基准，可能因多重共线性失效）
  4. 方法二：Lasso（LassoCV，10 折时序 CV）
  5. 方法三：Ridge（RidgeCV）
  6. 方法四：弹性网（ElasticNetCV）
  7. 方法五：Post-Lasso（LassoCV 筛变量 + OLS）
  8. 系数路径图：哪些因子在哪些时期最重要？
  9. 样本外评估：R²_OOS、MSE、IC（信息系数）
  10. 结果汇总对比表（含 callout-tip 提示词模板 #3）
```

---

### Chapter C：树模型

**文件**：`ml_C_trees_lec.qmd`、`ml_C_trees_codes.ipynb`、`ml_C_trees_case.ipynb`  
**定位**：从决策树到随机森林到 XGBoost 的递进，重点讲可解释性（SHAP）  
**教学深度**：会用 + 能讲（树的数学推导不需要）  
**建议篇幅**：讲义约 40–55 页，codes 约 350 行，case 约 450 行

**讲义结构：**

```
本章概览
C.1  决策树
     - 直觉：递归二分
     - 分裂准则：回归（MSE 下降）、分类（基尼系数/信息增益）
     - 树的生长：何时停止
     - 剪枝：代价复杂度剪枝
     - 优缺点：直觉强但方差极大
     - callout-note：决策树是理解集成方法的基础

C.2  随机森林
     - Bagging 的基本思想（引用 Chapter A Bootstrap）
     - 特征随机子集：为什么能降低相关性、进而降低方差
     - Out-of-Bag 误差：免费的泛化误差估计
     - 超参数：树的数量 B、每次分裂候选特征数 m
     - callout-tip：sklearn RandomForestRegressor 关键参数说明

C.3  梯度提升与 XGBoost
     - Boosting 的基本思想：从偏差方向迭代修正
     - 梯度提升的统一框架（加法模型 + 负梯度）
     - XGBoost 的两项关键改进：正则化树结构、近似分裂算法
     - 超参数调优：树深度、学习率、子采样率、正则化系数
     - LightGBM 简介（一段话）
     - callout-caution：XGBoost 在小样本金融数据中容易过拟合，需仔细调参

C.4  树模型与线性模型的对比
     - 何时用树模型：非线性关系、特征交互、无需标准化
     - 何时用线性模型：稀疏高维、需要因果解读
     - callout-important：特征重要性 ≠ 因果效应

C.5  模型可解释性
     C.5.1 特征重要性
           - 均值不纯度下降（MDI）：快但有偏
           - 置换重要性（Permutation Importance）：慢但无偏
           - 对比：何时用哪种
     C.5.2 SHAP 值
           - Shapley 值的直觉（联盟博弈论类比）
           - SHAP 值的三个性质（局部准确性、缺失性、一致性）
           - 全局解释：特征重要性条形图
           - 局部解释：单样本 waterfall 图
           - 交互效应：beeswarm 图
           - callout-tip：提示词模板 #4b（SHAP 可解释性分析）
     C.5.3 部分依赖图（PDP）与个体条件期望图（ICE）

C.6  Python 实操要点
     - sklearn RF/GBM、xgboost、shap 包
     - 超参数调优：GridSearchCV vs RandomizedSearchCV
     - callout-tip：提示词模板 #4（随机森林特征重要性）
     - callout-tip：提示词模板 #5（XGBoost 调参）

本章小结
参考文献
```

**codes.ipynb 生成的图形（9 张）：**

| 文件名 | 内容 |
|--------|------|
| `fig_C_decision_tree.png` | 决策树结构图（深度 3，回归树）|
| `fig_C_bagging_variance.png` | Bagging 如何降低方差（单树 vs 集成预测方差对比）|
| `fig_C_rf_oob_error.png` | 随机森林 OOB 误差随树数量的收敛曲线 |
| `fig_C_boosting_steps.png` | Boosting 迭代过程示意（4 步，残差逐步减小）|
| `fig_C_feature_importance.png` | MDI vs Permutation Importance 对比条形图 |
| `fig_C_shap_beeswarm.png` | SHAP beeswarm 图（前 10 重要特征）|
| `fig_C_shap_waterfall.png` | 单样本 SHAP waterfall 图 |
| `fig_C_pdp.png` | 部分依赖图（2 个特征）|
| `fig_C_linear_vs_tree.png` | 线性 vs 树模型在非线性数据上的对比 |

**case.ipynb**：复用 Chapter B 的 A 股因子数据，新增 RF 和 XGBoost，做五方法对比（OLS/Lasso/Ridge/RF/XGBoost），用 SHAP 解释哪些财务因子最重要。

---

### Chapter D：支持向量机

**文件**：`ml_D_svm_lec.qmd`、`ml_D_svm_codes.ipynb`、`ml_D_svm_case.ipynb`  
**定位**：完整独立章节，不依赖其他章节，可在其他课程中单独使用  
**教学深度**：会用 + 能讲（核方法的数学推导简述即可）  
**建议篇幅**：讲义约 25–35 页，codes 约 200 行，case 约 300 行

**讲义结构：**

```
本章概览
D.1  最大间隔分类器
     - 分类问题的几何直觉
     - 支持向量的定义
     - 硬间隔 SVM（线性可分情形）的优化问题
     - callout-note：对偶问题的直觉（不需推导细节）

D.2  软间隔 SVM
     - 现实中的线性不可分
     - 松弛变量与惩罚参数 C
     - C 的作用：偏差-方差权衡（C 大→低偏差高方差，C 小→高偏差低方差）
     - callout-important：C 是 SVM 最重要的超参数

D.3  核方法
     - 特征空间变换的思想（低维非线性 → 高维线性可分）
     - 核函数的定义（避免显式变换的计算技巧）
     - 常用核函数：线性核、多项式核、RBF 核（高斯核）
     - 核参数 γ 的作用（RBF 核）
     - callout-note：Mercer 定理（一句话说明，不推导）

D.4  回归 SVM（SVR）
     - ε-不敏感损失函数
     - 模型设定与参数含义（C、ε、kernel）
     - 与 Lasso/Ridge 的类比

D.5  超参数调优
     - 网格搜索：C × γ 的二维搜索
     - 交叉验证选参（引用 Chapter A 定义）
     - callout-warning：SVM 对特征尺度敏感，必须标准化

D.6  SVM 在金融中的应用场景
     - 适用：高维小样本、非线性决策边界清晰的分类问题
     - 不适用：样本量 n > 100,000（计算瓶颈）、需要概率输出
     - 与 RF/XGBoost 的选择建议

D.7  Python 实操要点
     - sklearn SVC / SVR / GridSearchCV
     - callout-tip：提示词模板 #6（SVM 分类）
     - callout-tip：提示词模板 #7（SVR 回归）

本章小结
参考文献
```

**codes.ipynb 生成的图形（5 张）：**

| 文件名 | 内容 |
|--------|------|
| `fig_D_svm_margin.png` | 最大间隔分类器示意（支持向量、决策边界、间隔带）|
| `fig_D_soft_margin.png` | 软间隔 SVM（不同 C 值下的决策边界）|
| `fig_D_kernel_trick.png` | 核方法示意（2D 非线性 → 3D 线性可分）|
| `fig_D_rbf_gamma.png` | RBF 核不同 γ 值下的决策边界（2×3 子图）|
| `fig_D_svm_vs_lr.png` | SVM vs Logistic 回归决策边界对比 |

**case.ipynb**：A 股上市公司信用评级预测（二分类），比较 Logit/SVM（线性核）/SVM（RBF 核）/RF 四种方法，用 AUC-ROC 评估，展示 C 和 γ 的调参曲线。

---

### Chapter E：无监督学习

**文件**：`ml_E_unsup_lec.qmd`、`ml_E_unsup_codes.ipynb`、`ml_E_unsup_case.ipynb`  
**定位**：降维（PCA）与聚类（K-means、层次聚类）；含异常检测简介  
**教学深度**：会用 + 能讲  
**建议篇幅**：讲义约 30–40 页，codes 约 250 行，case 约 350 行

**讲义结构：**

```
本章概览
E.1  无监督学习的目标与挑战
     - 没有标签意味着什么
     - 金融中的典型无监督任务
     - 评估无监督学习结果的困难

E.2  主成分分析（PCA）
     E.2.1 动机：降维的必要性
           - 维数灾难（Curse of Dimensionality）
           - 金融因子模型的 PCA 视角
     E.2.2 模型设定
           - 协方差矩阵的特征分解
           - 主成分的定义：方差最大化方向
           - 方差解释比（Explained Variance Ratio）
           - 碎石图（Scree Plot）选择主成分数量
     E.2.3 PCA 的几何直觉
           - 旋转视角：找到数据最"散"的方向
           - callout-note：PCA 的 SVD 推导（折叠）
     E.2.4 PCA 与因子分析的区别
     E.2.5 金融应用：宏观因子提取、收益率协方差矩阵估计
     E.2.6 callout-important：PCA 假设线性关系，对非线性结构失效

E.3  聚类分析
     E.3.1 K-means 聚类
           - 算法步骤（含图示）
           - 肘部法则确定 K
           - 局限：球形簇假设、对初始值敏感
     E.3.2 层次聚类
           - 凝聚式（bottom-up）vs 分裂式（top-down）
           - 连接准则：单连接/完全连接/Ward 方法
           - 树状图（Dendrogram）的解读
           - 金融应用：资产相关性层次结构
     E.3.3 聚类评估
           - 轮廓系数（Silhouette Score）
           - callout-caution：聚类结果需要领域知识解读，数学指标不是唯一标准

E.4  异常检测简介
     - 孤立森林（Isolation Forest）：随机分割树的逻辑
     - 金融应用：欺诈交易识别、异常市场行为检测
     - callout-tip：sklearn IsolationForest 提示词模板

E.5  Python 实操要点
     - sklearn PCA / KMeans / AgglomerativeClustering
     - scipy.cluster.hierarchy（树状图）
     - callout-tip：提示词模板 #8（PCA 降维）
     - callout-tip：提示词模板 #9（K-means 聚类）

本章小结
参考文献
```

**codes.ipynb 生成的图形（7 张）：**

| 文件名 | 内容 |
|--------|------|
| `fig_E_pca_2d.png` | PCA 几何示意（2D 数据，主成分方向）|
| `fig_E_scree_plot.png` | 碎石图（前 10 个主成分的方差解释比）|
| `fig_E_kmeans_steps.png` | K-means 迭代过程（4 步，含质心移动）|
| `fig_E_elbow.png` | 肘部法则图（K vs 组内距离平方和）|
| `fig_E_dendrogram.png` | 层次聚类树状图（A 股行业）|
| `fig_E_silhouette.png` | 轮廓系数图（不同 K 值对比）|
| `fig_E_isolation_forest.png` | 孤立森林异常检测结果（散点图，标注异常点）|

**case.ipynb**：A 股行业聚类分析（基于月度收益率相关矩阵，层次聚类 + 热力图）+ PCA 宏观因子提取（基于 30 个宏观经济指标，提取前 3 个主成分并解释经济含义）。

---

### Chapter F：机器学习与因果推断

**文件**：`ml_F_causal_lec.qmd`、`ml_F_causal_codes.ipynb`、`ml_F_causal_case.ipynb`  
**定位**：Part V 理论高峰，所有"ML + 因果"方法汇集于此  
**教学深度**：能讲（DML 渐近理论只需会用）  
**建议篇幅**：讲义约 45–55 页，codes 约 300 行，case 约 500 行

**讲义结构：**

```
本章概览
F.1  引言：机器学习与因果推断的交汇
     - 高维控制变量问题
     - 函数形式误设问题
     - ML 在因果推断中的两种角色：变量筛选 + 非参数控制
     - 本章方法全景（流程图）

F.2  Post-Lasso：思路与局限
     - 两步估计流程
     - 降低收缩偏差的优势
     - 遗漏变量风险（核心局限）

F.3  双重选择 Lasso（DS-Lasso）
     - Post-Lasso 局限的正式分析
     - DS-Lasso 核心思想：对 Y 和 D 分别做 Lasso，取并集
     - 四步估计流程（详解）
     - 理论保证：近似稀疏性 → 渐近正态
     - callout-important：有限样本局限
     - Python 实操（doubleml 包）

F.4  部分消除 Lasso（PO-Lasso）
     - FWL 定理（完整陈述与证明，不依赖其他章节）
     - Venn 图直观解读
     - PO-Lasso 估计流程
     - DS-Lasso vs PO-Lasso：异同对比表

F.5  双重去偏机器学习（DML）
     - DS-Lasso 和 PO-Lasso 的共同局限：第一阶段偏差污染
     - DML 的改进：K 折交叉拟合
     - 三方程模型设定
     - DML1 和 DML2 两个估计量（含公式）
     - 推荐使用 DML2（Stata xporegress 的默认）
     - DML 的统计推断（异方差稳健标准误）
     - callout-important：DML 的假设边界
       "DML 能解决函数形式误设和第一阶段污染偏差；
        但不能解决不可观测的遗漏变量。
        若存在不可观测的遗漏变量，需转向 Lasso-IV。"
     - DML 的局限与建议（K 的选择、循环重复取均值）
     - Python 实操（doubleml 包）

F.6  双重去偏机器学习扩展：DDML
     - DML 的推广：第一阶段可替换为任意 ML 方法
     - DDML 框架（Neyman 正交矩条件 + 交叉拟合）
     - 为什么非参数第一阶段更优
     - 实现：随机森林作为第一阶段（doubleml + sklearn RF）
     - callout-note：DDML 不需要稀疏性假设，适用于真正非线性场景
     - DML vs DDML 的选择建议（含对比表）

F.7  Lasso 工具变量（Lasso-IV）
     - 弱工具变量问题回顾
     - Lasso-IV 的思路：从高维候选 IV 中筛选有效 IV
     - 估计量（单个/多个内生变量）
     - 与传统 2SLS 的关系
     - 适用边界：解决弱 IV，但不能解决 IV 内生性
     - 应用简述：Belloni et al. (2014) 三个重现案例

F.8  异质性处理效应
     F.8.1 为什么 ATE 不够
           - 政策效果对不同群体可能截然不同
           - CATE 的定义：τ(x) = E[Y(1) - Y(0) | X = x]
     F.8.2 因果森林（Causal Forest）
           - 与普通随机森林的区别（honest estimation）
           - 估计 CATE 的方法
           - 置信区间构建
     F.8.3 Python 实操（econml 包）
           - callout-tip：提示词模板 #10（因果森林）

F.9  方法选择的决策框架（全章总结）
     - 表格：各方法解决的问题、假设、局限、推荐场景
     - 流程图：给定研究问题，如何选方法

本章小结
参考文献
```

**codes.ipynb 生成的图形（8 张）：**

| 文件名 | 内容 |
|--------|------|
| `fig_F_dsl_flow.png` | DS-Lasso 四步估计流程图 |
| `fig_F_fwl_venn.png` | FWL 定理 Venn 图（Y、D、X 的方差分解）|
| `fig_F_dml_crossfit.png` | DML K 折交叉拟合示意图（K=5）|
| `fig_F_dml_mc_normal.png` | DML 蒙特卡洛：有无交叉拟合时 θ̂ 的分布对比 |
| `fig_F_ddml_vs_dml.png` | DDML（RF）vs DML（Lasso）偏差对比（非线性 DGP 下）|
| `fig_F_lasso_iv_path.png` | Lasso-IV：λ 变化时选中的 IV 数量 |
| `fig_F_cate_dist.png` | 因果森林估计的 CATE 分布直方图 |
| `fig_F_method_compare.png` | 多方法处理效应估计对比（横向误差棒图）|

**模拟数据规格（供 codes 使用）：**

```python
# PLR（部分线性回归）数据生成，参考 Chernozhukov et al. (2018)
# 用 doubleml.datasets.make_plr_CCDDHNR2018() 生成
# 真实 θ = 0.5，n = 500，p = 20
# 保存为：data/sim_F_plr.csv
```

**case.ipynb**：政策评估——某项金融监管政策对上市公司融资成本的影响。若真实数据获取困难，使用高质量模拟数据（PLR 结构 + 非线性 g(X)）。五种方法对比（OLS/Post-Lasso/DS-Lasso/DML/DDML），输出系数对比图 + DML 结果分布直方图 + CATE 异质性分析。

---

### Python 实操参考手册

**文件**：`ml_ref_python.ipynb`  
**定位**：全 Part 共用的代码手册，按任务类型组织，不是教学内容  
**建议篇幅**：约 800–1000 行代码，10 个主要任务模块

**结构：**

```
模块 0：环境检查与包版本
模块 1：数据准备（标准化、特征工程、时序分割）
模块 2：惩罚回归代码模板（Lasso/Ridge/ElasticNet + CV）
         含提示词模板 #1、#2、#3
模块 3：树模型代码模板（RF、XGBoost + SHAP）
         含提示词模板 #4、#5
模块 4：SVM 代码模板（SVC、SVR + GridSearch）
         含提示词模板 #6、#7
模块 5：无监督学习代码模板（PCA、K-means、层次聚类）
         含提示词模板 #8、#9
模块 6：因果推断代码模板（doubleml、econml）
         含提示词模板 #10
模块 7：模型评估与可视化（统一的评估流程）
模块 8：多方法结果汇总图（横向误差棒图模板）
模块 9：常见报错与解决方案
```

---

## 九、提示词模板规范

每个 `callout-tip` 中的提示词必须包含以下四个要素：

1. **数据接口**：明确变量名、数据类型（`df`、`X`、`y` 等），学生只需替换为自己的变量名
2. **关键参数**：给出推荐值（如 `n_folds=5`、`random_state=42`），不让学生自行摸索
3. **输出要求**：具体说明要打印什么、画什么图（不给 AI 过多发挥空间）
4. **对比基准**：要求与 OLS 或上一个方法对比，培养批判性思维

**格式模板：**

````markdown
::: {.callout-tip}
## 💬 提示词模板 #X：[任务名称]

将以下提示词发送给 AI，可生成适用于你自己数据集的代码：

```
[提示词正文，包含数据接口说明、具体任务要求、输出格式、对比要求、中文注释要求]
```
:::
````

---

## 十、当前任务执行指令

**在开始每个具体文件的写作时，按以下步骤执行：**

**Step 1**：确认当前任务是哪个文件（见下方任务清单）

**Step 2**：重新阅读本提纲中对该文件的规格说明（第八节）

**Step 3**：对照风格规范（第三至七节）检查以下项目：
- [ ] 文档头 YAML 是否正确
- [ ] 章节结构是否包含"本章概览"和"本章小结"
- [ ] 学习目标是否用可检验的行为动词
- [ ] 术语首次出现是否附英文
- [ ] 样本量是否统一用小写 $n$
- [ ] Callout 类型是否使用正确
- [ ] 每章是否自包含（不依赖其他章节的知识）

**Step 4**：写作完成后，输出文件

---

## 十一、任务清单与执行状态

| 序号 | 文件名 | 状态 | 备注 |
|------|--------|------|------|
| 01 | `ml_A_intro_lec.qmd` | ✅ 初稿完成 | 待审核修改：删除对其他章节的引用，改为自包含 |
| 02 | `ml_A_intro_codes.ipynb` | ⬜ 待写 | 生成 4 张图 |
| 03 | `ml_B_lasso_lec.qmd` | ⬜ 待写 | 有 .tex 原稿可参考 |
| 04 | `ml_B_lasso_codes.ipynb` | ⬜ 待写 | 生成 8 张图 |
| 05 | `ml_B_lasso_case.ipynb` | ⬜ 待写 | A 股因子数据 |
| 06 | `ml_C_trees_lec.qmd` | ⬜ 待写 | — |
| 07 | `ml_C_trees_codes.ipynb` | ⬜ 待写 | 生成 9 张图 |
| 08 | `ml_C_trees_case.ipynb` | ⬜ 待写 | 复用 Chapter B 数据 |
| 09 | `ml_D_svm_lec.qmd` | ⬜ 待写 | — |
| 10 | `ml_D_svm_codes.ipynb` | ⬜ 待写 | 生成 5 张图 |
| 11 | `ml_D_svm_case.ipynb` | ⬜ 待写 | 信用评级分类 |
| 12 | `ml_E_unsup_lec.qmd` | ⬜ 待写 | — |
| 13 | `ml_E_unsup_codes.ipynb` | ⬜ 待写 | 生成 7 张图 |
| 14 | `ml_E_unsup_case.ipynb` | ⬜ 待写 | A 股行业聚类 + PCA |
| 15 | `ml_F_causal_lec.qmd` | ⬜ 待写 | 有 .tex 原稿可参考 |
| 16 | `ml_F_causal_codes.ipynb` | ⬜ 待写 | 生成 8 张图 |
| 17 | `ml_F_causal_case.ipynb` | ⬜ 待写 | 政策评估 |
| 18 | `ml_ref_python.ipynb` | ⬜ 待写 | 全 Part 完成后整合 |

**执行规则**：
- 每次只执行一个文件
- 执行完成后，在任务清单中将状态更新为 ✅
- `_lec.qmd` 写完后才写对应的 `_codes.ipynb`
- 所有 `_lec.qmd` 写完后才写 `ml_ref_python.ipynb`
- 如发现本提纲有遗漏或矛盾，在执行当前任务前先指出，待确认后再继续

---

## 十二、附：已完成文件摘要

### `ml_A_intro_lec.qmd`（初稿，待修订）

**当前问题**（下次修订时处理）：
1. A.3 节引用了"第 41 章 §41.6.2"和"第 33 章 §33.2"——需删除这些引用，改为在本章内完整推导 Logit 损失函数的 MLE 来源（约增加 300 字）
2. 时间范围已正确设置为 2000–2025
3. 其余内容基本符合规范

**已完成节的标签（供后续章节交叉引用）：**
```
#sec-A-what-is-ml        #sec-A-prediction-vs-causal
#sec-A-loss-function     #sec-A-bias-variance
#sec-A-regularization    #sec-A-norms
#sec-A-cross-validation  #sec-A-metrics
#sec-A-pitfalls          #sec-A-overview
```

### `ml_style_guide.md`（v1.1，已完成）

风格指南包含：文件命名规范、QMD 文档头、章节结构模板、术语表、数学符号约定、公式排版规范、Callout 使用规则、交叉引用规范、图形规范（含全局设置代码）、代码规范、写作语言与文风、各章定位与边界说明。

---

## 十三、数据文件总览

Agent 在生成 codes.ipynb 和 case.ipynb 时，必须严格遵守以下数据文件规格，保证各章文件之间的数据接口一致。

### 13.1 模拟数据文件（由 codes.ipynb 生成，保存至 `data/` 目录）

| 文件名 | 生成章节 | 规格 | 使用章节 |
|--------|---------|------|---------|
| `sim_A_poly_fit.csv` | A-codes | n=100，1 个特征，真实关系为 sin(x)+noise，用于多项式过拟合演示 | A-codes |
| `sim_B_sparse.csv` | B-codes | n=300, p=100, s=10；AR(1) 相关结构 ρ=0.5；误差 N(0,1) | B-codes, B-case |
| `sim_C_nonlinear.csv` | C-codes | n=500, p=20；目标变量含非线性交互项（x₁·x₂ + x₃²）；用于展示树模型优势 | C-codes |
| `sim_D_classification.csv` | D-codes | n=400, p=2（便于可视化）；两类非线性可分（moon 形状）；另备 p=20 高维版本用于 case | D-codes, D-case |
| `sim_E_clustering.csv` | E-codes | n=300, p=5；含 3 个真实簇，用于 K-means 和轮廓系数演示 | E-codes |
| `sim_F_plr.csv` | F-codes | 使用 `doubleml.datasets.make_plr_CCDDHNR2018()`；n=500, p=20；真实 θ=0.5 | F-codes, F-case |
| `sim_F_plr_nonlinear.csv` | F-codes | 同上但 g(X) 改为非线性（sin 函数），用于展示 DDML 相对 DML 的优势 | F-codes |

**数据生成代码规范**：每个模拟数据集的生成必须：
- 设置 `np.random.seed(42)`
- 在 Cell 开头注释说明 DGP（数据生成过程）的数学形式
- 生成后打印数据维度和前 3 行，确认正确
- 保存前检查：`assert df.shape == (n, p+1), "维度检查失败"`

### 13.2 真实数据文件（需获取，保存至 `data/` 目录）

| 文件名 | 内容 | 获取方式 | 使用章节 |
|--------|------|---------|---------|
| `data_ashare_factors.csv` | 沪深 300 成分股月度数据（2000–2025）；列：股票代码、日期、月超额收益率、~30 个财务因子 | `akshare` 或预处理好的 CSV | B-case, C-case |
| `data_credit_rating.csv` | A 股上市公司信用评级数据；列：公司代码、年份、评级（二元化）、财务特征 | CSMAR 或 Wind | D-case |
| `data_industry_ret.csv` | A 股 30 个行业的月度收益率（2000–2025）；用于聚类分析 | `akshare` | E-case |
| `data_macro_factors.csv` | 30 个宏观经济指标月度数据（2000–2025）；用于 PCA 因子提取 | Wind / 国家统计局 | E-case |

**真实数据处理原则**：
- 若运行环境无法连接数据源，使用对应的模拟数据代替，在 Cell 注释中标注 `# [替代方案] 真实数据获取失败，使用模拟数据`
- 数据清洗步骤必须写成函数，便于替换数据源后复用
- 所有真实数据加载后必须打印：样本量、时间范围、缺失值比例

### 13.3 各章数据依赖关系

```
A-codes  → 仅使用内部生成的小型模拟数据（无保存文件）
B-codes  → 生成 sim_B_sparse.csv
B-case   → 读取 sim_B_sparse.csv + data_ashare_factors.csv
C-codes  → 生成 sim_C_nonlinear.csv
C-case   → 读取 data_ashare_factors.csv（复用 B-case 数据）
D-codes  → 生成 sim_D_classification.csv
D-case   → 读取 sim_D_classification.csv（p=20 版）+ data_credit_rating.csv
E-codes  → 生成 sim_E_clustering.csv
E-case   → 读取 data_industry_ret.csv + data_macro_factors.csv
F-codes  → 生成 sim_F_plr.csv + sim_F_plr_nonlinear.csv
F-case   → 读取 sim_F_plr.csv（主）+ sim_F_plr_nonlinear.csv（DDML 对比）
ref      → 所有模拟数据均可直接生成，不依赖真实数据
```

---

## 十四、各章提示词模板完整编号表

| 编号 | 所在章节 | 任务描述 |
|------|---------|---------|
| #1 | B-lec §B.8 | Lasso 基础回归（LassoCV + 标准化 + 样本外评估）|
| #2 | B-lec §B.8 | CV 误差曲线（λ-MSE 图 + 1-SE 规则标注）|
| #3 | B-case | 多方法样本外预测对比表（OLS/Lasso/Ridge/EN/Post-Lasso）|
| #4 | C-lec §C.6 | 随机森林特征重要性（MDI + Permutation 对比）|
| #4b | C-lec §C.5.2 | SHAP 可解释性分析（beeswarm + waterfall + PDP）|
| #5 | C-lec §C.6 | XGBoost 调参（GridSearchCV + 学习曲线）|
| #6 | D-lec §D.7 | SVM 分类（SVC + GridSearch C × γ + AUC 评估）|
| #7 | D-lec §D.7 | SVR 回归（SVR + CV + 与 Lasso 对比）|
| #8 | E-lec §E.5 | PCA 降维（碎石图 + 主成分解释 + 降维可视化）|
| #9 | E-lec §E.5 | K-means 聚类（肘部法则 + 轮廓系数 + 聚类可视化）|
| #10 | F-lec §F.8.3 | 因果森林 CATE 估计（econml + 异质性可视化）|

**提示词模板统一格式**（Agent 写每个模板时严格遵守）：

````markdown
::: {.callout-tip}
## 💬 提示词模板 #X：[任务名称]

将以下提示词发送给 AI，可生成适用于你自己数据集的代码：

```
背景：[一句话说明任务场景]

我的数据：
- DataFrame 名称：df（或 X, y 等）
- 目标变量：[列名]（类型：连续/二元）
- 特征变量：[列名范围或数量]
- 样本量：约 [n] 行，[p] 列特征

请帮我完成以下任务：
1. [具体步骤 1，含推荐参数值]
2. [具体步骤 2]
3. [输出要求：表格/图形/指标]
4. 与 OLS（或上一个方法）的结果对比，说明差异及原因
5. 所有代码用中文注释，专业术语第一次出现时附英文
```
:::
````

