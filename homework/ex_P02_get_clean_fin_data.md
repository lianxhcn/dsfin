## P01：金融数据获取、管理与初步分析

> **作业性质**：个人作业  
> **对应讲义**：第 7 章（数据获取）、第 11 章（数据管理）、第 12 章（数据清洗）  
> **提交方式**：见文末「提交要求」

---

### 任务背景

数据是金融分析的起点。拿到数据之前，你需要知道数据在哪里、怎么获取；拿到之后，你需要知道怎么存放、怎么清洗、怎么合并。本次作业覆盖这三个环节，目标是建立一套完整、可复现的数据处理流程——而不只是跑通几行代码。

---

### 第一部分：数据获取

#### 1.1 自选 10 只股票

从 A 股市场自行选定 **10 只股票**，要求：

- 覆盖以下行业中的至少 **5 个**（每个行业至多 2 只）：
  银行、汽车、房地产、白酒、能源、通讯、物流
- 在 `README.md` 中列出股票代码、名称、行业，说明选股理由（1-2 句）

下载每只股票过去 5 年（2020-01-01 至今）的**后复权日度行情**，字段须包含：

`日期、开盘价、收盘价、最高价、最低价、成交量、成交额`

**数据来源可自行选择**，以下工具均可，选用一种即可，在 `README.md` 中注明：

| 工具 | 特点 | 参考接口 |
|------|------|---------|
| `akshare` | 免费，无需注册，覆盖广 | `ak.stock_zh_a_hist()` |
| `baostock` | 免费，需登录，数据稳定 | `bs.query_history_k_data_plus()` |
| `tushare` | 需注册获取 token，数据丰富 | `pro.daily()` |
| 其他 | 如 yfinance、本地 CSV 等 | — |

#### 1.2 市场指数

下载以下指数的日度数据（时间范围与股票数据一致）：

- **沪深 300**（000300）——作为后续 CAPM 分析的市场基准（必选）
- 自选另一个指数（如中证 500、创业板指、上证综指），说明选择理由

#### 1.3 宏观经济指标

下载至少 **2 项**月度宏观指标，要求：

- **必选**：CPI 同比增速
- **自选一项**：人民币/美元汇率、M2 同比增速、1 年期 LPR 利率、工业增加值增速等
- 在 `README.md` 中说明选择该指标的理由（它与股票市场有何关联？）

数据来源同样自由选择，可用 `akshare`（`ak.macro_china_cpi_yearly()`）、GMD、世界银行 API 等，须在 README 中注明来源。

#### 1.4 财务指标

获取 10 只股票最近 5 个年度的至少 **2 类**财务指标，推荐：

- 净资产收益率（ROE）
- 净利润率、资产负债率、营业收入增速等

将财务数据整理为**长格式**（Long format）：每行为一只股票一个年度的观测，字段包含 `code, year, indicator, value`。

#### 1.5 下载日志

编写下载函数时，需将每次下载的结果记录到 `download_log.txt`，格式如下：

```
[2025-05-01 10:23:45] SUCCESS  stock_000001  shape=(1200, 7)
[2025-05-01 10:23:48] SUCCESS  stock_600519  shape=(1198, 7)
[2025-05-01 10:23:51] FAILED   stock_999999  Error: No data returned
```

---

### 第二部分：数据存储与管理

#### 2.1 目录结构

按以下规范建立项目文件夹，**使用 Python 代码自动创建**（`os.makedirs`），不得手动新建：

```
dshw-p01/
├── README.md                    ← 项目说明（见 2.3 节要求）
├── report.html                  ← 分析报告（HTML 或 PDF，见第六部分）
├── requirements.txt             ← 依赖库列表
├── .gitignore
├── 01_download.ipynb            ← 数据下载
├── 02_clean.ipynb               ← 数据清洗
├── 03_analysis.ipynb            ← 描述统计与回归分析
├── data/
│   ├── stock/                   ← 个股行情原始数据（CSV）
│   │   ├── stock_000001.csv
│   │   └── ...
│   ├── index/                   ← 指数数据（CSV）
│   │   └── index_000300.csv
│   ├── macro/                   ← 宏观数据（CSV）
│   │   ├── macro_cpi.csv
│   │   └── macro_[自选指标].csv
│   ├── finance/                 ← 财务数据（CSV）
│   │   └── finance_ratios.csv
│   ├── clean/                   ← 清洗后数据
│   └── combined/                ← 合并后综合数据
├── output/                      ← 图形输出（PNG）
└── download_log.txt             ← 下载日志
```

文件命名规范：全部小写，用下划线分隔，不含空格和中文。

#### 2.2 数据存储格式

存储要求分为**基础**和**进阶**两层：

**基础要求（必做）：方式 A — CSV**

- 所有原始数据以 CSV 格式存储（如上述目录结构）
- 合并后的综合数据保存为 `data/combined/combined_data.csv`
- 在 `README.md` 中说明：CSV 格式有哪些优点，在什么情况下会力不从心？

**进阶要求（必做其中一种）：方式 B 或方式 C**

在完成方式 A 的基础上，从以下两种进阶格式中**选择一种**额外实现，并在 `README.md` 中说明选择理由。后续数据清洗和分析（第三、四、五部分）均**以方式 A 的 CSV 文件为主要数据源**；进阶格式用于展示对存储工具的掌握，并与 CSV 做对比说明。

---

**方式 B：Parquet**

将清洗后的数据额外保存一份 Parquet 格式，与 CSV 并存于 `data/clean/`：

```
data/clean/
├── stock_clean.csv         ← 方式 A（必做）
├── stock_clean.parquet     ← 方式 B（进阶，选做其一）
```

需在 `02_clean.ipynb` 中演示以下特性：

```python
import pandas as pd, pyarrow.parquet as pq, os, time

# 列式读取（只加载需要的列）
df = pd.read_parquet("data/clean/stock_clean.parquet",
                     columns=["date", "code", "close"])

# 查看 Schema（类型契约）
schema = pq.read_schema("data/clean/stock_clean.parquet")
print(schema)

# 与 CSV 对比：读取速度与文件体积
t0 = time.time()
pd.read_csv("data/clean/stock_clean.csv")
print(f"CSV  读取耗时: {time.time()-t0:.3f}s  "
      f"文件大小: {os.path.getsize('data/clean/stock_clean.csv')/1024:.1f} KB")

t0 = time.time()
pd.read_parquet("data/clean/stock_clean.parquet")
print(f"Parquet 读取耗时: {time.time()-t0:.3f}s  "
      f"文件大小: {os.path.getsize('data/clean/stock_clean.parquet')/1024:.1f} KB")
```

用文字回答：在本次数据规模下，两种格式的速度和体积差异是否明显？什么场景下差异会更显著？

---

**方式 C：SQLite**

将清洗后的数据额外存入 SQLite 数据库 `data/combined/fin_data.db`，设计合理的表结构（至少 3 张表）：

```sql
CREATE TABLE stock_price (
    code    TEXT,
    date    TEXT,
    close   REAL,
    volume  REAL,
    PRIMARY KEY (code, date)
);
CREATE TABLE macro_data (
    date      TEXT,
    indicator TEXT,
    value     REAL,
    PRIMARY KEY (date, indicator)
);
CREATE TABLE stock_info (
    code     TEXT PRIMARY KEY,
    name     TEXT,
    industry TEXT
);
```

需在 `02_clean.ipynb` 中演示以下操作：

```python
import sqlite3, pandas as pd

conn = sqlite3.connect("data/combined/fin_data.db")

# 跨表 JOIN：将股票行情与宏观数据按月份合并
query = """
SELECT p.date, p.code, p.close,
       m.value AS cpi
FROM stock_price p
LEFT JOIN macro_data m
       ON substr(p.date, 1, 7) = substr(m.date, 1, 7)
      AND m.indicator = 'cpi'
"""
df = pd.read_sql_query(query, conn)
```

在以上基础上，再写 **2 条有实际业务含义的 SQL 查询**，附上每条查询的用途说明（如：查询成交量排名前三的交易日，或筛选某行业股票的年均收盘价等）。

> **注意**：`fin_data.db` 文件不要上传 GitHub，在 `.gitignore` 中添加 `*.db`。在 `README.md` 中说明他人如何通过运行 Notebook 从头重建数据库。

#### 2.3 README.md 要求

`README.md` 须包含以下内容（可在此基础上扩展）：

```markdown
## P01：金融数据获取、管理与初步分析

### 股票列表
| 代码 | 名称 | 行业 | 选股理由 |
|------|------|------|---------|
| ...  | ...  | ...  | ...     |

### 数据来源
- 股票行情：[工具名称]，后复权，日度
- 市场指数：[说明]
- 宏观指标：[指标名称]，来源：[说明]，选择理由：[说明]
- 财务数据：[说明]

### 存储方式
- 基础：CSV（方式 A）
- 进阶：Parquet（方式 B）/ SQLite（方式 C）[二选一]
- 选择进阶方式的理由：……

### GitHub 仓库
https://github.com/[你的用户名]/dshw-p01

### 如何运行
1. 安装依赖：`pip install -r requirements.txt`
2. 运行 `01_download.ipynb` 下载原始数据
3. 运行 `02_clean.ipynb` 清洗并存储数据
4. 运行 `03_analysis.ipynb` 查看分析结果
5. 打开 `report.html` 阅读完整报告
```

---

### 第三部分：数据清洗

在 `02_clean.ipynb` 中，完成以下清洗步骤，**每步须有文字说明清洗前后的变化**（不能只有代码）：

#### 3.1 单表清洗（对每只股票的原始数据）

| 清洗项目 | 具体要求 |
|---------|---------|
| **缺失值检测** | 统计每列缺失值的数量和比例，制成表格；说明缺失的可能原因（停牌？节假日？数据源问题？） |
| **缺失值处理** | 向前填充（`ffill`）或删除，须说明选择依据 |
| **日期格式统一** | 确保所有表的日期列统一为 `datetime64` 格式，并设为索引 |
| **数据类型检查** | 确认价格、成交量列为数值型；若存在字符型需转换并记录 |
| **重复值处理** | 检测并删除重复行，记录删除数量 |
| **离群值标注** | 计算日收益率，对单日涨跌幅超过 ±20% 的记录，在新列 `is_extreme` 中标注为 `True`（不删除，但须说明可能成因） |

#### 3.2 宽表与长表转换

- 将 10 只股票的收盘价合并为**宽表**（日期为索引，每列一只股票）
- 再用 `pd.melt` 转换回**长表**，字段为 `date, code, close`
- 用文字回答：宽表适合什么样的操作？长表适合什么样的操作？

#### 3.3 多表合并

- 将个股日度数据与指数日度数据按日期做 `left join`
- 将月度宏观数据与日度数据合并（需处理频率不一致问题：将宏观数据映射到对应月份的每个交易日，或合并至月度收益率数据中）
- 记录每次合并前后的行数，说明行数变化的原因

---

### 第四部分：描述性统计与可视化

在 `03_analysis.ipynb` 中完成以下分析，**每张图后须有不少于 2 句的文字解读**：

#### 4.1 基本统计量

计算 10 只股票日收益率（$r_t = \ln(P_t / P_{t-1})$）的描述性统计，以表格形式呈现：

| 股票 | 行业 | 年化均值 | 年化波动率 | 偏度 | 峰度 | 最大回撤 |
|------|------|---------|----------|------|------|---------|
| ...  | ...  | ...     | ...      | ...  | ...  | ...     |

#### 4.2 可视化（图 1-4 必做，图 5 选做）

**图 1：归一化收盘价走势图**
- 10 只股票以 2020-01-01 = 1 为基准的归一化收盘价，叠加沪深 300
- 要求：图例按行业分组着色，有标题和坐标轴标签

**图 2：日收益率分布图**
- 10 只股票收益率分面直方图（2 行 × 5 列），每个子图叠加正态分布曲线
- 要求：每个子图标注均值和标准差

**图 3：收益率相关系数热力图**
- 10 只股票日收益率的相关系数矩阵热力图，标注具体数值
- 要求：按行业对股票排序；讨论同行业内相关性是否高于跨行业

**图 4：宏观指标与股市关系**
- 选 1 项宏观指标，绘制其与沪深 300 月度收益率的散点图，叠加线性拟合线
- 要求：标注 Pearson 相关系数，讨论关系方向和经济含义

**图 5（选做）：财务指标跨公司对比**
- 绘制 10 只股票最近 5 年 ROE 的折线图或分组箱型图，按行业分组
- 讨论不同行业 ROE 的水平与趋势差异

所有图形保存至 `output/`，格式 PNG，分辨率 ≥ 150 dpi。

---

### 第五部分：回归分析

#### 5.1 CAPM 模型估计

对 10 只股票分别估计 CAPM 模型：

$$r_{i,t} - r_f = \alpha_i + \beta_i (r_{m,t} - r_f) + \varepsilon_{i,t}$$

其中：
- $r_{i,t}$：个股日对数收益率
- $r_{m,t}$：沪深 300 日对数收益率
- $r_f$：无风险利率，统一设为年化 2.0%，日频换算：$r_f^{\text{daily}} = 0.02 / 252$

使用 `statsmodels.OLS` 估计，汇总结果为表格：

| 股票 | 行业 | $\hat{\alpha}$ | p 值 | $\hat{\beta}$ | 95% CI | $R^2$ |
|------|------|----------------|------|---------------|--------|-------|
| ...  | ...  | ...            | ...  | ...           | ...    | ...   |

**可视化**：绘制 Beta 系数点图，横轴为 Beta 值，纵轴为股票名称，误差棒表示 95% 置信区间，按行业分组着色，在 $\beta = 1$ 处画参考竖线。

**分析讨论**（必须用文字回答，不可只列数字）：
1. 哪些股票 $\hat{\beta} > 1$？它们属于哪些行业？这与"周期性 vs 防御性"行业分类是否吻合？
2. $\hat{\alpha}$ 是否显著异于零？Alpha 显著意味着什么？
3. $R^2$ 最高和最低的股票分别是哪只？你如何解释这一差异？

#### 5.2 宏观指标对股票收益率的影响（选做）

选 1 项宏观指标，以月度数据分析其对 10 只股票月度收益率的影响：

$$r_{i,t}^{\text{月}} = \alpha_i + \gamma_i \cdot X_t + \varepsilon_{i,t}$$

- 对 10 只股票分别估计，汇报 $\hat{\gamma}_i$ 及显著性
- 用分面图或点图展示 $\hat{\gamma}_i$，按行业分组着色
- 讨论：不同行业对该宏观指标的敏感性有何差异？背后的经济逻辑是什么？

---

### 第六部分：分析报告

除 Notebook 之外，须额外提交一份**独立的分析报告**，格式为 `.html` 或 `.pdf`，文件名为 `report.html`（或 `report.pdf`），放置于项目根目录。

由 Notebook 导出，或使用 `nbconvert` 生成：

```bash
# 从分析 Notebook 直接导出 HTML（推荐）
jupyter nbconvert --to html 03_analysis.ipynb --output report.html

# 或导出 PDF（需安装 LaTeX 或 Pandoc）
jupyter nbconvert --to pdf 03_analysis.ipynb --output report.pdf
```

**报告内容要求**：

- 包含完整流程：数据说明 → 清洗说明 → 统计结果 → 图表 → CAPM 结果 → 结论
- **每个分析模块须有用 Markdown 单元格写成的标题和解释文字**，不能全是代码块；代码可以保留，但不能喧宾夺主
- 报告须能独立阅读：不打开 Notebook，读者也能通过报告理解数据来源、方法和主要发现

> **建议**：在开始写代码前，先在 Notebook 中规划好 Markdown 单元格的结构（标题层级、分析说明位置），事后补文字往往质量更差。

---

### 加分项：Quarto Online Book 发布

> 本项为**选做加分项**，完成可获额外加分（+10 分）。

将本次作业整理为一本在线电子书，使用 VS Code + Quarto 渲染，发布至 GitHub Pages。

**参考教程**：[Lian-2025-Quarto book](https://lianxhcn.github.io/quarto_book/)

**具体要求**：

- 使用与提交仓库相同的 **`dshw-p01`** 仓库，在其中配置 Quarto 电子书
- 将 Notebook（`.ipynb`）或改写的 Quarto 文档（`.qmd`）渲染为 HTML 电子书
- 发布到 GitHub Pages，确保以下链接可公开访问：
  `https://[你的用户名].github.io/dshw-p01/`
- 电子书须有目录导航、各章节标题、图表和分析文字，排版整洁
- 在 `README.md` 中提供电子书链接

---

### 提交要求

本次作业须**同时完成以下两种提交方式**，缺一不可：

**① 坚果云压缩包**

- 将整个项目文件夹压缩为 `.zip`，命名格式：`P01_学号_姓名.zip`
  （例：`P01_20231001_张三.zip`）
- 上传至课程指定的坚果云共享文件夹

**② GitHub 仓库**

- 在个人 GitHub 账户下新建仓库，仓库名称固定为 **`dshw-p01`**（Public）
- 使用 **GitHub Desktop** 将本地项目同步至该仓库
- 将仓库地址写入 `README.md`（格式：`https://github.com/[用户名]/dshw-p01`）

**`.gitignore` 建议配置**：

```gitignore
# 原始数据（体积较大，通过运行 Notebook 重新下载）
data/stock/
data/index/
data/macro/
data/finance/

# 数据库文件
*.db

# Notebook 缓存
.ipynb_checkpoints/

# 系统文件
.DS_Store
__pycache__/
```

> `data/clean/` 和 `data/combined/` 中的清洗/合并后数据是否上传由你决定，但须在 `README.md` 中说明。

---

### 提交清单

提交前请逐项检查：

- [ ] 项目根目录名称为 `dshw-p01`，目录结构由 Python 代码自动创建
- [ ] `README.md` 完整，含股票列表、数据来源、存储方式说明、GitHub 仓库链接、运行步骤
- [ ] `download_log.txt` 存在，记录所有数据的下载状态
- [ ] 3 个 Notebook 均可从头到尾完整运行，无报错
- [ ] 方式 A（CSV）已完成；方式 B 或 C 至少完成一种，并有对比说明
- [ ] 数据清洗 6 个步骤均完成，每步有文字说明
- [ ] 图 1-4 均已完成，保存至 `output/`，每图有文字解读
- [ ] CAPM 回归表格存在，三个讨论问题均有文字回答
- [ ] `report.html`（或 `.pdf`）存在于根目录，可独立阅读
- [ ] GitHub 仓库已创建并同步，仓库地址已写入 `README.md`
- [ ] `.gitignore` 配置正确
- [ ] （加分）GitHub Pages 链接可访问，已写入 `README.md`

---

### 评分标准

| 维度 | 分值 | 说明 |
|------|------|------|
| 数据获取的完整性 | 15 分 | 四类数据齐全，下载日志规范，数据来源说明清晰 |
| 目录结构与存储规范 | 15 分 | 命名规范，方式 A + B/C 均完成，选择理由有说明 |
| 数据清洗的规范性 | 25 分 | 6 个步骤完整，有前后对比说明，文字清晰 |
| 可视化质量 | 20 分 | 图形规范，每图有实质性文字解读 |
| 回归分析与讨论 | 15 分 | CAPM 结果正确，三个讨论问题有实质回答 |
| 分析报告质量 | 10 分 | 可独立阅读，结构清晰，文字与图表配合得当 |
| **加分项** | **+10 分** | Quarto 电子书发布至 GitHub Pages，排版整洁 |

> **核心提示**：代码能跑通是基本要求，分析文字的质量决定上限。图后的文字解读、CAPM 三个讨论问题，是评分最能拉开差距的地方。
