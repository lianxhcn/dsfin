
> **作者：** 左志勇(中山大学)        
> **E-mail:**  <zuozhy6@mail2.sysu.edu.cn>

&emsp;


> **编者按**：本文部分摘译自下文，特此致谢！  
> **Source**：
>- Correia S, Guimarães P, Zylkin T. Fast Poisson estimation with high-dimensional fixed effects[J]. The Stata Journal, 2020, 20(1): 95-115. [-PDF-](https://arxiv.org/pdf/1903.01690.pdf)
>- Sul D. Panel Data Econometrics: Common Factor Analysis for Empirical Researchers[M]. 2019.

&emsp;

## 1. 什么是引力模型？

引力模型的思想和概念源自经典物理学中的万有引力定律：

$$
F=\frac{G \cdot m_{1}\cdot m_{2}}{r^{2}}
\quad (1)
$$

式中 $F$ 为两物体之间的引力大小，其与两物体的质量乘积 $M_{1}$ 和 $M_{2}$ 成正比，而与两物体之间的距离平方 $r^{2}$ 成反比， $G$ 为引力常数。

最早将引力模型用于研究国际贸易的是 Tinbergen(1962) 和 Poyhonen(1963) ，他们分别独立使用引力模型研究分析了双边贸易流量，并得出了相同的结果：两国双边贸易规模与他们的经济总量成正比，与两国之间的距离成反比，其中 Tinbergen(1962) 列出的引力模型标准式为：

$$
F_{ij}=\frac{Gm_{i}^{\beta_{1}}m_{j}^{\beta_{2}}}{d_{ij}^{\beta_{3}}}
\quad (2)
$$

其中 $F_{ij}$ 为 $i$ 国与 $j$ 国之间的贸易总额（取绝对值）， $m_{i}$ 与 $m_{j}$ 为两国经济总量， $d_{ij}$ 代表两国之间的地理距离， $G$ 为常数，为使 $(2)$ 式能够进行线性估计，将其转化为对数形式：

$$
\ln F_{ij}=\ln G+\beta_{1}\ln m_{i}+\beta_{2}\ln m_{j}-\beta_{3}\ln d_{ij}
\quad (3)
$$

相比于国际贸易理论中经典的Heckscher-Ohlin模型，引力模型在形式上更接近一个多因素模型，我们不妨写出引力模型的面板形式：

$$
f_{ij,t}=\ln G+\beta_{1}\ln m_{it}+\beta_{2}\ln m_{jt}-\beta_{3}\ln d_{ij}+\epsilon_{ij,t}
\quad (4)
$$

式中 $\epsilon_{ij,t}$ 为模型扰动项，且 $f_{ij,t}=\ln F_{ij}$ 。在这种情况下 $\ln m_{it}$ 和 $\ln m_{jt}$ 成为影响 $f_{ij,t}$ 的共同因子（Common Factors），而地理距离变量 $d_{ij}$ 则控制不随时间变动的国家对固定效应。

基于 $(4)$ 式，我们即可在确定如何衡量经济规模（如名义GDP）与国家间距离（如两国首都直线距离）后利用简单的OLS回归得出系数估计结果了，这也是最基本的三因素引力模型。

该模型也被用于解释国际贸易以外的问题，如分析城市之间的贸易流量、区域之间的交通流量与人口迁移流量等。

进一步地，如果我们认为 $(4)$ 式是对现实经济结构的正确表述，那么 $\ln m_{it}$ 和 $\ln m_{jt}$ 其实并不需要被确定为某一数值变量（如该国的经济规模等），而可以替换为国家-时间固定效应，同时 $\ln d_{ij}$ 也可以与 $(4)$ 式中的常数项相结合，成为国家对固定效应，即有如下三维固定效应引力模型：

$$
f_{ij,t}=a_{ij}+\theta_{it}+\theta_{jt}+\epsilon_{ij,t}
\quad (5)
$$

即 $f_{ij,t}$ 由三个维度的因素影响， $a_{ij}$ 是不随时间变化的个体对固定效应， $\theta_{it}$ 和 $\theta_{jt}$ 是随时间变化的两个共同因子，但是 $\theta_{it}$ 不随 $j$ 变化，是 $i$ 自身的因素； $\theta_{jt}$ 随 $j$ 变化，是与 $i$ 贸易的对象的因素。根据这三个维度的特点，可以利用组内和组间均值的差异进行共同因素的识别。

&emsp;
 
## 2. 三维引力模型的系数估计方法

### 2.1 高维固定效应面板OLS估计

直观上理解，我们以 $(5)$ 式为基础直接进行高维固定效应面板OLS回归似乎并无不妥，然而：

* 考虑到 $f_{ij,t}=\ln F_{ij}$ ，当某两国之间的贸易总额为 0 时，取自然对数后贸易数据会出现缺失进而导致估计结果出现样本选择偏差，尽管可以采取 $f_{ij,t}=\ln\big(F_{ij}+1)$ 的变量定义修正来解决此问题，但是这样可以证明估计量是不一致的 (Santos Silva and Tenreyro, 2006)，并且如果零值很多，那么因变量微小的调整会导致模型估计系数和模型的解释力变化很大。

* 被解释变量存在着分布离散的特征，与一般OLS回归形式依赖样本服从正态分布的假设不同，这可能会造成较严重的异方差问题从而导致参数估计失去有效性且影响显著性判断。

基于以上理由，我们考虑采用其他方法对引力模型进行系数估计。

### 2.2 偏移估计

为估计 $\theta_{it}$ 和 $\theta_{jt}$ ，首先在 $T$ 的维度上求均值，以此消除不随时间变化的个体效应：

$$
\frac{1}{T}\sum_{t=1}^T f_{ij,t}=a_{ij}+\frac{1}{T}\sum_{t=1}^T \theta_{it}+\frac{1}{T}\sum_{t=1}^T \theta_{jt}+\frac{1}{T}\sum_{t=1}^T \epsilon_{ij,t}
\quad (6)
$$

令上标 '~' 表示变量相对于其时间序列均值的偏离，例如 $\tilde{f}_{ij,t}=f_{ij,t}-\frac{1}{T}\sum_{t=1}^T f_{ij,t}$，则由 $(5)$ 式减去 $(6)$ 式不难得到：

$$
\tilde{f}_{ij,t}=\tilde{\theta}_{it}+\tilde{\theta}_{jt}+\tilde{\epsilon}_{ij,t}
\quad (7)
$$

其次，考虑两个共同因子的特性，按照 $i$ 或者 $j$ 求截面均值，另一个因子没有变化，由此消去这个共同因子的影响。令 $(7)$ 式对 $i$ 取截面平均：

$$
\frac{1}{n}\sum_{i=1}^n \tilde{f}_{ij,t}=\frac{1}{n}\sum_{i=1}^n \tilde{\theta}_{it}+\tilde{\theta}_{jt}+\frac{1}{n}\sum_{i=1}^n \tilde{\epsilon}_{ij,t}
\quad (8)
$$

将 $(7)$ 式减去 $(8)$ 式：

$$
\hat{f}_{ij,t}=\tilde{f}_{ij,t}-\frac{1}{n}\sum_{i=1}^n \tilde{f}_{ij,t}=(\tilde{\theta}_{it}-\frac{1}{n}\sum_{i=1}^n \tilde{\theta}_{it})+(\tilde{\epsilon}_{ij,t}-\frac{1}{n}\sum_{i=1}^n \tilde{\epsilon}_{ij,t})
\quad (9)
$$

由于 $\tilde{\theta}_{it}-\frac{1}{n}\sum_{i=1}^n \tilde{\theta}_{it}$ 不随 $j$ 变化，而 $\tilde{\epsilon}_{ij,t}-\frac{1}{n}\sum_{i=1}^n \tilde{\epsilon}_{ij,t}$ 随 $j$ 变化，则在 $(4)$ 式是正确识别的条件下，回归残差满足 $E_i(\epsilon_{ij,t})=E_j(\epsilon_{ij,t})=E_t(\epsilon_{ij,t})=E(\epsilon_{ij,t})=0$（残差不与 $a_{ij},\theta_{it},\theta_{jt}$ 相关）。所以在 $j$ 维度上求均值可以抵消 $\tilde{\epsilon}_{ij,t}-\frac{1}{n}\sum_{i=1}^n \tilde{\epsilon}_{ij,t}$ ，从而识别出 $\tilde{\theta}_{it}-\frac{1}{n}\sum_{i=1}^n \tilde{\theta}_{it}$ 。

基于此，当 $m$ 的值足够大时，我们令 $(9)$ 式再对 $j$ 取截面平均：

$$
\frac{1}{m}\sum_{j=1}^m \hat{f}_{ij,t}=\hat{\theta}_{it}+\frac{1}{m} \sum_{j=1}^m \tilde{\epsilon}_{ij,t}-\frac{1}{m}\sum_{j=1}^m \sum_{i=1}^n \frac{1}{n}\tilde{\epsilon}_{ij,t} \approx \hat{\theta}_{it} 
\quad (10)
$$

式中 $\hat{\theta}_{it}=\tilde{\theta_{it}}-\frac{1}{n}\sum_{i=1}^n \tilde{\theta_{it}}$ ，代表 $\tilde{\theta_{it}}$ 在固定 $t$ 维度的条件下相对于其个体序列均值的偏移，且消去了不随时间变化的个体效应以及另一个共同因子的影响，因而可以作为 $\theta_{it}$ 的估计量，展开 $(10)$ 式不难得到：

$$
\hat{\theta}_{it}=\frac{1}{m}\sum_{j=1}^m \big(f_{ij,t}-\frac{1}{T}\sum_{t=1}^T f_{ij,t}-\frac{1}{n}\sum_{i=1}^n f_{ij,t}+\frac{1}{T}\sum_{t=1}^T \frac{1}{n}\sum_{i=1}^n f_{ij,t})
\quad (11)
$$

完全对称地，我们也可以得到：

$$
\hat{\theta}_{jt}=\frac{1}{n}\sum_{i=1}^n \big(f_{ij,t}-\frac{1}{T}\sum_{t=1}^T f_{ij,t}-\frac{1}{m}\sum_{j=1}^m f_{ij,t}+\frac{1}{T}\sum_{t=1}^T \frac{1}{m}\sum_{j=1}^m f_{ij,t})
\quad (12)
$$

值得注意的是， $(11)$ 和 $(12)$ 式仅在 $(5)$ 式条件满足，即贸易模型可被表征为一个三维固定效应模型时才成立。如果共同因子数量 $>$ 2（例如“进口国#时间”这一固定效应可能包含该国在当年的名义GDP与第三产业占比等多个实际变量），上式所表示的估计就是错误的（Anderson and Wincoop, 2003）。当我们需要考察具体因素（如贸易协定）对贸易额的影响时，偏移估计并不能给我们提供有效的信息。

另外，偏移估计仅提供了对模型参数的估计，而无法对其进行显著性检验。

### 2.3 高维固定效应面板泊松伪最大似然估计 (PPMLHDFE)

泊松回归通常意义上是估计「计数数据模型」的标准方法，Gourieroux 等 (1984) 通过放松因变量分布的假设，使泊松回归不再局限于计数数据。作为泊松回归的一种简单拓展，泊松伪极大似然（Poisson Pseudo Maximum Likelihood，PPML）估计法被广泛用于估算含有大量零值且存在异方差的贸易数据，即使因变量不服从泊松分布，PPML回归也能得到一致无偏的估算结果。

Correia S et al. (2020) 进一步修正了 PPML 估计法，在存在高维固定效应（Multiple High-Dimensional Fixed Effects）的前提下进行 PPML 回归，称为高维固定效应泊松伪极大似然估计法（PPMLHDFE）。与PPML估计法相比，PPMLHDFE估计法可以更为稳健地检验伪极大似然估计。

**IRLS 算法**

GLM 是基于 Nelder 和 Wedderbum (1972) 引入的指数分布族的一类回归模型，主要包括流行的非线性回归模型，例如 Logit、Probit、Cloglog 和 Poisson 。 Hardin 和 Hilbe (2018) 将指数族定义如下：

$$
f_{y}(y ; \theta, \phi)=\exp \left\{\frac{y \theta-b(\theta)}{a(\phi)}+c(y, \phi)\right\}
$$

其中，$a(\cdot)$、$b(\cdot)$ 和 $c(\cdot)$是特定函数，$\phi$ 和 $\theta$是参数。对于这些模型而言：

$$
E(y)=\mu=b^{\prime}(\theta)
$$

$$
V(y)=b^{\prime \prime}(\theta) a(\phi)
$$

给定一组具有 $n$ 个独立的观察值，每个观察值均由 $i$ 索引，可以通过链接函数 $g(.)$ 将期望值与一组协变量 ($x_i$) 关联。更具体地说，假设下式：

$$
E\left(y_{i}\right)=\mu_{i}=g^{-1}\left(\mathbf{x}_{i} \boldsymbol{\beta}\right)
$$

则 GLM 的似然函数可以写为：

$$
L\left(\theta, \phi ; y_{1}, y_{2}, \ldots, y_{n}\right)=\prod_{i=1}^{n} \exp \left\{\frac{y_{i} \theta_{i}-b\left(\theta_{i}\right)}{a(\phi)}+c\left(y_{i}, \phi\right)\right\}
$$

通过求解 (伪) 似然最大化的一阶条件，得到 $β$ 的估计。应用高斯-牛顿算法和期望 Hessian 函数导出修正方程为：

$$
\boldsymbol{\beta}^{(r)}=\left(\mathbf{X}^{\prime} \mathbf{W}^{(r-1)} \mathbf{X}\right)^{-1} \mathbf{X}^{\prime} \mathbf{W}^{(r-1)} \mathbf{z}^{(r-1)}  \tag{13}
$$

其中 $\mathbf{X}$ 是解释变量矩阵，$\mathbf{W}^{(r-1)}$ 是权重矩阵，$\mathbf{Z}^{(r-1)}$ 是因变量的变换，$r$ 是迭代索引。式 $(13)$ 表明 $β$ 的估计值是通过加权最小二乘法递归而获得，这种方法称之为 IRLS。

**泊松伪极大似然估计 (PPML)**

泊松回归定义如下：

$$
E\left(y_{i}\right)=\mu_{i}=\exp \left(\mathbf{x}_{i} \boldsymbol{\beta}\right) \tag{14}
$$


实现 IRLS 的回归权重可以简化为：

$$
\mathbf{W}^{(r-1)}=\operatorname{diag}\left\{\exp \left(\mathbf{x}_{i} \boldsymbol{\beta}^{(r-1)}\right)\right\} \tag{15}
$$

而中间回归的因变量则为:

$$
z_{i}^{(r-1)}=\left\{\frac{y-\exp \left(\mathbf{x}_{i} \boldsymbol{\beta}^{(r-1)}\right)}{\exp \left(\mathbf{x}_{i} \boldsymbol{\beta}^{(r-1)}\right)}+\mathbf{x}_{i} \boldsymbol{\beta}^{(r-1)}\right\} \tag{16}
$$

因此，在 $(13)$ 中实现 IRLS 更新回归仅需要计算在先前迭代中获得拟合值$\mathbf{x}_{i} \boldsymbol{\beta}^{(r-1)}$的向量即可。

**处理 HDFE**

在 HDFE 下，IRLS 的困难是 $\mathbf{X}$ 可能包含很多固定效应，导致无法直接计算 $\left(\mathbf{X}^{\prime} \mathbf{W}^{(r-1)} \mathbf{X}\right)$。解决方案是使用一个替代的公式，即只估计非固定效应协变量的系数 (例如，$\boldsymbol{\delta}$)，从而降低维数。由于式 $(13)$ 是加权线性回归，因此可以依靠 FWL 定理来探讨固定效应。这意味着代替式 $(13)$，可以使用下式：

$$
\boldsymbol{\delta}^{(r)}=\left(\tilde{\mathbf{X}}^{\prime} \mathbf{W}^{(r-1)} \tilde{\mathbf{X}}\right)^{-1} \tilde{\mathbf{X}}^{\prime} \mathbf{W}^{(r-1)} \widetilde{\mathbf{z}}^{(r-1)} \tag{17}
$$

其中，$\tilde{\mathbf{X}}$ 和 $\widetilde{\mathbf{Z}}$ 分别是主协变量矩阵 $\mathbf{X}$ 和因变量 $\mathbf{z}$ 的变换后的加权。此外，FWL 定理还暗示从式 $(17)$ 计算的残差与从式 $(13)$ 计算的残差相同。这意味着可以使用以下方法对 $\mathbf{W}$ 和 $\mathbf{z}$ 执行所需的更新：

$$
\mathbf{X} \boldsymbol{\beta}^{(r)}=\mathbf{z}^{(r-1)}-\mathbf{e}^{(r)}
$$

其中，$\mathbf{e}^{(r)}$ 是一个向量，该向量收集使用式 $(16)$ 计算的残差。然后，与原始 IRLS 循环一样，$\mathbf{W}^{(r)}$ 和 $\mathbf{z}^{(r)}$ 的新值直接从式 $(15)$ 和 $(16)$ 开始。其次，这也意味着，一旦 $\boldsymbol{\delta}^{(r)}$ 收敛到正确的估计值 $\widehat{\delta}$，式 $(17)$ 中加权最小二乘回归的估计方差-协方差矩阵将成为 $\widehat{\delta}$ 正确的方差-协方差矩阵。

**加速 HDFE–GIRLS**

命令 `poi2hdfe` 可以实现式 $(17)$，同时使用 `reghdfe` 作为运行 HDFE 加权最小二乘回归。这是一个密集型计算过程，需要在每次 IRLS 迭代中估算 HDFE 回归模型。但是，`ppmlhdfe` 中有多种变通办法，可以使其效率更高。例如，`ppmlhdfe` 直接嵌入 `reghdfe` 的 Mata 中。因此利用了这样一个事实，它们在每个 IRLS 迭代中保持不变，某些计算只需要执行一次。但最显著的速度改进来自于对标准 HDFE–IRLS 算法的改进，该算法旨在减少对 `reghdfe` 的调用次数。

**最大似然估计的存在性**

Santos Silva 和 Tenreyro (2010，2011) 指出，对于某些数据配置，可能不存在泊松回归的最大似然估计 (MLE)，进而导致估计可能无法收敛或收敛到错误的值。在泊松回归的情况下，如果对数似然随着一个或多个系数趋于无穷大而单调增加，则会发生这种情况。Santos Silva 和 Tenreyro (2010) 认为发生这种情况的主要原因是变量间的多重共线性。为此，他们建议排除有问题的变量。但是，排除哪个回归变量是一个模棱两可的决定，可能会影响其余参数的识别。此外，在具有多个 HDFE 的泊松模型中，该策略甚至不可行。

Correia 等 (2019) 讨论了各种 GLM 模型估计中的必要条件和充分条件，并表明在泊松回归情况下，如果从样本中删除一些观察值，可能得到总 MLE 估计。这些单独的观测值不传递估计过程的相关信息，可以安全地丢弃。同时，删除这些观察值后，某些回归变量将产生共线性，因此也必须删除。此外，Correia 等 (2019) 提出了一种识别分离观察结果的方法，并且即使在 HDFE 存在情况下，也可以成功运行。

**渐进偏误**

[Weidner and Zylkin (2021)](https://www.sciencedirect.com/science/article/pii/S0022199621000933) 指出，当时间维度固定时，以 PPMLHDFE 得出的点估计值和聚类稳健夹心估计量（通常用于推断）均具有阶数为 $\frac{1}{N}$ 的渐近伴随参数偏差 (Asymptotic Incidental Parameter Bias)，且后者为下偏，其中 $N$ 是数据中的贸易主体数。

为此 [Weidner and Zylkin (2021)](https://www.sciencedirect.com/science/article/pii/S0022199621000933) 在其论文中提出了一种偏差修正算法，在 Stata 中我们可以通过 `ppml_fe_bias` 命令实现对该渐进偏误的修正。

### 2.4 高维固定效应负二项回归模型

注意到在泊松回归中，隐含着一个重要假设：

$$
E\big(y_i|\mathbf{x}_{i})=Var(y_i|\mathbf{x}_{i})=\mu_i
$$

如果贸易额度（被解释变量）的期望和方差差距很大——方差明显大于期望，我们称此时数据集存在过度分散（Overdispersion）问题，就有必要引入负二项分布回归法（Negative Binominal Regression，NBREG），相比于泊松回归，其主要区别在于对 $(14)$ 式的修正：

$$
E\left(y_{i}\right)=\mu_{i}=\exp \left(\mathbf{x}_{i} \boldsymbol{\beta}+ \epsilon_i \right) \tag{18}
$$

即在泊松回归的基础上多了一个扰动项 $\epsilon_i$ 来捕捉个体异质性或不可观测部分。可以证明，负二项回归模型的条件期望仍为 $E\big(y_i|\mathbf{x}_{i})=\mu_i=\exp \left(\mathbf{x}_{i} \boldsymbol{\beta} \right)$ ，而条件方差为：

$$
Var(y_i|\mathbf{x}_{i})=\mu_i+\alpha \mu_i^2 > \mu_i
$$

这表明在负二项回归中，条件方差大于条件期望，且条件方差是 $\alpha$ 的增函数，故 $\alpha$ 称为“过度分散参数” (Overdisperson Parameter) ;当 $\alpha\to0$ 时，负二项回归就转化为了泊松回归。因此在进行负二项回归后，只要对原假设 “$H_0: \alpha=0$” 进行检验，即可确定是使用泊松回归还是负二项回归。

在某种意义上，泊松回归和负二项回归的关系有如线性模型中 OLS 与 WLS 的关系。即使数据中存在过度分散，“泊松回归+稳健标准误”依然提供了对参数及标准误的一致估计，这类似于在异方差的情况下使用“OLS+稳健标准误”。因此在样本量足够大的情况下，泊松模型就已经能够满足大多数经济学研究的精度要求了。且 [Kareem F O 等 (2016)](https://ageconsearch.umn.edu/record/230588?ln=en) 比较了存在大量零额贸易时不同估计方法的表现，认为基于PPML估计法的一系列估计方法表现得更胜一筹。

基于此，实例中我们仍以泊松模型为主进行命令介绍与演示。

&emsp;
 
## 3. STATA 命令介绍

### 3.1 reghdfe 命令

**命令安装：**

```stata
ssc install reghdfe, replace
ssc install ftools, replace // ftools 为使用 reghdfe 命令的必须工具包
```

其语法结构与下面的 `ppmlhdfe` 基本一致，具体可参考往期推文 [reghdfe：多维面板固定效应估计](https://www.lianxh.cn/news/8be6ff429cf93.html) 。

### 3.2 ppmlhdfe 命令

**命令安装：**

```stata
ssc install ppmlhdfe, replace
// reghdfe 和 ftools 是使用 ppmlhdfe 的必须工具包
ssc install reghdfe, replace
ssc install ftools, replace
```

**语法结构：**

```stata
ppmlhdfe depvar [indepvars] [if] [in] [weight] ,  ///
         [absorb(absvars)] [options]
```

- `depvar`：被解释变量；
- `indepvars`：解释变量；
- `absorb(absvars)`：要吸收的分类变量 (固定效应)，也允许单独的斜率；
- `absorb(..., savefe)`：使用 __hdfe #__ 保存所有固定效应估计值。
- `[options]` 选项：

  - `exposure(varname)`：在系数约束为 1 的模型中包含 ln(varname)；
  - `offset(varname)`：在系数约束为 1 的模型中包含 varname；
  - `d(newvar)`：将固定效应之和另存为 newvar；
  - `d`：如上，但变量将另存为 _ppmlhdfe_d；
  - `vce(vcetype)`：vcetype 可以是 robust 或聚类；
  - `verbose(#)`：显示调试信息量；
  - `nolog`：隐藏迭代日志；
  - `tolerance(#)`：收敛标准，默认为 `tolerance(1e-8)`；
  - `guess(string)`：设置用于设置初始值的规则；
  - `eform`：报告指数系数；
  - `irr`：eform 的同义词；
  - `separation(string)`：用于删除分离的观测值及其相关回归变量的算法；
  - `maxiteration(#)`：指定最大迭代次数；
  - `keepsingletons`：不要删除单例组；
  - `version`：报告 `ppmlhdfe` 的版本号和日期；
  - `display_options`：控制回归表的选项，如置信水平、数字格式等。

### 3.3 ppml_fe_bias 命令

**命令安装：**

```stata
ssc install ppml_fe_bias, replace
// 以下四个 packages 是使用 ppml_fe_bias 的必要工具箱
ssc install outreg, replace
ssc install hdfe, replace
ssc install gtools, replace
ssc install rowmat_utils, replace
```

**语法结构：**

```stata
ppml_fe_bias depvar [indepvars] [if] [in],  ///
             lambda(varname) i(exp_id) j(imp_id) t(time_id) [options]
```

- `lambda(varname)`：输入代表固定效应之和的变量 varname；
- `i(exp_id) j(imp_id) t(time_id)`：分别输入代表出口国、进口国与时间的类别变量。
- `[options]` 选项：

  - `bias(name)`：将系数的误差矫正信息存储在矩阵 name 中；
  - `v(name)`：将误差矫正后的方差矩阵存储在 name 中；
  - `beta(name)`：输入由 ppmlhdfe 得到的系数估计矩阵；
  - `approx`：采用估计算法计算方差偏差；
  - `exact`：采用精确算法计算方差偏差。

### 3.4 nbreg 命令

**语法结构：**

```stata
nbreg depvar [indepvars] [if] [in] [weight] [, nbreg_options]
```

该命令为 Stata 内置命令，语法结构与基础的 `reg` 命令相似，在处理高维固定效应模型时需手动设定虚拟变量。

&emsp;

## 4. Stata 应用实例与方法比较

使用 `ppml_ panel_sg` 命令提供的辅助数据和示例来拟合引力模型。该数据集包含 35 个国家 1986 年至 2004 年的年度双边贸易数据。目的是估计自由贸易协定变量 **fta** 对贸易的影响。在本例中，我们希望控制国家对固定效应 (country-pair fixed effects) 和国家时间固定效应 (对于进口国和出口国)。此外，希望标准误聚类在国家对的级别上。

### 4.1 高维固定效应面板泊松伪极大似然估计 (PPMLHDFE)

```stata
* 数据下载地址：
* https://gitee.com/arlionn/data/blob/master/data01/EXAMPLE_TRADE_FTA.dta

use http://fmwww.bc.edu/RePEc/bocode/e/EXAMPLE_TRADE_FTA_DATA if category=="TOTAL", clear
egen imp = group(isoimp)
egen exp = group(isoexp)
ppmlhdfe trade fta, absorb(imp#year exp#year imp#exp) cluster(imp#exp) d nolog

//提取固定效应之和与系数估计矩阵并进行偏差矫正
predict lambda
matrix beta = e(b)
ppml_fe_bias trade fta, i(exp) j(imp) t(year) lambda(lambda) beta(beta)
```

```stata
Converged in 11 iterations and 35 HDFE sub-iterations (tol = 1.0e-08)

HDFE PPML regression                         No. of obs   =   5,950
Absorbing 3 HDFE groups                      Residual df  =   1,189
Statistics robust to heteroskedasticity      Wald chi2(1) =   21.04
Deviance             =  377332502.3          Prob > chi2  =  0.0000
Log pseudolikelihood = -188710931.7          Pseudo R2    =  0.9938

Number of clusters (imp#exp)=      1,190
                 (Std. Err. adjusted for 1,190 clusters in imp#exp)
-------------------------------------------------------------------
       |            Robust
 trade |    Coef.  Std. Err.      z    P>|z|   [95% Conf. Interval]
-------+-----------------------------------------------------------
   fta | .1924455  .0419527     4.59   0.000   .1102197    .2746713
 _cons | 16.45706  .0217308   757.32   0.000   16.41447    16.49965
-------------------------------------------------------------------

Absorbed degrees of freedom:
-----------------------------------------------------+
 Absorbed FE | Categories  - Redundant  = Num. Coefs |
-------------+---------------------------------------|
    imp#year |       175           0         175     |
    exp#year |       175           5         170     |
     imp#exp |      1190        1190           0    *|
-----------------------------------------------------+
* = FE nested within cluster; treated as redundant for DoF computation
```

```stata
Adjusted SEs
.0527904093
bias corrections (to be subtracted from original coefficients)
.0060619547
note: beta matrix will be shortened to the same length as the number of x-variables

           -------------------------------------------------------------
                     original      bias     adjusted SEs  bias-corrected 
           -------------------------------------------------------------
             fta    0.1924455   0.0060620   0.0527904      0.1863835    
                    (0.0419527)                           (0.0527904)*** 
           -------------------------------------------------------------
       Standard errors clustered by pair, using a local de-biasing adjustment
     to account for estimation noise in the exp-year and imp-year fixed effects.
                        * p<0.10; ** p<0.05; *** p<0.01
```

利用 `ppmlhdfe` 命令进行估计，并采用 `ppml_fe_bias` 进行偏差修正，结果显示贸易协定变量 **fta** 的系数估计修正值为 **0.1863835** ，修正稳健标准误为 **0.0527904** ，对国家间贸易额在 1% 水平下有显著正向影响。

### 4.2 高维固定效应面板负二项回归估计与OLS估计 (NBREG 与 REGHDFE)

执行代码：

```stata
* 采用负二项回归时，需采用创建交叉项的虚拟变量的方式控制相应的固定效应
egen impexp=group(imp exp)
nbreg trade fta i.(imp#year) i.(exp#year) i.impexp vce(cluster impexp)
reghdfe trade fta, absorb(imp#year exp#year imp#exp) cluster(imp#exp)
```

在实际操作过程中，不难发现命令 `nbreg` 所需的运算时间远长于其他两种估计方法，在处理大样本数据时这尤其会成为负二项回归的一个相对较明显的缺点。

将三种估计方式的结果汇总如下：

```
                        Regression Table
-------------------------------------------------------------------
       |            (1)              (2)               (3)
       |          PPMLHDFE	         NBREG	           REGHDFE
-------+-----------------------------------------------------------
   fta |          0.186***	        0.156***	        2.34e+06***
       |           (3.53)	          (2.80)	           (2.96)
-------+-----------------------------------------------------------
     N |            5950	            5950	             5950
  r2_a |		                                             0.84
  r2_p |            0.99	            0.11	
-------------------------------------------------------------------
```

表格中 **fta** 一行内括号中的数字代表显著性检验值，结果显示无论选取何种估计方式，贸易协定变量均在 1% 水平上对两国间贸易额具有显著正向影响，但检验值可能存在一定差别，因此在核心解释变量的作用相对不显著的情况下，选取不同的估计方式可能会对实证结论产生影响。

需注意的是，由于 `ppmlhdfe` 和 `nbreg` 采用的均是伪极大似然估计法，故仅存在伪 $R^2$ 可作为判断模型拟合效果的指标。在这一例子中， `ppmlhdfe` 的拟合能力明显高于 `nbreg` 。

&emsp;

## 5. 结语

贸易引力模型在双边贸易流量影响因素问题上具有较强的解释力且在诸多应用中取得了较大的成功。本文详细介绍了三维固定效应引力模型的数学构造、估计算法、偏差修正算法与相应的 Stata 命令操作，并在实例中对三种典型的估计方法进行了初步比较。

&emsp;

## 6. 参考资料

- Correia S, Guimaraes P, Zylkin T, et al. Fast Poisson estimation with high-dimensional fixed effects[J]. 2020. [-PDF-](https://arxiv.org/pdf/1903.01690.pdf)
- Sul D. Panel Data Econometrics: Common Factor Analysis for Empirical Researchers[M]. 2019.
- 陈强. 高级计量经济学及Stata应用(第二版)[M]. 高等教育出版社, 2014.
- Correia, S. Linear Models with High-Dimensional Fixed Effects: An Efficient and Feasible Estimator. Working Paper. 2016. [-PDF-](http://scorreia.com/research/hdfe.pdf)
- Martin Weidner, Thomas Zylkin. Bias and consistency in three-way gravity models. Journal of International Economics. 2021. [-PDF-](https://www.sciencedirect.com/science/article/pii/S0022199621000933)


&emsp; 

## 7. 相关推文

> Note：产生如下推文列表的 Stata 命令为：   
> &emsp; `lianxh 三维 引力 离散  泊松 零值, md2 nocat`  
> 安装最新版 `lianxh` 命令：    
> &emsp; `ssc install lianxh, replace` 

  
  - 万源星, 2020, [xtpdyn：动态面板Probit模型及Stata实现](https://www.lianxh.cn/details/44.html).
  - 刘潍嘉, 2025, [扎马步-常用概率分布函数详解：Python篇](https://www.lianxh.cn/details/1598.html).
  - 刘潍嘉, 2025, [扎马步-常用概率分布函数详解：R语言篇](https://www.lianxh.cn/details/1610.html).
  - 刘潍嘉, 2025, [扎马步-常用概率分布函数详解：Stata篇](https://www.lianxh.cn/details/1611.html).
  - 匡宇驰, 2024, [log-0 问题：零值太多如何取对数？](https://www.lianxh.cn/details/1455.html).
  - 吴小齐, 2024, [Stata绘图：高级柱状图(二)-离散变量之间关系的可视化](https://www.lianxh.cn/details/1469.html).
  - 崔颖, 2020, [Stata：用负二项分布预测蚊子存活率](https://www.lianxh.cn/details/399.html).
  - 左志勇, 2022, [Stata：三维引力模型介绍与估计-ppmlhdfe-nbreg-reghdfe](https://www.lianxh.cn/details/848.html).
  - 彭晴, 2023, [AER论文推介：通勤移民与就业弹性](https://www.lianxh.cn/details/1310.html).
  - 曾颖娴, 2020, [离散型调节变量——该如何设定模型？](https://www.lianxh.cn/details/80.html).
  - 朱磊, 2020, [Stata：今天你table了吗？二维列表和三维列表范例](https://www.lianxh.cn/details/376.html).
  - 李增杰, 2024, [R语言：IPW深度解读-离散变量和连续变量情形](https://www.lianxh.cn/details/1532.html).
  - 李胜胜, 2021, [引力模型-高维固定效应面板泊松模型](https://www.lianxh.cn/details/574.html).
  - 毕英睿, 2023, [取对数：如何应对零值和负数](https://www.lianxh.cn/details/1234.html).
  - 赵俊, 2024, [Stata：计数模型的选择与比较-countfit](https://www.lianxh.cn/details/1512.html).
  - 连享会, 2021, [Stata-Python交互-5：边际效应三维立体图示](https://www.lianxh.cn/details/555.html).
  - 连享会, 2020, [Stata新命令：ppmlhdfe-面板计数模型-多维固定效应泊松估计](https://www.lianxh.cn/details/337.html).
  - 连享会, 2020, [Stata新命令：面板-LogitFE-ProbitFE](https://www.lianxh.cn/details/341.html).
  - 连玉君, 2020, [Stata：因变量是类别变量时采用什么方法估计？](https://www.lianxh.cn/details/382.html).
  - 连玉君, 杨柳, 2020, [Stata：Logit模型一文读懂](https://www.lianxh.cn/details/170.html).
  - 邱紫烨, 2021, [RDD：离散变量可以作为断点回归的分配变量吗？](https://www.lianxh.cn/details/565.html).
  - 郑浩文, 2021, [ZIP-too many Zero：零膨胀泊松回归模型](https://www.lianxh.cn/details/501.html).
  - 黄欣怡, 2020, [Stata：多元 Logit 模型详解 (mlogit)](https://www.lianxh.cn/details/443.html).


