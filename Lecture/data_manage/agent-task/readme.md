# agent-task 文件夹说明

## 这个文件夹是什么

这个文件夹包含了用于驱动 VS Code Chat Agent 自动生成「第二章：数据管理与组织」讲义的**全套任务规格文档**。

这些文档不是给人直接执行的操作手册，而是**喂给 Agent 的上下文**——Agent 读完这些文档后，能自主完成数据下载、讲义生成、自检收尾等全流程工作，无需人工干预。

---

## 如何使用

**入口文件是上一级目录的 `agent-task.md`**（即 `data_manage/agent-task.md`）。

操作步骤：

1. 在 VS Code 中打开 Chat（Agent 模式）
2. 将 `data_manage/agent-task.md` 的全部内容粘贴给 Agent，或用 `#file` 引用该文件
3. 发送消息："请按照这份任务说明完成所有阶段的工作"
4. Agent 会自动读取本文件夹中的各阶段规格文档，逐步执行

等待 Agent 完成后，检查 `data_manage/` 下是否生成了 `lecture_data_manage.ipynb` 和 `data_raw/` 目录。

---

## 本文件夹内容一览

| 文件 | 用途 |
|---|---|
| `task-phase1-env.md` | 阶段1：环境检查与目录准备的详细规格 |
| `task-phase2-data.md` | 阶段2：数据下载规格（股票、指数、宏观、财务） |
| `task-phase3-lecture.md` | 阶段3：讲义结构与各节内容的详细规格 |
| `task-phase4-check.md` | 阶段4：整体自检清单与收尾规格 |
| `context-lecture-style.md` | 讲义写作风格规范（Markdown 格式、代码风格、中文约定） |
| `context-datasets.md` | 四类数据集的教学定位与字段规格 |
| `lecture_get_data.ipynb` | 第一章讲义（供 Agent 参考写作风格） |
| `lecture_data_clean.ipynb` | 第三章讲义（供 Agent 参考写作风格） |
| `phase1_setup.py` | 阶段1辅助脚本（目录创建） |
| `fix_missing_data.py` | 数据修复辅助脚本（处理下载失败的数据集） |
| `test_bs.py` | baostock 接口可用性测试脚本 |

---

## 任务输出（Output）

Agent 完成任务后，会在 `data_manage/` 目录下生成以下文件：

```
data_manage/
├── lecture_data_manage.ipynb       ← 本章讲义主文件（最终交付物）
└── data_raw/
    ├── stock_daily/                ← 10只个股日度行情 CSV（各一个文件）
    ├── index_daily/                ← 沪深300等指数日度 CSV
    ├── macro_monthly/              ← 利率、汇率、CPI 月度 CSV
    ├── fin_annual/                 ← 年度财务指标 CSV
    ├── company_info.csv            ← 公司基本信息（截面）
    └── download_log.txt            ← 下载日志（记录成功/失败情况）
```

讲义 `lecture_data_manage.ipynb` 从头运行应无报错，所有数字均来自本地真实数据。

---

## 背景：为什么这样组织任务

传统方式是把所有任务说明写在一个很长的提示词里，容量有限，细节容易丢失。

这里采用的方案是**分层文档结构**：
- `agent-task.md`：总纲，说明任务全貌和阶段划分（Agent 的入口）
- `task-phase*.md`：每个阶段的详细操作规格（Agent 按需读取）
- `context-*.md`：背景知识上下文（Agent 按需参考）

这种结构的好处是：每个文档聚焦单一责任，Agent 在执行某阶段时只需加载对应文档，不会被无关信息干扰；同时人类读者也可以独立阅读各文档，理解任务设计思路。
