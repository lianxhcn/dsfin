# 阶段 4：整体自检与收尾

## 目标

确认所有交付物完整、可运行，并生成一份给老师的验收报告。

---

## 步骤 4.1：文件完整性检查

运行以下代码：

```python
from pathlib import Path

required_files = [
    "codes_get_data.ipynb",
    "lecture_data_manage.ipynb",
    "data_raw/download_log.txt",
    "data_raw/company_info.csv",
    "data_raw/fin_annual/fin_indicators.csv",
    "data_raw/stock_daily/000001.csv",
    "data_raw/stock_daily/600519.csv",
    "data_raw/index_daily/000300.csv",
    "data_raw/macro_monthly/shibor_3m.csv",
    "data_raw/macro_monthly/cpi_monthly.csv",
]

base = Path("data_manage")
print("文件完整性检查：")
all_ok = True
for f in required_files:
    p = base / f
    status = "✓" if p.exists() else "✗ 缺失"
    if not p.exists():
        all_ok = False
    size = f"{p.stat().st_size/1024:.1f} KB" if p.exists() else ""
    print(f"  {status}  {f}  {size}")

print(f"\n整体状态：{'全部通过' if all_ok else '有文件缺失，请检查 download_log.txt'}")
```

---

## 步骤 4.2：数据摘要汇总

```python
import pandas as pd
from pathlib import Path
import glob

base = Path("data_manage/data_raw")

print("=" * 60)
print("数据集摘要")
print("=" * 60)

# stock_daily
files = glob.glob(str(base / "stock_daily/*.csv"))
csv_files = [f for f in files if f.endswith('.csv')]
if csv_files:
    dfs = [pd.read_csv(f) for f in csv_files]
    df_all = pd.concat(dfs)
    print(f"\n个股日度 (stock_daily)：")
    print(f"  文件数：{len(csv_files)} 只股票")
    print(f"  总行数：{len(df_all):,}")
    print(f"  时间范围：{df_all['date'].min()} ~ {df_all['date'].max()}")
    print(f"  缺失值：{df_all.isnull().sum().sum()}")

# company_info
p = base / "company_info.csv"
if p.exists():
    df = pd.read_csv(p)
    print(f"\n公司信息 (company_info)：{len(df)} 行")
    print(df[['code','name','industry_l1','ownership']].to_string(index=False))

# fin_annual
p = base / "fin_annual/fin_indicators.csv"
if p.exists():
    df = pd.read_csv(p)
    print(f"\n年度财务 (fin_annual)：{len(df)} 行，年份：{sorted(df['year'].unique())}")
```

---

## 步骤 4.3：讲义快速验证

打开 `lecture_data_manage.ipynb`，运行前 5 个 code cell，确认：

- [ ] 无 `ImportError`
- [ ] mini-dataset 能正常构造和展示
- [ ] SQLite 建库成功（`finance.db` 文件已生成）
- [ ] 至少一个 SQL 查询有输出

---

## 步骤 4.4：生成验收报告

```python
from datetime import datetime
from pathlib import Path
import glob

report_path = Path("data_manage/COMPLETION_REPORT.md")

lines = [
    "# Agent 任务完成报告",
    f"\n生成时间：{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
    "\n## 数据下载结果",
]

# 读取下载日志摘要
log_path = Path("data_manage/data_raw/download_log.txt")
if log_path.exists():
    with open(log_path, encoding='utf-8') as f:
        lines.append("\n```")
        lines.append(f.read())
        lines.append("```")

lines += [
    "\n## 文件清单",
    "```",
]
for p in sorted(Path("data_manage").rglob("*")):
    if p.is_file() and '.ipynb_checkpoints' not in str(p):
        size = p.stat().st_size / 1024
        lines.append(f"{p.relative_to('data_manage')}  ({size:.1f} KB)")
lines.append("```")

lines += [
    "\n## 老师须知",
    "1. 请先检查本报告中的数据下载结果，确认无误",
    "2. 打开 `lecture_data_manage.ipynb`，从头运行，确认全部 cell 无报错",
    "3. 如有个别数据下载失败，参考 `data_raw/download_log.txt` 手动补充",
    "4. Parquet 文件和 SQLite 数据库在首次运行 `lecture_data_manage.ipynb` 时自动生成",
]

with open(report_path, "w", encoding="utf-8") as f:
    f.write("\n".join(lines))

print(f"验收报告已生成：{report_path}")
```

---

## 最终交付物确认清单

- [ ] `codes_get_data.ipynb`：已运行完毕，数据已下载
- [ ] `lecture_data_manage.ipynb`：已生成，前5个cell可运行
- [ ] `data_raw/`：所有子目录和文件齐全
- [ ] `data_raw/download_log.txt`：记录完整
- [ ] `COMPLETION_REPORT.md`：已生成

**任务完成。** 老师醒来后查看 `COMPLETION_REPORT.md` 即可了解整体情况。
