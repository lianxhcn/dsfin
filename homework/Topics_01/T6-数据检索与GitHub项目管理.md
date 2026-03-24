## 研究工具训练（上）：数据检索与 GitHub 项目管理

### 任务背景

规范的项目管理习惯和高效的资料检索能力，是开展数据研究的基础。本题要求你完成两件事：一是学会在 GitHub 和 Harvard Dataverse 等平台上主动搜寻有价值的教程与数据；二是建立一个结构清晰、提交记录规范的 GitHub 仓库，并将检索成果纳入其中统一管理。

完成本题后，**后续所有小组作业（T1-T5）均建议沿用本题建立的 GitHub 工作流进行提交**。

> **评分重心**：仓库结构的规范性、commit 记录的质量，以及对检索结果的筛选与评价能力——而非数据分析本身。

---

### 任务一：文献与数据检索

#### 1.1 在 GitHub 上搜索教学资源

在 GitHub 搜索栏中，围绕本课程涉及的任一主题，使用英文关键词进行搜索。关键词示例：

- `financial data analysis python notebook`
- `CAPM beta rolling regression`
- `factor investing quantitative tutorial`
- `GARCH volatility python`
- `yield curve analysis python`

从搜索结果中筛选出 **3 个你认为有价值的仓库**，在 `README.md` 中以表格形式呈现：

| 仓库地址 | 作者 / 机构 | Stars | 最近更新 | 主要内容 | 有价值的理由 |
|----------|------------|-------|---------|---------|------------|
| ... | ... | ... | ... | ... | ... |

**筛选时请综合考虑以下维度**（在表格后用 2-3 句话说明你们的筛选标准）：

- Star 数量与 Fork 数量
- 最近 commit 时间（是否仍在维护）
- README 文档的完整程度
- 代码是否有配套数据或可独立运行
- 是否有清晰的教学结构（如章节划分、习题等）

#### 1.2 在 Harvard Dataverse 上检索数据集

[Harvard Dataverse](https://dataverse.harvard.edu) 是哈佛大学维护的开放学术数据平台，收录了大量经济、金融、社会科学领域的研究数据集，通常与已发表论文配套，可直接引用。

围绕本课程任一主题，在 Harvard Dataverse 上检索并找到 **2 个数据集**，在 `README.md` 中以表格形式呈现：

| 数据集名称 | 作者 | 发布年份 | 数据简介 | DOI / 链接 | 是否可直接下载 |
|-----------|------|---------|---------|-----------|-------------|
| ... | ... | ... | ... | ... | ... |

随后，**尝试下载其中 1 个数据集**，在 `notebooks/dataverse_demo.ipynb` 中用 Python 读取并完成：

- 输出数据框的前 5 行（`df.head()`）
- 输出基本信息（`df.info()`、`df.describe()`）
- 用 1-2 句话描述该数据集的结构和你对它的初步判断（是否适合用于金融分析？为什么？）

#### 1.3 补充：探索其他开放数据平台（选做）

从以下平台中任选 1 个，在 `README.md` 中简要介绍其定位、数据覆盖范围，以及与 Harvard Dataverse 的主要区别：

- **Zenodo**（https://zenodo.org）：欧洲开放科学平台，支持代码与数据打包存档，可生成 DOI
- **ICPSR**（https://www.icpsr.umich.edu）：密歇根大学社会科学数据存档，侧重调查数据
- **FRED**（https://fred.stlouisfed.org）：美联储经济数据库，宏观金融数据权威来源
- **World Bank Open Data**（https://data.worldbank.org）：世界银行宏观发展指标

---

### 任务二：GitHub 项目管理

#### 2.1 新建仓库并初始化

按以下步骤操作，关键步骤截图保存，汇总到 `README.md` 末尾的"操作记录"部分：

1. 登录 GitHub，新建一个**公开（Public）仓库**，建议命名为 `dsfin-projects`（后续 T1-T5 也放入此仓库的子文件夹）
2. 初始化时勾选：Add a README file、`.gitignore` 模板选 `Python`、License 选 `MIT`
3. 为仓库添加至少 3 个 Topics 标签（如 `finance`、`python`、`data-analysis`）
4. 在 README 中填写：项目简介、小组成员、文件夹结构说明

#### 2.2 通过 GitHub Desktop 实现本地同步

1. 安装 [GitHub Desktop](https://desktop.github.com)，将仓库 Clone 到本地
2. 在本地按以下结构创建文件夹：

```
dsfin-projects/
├── README.md
├── topic06/
│   ├── notebooks/
│   │   └── dataverse_demo.ipynb     ← 任务一的演示 Notebook
│   └── data/
│       └── README_data.md           ← 数据说明文件（不上传原始数据）
├── topic01/                         ← 后续作业预留位置
├── topic02/
└── ...
```

3. 在本地完成修改后，通过 GitHub Desktop 执行 **Commit → Push**
4. **整个作业过程中要求至少完成 5 次有意义的 Commit**，每次提交需填写清晰的 commit message

**Commit message 示例**：

```
# ✅ 好的示例
Add: 初始化项目结构，创建 topic06 子文件夹
Add: 完成 GitHub 仓库检索，更新 README 表格
Add: 完成 Dataverse 数据下载，新增 dataverse_demo.ipynb
Update: 补充数据集筛选标准说明
Fix: 修正 README 中仓库链接错误

# ❌ 不可取的示例
update
fix
123
done
```

#### 2.3 配置 `.gitignore`

确认本地 `.gitignore` 文件中包含以下内容，防止大文件或系统文件被误提交：

```gitignore
# Jupyter Notebook 缓存
.ipynb_checkpoints/

# 数据文件（体积较大，不上传 GitHub）
*.csv
*.xlsx
*.parquet

# Python 缓存
__pycache__/
*.pyc

# 系统文件
.DS_Store
Thumbs.db
```

在 `topic06/data/README_data.md` 中说明：**为什么数据文件不上传 GitHub**，以及他人如何复现你的数据下载步骤（提供下载链接或代码）。

---

### 最终提交内容

提交 GitHub 仓库链接，仓库需满足：

- [ ] 仓库为 Public，含 README、.gitignore、License
- [ ] 文件夹结构清晰，符合上述要求
- [ ] README 包含检索结果表格（GitHub 仓库 × 3，Dataverse 数据集 × 2）及筛选说明
- [ ] `notebooks/dataverse_demo.ipynb` 可完整运行
- [ ] 至少 5 次有意义的 Commit，message 清晰具体
- [ ] `.gitignore` 正确配置，无多余文件被追踪

---

### 评分标准

| 维度 | 分值 | 说明 |
|------|------|------|
| GitHub 仓库检索质量 | 25 分 | 3 个仓库的相关性、筛选理由的深度 |
| Dataverse 数据检索与读取 | 25 分 | 数据集说明的完整性、Notebook 的可运行性 |
| 仓库结构与规范性 | 25 分 | 文件夹结构、README 完整度、.gitignore 配置 |
| Commit 记录质量 | 25 分 | 提交次数（≥5）、message 是否清晰有意义 |

---

### 参考资源

- GitHub 官方文档（中文）：https://docs.github.com/zh
- GitHub Desktop 下载：https://desktop.github.com
- Harvard Dataverse 使用指南：https://dataverse.org/guides/user
- Commit message 规范参考：https://www.conventionalcommits.org/zh-hans
- `.gitignore` 模板库：https://github.com/github/gitignore
