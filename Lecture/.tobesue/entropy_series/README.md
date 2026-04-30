# Entropy 推文系列

本文件夹包含三篇推文的 `lec.ipynb` 与 `codes.ipynb`。

## 文件结构

```text
entropy_series/
├─ 01_entropy_intro_lec.ipynb
├─ 01_entropy_intro_codes.ipynb
├─ 02_entropy_conditional_tree_lec.ipynb
├─ 02_entropy_conditional_tree_codes.ipynb
├─ 03_entropy_crossentropy_weighting_lec.ipynb
├─ 03_entropy_crossentropy_weighting_codes.ipynb
├─ figs/
└─ data/
```

## 推荐执行顺序

1. 运行 `01_entropy_intro_codes.ipynb`，生成第 1 篇所需插图和示例数据。
2. 打开或运行 `01_entropy_intro_lec.ipynb`。
3. 运行 `02_entropy_conditional_tree_codes.ipynb`，生成第 2 篇所需插图和示例数据。
4. 打开或运行 `02_entropy_conditional_tree_lec.ipynb`。
5. 运行 `03_entropy_crossentropy_weighting_codes.ipynb`，生成第 3 篇所需插图和模拟数据。
6. 打开或运行 `03_entropy_crossentropy_weighting_lec.ipynb`。

## 本版主要调整

- 修正了 log-likelihood 的表述：likelihood 不能简单等同于概率；对于连续变量尤其应理解为密度函数下的相对支持。
- 修正了 entropy 的表述：普通 entropy 衡量概率分布的平均信息量或平均不确定性；“还剩多少不确定性”主要用于 conditional entropy。
- 所有图形标题中的 `log_2` 改用 mathtext 表示，避免 Unicode 下标在本地环境中显示为乱码。
- 重画了决策树 split 图，使其更紧凑、更彩色，并直接呈现类别分布、节点熵和信息增益。
- 将协变量平衡图改为 Love plot 风格，避免“图例有颜色但柱形不可见”的问题。
- 将权重分布图改为排序权重诊断图，并加入 95 分位数和 ESS，便于判断是否存在少数样本权重过大。
- 三篇 `lec.ipynb` 的正文均有所扩展，并加入了可独立运行的 Python 示例代码与 Quarto callout。

## Windows 字体说明

`codes.ipynb` 在 Windows 系统下默认使用 `SimHei`。若你的本地环境仍出现中文字体警告，可在 setup 代码块中把：

```python
FONT_FAMILY = 'SimHei'
```

改为你本机可用的中文字体，例如 `Microsoft YaHei`。
