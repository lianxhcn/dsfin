# A 股 Beta 与投资组合分析：项目复现说明

本文档用于交给新的 agent。目标不是展示全部结果，而是让对方快速理解：这个项目已经做了什么、采用了什么设定、各 notebook 之间如何衔接、如何从零完整复现分析流程。

## 1. 项目目标

本项目围绕 5 只 A 股个股与沪深 300 指数，完成了三部分工作：

- 下载并清洗日度行情数据；
- 基于 CAPM 估计个股 Beta，并做分年度与滚动窗口分析；
- 基于个股收益率做相关性分析、等权重组合分析与有效前沿分析。

核心研究问题可以写成两个层面：

- 资产定价层面：个股相对于市场组合的系统性风险有多大，是否随时间变化；
- 投资组合层面：给定这 5 只股票，简单分散化是否能改善风险收益表现。

## 2. 当前项目已经完成的文件

当前已经完成并上传的核心文件有 5 个：

- `01_data_download.ipynb`
- `02_beta_estimation.ipynb`
- `03_portfolio_analysis.ipynb`
- `README.md`
- `Report.md`

其中：

- `README.md` 更像项目概览；
- `Report.md` 更像结果摘要；
- 3 个 notebook 才是完整复现分析流程的主体。

## 3. 样本设定

### 3.1 股票样本

项目固定使用 5 只股票：

| 变量名 | 股票代码 | 股票名称 | 行业 |
|---|---|---|---|
| ICBC | 601398.SH | 工商银行 | 银行 |
| YILI | 600887.SH | 伊利股份 | 食品饮料 |
| ZTE | 000063.SZ | 中兴通讯 | 通信 |
| YUNNAN | 000538.SH / 实际 notebook 中为 `000538.SZ` | 云南白药 | 医药生物 |
| SINOPEC | 600028.SH | 中国石化 | 石油化工 |

说明：`README.md` 与 `Report.md` 中写的是 `000538.SZ`，复现时以 notebook 中的实际代码为准。

### 3.2 市场基准

- 市场组合代理：沪深 300 指数
- 代码：`000300`
- 变量名：`CSI300`

### 3.3 时间范围

- 起始日期：`2019-01-01`
- 截止日期：`2026-03-25`

注意：2026 年只有部分年份数据，因此“分年度 Beta”中的 2026 年结果若样本不足，可单独处理；原 notebook 中采用统一循环，但会跳过观测值少于 30 的年度-股票组合。

## 4. 总体执行顺序

这个项目有明确的依赖关系，必须按以下顺序执行：

1. **先运行** `01_data_download.ipynb`
   - 生成原始数据、清洗后价格矩阵、收益率矩阵、描述性统计和基础图形。
2. **再运行** `02_beta_estimation.ipynb`
   - 读取 `data_clean/returns.csv` 和 `data_clean/prices.csv`；
   - 输出 CAPM 全样本 Beta、残差诊断、分年度 Beta、滚动 Beta。
3. **最后运行** `03_portfolio_analysis.ipynb`
   - 读取 `data_clean/returns.csv`、`data_clean/prices.csv`；
   - 同时依赖 `output/Q2_beta/full_sample_beta.csv`；
   - 输出相关性分析、等权重组合分析、有效前沿结果。

一句话概括依赖关系：

`01_data_download.ipynb -> 02_beta_estimation.ipynb -> 03_portfolio_analysis.ipynb`

## 5. 目录结构

项目目录结构如下：

```text
topic01_beta/
├── README.md
├── Report.md
├── 01_data_download.ipynb
├── 02_beta_estimation.ipynb
├── 03_portfolio_analysis.ipynb
├── data_raw/
├── data_clean/
└── output/
    ├── Q1_data/
    ├── Q2_beta/
    ├── Q3_yearly_beta/
    ├── Q4_rolling_beta/
    ├── Q5_correlation/
    ├── Q6_portfolio/
    └── Q7_efficient_frontier/
```

## 6. 运行环境与依赖包

### 6.1 Python 版本

- Python 3.9+

### 6.2 主要依赖

- `akshare`
- `pandas`
- `numpy`
- `matplotlib`
- `seaborn`
- `scipy`
- `statsmodels`
- `tqdm`

建议安装命令：

```bash
pip install akshare pandas numpy matplotlib seaborn scipy statsmodels tqdm
```

### 6.3 图形与中文显示

notebook 中显式设置了中文字体与负号：

```python
plt.rcParams['font.sans-serif'] = ['SimHei', 'Microsoft YaHei', 'DejaVu Sans']
plt.rcParams['axes.unicode_minus'] = False
```

如果在其他机器上运行时中文乱码，优先检查字体是否存在。

## 7. 关键统一参数

整个项目中反复用到的参数如下：

- 无风险利率：年化 `0.025`
- 日频无风险利率：`RF_DAILY = 0.025 / 252`
- 年化交易日数：`252`
- 滚动窗口长度：`60` 个交易日
- Ljung-Box 检验滞后阶数：`10`
- 分年度 Beta 的最少样本数：`30`
- 蒙特卡洛模拟次数：`5000`
- 有效前沿优化约束：权重和为 1，不允许做空

## 8. Notebook 1：数据下载与预处理

文件：`01_data_download.ipynb`

### 8.1 目标

完成以下工作：

- 使用 `akshare` 下载 5 只股票的日度后复权行情；
- 下载沪深 300 指数日度行情；
- 提取收盘价并计算日对数收益率；
- 将价格矩阵和收益率矩阵保存到 `data_clean/`；
- 输出描述性统计、正态性检验和时序图。

### 8.2 数据下载设定

个股数据下载函数：

```python
ak.stock_zh_a_hist(symbol=..., period='daily', start_date=..., end_date=..., adjust='hfq')
```

说明：

- 个股使用 `hfq` 后复权；
- 指数使用：

```python
ak.index_zh_a_hist(symbol='000300', period='daily', start_date=..., end_date=...)
```

### 8.3 预处理逻辑

预处理阶段做了三件事：

1. 标准化日期列与收盘价列名称；
2. 按日期升序排列；
3. 仅保留 `date` 与 `close` 两列用于后续分析。

notebook 中分别定义了：

- `process_stock_data(df, code, name)`
- `process_index_data(df)`

### 8.4 收益率定义

收益率采用日对数收益率：

$$
r_{it} = \ln \left( \frac{P_{it}}{P_{i,t-1}} \right)
$$

其中，$P_{it}$ 表示资产 $i$ 在日期 $t$ 的收盘价。

对应函数：

- `calculate_returns(df)`

### 8.5 对齐规则

所有资产收益率先并成一个宽表 `return_df`，随后使用：

```python
aligned_data = return_df.dropna()
price_df = price_df.loc[aligned_data.index]
```

这意味着：

- 最终样本保留所有资产都同时有有效收益率的日期交集；
- 价格矩阵与收益率矩阵共用同一套日期索引。

### 8.6 Notebook 1 输出文件

#### `data_raw/`

- `ICBC_raw.csv`
- `YILI_raw.csv`
- `ZTE_raw.csv`
- `YUNNAN_raw.csv`
- `SINOPEC_raw.csv`
- `CSI300_raw.csv`

#### `data_clean/`

- `returns.csv`
- `prices.csv`

#### `output/Q1_data/`

- `descriptive_statistics.csv`
- `jarque_bera_test.csv`
- `returns_timeseries_faceted.png`
- `returns_timeseries_overlay.png`
- `CSI300_returns_timeseries.png`

### 8.7 描述性统计与正态性检验

描述性统计包括：

- `Mean`
- `Std`
- `Skewness`
- `Kurtosis`
- `Min`
- `Max`
- `Count`
- `Ann. Return`
- `Ann. Volatility`

其中：

$$
\text{Ann.Return} = \bar r \times 252
$$

$$
\text{Ann.Volatility} = s_r \times \sqrt{252}
$$

正态性检验使用 Jarque-Bera 检验。

## 9. Notebook 2：Beta 系数估计

文件：`02_beta_estimation.ipynb`

### 9.1 目标

完成以下工作：

- 读取清洗后的收益率数据；
- 构造超额收益；
- 估计全样本 CAPM Beta；
- 做残差诊断；
- 估计分年度 Beta；
- 估计 60 日滚动 Beta；
- 输出图形与结果表。

### 9.2 超额收益定义

对所有资产，先计算超额收益：

$$
R_{it}^{e} = r_{it} - r_f
$$

其中，$r_f = 0.025 / 252$。

### 9.3 CAPM 设定

核心回归模型为：

$$
R_{it}^{e} = \alpha_i + \beta_i R_{mt}^{e} + \varepsilon_{it}
$$

其中：

- $R_{it}^{e}$：个股 $i$ 的日超额收益；
- $R_{mt}^{e}$：沪深 300 指数的日超额收益；
- $\beta_i$：个股相对市场的系统性风险暴露。

实现函数：

- `capm_regression(stock_excess, market_excess)`

估计方法：

- `statsmodels.OLS`

### 9.4 全样本回归输出

每只股票都会输出：

- `Alpha`
- `Alpha_pval`
- `Beta`
- `Beta_pval`
- `R-squared`
- `Adj_R2`
- `Std_Error`
- `F_stat`
- `F_pval`
- `N_obs`

对应输出文件：

- `output/Q2_beta/full_sample_beta.csv`

### 9.5 残差诊断

notebook 对 CAPM 残差做两类检验：

- Ljung-Box 自相关检验；
- White 异方差检验。

原假设分别是：

- Ljung-Box：残差无自相关；
- White：残差同方差。

设置：

- Ljung-Box 滞后阶数 `lags = [10]`

对应输出文件：

- `output/Q2_beta/residual_diagnostics.csv`

### 9.6 分年度 Beta

做法是将收益率按自然年度分组，对每个“股票 × 年份”分别跑一次 CAPM：

$$
R_{it}^{e} = \alpha_{iy} + \beta_{iy} R_{mt}^{e} + \varepsilon_{it}, \quad t \in y
$$

约束：

- 若某年度有效样本数小于 30，则跳过该组。

对应输出文件：

- `output/Q3_yearly_beta/yearly_beta.csv`
- `output/Q3_yearly_beta/yearly_beta_pivot.csv`
- `output/Q3_yearly_beta/yearly_beta.png`

### 9.7 滚动 Beta

滚动 Beta 使用 60 个交易日窗口。对每个窗口单独做一次 OLS：

$$
R_{it}^{e} = \alpha_{i,t}^{(60)} + \beta_{i,t}^{(60)} R_{mt}^{e} + \varepsilon_{it}
$$

实现函数：

- `rolling_beta(stock_excess, market_excess, window = 60)`

滚动 Beta 统计特征包括：

- `Mean`
- `Std`
- `Min`
- `Max`
- `Range = Max - Min`

对应输出文件：

- `output/Q4_rolling_beta/rolling_beta.csv`
- `output/Q4_rolling_beta/rolling_beta_stats.csv`
- `output/Q4_rolling_beta/rolling_beta.png`
- `output/Q4_rolling_beta/rolling_beta_faceted.png`

### 9.8 Notebook 2 中额外标注的事件区间

滚动 Beta 图中额外标注了三段市场事件：

- `2020-02-01` ~ `2020-04-30`：COVID-19
- `2021-07-01` ~ `2021-09-30`：监管收紧
- `2022-03-01` ~ `2022-05-31`：A 股调整

这些阴影区主要用于图形解释，不影响估计本身。

## 10. Notebook 3：相关性分析与投资组合构建

文件：`03_portfolio_analysis.ipynb`

### 10.1 目标

完成以下工作：

- 计算 5 只股票之间的静态相关系数矩阵；
- 计算两两股票的 60 日滚动相关系数；
- 构造等权重组合并评价绩效；
- 用 CAPM 估计组合 Beta；
- 验证组合 Beta 的可加性；
- 求解最小方差组合、最大夏普组合，并绘制有效前沿。

### 10.2 静态相关系数

直接对 5 只股票日收益率计算 Pearson 相关系数矩阵：

$$
\rho_{ij} = \text{Corr}(r_{it}, r_{jt})
$$

对应输出文件：

- `output/Q5_correlation/correlation_matrix.csv`
- `output/Q5_correlation/correlation_heatmap.png`

### 10.3 滚动相关系数

对 5 只股票两两配对，共有：

$$
\binom{5}{2} = 10
$$

个组合。

每一对股票采用 60 日滚动相关系数：

$$
\rho_{ij,t}^{(60)} = \text{Corr}(r_{i,t-59:t}, r_{j,t-59:t})
$$

对应输出文件：

- `output/Q5_correlation/rolling_correlation.csv`
- `output/Q5_correlation/rolling_correlation_stats.csv`
- `output/Q5_correlation/rolling_correlation.png`

### 10.4 等权重组合

组合权重固定为：

$$
w_i = \frac{1}{5}, \quad i = 1, \ldots, 5
$$

组合日收益率为：

$$
r_{p,t} = \sum_{i=1}^{5} w_i r_{it}
$$

### 10.5 绩效评价指标

等权重组合的绩效函数为：

- `calculate_performance_metrics(returns_series, rf_daily = RF_DAILY, annualization_factor = 252)`

评价指标包括：

- 年化收益率
- 年化波动率
- 最大回撤
- 夏普比率
- 样本量

形式上：

$$
\text{Ann.Return} = \bar r_p \times 252
$$

$$
\text{Ann.Volatility} = s_p \times \sqrt{252}
$$

$$
\text{Sharpe} = \frac{\text{Ann.Return} - 0.025}{\text{Ann.Volatility}}
$$

最大回撤基于累计净值序列计算。累计净值定义为：

$$
NAV_t = \prod_{\tau = 1}^{t} (1 + r_{p,\tau})
$$

回撤定义为：

$$
DD_t = \frac{NAV_t - \max_{\tau \le t} NAV_{\tau}}{\max_{\tau \le t} NAV_{\tau}}
$$

最大回撤即 $\min_t DD_t$。

对应输出文件：

- `output/Q6_portfolio/portfolio_performance.csv`
- `output/Q6_portfolio/nav_data.csv`
- `output/Q6_portfolio/portfolio_nav.png`

### 10.6 组合 CAPM 与 Beta 可加性

组合超额收益定义为：

$$
R_{p,t}^{e} = r_{p,t} - r_f
$$

然后估计：

$$
R_{p,t}^{e} = \alpha_p + \beta_p R_{m,t}^{e} + \varepsilon_{p,t}
$$

notebook 进一步检验：

$$
\beta_p \approx \sum_{i=1}^{5} w_i \beta_i
$$

在等权重情况下：

$$
\beta_p \approx \frac{1}{5} \sum_{i=1}^{5} \beta_i
$$

这里用 `03_portfolio_analysis.ipynb` 读取 `output/Q2_beta/full_sample_beta.csv`，并与组合回归得到的 Beta 做对比。

### 10.7 有效前沿

#### 输入

- 5 只股票的年化平均收益率向量；
- 年化协方差矩阵。

#### 目标函数

定义：

$$
\mu_p = w'\mu
$$

$$
\sigma_p = \sqrt{w'\Sigma w}
$$

$$
\text{Sharpe}(w) = \frac{\mu_p - r_f}{\sigma_p}
$$

notebook 中实现了三个函数：

- `portfolio_return(weights, mean_returns)`
- `portfolio_volatility(weights, cov_matrix)`
- `portfolio_sharpe(weights, mean_returns, cov_matrix, rf = RF_ANNUAL)`

#### 约束

- 权重和为 1：$\sum_i w_i = 1$
- 不允许做空：$0 \le w_i \le 1$

#### 求解内容

- 最小方差组合；
- 最大夏普比率组合；
- 5000 次蒙特卡洛随机权重组合；
- 基于目标收益率序列数值求解有效前沿边界。

对应输出文件：

- `output/Q7_efficient_frontier/efficient_frontier.png`
- `output/Q7_efficient_frontier/efficient_frontier_portfolios.csv`

## 11. 主要结果摘要

以下数值来自现有 `Report.md`，可作为复现后的核对基准。

### 11.1 全样本 Beta

| 股票 | Beta | R² |
|---|---:|---:|
| ICBC | 0.1807 | 0.0531 |
| YILI | 0.7853 | 0.2692 |
| ZTE | 1.2047 | 0.3929 |
| YUNNAN | 0.7112 | 0.2226 |
| SINOPEC | 0.2231 | 0.0567 |

结论层面：

- ZTE 的系统性风险最高；
- ICBC 与 SINOPEC 的 Beta 明显偏低，防御性更强。

### 11.2 等权重组合绩效

| 指标 | 等权组合 | 沪深 300 |
|---|---:|---:|
| 年化收益率 | 5.98% | 6.11% |
| 年化波动率 | 14.84% | 19.00% |
| 最大回撤 | -26.82% | -38.65% |
| 夏普比率 | 0.2345 | 0.1889 |
| Calmar 比率 | 0.1665 | 0.0954 |

解释：

- 组合收益率略低于基准；
- 但波动率和最大回撤更低；
- 风险调整后表现优于沪深 300。

### 11.3 有效前沿中的特殊组合

| 组合 | 年化收益 | 年化波动 | 夏普比率 |
|---|---:|---:|---:|
| 等权重组合 | 5.98% | 14.84% | 0.2345 |
| 最小方差组合 | 5.88% | 9.36% | 0.3605 |
| 最大夏普组合 | 6.63% | 10.28% | 0.4017 |

## 12. 对 agent 的明确复现要求

如果新的 agent 要“完整复现”本项目，至少应做到以下几点：

1. **不要改样本股票**，仍使用这 5 只股票和沪深 300。
2. **不要改样本期**，仍使用 `2019-01-01` 到 `2026-03-25`。
3. **不要改收益率定义**，仍使用日对数收益率。
4. **不要改无风险利率设定**，仍使用年化 `2.5%`。
5. **不要改滚动窗口**，仍使用 `60` 日。
6. **不要改优化约束**，仍使用“不允许做空、权重和为 1”。
7. 必须按 `01 -> 02 -> 03` 的顺序执行。
8. 复现完成后，应检查输出文件是否完整生成。
9. 若结果与 `Report.md` 有细微差异，应先检查：
   - `akshare` 版本是否变化；
   - 数据源接口是否更新；
   - 是否误改了复权方式或日期对齐方式；
   - 是否将简单收益率误写成对数收益率。

## 13. 建议 agent 优先核对的输出文件

为了快速判断复现是否成功，建议优先核对以下 8 个文件：

- `data_clean/returns.csv`
- `data_clean/prices.csv`
- `output/Q2_beta/full_sample_beta.csv`
- `output/Q2_beta/residual_diagnostics.csv`
- `output/Q3_yearly_beta/yearly_beta.csv`
- `output/Q4_rolling_beta/rolling_beta.csv`
- `output/Q6_portfolio/portfolio_performance.csv`
- `output/Q7_efficient_frontier/efficient_frontier_portfolios.csv`

如果这 8 个文件都能正常生成，且数值与现有报告大体一致，说明主流程已经复现成功。

## 14. 后续如需进一步规范化

若后续要把这个项目改造成更正式、可长期维护的版本，可以继续做三件事：

- 把 3 个 notebook 改写为 `main.py + functions.py + config.py` 的脚本化结构；
- 固化依赖版本，增加 `requirements.txt`；
- 写一个总控脚本，使 agent 可以一键完成全流程执行。

但就当前阶段而言，现有 3 个 notebook 已经足以完整复现整个分析流程。
