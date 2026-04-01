# 阶段 1：环境检查与目录准备

## 目标

确认本地 Python 环境满足要求，创建所有必要目录，安装缺失的包。

---

## 步骤 1.1：检查 Python 环境

在终端运行：

```bash
python --version
pip list | grep -E "akshare|baostock|duckdb|pyarrow|pandas|sqlalchemy"
```

**预期结果：**
- Python >= 3.8
- 以下包已安装（版本不限）：pandas、akshare、duckdb、pyarrow

---

## 步骤 1.2：安装缺失的包

如果上一步有包缺失，运行：

```bash
pip install akshare baostock duckdb pyarrow sqlalchemy jupyter
```

安装完成后再次运行步骤 1.1 确认。

---

## 步骤 1.3：创建目录结构

运行以下 Python 代码：

```python
from pathlib import Path

base = Path("lecture_data_manage")
dirs = [
    "data_raw/stock_daily",
    "data_raw/index_daily", 
    "data_raw/macro_monthly",
    "data_raw/fin_annual",
]
for d in dirs:
    (base / d).mkdir(parents=True, exist_ok=True)

print("目录创建完成：")
for d in sorted(base.rglob("*")):
    if d.is_dir():
        print(f"  {d}/")
```

---

## 步骤 1.4：写入初始下载日志

```python
from pathlib import Path
from datetime import datetime

log_path = Path("lecture_data_manage/data_raw/download_log.txt")
with open(log_path, "w", encoding="utf-8") as f:
    f.write(f"下载日志\n")
    f.write(f"创建时间：{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
    f.write("=" * 60 + "\n\n")

print(f"日志文件已创建：{log_path}")
```

---

## 阶段 1 自检

- [ ] Python >= 3.8
- [ ] akshare、duckdb、pyarrow、pandas 均已安装
- [ ] `data_raw/` 下的四个子目录均已创建
- [ ] `download_log.txt` 已存在

全部通过后，进入阶段 2。
