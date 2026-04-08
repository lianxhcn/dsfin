# HDFE：多维固定效应

## 简介

自从 [Abowd et al. (1999)](https://www.sciencedirect.com/science/article/pii/S0927537119300922#bib0001) 提出双向固定效应模型 (TWFE) 以来，包含多个固定效应的模型被广泛应用于各个领域，如 [劳动经济学](https://www.sciencedirect.com/topics/economics-econometrics-and-finance/labour-market-theory) (参见 [Abowd et al., 2008](https://www.sciencedirect.com/science/article/pii/S0927537119300922#bib0004) 的综述)，教育 (e.g. [Jacob and Lefgren, 2008](https://www.sciencedirect.com/science/article/pii/S0927537119300922#bib0024), [Kramarz et al., 2008](https://www.sciencedirect.com/science/article/pii/S0927537119300922#bib0030), [Jackson, 2013](https://www.sciencedirect.com/science/article/pii/S0927537119300922#bib0023))，健康 (e.g. [Bennett et al., 2015](https://www.sciencedirect.com/science/article/pii/S0927537119300922#bib0007))，以及移民 ([Grogger and Hanson, 2011](https://www.sciencedirect.com/science/article/pii/S0927537119300922#bib0019))。匹配效应模型 (match effecs) 则是在 TWFE 中进一步加入了两个固定效应的交互项。例如，在国际贸易中，进口国 ($i$) 和出口国 ($j$) 的匹配常常是研究的一个兴趣点，此时在模型中加入交互项 $\alpha_i \times \alpha_j$ 能够很好地捕捉这种匹配效应。同理，劳动经济学中「雇主-员工」的匹配也往往与他们各自的特征 (固定效应) 密切相关 (如， [Jovanovic, 1979](https://www.sciencedirect.com/science/article/pii/S0927537119300922#bib0027), [Mortensen, 1978](https://www.sciencedirect.com/science/article/pii/S0927537119300922#bib0032))，因此模型中同行会加入公司和个人个体效应的交互项 (两组虚拟变量的交乘项)。

显然，引入高维固定效应以及它们的交互项，会增加计算难度。本章介绍的方法包含很多巧妙、有效的算法，[^1] 理论基础均源于 FWL 定理。

有关各类 HDFE 模型的介绍，参见 Matyas ( [2017](https://link.springer.com/book/10.1007/978-3-319-60783-2), [PDF](https://link.springer.com/content/pdf/10.1007%2F978-3-319-60783-2.pdf))，涉及内生性问题、空间计量，引力模型，以及 HDFE 在国际贸易、移民、消费者行为、房地产经济等领域的应用。[^2]

本章介绍的各类模型都可以使用 `reghdfe` 命令来实现，详情参见 `help reghdfe`，[Correia - reghdfe 主页](http://scorreia.com/software/reghdfe/)，以及 [连玉君-`reghdfe` 笔记](https://gitee.com/arlionn/stata/wikis/%E9%9D%A2%E6%9D%BF/reghdfe-%E7%AC%94%E8%AE%B0.md?sort_id=5530587)。若对高维固定效应的矩阵运算感兴趣，可以参考 Revesz ([2013](http://www.personal.ceu.hu/staff/repec/pdf/stata-program_document-dofile.pdf))。

在 Google 学术中检索 [“High Dimensional” “Fixed Eﬀects”](https://xs2.dailyheadlines.cc/scholar?hl=zh-CN&as_sdt=0%2C5&as_ylo=2018&q=%22High+Dimensional%22+%22Fixed+E%EF%AC%80ects%22&btnG=)，可以发现高维固定效应模型在各个领域都得到的广泛的应用。

## Frisch-Waugh-Lovell 定理

### 简介

在多元线性回归中，借助「部分回归 」 的思想可以更为深入地理解系数的含义。
「部分回归 」 的基本思想是，当引入控制变量后，若想探究解释变量 $x_1$ 与被解释变量 $y$ 的「干净关系」(在控制了其他因素的前提下，二者的关系)，那么就需要先 「剔除」(partial out) 控制变量 ($x_2, x_3, \cdots$) 对 $y$ 和 $x_1$ 的影响，进而用「剩余部分」的 $y$ 对剩余部分的 $x_1$ 做回归。此类分析的理论基础是著名的 **FWL 定理**。

Frisch-Waugh-Lovell 定理 (简称 FWL 定理) 由 Frisch and Waugh (1933) 和 Lovell (1963) 提出，它阐释了 OLS 回归的一个重要性质，为理解多元回归的系数含义，高效地估计高维固定效应提供了一个重要的理论基础。[^3]在 Stata 中，`reghdfe` 等处理高维固定效应的命令基本原理便是 FWL 定理。此外，在 `ivreg2`, `lasso2` 等命令中经常出现的 `partial()` 选项也是以 FWL 定理为基础的。用于可视化展示多元回归结果的部分回归图命令 `avplot`, `reganat`, `avciplot`, `avciplots` 等也都基于 FWL 定理。[^4]

我们先介绍一下 FWL 定理产生的背景。在早期的时间序列回归模型中常常包含时间趋势项：[^5]

$$
y_{t} = \alpha + x_{1t}\beta_1 + x_{2t}\beta_2 + \theta t + u_{t} \tag{1}
$$

通常有两种处理方法，一种是直接估计 (1)，即 `reg y x1 x2 c.t`；另一种是分别对 $y$, $x_1$ 和 $x_2$ 执行「去时间趋势」处理，[^6]
分别记为 $\tilde{y}$, $\tilde{x}_1$ 和 $\tilde{x}_2$，然后用 $\tilde{y}$ 和 $\tilde{x}_1$ 和 $\tilde{x}_2$ 执行 OLS 估计，此时不再包含时间趋势项。Frisch and Waugh (1933) 采用分块矩阵的方式证实了上述两种方式的等价性。Stata 实操对比结果如下：

```stata
*-时间趋势项 - FWL 定理
	  webuse "lutkepohl2.dta", clear
	  gen t = _n        // Time trend
	  rename (ln_inc ln_consump ln_inv) (y x1 x2)

	  *-method 1: Pooled OLS
	  reg y x1 x2 c.t   // c.t 表示时间趋势项
	  est store full

	  *-method 2: FWL partial OLS
	  reg y  c.t
	      predict e_y , residual  // 残差，去除时间趋势后的 y
	  reg x1 c.t
	      predict e_x1, res       // 去除时间趋势后的 x1
	  reg x2 c.t
	      predict e_x2, res       // 去除时间趋势后的 x2
	  reg e_y e_x1 e_x2           // 不包含 c.t
	  est store FWL

	  esttab full FWL, nogap
--------------------------------------------
                      (1)             (2)
                        y             e_y
--------------------------------------------
x1                  0.964***
                  (19.58)
x2                 0.0544**
                   (2.67)
t                0.000423
                   (0.47)
e_x1                                0.964***
                                  (19.69)
e_x2                               0.0544**
                                   (2.69)
_cons              0.0454       -1.26e-16
                   (0.17)         (-0.00)
--------------------------------------------
N                      92              92
--------------------------------------------
```

将此问题进行扩展，常见的应用包括如下几种情形：

其一，若模型中包含 $K$ 个行业虚拟变量，则直接执行 `reg y x i.industry` 与执行 `reg c_y c_x` 是等价的，其中，`c_y` 表示 $y_i$ 与第 $i$ 家公司所在的行业均值的差值，`c_x` 的定义与之相似。[^7]
当 $K$ 很大时，前者存在计算困难，而后者则不存在这个问题。

其二，当模型中同时包含多组虚拟变量，如 `i.industry i.firm i.year` 时，我们可以多次使用 FWL 定理，逐个击破，这也是 `areg`, `reghdfe`, `ivreg2hdfe`, `regintfe` 等命令估计高维固定效应的基本思路。[^8] 同时，类似的处理思路也可以应用于非线性模型的估计中，如 `ppmlhdfe` 命令——用于估计包含高维固定效应的泊松模型 (Correia et al., [2020](https://journals.sagepub.com/doi/pdf/10.1177/1536867X20909691))；以及广义线性模型 (GLM)，如 Stammann (2018, [PDF](https://arxiv.org/pdf/1707.01815v2.pdf))。

其三，在机器学习和惩罚回归中，需要应对数以百千的变量，FWL 定理也是计算过程中的一个重要工具，详情参见 Yamada ([2017](http://dx.doi.org/10.1080/03610926.2016.1252403), [PDF](https://sci-hub.ee/10.1080/03610926.2016.1252403))。[^9]

### FWL 定理的含义和直观解释

FWL 定理可以用于任何包含两个以上的解释变量的模型中。我们可以解释变量分成两组：

$$
\boldsymbol{y}=\boldsymbol{X}_{1} \boldsymbol{\beta}_{1}+\boldsymbol{X}_{2} \boldsymbol{\beta}_{2}+\text { residuals } \tag{2}
$$

其中，$\boldsymbol{X}_{1}$ 为 $n \times k_{1}$ 维矩阵，$\boldsymbol{X}_{2}$ 为 $n \times k_{2}$，且 $\boldsymbol{X} \equiv\left[\begin{array}{ll}\boldsymbol{X}_{1} & \boldsymbol{X}_{2}\end{array}\right]$，$k=k_{1}+k_{2}$。

例如，$\boldsymbol{X}_{1}$ 可以是一组年度虚拟变量，时间趋势变量，或反映公司个体效应的虚拟变量，等等。$\boldsymbol{X}_{2}$ 为其他有明确含义的解释变量。多数情况下，$\boldsymbol{X}_{1}$ 中的变量个数数量庞大，并非我们关注的重点，但又不得不控制它们，否则便会导致遗漏变量偏误。

FWL 定理的基本结论是：直接对 (2) 执行 OLS 回归得到的 $\widehat{\boldsymbol{\beta}}_2$ 与采用如下 Partial 回归得到的 $\tilde{\boldsymbol{\beta}}_{2}$ 是等价的。同时，两种方法得到的残差向量也是相同的。

1. 用 $y$ 对 $X_{1}$ 执行 OLS 回归，得到残差 $e_{y}$。
2. 用 $X_{2}$ 对 $X_{1}$ 执行 OLS 回归，得到残差向量 $e_{X_{2}}$。说明：如果 $k_2>1$，则执行 $k_2$ 次回归，即用 $X_{2}$ 中的每个变量分别作为被解释变量进行估计。此时，$e_{X_{2}}$ 包含 $k_2$ 列。
3. 用 $e_{y}$ 对 $e_{X_{2}}$ 执行 OLS 回归，得到系数向量 $\tilde{\beta}_{2}$.

上述过程和基本思想可以通过图 1 加以直观解释。

![OLS-venn-01](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/OLS-venn-01.png){width="50%"}



下面的 Stata 代码与图 1 一一对应。

```stata
sysuse "auto.dta", clear
rename (price length weight) (Y X1 X2)
reg    Y X1 X2                         // [1]

reg Y X2
predict e_y, res  //韦恩图: A+B

reg X1 X2
predict e_x, res  //韦恩图: B   or B+F

reg e_y e_x       //韦恩图: B          // [2]
```

### FWL 定理的简单证明

下面给出 FWL 定理的简要证明。更为正式的证明和分析参见 Davidson and MacKinnon ([2004](http://qed.econ.queensu.ca/pub/faculty/mackinnon/econ850/), [PDF](http://qed.econ.queensu.ca/ETM/ETM-davidson-mackinnon-2021.pdf), pp. 62–75)，以及 Lovell (2008)。

假设线性回归方程为：

$$
\mathrm{y}=\mathrm{X} \beta+\varepsilon \tag{3}
$$

其中，$\beta$ 为 $K \times 1$ 的系数向量，$\varepsilon$ 为 $n \times 1$ 的干扰项向量。OLS 估计量 $b$ 满足下式：

$$
X'Xb = X'y \tag{4}
$$

为了便于解释，我们可以把 $X$ 分割为 $X = [x_1, X_2]$，其中 $X_2 = [x_2, ..., x_k]$。
此时，(4) 可以重新表述如下：

$$
\left[\begin{array}{cc}
x_1^{\prime} x_1 & x_1^{\prime} X_2 \\
X_2^{\prime} x_1 & X_2^{\prime} X_2
\end{array}\right]\left[\begin{array}{l}
b_1 \\
b_2
\end{array}\right]=\left[\begin{array}{l}
x_1^{\prime} y \\
X_2^{\prime} y
\end{array}\right]
$$

其中，

$$
X^{\prime} X=\left[\begin{array}{cc}
x_1^{\prime} x_1 & x_1^{\prime} X_2 \\
X_2^{\prime} x_1 & X_2^{\prime} X_2
\end{array}\right], \quad X^{\prime} y=\left[\begin{array}{c}
X_1^{\prime} y \\
X_2^{\prime} y
\end{array}\right], \quad b=\left[\begin{array}{c}
b_1 \\
b_2
\end{array}\right]
$$




由此可以得到如下两个式子：

$$
\begin{gathered}
x_{1}^{\prime} x_{1} b_{1}+x_{1}^{\prime} X_{2} b_{2}=x_{1}^{\prime} y \\
X_{2}^{\prime} x_{1} b_{1}+X_{2}^{\prime} X_{2} b_{2}=X_{2}^{\prime} y
\end{gathered} \tag{6}
$$

也就是说，[^10]

$$
b_2 = (X_2'X_2)^{-1}X_2'(y-x_1b_1) \tag{7}
$$

联想 OLS 估计量的表达式 $b= (X'X^{-1})X'y$，我们可以把 $b_2$ 理解为 用 $(y-x_1b_1)$ 对 $X_2$ 做回归后得到的 $X_2$ 的系数。

经过一些简单的推导，也可以得到 $b_1$ 的估计式：

$$
b_1 = (X_1'M_2X_1)^{-1}X_1'M_2y \tag{8}
$$

其中，$M_2 = I-X_2(X_2'X_2)^{-1}X_2'$。由于 $M_2$ 是对称 (symmetric) 且幂等 (idempotent) 的，因此 $b_1$ 可以重新表述为：

$$
b_1 = (x_1'M_2'M_2x_1)^{-1}x_1'M_2'M_2y=(e_{x1}'e_{x1})^{-1}e_{x1}'e_y \tag{9}
$$

其中，$e_{x1}=M_2x_1$，$e_y=M_2y$。事实上，$e_y=M_2y$ 是 $y$ 对 $X_2$ 做回归后的残差向量，而 $e_{x1}$ 则是 $x_1$ 对 $X_2$ 做回归后的残差的向量。

换个角度来看，$e_y$ 和 $e_{x1}$  也理解为：剔除了 $X_2$ 影响之后的 $y$ 和 $x_1$。因此，用 $e_y$ 与 $e_{x_1}$ 回归，得到的 $e_{x_1}$ 的系数即可反映「当控制了 $X_2$ 之后」， $x_1$ 与 $y$ 的关系。我们也可以绘制 $e_y$ 与 $e_{x_1}$ 之间的散点图，以直观地呈现二者的「干净」关系，相应的 Stata 命令为 `avplot`，``。


<!-- ::: {.callout-note}
### 扩展：多个变量的情形

> Source: Hastie, T., R. J. Tibshirani, J. Friedman. The elements of statistical learning: Data mining, inference, and prediction[M]. 2013. [PDF](https://hastie.su.domains/Papers/ESLII.pdf).

1. Initialize $\mathbf{z}_{0}=\mathbf{x}_{0}=\mathbf{1}$.
2. For $j=1,2, \ldots, p$
Regress $\mathbf{x}_{j}$ on $\mathbf{z}_{0}, \mathbf{z}_{1}, \ldots,, \mathbf{z}_{j-1}$ to produce coefficients $\hat{\gamma}_{\ell j}=$ $\left\langle\mathbf{z}_{\ell}, \mathbf{x}_{j}\right\rangle /\left\langle\mathbf{z}_{\ell}, \mathbf{z}_{\ell}\right\rangle, \ell=0, \ldots, j-1$ and residual vector $\mathbf{z}_{j}=$ $\mathbf{x}_{j}-\sum_{k=0}^{j-1} \hat{\gamma}_{k j} \mathbf{z}_{k} .$
3. Regress $\mathbf{y}$ on the residual $\mathbf{z}_{p}$ to give the estimate $\hat{\beta}_{p}$.
::: -->



## 回顾：组内估计量 (FE)

我们先回顾一下一维固定效应模型的估计方法，继而扩展至 TWFE 和多维 FE 模型。

考虑如下一维固定效应模型：

$$
y_{it} = \alpha_{i} + \mathbf{x}_{it}'\boldsymbol{\beta} + \varepsilon_{it} \tag{10}
$$

其组内均值为：

$$
\bar{y}_{i} = \alpha_i + \bar{\mathbf{x}}_i\boldsymbol{\beta} + \bar{\varepsilon}_i \tag{11}
$$

其中，$\bar{y}_i=(1/T_i)\sum_{t=1}^{T_i}y_{it}$，$T_i$ 表示第 $i$ 个个体的观察期数。$\bar{\mathbf{x}}_i$ 和 $\bar{\varepsilon}_i$ 的定义方式与此相同。

用 (10) 与 (11) 相减，可去除个体效应 $\alpha_i$：

$$
(y_{it}-\bar{y}_i)=(\mathbf{x}_{it}-\bar{\mathbf{x}}_i)'\boldsymbol{\beta} + (\varepsilon_{it}-\bar{\varepsilon}_i) \tag{12}
$$

若设定 $\dot{y}_{it}=(y_{it}-\bar{y}_i)$, $\dot{\mathbf{x}}_{it}= (\mathbf{x}_{it}-\bar{\mathbf{x}}_i)$，以及 $\dot{\varepsilon}_{it}= (\varepsilon_{it}-\bar{\varepsilon}_i)$，则我们只需对如下模型执行 OLS 估计即可得到 $\boldsymbol{\beta}$ 的估计值：

$$
\dot{y}_{it} = \dot{\mathbf{x}}_{it}'\boldsymbol{\beta} + \dot{\varepsilon}_{it} \tag{13}
$$

简言之，要得到固定效应模型 (10) 的估计系数，只需从原始数据中减去其组内平均值，进而对变换后的组内差分模型 (13) 执行 OLS 估计即可。显然，上述「组内去心」变换便是 FWL 定理的一个典型应用。[^11]

### Stata 实操和启示

在 Stata 中，有诸多命令都可以实现上述估计过程，如 `areg`, `xtreg`, `reghdfe` 等：

```stata
. xtset id year
. areg    y x1 x2, absorb(id) vce(cluster id)
. xtreg   y x1 x2, fe robust //此时, robust <=> vce(cluster id)
. reghdfe y x1 x2, absorb(id) vce(cluster id)
```

在有些情况下，(10) 式的估计可能只是回归分析的一个环节，此时我们可以依据 FWL 定理，预先手动进行「组内去心处理」，进而采用去心后的数据进行后续分析，例如：

```stata
. xtset id year
*-center: y[it] - ymean[i]
*. bysort id: center y x1 x2, inplace // inplace - 替换现有同名变量
. bysort id: center y x1 x2, prefix(c_)
. reg c_y c_x1 c_x2, vce(cluster id) // 手动估计 FE 模型

. rwrmed    c_y c_x1 c_x2  //中介效应分析, Stata Journal, SJ-21-3
  net describe st0646      // 查看命令和附件

. ivmediate c_y c_x1 c_x2  //中介效应分析, Stata Journal, SJ-20-3
  net describe st0611_1    // 查看命令和附件
```

## TWFE：二维固定效应模型

我们可以在 (10) 中加入一组时间虚拟变量以控制宏观经济因素的影响，该模型称为 TWFE：

$$
y_{it} = \mathbf{x}_{it}'\boldsymbol{\beta} + a_i+\lambda_t + \varepsilon_{it} \tag{14}
$$

我们可以采用类似于 (12) 的方式同时去除个体固定效应和时间效应。转换方式为：[^12]

$$
\widetilde{y}_{it}=y_{it}-\bar{y}_i-\bar{y}_t \tag{15}
$$

其中，$\bar{y}_t=(1/N_t)\sum_{i=1}^{N_t}y_{it}$，$N_t$ 表示第 $t$ 个时点包含的公司数量。$\bar{y}_i$ 的定义同前。

按此思路可以得到 $\widetilde{\mathbf{x}}_{it}$，进而用 $\widetilde{y}_{it}$ 对 $\widetilde{\mathbf{x}}_{it}$ 执行 OLS 回归即可得到 (14) 的无偏估计量，记为 $\widehat{\boldsymbol{\beta}}_{TWFE}$。

若需在回归中保留常数项，则可以执行如下变换：

$$
\widetilde{y}_{it}=y_{it}-\bar{y}_i-\bar{y}_t+\bar{y}
$$

其中，$\bar{y}$ 表示 $y_{it}$ 的样本均值。

实证分析中通常使用如下两条命令估计 TWFE 模型。差别如下：

- [M1] 将时间效应 $\lambda_t$ 作为一组虚拟变量纳入模型，
- [M2] 则是预先采用 (15) 式去除 $\lambda_t$。由 FWL 定理可知，二者是等价的。

```stata
. xtset id year
. xtreg   y x1 x2 i.year, fe vce(cluster id)  // [M1]
. reghdfe y x1 x2, absorb(id year) vce(cluster id)  // [M2] <=> [M1]
```

若需手动操作，则 (15) 式可以用如下命令实现：

```stata
xtset id year
local yx "y x1 x2"

* y_i_mean
  foreach v of varlist `yx'{
  	  bysort id: egen `v'_i = mean(`v')
  }

* y_t_mean
  foreach v of varlist `yx'{
  	  bysort year: egen `v'_t = mean(`v')
  }

* y_ddm = y_it - y_i_mean - y_t_mean
*  (ddm: double de-mean)
  foreach v of varlist `yx'{
  	  gen `v'_ddm = `v' - `v'_i - `v'_t
  }

reg y_ddm x1_ddm x2_ddm, vce(cluster id)
```

## HDFE：高维固定效应模型

在教育经济、移民、公司金融等领域的研究中，经常使用高维固定效应模型，其中尤以国际贸易领域中的「引力模型」影响最大，[^13]通常会在模型中包含三维甚至四维固定效应，以及它们的交互项。若允许经济变量的影响具有异质性，则还可以把固定效应与 $x$ 变量交乘。

这里以三维固定效应模型为例进行说明，更一般的情形在原理上于此相似，矩阵推导详情参见 Balazsi, Matyas, Wansbeek ([2018](https://doi.org/10.1080/07474938.2015.1032164), [PDF](http://sci-hub.ren/10.1080/07474938.2015.1032164))。[^14]

假设我们需要研究全国 31 个省在一段时间内的行业产出的影响因素，则数据包括三个维度：省份 ($i=1,\cdots, N$)，行业 ($j=1,\cdots,G$)，年份 ($t=1,\cdots,T$)，模型设定为：

$$
y_{ijt} = \mathbf{x}_{ijt}'\boldsymbol{\beta} + a_i + \gamma_j + \lambda_t + \varepsilon_{ijt} \tag{16}
$$

沿袭 (12) 和 (15) 的变换思路，可以采用如下变换去除三个维度的固定效应：

$$
\widetilde{y}_{ijt} = y_{ijt}-\bar{y}_i-\bar{y}_j-\bar{y}_t + 2\bar{y} \tag{17}
$$

Balazsi et al.  ([2018](https://doi.org/10.1080/07474938.2015.1032164), [PDF](http://sci-hub.ren/10.1080/07474938.2015.1032164)) 文中表述如下：[^15]

$$
\widetilde{y}_{i j t}=y_{i j t}-\bar{y}_{i . .}-\bar{y}_{. j .}-\bar{y}_{. . t}+2 \bar{y}_{\ldots .} \tag{18}
$$

最后，需要特别注意的是，经过组内变换后的系数估计值与直接进行包含多组虚拟变量的 OLS 回归虽然在系数上相同，但标准误的计算需要调整。Stata 中的 `reghdfe` 等命令对此进行了非常妥善的处理。

```stata
. reghdfe y x1 x2, absorb(province industry year)
```

若需手动操作，则 (17) 式可以用如下命令实现：

```stata
. xtset id jcode time
. bysort   id: center y x1 x2, inplace //原地替换已有变量
. bysort year: center y x1 x2, inplace
. reg y x1 x2, vce(cluster id)
```

### 双边固定效应

国际贸易领域中的引力模型通常会包含交互固定效应。[^16]例如，Egger and Pfaffermayr ([2003](https://doi.org/10.1007/s001810200146), [PDF](http://sci-hub.ren/10.1007/s001810200146)) 便设定了如下模型，以反映贸易双方的交互影响：

$$
y_{i j t}=\mathbf{x}_{ijt}'\boldsymbol{\beta}+\gamma_{ij}+\varepsilon_{i j t}, \tag{19}
$$

其中，$\gamma_{i j}$ 为双边固定效应，可以采用如下变换去除之 (Balazsi et al., [2018](https://doi.org/10.1080/07474938.2015.1032164), [PDF](http://sci-hub.ren/10.1080/07474938.2015.1032164), eq. 6)：

$$
\widetilde{y}_{i j t}=y_{i j t}-\bar{y}_{i j .} \tag{20}
$$

Stata 命令为：

```stata
. reghdfe y x1 x2, absorb(i.ivar#i.jvar) vce(cluster ivar jvar)
```

手动生成 $y_{i j t}-\bar{y}_{i j .}$ 的命令为：

```stata
bysort ivar jvar: egen y_ij_mean = mean(y)
```

实证分析中应用更为广泛的是 Cheng and Wall (2005) 提出的扩展模型，它在 (19) 中增加了时间效应 $\lambda_{t}$：

$$
y_{i j t}=\mathbf{x}_{ijt}'\boldsymbol{\beta} + \gamma_{i j}+\lambda_{t}+\varepsilon_{i j t} . \tag{21}
$$

用 (18) 式对原始数据进行变换后执行 OLS 估计即可 (Balazsi et al., [2018](https://doi.org/10.1080/07474938.2015.1032164), [PDF](http://sci-hub.ren/10.1080/07474938.2015.1032164))。

Stata 命令为：

```stata
. reghdfe y x1 x2, absorb(ivar#jvar tvar) vce(cluster ivar jvar)
```

Matyas ([2017](https://link.springer.com/book/10.1007/978-3-319-60783-2), [PDF](https://link.springer.com/content/pdf/10.1007%2F978-3-319-60783-2.pdf)) 文中表 1.1, 表 1.2, 表 2.1 列举了多种其它设定方式，例如：

$$
\begin{aligned}
	& y_{i j t}=\beta^{\prime} x_{i j t}+\alpha_{j t}+\varepsilon_{i j t}, \\
	& y_{i j t}=\beta^{\prime} x_{i j t}+\alpha_{i t}+\alpha_{j t}^*+\varepsilon_{i j t},
	\end{aligned} \tag{22}
$$

或者把各个交互效应都考虑在内的完整设定：

$$
y_{i j t}=\beta^{\prime} x_{i j t}+\gamma_{i j}+\alpha_{i t}+\alpha_{j t}^{*}+\varepsilon_{i j t} . \tag{23}
$$

相应的组内变换公式为：

$$
\tilde{y}_{i j t}=y_{i j t}-\bar{y}_{i j .}-\bar{y}_{. j t}-\bar{y}_{i . t}+\bar{y}_{. . t}+\bar{y}_{. j .}+\bar{y}_{i . .}-\bar{y}_{. . .} \tag{24}
$$

Stata 命令为：

```stata
. reghdfe y x1 x2, absorb(ivar#jvar ivar#tvar jvar#tvar)  ///
                   vce(cluster ivar jvar tvar)
```

### HDFE：高维及更一般的设定

按照上面的分析逻辑，我们的数据也可能包含四个甚至五个维度的特征。例如，

- 我们想研究公司 $s$ 在时间 $t$ 上的产品 $j$ 从给定国家到国家 $i$ 的出口量 $y$。显然，变量 $y_{i j s t}$ 包含四个维度 (`公司-产品-时间-进口国`)。
- 若手头的数据不仅针对一个国家，而是多个国家，我们最终将得到五维面板数据 (`出口国-公司-产品-时间-进口国`)。

显然，这种高维数据使得我们可以采用多种方式来设定的固定效应：基本的固定效应有 5 个，若进一步加入它们的各种交互项，则可供选择的模型设定形式将会大幅增加。然而，就技术层面而言，此前介绍的三维模型的处理思路可以很容易推广到高维情形。

举例而言，若将 (23) 式扩展至四维，并包含所有的交互效应，则：

$$
y_{i j s t}=x_{i j s t}^{\prime} \beta+\gamma_{i j s}^{0}+\gamma_{i j t}^{1}+\gamma_{j s t}^{2}+\gamma_{i s t}^{3}+\varepsilon_{i j s t}, \tag{25}
$$

去除 $\left(\gamma_{i j s}^{0}, \gamma_{i j t}^{1}, \gamma_{j s t}^{2}, \gamma_{i s t}^{3}\right)$ 的组内变换公式为 (Balazsi et al., [2018](https://doi.org/10.1080/07474938.2015.1032164), [PDF](http://sci-hub.ren/10.1080/07474938.2015.1032164))：

$$
\begin{aligned}
\tilde{y}_{i j s t} =\ & y_{i j s t}-\bar{y}_{. j s t}-\bar{y}_{i . s t}-\bar{y}_{i j . t}-\bar{y}_{i j s .}+\bar{y}_{. . s t}+\bar{y}_{. j . t}+\bar{y}_{. j s .} \\
& +\bar{y}_{i . . t}+\bar{y}_{i . s .}+\bar{y}_{i j . .}-\bar{y}_{\ldots t}-\bar{y}_{. . s .}-\bar{y}_{. j . .}-\bar{y}_{i . . .}+\bar{y}_{\ldots . .}
\end{aligned} \tag{26}
$$

在 Stata 中，使用 `reghdfe` 命令可以非常方便地实现上述变换：

```stata
. reghdfe y x1 x2, absorb(ivar#jvar#svar#tvar)  ///
                   vce(cluster ivar jvar svar tvar)
```


## 参考文献

Balazsi, L., L. Matyas, T. Wansbeek. 2018. The estimation of multidimensional fixed effects panel data models. Econometric Reviews, 37 (3): 212-227. [Link](https://doi.org/10.1080/07474938.2015.1032164), [PDF](http://sci-hub.ren/10.1080/07474938.2015.1032164), [Cited](https://xs2.dailyheadlines.cc/scholar?cites=1236190443942270900&as_sdt=2005&sciodt=0,5&hl=zh-CN)

Chiang, H. D., K. Kato, Y. Ma, Y. Sasaki, 2022, Multiway cluster robust double/debiased machine learning, Journal of Business \& Economic Statistics, 40 (3): 1046-1056. [-Link-](https://doi.org/10.1080/07350015.2021.1895815), [-PDF-](https://sci-hub.ren/10.1080/07350015.2021.1895815), [Replication-R codes](https://www.tandfonline.com/doi/suppl/10.1080/07350015.2021.1895815?scroll=top), Stata: `findit crhdreg`

Correia, S., P. Guimarães, T. Zylkin. 2020. Fast poisson estimation with high-dimensional fixed effects. The Stata Journal, 20 (1): 95-115. [Link](https://doi.org/10.1177/1536867x20909691), [PDF](https://journals.sagepub.com/doi/pdf/10.1177/1536867X20909691), [Cited](https://xs2.dailyheadlines.cc/scholar?cites=5570354126943298338&as_sdt=2005&sciodt=0,5&hl=zh-CN)

Davidson, Russell; MacKinnon, James G. (2004). Econometric Theory and Methods. New York: Oxford University Press. pp. 62–75. [Link](http://qed.econ.queensu.ca/pub/faculty/mackinnon/econ850/), [PDF](http://qed.econ.queensu.ca/ETM/ETM-davidson-mackinnon-2021.pdf)

Egger, P., M. Pfaffermayr. 2003. The proper panel econometric specification of the gravity equation: A three-way model with bilateral interaction effects. Empirical Economics, 28 (3): 571-580. [Link](https://doi.org/10.1007/s001810200146), [PDF](http://sci-hub.ren/10.1007/s001810200146).

Fiebig, D. G., R. Bartels. 1996. The Frisch-Waugh theorem and generalized least squares. Econometric Reviews, 15 (4): 431-443. [Link](https://doi.org/10.1080/07474939608800365), [Link](https://doi.org/10.1080/07474939608800365), [PDF](http://sci-hub.ren/10.1080/07474939608800365).

Frisch, R., and F. V. Waugh. 1933. Partial time regressions as compared with individual trends. Econometrica 1: 387–401.

Guimaraes, P., P. Portugal. 2010. A simple feasible alternative procedure to estimate models with high-dimensional fixed effects. Stata Journal, 10 (4): 628–649. [PDF](https://journals.sagepub.com/doi/pdf/10.1177/1536867X1101000406),  [cited](https://xs2.dailyheadlines.cc/scholar?cites=8847440803699029187&as_sdt=2005&sciodt=0,5&hl=zh-CN).

Hansen B E . 2021. Econometrics. Princeton University Press, forthcoming. [Data and Contents](https://www.ssc.wisc.edu/~bhansen/econometrics/), [PDF](https://www.ssc.wisc.edu/~bhansen/econometrics/Econometrics.pdf)

Hastie, Trevor; Tibshirani, Robert; Friedman, Jerome (2017). Multiple Regression from Simple Univariate Regression. The Elements of Statistical Learning : Data Mining, Inference, and Prediction (2nd ed.). New York: Springer. pp. 52–55. [PDF](https://hastie.su.domains/Papers/ESLII.pdf#page=71)

Hastie, T., R. J. Tibshirani, J. Friedman. The elements of statistical learning: Data mining, inference, and prediction[M]. 2017. 2E.  [PDF](https://hastie.su.domains/Papers/ESLII.pdf).

Hayashi, Fumio (2000). Econometrics. Princeton: Princeton University Press. pp. 18–19.

Head, K., T. Mayer. 2014. Chapter 3 - gravity equations: Workhorse, toolkit, and cookbook, in G. Gopinath, E. Helpman,K. Rogoff eds, Handbook of International Economics (Elsevier, 131-195. [Link](https://www.sciencedirect.com/science/article/pii/B9780444543141000033), [PDF](http://sci-hub.ren/10.1016/B978-0-444-54314-1.00003-3).

Lovell, M. C. 1963. Seasonal adjustment of economic time series and multiple regression analysis. Journal of the American Statistical Association 58: 993–1010.

Lovell, M. (2008). A Simple Proof of the FWL Theorem. Journal of Economic Education. 39 (1): 88–91.

Matyas, L. 2017. The Econometrics of Multi-dimensional panels. Advanced Studies in Theoretical and Applied Econometrics. Berlin: Springer. [Link](https://link.springer.com/book/10.1007/978-3-319-60783-2), [PDF](https://link.springer.com/content/pdf/10.1007%2F978-3-319-60783-2.pdf).

Silva, J. M. C. S., S. Tenreyro. 2006. The log of gravity. The Review of Economics and Statistics, 88 (4): 641-658. [Link](https://doi.org/10.1162/rest.88.4.641),  [PDF](http://sci-hub.ren/10.1162/rest.88.4.641).

Stammann, Amrei, Florian Heiß, and Daniel McFadden. 2016. Estimating fixed effects logit models with large panel data. Working Paper. [PDF](https://www.econstor.eu/bitstream/10419/145837/1/VfS_2016_pid_6909.pdf)

Stammann, A. 2018. Fast and Feasible Estimation of Generalized Linear Models with High-Dimensional k-way Fixed Effects. ArXiv e-prints .
[PDF](https://arxiv.org/pdf/1707.01815v2.pdf)

Yamada, H. 2017.  The Frisch-Waugh-Lovell Theorem for the lasso and the ridge regression.  Communications in Statistics - Theory and Methods 46(21): 10897-10902. [Link](http://dx.doi.org/10.1080/03610926.2016.1252403), [PDF](http://sci-hub.ren/10.1080/03610926.2016.1252403).

[^1]: Correia et al. ([2020](https://journals.sagepub.com/doi/pdf/10.1177/1536867X20909691)) 对 Stata 中的各种用于估计高维固定效应的命令进行非常细致的梳理。
[^2]: 该书表 1.1 - 表 1.3，以及表 2.1 对比了国际贸易、房地产、移民等多个领域中使用高维固定效应模型的 100 余篇论文的模型设定形式。
[^3]: Davidson and MacKinnon ([1993](http://qed.econ.queensu.ca/pub/dm-book/EIE-davidson-mackinnon-2021.pdf), 19-24) 以及 Davidson and MacKinnon ([2004](http://qed.econ.queensu.ca/pub/faculty/mackinnon/econ850/), [PDF](http://qed.econ.queensu.ca/ETM/ETM-davidson-mackinnon-2021.pdf), pp. 62–75, [Slides](http://qed.econ.queensu.ca/pub/faculty/mackinnon/econ850/slides/econ850-slides-h03.pdf)) 对此进行非常细致的介绍。
[^4]: 参见连享会推文：[图示线性回归系数：Frisch-Waugh定理与部分回归图](https://www.lianxh.cn/news/e346db1a68211.html)，以及 [多元回归系数：我们都解释错了？](https://www.lianxh.cn/news/22f1f266f5868.html)。
[^5]: 有关时间趋势项的介绍参见连享会推文：[傻傻分不清：时间趋势项与时间虚拟变量](https://www.lianxh.cn/news/5bbe8408904fb.html)。
[^6]: 以 $y$ 为例，用 $y$ 对 $t$ 进行 OLS 回归，得到的残差项 $\tilde{y}$ 即为去除时间趋势后的 $y$。
[^7]: 生成 `c_y` 和 `c_x` 的 Stata 命令为：`bysort industry: center y x, prefix(c_)`。
[^8]: 例如，Guimaraes and Portugal ([2010](https://journals.sagepub.com/doi/pdf/10.1177/1536867X1101000406)) 基于 FWL 定理，提出了一种快速估计高维固定效应的方法，Stata 命令为 `regintfe`。不过，其功能已经完全被 `reghdfe` 覆盖。
[^9]: 相关应用参见 [[LASSO] Lasso_intro](https://www.stata.com/manuals/lassoLasso_intro.pdf)，以及[[LASSO] poregress](https://www.stata.com/manuals/lassoporegress.pdf)。
[^10]: 由 (6) 式可知，$X_2'X_2b_2 = X_2'y - X_2'x_1b_1= X_2'(y-x_1b_1)$。
[^11]: 更为严格的推导过程参见第 sec:xt-app-FE-within 小节。
[^12]: 具体推导过程参见第 sec:xt-fe-twfe-app 小节。
[^13]: 有关引力模型的介绍参见 Silva and Tenreyro ([2006](https://doi.org/10.1162/rest.88.4.641), [PDF](http://sci-hub.ren/10.1162/rest.88.4.641)，以及 Head and Mayer ( [2014](https://www.sciencedirect.com/science/article/pii/B9780444543141000033), [PDF](http://sci-hub.ren/https://doi.org/10.1016/B978-0-444-54314-1.00003-3))。
[^14]: 文中的矩阵运算可以用 Stata 中的 Mata 语言实现，详情参见  Revesz ([2013](http://www.personal.ceu.hu/staff/repec/pdf/stata-program_document-dofile.pdf))。
[^15]: 需要强调的是，上述组内变换通常并不唯一，比如，如下变换也可以消除 (16) 式中的三个固定效应：
  $\widetilde{y}_{i j t}=y_{i j t}-\bar{y}_{i j .}-\bar{y}_{. t}+\bar{y}_{\ldots}$，但由此变换得到的 $\boldsymbol{\beta}$ 系数估计值是相同的。
[^16]: 有关引力模型的介绍参见 Silva and Tenreyro ([2006](https://doi.org/10.1162/rest.88.4.641), [PDF](http://sci-hub.ren/10.1162/rest.88.4.641)，以及 Head and Mayer ( [2014](https://www.sciencedirect.com/science/article/pii/B9780444543141000033), [PDF](http://sci-hub.ren/https://doi.org/10.1016/B978-0-444-54314-1.00003-3))。
