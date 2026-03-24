## 研究工具训练：文献检索、版本管理与 AI 辅助自学

### 任务背景

现代数据科学研究不仅要求掌握分析方法，还需要具备**高效检索资料、规范管理代码与数据、以及持续自学新方法**的能力。本题不考察特定的金融分析结论，而是通过一套完整的"找资料 → 管项目 → 学方法 → 写文档 → 做展示"流程，帮助你建立独立开展数据研究的基础工作习惯。

> **评分重心**：过程的规范性与完整性，而非分析结论的"正确性"。一份记录了真实探索过程（包括走弯路、修正、追问）的文档，优于一份看起来完美但缺乏思考痕迹的报告。

---

### 任务一：文献与数据检索

#### 1.1 在 GitHub 上搜索教学资源

- 在 GitHub 搜索栏中，使用以下关键词（或自行组合）搜索相关教程和代码仓库：
  - `financial data analysis python`
  - `CAPM beta python notebook`
  - `factor investing tutorial`
  - `GARCH python tutorial`
- 从搜索结果中筛选出 **3 个你认为有价值的仓库**，填写如下信息（汇总为 Markdown 表格）：

  | 仓库地址 | 作者 / 机构 | Stars 数 | 主要内容描述 | 你认为有价值的原因 |
  |----------|------------|---------|------------|-----------------|
  | ... | ... | ... | ... | ... |

- **筛选标准参考**（自行判断，在 README 中说明）：Star 数量、最近更新时间、文档完整度、代码可运行性、是否有配套数据

#### 1.2 在 Harvard Dataverse 上检索数据集

Harvard Dataverse（https://dataverse.harvard.edu）是一个开放的学术数据共享平台，收录了大量经济、金融、社会科学领域的研究数据集。

- 在 Harvard Dataverse 上，围绕本课程涉及的任一主题（股票市场、利率、货币政策、因子投资等），搜索并找到 **2 个真实的数据集**
- 填写如下信息（汇总为 Markdown 表格）：

  | 数据集名称 | 作者 | 发布年份 | 数据描述 | DOI / 链接 | 是否可直接下载 |
  |-----------|------|---------|---------|-----------|-------------|
  | ... | ... | ... | ... | ... | ... |

- 尝试下载其中 **1 个数据集**，用 Python 读取并输出前 5 行，截图或将代码嵌入 Notebook

#### 1.3 补充：探索其他数据平台（选做）

访问以下平台中的至少 1 个，简要描述其定位、数据覆盖范围，以及与 Harvard Dataverse 的区别：

- **ICPSR**（https://www.icpsr.umich.edu）：社会科学数据存档
- **Zenodo**（https://zenodo.org）：欧洲开放科学平台，支持代码与数据共同存档
- **FRED**（https://fred.stlouisfed.org）：美联储经济数据库
- **World Bank Open Data**（https://data.worldbank.org）：世界银行宏观数据

---

### 任务二：GitHub 项目管理

#### 2.1 新建 GitHub 仓库并完成初始化

按以下步骤操作，并在 README 中记录每步截图或说明：

1. 登录 GitHub，新建一个公开（Public）仓库，命名为 `dsfin-topic06`（或自定义）
2. 勾选"Add a README file"，选择 `.gitignore` 模板为 `Python`，License 选择 `MIT`
3. 在 README 中填写以下内容：
   - 项目简介（本次作业的主题和目的）
   - 小组成员姓名
   - 项目文件夹结构说明
4. 为仓库添加至少 **3 个 Topics 标签**（如 `finance`、`python`、`data-analysis`）

#### 2.2 通过 GitHub Desktop 实现本地同步

1. 安装 GitHub Desktop（https://desktop.github.com），将上述仓库 Clone 到本地
2. 在本地创建如下项目结构：

```
dsfin-topic06/
├── README.md
├── notes/               # 存放自学笔记（任务三的输出）
├── slides/              # 存放 Marp 幻灯片（任务四的输出）
├── data/                # 存放任务一下载的数据
├── notebooks/           # 存放 Jupyter Notebook
└── output/              # 存放图形等输出
```

3. 在本地新建或修改至少 1 个文件（如修改 README，或新建 `notes/` 下的第一个 `.md` 文件）
4. 通过 GitHub Desktop 完成：**Commit**（填写有意义的 commit message）→ **Push**
5. 在 README 中截图展示 GitHub Desktop 的 commit 历史（或直接在 GitHub 网页上展示 commit 记录），要求**整个作业过程中至少有 5 次有意义的 Commit**，每次 Commit message 应清楚描述本次改动内容

> **Commit message 示例**（好的习惯）：
> - ✅ `Add: 初始化项目结构，创建各子文件夹`
> - ✅ `Add: 完成 Harvard Dataverse 数据检索，更新 README 表格`
> - ✅ `Update: IPW 自学笔记第一稿，完成基本概念部分`
> - ❌ `update`（过于模糊，不可取）
> - ❌ `fix bug`（无具体说明，不可取）

#### 2.3 使用 `.gitignore` 管理敏感和冗余文件

- 确认 `.gitignore` 中已包含以下条目，防止不必要的文件被追踪：
  ```
  # Jupyter Notebook checkpoints
  .ipynb_checkpoints/
  # 数据文件（大文件不上传至 GitHub）
  data/*.csv
  data/*.xlsx
  # 系统文件
  .DS_Store
  __pycache__/
  ```
- 在 README 中说明：数据文件不上传 GitHub 的原因，以及如何让他人复现你的数据下载步骤

---

### 任务三：AI 辅助自学——方法笔记撰写

#### 3.1 选择一个自学主题

从以下主题中选择 **1 个**（也可自定义，需与金融数据分析相关）：

| 编号 | 主题 | 关键词参考 |
|------|------|-----------|
| A | 逆概率加权（IPW，Inverse Probability Weighting） | 因果推断、处理效应、倾向得分 |
| B | Lasso / Ridge 回归 | 正则化、变量选择、高维数据 |
| C | 随机森林（Random Forest）用于金融预测 | 集成学习、特征重要性、过拟合 |
| D | 主成分回归（PCR）与偏最小二乘（PLS） | 降维、多重共线性 |
| E | 隐马尔可夫模型（HMM）识别市场状态 | 市场状态切换、牛熊市识别 |
| F | 文本情感分析在金融中的应用 | NLP、FinBERT、情感因子 |
| 自定义 | 需经老师确认 | — |

#### 3.2 与 AI 进行结构化对话，生成自学笔记

**核心要求**：不能直接让 AI 一次性生成全文，必须通过**多轮追问与讨论**逐步深化理解。建议对话轮次不少于 15 轮。

推荐的对话推进策略（以 IPW 为例）：

```
第 1 轮：请用最简单的语言解释 IPW 是什么，它解决什么问题？
第 2 轮：你提到"混淆变量"，能举一个金融领域的具体例子吗？
第 3 轮：倾向得分是怎么估计的？用什么模型？
第 4 轮：IPW 的权重是怎么计算的？公式是什么？
第 5 轮：IPW 有哪些局限性？权重过大会有什么问题？
第 6 轮：如何用 Python 实现一个简单的 IPW 示例？请给出完整可运行的代码
第 7 轮：你给的代码中第 X 行是什么意思？为什么要这样写？
第 8 轮：IPW 和倾向得分匹配（PSM）有什么区别？各有什么优劣？
第 9 轮：在金融研究中，IPW 通常用在哪些场景？能举一篇实证论文的例子吗？
第 10 轮：如果我想把 IPW 用在 A 股的某个问题上，你建议怎么设计？
……
```

**对话记录要求**：

- 将完整的对话记录（包括你的提问和 AI 的回复）保存为 `notebooks/ai_conversation_log.md`（可适当精简，保留关键轮次，但不能删除走弯路或修正的过程）
- 在笔记中明确标注：哪些地方 AI 的回答让你困惑，你是如何通过追问解决的

#### 3.3 整理输出：自学笔记 `.md` 文档

基于对话过程，整理输出一份**结构完整的自学笔记**，保存为 `notes/note_[主题名].md`，需包含以下部分：

```markdown
## [主题名称] 自学笔记

### 1. 核心问题：这个方法解决什么问题？
### 2. 直觉与类比：用一句话解释给外行听
### 3. 方法原理
   - 数学公式（使用 LaTeX）
   - 关键假设
   - 计算步骤
### 4. Python 实现
   - 最小可运行示例（代码块）
   - 关键参数说明
### 5. 在金融数据分析中的应用场景
### 6. 与相关方法的对比
### 7. 局限性与注意事项
### 8. 参考资料
   - 至少 1 篇学术论文（注明来源，建议从 GitHub/Dataverse 检索到的仓库中找到引用）
   - 至少 1 个参考代码仓库（GitHub 链接）
   - AI 工具使用说明（使用了哪个 AI，对话轮数，主要用途）
```

---

### 任务四：生成 Marp 幻灯片并展示

#### 4.1 Marp 简介与安装

[Marp](https://marp.app) 是一个基于 Markdown 的幻灯片制作工具，让你可以用写 `.md` 文档的方式生成专业幻灯片，便于与代码和笔记统一管理在 GitHub 仓库中。

安装方式（任选其一）：

- **VS Code 插件**：在 VS Code 扩展商店中搜索 `Marp for VS Code` 并安装
- **命令行工具**：`npm install -g @marp-team/marp-cli`

#### 4.2 制作幻灯片

基于任务三的自学笔记，制作一份 Marp 幻灯片，保存为 `slides/slide_[主题名].md`。

**幻灯片结构要求**（8-12 张）：

```
第 1 张：封面（主题名称、小组成员、日期）
第 2 张：目录
第 3 张：这个方法解决什么问题？（动机）
第 4-5 张：方法原理（含公式）
第 6 张：Python 代码示例（关键片段）
第 7 张：金融应用场景
第 8 张：与相关方法的对比表格
第 9 张：局限性
第 10 张：学习过程反思（你们走了哪些弯路？AI 哪里回答得不好？）
第 11 张：参考资料
```

**Marp 幻灯片模板示例**：

```markdown
---
marp: true
theme: default
paginate: true
---

# IPW：逆概率加权
## 金融数据分析与建模 | 小组作业 Topic06

小组成员：张三、李四、王五
日期：2025 年 XX 月

---

## 目录

1. 问题动机
2. 方法原理
3. Python 实现
4. 金融应用
5. 方法对比
6. 学习反思

---

## 问题动机

> **核心问题**：如何从观测数据中估计因果效应？

- 直接比较处理组和控制组会受到**选择偏误**的干扰
- 例：研究"分析师评级上调"对股价的影响……

---
```

#### 4.3 导出为 PDF 或 HTML

使用以下命令将 Marp 幻灯片导出：

```bash
# 导出为 PDF
marp slides/slide_topic.md --pdf -o output/slide_topic.pdf

# 导出为 HTML（可在浏览器中展示）
marp slides/slide_topic.md -o output/slide_topic.html
```

将导出的 PDF 文件上传至 GitHub 仓库的 `output/` 文件夹，并在 README 中提供直接链接。

---

### 最终提交内容

#### GitHub 仓库（主要提交方式）

提交 GitHub 仓库链接，仓库需包含：

```
dsfin-topic06/
├── README.md                          ← 完整的项目说明，含检索结果表格
├── notes/
│   ├── note_[主题名].md               ← 自学笔记（任务三）
│   └── ai_conversation_log.md        ← AI 对话记录（精选）
├── slides/
│   └── slide_[主题名].md              ← Marp 幻灯片源文件（任务四）
├── data/
│   └── README_data.md                ← 数据说明（不上传原始数据文件）
├── notebooks/
│   └── dataverse_demo.ipynb          ← 读取 Dataverse 数据的演示 Notebook
└── output/
    └── slide_[主题名].pdf             ← 导出的幻灯片 PDF（任务四）
```

#### 课堂展示（10 分钟）

- 展示 Marp 幻灯片（8-12 张，约 8 分钟）
- 现场演示 GitHub 仓库结构和 commit 历史（约 2 分钟）
- 须回答老师或同学的 1-2 个提问

---

### 评分标准

| 维度 | 分值 | 说明 |
|------|------|------|
| 文献与数据检索（任务一） | 20 分 | 检索结果的质量与说明的完整性 |
| GitHub 使用规范（任务二） | 20 分 | 仓库结构、commit 数量与质量、.gitignore 配置 |
| 自学笔记质量（任务三） | 35 分 | 内容完整性、理解深度、AI 对话过程的真实性 |
| Marp 幻灯片与展示（任务四） | 25 分 | 幻灯片质量、表达清晰度、现场问答 |

> **特别说明**：任务三中，AI 对话记录是评分的重要依据。对话过程应体现真实的学习轨迹——包括困惑、追问和修正——而非直接让 AI 一次性生成答案后再"倒推"提问记录。评分时将重点看对话的递进性和你们对方法的真实理解程度。

---

### 参考资源

**GitHub 使用入门**
- GitHub 官方文档：https://docs.github.com/zh
- GitHub Desktop 下载：https://desktop.github.com
- Commit message 规范（Conventional Commits）：https://www.conventionalcommits.org/zh-hans

**数据检索平台**
- Harvard Dataverse：https://dataverse.harvard.edu
- Zenodo：https://zenodo.org
- ICPSR：https://www.icpsr.umich.edu

**Marp 幻灯片**
- Marp 官网：https://marp.app
- Marp for VS Code 插件：https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode
- Marp 主题文档：https://github.com/marp-team/marp-core/tree/main/themes

**AI 辅助学习建议**
- 建议使用：Claude（https://claude.ai）、ChatGPT、Kimi 等
- 每次对话建议在新会话中开始，避免上下文污染
- 遇到 AI 给出不确定信息时，务必用文献或代码实测进行验证
