## 金融数据看板：从数据获取到交互式可视化

> **作业性质**：小组作业（建议 3-4 人）  
> **完成时间**：两周  
> **工具**：Python + Plotly + Quarto Book + GitHub Pages  
> **提交方式**：GitHub 仓库链接（含 GitHub Pages 网址）

---

## Part 1：讲义部分（必须完成，内容将用于后续课程）

> **说明**：本部分要求小组以"讲义"而非"作业报告"的风格撰写，内容须清晰、准确、可供他人学习使用。写作质量直接影响评分，且优秀的内容可能被收录为课程正式讲义。

### 1.1 什么是数据看板（Dashboard）

请在 Quarto Book 的对应章节中，用自己的语言回答以下问题（每个问题 200-400 字，配合 1-2 张图或截图说明）：

**① 数据看板是什么？**

从以下角度展开：

- 核心定义：看板是将多个相关数据可视化组件组织在同一界面的信息呈现形式
- 与普通图表的区别：单图 vs 多图联动；静态 vs 动态；报告 vs 监控
- 金融领域的典型应用场景：Bloomberg Terminal、Wind 资讯、交易所实时行情大屏、基金公司风控看板

举一个你能找到的真实金融看板截图（注明来源），指出其包含哪些组件、布局如何安排、服务于什么决策需求。

**② 好的看板具备哪些特征？**

结合以下维度展开讨论：

- **信息密度**：在有限空间内传递足够信息，但避免视觉过载
- **层次感**：核心指标突出显示（KPI cards），细节支撑信息次之
- **交互性**：允许用户按需筛选、缩放、钻取，而非强迫一次看完所有内容
- **时效性**：数据多新？如何让用户感知数据的更新时间？
- **受众适配**：同一份数据，管理层看板 vs 分析师看板的设计逻辑有何不同？

可参考文献：[Storytelling with Data](https://www.storytellingwithdata.com)、Edward Tufte 的数据-墨水比（Data-Ink Ratio）概念。

> 📝
> Stephen Few（2006）在 *Information Dashboard Design* 中总结了看板设计的核心原则，包括：避免过度使用颜色、禁用三维饼图、保持视觉一致性等。原文摘要可在以下链接获取：<https://www.perceptualedge.com>

---

### 1.2 Python 中的看板实现工具

请撰写一份工具介绍，覆盖以下内容：

**① 工具全景图（一张对比表）**

在你的 Quarto 文档中插入如下对比表，并在表格下方用 2-3 段文字说明各工具的核心适用场景：

| 工具 | 类型 | 交互性 | 部署方式 | 学习曲线 | 典型用途 |
|------|------|--------|---------|---------|---------|
| `matplotlib` | 静态绘图 | 无 | 图片/PDF | 低 | 论文插图 |
| `plotly` | 交互绘图 | 高（悬停、缩放、筛选） | HTML / Notebook | 低-中 | 报告、看板组件 |
| `Dash` | Web 应用框架 | 极高（回调联动） | 服务器/云端 | 高 | 动态看板应用 |
| `Streamlit` | Web 应用框架 | 高（控件驱动） | Streamlit Cloud | 中 | 快速原型、数据应用 |
| `Panel` | 多后端框架 | 高 | 多种 | 中-高 | 科学计算看板 |
| `Quarto + Plotly` | 文档 + 图表 | 中（静态交互） | GitHub Pages | 低 | **本作业主线** |

> 📝
> 两者都能实现动态看板，但设计哲学不同：Streamlit 以"脚本即应用"为核心，代码更简洁；Dash 基于 React，支持更复杂的回调逻辑和企业级部署。详细对比参见：<https://plotly.com/comparing-dash-and-streamlit/>

**② Plotly 核心概念与基础语法**

这是本作业的主要绘图工具，须详细介绍以下内容（每部分配有完整可运行的代码示例）：

*Figure 对象模型*

```python
import plotly.graph_objects as go

# Plotly 的核心是 Figure 对象，由 data（轨迹列表）和 layout（布局配置）组成
fig = go.Figure()

# 添加一条折线轨迹（Trace）
fig.add_trace(go.Scatter(
    x=[1, 2, 3, 4, 5],
    y=[10, 11, 12, 11, 13],
    mode='lines+markers',
    name='示例序列',
    line=dict(color='royalblue', width=2),
    hovertemplate='日期: %{x}<br>数值: %{y:.2f}<extra></extra>'
))

# 配置布局
fig.update_layout(
    title='示例折线图',
    xaxis_title='日期',
    yaxis_title='数值',
    template='plotly_white',   # 主题：plotly / plotly_dark / plotly_white / ggplot2
    height=400,
    hovermode='x unified'      # 悬停时显示同一 x 位置的所有轨迹值
)

fig.show()
```

*子图布局（make_subplots）*

```python
from plotly.subplots import make_subplots

# 创建 2 行 2 列的子图布局
fig = make_subplots(
    rows=2, cols=2,
    subplot_titles=('主指数走势', '成交量', '行业热力图', '利率曲线'),
    row_heights=[0.6, 0.4],    # 行高比例
    vertical_spacing=0.1,
    specs=[
        [{"colspan": 2}, None],          # 第一行跨两列
        [{"type": "xy"}, {"type": "xy"}] # 第二行各占一列
    ]
)

fig.add_trace(go.Scatter(x=[], y=[], name='沪深300'), row=1, col=1)
fig.add_trace(go.Bar(x=[], y=[], name='成交量'),      row=2, col=1)
# ... 添加更多轨迹

fig.update_layout(height=700, showlegend=True)
```

*时间范围选择器（RangeSelector）*

这是实现"过去 1 个月 / 3 个月 / 6 个月 / 1 年"局部放大功能的核心组件：

```python
fig.update_xaxes(
    rangeslider=dict(visible=True),    # 底部滑动条
    rangeselector=dict(
        buttons=[
            dict(count=1,  label="1个月", step="month", stepmode="backward"),
            dict(count=3,  label="3个月", step="month", stepmode="backward"),
            dict(count=6,  label="6个月", step="month", stepmode="backward"),
            dict(count=1,  label="今年",  step="year",  stepmode="todate"),
            dict(step="all", label="全部")
        ],
        bgcolor='rgba(150,200,250,0.4)',
        activecolor='royalblue'
    )
)
```

> **说明**：`RangeSelector` 是纯前端交互，无需重新查询数据，用户点击按钮后图表会即时缩放到对应时间范围，这正是"本地交互"的优势。

*将图表导出为 HTML 并嵌入 Quarto*

```python
# 导出为独立 HTML 文件
fig.write_html(
    "output/index_chart.html",
    include_plotlyjs='cdn',    # 从 CDN 加载 Plotly.js，减小文件体积
    full_html=True
)

# 在 Quarto 文档中嵌入（两种方式）
```

```markdown
<!-- 方式一：iframe 嵌入（适合独立 HTML） -->
<iframe src="output/index_chart.html" width="100%" height="500px"
        frameborder="0"></iframe>

<!-- 方式二：直接在代码块中生成（推荐，Quarto 会自动处理） -->
```{python}
#| echo: false
fig.show()
```
```

> 💡
> Plotly 提供两套 API：`plotly.express`（高级接口，代码简洁，适合快速探索）和 `plotly.graph_objects`（低级接口，灵活可控，适合精细定制）。本作业主线使用 `graph_objects`，因为看板通常需要精细的子图布局控制。Express 的使用示例见官方文档：<https://plotly.com/python/plotly-express/>

**③ Quarto Book 的多页布局与看板页设计**

在 Quarto Book 中，看板通常以一个独立的 `.qmd` 页面呈现。介绍以下布局技巧（配代码示例）：

```markdown
---
title: "中国股市数据看板"
format:
  html:
    page-layout: full          # 全宽布局，去掉侧边留白
    toc: false                 # 看板页不需要目录
    code-fold: true            # 代码默认折叠
execute:
  echo: false                  # 默认不显示代码，只显示图表
---

:::: {.columns}               <!-- 多列布局 -->
::: {.column width="70%"}
<!-- 主图：指数走势 -->
```{python}
fig_main.show()
```
:::
::: {.column width="30%"}
<!-- 侧栏：KPI 指标卡 -->
```{python}
fig_kpi.show()
```
:::
::::
```

---

### 1.3 数据获取：API 接口与本地缓存

**① 本作业使用的数据接口**

以下接口经过验证，在中国大陆可稳定访问，无需注册或付费：

| 数据内容 | akshare 接口 | 返回频率 | 说明 |
|---------|-------------|---------|------|
| 主要指数日 K 线 | `ak.index_zh_a_hist(symbol, period="daily")` | 日度 | 沪深300=000300，上证=000001 |
| 指数实时行情 | `ak.stock_zh_index_spot_sina()` | 实时快照 | 交易时段返回最新价 |
| 申万行业涨跌幅 | `ak.index_realtime_sw()` | 实时 | 一级行业今日涨跌 |
| LPR 利率 | `ak.macro_china_lpr()` | 月度 | 1年期和5年期LPR |
| SHIBOR | `ak.macro_china_shibo_rate()` | 日度 | 隔夜至1年期 |
| 10年期国债收益率 | `ak.bond_zh_us_rate()` | 日度 | 中美国债收益率 |
| 北向资金净流入 | `ak.stock_hsgt_north_net_flow_in_em()` | 日度 | 沪深港通北向资金 |

**② 本地缓存设计（必须实现）**

频繁调用 API 不仅速度慢，还可能触发频率限制。本地缓存的逻辑是：**先检查本地文件是否已有当天数据，有则直接读取，没有才请求 API**。

```python
import pandas as pd
import akshare as ak
from pathlib import Path
from datetime import datetime, date
import time

CACHE_DIR = Path("data/cache")
CACHE_DIR.mkdir(parents=True, exist_ok=True)

def get_index_data(symbol: str,
                   start_date: str = "20240101",
                   force_update: bool = False) -> pd.DataFrame:
    """
    获取指数历史日 K 线数据，带本地缓存。

    Parameters
    ----------
    symbol : str
        指数代码，如 "000300"（沪深300）
    start_date : str
        起始日期，格式 YYYYMMDD
    force_update : bool
        强制重新从 API 获取，忽略缓存

    Returns
    -------
    pd.DataFrame
        包含日期、开盘、收盘、最高、最低、成交量的 DataFrame
    """
    cache_file = CACHE_DIR / f"index_{symbol}.parquet"
    today = date.today().strftime("%Y%m%d")

    # 检查缓存：若文件存在且今天已更新，直接读取
    if cache_file.exists() and not force_update:
        df_cache = pd.read_parquet(cache_file)
        last_date = df_cache['日期'].max().strftime("%Y%m%d")
        if last_date >= today:
            print(f"[缓存] {symbol} 数据已是最新（{last_date}），跳过 API 请求")
            return df_cache

    # 缓存过期或不存在，请求 API
    print(f"[API] 正在获取 {symbol} 数据...")
    try:
        df = ak.index_zh_a_hist(
            symbol=symbol,
            period="daily",
            start_date=start_date,
            end_date=today
        )
        df['日期'] = pd.to_datetime(df['日期'])
        df.to_parquet(cache_file, index=False)
        print(f"[缓存] 已保存至 {cache_file}")
        time.sleep(0.5)   # 礼貌请求，避免触发频率限制
        return df
    except Exception as e:
        print(f"[错误] {symbol} 获取失败: {e}")
        # 若 API 失败但有旧缓存，返回旧数据
        if cache_file.exists():
            print(f"[降级] 使用旧缓存数据")
            return pd.read_parquet(cache_file)
        raise
```

在 Quarto 文档中，所有数据获取都通过这类缓存函数调用，而不是直接调用 akshare。这样：
- 每天第一次运行：自动更新数据，生成最新看板
- 同一天多次运行：直接读缓存，秒级响应
- API 不可用时：降级使用昨日数据，看板仍可正常渲染

> **在 README.md 中说明**：每天需要运行 `quarto render` 一次以更新看板数据，并重新部署到 GitHub Pages。可使用 GitHub Actions 实现自动定时更新（选做加分项）。

---

## Part 2：看板设计与实现（自由发挥）

### 2.1 选题要求

请从以下四个主题中**选择一个**，设计并实现你们小组的数据看板。允许在主题范围内自由扩展内容，但核心数据必须通过 API 实时获取，不得使用手动下载的静态数据。

---

**主题 A：中国股市全景看板**

> *定位：面向普通投资者的每日行情概览，类似财经 App 的首页*

必须包含的数据维度：
- 主要宽基指数（沪深300、上证综指、创业板指、科创50）的日 K 线走势，支持时间范围切换（1M/3M/6M/1Y）
- 今日申万一级行业涨跌幅热力图（颜色代表涨跌幅大小）
- 主要指数的成交量时序图（柱状图，与 K 线图共享 x 轴）
- 北向资金近期净流入/净流出趋势

自由发挥方向建议（选做其中 1-2 项即可）：
- 个股涨跌停家数统计（每日情绪指标）
- 融资融券余额趋势
- AH 溢价指数

---

**主题 B：利率与债券市场看板**

> *定位：面向固收研究人员的资金面与利率环境监控*

必须包含的数据维度：
- LPR 利率历史走势（1年期 vs 5年期对比）
- SHIBOR 各期限利率的期限结构曲线（最新日 vs 一个月前的对比）
- 中国10年期国债收益率走势，叠加美国10年期国债收益率（中美利差）
- 货币市场利率（DR007 或 SHIBOR 隔夜）的近期走势

自由发挥方向建议：
- M2/M1 同比增速时序图
- 社会融资规模结构图
- CPI/PPI 对比走势

---

**主题 C：上市公司财务健康看板**

> *定位：面向股票研究员的个股/行业财务体检报告，每季度更新*

必须包含的数据维度：
- 选定 1 个行业（自选），展示该行业内10-20只股票的 ROE、资产负债率、营业收入增速的散点图（气泡大小代表市值）
- 主要财务指标的行业横截面分布（箱型图）
- 选定 1-2 只代表性公司，展示其近 5 年的财务指标时序图

数据获取建议：`akshare` 的 `ak.stock_financial_abstract_ths()` 或 `ak.stock_a_indicator_lg()`

自由发挥方向建议：
- 盈利能力象限图（ROE vs ROA，按行业着色）
- 净利润增速排名条形竞赛图（Bar Chart Race）

---

**主题 D：宏观经济与大类资产看板**

> *定位：面向资产配置研究员的宏观环境综合监控*

必须包含的数据维度：
- 中国主要宏观指标时序图：GDP 增速、CPI、PMI（制造业与非制造业）
- 大类资产近一年收益率对比：A 股（沪深300）、黄金、人民币/美元汇率、10年期国债
- 美联储联邦基金利率走势（来自 FRED 或 akshare）

数据获取建议：`akshare` 宏观经济板块接口（`ak.macro_china_*` 系列）

自由发挥方向建议：
- 全球主要股指对比（标普500、日经225、恒生指数）
- 大宗商品价格（铜、原油、黄金）走势

---

### 2.2 看板设计规范

无论选择哪个主题，最终看板都须满足以下规范：

**布局要求**：
- 至少包含 **4 个独立的图表组件**
- 至少 1 个图表实现**时间范围切换**（RangeSelector）
- 至少 1 个图表包含**双轴或分面设计**（如 K 线图 + 成交量共享 x 轴）
- 页面顶部须有 **KPI 摘要区**（显示当日或最新的 3-5 个核心数值）

**数据要求**：
- 所有数据通过 API + 本地缓存获取，不允许手动下载后导入
- 在看板页面的显眼位置标注**数据更新时间**（精确到日）
- 每个图表须有**数据来源标注**（如"数据来源：akshare / 上交所"）

**交互要求**：
- 所有图表须支持悬停显示数值（`hovertemplate` 格式化）
- 时序图须有 RangeSelector 或 RangeSlider

**KPI 摘要区示例**（可用 Plotly 的 Indicator 或 HTML 实现）：

```python
import plotly.graph_objects as go

fig_kpi = go.Figure()
fig_kpi.add_trace(go.Indicator(
    mode="number+delta",
    value=3850.23,
    delta={'reference': 3820.15, 'relative': True,
           'valueformat': '.2%'},
    title={'text': "沪深300<br><span style='font-size:0.8em'>今日收盘</span>"},
    domain={'x': [0, 0.25], 'y': [0, 1]}
))
# 继续添加更多 KPI 指标...

fig_kpi.update_layout(height=150, margin=dict(t=20, b=0))
```

---

## Part 3：Quarto Book 结构与 GitHub Pages 部署

### 3.1 仓库结构

```
dshw-dashboard/
├── _quarto.yml                  ← Quarto Book 配置
├── index.qmd                    ← 首页（项目介绍）
├── 01_intro.qmd                 ← Part 1：Dashboard 介绍
├── 02_tools.qmd                 ← Part 1：Python 工具介绍
├── 03_data.qmd                  ← Part 1：数据获取与缓存
├── 04_dashboard.qmd             ← Part 2：看板主页面（full-width）
├── 05_methods.qmd               ← 实现过程说明（可选）
├── data/
│   └── cache/                   ← 本地缓存（加入 .gitignore）
├── output/                      ← 导出的图表文件（可选）
├── requirements.txt
├── README.md
└── .gitignore
```

**`_quarto.yml` 配置示例**：

```yaml
project:
  type: book
  output-dir: docs              # GitHub Pages 从 docs/ 读取

book:
  title: "金融数据看板"
  author: "小组成员姓名"
  date: today
  chapters:
    - index.qmd
    - part: "Part 1：讲义"
      chapters:
        - 01_intro.qmd
        - 02_tools.qmd
        - 03_data.qmd
    - part: "Part 2：看板"
      chapters:
        - 04_dashboard.qmd

format:
  html:
    theme: cosmo
    code-fold: true
    code-tools: true

execute:
  freeze: auto                  # 缓存代码执行结果，加速重新渲染
```

**`.gitignore` 配置**：

```gitignore
data/cache/          # 本地缓存数据不上传（体积较大）
.ipynb_checkpoints/
__pycache__/
.DS_Store
```

> **注意**：`data/cache/` 不上传 GitHub，在 README 中说明：clone 仓库后首次运行 `quarto render` 会自动从 API 获取数据并建立本地缓存。

### 3.2 GitHub Pages 部署步骤

在 README 中详细记录以下部署过程（配截图）：

```bash
# 1. 本地渲染
quarto render

# 2. 检查 docs/ 目录是否生成
ls docs/

# 3. 通过 GitHub Desktop 提交并推送

# 4. 在 GitHub 仓库 Settings → Pages 中：
#    Source: Deploy from a branch
#    Branch: main / docs
```

### 3.3 自动定时更新（选做加分项 +10 分）

使用 GitHub Actions 实现每日自动运行 `quarto render` 并更新 GitHub Pages：

```yaml
# .github/workflows/update_dashboard.yml
name: Daily Dashboard Update

on:
  schedule:
    - cron: '0 2 * * *'    # 北京时间每天上午 10:00（UTC+8）
  workflow_dispatch:        # 允许手动触发

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - run: pip install -r requirements.txt
      - uses: quarto-dev/quarto-actions/setup@v2
      - run: quarto render
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./docs
```

---

## 提交要求

**提交内容（必须同时完成）**：

**① GitHub 仓库**
- 仓库名称：**`dshw-dashboard`**，Public
- 包含完整的 Quarto Book 源文件和代码
- README 中注明：GitHub Pages 网址、小组成员、主题选择、数据来源

**② GitHub Pages 网址**
- 确保网址可公开访问：`https://[用户名].github.io/dshw-dashboard/`
- 看板页面须能正常渲染（图表有数据、可交互）
- 在网站首页显眼位置标注**数据最后更新日期**

**坚果云**（可选）：若 GitHub Pages 暂时无法访问，额外提交压缩包作为备份

---

## README.md 要求

```markdown
## 金融数据看板

### 小组成员与分工
| 姓名 | 负责模块 |
|------|---------|
| ...  | Part 1：讲义撰写 |
| ...  | Part 2：看板设计 |
| ...  | Part 2：数据获取与缓存 |
| ...  | 部署与文档 |

### 主题选择
主题 [A/B/C/D]：[主题名称]

### 数据来源
| 数据内容 | 接口 | 更新频率 |
|---------|------|---------|

### 看板网址
https://[用户名].github.io/dshw-dashboard/

### 本地运行方法
1. `pip install -r requirements.txt`
2. `quarto render`
3. 浏览器打开 `docs/index.html`

### AI 使用说明
[说明使用了哪些 AI 工具，主要用于哪些环节，如 Agent 模式的 task 文档见 docs/agent-task.md]
```

---

## 评分标准

| 维度 | 分值 | 说明 |
|------|------|------|
| **Part 1：讲义质量** | **40 分** | |
| Dashboard 概念介绍 | 15 分 | 定义准确，有真实案例，配图说明 |
| Python 工具介绍 | 15 分 | 对比表完整，Plotly 代码示例可运行 |
| 数据获取与缓存 | 10 分 | 缓存逻辑正确，代码规范，有使用说明 |
| **Part 2：看板实现** | **45 分** | |
| 数据完整性 | 10 分 | 所有数据通过 API 获取，无手动导入 |
| 图表质量与规范 | 15 分 | ≥4 个图表，悬停格式化，数据来源标注 |
| 交互功能 | 10 分 | RangeSelector 实现，KPI 摘要区完整 |
| 主题深度与创意 | 10 分 | 在必做内容之外有自己的想法和扩展 |
| **Part 3：部署** | **15 分** | |
| GitHub Pages 可访问 | 10 分 | 网址有效，页面正常渲染 |
| README 与文档 | 5 分 | 完整，他人可据此复现 |
| **加分项** | | |
| GitHub Actions 自动更新 | +10 分 | workflow 文件正确，能定时触发渲染 |
| 选做扩展内容 | +5 分 | 在主题范围内有实质性的自选内容 |

> **讲义部分占 40 分是刻意设计的**：这部分内容将用于后续课程，质量要求高于普通作业报告。清晰的文字、可运行的代码示例、有层次的结构——这三点是讲义区别于作业报告的核心。评分时对 Part 1 的写作质量要求会明显高于 Part 2 的实现部分。
