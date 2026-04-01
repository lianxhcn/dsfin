# 数据集设计规格

## 四类数据集的教学定位

| 数据集 | 文件位置 | 粒度 | 主键 | 在讲义中的教学功能 |
|---|---|---|---|---|
| A 个股日度 | `stock_daily/{code}.csv` | firm-date | code+date | 全章主线，引出"多文件管理"问题 |
| B 指数+宏观 | `index_daily/`, `macro_monthly/` | date（日/月混频）| date | 演示混频 JOIN |
| C 年度财务 | `fin_annual/fin_indicators.csv` | firm-year | code+year | 演示跨频率聚合与合并 |
| D 公司信息 | `company_info.csv` | firm | code | 维度表，JOIN 键 |

---

## 股票列表（固定，不要更改）

```python
stocks = {
    "000001": "平安银行",   # 银行/金融
    "000002": "万科A",      # 房地产
    "600519": "贵州茅台",   # 消费/白酒（大盘权重股）
    "300750": "宁德时代",   # 新能源/制造
    "601318": "中国平安",   # 保险
    "002594": "比亚迪",     # 汽车/新能源
    "600036": "招商银行",   # 银行
    "601012": "隆基绿能",   # 光伏
    "000333": "美的集团",   # 家电/制造
    "600276": "恒瑞医药",   # 医药
}
```

选股理由：行业分散（金融、消费、制造、能源、医药）、有大盘权重股也有中型股、有国企也有民企，适合后续做行业对比和分组分析。

---

## 字段规格（统一标准）

### stock_daily（个股日度）

```
date        string    YYYY-MM-DD
code        string    6位股票代码
name        string    股票简称
open        float     开盘价（后复权）
close       float     收盘价（后复权）
high        float     最高价（后复权）
low         float     最低价（后复权）
volume      float     成交量（手）
amount      float     成交额（元）
pct_chg     float     涨跌幅（%）
turnover    float     换手率（%）
```

### index_daily（指数日度）

```
date        string    YYYY-MM-DD
index_code  string    指数代码
index_name  string    指数名称
open        float
close       float
high        float
low         float
volume      float
amount      float
pct_chg     float
```

### macro_monthly（宏观月度）

**shibor_3m.csv**
```
date        string    YYYY-MM
shibor_3m   float     3个月期Shibor利率（%）
```

**usd_cny.csv**
```
date        string    YYYY-MM
usd_cny     float     人民币兑美元汇率（月末值）
```

**cpi_monthly.csv**
```
date        string    YYYY-MM
cpi_yoy     float     CPI同比增速（%）
```

### fin_annual（年度财务）

```
code        string    股票代码
name        string    股票简称
year        int       年份（2018-2023）
pe_ttm      float     市盈率TTM
pb          float     市净率
roe         float     净资产收益率（%）
total_revenue  float  营业收入（亿元）
net_profit     float  净利润（亿元）
total_assets   float  总资产（亿元）
debt_ratio     float  资产负债率（%）
```

### company_info（公司信息）

```
code        string    股票代码
name        string    股票简称
industry_l1 string    一级行业
industry_l2 string    二级行业
province    string    所在省份
list_date   string    上市日期
ownership   string    国企/民企
```

---

## Mini-dataset 规格

Mini-dataset 用于 Sec 1 和 Sec 3 的概念演示，字段名与上述真实数据完全一致，仅压缩为3只股票、少量行数。

**三只演示股票：** 000001（平安银行）、600519（贵州茅台）、300750（宁德时代）

**daily_mini：** 每只股票各3个交易日，共9行

**fin_annual_mini：** 每只股票2年（2022-2023），共6行

**company_info_mini：** 3行

---

## 数据质量预期

| 数据集 | 预期行数 | 可能的问题 |
|---|---|---|
| stock_daily（每只）| ~1,200行 | 个别股票上市时间晚于2020年，行数会少 |
| index_daily（每个）| ~1,240行 | 一般无问题 |
| shibor_3m | ~60行 | 按月聚合后约60行 |
| usd_cny | ~60行 | 同上 |
| cpi_monthly | ~60行 | 同上 |
| fin_annual | ≤60行 | 部分股票早年可能缺数据 |
| company_info | 10行 | 固定 |

缺失值在财务数据中较常见（新上市公司早年无数据），这些缺失在讲义 Sec 3 中可以作为"真实数据的现实"来讨论，呼应第三章数据清洗的内容。
