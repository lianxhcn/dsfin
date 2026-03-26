## 可复现研究报告：Quarto 排版与 GitHub Pages 发布

### 任务背景

在学术研究和行业报告中，"可复现性"是衡量工作质量的重要标准——别人拿到你的代码和数据，应该能一键复现所有图表和结论。Jupyter Notebook 虽然方便，但作为最终交付物有明显局限：格式不统一、代码与叙述混杂、难以生成专业排版的 PDF/HTML 文档。

本题要求你将前面完成的某道作业（T1-T5 任选其一）**重新整理为一份规范的 Quarto 研究报告**，并部署到 GitHub Pages 供公开访问。目标是：任何人访问你的 GitHub Pages 链接，都能读到一份排版整洁、图文并茂、逻辑清晰的分析报告。

---

### 工具简介

**Quarto**（https://quarto.org）是新一代科学写作工具，支持在 `.qmd` 文件中混写 Markdown 文本和 Python/R 代码块，一键渲染为 HTML、PDF 或 Word 文档。它是 R Markdown 的继任者，已被学术界和数据科学社区广泛采用。

安装：
```bash
# 下载安装包：https://quarto.org/docs/get-started/
# 安装 Quarto VS Code 插件：quarto.quarto
# 验证安装
quarto --version
```

---

### 分析任务

#### 必做部分

**1. 选题与内容规划**

从 T1-T5 中选择 1 道，将其分析结果重新组织为一份**完整的研究报告**，而非 Notebook 的线性展示。

报告须包含以下结构（参考学术论文格式）：

```
1. 摘要（Abstract）
   - 研究问题、数据、主要方法、核心发现（200字以内）

2. 引言（Introduction）
   - 研究背景与动机
   - 本报告的分析框架

3. 数据（Data）
   - 数据来源、时间范围、样本描述
   - 主要变量的描述性统计表格

4. 方法（Methodology）
   - 核心方法的数学表达（LaTeX 公式）
   - 分析步骤的简要说明

5. 实证结果（Results）
   - 主要图表（每图需有标题和图注）
   - 每个结果后跟随文字解释

6. 结论（Conclusion）
   - 主要发现的总结
   - 局限性与未来研究方向

7. 参考资料（References）
```

**2. 用 Quarto 撰写报告**

新建 `report.qmd` 文件，用 Quarto 语法撰写报告。关键语法示例：

````markdown
---
title: "A 股个股 Beta 系数估计与投资组合分析"
author: "张三、李四、王五"
date: today
format:
  html:
    toc: true
    toc-depth: 3
    code-fold: true       # 代码默认折叠，点击展开
    code-tools: true
    theme: cosmo
    fig-width: 8
    fig-height: 5
  pdf:
    documentclass: article
    geometry: margin=1in
execute:
  echo: true
  warning: false
  cache: true             # 缓存代码执行结果，避免重复运行
---

## 摘要

本报告使用 `akshare` 获取……

## 数据

@tbl-summary 展示了 5 只股票的描述性统计。

```{python}
#| label: tbl-summary
#| tbl-cap: "5 只股票收益率描述性统计"

import pandas as pd
# ... 你的代码
df.describe().round(4)
```

## 方法

CAPM 模型如下：

$$r_{i,t} - r_f = \alpha_i + \beta_i (r_{m,t} - r_f) + \varepsilon_{i,t}$$

## 结果

@fig-rolling-beta 展示了滚动 Beta 系数的时序变化。

```{python}
#| label: fig-rolling-beta
#| fig-cap: "5 只股票的 60 日滚动 Beta 系数（2019-2024）"

# ... 绘图代码
```
````

**主要要求**：

- 所有图表须有编号（`#| label: fig-xxx`）和说明（`#| fig-cap:`），并在正文中用 `@fig-xxx` 引用
- 所有表格须有编号（`#| label: tbl-xxx`）和说明，并在正文中引用
- 数学公式使用 LaTeX 语法
- 代码默认折叠（`code-fold: true`），保持报告可读性
- 在 `_quarto.yml` 或文件头中配置 `cache: true`，缓存计算结果

**3. 本地渲染与检查**

```bash
# 渲染为 HTML（开发阶段常用）
quarto render report.qmd --to html

# 渲染为 PDF（需安装 LaTeX 或使用 typst）
quarto render report.qmd --to pdf

# 预览（实时更新）
quarto preview report.qmd
```

逐项检查：
- [ ] 所有代码块均能正常执行
- [ ] 图表标号与正文引用对应
- [ ] LaTeX 公式渲染正确
- [ ] 目录（TOC）结构清晰
- [ ] HTML 版本在浏览器中排版整洁

**4. 发布到 GitHub Pages**

将报告部署为可公开访问的网页：

**方法一：手动部署（简单）**

```bash
# 渲染到 docs/ 文件夹
quarto render report.qmd --output-dir docs

# 推送到 GitHub 后，在仓库 Settings → Pages 中：
# Source 选择 "Deploy from a branch"
# Branch 选择 "main"，目录选择 "/docs"
```

**方法二：GitHub Actions 自动部署（推荐）**

在仓库中新建 `.github/workflows/publish.yml`：

```yaml
name: Publish Quarto Report

on:
  push:
    branches: [main]
    paths:
      - 'topic11/**'

jobs:
  build-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: pip install -r topic11/requirements.txt

      - name: Install Quarto
        uses: quarto-dev/quarto-actions/setup@v2

      - name: Render report
        run: quarto render topic11/report.qmd --output-dir topic11/docs

      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: topic11/docs
```

- 推送代码后，GitHub Actions 自动渲染并部署
- 在 README 中提供 GitHub Pages 链接：`https://[用户名].github.io/dsfin-projects/`

#### 选做部分

**5. 多格式输出**

在同一 `.qmd` 文件中同时渲染为 HTML 和 PDF：

```yaml
format:
  html:
    toc: true
    code-fold: true
  pdf:
    documentclass: article
    include-in-header:
      text: |
        \usepackage{ctex}   # 支持中文 PDF
```

将 PDF 版本也上传到仓库的 `output/` 文件夹。

**6. 参数化报告**

将报告中的关键参数（如股票代码、时间范围）提取为 Quarto 参数，实现一套代码生成不同版本的报告：

```yaml
---
params:
  stocks: ["000001", "600519", "000858", "601318", "300750"]
  start_date: "2019-01-01"
  end_date: "2024-12-31"
---
```

```python
# 在代码块中使用参数
stocks = params["stocks"]  # Quarto 自动注入
```

```bash
# 生成不同参数版本
quarto render report.qmd -P stocks:'["000001","000002"]'
```

---

### 项目结构要求

```
topic11_quarto_report/
├── README.md                        # 报告简介 + GitHub Pages 链接
├── report.qmd                       # Quarto 报告源文件
├── _quarto.yml                      # 项目级配置（可选）
├── requirements.txt                 # Python 依赖列表
├── data/
│   └── README_data.md               # 数据说明（原始数据不上传）
├── docs/                            # 渲染输出（GitHub Pages 读取此目录）
│   └── report.html
└── .github/
    └── workflows/
        └── publish.yml              # GitHub Actions 配置（选做）
```

---

### 提交要求

- 提交 GitHub 仓库链接 + **GitHub Pages 网址**（必须可公开访问）
- HTML 报告须包含完整的图表、公式和目录，排版整洁
- 在 README 中用一段话说明：为什么 Quarto 报告比 Jupyter Notebook 更适合作为最终交付物？
- 重点评分项：报告的叙事逻辑（数据 → 方法 → 结果 → 结论是否流畅）和排版规范性，而非分析本身的新颖性
