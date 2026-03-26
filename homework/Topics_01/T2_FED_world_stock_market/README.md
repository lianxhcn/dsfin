# 美联储货币政策与全球股市联动分析

## 项目概述

本项目围绕美联储政策利率调整，研究全球 6 个主要股票市场对货币政策冲击的短期反应、回归敏感性以及动态联动性变化。分析框架包含：

1. 美联储利率事件识别与整理
2. 事件研究法下的异常收益率 AR 与累计异常收益率 CAR
3. 分市场回归分析
4. 全球股市联动性的滚动相关与分阶段对比

## 市场样本与数据来源

| 市场 | 指数名称 | 代码 | 数据源 | 频率 |
|---|---|---|---|---|
| 美国 | 标普 500 | ^GSPC | yfinance | 日度 |
| 中国 | 沪深 300 | 000300 | akshare | 日度 |
| 日本 | 日经 225 | ^N225 | yfinance | 日度 |
| 英国 | 富时 100 | ^FTSE | yfinance | 日度 |
| 德国 | DAX | ^GDAXI | yfinance | 日度 |
| 中国香港 | 恒生指数 | ^HSI | yfinance | 日度 |
| 美国货币政策 | 联邦基金目标利率上限 | DFEDTARU / akshare | FRED 或 akshare | 日度 / 决议日 |

## 研究期间

- 建议样本期：2000-01-01 至今
- 事件窗口：[-5, +5] 个交易日
- 正常收益估计窗口：[-30, -6] 个交易日
- 联动性滚动窗口：60 个交易日

## 项目结构

```text
T2_FED_world_stock_market/
├── README.md
├── 01_data_clean.ipynb
├── 02_event_study.ipynb
├── 03_regression_analysis.ipynb
├── data_raw/
├── data_clean/
├── code/
│   ├── data_utils.py
│   └── event_study_utils.py
└── output/
```

## 利率事件表字段说明

清洗后的事件表应包含以下字段：

- date: 决议公布日
- change_bp: 利率变动幅度，单位为基点 bp
- type: hike / cut / hold
- rate_after: 调整后利率水平
- rate_before: 调整前利率水平
- year: 年份
- event_id: 事件编号

## 研究期间内加息/降息事件列表

说明：该表由 [01_data_clean.ipynb](./01_data_clean.ipynb) 自动生成并保存到 data_clean/fed_events.csv。运行 notebook 后可在此处替换为实际输出表。建议最终 README 粘贴前 15 到 20 条事件，并附完整文件路径说明。

| date | change_bp | type | rate_after |
|---|---:|---|---:|
| 2001-01-03 | -50 | cut | 6.00 |
| 2004-06-30 | 25 | hike | 1.25 |
| 2007-09-18 | -50 | cut | 4.75 |
| 2015-12-16 | 25 | hike | 0.50 |
| 2019-07-31 | -25 | cut | 2.25 |
| 2020-03-15 | -100 | cut | 0.25 |
| 2022-03-16 | 25 | hike | 0.50 |
| 2022-06-15 | 75 | hike | 1.75 |
| 2023-07-26 | 25 | hike | 5.50 |

## 主要发现

运行 notebook 后，README 至少应总结 3 到 5 条发现。建议围绕以下方向组织：

1. 加息事件与降息事件对不同市场的平均 CAR 是否存在方向差异。
2. 哪些市场对 change_bp 的回归系数更显著，反映政策敏感度更高。
3. 全球股市在不同货币政策周期中的平均相关性是否显著变化。
4. 中国市场与美国、欧洲市场相比是否表现出更弱或更滞后的反应。
5. 极端宽松或快速紧缩阶段，全球市场联动性是否显著增强。

## 运行环境

- Python 3.10+
- pandas
- numpy
- matplotlib
- seaborn
- scipy
- statsmodels
- yfinance
- akshare

## 运行顺序

1. 运行 01_data_clean.ipynb 获取并清洗利率与股指数据。
2. 运行 02_event_study.ipynb 生成 AR、CAR、显著性检验与事件图。
3. 运行 03_regression_analysis.ipynb 完成回归分析与联动性热力图。

## 输出文件说明

- data_raw/fed_rate_raw.csv: 原始利率数据
- data_raw/global_index_prices.csv: 原始指数价格
- data_clean/fed_events.csv: 清洗后的政策事件表
- data_clean/global_index_returns.csv: 对齐后的日收益率
- output/average_car_by_market.csv: 各市场平均 CAR
- output/regression_results.csv: 各市场回归结果
- output/correlation_heatmap_*.png: 分阶段联动性热力图

## 注意事项

- 不同市场交易日与时区不一致，事件日收益率需要使用最近可交易日映射。
- FRED 与 akshare 的美联储利率序列口径可能略有差异，建议最终提交时固定一种来源并说明。
- 事件研究中的估计窗口和事件窗口可能因节假日导致样本不足，代码已包含最小样本校验。
