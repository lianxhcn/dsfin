# 阶段 3：讲义写作规格

## 目标

生成 `data_store_manage.ipynb`，内容完整、代码可运行、风格与第一章第三章一致。

---

## 讲义结构总览

```
# 数据管理与组织

导语
本章导读（三个意识：粒度、主键、复用）

## Sec 1  数据表、主键与粒度            ← 来自 ChatGPT 初稿，用 mini-dataset
## Sec 2  存储格式的选择                ← CSV / Parquet / SQLite / DuckDB 对比
## Sec 3  用 SQLite 管理金融数据        ← mini-dataset 建库 → 真实数据实战
## Sec 4  SQL 核心操作                  ← pandas 对照表 + 真实数据查询
## Sec 5  大数据量：DuckDB + Parquet    ← 性能基准测试
## Sec 6  数据管理规范                  ← 目录结构、命名、元数据
```

---

## 各节详细规格

---

### 导语

参考第一章导语风格：2-3段，点出"数据堆积的困境"，引出本章主线。

**建议切入点：** 用 `data_raw/` 目录里已有的文件数量作为开场——"你已经有了 XX 个 CSV 文件，这一章要解决的问题是：如何把它们管好。"

**本章主线公式（参考 ChatGPT 初稿，保留）：**
$$\text{source files / APIs} \rightarrow \text{storage \& organization} \rightarrow \text{cleaning} \rightarrow \text{analysis}$$

---

### 本章导读

三个核心意识（来自 ChatGPT 初稿，保留这个框架）：

- **粒度意识**：每张表的每一行代表什么？
- **主键意识**：什么变量组合能唯一识别一行？
- **复用意识**：如何让数据组织支撑长期项目？

配一个本章数据集说明表：

| 数据集 | 文件 | 粒度 | 主键 | 行数（运行后填入实际值）|
|---|---|---|---|---|
| 个股日度 | stock_daily/*.csv | firm-date | code+date | ~12,000 |
| 市场指数 | index_daily/*.csv | index-date | index_code+date | ~3,700 |
| 宏观月度 | macro_monthly/*.csv | date | date | ~60/指标 |
| 年度财务 | fin_annual/fin_indicators.csv | firm-year | code+year | ~60 |
| 公司信息 | company_info.csv | firm | code | 10 |

---

### Sec 1  数据表、主键与粒度

**来源：** 主要改写自 ChatGPT 初稿的 Sec 2（Cell 4-9），但代码部分改用与真实数据结构一致的 mini-dataset。

**Mini-dataset 定义（在代码中手动构造，3只股票）：**

```python
import pandas as pd

# ── Mini-dataset：3只股票，结构与 data_raw/ 完全一致 ──
# 公司信息表（粒度：firm，主键：code）
company_info_mini = pd.DataFrame({
    'code':       ['000001', '600519', '300750'],
    'name':       ['平安银行', '贵州茅台', '宁德时代'],
    'industry_l1':['金融',    '消费',    '制造'],
    'ownership':  ['国企',    '民企',    '民企'],
})

# 年度财务表（粒度：firm-year，主键：code+year）
fin_annual_mini = pd.DataFrame({
    'code': ['000001','000001','600519','600519','300750','300750'],
    'year': [2022, 2023, 2022, 2023, 2022, 2023],
    'roe':  [0.098, 0.105, 0.315, 0.298, 0.228, 0.193],
    'pe_ttm':[5.2,  5.8,   28.4,  24.1,  35.6,  22.3],
})

# 个股日度表（粒度：firm-date，主键：code+date）
# 仅构造 6 行用于演示
daily_mini = pd.DataFrame({
    'code':  ['000001']*3 + ['600519']*3,
    'date':  ['2024-01-02','2024-01-03','2024-01-04']*2,
    'close': [10.2, 10.5, 10.3, 1680.0, 1695.0, 1702.0],
    'pct_chg':[-0.5, 2.9, -1.9, 0.3, 0.9, 0.4],
    'turnover':[0.8, 1.2, 0.9, 0.2, 0.3, 0.2],
})
daily_mini['date'] = pd.to_datetime(daily_mini['date'])
```

**注意：** 字段名与 `data_raw/` 中的真实 CSV 完全一致，方便后续代码直接复用。

**演示内容（按顺序）：**

1. 展示三张表，说明粒度的概念
2. 检查主键唯一性（`duplicated()` 方法）
3. **"粒度错误"演示**：只按 `code` 合并 firm-year 和 firm-date，观察行数膨胀——这是 ChatGPT 初稿最好的部分，完整保留
4. **"正确做法"**：先把日度数据聚合到 firm-year（年均换手率、年波动率），再 merge

---

### Sec 2  存储格式的选择

**核心内容：** 四种格式的对比，用真实数据（`000001.csv`）做速度和体积测试。

**格式对比表（先给出，后用代码验证）：**

| 格式 | 适合场景 | 不适合场景 | 备注 |
|---|---|---|---|
| CSV | 分享、查看、小数据 | 大文件、频繁读写 | 无类型信息 |
| Parquet | 大表、重复读取、分析 | 人工查看 | 列式存储 |
| SQLite | 多表关联、反复查询 | 大并发写入 | 单文件数据库 |
| DuckDB | 超大量分析查询 | 事务型操作 | 直接查 Parquet |

**代码演示（用平安银行 5 年日度数据）：**

```python
import pandas as pd
import time
from pathlib import Path

csv_path = Path("data_raw/stock_daily/000001.csv")
parquet_path = Path("data_raw/stock_daily/000001.parquet")

# 先保存为 Parquet
df = pd.read_csv(csv_path)
df.to_parquet(parquet_path, index=False)

# 对比文件大小
csv_size = csv_path.stat().st_size / 1024
pq_size  = parquet_path.stat().st_size / 1024
print(f"CSV 大小：   {csv_size:.1f} KB")
print(f"Parquet 大小：{pq_size:.1f} KB")
print(f"压缩比：     {csv_size/pq_size:.1f}x")

# 对比读取速度（各读 20 次取均值）
import timeit
t_csv = timeit.timeit(lambda: pd.read_csv(csv_path), number=20) / 20
t_pq  = timeit.timeit(lambda: pd.read_parquet(parquet_path), number=20) / 20
print(f"\nCSV 平均读取：    {t_csv*1000:.1f} ms")
print(f"Parquet 平均读取：{t_pq*1000:.1f} ms")
print(f"速度提升：        {t_csv/t_pq:.1f}x")
```

**注意：** 具体数字（压缩比、速度提升）在运行后填入讲义，不要用假设值。

---

### Sec 3  用 SQLite 管理金融数据

**节奏：mini-dataset 建库 → 真实数据实战**

#### Part A：mini-dataset 建库（理解语法）

```python
import sqlite3
import pandas as pd

# 在内存中建库（演示用，不写磁盘）
conn_mini = sqlite3.connect(":memory:")

# 写入三张 mini 表
company_info_mini.to_sql('company_info', conn_mini, if_exists='replace', index=False)
fin_annual_mini.to_sql('fin_annual',    conn_mini, if_exists='replace', index=False)
daily_mini.to_sql('daily',              conn_mini, if_exists='replace', index=False)

# 查看数据库中有哪些表
tables = pd.read_sql("SELECT name FROM sqlite_master WHERE type='table'", conn_mini)
print(tables)
```

演示 3 个基本操作（每个配中文注释）：
1. 查询单表：SELECT + WHERE + ORDER BY
2. 聚合：GROUP BY + HAVING
3. 多表 JOIN（company_info ✕ fin_annual）

#### Part B：真实数据建库

```python
# 建立持久化数据库文件
conn = sqlite3.connect("data_raw/finance.db")

# 读入全部10只股票，合并写入 stock_daily 表
import glob
dfs = []
for f in glob.glob("data_raw/stock_daily/*.csv"):
    dfs.append(pd.read_csv(f))
df_all = pd.concat(dfs, ignore_index=True)
df_all.to_sql('stock_daily', conn, if_exists='replace', index=False)

# 同样写入其他表...
# company_info, fin_annual, index_daily, macro_monthly

print(f"stock_daily 表：{len(df_all):,} 行")
```

**"替代 concat 的真实价值"演示：**
```python
# 旧做法：每次分析都要先 concat 10 个文件
# 新做法：一条 SQL，直接查

query = """
SELECT code, COUNT(*) as days, 
       MIN(date) as start, MAX(date) as end,
       ROUND(AVG(pct_chg), 4) as avg_ret
FROM stock_daily
GROUP BY code
ORDER BY avg_ret DESC
"""
pd.read_sql(query, conn)
```

---

### Sec 4  SQL 核心操作

**开头放 pandas ↔ SQL 对照表**（这是这一章最有价值的学习工具）：

| 操作 | pandas 写法 | SQL 写法 |
|---|---|---|
| 筛选行 | `df[df['pe_ttm'] < 20]` | `WHERE pe_ttm < 20` |
| 选列 | `df[['code','roe']]` | `SELECT code, roe` |
| 排序 | `df.sort_values('roe', ascending=False)` | `ORDER BY roe DESC` |
| 取前N行 | `df.nlargest(10, 'roe')` | `ORDER BY roe DESC LIMIT 10` |
| 分组均值 | `df.groupby('industry_l1')['roe'].mean()` | `GROUP BY industry_l1` |
| 多表合并 | `pd.merge(df1, df2, on='code')` | `JOIN ... ON code` |
| 新建列 | `df['ret_annual'] = df['pct_chg'] * 252` | `pct_chg * 252 AS ret_annual` |

**然后用真实数据演示以下 4 个查询，每个都有实际分析意义：**

**查询 1：各行业平均 ROE（2023年）**
```sql
SELECT c.industry_l1, 
       COUNT(*) as n_firms,
       ROUND(AVG(f.roe), 4) as avg_roe
FROM fin_annual f
JOIN company_info c ON f.code = c.code
WHERE f.year = 2023
GROUP BY c.industry_l1
ORDER BY avg_roe DESC
```

**查询 2：找出 2023 年日均成交量最大的 5 个交易日（各股票）**
```sql
SELECT code, date, volume,
       RANK() OVER (PARTITION BY code ORDER BY volume DESC) as vol_rank
FROM stock_daily
WHERE date LIKE '2023%'
QUALIFY vol_rank <= 5
```

**查询 3：日度行情 × 公司信息（混频对照）**
```sql
SELECT s.date, s.code, c.name, c.industry_l1, 
       s.close, s.pct_chg
FROM stock_daily s
JOIN company_info c ON s.code = c.code
WHERE s.date >= '2024-01-01'
  AND c.ownership = '国企'
ORDER BY s.date, s.pct_chg
```

**查询 4：把日度数据聚合为年度，与财务数据合并**
```sql
SELECT f.code, f.year, f.roe, f.pe_ttm,
       r.avg_ret, r.volatility
FROM fin_annual f
JOIN (
    SELECT code,
           STRFTIME('%Y', date) AS year,
           ROUND(AVG(pct_chg), 4)  AS avg_ret,
           ROUND(AVG(ABS(pct_chg)),4) AS volatility
    FROM stock_daily
    GROUP BY code, STRFTIME('%Y', date)
) r ON f.code = r.code AND f.year = CAST(r.year AS INTEGER)
ORDER BY f.year, f.code
```

**每个查询后用 `pd.read_sql(query, conn)` 展示结果。**

**"何时用 SQL，何时用 pandas"判断框架：**
（来自 ChatGPT 初稿 Cell 16，内容好，可以整合）

---

### Sec 5  大数据量：DuckDB + Parquet

**先把所有10只股票保存为 Parquet：**
```python
import duckdb
df_all.to_parquet("data_raw/stock_daily/all_stocks.parquet", index=False)
```

**性能基准测试（这是重点，数字要真实）：**
```python
import timeit

# 任务：计算每只股票 2023 年的平均日收益率
# 方法1：循环读 CSV + pandas
def method_csv():
    dfs = [pd.read_csv(f) for f in glob.glob("data_raw/stock_daily/*.csv")]
    df = pd.concat(dfs)
    return df[df['date'].str.startswith('2023')].groupby('code')['pct_chg'].mean()

# 方法2：SQLite
def method_sqlite():
    return pd.read_sql(
        "SELECT code, AVG(pct_chg) FROM stock_daily WHERE date LIKE '2023%' GROUP BY code",
        conn
    )

# 方法3：DuckDB + Parquet
def method_duckdb():
    return duckdb.query("""
        SELECT code, AVG(pct_chg) 
        FROM 'data_raw/stock_daily/all_stocks.parquet'
        WHERE date LIKE '2023%'
        GROUP BY code
    """).df()

t1 = timeit.timeit(method_csv,    number=10) / 10
t2 = timeit.timeit(method_sqlite, number=10) / 10
t3 = timeit.timeit(method_duckdb, number=10) / 10

print(f"方法1（CSV + pandas）：  {t1*1000:.1f} ms")
print(f"方法2（SQLite）：        {t2*1000:.1f} ms")
print(f"方法3（DuckDB + Parquet）：{t3*1000:.1f} ms")
```

**在讲义中填入真实数字，不要写"约XXms"。**

**DuckDB 的额外展示：直接 SQL 查 Parquet，不需要导入：**
```python
result = duckdb.query("""
    SELECT code, COUNT(*) as days
    FROM 'data_raw/stock_daily/all_stocks.parquet'
    GROUP BY code
""").df()
```

---

### Sec 6  数据管理规范

**内容精简，实用为主，不超过 3 个 Code Cell。**

1. **目录结构规范**（文字+代码创建目录）：参考 ChatGPT 初稿 Cell 10-11，但目录名改为金融项目专属版
2. **文件命名规范**：参考 ChatGPT 初稿 Cell 12，给出命名模板
3. **元数据记录**：用 `download_log.txt` 作为真实案例，展示如何读取并汇总

**机构环境简介（文字，不要求代码）：** 简短提及 MySQL/PostgreSQL、数据中台的概念，让学生知道这章的技能是升级版工具链的入口，而不是终点。

---

### AI 提示词模板

每节末尾一个，重点在 Sec 3 和 Sec 4：

**Sec 3 提示词：**
> 我有一个 SQLite 数据库，包含以下表：
> - `stock_daily`：字段 code, date, close, pct_chg, volume, turnover；主键 (code, date)；约 12,000 行
> - `company_info`：字段 code, name, industry_l1, ownership；主键 code；10行
> - `fin_annual`：字段 code, year, roe, pe_ttm；主键 (code, year)；约 60 行
>
> 请帮我写一个 SQL 查询：找出 2022-2023 年间，ROE 连续两年超过 15% 的股票，输出股票代码、名称、行业、两年的 ROE 值。结果按 2023 年 ROE 降序排列。

**Sec 4 提示词：**
> 我用 DuckDB 直接查询一个 Parquet 文件（路径：`data_raw/stock_daily/all_stocks.parquet`），字段包括 code, date, close, pct_chg, volume。请帮我写查询，计算每只股票 2023 年的年化波动率（用日收益率标准差 × √252），并按波动率降序排列，用 Python 代码调用 duckdb.query() 执行并返回 DataFrame。

---

## 写作注意事项

1. **代码注释全部用中文**，风格参考 `context-lecture-style.md`
2. **每节至少有一个 callout-tip 或 callout-note**（quarto 格式）
3. **数字不要硬编码**：行数、时间范围、速度等在代码运行后用变量打印，不要写死在文字里
4. **mini-dataset 和真实数据的过渡要自然**，加一句过渡语："以上用3只股票演示了基本操作。下面我们把同样的逻辑应用到完整的10只股票数据上。"
5. **本章篇幅控制**：参考第一章（49个cell），本章目标 40-55 个 cell

---

## 阶段 3 自检

- [ ] 所有 6 节（导语+1-5）均已完成
- [ ] mini-dataset 字段名与真实数据一致
- [ ] pandas ↔ SQL 对照表已包含
- [ ] 性能基准测试已运行，数字为真实值
- [ ] 每节末尾有 AI 提示词模板
- [ ] 全部 code cell 可从头到尾顺序运行无报错

全部通过后，进入阶段 4。
