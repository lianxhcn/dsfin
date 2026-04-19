## 上市公司亏损影响因素分析：二元与多元离散选择模型

> **作业性质**：小组作业（建议 3-4 人）  
> **完成时间**：两周  
> **数据来源**：沿用上一次作业（资本结构分析）的 CSMAR 数据集，可按需补充变量  
> **工具**：Python（推荐），Jupyter Notebook  
> **提交方式**：见文末「提交要求」

---

### 研究背景与问题

上市公司亏损（NPR < 0）是资本市场监管的核心关注点之一。连续亏损会触发 ST 警示，进而影响公司融资能力、股价表现和投资者信心。理解"哪些因素使企业更容易陷入亏损"不仅有学术价值，也有直接的监管和投资实践意义。

本作业围绕两个核心问题展开：

1. **影响因素分析**：哪些财务和公司特征显著预测企业亏损？亏损的严重程度（偶发 vs 持续）是否受到不同因素的影响？
2. **模型拓展**：从二元亏损（亏/不亏）扩展到有序亏损程度，比较 Logit、有序 Logit（ologit）和多项 Logit（mlogit）的结论差异。

---

### 第一部分：因变量构造

#### 1.1 二元亏损指标

$$Loss_{it} = \begin{cases} 1 & \text{若 } NPR_{it} < 0 \\ 0 & \text{若 } NPR_{it} \geq 0 \end{cases}$$

#### 1.2 有序亏损程度指标

将亏损按持续性分为三类，构造有序变量 $LossType_{it}$：

| 取值 | 定义 | 经济含义 |
|------|------|---------|
| 0 | 当年及前一年均 NPR ≥ 0 | 持续盈利 |
| 1 | 当年 NPR < 0，但非连续亏损 | 偶发性亏损（一次性冲击） |
| 2 | 当年及前一年均 NPR < 0 | 持续性亏损（经营持续恶化） |

```python
df = df.sort_values(['stkcd', 'year'])
df['npr_lag'] = df.groupby('stkcd')['npr'].shift(1)

def classify_loss(row):
    if row['npr'] >= 0:
        return 0                             # 持续盈利
    elif row['npr'] < 0 and (pd.isna(row['npr_lag']) or row['npr_lag'] >= 0):
        return 1                             # 偶发亏损
    else:
        return 2                             # 持续亏损

df['loss_type'] = df.apply(classify_loss, axis=1)
```

> ⚠️ **注意**：$LossType$ 的计算需要前一年数据，因此 2010 年的观测若无 2009 年数据则为缺失，需在后续分析中说明处理方式。

统计并可视化三类样本的分布：

- 各类别的频次和占比（柱状图）
- 各类别的时序趋势（按年份统计每类占比的折线图）
- 分 SOE/非SOE 的类别分布对比

---

### 第二部分：特征变量

#### 2.1 沿用上一作业的变量

直接从资本结构作业的清洗数据集读取以下变量（已经过 Winsorize 处理）：

| 变量 | 定义 | 预期方向（对亏损概率） |
|------|------|-------------------|
| $Lev$ | 总负债 / 总资产 | + （高杠杆 → 财务压力） |
| $Size$ | ln(总资产) | − （规模越大越稳定） |
| $Tang$ | 固定资产净值 / 总资产 | − （有形资产提供抵押） |
| $Growth$ | 总资产增长率 | − （成长性越好越不易亏损） |
| $NDTS$ | 折旧摊销 / 总资产 | ? （保守，可多方向） |
| $SOE$ | 国有=1 | − （国企有政府支持） |

#### 2.2 补充变量（本作业新增）

下列变量需从 CSMAR 补充下载，重点选取与亏损预测相关的运营和市场特征：

| 变量 | 定义 | CSMAR 来源 | 预期方向 |
|------|------|-----------|---------|
| $ROA\_lag$ | 上一年 ROA（净利润/总资产） | 利润表 | − （上期盈利强 → 不易亏损） |
| $CashRatio$ | 货币资金 / 总资产 | 资产负债表 | − （现金充裕 → 缓冲能力强） |
| $OpCF$ | 经营活动现金流 / 总资产 | 现金流量表 | − （现金流为负是亏损先兆） |
| $SalesGrowth$ | 营业收入增长率 | 利润表 | − （收入下滑 → 亏损概率上升） |
| $Age$ | 上市年数（当年年份 − 上市年份） | 公司特征表 | − （成熟企业更稳定） |
| $DualRole$ | 董事长与总经理是否兼任（=1） | 公司治理表 | + （治理薄弱） |

> **为什么补充这些变量**：资本结构作业关注的是杠杆率的影响因素，现金流、收入增长、公司治理这些变量在那道题中是控制变量或不相关；但在预测亏损这个问题上，它们往往是更直接的先行指标。

#### 2.3 变量筛选：从候选变量到最终入模变量

当特征变量较多时，需要通过系统方法筛选最优变量组合，避免过拟合和多重共线性。本作业要求完成以下筛选流程：

**步骤一：单变量筛选（初步过滤）**

对每个候选变量，分别计算其与 $Loss$ 的：
- 点二列相关系数（Point-biserial correlation）
- 单变量 Logit 回归的 AUC
- t 检验（亏损组 vs 非亏损组均值差异）

保留相关性显著（p < 0.1）且单变量 AUC > 0.55 的变量进入下一步。

**步骤二：多重共线性检验**

计算通过初步筛选的变量之间的相关系数矩阵和 VIF（方差膨胀因子）：

```python
from statsmodels.stats.outliers_influence import variance_inflation_factor
import pandas as pd

def calc_vif(X):
    vif = pd.DataFrame()
    vif["Variable"] = X.columns
    vif["VIF"] = [variance_inflation_factor(X.values, i)
                  for i in range(X.shape[1])]
    return vif.sort_values("VIF", ascending=False)
```

对 VIF > 5 的变量对，保留与 $Loss$ 相关性更高的一个。

**步骤三：正则化筛选（Lasso Logit）**

使用 L1 正则化（Lasso）自动筛选变量：

```python
from sklearn.linear_model import LogisticRegressionCV
from sklearn.preprocessing import StandardScaler

X_scaled = StandardScaler().fit_transform(X)
lasso = LogisticRegressionCV(
    Cs=10, cv=5, penalty='l1', solver='saga',
    scoring='roc_auc', random_state=42
)
lasso.fit(X_scaled, y)

# 查看非零系数（被 Lasso 选中的变量）
selected = pd.Series(lasso.coef_[0], index=X.columns)
selected_vars = selected[selected != 0].index.tolist()
print("Lasso 选中的变量：", selected_vars)
```

**步骤四：最终变量集确认**

将 Lasso 选中的变量作为"推荐变量集"，人工检验其经济合理性，形成最终入模变量列表，在报告中说明每个入选变量的理论依据。

---

### 第三部分：描述性统计

#### 3.1 亏损公司与盈利公司的特征对比

计算所有特征变量在 $Loss=1$ 和 $Loss=0$ 两组的均值，并做 t 检验：

| 变量 | Loss=0（盈利） | Loss=1（亏损） | 差值 | t 统计量 |
|------|-------------|-------------|------|---------|
| Lev | | | | |
| Size | | | | |
| ... | | | | |

#### 3.2 亏损时序分布

- 绘制 2010-2025 年各年亏损率（$Loss=1$ 占比）的折线图，分 SOE/非SOE
- 绘制持续亏损（$LossType=2$）的年度占比时序图
- 标注重要经济事件（2015 股灾、2018 贸易摩擦、2020 新冠）

#### 3.3 行业分布

绘制亏损率的行业分布条形图（按行业一级分类排序），讨论：哪些行业亏损率最高？这与行业周期性特征是否吻合？

---

### 第四部分：二元 Logit 模型

#### 4.1 基准模型

$$P(Loss_{it}=1) = \Lambda(\alpha + \beta_1 Lev_{it} + \beta_2 Size_{it} + \cdots + \beta_k X_{kit} + \delta_j + \tau_t)$$

其中 $\Lambda(\cdot)$ 为 Logistic 函数，$\delta_j$ 为行业固定效应，$\tau_t$ 为年度固定效应。

```python
import statsmodels.formula.api as smf

# 注意：Logit 模型不能直接用 pyfixest，需用 statsmodels 或 linearmodels
formula = ("loss ~ lev + size + tang + growth + ndts + soe"
           " + cash_ratio + op_cf + sales_growth + age"
           " + C(ind_code) + C(year)")

logit_model = smf.logit(formula, data=df).fit(
    cov_type='cluster',
    cov_kwds={'groups': df[['stkcd', 'year']]}  # 双向聚类标准误
)
print(logit_model.summary())
```

> **关于固定效应与 Logit 的"附带参数问题"（Incidental Parameter Problem）**：严格意义上，含有个体固定效应的非线性模型（如 Logit）会因参数数量随样本量增长而导致系数有偏。本作业采用加入行业和年度虚拟变量的方式近似控制，这是实证研究中的常见做法。如有兴趣，可进一步了解条件 Logit（Conditional Logit）的解决方案。

#### 4.2 边际效应（Average Marginal Effects, AME）

Logit 回归的系数不能直接解读为"$X$ 增加 1 单位，亏损概率变化多少"——需要计算平均边际效应：

```python
from statsmodels.discrete.discrete_model import LogitResults

# 计算平均边际效应
marginal_effects = logit_model.get_margeff(at='mean')
print(marginal_effects.summary())

# 可视化：各变量的 AME 及置信区间（系数图）
```

**必须回答**：

1. $Lev$、$Size$、$OpCF$ 的 AME 方向和大小是什么？与直觉预期是否一致？
2. SOE（国有企业）的 AME 是否显著？这如何从政府支持假说角度解释？
3. 哪个变量的 AME 绝对值最大？它对亏损概率的经济影响有多大？

#### 4.3 模型逐步扩展（嵌套模型对比）

通过逐步加入变量，展示模型解释力的变化，比较四个嵌套模型：

| 模型 | 变量 | 说明 |
|------|------|------|
| Logit-1 | 仅 Lev + Size | 最简模型 |
| Logit-2 | + Tang + Growth + NDTS + SOE | 加入资本结构变量 |
| Logit-3 | + ROA_lag + CashRatio + OpCF + SalesGrowth | 加入运营变量 |
| Logit-4 | + Age + DualRole | 加入公司特征变量 |

评估指标：McFadden's $R^2$（伪 $R^2$）、AIC、BIC、AUC（ROC 曲线下面积）。

```python
from sklearn.metrics import roc_auc_score, roc_curve
import matplotlib.pyplot as plt

y_prob = logit_model.predict()
auc = roc_auc_score(df['loss'], y_prob)

fpr, tpr, _ = roc_curve(df['loss'], y_prob)
plt.plot(fpr, tpr, label=f'Logit (AUC = {auc:.3f})')
plt.plot([0,1],[0,1], 'k--')
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('ROC Curve')
plt.legend()
```

---

### 第五部分：有序 Logit 模型（ologit）

以 $LossType \in \{0, 1, 2\}$ 为因变量，估计有序 Logit 模型：

$$P(LossType_{it} \leq k) = \Lambda(\tau_k - \boldsymbol{\beta}'\boldsymbol{X}_{it}), \quad k=0,1$$

```python
from statsmodels.miscmodels.ordinal_model import OrderedModel

ordered_logit = OrderedModel(
    df['loss_type'],
    df[feature_cols],
    distr='logit'
)
result_ologit = ordered_logit.fit(method='bfgs')
print(result_ologit.summary())

# 计算边际效应（对每个类别分别计算）
margeff_ologit = result_ologit.get_margeff()
print(margeff_ologit.summary())
```

**必须回答**：

1. 比例优势假定（Proportional Odds Assumption）：ologit 假设各变量对每个跨类别比较的效应是相同的，即"平行线假设"。使用 Brant 检验或似然比检验验证这一假设是否成立：

```python
# Brant 检验（若统计量显著，说明平行线假设不成立，应改用 mlogit）
from scipy import stats

# 分别估计两个二元 Logit：P(>=1) 和 P(>=2)
# 对比两个方程的系数，若差异显著则拒绝平行线假设
```

2. 若平行线假设被拒绝，改用**多项 Logit（mlogit）**，以 $LossType=0$（持续盈利）为参照组：

```python
from statsmodels.discrete.discrete_model import MNLogit

mnlogit = MNLogit(df['loss_type'], df[feature_cols_with_const])
result_mlogit = mnlogit.fit()

# 计算相对风险比（Relative Risk Ratio）
rrr = np.exp(result_mlogit.params)
```

3. 比较 ologit 与 mlogit 的结论：对于哪些变量，两个模型的方向和显著性是一致的？哪些变量存在差异？如何解释？

---

### 第六部分：稳健性检验

#### 6.1 替代因变量定义

- 改用 **ROE < 0**（净资产收益率为负）重新定义亏损，重新估计 Logit-4
- 讨论：两种定义下的系数是否一致？若不同，原因是什么？

#### 6.2 子样本稳健性

- **按产权性质分组**：分别对 SOE 和非 SOE 估计 Logit-4，比较两组系数
- **按时间子样本**：分别在 2010-2016 和 2017-2025 估计，检验金融危机后监管环境变化是否影响结论

#### 6.3 Probit 模型对比

以相同变量估计 Probit 模型，与 Logit 结果进行对比：

```python
probit_model = smf.probit(formula, data=df).fit()
```

展示两个模型的 AME 对比表，讨论两种模型在本数据集上的结论差异是否显著。

---

### 结果汇总表

将主要模型结果整理为汇报表（汇报边际效应，非原始系数）：

|  | Logit-1 | Logit-2 | Logit-3 | Logit-4 | Ologit | Mlogit(k=1) | Mlogit(k=2) |
|--|---------|---------|---------|---------|--------|------------|------------|
| Lev | | | | | | | |
| Size | | | | | | | |
| OpCF | | | | | | | |
| ... | | | | | | | |
| 行业FE | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| 年度FE | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| N | | | | | | | |
| AUC | | | | | | | |
| McFadden R² | | | | | | | |

注：括号内为标准误，\*p<0.1, \*\*p<0.05, \*\*\*p<0.01

---

### 提交要求

**同时完成以下两种方式：**

**① 坚果云压缩包**
- 文件命名：`Logit_小组名_成员名单.zip`
- 包含：Notebook（`.ipynb`）、`output/`、`README.md`
- 不包含 `data/raw/`（说明如何重新获取）

**② GitHub 仓库**
- 仓库名称：**`dshw-logit`**，Public
- GitHub Desktop 同步，仓库地址写入 `README.md`

加分项：Quarto Book 发布至 GitHub Pages（+10 分）

---

### 评分标准

| 维度 | 分值 | 说明 |
|------|------|------|
| 因变量构造与描述统计 | 15 分 | LossType 构造正确，时序/行业图有解读 |
| 变量筛选流程 | 15 分 | 三步筛选完整，最终变量有经济理由 |
| 二元 Logit 模型 | 25 分 | AME 计算正确，嵌套模型对比完整，三个问题有实质回答 |
| 有序/多项 Logit | 25 分 | 平行线检验完成，ologit/mlogit 结论对比有讨论 |
| 稳健性检验 | 10 分 | 至少完成两种稳健性检验 |
| 报告质量 | 10 分 | 结论表规范，文字解读有实质内容 |
| **加分项** | **+10 分** | Quarto Book 发布至 GitHub Pages |
