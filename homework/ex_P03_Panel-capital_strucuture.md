## 上市公司资本结构影响因素分析：面板数据模型实证

> **作业性质**：个人作作业-exP03（独立完成）
> **完成时间**：1 周  
> **数据来源**：CSMAR（中国股票市场与会计研究数据库）  
> **样本区间**：2010-2025 年（年度数据）  
> **工具**：Stata（主线）或 Python，使用 Jupyter Notebook 完成 (若你的 Stata 安装目录下没有 `STATA.LIC` 文件，可以在课程群中联系助教，获取 Stata 许可证文件)；在 Jupyter Notebook 中使用 Stata 的配置方法参见 [2.3 配置 Stata 环境：nbstata](https://lianxhcn.github.io/dsfin/Lecture/00-setup/01_01_install_anaconda.html#%E9%85%8D%E7%BD%AE-stata-%E7%8E%AF%E5%A2%83nbstata)
> **提交方式**：见文末「提交要求」

---

### 研究背景与问题

资本结构是公司财务领域的核心议题。两大主流理论对同一现象给出了截然相反的预测：

- **权衡理论（Trade-off Theory）**：企业在债务税盾收益和财务困境成本之间寻求平衡。盈利能力越强，税盾价值越大、偿债能力越强，故预测 $NPR$ 与 $Lev$ **正相关**。
- **优序融资理论（Pecking Order Theory）**：企业按照内源融资 → 债务融资 → 股权融资的顺序选择资金来源。盈利能力越强，内源资金越充裕，对外部债务的需求越低，故预测 $NPR$ 与 $Lev$ **负相关**。

本作业以 A 股上市公司为样本，通过多种面板数据模型系统检验两个理论的预测，并进一步分析产权性质（SOE）对这一关系的调节作用，以及 NPR-Lev 关系随时间和企业规模的异质性。

---

### 第一部分：数据获取与处理

#### 1.1 数据下载

登录 CSMAR，分别下载以下数据表，时间范围均为 **2010-2025 年**，存入 `data/raw/` 文件夹：

| 数据表 | CSMAR 模块 | 建议文件名 | 用途 |
|--------|-----------|-----------|------|
| 资产负债表 | 财务报表 → 资产负债表 | `balance_sheet.csv` | Lev、Size、Tangibility、NDTS |
| 利润表 | 财务报表 → 利润表 | `income_stmt.csv` | NPR（净利润） |
| 现金流量表 | 财务报表 → 现金流量表 | `cashflow.csv` | NDTS（折旧摊销） |
| 股权性质 | 公司特征 → 实际控制人性质 | `ownership.csv` | SOE 虚拟变量 |
| 行业分类 | 公司特征 → 行业分类（证监会） | `industry.csv` | 行业固定效应 |
| ST/PT 标记 | 公司特征 → 交易状态 | `st_flag.csv` | 样本筛选 |
| M2 增长率 | 宏观经济 → 货币供应量 | `m2.csv` | 交互固定效应模型 |

> **注意**：以上指标可能分布在不同子库中，需分别下载后合并。建议先各自下载为 CSV，再在 Notebook 中用 Python/Stata 合并，不要手动在 Excel 中操作。

#### 1.2 变量构造

所有变量以**年报数据**为准（使用年末值），按如下定义计算：

**因变量**

$$Lev_{it} = \frac{\text{总负债}_{it}}{\text{总资产}_{it}}$$

**核心解释变量**

$$NPR_{it} = \frac{\text{净利润}_{it}}{\text{总资产}_{it}}$$

**控制变量（必做）**

| 变量 | 定义 | 预期符号 |
|------|------|---------|
| $Size_{it}$ | $\ln(\text{总资产}_{it})$ | + |
| $Tang_{it}$ | 固定资产净值 / 总资产 | + |
| $Growth_{it}$ | $(\text{总资产}_{it} - \text{总资产}_{it-1}) / \text{总资产}_{it-1}$ | − |
| $NDTS_{it}$ | 折旧与摊销 / 总资产 | − |
| $SOE_i$ | 国有企业=1，民营企业=0 | + |

> ⚠️ **滞后计算提醒**：$Growth_{it}$ 需要 $t-1$ 期的总资产，在 Stata 中须先 `xtset stkcd year`，再用 `L.totalassets` 计算；Python 中须按 `(stkcd, year)` 排序后使用 `.groupby('stkcd')['totalassets'].shift(1)`。漏掉 `xtset` 或忘记按公司分组就做滞后，是最常见的错误。

**控制变量（选做）**

$$Liq_{it} = \frac{\text{流动资产}_{it}}{\text{流动负债}_{it}}$$

**宏观变量（交互固定效应模型专用）**

$$m2\_growth_t = \frac{M2_t - M2_{t-1}}{M2_{t-1}} \times 100$$

这是年度宏观变量，只随时间变化，不随个体变化（即纯时间序列变量）。

#### 1.3 样本筛选

按顺序执行以下筛选，并**在 Notebook 中记录每步筛选后的样本量变化**：

```
初始样本（2010-2025，全部 A 股）
  → 剔除金融、保险行业（证监会行业代码 J 开头）
  → 剔除曾被 ST/PT 处理的公司（保守处理：只要曾被 ST 过，全部年度均剔除）
  → 剔除资不抵债样本（Lev > 1）
  → 剔除关键变量缺失的观测
  → 最终样本
```

呈现样本筛选流程表：

| 筛选步骤 | 剔除观测数 | 剩余观测数 | 剩余公司数 |
|---------|----------|----------|----------|
| 初始样本 | — | | |
| 剔除金融保险 | | | |
| 剔除 ST/PT | | | |
| 剔除 Lev > 1 | | | |
| 剔除缺失值 | | | |
| **最终样本** | | | |

#### 1.4 行业分类处理

按证监会行业分类标准构造行业哑变量，规则如下：

- **制造业**（代码 C）：使用 **2 位数**行业代码（如 C13、C14……）
- **其他行业**：使用 **1 位数**行业代码（如 A、B、D、E……）
- 若某个 2 位数制造业子行业样本量 < 30，将其合并至"其他制造业"类别

在回归中，行业效应通过 `absorb(ind_code)` 或个体固定效应（已包含行业信息）处理，无需手动生成哑变量。

#### 1.5 异常值处理（Winsorize）

对以下连续变量在**截面层面**（每年分别）进行双侧 1% Winsorize：

| 变量 | 是否 Winsorize | 说明 |
|------|--------------|------|
| $Lev$ | ✅ | 已剔除 >1 的样本，仍需处理下尾 |
| $NPR$ | ✅ | 净利润率分布有较厚尾部 |
| $Tang$ | ✅ | |
| $Growth$ | ✅ | 成长率极端值较多 |
| $NDTS$ | ✅ | |
| $Size$ | ❌ | 对数变换已缓解极值 |
| $SOE$ | ❌ | 二值变量 |
| $Liq$（选做）| ✅ | |

绘制 $Lev$、$NPR$、$Growth$ 的 Winsorize **前后箱型图对比**，直观展示处理效果。

---

### 第二部分：描述性统计

#### 2.1 主要变量描述性统计

计算以下统计量，**分全样本、SOE、非SOE 三组**呈现：

| 变量 | N | Mean | SD | P10 | P25 | Median | P75 | P90 |
|------|---|------|-----|-----|-----|--------|-----|-----|
| Lev | | | | | | | | |
| NPR | | | | | | | | |
| Size | | | | | | | | |
| Tang | | | | | | | | |
| Growth | | | | | | | | |
| NDTS | | | | | | | | |

并对 SOE 与非SOE 之间的均值差异进行 t 检验，标注显著性星号。

#### 2.2 相关系数矩阵

计算主要变量的 Pearson 相关系数矩阵，并标注 5% 显著性水平：

|  | Lev | NPR | Size | Tang | Growth | NDTS | SOE |
|--|-----|-----|------|------|--------|------|-----|
| Lev | 1 | | | | | | |
| NPR | | 1 | | | | | |
| Size | | | 1 | | | | |
| Tang | | | | 1 | | | |
| Growth | | | | | 1 | | |
| NDTS | | | | | | 1 | |
| SOE | | | | | | | 1 |

重点讨论：(1) $NPR$ 与 $Lev$ 的相关系数方向；(2) $Size$ 与 $NPR$ 的相关系数（为后续函数系数模型的信息不对称假设提供初步证据）；(3) 是否存在严重的多重共线性（相关系数 > 0.7）。

#### 2.3 时序趋势图

绘制以下时序图（按 SOE/非SOE 分组）：

- **图 1**：样本均值 $Lev_t$ 的时序趋势（2010-2025）
- **图 2**：样本均值 $NPR_t$ 的时序趋势（2010-2025）
- **图 3**：$Lev$ 分布的分年度箱型图，观察杠杆率分布的时序变化

---

### 第三部分：模型估计

#### 模型 M1：双向固定效应基准模型（TWFE）

$$Lev_{it} = \alpha_i + \lambda_t + \beta \cdot NPR_{it} + \boldsymbol{\gamma}' \boldsymbol{X}_{it} + \varepsilon_{it}$$

其中 $\alpha_i$ 为公司固定效应，$\lambda_t$ 为年度固定效应，$\boldsymbol{X}_{it}$ 为控制变量向量。

**Stata 实现（主线）**：

```stata
* 安装包（如未安装）
* ssc install reghdfe
* ssc install ftools

reghdfe lev npr size tang growth ndts, ///
    absorb(stkcd year) ///
    vce(cluster stkcd year)   // 双向聚类标准误

* 查看结果
estimates store m1
```

**Python 实现（备选，使用 pyfixest）**：

```python
# pip install pyfixest
import pyfixest as pf

fit = pf.feols(
    "lev ~ npr + size + tang + growth + ndts | stkcd + year",
    data=df,
    vcov={"CRV1": "stkcd + year"}   # 双向聚类标准误
)
fit.summary()
```

**呈现要求**：

- 汇报系数、标准误（括号内）、t 值、显著性星号（\*p<0.1, \*\*p<0.05, \*\*\*p<0.01）
- 汇报 $R^2$（within）、观测数、公司数
- 明确注明：标准误已在公司和年度层面双向聚类

**必须回答**：$\hat{\beta}$ 的符号是正还是负？这支持哪种理论？结论是否有统计显著性？

#### 模型 M1'：交互固定效应（IFE）——稳健性检验

$$Lev_{it} = \alpha_i + \beta \cdot NPR_{it} + \theta \cdot m2\_growth_t + \boldsymbol{\lambda}_i' \boldsymbol{f}_t + \boldsymbol{\gamma}' \boldsymbol{X}_{it} + \varepsilon_{it}$$

其中 $\boldsymbol{\lambda}_i' \boldsymbol{f}_t$ 为交互固定效应（interactive fixed effects），用于控制不可观测的时变因素（如宏观经济冲击对不同企业的异质性影响）。模型同时包含可观测的宏观变量 $m2\_growth_t$。

**动机**：M1 中的时间固定效应 $\lambda_t$ 假设宏观冲击对所有公司的影响是同质的。如果不同规模、不同行业的公司对宏观货币政策的敏感性不同，M1 的 $\hat{\beta}$ 就可能存在偏误。IFE 通过估计 $r$ 个潜在因子来吸收这种异质性。

**Stata 实现**：

```stata
* 安装包（如未安装）
* ssc install regife, replace
* 注：regife 为 Stata 外部命令，具体安装方式请参考课堂讲义
```

**与 M1 的比较**：

- 对比 M1 和 M1' 中 $\hat{\beta}$ 的大小和显著性是否有显著变化
- 对比 $\hat{\theta}$（M2 增长率的系数）：M2 增长率对企业杠杆率是否有显著影响？方向如何？
- 讨论：引入 IFE 后结论是否稳健？

#### 模型 M2：分组回归

按 $SOE$ 将样本分为国有企业和民营企业两组，**分别**估计 M1 的基准模型：

```stata
* 国有企业
reghdfe lev npr size tang growth ndts if soe==1, ///
    absorb(stkcd year) vce(cluster stkcd year)
estimates store m2_soe

* 民营企业
reghdfe lev npr size tang growth ndts if soe==0, ///
    absorb(stkcd year) vce(cluster stkcd year)
estimates store m2_private

* 使用 suest 或 test 正式检验两组系数差异
```

**必须回答**：

1. 国有企业和民营企业的 $\hat{\beta}$ 符号是否一致？大小有何差异？
2. 使用系数差异检验（Chow test 或 bootstrapped difference test），两组的 $\hat{\beta}$ 差异是否在统计上显著？
3. 这一差异如何用融资可得性（国有企业的软约束）和信息不对称（民营企业的融资摩擦）来解释？

#### 模型 M3：交互项调节效应

在同一模型中正式检验产权性质的调节作用：

$$Lev_{it} = \alpha_i + \lambda_t + \beta_1 NPR_{it} + \beta_2 (NPR_{it} \times SOE_i) + \beta_3 SOE_i + \boldsymbol{\gamma}' \boldsymbol{X}_{it} + \varepsilon_{it}$$

```stata
gen npr_soe = npr * soe

reghdfe lev npr npr_soe soe size tang growth ndts, ///
    absorb(stkcd year) vce(cluster stkcd year)
```

> **注意**：由于模型中含有 $\alpha_i$（个体固定效应），$SOE_i$ 本身（时不变变量）会被吸收而无法单独估计。这是面板固定效应模型的固有特性，需要在报告中明确说明，并解释交互项系数 $\hat{\beta}_2$ 的含义——它捕捉的是产权性质对 $NPR$-$Lev$ 斜率的调节作用，而非 $SOE$ 对 $Lev$ 水平的直接影响。

**呈现要求**：

- 汇报 $\hat{\beta}_1$（民营企业中 NPR 的效应）和 $\hat{\beta}_1 + \hat{\beta}_2$（国有企业中 NPR 的效应）
- 绘制调节效应图（Margins Plot）：以 $NPR$ 为横轴，$Lev$ 的预测值为纵轴，分 SOE=0 和 SOE=1 两条线

#### 模型 M4：时变系数模型

允许 $\beta$ 随年度变化，检验 NPR-Lev 关系的时序稳定性：(Note: 以下代码只是示例，可能有误，具体实现可能需要根据实际数据结构调整)


$$Lev_{it} = \alpha_i + \sum_{t=2010}^{2025} \beta_t \cdot (NPR_{it} \times \mathbf{1}[Year=t]) + \boldsymbol{\gamma}' \boldsymbol{X}_{it} + \varepsilon_{it}$$

```stata
reghdfe lev i.year#c.npr size tang growth ndts, ///
    absorb(stkcd year) vce(cluster stkcd year)

* 提取各年系数和置信区间，绘制时序图
coefplot, ……

* 绘图
margins, dydx(npr) at(year=(2010(1)2025)) ……

marginsplot, ……
```

**呈现要求**：

- 绘制 $\hat{\beta}_t$ 的时序图，加入 95% 置信区间（error band）
- (可选) 在图中标注重要宏观事件（2015 年股灾、2018 年中美贸易摩擦、2020 年 COVID-19、2022 年经济下行）
- 讨论：NPR-Lev 关系是否发生了结构性变化？转折点大约在哪一年？

#### 模型 M5：函数系数模型（非线性调节效应）

以 $Size$ 作为调节变量，检验信息不对称程度对 NPR-Lev 关系的异质性影响：

$$Lev_{it} = \alpha_i + \lambda_t + \beta(Size_{it}) \cdot NPR_{it} + \boldsymbol{\gamma}' \boldsymbol{X}_{it} + \varepsilon_{it}$$

**理论动机**：规模越小的企业，信息不对称程度越高，外部融资成本越高，越可能依赖内源资金，优序融资理论的预测应更为显著（$\beta$ 更负）；规模越大的企业，信息越透明，融资可得性更强，权衡理论的逻辑更占主导（$\beta$ 趋向正值）。

**方法一**：多项式调节（`reghdfe` + 高阶交互项）

$$\beta(Size_{it}) = \beta_0 + \beta_1 Size_{it} + \beta_2 Size_{it}^2$$

```stata
gen npr_size   = npr * size
gen npr_size2  = npr * size^2

reghdfe lev npr npr_size npr_size2 size tang growth ndts, ///
    absorb(stkcd year) vce(cluster stkcd year)

* 计算边际效应并绘图
margins, dydx(npr) at(size=(20(1)30))
marginsplot, title("β(Size)：NPR 对 Lev 的边际效应随企业规模变化")
```

**方法二**：样条函数系数模型（`xtplfc`）(可选)

该命令的早期版本只支持平衡面板，最新版本已支持非平衡面板。请根据实际数据情况选择使用。

最新版本需要手动下载并安装：<https://gitee.com/kerrydu/xtplfc_Stata/>

```stata
net install xtplfc, from("https://gitee.com/kerrydu/xtplfc_Stata/raw/master/") replace
```

上述新版命令无法执行，可以使用 `ssc install xtplfc, replace` 安装旧版，进而使用 `xtbalance` 将数据转换为平衡面板后运行。

参考课堂讲义（第 29、30 章），使用 `xtplfc` 命令，以 $Size$ 为平滑变量估计非参数形式的 $\beta(Size)$：

```stata
* 安装包（如未安装）
* net install xtplfc, ...

xtplfc lev npr size tang growth ndts, ///
    uv(size) id(stkcd) time(year) ///
    bw(0.2)   // 带宽参数，可调整
```

**呈现要求**：

- 绘制 $\hat{\beta}(Size)$ 关于 $Size$ 的函数图像，加入 95% 置信带
- 在横轴标注样本中 $Size$ 的 P10、P25、Median、P75、P90 分位点
- 讨论：$\beta(Size)$ 是单调的吗？是否存在拐点？经济含义是什么？

#### 模型 M6：门槛模型（稳健性检验）

使用 Hansen (1999) 面板门槛模型，以 $Size$ 为门槛变量，检验 NPR-Lev 关系是否存在离散跳跃（与 M5 的连续函数形式互为稳健性检验）：

$$Lev_{it} = \alpha_i + \beta_1 NPR_{it} \cdot \mathbf{1}[Size_{it} \leq \hat{\gamma}] + \beta_2 NPR_{it} \cdot \mathbf{1}[Size_{it} > \hat{\gamma}] + \boldsymbol{\gamma}' \boldsymbol{X}_{it} + \varepsilon_{it}$$

> ⚠️ **数据要求**：`xthreg` 要求**平衡面板**。需先使用 `xtbalance` 命令将数据转换为平衡面板，再运行门槛模型。

```stata
* 安装包（如未安装）
* ssc install xtbalance
* findit xthreg // 然后根据提示安装

* 转换为平衡面板
xtbalance, range(2010 2025)
* 查看平衡后的样本量变化

* 单门槛检验
xthreg lev npr size tang growth ndts, ///
    thv(size) trim(0.05) nboot(300) id(stkcd) time(year)

* 如通过单门槛检验，可进一步做双门槛
```

**与 M5 比较**：

- 门槛值 $\hat{\gamma}$ 对应的 $Size$ 分位数是多少？与 M5 中 $\hat{\beta}(Size)$ 的拐点位置是否吻合？
- 门槛两侧的 $\hat{\beta}_1$ 和 $\hat{\beta}_2$ 符号和大小，与 M5 的结论是否一致？

**子样本稳健性**：在 2015-2025 子样本上重复 M6，检验门槛效应是否稳健。

---

### 第四部分：结果汇总与报告

#### 4.1 回归结果汇总表

将 M1-M3 的结果汇总为一张标准回归表（参考学术论文格式）：

|  | M1: TWFE | M1': IFE | M2a: SOE | M2b: Non-SOE | M3: 交互项 |
|--|---------|---------|---------|-------------|----------|
| NPR | | | | | |
| NPR × SOE | | | | | — |
| m2_growth | — | | — | — | — |
| Size | | | | | |
| Tang | | | | | |
| Growth | | | | | |
| NDTS | | | | | |
| 公司FE | ✓ | ✓ | ✓ | ✓ | ✓ |
| 年度FE | ✓ | 交互FE | ✓ | ✓ | ✓ |
| 聚类标准误 | 双向 | Robust | 双向 | 双向 | 双向 |
| N | | | | | |
| 公司数 | | | | | |
| Within R² | | | | | |

注：括号内为标准误，\*p<0.1, \*\*p<0.05, \*\*\*p<0.01

#### 4.2 图形输出

所有图形存入 `output/figures/`，须包含：

| 图编号 | 内容 | 对应模型 |
|--------|------|---------|
| Fig 1 | Lev 时序均值（分 SOE/非SOE） | 描述统计 |
| Fig 2 | Winsorize 前后箱型图对比 | 数据处理 |
| Fig 3 | 主要变量相关系数热力图 | 描述统计 |
| Fig 4 | SOE 调节效应边际效应图 | M3 |
| Fig 5 | $\hat{\beta}_t$ 时序图（带置信区间） | M4 |
| Fig 6 | $\hat{\beta}(Size)$ 函数图（带置信带） | M5 |
| Fig 7 | 门槛检验似然比统计量图 | M6 |

#### 4.3 核心讨论问题

报告须用文字回答以下问题（不可只列数字）：

1. **理论检验**：综合 M1-M3 的证据，A 股上市公司资本结构更符合权衡理论还是优序融资理论？这一结论是否因产权性质而异？
2. **时序稳定性**：M4 中 $\hat{\beta}_t$ 在哪些时期出现了明显变化？是否与宏观经济政策（如 2015 年"去杠杆"、2020 年货币宽松）存在关联？
3. **信息不对称机制**：M5 和 M6 的结论是否支持"小企业更符合优序融资理论"的假设？门槛值 $\hat{\gamma}$ 对应的 $Size$（总资产对数值）大约是多少亿元规模？
4. **IFE vs TWFE**：M1' 引入 M2 增长率后，$\hat{\beta}$ 发生了什么变化？这说明什么？

---

### 提交要求

**同时完成以下两种提交方式：**

**① 坚果云压缩包**

- 文件命名：`exP03_姓名.zip`
- 包含：全部 Notebook（`.ipynb`）、`do` 文件（若使用 Stata）、`data/raw/`、`output/`、`README.md`
  - 其中，`readme.md` 中要在文档头部列出你存放作业的 github 仓库链接和基于 github pages 生成的 quarto book 链接。生成 quarto book 的方式，参见 [Quarto Book 教程](https://lianxhcn.github.io/quarto_book/) 和本课程课程网站的 [_quarto.yml](https://github.com/lianxhcn/dsfin/blob/main/_quarto.yml) 配置。
- 要确保你提交的 .zip 文档解压后，能直接打开 Notebook 文件并运行（即数据路径正确，且不需要额外配置环境）

**② GitHub 仓库 + Quarto Book（选做加分）**

- 仓库名称：**`dshw--panel`**，Public
- github 仓库中不能包含原始数据（`data/raw/`），但可以包含清洗后的最终数据（`data/clean/`）和分析结果（`output/`）
- 将分析整理为 Quarto Book，参考 [Quarto Book 教程](https://lianxhcn.github.io/quarto_book/) 和课程网站的 [_quarto.yml](https://github.com/lianxhcn/dsfin/blob/main/_quarto.yml) 配置
- 发布至 GitHub Pages，在 README 中提供链接
- 章节结构建议：
  - Chapter 1: Introduction & Hypotheses
  - Chapter 2: Data & Variables
  - Chapter 3: Empirical Results
  - Chapter 4: Robustness Checks
  - Chapter 5: Conclusion

**`.gitignore` 配置**：

```gitignore
data/raw/
data/clean/*.dta
*.log
.ipynb_checkpoints/
.DS_Store
__pycache__/
```

---

### README.md 要求

```markdown
# 上市公司资本结构影响因素分析

> [作业要求](https://github.com/lianxhcn/dsfin/blob/main/homework/ex_P03_Panel-capital_strucuture.md)

## 个人信息

- 姓名：XXX
- 邮箱：<xxx@example.com>

### 数据来源
- CSMAR，下载时间：XXXX-XX-XX
- 最终样本：XX 个公司，XX 个观测值，XX-XX 年

### 样本筛选流程
（粘贴第 1.3 节的样本筛选流程表）

### 工具
- Stata XX.X（主要建模）/ Python XX（数据处理）
- Jupyter Notebook

### GitHub 仓库
https://github.com/[组长用户名]/dshw--panel

### Quarto Book（如完成）
https://[用户名].github.io/dshw--panel/

### 主要发现（3-5 条）
1. ...
```

---

### 评分标准

| 维度 | 分值 | 说明 |
|------|------|------|
| 数据处理规范性 | 20 分 | 筛选流程表完整、Winsorize 正确、滞后变量处理无误 |
| 描述统计与相关系数 | 10 分 | 表格规范，分组统计，有文字说明 |
| M1-M3 基础模型 | 25 分 | 双向聚类标准误、IFE 对比、交互项解释 |
| M4 时变系数 | 15 分 | $\hat{\beta}_t$ 图规范，有时序解读 |
| M5-M6 变系数与门槛 | 20 分 | 函数图有置信带，门槛检验流程完整，两者对比 |
| 报告质量 | 10 分 | 四个核心讨论问题有实质回答，逻辑清晰 |
| **加分项** | **+15 分** | Quarto Book 发布至 GitHub Pages，排版整洁 |

> **核心提示**：评分重点在于"你是否理解了为什么要做这一步"。同样一个回归，汇报了系数但不知道如何解读，和汇报了系数且能联系权衡理论 vs 优序融资理论进行讨论，是完全不同的水平。四个核心讨论问题没有标准答案，但必须有经济逻辑。
