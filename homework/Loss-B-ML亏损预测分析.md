## 上市公司亏损预测：机器学习方法

> **作业性质**：小组作业（建议 3-4 人）  
> **完成时间**：两周  
> **数据来源**：沿用资本结构作业的 CSMAR 数据集，特征变量与 Logit 作业保持一致  
> **工具**：Python（sklearn + statsmodels），Jupyter Notebook  
> **提交方式**：见文末「提交要求」

---

### 研究背景与任务定位

**因果推断 vs 预测**：本作业与 Logit 作业使用相同数据，但目标完全不同。

| 维度 | Logit 作业 | 本作业 |
|------|-----------|--------|
| 目标 | 理解哪些因素"导致"亏损 | 预测哪些公司"将会"亏损 |
| 关注点 | 系数方向、显著性、因果解释 | 样本外预测精度、泛化能力 |
| 数据使用 | 全样本估计（不划分训练/测试） | 严格的训练集/测试集分离 |
| 评估指标 | AME、McFadden R²、AIC | AUC、F1、Precision、Recall |
| 模型偏好 | 可解释性（白盒） | 预测精度（可容忍黑盒） |

这两种视角在实践中都有价值：监管机构和学者更关注因果机制（Logit），而量化投资者和风控部门更关注预测精度（ML）。本作业训练的是后者的思维方式。

---

### 第一部分：数据准备与特征工程

#### 1.1 因变量

$$Loss_{it} = \mathbf{1}[NPR_{it} < 0]$$

使用二元亏损指标（而非 Logit 作业中的三分类 $LossType$），以使预测任务更清晰。

#### 1.2 特征变量

使用 Logit 作业中经过 Winsorize 和变量筛选后确定的全部特征（$Lev$、$Size$、$Tang$、$Growth$、$NDTS$、$SOE$、$ROA\_lag$、$CashRatio$、$OpCF$、$SalesGrowth$、$Age$、$DualRole$），**无需重新筛选**，直接使用 Logit 作业中 Lasso 选出的变量集。

#### 1.3 类别不平衡处理

A 股亏损公司占比约 10%-15%，存在显著的**类别不平衡**（Class Imbalance）。若忽视这一问题，所有模型会倾向于将所有样本预测为"不亏损"，准确率（Accuracy）虚高但毫无预测价值。

**检查类别比例**：

```python
print(df['loss'].value_counts(normalize=True))
# 预期输出类似：0: 0.87, 1: 0.13
```

**处理策略（必须选择一种并说明理由）**：

| 策略 | 方法 | 适用场景 |
|------|------|---------|
| 过采样少数类 | SMOTE（合成少数类过采样） | 数据量不足时 |
| 欠采样多数类 | RandomUnderSampler | 数据量充足时 |
| 调整分类阈值 | 将默认 0.5 阈值调低至 0.3 | 关注召回率时 |
| 调整类别权重 | `class_weight='balanced'` | 最简单，推荐优先尝试 |

```python
# 推荐方案：调整类别权重（不改变数据，代码最简洁）
from sklearn.linear_model import LogisticRegression
model = LogisticRegression(class_weight='balanced')

# 或者 SMOTE 过采样
from imblearn.over_sampling import SMOTE
smote = SMOTE(random_state=42)
X_train_res, y_train_res = smote.fit_resample(X_train, y_train)
```

> **核心原则**：类别不平衡处理只能在**训练集内部**进行，绝对不能对测试集做任何采样处理。测试集必须保持原始分布，才能反映真实预测场景。

---

### 第二部分：时序交叉验证框架

#### 2.1 为什么不能用随机 K-Fold

金融面板数据存在**时序依赖**：$t$ 年的公司状态与 $t-1$、$t-2$ 年高度相关。若使用随机 K-Fold，训练集中会包含测试集公司的未来数据，造成**数据泄露（Data Leakage）**，导致样本外性能被严重高估。

**时序划分方案（本作业采用）**：

```
扩展窗口（Expanding Window）：
  折 1：训练 2010-2018 → 测试 2019
  折 2：训练 2010-2019 → 测试 2020
  折 3：训练 2010-2020 → 测试 2021
  折 4：训练 2010-2021 → 测试 2022
  折 5：训练 2010-2022 → 测试 2023
  折 6：训练 2010-2023 → 测试 2024
  最终评估：训练 2010-2019 → 测试 2020-2025（保留最近5年作最终测试集）
```

```python
import numpy as np
from sklearn.model_selection import TimeSeriesSplit

years = sorted(df['year'].unique())
# 使用年份作为时间维度，而非行索引
# 注意：sklearn 的 TimeSeriesSplit 基于行索引，
# 对面板数据需要自定义 split

def time_series_splits(df, year_col='year', n_splits=5):
    """按年份生成时序交叉验证折"""
    years = sorted(df[year_col].unique())
    min_train_years = len(years) - n_splits
    splits = []
    for i in range(n_splits):
        train_years = years[:min_train_years + i]
        test_year = years[min_train_years + i]
        train_idx = df[df[year_col].isin(train_years)].index
        test_idx = df[df[year_col] == test_year].index
        splits.append((train_idx, test_idx))
    return splits
```

#### 2.2 讨论：何时随机 K-Fold 更合适？

> 思考题：假设某基金公司训练好了一个亏损预测模型，想用它预测**当年新上市公司**次年的亏损风险。在这个场景下，是否仍然需要时序交叉验证？请说明理由，并描述应该如何划分数据。

（提示：新上市公司在训练集中不存在，泄露的方向是跨**个体**而非跨**时间**的。）

---

### 第三部分：探索性聚类分析（K-means）

在建模之前，先用无监督方法探索亏损企业的内部异质性——亏损可能有多种"类型"，不同类型的驱动因素可能不同。

#### 3.1 对亏损子样本聚类

仅对 $Loss=1$ 的样本进行聚类，以财务特征为输入：

```python
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import silhouette_score

# 只取亏损样本
df_loss = df[df['loss'] == 1].copy()
X_loss = df_loss[['lev', 'size', 'tang', 'growth', 'cash_ratio', 'op_cf', 'sales_growth']]

# 标准化（K-means 对量纲敏感）
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X_loss)

# 用肘部法则（Elbow Method）选择最优 K
inertias, silhouettes = [], []
for k in range(2, 8):
    km = KMeans(n_clusters=k, random_state=42, n_init=10)
    km.fit(X_scaled)
    inertias.append(km.inertia_)
    silhouettes.append(silhouette_score(X_scaled, km.labels_))

# 绘制肘部曲线和轮廓系数曲线，选择最优 K
```

#### 3.2 聚类结果描述

以最优 $K$ 进行聚类后，描述每个簇的财务画像：

```python
df_loss['cluster'] = km.predict(X_scaled)

# 计算每个簇的特征均值
cluster_profile = df_loss.groupby('cluster')[feature_cols].mean()
print(cluster_profile.round(3))
```

绘制**雷达图（Radar Chart）**，直观展示各簇的财务特征差异：

| 簇 | 特征描述 | 典型企业类型 |
|----|---------|------------|
| 簇 0 | 高杠杆、低现金流 | 债务危机型亏损 |
| 簇 1 | 低杠杆、收入萎缩 | 业务萎缩型亏损 |
| 簇 2 | 高成长、大额投入 | 战略投入型亏损 |

（以上为示例，实际结果依数据而定，须根据真实聚类结果重新命名和解释）

#### 3.3 聚类结果与后续建模的关联

分析不同簇的亏损持续性差异：
- 各簇中 $LossType=2$（持续亏损）的占比是否有显著差异？
- 讨论：K-means 发现的亏损类型对预测模型有什么启示？（某些类型的亏损可能比其他类型更难预测）

---

### 第四部分：预测模型

使用以下 5 个模型，在统一的时序交叉验证框架下进行预测：

| 模型 | 库 | 关键参数 | 定位 |
|------|----|---------|------|
| 逻辑回归（LR） | `sklearn.linear_model` | `C`, `class_weight` | 线性基准，可解释 |
| 支持向量机（SVM） | `sklearn.svm.SVC` | `C`, `kernel`, `gamma` | 非线性，边界清晰 |
| 随机森林（RF） | `sklearn.ensemble` | `n_estimators`, `max_depth` | 集成方法，自带特征重要性 |
| XGBoost（XGB） | `xgboost` | `n_estimators`, `learning_rate` | 梯度提升，通常最强 |
| 朴素贝叶斯（NB） | `sklearn.naive_bayes` | — | 极简基准 |

#### 4.1 超参数调优

对每个模型，在**训练集内部**使用时序交叉验证进行超参数搜索（不得使用测试集调参）：

```python
from sklearn.model_selection import GridSearchCV

# SVM 示例
svm_params = {
    'C': [0.1, 1, 10],
    'kernel': ['linear', 'rbf'],
    'gamma': ['scale', 'auto'],
    'class_weight': ['balanced']
}

# 注意：这里的 cv 也应使用时序划分
svm_cv = GridSearchCV(
    SVC(probability=True),
    svm_params,
    cv=time_series_splits(df_train, n_splits=3),
    scoring='roc_auc',
    n_jobs=-1
)
svm_cv.fit(X_train, y_train)
print("最优参数：", svm_cv.best_params_)
```

#### 4.2 评估指标

对每个模型，在测试集上计算以下指标：

```python
from sklearn.metrics import (
    roc_auc_score, average_precision_score,
    f1_score, precision_score, recall_score,
    confusion_matrix, classification_report,
    brier_score_loss
)

def evaluate_model(y_true, y_pred, y_prob):
    return {
        'AUC':       roc_auc_score(y_true, y_prob),
        'AP':        average_precision_score(y_true, y_prob),   # PR曲线下面积
        'F1':        f1_score(y_true, y_pred),
        'Precision': precision_score(y_true, y_pred),
        'Recall':    recall_score(y_true, y_pred),
        'Brier':     brier_score_loss(y_true, y_prob),          # 概率校准
    }
```

**各指标含义与重要性**：

| 指标 | 含义 | 本场景的重要性 |
|------|------|--------------|
| AUC（ROC） | 区分亏损/盈利的整体能力，与阈值无关 | **最重要**，首选评估指标 |
| AP（PR曲线面积） | 类别不平衡下的精度，比 AUC 更严格 | 类别不平衡时优先参考 |
| F1 | Precision 和 Recall 的调和均值 | 综合评估，需指定阈值 |
| Recall（召回率） | 真实亏损公司中被正确识别的比例 | 若"漏报"代价大则重点关注 |
| Precision（精确率）| 预测为亏损的公司中真正亏损的比例 | 若"误报"代价大则重点关注 |
| Brier Score | 预测概率的均方误差，评估概率校准 | 若用于风险定价则需关注 |
| Accuracy | 整体准确率 | **不推荐**作为主指标（类别不平衡下无意义） |

> **为什么不用 Accuracy**：若测试集中 87% 是盈利公司，一个"无脑预测所有公司不亏损"的模型 Accuracy 也有 87%，但它对亏损公司的识别能力为零。Accuracy 在类别不平衡场景下会产生严重误导。

#### 4.3 混淆矩阵与错误分析

```python
from sklearn.metrics import ConfusionMatrixDisplay
import matplotlib.pyplot as plt

fig, axes = plt.subplots(1, 5, figsize=(20, 4))
for ax, (name, model) in zip(axes, models.items()):
    y_pred = model.predict(X_test)
    ConfusionMatrixDisplay.from_predictions(
        y_test, y_pred, ax=ax,
        display_labels=['盈利', '亏损'],
        colorbar=False
    )
    ax.set_title(name)
plt.tight_layout()
```

**必须回答**：

1. 哪类错误更严重——**假阴性**（将亏损公司误判为盈利）还是**假阳性**（将盈利公司误判为亏损）？在监管预警、量化投资两个场景下，答案是否相同？
2. 通过调整决策阈值（从默认 0.5 调低至 0.2-0.3），Recall 如何变化？代价是什么？

#### 4.4 ROC 曲线与 PR 曲线对比

```python
from sklearn.metrics import roc_curve, precision_recall_curve

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

for name, model in models.items():
    y_prob = model.predict_proba(X_test)[:, 1]
    
    # ROC 曲线
    fpr, tpr, _ = roc_curve(y_test, y_prob)
    auc = roc_auc_score(y_test, y_prob)
    ax1.plot(fpr, tpr, label=f'{name} (AUC={auc:.3f})')
    
    # PR 曲线
    prec, rec, _ = precision_recall_curve(y_test, y_prob)
    ap = average_precision_score(y_test, y_prob)
    ax2.plot(rec, prec, label=f'{name} (AP={ap:.3f})')

ax1.plot([0,1],[0,1],'k--'); ax1.set_title('ROC Curve')
ax2.axhline(y_test.mean(), color='k', linestyle='--', label='Baseline')
ax2.set_title('Precision-Recall Curve')
for ax in [ax1, ax2]:
    ax.legend(); ax.set_xlabel('Recall' if ax==ax2 else 'FPR')
```

---

### 第五部分：模型解释（可解释性分析）

"黑盒"模型预测精度高，但不知道为什么做出某个预测，在实际应用中往往难以被监管机构或投资者接受。本部分要求对最优模型进行可解释性分析。

#### 5.1 随机森林特征重要性

```python
rf_best = best_models['RF']

# 特征重要性（MDI：Mean Decrease Impurity）
feat_imp = pd.Series(
    rf_best.feature_importances_,
    index=feature_cols
).sort_values(ascending=False)

feat_imp.plot(kind='barh', title='随机森林特征重要性（MDI）')
```

#### 5.2 SHAP 值分析

SHAP（SHapley Additive exPlanations）是目前最受认可的模型解释框架，能为每个预测给出"每个特征贡献了多少":

```python
# pip install shap
import shap

# 对随机森林计算 SHAP 值
explainer = shap.TreeExplainer(rf_best)
shap_values = explainer.shap_values(X_test)

# 全局特征重要性（Beeswarm Plot）
shap.summary_plot(shap_values[1], X_test,
                  feature_names=feature_cols,
                  plot_type='beeswarm')

# 单样本解释：解释一个被错误预测的亏损公司
wrong_idx = np.where((y_test == 1) & (y_pred == 0))[0][0]
shap.force_plot(explainer.expected_value[1],
                shap_values[1][wrong_idx],
                X_test.iloc[wrong_idx],
                feature_names=feature_cols)
```

**必须回答**：

1. SHAP 重要性排名与随机森林 MDI 重要性排名是否一致？若有差异，哪个更可信？
2. 与 Logit 作业中的 AME 排名相比，哪些特征在两种方法中都稳定地排在前列？这些特征是否有经济意义上的共同特点？

---

### 第六部分：模型综合对比

#### 6.1 性能汇总表

| 模型 | AUC | AP | F1 | Recall | Precision | Brier |
|------|-----|-----|-----|--------|-----------|-------|
| 逻辑回归 | | | | | | |
| SVM | | | | | | |
| 随机森林 | | | | | | |
| XGBoost | | | | | | |
| 朴素贝叶斯 | | | | | | |

各模型均基于最优超参数，在同一最终测试集（2020-2025）上评估。

#### 6.2 逐年预测性能

绘制每个模型在各测试年份（2019-2025）的 AUC 时序图，分析：

- 预测性能在哪些年份明显下降？（如 2020 年 COVID-19 冲击是否导致模型性能恶化？）
- 不同模型的性能稳定性如何？哪个模型的年际波动最小？

```python
yearly_auc = {}
for year in test_years:
    mask = df_test['year'] == year
    for name, model in models.items():
        y_prob = model.predict_proba(X_test[mask])[:, 1]
        yearly_auc.setdefault(name, []).append(
            roc_auc_score(y_test[mask], y_prob)
        )

pd.DataFrame(yearly_auc, index=test_years).plot(
    title='逐年 AUC：各模型性能稳定性比较',
    marker='o'
)
```

#### 6.3 核心讨论问题

报告须用文字回答以下问题：

1. **模型选择**：综合 AUC、AP、F1 和可解释性，你会向监管机构推荐哪个模型用于亏损预警？理由是什么？
2. **预测 vs 因果**：Logit 作业发现 $OpCF$ 是亏损的重要影响因素，在本作业的 SHAP 分析中它的排名如何？两者不一致时，可能的原因是什么？
3. **时效性与衰减**：机器学习模型通常存在"性能衰减"问题——随着时间推移，训练数据与预测目标的分布越来越不一致。你会建议多久重新训练一次模型？

---

### 提交要求

**同时完成以下两种方式：**

**① 坚果云压缩包**
- 文件命名：`ML_小组名_成员名单.zip`
- 包含：全部 Notebook、`output/`、`README.md`
- 不包含 `data/raw/`

**② GitHub 仓库**
- 仓库名称：**`dshw-ml`**，Public
- GitHub Desktop 同步，仓库地址写入 `README.md`

加分项：Quarto Book 发布至 GitHub Pages（+10 分）

---

### README.md 要求

```markdown
## 上市公司亏损预测：机器学习方法

### 小组成员与分工
| 姓名 | 负责模块 |
|------|---------|

### 数据概况
- 样本：XX 公司，XX 观测，2010-2025 年
- 训练集：2010-2019；测试集：2020-2025
- 亏损样本占比：XX%
- 类别不平衡处理方式：[说明]

### 模型性能摘要
| 模型 | AUC（测试集）| 推荐场景 |
|------|------------|---------|

### GitHub 仓库
https://github.com/[用户名]/dshw-ml

### 主要发现（3-5 条）
1. ...
```

---

### 评分标准

| 维度 | 分值 | 说明 |
|------|------|------|
| 数据准备与类别不平衡处理 | 15 分 | 处理策略有理由，测试集未被污染 |
| 时序交叉验证实现 | 15 分 | 无数据泄露，折划分正确，讨论问题有实质回答 |
| K-means 聚类分析 | 10 分 | 聚类有解释，与预测任务有关联 |
| 5 个模型实现与评估 | 25 分 | 超参数调优在训练集内部进行，6 个指标齐全 |
| 模型可解释性分析 | 15 分 | SHAP 图规范，与 Logit 结果对比有实质讨论 |
| 综合对比与核心讨论 | 20 分 | 逐年 AUC 图有分析，三个问题有实质回答 |
| **加分项** | **+10 分** | Quarto Book 发布至 GitHub Pages |

> **核心提示**：这道题最容易犯的错误是"用测试集调参"和"对测试集做 SMOTE"——前者导致结果过于乐观，后者导致评估失真。评分时会重点检查训练/测试分离是否严格。性能好看但流程有问题，不如性能差一点但流程正确。
