## 数据获取进阶：API 调用与 SQLite 数据库管理

### 任务背景

在实际的金融数据研究中，数据往往不是"一次下载、直接使用"，而是需要通过 API 定期获取、存入数据库、再按需查询分析。本题要求你掌握两项核心技能：一是**直接调用数据 API**（而非依赖封装好的 akshare），二是**用 SQLite 建立本地数据库**，实现数据的持久化存储与 SQL 查询分析。

---

### 数据来源

**必做：FRED API（美联储经济数据库）**

FRED（https://fred.stlouisfed.org）提供免费 API，覆盖宏观、利率、汇率、大宗商品等数万个序列。

- 注册账号并申请免费 API Key：https://fred.stlouisfed.org/docs/api/api_key.html
- API 文档：https://fred.stlouisfed.org/docs/api/fred/

调用示例：
```python
import requests

API_KEY = "your_api_key_here"
BASE_URL = "https://api.stlouisfed.org/fred/series/observations"

params = {
    "series_id": "DGS10",        # 美国 10 年期国债收益率
    "api_key": API_KEY,
    "file_type": "json",
    "observation_start": "2000-01-01",
}
response = requests.get(BASE_URL, params=params)
data = response.json()
```

**必做：tushare 或 baostock API（A 股数据）**

选择以下之一：
- **tushare**（需注册获取 token）：https://tushare.pro/document/2
- **baostock**（免费，无需注册）：`pip install baostock`

```python
# baostock 示例
import baostock as bs
lg = bs.login()
rs = bs.query_history_k_data_plus(
    "sh.000300",
    "date,close,volume",
    start_date="2015-01-01",
    frequency="d", adjustflag="3"
)
```

**选做：Wind API / Tushare Pro 高级接口**（如有校园账号）

---

### 分析任务

#### 必做部分

**1. 通过 FRED API 获取宏观数据**

调用 FRED API 获取以下序列，时间范围 2000 年至今，频率为月度：

| Series ID | 指标名称 |
|-----------|---------|
| `DGS10` | 美国 10 年期国债收益率 |
| `DGS2` | 美国 2 年期国债收益率 |
| `FEDFUNDS` | 联邦基金利率 |
| `CPIAUCSL` | 美国 CPI（未季调） |
| `UNRATE` | 美国失业率 |
| `DEXCHUS` | 人民币/美元汇率 |

要求：
- 编写通用的 API 请求函数，支持传入任意 Series ID 和时间范围
- 将所有序列合并为一个宽格式 DataFrame（以日期为索引）
- 处理缺失值，说明处理策略

**2. 通过 A 股 API 获取行情数据**

使用 tushare 或 baostock 获取以下数据：
- 沪深 300 指数日度行情（2010 年至今）
- 自选 10 只股票的日度行情（同时间范围）
- 各股票的基本信息（上市日期、行业分类、总市值）

要求：
- 编写批量下载函数，支持传入股票代码列表，自动处理频率限制（加入 `time.sleep()`）
- 记录每只股票的下载状态（成功/失败），对失败的股票重试

**3. 建立 SQLite 数据库**

使用 `sqlite3` 或 `sqlalchemy` 建立本地数据库，文件名为 `fin_data.db`，包含以下表结构：

```sql
-- 宏观数据表
CREATE TABLE macro_data (
    date        TEXT NOT NULL,
    series_id   TEXT NOT NULL,
    value       REAL,
    PRIMARY KEY (date, series_id)
);

-- 股票行情表
CREATE TABLE stock_price (
    code        TEXT NOT NULL,
    date        TEXT NOT NULL,
    open        REAL,
    high        REAL,
    low         REAL,
    close       REAL,
    volume      REAL,
    adj_close   REAL,
    PRIMARY KEY (code, date)
);

-- 股票基本信息表
CREATE TABLE stock_info (
    code        TEXT PRIMARY KEY,
    name        TEXT,
    industry    TEXT,
    list_date   TEXT,
    market_cap  REAL
);
```

- 将任务 1 和任务 2 下载的数据写入对应数据表
- 编写数据更新函数：检测数据库中最新日期，只下载增量数据（而非每次全量下载）

**4. SQL 查询分析**

使用 SQL（通过 `pandas.read_sql_query` 执行）完成以下查询，将结果输出为 DataFrame 并可视化：

```sql
-- 查询 1：计算美国收益率曲线利差（10Y - 2Y）的月度时序
SELECT date,
       MAX(CASE WHEN series_id='DGS10' THEN value END) -
       MAX(CASE WHEN series_id='DGS2'  THEN value END) AS spread_10_2
FROM macro_data
GROUP BY date
ORDER BY date;

-- 查询 2：计算每只股票的年度平均收盘价和总成交量
SELECT code, substr(date,1,4) AS year,
       AVG(adj_close) AS avg_close,
       SUM(volume)    AS total_volume
FROM stock_price
GROUP BY code, year
ORDER BY code, year;

-- 查询 3：筛选出特定行业中，上市超过 10 年的股票
SELECT s.code, s.name, s.industry, s.list_date
FROM stock_info s
WHERE s.industry = '银行'
  AND (julianday('now') - julianday(s.list_date)) / 365.0 > 10;
```

- 在以上基础上，**自行设计 2 个有实际分析意义的 SQL 查询**，说明查询目的并可视化结果

**5. 数据库 + 分析的完整流程演示**

将以上步骤串联为一个完整的分析案例，以"美联储加息周期对人民币汇率的影响"为主题（也可自选）：

- 从数据库中查询联邦基金利率和人民币/美元汇率
- 识别加息周期（利率连续上升的时间段）
- 绘制加息周期与汇率走势的对比图
- 计算加息期间和降息期间汇率的平均变动幅度

#### 选做部分

**6. 数据库自动更新脚本**

编写一个独立的 Python 脚本 `update_db.py`：
- 自动检测数据库中各表的最新日期
- 调用 API 下载增量数据
- 写入数据库，记录更新日志（更新时间、新增记录数）
- 在 README 中说明如何通过 cron（Linux/Mac）或任务计划程序（Windows）定期运行此脚本

**7. 数据质量检验**

- 对数据库中的行情数据进行质量检验：
  - 检测价格异常（单日涨跌幅超过 20% 的记录，排除一字板）
  - 检测交易量异常（成交量为 0 的交易日，可能为停牌）
  - 检测日期连续性（是否存在非节假日的缺失交易日）
- 将检测结果写入 `data_quality` 表，供后续分析时参考

---

### 项目结构要求

```
topic10_api_database/
├── README.md                        # API 申请说明、数据库结构说明、查询说明
├── 01_api_download.ipynb            # FRED + A 股 API 数据获取
├── 02_database_setup.ipynb          # SQLite 数据库建立与写入
├── 03_sql_analysis.ipynb            # SQL 查询与可视化分析
├── update_db.py                     # 数据库更新脚本（选做）
├── fin_data.db                      # SQLite 数据库文件（勿上传 GitHub！）
└── output/
```

**注意**：`fin_data.db` 文件体积较大，**不要上传到 GitHub**。在 `.gitignore` 中添加 `*.db`，在 README 中说明如何从头重建数据库。

---

### 提交要求

- 提交 GitHub 仓库链接（新建 `topic10/` 子文件夹）
- API Key 不能出现在代码中，改用环境变量或配置文件（在 `.gitignore` 中排除）：
  ```python
  import os
  API_KEY = os.environ.get("FRED_API_KEY")
  # 或从 config.ini 读取，config.ini 加入 .gitignore
  ```
- 所有 Notebook 需完整运行（可将 API 请求结果缓存为本地 CSV，避免每次重新请求）
- SQL 查询部分需有清晰的注释，说明每个查询的业务含义
