# 交互固定效应模型

## 简介

面板数据模型的一个好处是，可以在模型中引入 $\alpha_i$ 和 $\lambda_t$，并通过「组内去心」或「差分」处理控制那些不可观测因素的影响，以便减少由于不随时间或个体变化的遗漏变量与解释变量相关导致的内生性问题。

传统的面板固定效应模型中，个体效应和时间效应都是以「叠加 (addaptive)」的形式进入模型，以控制样本中不随时间变化的个体差异和不随个体变化的时间差异。然而，时间上的共同冲击 (common shock) 往往具有异质性影响，如「央行加息」、「石油价格上涨」等宏观冲击对不同的国家或公司产生的影响是不同的。更为棘手的是，很多共同冲击因素都是不可观测的，若不作处理，它们会以遗漏变量的身份潜伏在干扰项中，从而导致内生性问题 (混杂因素)。

Bai (2009) 提出的「交互固定效应模型」 (interactive fixed effect, 简记为 IntFE) 为上述问题提供了一种可行的解决办法。[^1] 其基本思想是在普通的固定效应模型中引入交互项 $\lambda_{i}^{\prime} F_{t}$。其中，$F_t$ 是一组共同因子 (各种时间维度上的共同冲击的集合，无法观测)， $\lambda_{i}$ 称为因子载荷，反映了 $F_t$ 对不同的个体的异质性影响。表面上，$F_t$ 是“看不见摸不着”的东西，但我们可以通过主成分分析或因子分析的方式提取其中最重要的一些因子，从而实现对共同因素的「控制」，以便更好地估计模型中核心变量的参数，或对被解释变量进行更为准确的预测。前文提到的固定效应模型、双向固定效应模型都是 IntFE 模型的特例。

IntFE 的应用非常广泛，在控制遗漏变量 (内生性问题的一个主要来源)、捕捉时变特征、提高拟合优度等方面都有重要的用途。[^2] 如 Bai (2009, pp.1262) 所言，该模型的一个主要用途是控制截面相关。通过在模型中加入足够数量的共同因子，干扰项中的截面相关得以被消除或大幅减弱，使其对统计推断的影响微乎其微。 例如，

- Hsiao, Ching and Wan (2012) 使用交互固定效应模型来构造「反事实」，以评估 1997 年香港回归的政策效果。其方法在政策评估中得到广泛应用，并称为「回归控制法 (regression control mothed)」 (参见 Chen and Yan (2021))。Kim and Oka (2013) 应用 IntFE 研究了美国州级层面的单边离婚法变化对离婚率的影响。
- Gobillon and Magnac (2016) 则将交互固定效应引入 DID 和合成控制法，以便更好地构造「反事实结果」变量。
- 交互固定效应也成为合成控制法的一个重要扩展工具，它出现在了「一般化合成控制法」(Xu , 2017)，增广合成控制法 (Ben-Michael et al., 2021)，以及「合成 DID」(Arkhangelsky et al., 2021) 中。

## 简要回顾

在正式介绍交互固定效应模型之前，我们先简单回顾一下基本的固定效应模型，进而进入时间趋势和共同因素的概念，以便更顺畅地理解 IntFE 的模型设定思想和应用场景。对于常规的固定效应模型比较熟悉的读者可以跳过“简要回顾” 小节。


### POLS, FE 和 TWFE

考虑如下包含 $N$ 个个体，$T$ 个时期的面板数据模型：

$$
Y_{it}=\mathbf{x}_{it}'\beta+u_{it} \tag{1}
$$

其中，$i=1,2, \ldots, N,\ \ t=1,2, \ldots, T$，$\mathbf{x}_{it}$ 为可观测解释变量，系数为 $\beta$，二者均为 $(p \times 1)$ 维行向量，$u_{it}$ 为随机干扰项。

文献中使用的各类面板数据模型都建立在对 $u_{it}$ 的设定上，包括：POLS，FE/RE，TFE 等：

- **POLS** &emsp;  假设 $u_{it}$ 为 $i.i.d$，且 $\operatorname{E}\,[u_{it} \mid \mathbf{X}_{it}]=0$，则直接采用 OLS 估计 (1) 即可。简言之，此时我们完全忽略面板数据的特征，只是简单地把所有观察值混合起来执行 OLS 回归而已，Stata 命令为： `. reg y x`

- **FE** 和 **RE** &emsp;  设定 $u_{it}=\alpha_{i} + v_{it}$，即考虑不可观测的个体固定效应 (地理位置、性别、种族等)，若假设 $\text{corr}\,(\alpha_{i}, v_{it})=0$，则得到 RE 模型；反之为 FE 模型。Stata 命令分别为 `. xtreg y x, re` 和 `. xtreg y x, fe`

- **TFE** &emsp;  设定 $u_{it}=\alpha_{i} + \lambda_{t} + \varepsilon_{it}$，即在 FE 的基础上进一步考虑时间维度上的固定效应 $\lambda_t$ (石油价格变化、货币政策调整等)，则称为双向固定效应模型 (TFE)。Stata 命令为 `. xtreg y x i.year, fe`



### TWFE 及其扩展

实证分析中，TFE 模型应用最为广泛，设定如下：

$$
Y_{it}=\mathbf{x}_{it}'\beta+\alpha_{i} + \lambda_{t} + \varepsilon_{it} \tag{2}
$$

为便于后续讨论，我们可以将其重新表述如下：

$$
Y_{it}=\mathbf{x}_{it}'\beta + \sum_{i=1}^N \alpha_i A_i + \sum_{t=1}^T \lambda_t B_t + \varepsilon_{it}
$$

其中，$A_i$ 是个体层面的虚拟变量 (共 $N$ 个)，$B_t$ 则是时间维度上的虚拟变量 (共 $T$ 个)。由此看来，在 TFE 的设定中，隐含着一个重要的假设，即在第 $t$ 年度的宏观冲击 $B_t$ 对所有个体的影响具有同质性，均为 $\lambda_t$。[^3]若允许异质性，我们可以假设宏观经济冲击 $B_t$ 会对不同的个体产生不同的影响，此时模型变为：[^4]

$$
Y_{i t}=\mathrm{x}_{i t}^{\prime} \beta+\sum_{i=1}^N \alpha_i A_i+\sum_{t=1}^T \lambda_t B_t+\sum_{i=1}^N \sum_{t=1}^T \theta_{i t} A_i B_t+\varepsilon_{i t}
$$

或简写为：

$$
Y_{it}=\mathbf{x}_{it}'\beta + \alpha_{i} + \lambda_{t} + \alpha_{i}\lambda_{t} + \varepsilon_{it}
$$

显然，这个模型包含的参数超过了样本数 $N\times T$，是无法识别的。处理思路是设定一些约束条件，以便减少模型中待估参数的个数。下面介绍几种常用的处理手段。

#### A. 行业变系数模型 {.unumbered}

假设宏观经济冲击的影响仅在比个体更高的层级上 (如行业层面） 存在异质性。此时，可以把 (3) 式中 $\mathcal{M} = \sum_{i=1}^N\sum_{t=1}^T \theta_{it} A_i B_t$ 替换为 $\mathcal{M}_1 = \sum_{j=1}^J\sum_{t=1}^T \theta_{jt} S_j B_t$，其中，$S_j$ 表示第 $j$ 个行业对应的虚拟变量，$j=1,2,\cdots,J$ 表示行业类别。 模型的待估参数为 $(p + N + JT)$ 个，简写如下：[^5]

$$
Y_{it}=\mathbf{x}_{it}'\beta + \alpha_{i} + \mathbf{g}_{j}\lambda_{t} + \varepsilon_{it} \tag{4}
$$

Stata 命令为：

```stata
   . reg     y x  i.id  i.year  i.industry#i.year
   . xtreg   y x        i.year  i.industry#i.year, fe
   . reghdfe y x, absorb(id year industry#year)
```

#### B. 异质性趋势模型或随机趋势模型 ** {.unumbered}

我们也可以把时间虚拟变量 $\lambda_{t}$ 替换为时间趋势 $Trend_t = t$[^6]。将 (3) 式中 $\mathcal{M}$ 的设定为 $\mathcal{M}_2 = \sum_{i=1}^N\sum_{t=1}^T \theta_{i} A_i\cdot t$，其中，$t=1,2,\cdots,T$。此时，每个个体都有自己的时间趋势系数 $\theta_{i}$，表示在样本区间内个体 $i$ 的平均变化趋势。[^7]模型的待估参数为 $(p + N + T + N)$ 个，简写如下：

$$
Y_{it}=\mathbf{x}_{it}'\beta + \alpha_{i} + \lambda_{t} + \alpha_{i}t + \varepsilon_{it} \tag{5}
$$

若直接估计 (5) 式，则 Stata 命令为：

```stata
. reg y x  i.id  i.year  i.id#c.year  // 适合 N 较小，如省级面板
. xtreg y x  i.year  i.id#c.year, fe  // 同上
. reghdfe y x, absorb(i.id i.year i.id#c.year) // 推荐, 如上市公司数据
```

$$
Y_{it}= \alpha_{i} + \mathbf{x}_{it}'\beta + \mathbf{z}_{t}'\gamma  +  v_{it} \tag{6}
$$

$$
v_{it} = \mathbf{w}_t'\eta + \varepsilon_{it}
$$

此处，`c.year` 表示把 `year` 变量视为连续变量，用以表示 $Trend_t=t$ 变量。[^8]我们也可以对 (5) 式进行一阶差分变换，得到：

$$
\Delta Y_{it}=\Delta\mathbf{x}_{it}'\beta + \Delta \lambda_{t} + \alpha_{i} + \Delta \varepsilon_{it} \tag{7}
$$

注意，$\alpha_{i}t-\alpha_{i}(t-1)=\alpha_{i}$。(7) 可以用如下两种方法估计：

```stata
   . xtreg    D.y D.(x1 x2) D.(i.year), fe robust
   . xtivreg2 y x1 x2 i.year, fd robust  // fd:=一阶差分
```

::: {.callout-tip}
### 时间趋势

- 徐婷, 徐云娇, 2020, [傻傻分不清：时间趋势项与时间虚拟变量](https://www.lianxh.cn/details/147.html)

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Trend_Year_dummy_01.png)
:::

#### C. 加入宏观经济变量 {.unumbered}

在很多研究中，我们关心的是一个或多个宏观经济变量 $\mathbf{z}_t$ 对 $Y_{it}$ 的影响。比如，$\mathbf{z}_t$ 可以是人均 GDP ($gdp_t$)，货币增速 ($m_t$)，经济政策不确定性 ($epu_t$) 等。此时，由于 $\mathbf{z}_t$ 与时间虚拟变量 $\lambda_t$ 完全共线性，故删去 $\lambda_t$，模型简写如下：

$$
Y_{it}= \alpha_{i} + \mathbf{x}_{it}'\beta + {\color{red}{\gamma\mathbf{z}_{t}}} + v_{it} \tag{8}
$$

Stata 命令为：

```stata
   . xtreg y x z1 z2, fe
```

问题在于，即使我们在 $\mathbf{z}_t$ 中包含了 3-5 个甚至更多的宏观经济变量，仍然可能存在一些被遗漏的变量 (如央行的口头沟通、疫情变化等)，这些变量虽然很重要，但往往难以观测或准确衡量。

换个角度来看，$\lambda_t = \mathbf{z}_{t}'\gamma + \mathbf{w}_t'\eta$，也就是说 $\lambda_t$ 其实包含了所有时间维度上的因素，我们在模型 (8) 中删去了 $\lambda_t$，代之以 $\mathbf{z}_t\gamma$，但被遗漏的 $\mathbf{w}_t'\eta$ 会进入干扰项，即 $v_{it} = \mathbf{w}_t'\eta + \varepsilon_{it}$。

显然，如果 $\text{corr}(\mathbf{w}_t,\mathbf{z}_t)\neq 0$ 或 $\text{corr}(\mathbf{w}_t,\mathbf{x}_{it})\neq 0$，则 $\gamma$ 或 $\beta$ 的 OLS 估计将是有偏的。 从另一个角度来看，(8) 中的干扰项为 $v_{it} = \mathbf{w}_t'\eta + \varepsilon_{it}$，由于 $\mathbf{w}_t$ 是所有个体面临的共同因素，所以个体间的干扰项存在截面相关，即 $\operatorname{corr}\left(v_{i t}, v_{j t}\right) \neq 0(\forall i \neq j)$。

有了上述铺垫，我们就很容易理解 IntFE 模型的设定思想了：虽然 $\mathbf{w}_t'\eta$ 不可观测，但我们可以将其设定为一组共同因子的组合，即 $\lambda^{\prime} F_{t}$ 或允许共同因子的影响具有异质性 $\lambda_{i}^{\prime} F_{t}$。在这一架构下，(8) 可以改用如下设定方式，以避免遗漏变量问题：

$$
Y_{it}=\alpha_{i} + \mathbf{x}_{it}'\beta + \gamma\mathbf{z}_{t}  + \lambda_{i}^{\prime} F_{t} + \varepsilon_{it} \tag{9}
$$

甚至可以允许可观测的宏观经济变量 $\mathbf{z}_t$ 对 $Y_{it}$ 具有异质性影响 (Peraran, 2006)，即把上式中的 $\gamma$ 替换为 $\gamma_i$ 或 $\gamma_t$。

```stata
   . regife y x1 x2 zt1 zt2, absorb(id) ife(id year, 1)
```

## Bai (2009) 模型

### 基本设定

考虑如下包含 $N$ 个个体，$T$ 个时期的面板数据模型：

$$
Y_{i t}=\mathbf{X}_{i t}^{\prime} \beta+u_{i t}, \quad u_{i t}=\lambda_i^{\prime} F_t+\varepsilon_{i t},
$$

其中，$i=1,2, \ldots, N,\ \ t=1,2, \ldots, T$，$\mathbf{X}_{it}$ 为可观测解释变量，系数为 $\beta$，二者均为 $(p \times 1)$ 维向量。复合干扰项 $u_{it}$ 具有因子结构，$\lambda_{i}$ 为因子载荷向量，$F_{t}$ 是共同因子 (common factors) 向量，二者均为 $(r \times 1)$ 维向量， $\lambda_{i}^{\prime} F_{t}=\lambda_{i 1} F_{1 t}+\cdots+\lambda_{i r} F_{r t}$。[^9] $\varepsilon_{it}$ 是常规意义上的随机干扰项。需要说明的是，$\lambda_{i}, F_{t}$, and $\varepsilon_{it}$ 均不可观测。在多数应用中，重点关注的是 $\mathbf{X}_{it}$ 的系数 $\beta$。

举个小例子，以便对交互固定效应 $\lambda_{i}^{\prime} F_{t}$ 有个直观的理解。假设 $F_t$ 中只包含一个因子——「未预期到的央行货币政策」 (如突然宣布将法定存款准备金率下调 $0.5%$，简称「降准」)，对于所有上市公司而言，这个冲击可以视为一个共同因素，若设定 $\lambda_{i}$ 为常数，即 $\lambda_{i}=\lambda$，则相当于假设 $F_t$ (降准) 对于所有公司的影响是相同的，但这显然有点牵强。对比来看，$\lambda_{i}$ 的设定就相对灵活一些，它表示 $F_t$ 每家公司具有不同的影响 —— $\partial Y_{it}/\partial F_t \mid \mathbf{X}_{it} = \lambda_{i}$。

显然，常见的双向固定效应模型只是交互固定效应模型的特例。假设有 2 个共同因子：

$$
F_t=\left[\begin{array}{l}
1 \\
\xi_t
\end{array}\right], \quad \lambda_i=\left[\begin{array}{c}
\alpha_i \\
1
\end{array}\right]
$$

此处，$F_{1t}=1$ 为常数，对应的因子载荷为 $\lambda_{i1}=\alpha_{i}$，即个体固定效应；$F_{2t}=\xi_t$ 是随时间变化的宏观冲击，假设其对所有公司的影响相同，即因子载荷为 $\lambda_{i2}=1$，则：

$$
\mathbf{\lambda}_i'F_t = \alpha_i+ \xi_t
$$

此时，(10) 式就是我们平时所使用的「双向固定效应模型」：[^10]

$$
Y_{it}=\mathbf{X}_{it}'\beta + \alpha_i+\xi_t + \varepsilon_{it} \tag{11}
$$

实证分析中常用的交互固定效应模型还会包含 $\alpha_{i}$ 和 $\delta_{t}$ (参见 Bai, [2009](https://sci-hub.ren/10.3982/Ecta6135), Eq. (4), p.1233)：

$$
Y_{it}=\mathbf{X}_{it}^{\prime} \beta+\alpha_{i}+\delta_{t}+\lambda_{i}^{\prime} F_{t}+\varepsilon_{it} \tag{12}
$$

Stata 命令为：

```stata
   . regife y x1 x2, absorb(id year) ife(id year, 1)
```

### 扩展模型

更一般化的设定如下 (参见 Bai, [2009](https://sci-hub.ren/10.3982/Ecta6135), Eq. (3), p.1230)：

$$
X_{it}=\tau_{i}+\theta_{t}+\sum_{k=1}^{r} a_{k} \lambda_{i k}+\sum_{k=1}^{r} b_{k} F_{k t}+\sum_{k=1}^{r} c_{k} \lambda_{i k} F_{k t}+\pi_{i}^{\prime} G_{t}+\eta_{it},
$$

其中，$a_{k}, b_{k}$ 和 $c_{k}$ 均为常数或常向量，$G_{t}$ 是另一组未出现在方程 $Y_{it}$ 中的共同因子。因此，$X_{it}$ 可以与 $\lambda_{i}$ 或 $F_{t}$ 相关，甚至可以与二者都相关。在给定一些限制性条件后，$\lambda_{i}$，$F_{t}$，以及 $\beta$ 都可以被直接估计出来。

当然，实证分析中或许不需要这么一般化的模型。我们可以在复杂度和解释力度之间作出权衡，设定一个折中的模型 (Pesaran, 2006)，例如，

$$
Y_{it} =
\underset{\text{可观测}}{\underbrace{\boldsymbol{\alpha}_{i}'\mathbf{d}_t + \mathbf{X}_{it}^{\prime} \beta }}
+
\underset{\text{不可观测}}{\underbrace{\boldsymbol{\lambda}_{i}^{\prime} \mathbf{F}_{t} + \varepsilon_{it}}} \tag{13}
$$

其中，$\mathbf{d}_t$ 是一组时间维度上的变量，比如 $T-1$ 个年度虚拟变量 (假设 $\mathbf{X}$ 中包含常数项)，也可以是前文提到的 人均 GDP 增长率 ($gdp_t$)，货币增速 ($m_t$)，经济政策不确定性 ($epu_t$) 等宏观变量。注意，这些变量都是可观测的，他们用来刻画 $\mathrm{E}\left(Y_{i t}\right)$ 的变化特征。与之对应的是「不可观测部分」，即 $\lambda_i^{\prime} \mathbf{F}_t+\varepsilon_{i t}$ ，它刻画的是干扰项的特征。换言之，若把（ $\mathbf{d}_t, \mathbf{F}_t$ ）视为所有宏观经济因素构成的集合，我们把可观测部分 $\mathbf{d}_t$ 作为解释变量来处理，而那些不可观测的则放入复合干扰项 $u_{i t}=\lambda_i^{\prime} \mathbf{F}_t+\varepsilon_{i t}$ 中，从而最大限度地克服了遗漏变量偏误。

举个具体的例子。假设我们重点关注 $epu_t$ 的影响，此时模型中无法同时加入 $\lambda_t$ (会导致完全共线性)，但我们又需要控制其它宏观变量的影响 (以免产生遗漏变量偏误)，可以把 (13) 设定成如下形式：

$$
Y_{it} = \alpha_{i} + \mathbf{X}_{it}^{\prime} \beta + epu_{t}\gamma + z_1\theta_1  + z_2\theta_2 + \lambda_{i}^{\prime} F_{t}+\varepsilon_{it} \tag{14}
$$

其中，$z_{1t}, z_{2t}$ 是除了 $epu_t$ 以外的其它可以观测的宏观经济变量，如 人均 GDP 增长率 ($gdp_t$)，货币增速 ($m_t$)，利率水平 ($interest_t$) 等，也可以包括反应某些特定时间段的虚拟变量，如 $crisis = \mathbf{I}(2008\leq t \leq 2009)$。[^11] Stata 命令为：

```stata
   . regife y x1 x2 epu m2 gdp, absorb(id) ife(id year, 1)
```

Bai (2009, eq. (35)-(37)) 还建议了一些更一般化的模型设定方式。先考虑如下基本模型：

$$
Y_{i t}=X_{i t}^{\prime} \beta+\mu+\alpha_{i}+\xi_{t}+\lambda_{i}^{\prime} F_{t}+\varepsilon_{i t} \tag{15}
$$

其中，$\mu$ 是总体均值，$\alpha_{i}$ 是固定效应，$\xi_{t}$ 是时间效应，而 $\lambda_{i}^{\prime} F_{t }$ 是交互效应。为了防止共线性，只需放入 $N-1$ 个个体虚拟变量和 $T-1$ 个时间虚拟变量即可 (参见 Greene (2000, p. 565))，即

$$
\sum_{i=1}^N \alpha_i=0, \quad \sum_{t=1}^T \xi_t=0 \tag{16}
$$

若进一步加入非时变变量 ($x_{i}$) 和宏观变量 ($w_{t}$)，则 (15) 变为：

$$
Y_{i t}=X_{i t}^{\prime} \varphi+\mu+\alpha_{i}+\xi_{t}+x_{i}^{\prime} \gamma+w_{t}^{\prime} \delta+\lambda_{i}^{\prime} F_{t}+\varepsilon_{i t} \tag{17}
$$

还可以做进一步扩展，以便允许非时变变量 ($x_{i}$) 和宏观变量 ($w_{t}$) 的影响具有截面异质性：

$$
Y_{i t}=X_{i t}^{\prime} \phi+\mu+\alpha_{i}+\xi_{t}+x_{i}^{\prime} \gamma_{t}+w_{t}^{\prime} \delta_{i}+\lambda_{i}^{\prime} F_{t}+\varepsilon_{i t} \tag{18}
$$

相对于传统固定效应模型，交互固定效应模型具有更普遍的现实意义。 例如，在研究收入时，固定效应通常捕获了无法观测的能力因素。 而现有研究表明，其他个人习惯或特征，如动机、奉献精神、毅力、努力工作、甚至自尊心都是决定收入的重要因素 (Cawley 等，2003；Carneiro 等，2003)。然而，这些特征对收入的影响可能会随着时间发生变化。 举例而言，雇主对劳动者个人能力的准确评估需要一定的时间，而工作收入取决于雇主对这些个人能力和特征的评估。因此 $F_t$ 可以视为雇主雇佣劳动者 $T$ 期后对劳动者个人特征的评价。在宏观上，$F_t$ 可以视为共同冲击，$\lambda_i$ 代表对这些共同冲击的异质性反应 (Bai，2009)。

上述模型可以使用 `xtdcce2` 和 `xtivdfreg` 等命令进行估计，以便允许 $\mathbf{x}_{it}$ 的系数可变，或在 $\mathbf{x}_{it}$ 中包含 $y_{it}$ 的一阶滞后项 $y_{it-1}$，甚至是采用 IV 估计控制内生性问题。

## 估计方法

由于交互固定效应的特殊形式，传统的静态面板估计方法 (组内估计量、差分估计量、以及 LSDV 方法) 一般都不能得到一致性的估计 (Bai, 2009, p.1230)，因此需要寻求更加有效的估计方法。交互固定效应的估计思路大致可以分为两类：一类是尝试消去交互固定效应，如 Holtz-Eakin 等 (1988)，Ahn 等 (2001)；另一类的基本思想则是控制或估计，如 Pesaran (2006)，Bai (2009)。下面简要介绍其中几种方法。

### 准差分法

对于只含有一个共同因子的模型，可以使用准差分法消去交互固定效应 (Holtz-Eakin et al., 1988)。 假设共同因子 $f_t$ 是外生的 (如宏观经济冲击)，因子载荷 $b_i$ 则是内生的，对于如下模型：

$$
y_{it}=\beta x_{it}+b_if_t+\varepsilon_{it} \tag{19}
$$

设定，$r_t=f_t/f_{t-1}$，则在 (19) 式的一阶滞后式 ($y_{i,t-1}$) 两边同时乘以 $r_t$ 可得：

$$
r_ty_{i,t-1}=r_t\beta x_{i,t-1}+b_ir_tf_{t-1}+r_t\varepsilon_{i,t-1} \tag{20}
$$

用 (19) 式减去 (20) 式，便可消去内生的因子载荷 $b_i$：

$$
\begin{aligned}
y_{it}&=r_ty_{i,t-1}+\beta x_{it}-\beta r_tx_{i,t-1}+\left(\varepsilon_{it}-r_t\varepsilon_{i,t-1}\right)\\
&=r_ty_{i,t-1}+\beta x_{it}-\beta r_tx_{i,t-1}+\varepsilon_{it}^*
\end{aligned} \tag{21}
$$

对于准差分后的模型:

$$
\begin{aligned}
y_{it}&=r_ty_{i,t-1}+\beta x_{it}-\beta r_tx_{i,t-1}+\left(\varepsilon_{it}-r_t\varepsilon_{i,t-1}\right)\\
&=r_ty_{i,t-1}+\beta x_{it}-\beta r_tx_{i,t-1}+\varepsilon_{it}^*
\end{aligned} \tag{22}
$$

从形式上来看，模型 (22) 可以视为一个变系数 ($r_t$) 动态面板模型。 可以将 $\{r_1, r_2, r_3, ...\}$ 作为待估参数，用更高阶的滞后项作为工具变量，使用 GMM 进行估计 (详见 Holtz et al., 1988)。该方法的局限在于：每执行一次准差分操作，只能去除一个共同因子。因此，若模型中包含 $r$ 个共同因子，就需要进行 $r$ 次准差分。显然，每次准差分都会损失一些信息。更为棘手的是，每一次准差分都要采用 GMM 估计一次，这难免涉及工具变量合理性检验问题 (如，过度识别检验)。

### 主成分两步法

主成分两步法由 Coakey et al. (2002) 提出，其基本思想是采用主成分分析法估计共同因子，进而将其作为控制变量加入回归方程。 对于交互固定效应模型：

$$
Y_{i t}=\mathbf{X}_{i t}^{\prime} \beta+u_{i t}, \quad u_{i t}=\lambda_i^{\prime} F_t+\varepsilon_{i t} \tag{23}
$$

**第一步**，估计共同因子。假设共同因子与解释变量不相关，即 $E(u_{it}|\mathbf{X}_{it})=0$，我们可以先不考虑因子结构，直接对 $Y_{it}=\mathbf{X}_{it}'\beta+ u_{it}$ 执行混合 OLS 估计，得到 $\beta$ 的 POLS 估计 $\widehat{\beta}_{OLS}$，以及残差 $\widehat{u}_{it} = Y_{it}-\mathbf{X}_{it}'\widehat{\beta}_{OLS}$，进而对残差进行主成分分析 (PCA)，即估计如下因子模型：

$$
\widehat{u}_{it} = \mathbf{\lambda}_i'F_t+\varepsilon_{it} \tag{24}
$$

由此可获得因子得分最高的 $r$ 个主成分，作为 $F_t$ 的估计值，记为 $\widehat{F}_t$。

**第二步**，估计 $\widehat{\beta}$。用 $\widehat{F}_t$ 做控制变量，对下式执行 OLS 估计，以获得 $\beta$ 的估计值 $\widehat{\beta}$:

$$
Y_{it}=\mathbf{X}_{it}'{\beta}+\mathbf{\lambda}_i'\hat F_t+\varepsilon_{it} \tag{25}
$$

### 主成分迭代法

Pesaran (2006) 指出，若共同因子与解释变量相关 (这是实际应用中的非常普遍的状况)，采用 Coakey et al. (2002) 的两阶段估计法得到的估计量是不一致的。 为此，Bai (2009) 建议采用“主成分迭代法”：对模型施加一些基本的约束条件，以便参数能够识别，进而将 Coakey et al. (2002) 的两步法不断迭代，直到收敛，最终可得一致估计量。

主成分迭代法要求面板数据为「大 $N$ 大 $T$」结构，同时因子与因子载荷都可以是内生的 (即 $\mathbf{F}_t$ 可以与 $\mathbf{X}_{it}$ 相关)。Bai (2009, pp.1262) 的蒙特卡洛模拟分析表明，当 $N$ 较小时，IntFE 估计量是不一致的。这意味着，在省级面板中要谨慎使用该模型。

模型的具体估计过程和假设条件参见“附：Bai (2009) 的迭代主成分估计法” 小节。有关因子模型和主成分分析的相关介绍参见 Bai and Wang ([2016](https://sci-hub.yncjkj.com/10.1146/annurev-economics-080315-015356)) 以及 Fan et al. ([2021](https://www.annualreviews.org/doi/10.1146/annurev-financial-091420-011735), Section 3)。非平行面板情形下的估计方法参见 Czarnowske and Stammann ([2020](https://arxiv.fenshishang.com/pdf/2004.03414.pdf))。

## Stata 实现

在 Stata 中可以使用 `regife` 命令估计 Bai (2009) 的 IntFE 模型。该命令依赖于外部命令 `reghdfe` 和 `hdfe`，需要一并安装：

```stata
ssc install regife, replace
ssc install reghdfe, replace
ssc install hdfe, replace
```

下面用 Stata 手册数据加以演示：

```stata
. webuse "nlswork.dta", clear
. keep if id <= 100
. regife ln_w tenure, f(id year, 1)                   //考虑一维交互固定效应
. regife ln_w tenure, a(id) f(id year, 1)             //加入个体固定效应
. regife ln_w tenure, a(id year) f(id year, 1)        // 加入个体和时间固定效应
. regife ln_w tenure, f(fid = id fyear = year, 1)
     //生成因子载荷和共同因子并保存在新变量fid、fyear中
. regife ln_w tenure, f(id year, 1) residuals(newvar) //保存残差项
```

我们可以对比一下单向固定效应、双向固定效应以及交互固定效应的估计结果：

```stata
qui:xtreg ln_w tenure, fe         //只考虑地区固定效应
est store idfe
qui:xtreg ln_w tenure i.year, fe  //只考虑时间和地区固定效应
est store idyearfe
regife ln_w tenure, a(id year) f(id year, 1) //考虑时间、地区固定效应和一维交互效应
est store idyearinterfe
esttab idfe idyearfe idyearinterfe, drop(*.year) nogap  //输出结果

. esttab idfe idyearfe idyearinterfe, drop(*.year) nogap  //输出结果

------------------------------------------------------------
                      (1)             (2)             (3)
                  ln_wage         ln_wage         ln_wage
------------------------------------------------------------
tenure             0.0394***       0.0258***       0.0118*
                   (8.47)          (4.65)          (2.02)
_cons               1.755***        1.649***        1.837***
                  (99.41)         (30.68)         (94.79)
------------------------------------------------------------
N                     570             570             561
------------------------------------------------------------
t statistics in parentheses
* p<0.05, ** p<0.01, *** p<0.001
```

可以看出，考虑的固定效应越多，系数的值越来越小，显著性越来越弱，说明因变量受到时间、地区以及两者交互效应的影响较大。

交互固定效应模型的发展非常迅猛，除了 `regife`，其它命令还包括：`reghdfe`，`xtmg`, `xtcce`, `xtdcce2`, `xtivdfreg`, `xtcd`, `xtcaec` 等。

如需了解更多信息，可以在 Stata 命令窗口中检索如下关键词：

```stata
   . findit interactive fixed
   . findit common correlated
   . findit common factor
```

## 参考文献

Bai, J. S., 2009, Panel data models with interactive fixed effects, Econometrica, 77 (4): 1229-1279. [Link](https://academic.microsoft.com/paper/2128249713/reference), [PDF](https://sci-hub.ren/10.3982/Ecta6135), [Citedby](https://academic.microsoft.com/paper/2128249713/citedby)

Bai, J. S., and S. Ng. 2021. Matrix Completion, Counterfactuals, and Factor Analysis of Missing Data. Journal of the American Statistical Association, 116(536): 1746-1763. [Link](https://doi.org/10.1080/01621459.2021.1967163 ), [PDF](http://sci-hub.ren/10.1080/01621459.2021.1967163)

Bai, J., \& Wang, P. (2016). Econometric Analysis of Large Factor Models. Annual Review of Economics, 8(1), 53–80. [Link](https://academic.microsoft.com/paper/1953394243/citedby), [PDF](https://sci-hub.yncjkj.com/10.1146/annurev-economics-080315-015356)

Kripfganz, S., Sarafidis, V. (2021). Instrumental-variable estimation of large-T panel-data models with common factors. The Stata Journal, 21(3), 659-686. [PDF1](https://journals.sagepub.com/doi/pdf/10.1177/1536867X211045558)

### 相关应用
Kim, D., \& Oka, T. (2014). Divorce law reforms and divorce rates in the USA: an interactive fixed‐effects approach. Journal of Applied Econometrics, 29(2), 231-245.

Kassouri, Y., Altıntaş, H., Alancioğlu, E., \& Kacou, K. Y. T. (2021). New insights on the debt-growth nexus: A combination of the interactive fixed effects and panel threshold approach. International Economics, 168, 40-55.

Shi, W., \& Lee, L. F. (2018). The effects of gun control on crimes: a spatial interactive fixed effects approach. Empirical economics, 55(1), 233-263.

Westerlund, J., Karabiyik, H., Narayan, P. K., \& Narayan, S. (2021). Estimating the speed of adjustment of leverage in the presence of interactive effects. Journal of Financial Econometrics.

Chan, M. K., \& Kwok, S. (2016). Policy evaluation with interactive fixed effects. Preprint. [PDF](http://econ-wpseries.com/2016/201611.pdf) 使用回归控制法 (Hsiao, 2012), 交互固定效应模型 (Bai, 2009), DID, CCE-DID 等方法估计了 Hsiao (2012) 文中的「香港回归」案例的政策效果

### 一些论文的重现数据和代码

Gobillon, L., \& Magnac, T. (2016). Regional Policy Evaluation: Interactive Fixed Eects and Synthetic Controls. The Review of Economics and Statistics, 98(3), 535–551. [Link](https://academic.microsoft.com/paper/2170775246/citedby), [PDF](http://sci-hub.ren/10.1162/REST_A_00537), [Data and R-Codes](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/LJGLDK)

Liu, H. (2019). The communication and European Regional economic growth: The interactive fixed effects approach. Economic Modelling, 83, 299-311. [Link](https://doi.org/10.1016/j.econmod.2019.07.016), [PDF](http://sci-hub.ren/10.1016/j.econmod.2019.07.016), [R-codes](https://github.com/kautu/ereg)

Hagedorn et al. ([2015](http://pirate.shu.edu/~rotthoku/Liberty/The%20Impact%20of%20Unemployment%20Benefit%20Extensions%20on%20Employment.pdf)) 在 DID 模型中加入了交互固定效应，分析了美国国会于 2013 年末将失业救济时长统一缩短为 26 周这一政策产生的影响。

[^1]: 事实上，此类模型在面板数据文献中由来已久 (参见 Bai, 2009, pp.1231)。Goldberger (1972), Jöreskog and Goldberger (1975) 等学者最早将引入因子模型引入计量经济学，但他们并未考虑这些因子 (通常置于干扰项中) 与解释变量之间的相关性。Kneip, Sickles, and Song (2005) 则假设 $F_{t}$ 是 $t$ 的平滑函数，并采用平滑样条函数 (smoothing spline) 进行估计。与 Bai (2009) 模型最为接近的是单因子交互模型，参见 Holtz-Eakin, Newey, and Rosen (1988) 和 Ahn, Lee, and Schmidt (2001)。Pesaran (2006) 提出的「均组估计量 (mean group estimator)」则是与 Bai (2009) 使用的主成分迭代估计量并行的估计方法。
[^2]: 参见 Bai (2009) 在微软学术中的 [被引文献](https://academic.microsoft.com/paper/2128249713/citedby)。
[^3]: 这里需要强调的是，在 TFE 模型中，$\lambda_t$ 是时间虚拟变量 $B_t$ 的系数，是一个待估参数。
[^4]: 为便于理解，可以写出对应的 Stata 命令：`reg y x i.id i.year i.id\#i.year`。
[^5]: 为了防止完全共线性，模型中不再包含 $\lambda_t$。当然，也可以保留 $\lambda_t$，但需要删去一个行业虚拟变量。
[^6]: 有关该模型的详细介绍和相关应用，参见 Wooldridge (2010, Sec 11.7, pp. 374-381)。
[^7]: 若模型中不包含 $\lambda_t$ 则 $\theta_{i}$ 表示每个个体的平均变化趋势 (原值)，否则表示与所有个体的平均变化趋势的差值。
[^8]: 需要注意的是，这里的 `i.year` 表示 $T$ 个时间虚拟变量，而 `c.year` 则被视为一个连续变量，它只表示一个变量。
[^9]: 例如，一个简单的二因子模型可以表示为：$y_{it}=x_{it} \beta+\lambda_{1i} F_{1t}+\lambda_{2i} F_{2t}+\varepsilon_{it}$。
[^10]: 若设定 $\lambda_t=[\alpha_i\ 0]', F_t=[1\ \xi_t]'$，则 $\mathbf{\lambda}_i'F_t=\alpha_i$，此时，$Y_{it}=\mathbf{X}_{it}'\beta + \alpha_i + \varepsilon_{it}$，即普通的固定效应模型。同理，若 $\lambda_t=[0\ 1]', F_t=[1\ \xi_t]'$，可得 $\mathbf{\lambda}_i'F_t = \xi_t$。
[^11]: 在模型中放入 $\lambda_t$，即 $T$ 个年度虚拟变量会导致完全共线性，但放入个别年度或某个时间段的虚拟变量则不会导致此问题。
[^12]: 需要说明的是，此处的数据存放方式与 Stata 中常规的数据存放方式有差别。 Stata 中常规的面板数据形式为「长条型 (long format)」，即每家公司的因变量 $y_i$ 是一个 $T\times 1$ 维列向量，所有公司的数据纵向堆叠，最终形成一个 $NT \times 1$ 维的列向量 $Y$。与之不同的是，在 (27) 式中，$Y$ 是由每家公司的 $T\times 1$ 列向量横向拼接而成的「扁平型 (wide format)」矩阵。由于 $x_i$ 中包含 $K$ 的变量，因此，最终的 $X$ 矩阵可以视为 $K$ 个与 $Y$ 矩阵尺寸相当的矩阵的拼接，其维度为 $T \times K \times N$。
[^13]: 初始值的获取有多种方式。比如，可以用 $Y_{it}$ 对 $\mathbf{X}_{it}$ 的 OLS 估计作为 $\beta$ 的初始值。也可以在上述估计过程中加入 $\mathbf{X}_{it}$ 中各个变量的年度均值作为控制变量，这可以在一定程度上控制宏观经济冲击，也可以将它们视为 $F_t$ 的组成部分。另一个更好的办法是使用 Pesaran (2006) 提出的共同相关效应“组均估计量” (Common Correlated Effects Mean Group estimator) 和增广组均估计量 (Augmented Mean Group estimator)，Stata 命令为 `xtmg`。
