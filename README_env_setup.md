# 虚拟环境配置指南

> 课程：金融数据分析与建模 | Website: https://lianxhcn.github.io/dsfin/

---

## 目录

1. [为什么只需要一个环境？](#1-为什么只需要一个环境)
2. [前置条件](#2-前置条件)
3. [创建虚拟环境（一步完成）](#3-创建虚拟环境一步完成)
4. [配置 nbstata（Stata 内核）](#4-配置-nbstata-stata-内核)
5. [验证安装](#5-验证安装)
6. [日常使用流程](#6-日常使用流程)
7. [维护与更新](#7-维护与更新)
8. [常见问题](#8-常见问题)

---

## 1. 为什么只需要一个环境？

你最初担心需要两个环境（一个 Python 3.11 + nbstata，一个 Python 3.12 纯 Python），  
但其实 **一个 Python 3.11 环境就够了**，原因如下：

| 考虑因素 | 结论 |
|----------|------|
| nbstata 限制 | 要求 Python < 3.12，所以必须用 3.11 |
| 纯 Python 章节 | Python 3.11 完全兼容所有用到的包 |
| 维护成本 | 一个环境维护更简单，学生配置也更简单 |
| 包冲突风险 | 无需担心两个环境之间的冲突 |

> 💡 只有在 Python 3.12 中有不可替代的特性，且该特性与 nbstata 有冲突时，才需要拆分环境。你的课程没有这种情况。

---

## 2. 前置条件

### 安装 Anaconda

如果尚未安装，请从官网下载：https://www.anaconda.com/download

> **建议**：安装时勾选"Add Anaconda to PATH"（Windows），或按提示将 conda 加入 shell（macOS）。

### 安装 Stata（仅用于 nbstata 章节）

- 需要已安装 Stata 17 或更高版本
- Windows 默认路径：`C:\Program Files\Stata17\`（或 Stata18/Stata19）
- macOS 默认路径：`/Applications/Stata/`

---

## 3. 创建虚拟环境（一步完成）

### 第一步：下载配置文件

将本仓库 Clone 或 Fork 到本地：

```bash
git clone https://github.com/lianxhcn/dsfin.git
cd dsfin
```

### 第二步：创建环境

打开 **Anaconda Prompt**（Windows）或 **Terminal**（macOS），运行：

```bash
conda env create -f env_dsfin_py311.yml
```

> 首次创建约需 5~15 分钟，取决于网络速度。

### 第三步：激活环境

```bash
conda activate dsfin_py311
```

激活成功后，命令行前缀会变为 `(dsfin_py311)`。

---

## 4. 配置 nbstata（Stata 内核）

> **仅需做一次**，之后每次用 `conda activate dsfin_py311` 激活环境即可。

### 激活环境后，运行以下命令：

```bash
conda activate dsfin_py311
python -m nbstata.install
```

#### 如果 nbstata 无法自动找到 Stata，手动指定路径：

**Windows**（根据你的 Stata 版本修改路径）：
```bash
python -m nbstata.install --stata-dir "C:\Program Files\Stata18"
```

**macOS**：
```bash
python -m nbstata.install --stata-dir "/Applications/Stata"
```

### 验证 Stata 内核是否安装成功：

```bash
jupyter kernelspec list
```

输出中应包含 `stata`：

```
Available kernels:
  python3       /Users/.../envs/dsfin_py311/share/jupyter/kernels/python3
  stata         /Users/.../share/jupyter/kernels/stata
```

---

## 5. 验证安装

激活环境后，运行以下 Python 代码验证关键包：

```bash
conda activate dsfin_py311
python -c "
import pandas as pd
import numpy as np
import matplotlib
import statsmodels
import sklearn
import akshare as ak
import jieba
import nbstata
print('✅ 所有关键包验证通过！')
print(f'   pandas     {pd.__version__}')
print(f'   numpy      {np.__version__}')
print(f'   matplotlib {matplotlib.__version__}')
print(f'   akshare    {ak.__version__}')
"
```

---

## 6. 日常使用流程

### 启动 Jupyter Lab（推荐）

```bash
conda activate dsfin_py311
jupyter lab
```

### 或启动经典 Notebook

```bash
conda activate dsfin_py311
jupyter notebook
```

### 在 Notebook 中切换内核

- 纯 Python 章节：选择内核 `Python 3 (ipykernel)`
- Stata 章节：选择内核 `Stata`

> 在 Jupyter Lab 中，点击右上角的内核名称即可切换。

---

## 7. 维护与更新

### 导师（连老师）更新环境配置后，学生同步更新：

```bash
# 1. 拉取最新代码
git pull origin main

# 2. 更新环境（自动安装新增的包）
conda activate dsfin_py311
conda env update -f env_dsfin_py311.yml --prune
```

> `--prune` 参数会自动移除配置文件中已删除的包，保持环境干净。

### 导出当前环境（连老师维护时使用）：

```bash
conda activate dsfin_py311

# 方式一：精确导出（含完整依赖树，可完全复现，但跨平台可能有问题）
conda env export > env_dsfin_py311_full.yml

# 方式二：仅导出主动安装的包（推荐用于跨平台共享）
conda env export --from-history > env_dsfin_py311.yml
```

### 清理 conda 缓存（节省磁盘空间）：

```bash
conda clean --all
```

---

## 8. 常见问题

### Q1：创建环境时报错 `PackagesNotFoundError`

**原因**：某些包在 conda-forge 中找不到。

**解决**：先用 conda 创建基础环境，再用 pip 安装缺失的包：

```bash
conda activate dsfin_py311
pip install 包名
```

---

### Q2：macOS Apple Silicon（M1/M2/M3）上某些包安装失败

**解决**：在创建环境时指定平台：

```bash
CONDA_SUBDIR=osx-arm64 conda env create -f env_dsfin_py311.yml
```

或在 Rosetta 终端下运行（强制使用 x86 模式）。

---

### Q3：`nbstata` 找不到 Stata

**解决**：手动设置 Stata 路径（参见第 4 节），或创建配置文件：

在你的主目录下创建 `~/.nbstata.conf`（macOS/Linux）或 `%USERPROFILE%\.nbstata.conf`（Windows）：

```ini
[stata]
stata_dir = /Applications/Stata   # macOS 示例
# stata_dir = C:\Program Files\Stata18  # Windows 示例
```

---

### Q4：`akshare` 获取数据时报网络错误

**原因**：部分数据源在国内访问受限。

**解决**：使用代理，或改用其他数据源（详见课程讲义）。

---

### Q5：`conda activate` 后命令行没有变化

**解决**（macOS/Linux）：

```bash
conda init zsh     # 或 conda init bash（根据你的 shell）
# 重启终端后再试
```

---

### Q6：如何删除环境重新来过？

```bash
conda deactivate              # 先退出当前环境
conda env remove -n dsfin_py311  # 删除环境
conda env create -f env_dsfin_py311.yml  # 重新创建
```

---

## 附：环境信息速查

| 项目 | 内容 |
|------|------|
| 环境名称 | `dsfin_py311` |
| Python 版本 | 3.11 |
| 配置文件 | `env_dsfin_py311.yml` |
| 激活命令 | `conda activate dsfin_py311` |
| 支持系统 | Windows 10/11, macOS 12+ |
| Jupyter 内核 | Python 3 + Stata |

---

*如有问题，请在 GitHub Issues 中提交：https://github.com/lianxhcn/dsfin/issues*
