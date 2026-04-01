# 阶段 2：数据下载规格

## 目标

生成并运行 `codes_get_data.ipynb`，将所有数据下载到 `data_raw/` 目录，并写入下载日志。

---

## 总体要求

- 每个数据集下载前先检查文件是否已存在，存在则跳过（避免重复下载）
- 每次 akshare 调用之间 `time.sleep(0.8)`，避免触发限频
- 所有下载操作用 `try/except` 包裹，失败时记录日志并继续
- 每个数据集下载完成后，打印摘要（行数、时间范围、文件大小）
- 所有摘要信息同步写入 `data_raw/download_log.txt`

---

## 数据集 A：10只个股日度行情

**存放路径：** `data_raw/stock_daily/{code}.csv`

**股票列表：**

```python
stocks = {
    "000001": "平安银行",   # 银行
    "000002": "万科A",      # 房地产
    "600519": "贵州茅台",   # 白酒
    "300750": "宁德时代",   # 新能源
    "601318": "中国平安",   # 保险
    "002594": "比亚迪",     # 汽车
    "600036": "招商银行",   # 银行
    "601012": "隆基绿能",   # 光伏
    "000333": "美的集团",   # 家电
    "600276": "恒瑞医药",   # 医药
}
```

**参数：**
- 时间范围：`start_date="20200101"`，`end_date="20260330"`
- 复权方式：`adjust="hfq"`（后复权）
- 周期：`period="daily"`

**主要接口：**
```python
import akshare as ak
df = ak.stock_zh_a_hist(
    symbol=code, period="daily",
    start_date="20200101", end_date="20260330",
    adjust="hfq"
)
```

**字段重命名（统一为英文，方便后续 SQL）：**
```python
df.columns = ['date','open','close','high','low','volume','amount','amplitude','pct_chg','chg','turnover']
df['code'] = code
df['name'] = name
```

**备用接口（akshare 失败时）：**
```python
import baostock as bs
lg = bs.login()
rs = bs.query_history_k_data_plus(
    f"sz.{code}" if code.startswith("0") or code.startswith("3") else f"sh.{code}",
    "date,open,high,low,close,volume,amount,turn",
    start_date="2020-01-01", end_date="2026-03-30",
    frequency="d", adjustflag="1"
)
df = rs.get_data()
bs.logout()
```

**预期结果：**
- 每只股票约 1200 行（2020-2026 交易日）
- 10 个 CSV 文件，每个约 100-200 KB

---

## 数据集 B1：市场指数日度

**存放路径：** `data_raw/index_daily/{index_code}.csv`

**指数列表：**
```python
indices = {
    "000300": "沪深300",
    "000001": "上证综指",
    "399001": "深证成指",
}
```

**接口：**
```python
df = ak.index_zh_a_hist(
    symbol=code, period="daily",
    start_date="20200101", end_date="20260330"
)
```

**字段重命名：**
```python
df.columns = ['date','open','close','high','low','volume','amount','amplitude','pct_chg','chg','turnover']
df['index_code'] = code
df['index_name'] = name
```

---

## 数据集 B2：宏观月度数据

**存放路径：** `data_raw/macro_monthly/`

### Shibor 利率（3个月期）
```
文件名：shibor_3m.csv
接口：ak.rate_interbank(market="上海银行同业拆借市场", symbol="Shibor人民币", indicator="3月")
字段重命名：{'报告日': 'date', '利率': 'shibor_3m'}
时间范围：筛选 2020-01-01 之后
```

### 人民币兑美元汇率
```
文件名：usd_cny.csv
接口：ak.currency_hist(symbol="USDCNY")  
字段重命名：{'日期': 'date', '收盘': 'usd_cny'}
时间范围：筛选 2020-01-01 之后，按月取最后一个交易日
```

### CPI（月度）
```
文件名：cpi_monthly.csv
接口：ak.macro_china_cpi_monthly()
字段重命名：{'月份': 'date', '全国-当月': 'cpi_yoy'}
时间范围：筛选 2020-01 之后
```

**注意：** 以上三个文件的 `date` 列格式可能不统一，下载后统一转换为 `YYYY-MM` 格式（月度数据取月份即可）。

---

## 数据集 C：个股年度财务指标

**存放路径：** `data_raw/fin_annual/fin_indicators.csv`

**接口（循环10只股票）：**
```python
df = ak.stock_a_indicator_lg(symbol=code)
# 筛选 2018-2023 年数据
# 保留字段：pe_ttm, pb, ps_ttm, roe, total_revenue, net_profit
```

**备用接口：**
```python
df = ak.stock_financial_abstract_ths(symbol=code, indicator="按年度")
```

**最终字段：**
```
code, name, year, pe_ttm, pb, roe, total_revenue, net_profit, total_assets, debt_ratio
```

**主键：** `(code, year)`，写入前验证无重复

---

## 数据集 D：公司基本信息

**存放路径：** `data_raw/company_info.csv`

**接口（循环10只股票）：**
```python
df = ak.stock_individual_info_em(symbol=code)
# 返回的是 key-value 格式，需要转置
```

**最终字段：**
```
code, name, industry_l1, industry_l2, province, list_date, ownership
```

其中 `ownership` 为国企/民企（从实控人字段推断：含"国资"/"国有"为国企，否则为民企）

**主键：** `code`，每只股票一行，共10行

---

## 下载日志格式

每个数据集下载完成后，向 `download_log.txt` 追加写入：

```
[2025-01-15 10:23:45] ✓ stock_daily/000001.csv  
    行数：1243  时间范围：2020-01-02 ~ 2026-03-30  文件大小：187 KB

[2025-01-15 10:24:12] ✗ stock_daily/300750.csv  
    错误：akshare 接口超时，已切换 baostock 重试
    重试结果：✓  行数：1089  时间范围：2020-01-02 ~ 2026-03-30
```

---

## 数据健康检查（所有下载完成后运行）

生成一个汇总表并打印：

```python
# 检查每个 CSV 的行数、时间范围、是否有缺失值
# 格式示例：
# 数据集          文件数   总行数   时间范围                缺失值
# stock_daily      10      12,431   2020-01-02~2026-03-30   0
# index_daily       3       3,729   2020-01-02~2026-03-30   0
# macro_monthly     3         180   2020-01~2026-03          5
# fin_annual        1         ≤60   2018~2024               -
# company_info      1          10   —                        0
```

---

## 阶段 2 自检

- [ ] `data_raw/stock_daily/` 下有 ≥ 8 个 CSV（允许最多2只下载失败）
- [ ] `data_raw/index_daily/` 下有 3 个 CSV
- [ ] `data_raw/macro_monthly/` 下有 3 个 CSV
- [ ] `data_raw/fin_annual/fin_indicators.csv` 存在且行数 > 0
- [ ] `data_raw/company_info.csv` 存在且有10行
- [ ] `download_log.txt` 记录了所有下载结果
- [ ] 健康检查汇总表已打印

全部通过后，进入阶段 3。
