# Agent Task：第二章讲义完整生成任务

## 本文件的用途

这是一份交给 VS Code Chat Agent 的任务说明书。将本文件内容粘贴给 Agent（或在 Chat 中引用），Agent 即可按阶段自主完成第二章讲义的生成。

**本文件位置：** `Lecture/data_manage/agent-task.md`

---

## 你是谁，你在做什么

你是一个在 VS Code 中运行的 Chat Agent。   
你的任务是在本地完整生成「金融数据分析与建模」课程第二章的所有文件。

这一章夹在已有的两章之间：
- 第一章：`data_get_data/lecture_get_data.ipynb`（金融数据获取）
- **第二章（本章）：`data_manage/lecture_data_manage.ipynb`（数据管理与组织）← 你要生成**
- 第三章：`data_clean/lecture_data_clean.ipynb`（数据清洗）

---

## 本文件夹结构

执行任务前，请确认以下目录结构（相对于 `Lecture/data_manage/`）：

```
data_manage/
├── agent-task.md                      ← 本任务说明书（当前文件）
├── agent-task/                        ← 任务规格文档（只读，勿修改）
│   ├── task-phase1-env.md             ← 阶段1详细规格
│   ├── task-phase2-data.md            ← 阶段2详细规格
│   ├── task-phase3-lecture.md         ← 阶段3详细规格
│   ├── task-phase4-check.md           ← 阶段4详细规格
│   ├── context-lecture-style.md       ← 讲义写作风格参考
│   ├── context-datasets.md            ← 数据集设计规格
│   ├── lecture_get_data.ipynb         ← 第一章讲义（风格参考）
│   ├── lecture_data_clean.ipynb       ← 第三章讲义（风格参考）
│   ├── phase1_setup.py                ← 阶段1辅助脚本
│   ├── fix_missing_data.py            ← 数据修复辅助脚本
│   └── test_bs.py                     ← baostock 接口测试脚本
├── codes/                             ← 数据下载脚本
│   ├── codes_get_data.py              ← 主数据下载脚本（阶段2运行）
│   └── codes_get_data_basic_info.ipynb
├── data_raw/                          ← 下载的原始数据（阶段2生成）
│   ├── stock_daily/                   ← 10只个股日度 CSV（各一个文件）
│   ├── index_daily/                   ← 市场指数日度 CSV
│   ├── macro_monthly/                 ← 宏观月度 CSV（利率、汇率、CPI）
│   ├── fin_annual/                    ← 年度财务指标 CSV
│   ├── company_info.csv               ← 公司基本信息（截面）
│   ├── company_industry_panel.csv     ← 公司行业面板数据
│   └── download_log.txt               ← 下载日志（自动生成）
└── lecture_data_manage.ipynb          ← 本章讲义主文件（阶段3生成，最终交付物）
```

---

## 任务总览

你需要按顺序完成以下四个阶段，**每个阶段完成后必须自我检查，确认通过再进入下一阶段**：

```
阶段 1：环境检查与目录准备
阶段 2：运行 codes/codes_get_data.py，下载并验证数据
阶段 3：生成讲义 lecture_data_manage.ipynb
阶段 4：整体自检与收尾
```

详细规格见 `agent-task/` 文件夹中各阶段的专属文档：
- `agent-task/task-phase1-env.md`
- `agent-task/task-phase2-data.md`
- `agent-task/task-phase3-lecture.md`
- `agent-task/task-phase4-check.md`

---

## 最终交付物

任务完成后，以下文件必须存在且可运行：

```
data_manage/
├── lecture_data_manage.ipynb          ← 本章讲义（从头运行无报错）
└── data_raw/
    ├── stock_daily/                   ← 10只个股日度 CSV
    ├── index_daily/                   ← 市场指数日度 CSV
    ├── macro_monthly/                 ← 宏观月度 CSV
    ├── fin_annual/                    ← 年度财务指标 CSV
    ├── company_info.csv
    └── download_log.txt
```

---

## 关键原则（必须遵守）

1. **数据优先**：讲义中所有涉及具体数字的地方（行数、时间范围、速度对比），必须基于本地真实运行结果填写，不得编造。

2. **容错处理**：akshare 部分接口可能因网络或限频失败。遇到失败时，记录到 `data_raw/download_log.txt`，用备用方案（见 `agent-task/task-phase2-data.md`），不要中断整个任务。

3. **风格一致**：讲义的写作风格必须与第一章、第三章保持一致。详见 `agent-task/context-lecture-style.md`，参考文件见 `agent-task/lecture_get_data.ipynb` 和 `agent-task/lecture_data_clean.ipynb`。

4. **顺序执行**：严格按阶段顺序执行，不要跳过。阶段2的数据是阶段3讲义的素材来源。

5. **中文输出**：所有讲义内容、注释、说明均使用中文。代码注释使用中文。

---

## 出现问题时怎么办

| 问题类型 | 处理方式 |
|---|---|
| akshare 接口报错 | 见 `agent-task/task-phase2-data.md` 的备用方案，换用 baostock 或生成模拟数据 |
| 某只股票数据下载失败 | 跳过该股票，记录日志，用剩余股票继续 |
| 数据行数与预期不符 | 记录实际行数，讲义中使用实际数字 |
| 不确定讲义某节如何写 | 参考 `agent-task/context-lecture-style.md` 和 `agent-task/task-phase3-lecture.md` 的详细规格 |

---

## 给课程老师的说明

所有 agent 规格文档由 Claude 预先设计，覆盖了数据集选股逻辑、讲义结构、写作风格、容错方案等细节。Agent 在本地执行时会自主完成，你睡醒后检查以下三点即可：

1. `data_raw/download_log.txt`：确认哪些数据下载成功
2. `data_raw/` 目录：确认文件是否齐全
3. 打开 `lecture_data_manage.ipynb`，从头运行一遍

如有个别数据缺失，参考 `download_log.txt` 中的说明手动补充。
