
> 编译：李琼琼 (山东大学)    
> 邮箱：<lqqflora@163.com>  

&emsp;

> 本文主要翻译自如下论文，并进行了适当的补充和调整.      
> **Source：** Engel C, Moffatt P G. dhreg, xtdhreg, and bootdhreg: Commands to implement double-hurdle regression[J]. Stata Journal, 2014, 14(4):778-797. [-PDF-](https://journals.sagepub.com/doi/pdf/10.1177/1536867X1401400405)

&emsp;

## 0.  背景介绍

双栏模型 (Double-hurdle model) 是由 Cragg (1971) 提出的：对于一个活动的参与，个体决策是由两部分组成的。第一个门槛 (hurdle), 决定个体是否是零类型；第二个门槛 (hurdle) 是在第一个阶段是非零的条件下，决定个体对活动的参与程度。这个模型的关键特征是这里有两种类型的零观测值，一种是无周围的环境如何变化他的选择都是零，另一种是他可以有非零选择但是目前的环境导致他选择零，后者也被称为归并零 (Tobin,1958)。

以个人捐款为例，可以分为两个选择行为：

- **S1：是否捐钱？** 这属于「意愿」问题，取决于个人的年龄、性格、宗教信仰等因素。
- **S2：捐多少钱？** 这属于「能力」问题，取决于可支配收入、财富水平等因素。

例如，如果一个人不喜欢帮助别人，自然不会做出捐赠的决定，那么即使其个人收入很高而导致的潜在捐出金额高，但最终表现出来的捐赠的金额却是 0。如果个人非常热爱帮助别人，但是身上没有带现金，最终也会表现不捐赠的行为。

虽然上面两种情况表面上是一样的，但要注意，第一种类型的人不会因为收入或者持有的现金金额变多而进行捐款，而第二种类型的人，如果身上持有现金则会进行捐款，并且捐赠的金额会随着收入和现金的变化而发生改变。

归并回归 (Tobit) 模型更多地是对第二种类型的行为做出研究，而双栏模型可以很好地解释两种类型的行为。双栏模型除了包括自然的零类型外，还允许零的概率由观测值的个体决定的。本质上，**Double-hurdle** 模型 是 **Tobit** 模型的延续。

本文主要分三部分内容对双栏模型进行介绍：

-  1 双栏模型介绍
-  2 模型的实现
-  3 面板双栏模型


&emsp;

## 1.  双栏模型 (Double-hurdle model) 介绍

在介绍双栏模型之前，我们先来了解一下它的前辈：Tobit 模型。

### 1.1 Tobit 模型

Tobit 模型又被称为归并回归模型 (censored regression model)， 根据 limit 的设置分为左归并 (lower censoring) 和右归并 (upper censoring)，左归并指事先设置一个最小值 A，当被解释变量低于这个值时则自动等于 A。 如果最低的 limit 为 0 时，被称为零归并 (zero censoring)。

$$
\begin{aligned} y_{i}^{*} &=\mathbf{x}_{i}^{\prime} \boldsymbol{\beta}+\varepsilon_{i}  \\
\varepsilon_{i} & \sim N\left(0, \sigma^{2}\right)  \end{aligned}  
$$

上面的公式中潜变量 $y_{i}^{*}$ (最终无法直接被看到）代表个体 $i$ 希望做出的贡献 (latent contribution)， 这个潜在贡献可以为负值，但是试验规则认为只要为负值最终的贡献都归为 0 (规则如下）：

$$
y_{i}=\left\{\begin{array}{cl}{y_{i}^{*}} & {\text { if } y_{i}^{ *}>0} \\ {0} & {\text { if } y_{i}^{ *}\leqslant0}\end{array}\right.
$$

这里以零归并举例，采用对数似然函数，估计模型如下：
$$
\log L=\sum_{i=1}^{n}\left[I_{y_{i}=0} \ln \left\{\Phi\left(-\frac{\mathbf{x}_{i}^{\prime} \boldsymbol{\beta}}{\sigma}\right)\right\}+I_{y_{i}>0} \ln \left\{\frac{1}{\sigma} \phi\left(\frac{y_{i}-\mathbf{x}_{i}^{\prime} \boldsymbol{\beta}}{\sigma}\right)\right\}\right]
$$
其中 $I$ 为示性函数，当下标所表示的条件正确时取值为 1，否则为 0。通过使 $\log L$ 最大化来求出 $\beta$ 和 $\sigma$。

### 1.2 Double - hurdle 模型

Double - hurdle 模型有两个阶段，这两个阶段分别采用 **probit** 估计和 **tobit** 估计：

$$
\begin{aligned} d_{i}^{*} &=\mathbf{z}_{i}^{\prime} \boldsymbol{\alpha}+\varepsilon_{1, i} \\ y_{i}^{* *} &=\mathbf{x}_{i}^{\prime} \boldsymbol{\beta}+\varepsilon_{2, i} \\\left(\begin{array}{c}{\varepsilon_{1, i}} \\ {\varepsilon_{2, i}}\end{array}\right) & \sim N\left[\left(\begin{array}{l}{0} \\ {0}\end{array}\right),\left(\begin{array}{cc}{1} & {0} \\ {0} & {\sigma^{2}}\end{array}\right)\right] \end{aligned}
$$

在第一个阶段 (hurdle)，被解释变量 ($d_i$) 是二元变量,由潜变量 $d_i^{*}$ 决定。

$$
d_{i}=\left\{\begin{array}{cl}{d_{i}^{*}} & {\text { if } d_{i}^{ *}>0} \\ {0} & {\text { if } d_{i}^{ *}\leqslant0}\end{array}\right.
$$

在第二个阶段 (hurdle), 被解释变量 $y_{i}^{*}$ 是零或者正数，非常像 **Tobit** 模型 (I)。$y_{i}^{*}=\max \left(y_{i}^{* *}, 0\right)$
双栏模型对数似然函数为：

$$
\log L=\sum_{0} \ln \left\{1-\Phi\left(\mathbf{z}_{i}^{\prime} \boldsymbol{\alpha}\right) \Phi\left(\frac{\mathbf{x}_{i}^{\prime} \boldsymbol{\beta}}{\sigma}\right)\right\}+\sum_{+} \ln \left\{\Phi\left(\mathbf{z}_{i}^{\prime} \boldsymbol{\alpha}\right) \frac{1}{\sigma} \phi\left(\frac{y_{i}-\mathbf{x}_{i}^{\prime} \boldsymbol{\beta}}{\sigma}\right)\right\}
$$

上式中，双栏模型的第二个阶段给 $y_{i}^{*}$ 设置了最小值 0 ，当然也可以将最小值设置为其他数 $y_{min}$, 都被称为 **lower hurdle**。 若最小值为 $y_{min}$， 对数似然函数的变为：

$$
\log L=\sum_{min} \ln \left\{1-\Phi\left(\mathbf{z}_{i}^{\prime} \boldsymbol{\alpha}\right) \Phi\left(\frac{\mathbf{x}_{i}^{\prime} \boldsymbol{\beta} - y_{min}}{\sigma}\right)\right\}+\sum_{+} \ln \left\{\Phi\left(\mathbf{z}_{i}^{\prime} \boldsymbol{\alpha}\right) \frac{1}{\sigma} \phi\left(\frac{y_{i}-\mathbf{x}_{i}^{\prime} \boldsymbol{\beta}}{\sigma}\right)\right\}
$$

若双栏模型是 **upper hurdle** 型，即第二个阶段设置一个最大值 $y_{max}$， 所有超过 $y_{max}$ 的值都等于 $y_{max}$，小于 $y_{max}$ 的值则不改变，那么此时模型变为：

$$
\log L=\sum_{max} \ln \left\{1-\Phi\left(\mathbf{z}_{i}^{\prime} \boldsymbol{\alpha}\right) \Phi\left( \frac{y_{max}-\mathbf{x}_{i}^{\prime} \boldsymbol{\beta}}{\sigma}\right)\right\}+\sum_{+} \ln \left\{\Phi\left(\mathbf{z}_{i}^{\prime} \boldsymbol{\alpha}\right) \frac{1}{\sigma} \phi\left(\frac{y_{i}-\mathbf{x}_{i}^{\prime} \boldsymbol{\beta}}{\sigma}\right)\right\}
$$


### 1.3 用图形解释 double hurdle 模型

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/7692714-e0a36d91c428bfd0)

上图中的的同心圆是 $d^{*}$ 和 $y^{**}$ 的联合分布，这个同心圆是以 $({z}_{i}^{\prime} \alpha$, ${x}_{i}^{\prime} \beta)$ 为中心并根据解释变量的变动进行移动。在第二、三象限，由于 $d^{*}$ 小于 0， $y$ 一直为 0，表现为个体永远不会 contribute；在第四象限，$d^{*}$ 大于 0, 但是 $y^{**}$ 小于 0， 所以 $y$ 暂时为 0，会随着 $x$ 变量的变动的而可能大于 0；在第一象限， $y$ 为正数，个体实际做了 contribution。

### 1.4 Double - hurdle 模型的特殊形式

如果模型第一阶段，只有截距而没有解释变量，$\Phi\left(\mathbf{z}_{i}^{\prime}\boldsymbol{\alpha}\right) = \Phi\left({\alpha_0}\right)$, 则对数似然函数变为：

$$
\log L=\sum_{0} \ln \left\{1-\Phi\left(\alpha_{0}\right) \Phi\left(\frac{\mathrm{x}_{i}^{\prime} \beta}{\sigma}\right)\right\}+\sum_{+} \ln \left\{\Phi\left(\alpha_{0}\right) \frac{1}{\sigma} \phi\left(\frac{y_{i}-\mathrm{x}_{i}^{\prime} \beta}{\sigma}\right)\right\}
$$
将 $p = \Phi\left({\alpha_0}\right)$ ,此时模型就变成了 **p-tobit** 模型，即认为有一定比例 $p$ 的样本可能会 contribute， 而永远不会 contribute 的样本占 $1-p$ 的比例。 **p-tobit** 模型最先由 **(Deaton and Irish, 1984)** 提出。


&emsp;

## 2.  模型的 Stata 实现

### 2.1 dhreg 命令介绍

我们可以使用 `dhreg` 命令来实现双栏模型的估计。在 Stata 命令窗口中输入 `help dhreg` 命令即可查看其完整帮助文件。`dhreg` 命令的基本语法为：

```stata
  dhreg depvar indepvars [if] [in] [, up ptobit hd(varlist) millr]
```
各项的含义如下：
- `depvar`:       表示被解释变量，即最终的可观测的 $y$
- `indepvars`：表示关键的解释变量，即决定 $y^{**}$ (潜变量) 的解释变量 $x$
- `up`：           将模型设置为右归并，并且设置 $y$ 最大值（默认为左归并）
- `ptobit`：       将双栏模型设置为 **p-tobit** 模型
- `hd(varlist)`:   表示第一栏中决定 $d^{*}$ 的解释变量 $z$
- `millr`：        用逆米尔斯比率来控制扰动项的相关性


### 2.2 基于模拟分析的范例

我们通过模拟生成的数据来对 `dhreg` 命令的使用进行介绍，下面是数据生成的过程 (DGP)：

$$
d_i^*=\begin{cases}
1&  -2+4z_i+\varepsilon_{i1} >0 \\
0 & otherwise
\end{cases}
$$

$$y_i^{**} = 0.5+0.3x_i+\varepsilon_{i2}$$

$$
y_i^*=\begin{cases}
y^{**}& y_i^{**} >0  \\
0 & otherwise
\end{cases}
$$

$$y_i=(d_i^*)(y_i^*)$$

$$\varepsilon_{i1}=0.5\varepsilon_{i2}+\sqrt{1-0.5^2}\eta_i$$

$$\varepsilon_{i1},\eta_i \sim N(0,1)$$

$$corr(\varepsilon_{i1},\varepsilon_{i2})=0.5$$

$$z_i,x_i \sim U(0,1)$$

上面第一个公式生成的潜变量 $d_i^*$ 即为第一个栏 (hurdle)，是由服从均匀分布的外生变量 $z_i$ 和扰动项 $\varepsilon_{i1}$ 决定的。第二个公式生成潜变量 $y^{**}$ 是第二个栏 (hurdle)，是由外生变量 $x_i$ 和扰动项 $\varepsilon_{i2}$ 决定的。当前面两个栏都被跨过时，就可以观察到变量 $y_i$ (可观测变量）的取值 (非 0)，否则 $y_i$ 为 0。

```stata
clear all
set obs 1000
set seed 123   // 设置种子，为了使每次重复模拟过程的结果相同
gen z_i = uniform()   //  z_i 服从（0,1)均匀分布
set seed 1234
gen x_i = uniform()
set obs 1000
set seed 12345  
gen e_i2 = invnormal(uniform())  // e_i2 服从标准正态分布
set seed 12435
gen n_i = invnormal(uniform())
gen e_i1 = 0.5*e_i2 + sqrt(1-0.5*0.5)*n_i
gen d_i = 0
replace d_i = 1 if -2 + 4*z_i + e_i1 > 0
gen y_i2 = 0.5 + 0.3*x_i + e_i2
gen y_i1 = 0
replace y_i1 = y_i2 if y_i2 > 0
gen y_i = d_i*y_i1
save data_process1.dta, replace  // 保存一份模拟数据
```

数据效果如下：

```stata
use "data_process1.dta", clear
hist y_i if d_i == 1,title(Conditional on passing first hurdle) scheme(sj)
graph save y_i_1.gph, replace
hist y_i ,title(All Data) scheme(sj)
graph save y_i_2.gph, replace
gr combine  y_i_1.gph  y_i_2.gph
graph save y_i.png, replace
```

![模拟数据的直方图](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/7692714-7787097c583f28b2)


从左图可以看出有很多观测值通过了第一栏(即  $d_i^* > 0$), 但是由于潜变量 $y_i^{**}$ 为 0， 导致了最终观测值为 0。而更多的 $y_i$ 为 0 的观测值是因为没有通过第一栏 (即 $d_i^* <= 0$)。



### 2.3 模型估计

我们先进行传统的 `tobit` 估计, 再使用 `dhreg` 进行估计，然后对这两种估计结果进行比较。

```stata 
. use "data_process1.dta", clear
. tobit y_i x_i, ll(0)

Tobit regression                        Number of obs     =    1,000
                                           Uncensored     =      413
Limits: lower = 0                          Left-censored  =      587
        upper = +inf                       Right-censored =        0

                                        LR chi2(1)        =     3.49
                                        Prob > chi2       =   0.0619
Log likelihood = -1129.3849             Pseudo R2         =   0.0015
---------------------------------------------------------------------
          |   Coef.  Std. Err.    t    P>|t|     [95% Conf. Interval]
----------+----------------------------------------------------------
      x_i |  0.362     0.194    1.87   0.062      -0.019      0.742  
    _cons | -0.471     0.119   -3.94   0.000      -0.705     -0.237  
----------+----------------------------------------------------------
var(e.y_i)|  2.407     0.192                  [95% CI: 2.058 - 2.814]
---------------------------------------------------------------------
```

接着是进行 `dhreg` 估计：

```stata
 dhreg y_i x_i, hd(z_i)
 (output omitted)
 maximum likelihood estimates of double hurdle model

N = 1000
log likelihood = -984.07209
chi square hurdle equation = 67.264411
p hurdle equation = 2.374e-16
chi square above equation = 4.8518223
p above equation = .02761694
chi square overall = 69.895304
p overall = 6.644e-16

--------------------------------------------------------------------------------
             |      coef         se          z          p   lower CI   upper CI
-------------+------------------------------------------------------------------
hurdle       |                                                                  
         z_i |  3.644556   .4443773   8.201488   2.22e-16   2.773592   4.515519
       _cons | -1.727589   .1522467   -11.3473   7.65e-30  -2.025987  -1.429191
above        |                                                                  
         x_i |   .416768    .189209   2.202685   .0276169   .0459251   .7876109
       _cons |  .5702333   .1428997   3.990444   .0000659    .290155   .8503115
sigma        |                                                                  
       _cons |  1.053116   .0643765   16.35869          0   .9269402   1.179292
--------------------------------------------------------------------------------
```

Tobit 模型估计 $x_i$ 的系数为 0.362  (在 10% 水平上显著) , 而 double hurdle 模型估计 $x_i$ 的系数为 0.417  (在 5% 水平上显著), 由本次模拟结果来看  Tobit 估计似乎接近真实值 ($x_i$ 实际系数为 0.3), 但是双栏模型可以将决定$d_i$的变量 $z_i$ 的系数估计出来 (估计为3.645), 非常接近真实值 4 (在 1% 水平上显著)。

[注：我们尝试通过设置不同的种子，生成不同的随机数，发现 double hurdle 模型对 $x_i$ 的估计有时候会比 Tobit 模型估计更加准确]。

&emsp;

## 3.  面板双栏模型 (Panel-hurdle model)

### 3.1 面板双栏模型基本原理

Dong and Kaiser (2008) 将双栏模型发展成面板双栏模型，并使用这个模型对家庭牛奶消费做实证分析。Dong 假设并验证了家庭牛奶消费总的来说由非经济因素和经济因素决定，非经济因素包括户主年龄、教育、种族背景等，经济因素包括收入、牛奶的价格等。在一定的时间内，非经济因素一般不会发生改变，并且在家庭是否产生购买牛奶的行为中起决定性作用。

* **第一阶段 (first hurdle)**
$$
\begin{aligned} d_{i}^{*} &=\mathbf{z}_{i}^{\prime} \boldsymbol{\alpha}+\varepsilon_{1, i} \\ d_{i} &=1 \text { if } | d_{i}^{*}>0 ; d_{i}=0 \text { otherwise } \\ \varepsilon_{1, i} & \sim N(0,1) \end{aligned}
$$

* **第二阶段 (second hurdle)**

$$
\begin{aligned} y_{i t}^{* *} &=\mathrm{x}_{i t}^{\prime} \beta+u_{i}+\varepsilon_{2, i t} \\ y_{i t}^{*} &=\max \left(y_{i t}^{* *}, 0\right) \\\left(\begin{array}{c}{\varepsilon_{1, i}} \\ {u_{i}} \\ {\varepsilon_{2, i t}}\end{array}\right) & \sim N\left[\left(\begin{array}{l}{0} \\ {0} \\ {0}\end{array}\right),\left(\begin{array}{ccc}{1} & {\rho \sigma_{u}} & {0} \\ {\rho \sigma_{u}} & {\sigma_{u}^{2}} & {0} \\ {0} & {0} & {\sigma^{2}}\end{array}\right)\right] \end{aligned}
$$
* **最终观测值**
$$
y_{i t}=d_{i} y_{i t}^{*}
$$
在第一个阶段中，**$\alpha$** 相当于非经济因素，**$d_i$** 表示个体家庭是否会购买牛奶，基本不随着时间变化而改变；在第二个阶段中，**$\beta$** 相当于经济因素，决定家庭购买牛奶的数量，**$y_{it}^{*}$** 表示个体家庭潜在购买牛奶的数量，$\mu_i$ 代表个体效应, 且 **$\mu_i$** 与解释变量 **$x_{it}$** 均不相关。**$y_{it}$** 表示个体家庭在第 $t$ 期购买牛奶的数量。

* **似然函数模型**

$$
\left(L_{i} | d_{i}=1, u_{i}\right)=\prod_{t=1}^{T}\left\{1-\Phi\left(\frac{\mathbf{x}_{i t}^{\prime} \boldsymbol{\beta}+u_{i}}{\sigma}\right)\right\}^{I\left(y_{i t}=0\right)}\left\{\frac{1}{\sigma} \phi\left(\frac{y_{i t}-\mathbf{x}_{i t}^{\prime} \boldsymbol{\beta}-u_{i}}{\sigma}\right)\right\}^{I\left(y_{i t}>0\right)}
$$

$$
\left(L_{i} | d_{i}=0\right)=\left\{\begin{array}{ll}{1} & {\text { if }\sum_{t=1}^{T} y_{i t}>0} \\ {0} & {\text { if }\sum_{t=1}^{T} y_{i t}=0}\end{array}\right.
$$

$$
\left(L_{i} | u_{i}\right)=\Phi\left(\mathrm{z}_{i}^{\prime} \boldsymbol{\alpha}\right)\left(L_{i} | d_{i}=1, u_{i}\right)+\left\{1-\Phi\left(\mathrm{z}_{i}^{\prime} \boldsymbol{\alpha}\right)\right\}\left(L_{i} | d_{i}=0\right)
$$

$$L_{i}=\int_{-\infty}^{\infty}\left(L_{i} | u\right) f(u) d u$$

样本最终的似然对数函数为：$\log L=\sum_{i=1}^{n} \ln L_{i}$。



### 3.2 面板双栏模型的 Stata 实现

Stata 中用 `xtdhreg` 和 `boothreg` 命令对面板数据进行双栏模型的估计。首先在 Stata 命令窗口中输入 `help xtdhreg` 命令即可查看其完整帮助文件。`xtdhreg` 命令的基本语法为：

```stata
  xtdhreg depvar indepvars [if] [in] [, up ptobit hd(varlist) uncorr trace ///
      difficult constraints(numlist)]
```
各项的含义如下：
- `depvar`:       表示被解释变量，即最终的可观测的 $y$
- `indepvars`：   表示关键的解释变量，即决定 $y^{**}$ (潜变量) 的解释变量 $x$
- `up`：           将模型设置为右归并，并且设置 $y$ 最大值（默认为左归并）
- `ptobit`：       将双栏模型设置为 **p-tobit** 模型
- `hd(varlist)`:   表示第一栏中决定 $d^*$ 的解释变量 $z$
- `millr`：        用逆米尔斯比率来控制扰动项的相关性
- `uncorr`：      表示第一栏和第二栏中的扰动项不相关
- `trace`：       显示每一次迭代的系数
- `difficult`：   当模型不收敛时，换用其他替代的算法
- `constraints(numlist)`：   允许对模型进行限制

在 Stata 命令窗口中输入 `help boothreg` 命令即可查看其完整帮助文件。`boothreg` 命令的基本语法为：

```stata
  bootreg depvar indepvars [if] [in] [, up ptobit hd(varlist) millr ///
    margins(string) seed(integer) reps(integer) strata(varlist) cluster(varlist) ///
    capt maxiter(integer)]
```

各项的含义如下：

- `depvar`:       表示被解释变量，即最终的可观测的 $y$
- `indepvars`：表示关键的解释变量，即决定 $y^{**}$ (潜变量) 的解释变量 $x$
- `up`：           将模型设置为右归并，并且设置 $y$ 最大值（默认为左归并）
- `ptobit`：       将双栏模型设置为 **p-tobit** 模型
- `hd(varlist)`:   表示第一栏中决定 $d^{*}$ 的解释变量 $z$
- `millr`：        用逆米尔斯比率来控制扰动项的相关性
- `margins(string)`：        bootstrep 估计的边际效应
- `seed(integer)`：          设置种子，为了使结果可重复
- `reps(integer)`：          boostrap 重复的次数，默认是 50 次
- `strata(varlist)`：        进行分层抽样
- `capt`：                   自动忽略不收敛的情况
- `maxiter(integer)`：      设置迭代的最多次数，默认为 50

---

### 3.3 基于模拟分析的范例

本小节我们先模拟生成面板数据，然后再利用生成的数据进行模型估计。

* **数据生成过程 (DPG)**
$$
\begin{aligned} d_{i}^{*} &=\left\{\begin{array}{cl}{1} & {\text -2+4 \times z_{i}+\varepsilon_{i 1}>0} \\ {0} & {\text { otherwise }}\end{array}\right.\\ y_{i t}^{*}=& 0.5+0.3 \times x_{i t}+u_{i}+\varepsilon_{i t 2} \\ y_{i t}^{*} &=\left\{\begin{array}{cc}{y_{i t}^{* *}} & {\text y_{i t}^{* *}>0} \\ {0} & {\text { otherwise }}\end{array}\right.\\ y_{i t}=& d_{i}^{*} \times y_{i t}^{*} \\ \varepsilon_{i 1} &=0.9 \times u_{i}+\sqrt{\left(1-0.9^{2}\right)} \times \eta_{i} \\\left(\begin{array}{c}{\varepsilon_{i t 2}} \\ {u_{i}}\end{array}\right) & \sim N\left[\left(\begin{array}{l}{0} \\ {0}\end{array}\right),\left(\begin{array}{ll}{1} & {0} \\ {0} & {\sigma^{2}}\end{array}\right] \times \eta_{i}\right.\\ \eta_{i} & \sim N\left(0, \sigma^{2}\right) \end{aligned}
$$

面板数据的个体为 $i$, 一共有 $T$ 期。这些个体的决策 (是否 参与) 是由第一栏 $d_i^*$ 是否大于 0 和第二栏 $y_{it}^*$ 是否大于 0 共同决定的。值得注意的是, $d_i^{*}$ 不会随着时间 $t$ 变化而改变，如果第一期 $d_i^{*} = 0$, 那么剩下的 $t-1$ 期都会有 $d_i^{*} = 0$ 即该个体一直选择不参与； 而当 $d_i^{*} > 0$ 时， $y_{it}^{*} = 0$，个体暂时不参与但并不会影响其他几期该的决策。另外，我们设置了个体随机效应 $u_i$, 并且 $u_i$ 与 第一个公式的误差项存在相关性。用 Stata 生成数据的过程如下：

```stata
clear all
set obs 2000
set seed 10011979
gen z_i = uniform()
set seed 1111122
gen u_i = rnormal(0, 3)
set seed 1222222
gen n_i = rnormal(0,3)
gen e_i1 = 0.9*u_i + sqrt(1-0.9^2)*n_i

/* 面板数据生成过程 */
gen d_i = 0
replace d_i = 1 if -2 + 4*z_i + e_i1 > 0
gen id = _n
expand 5  // 将 T 设置为 5 期
bys id: gen t = _n
xtset id t
bysort id (t): gen x_it = rnormal(0,1) + rnormal(0,1) if _n==1
bysort id (t): replace x_it = .8 * x_it[_n-1] + rnormal(0,1) if _n!=1
gen e_i2 = rnormal(0,1)
gen y_it2 = 0.5 + 0.3*x_it + u_i + e_i2
corr e_i2 u_i // 检查e_i2和u_i的相关性
gen y_it1 = 0
replace  y_it1 = y_it2 if y_it2 > 0
gen y_it = y_it1*d_i
save data_process2.dta, replace  //保存模拟数据
```

* **模型估计**
用 `xtdhreg` 命令进行双栏估计的结果如下：

```stata
. use data_process2.dta, clear
. help mdraws // 进行 xtdhreg 估计前，需要装`mdraws`包
. xtdhreg y_it x_it, hd(z_i)

                                           Number of obs     =   10,000
                                           Wald chi2(1)      =    46.82
Log likelihood = -9013.4217                Prob > chi2       =   0.0000

-----------------------------------------------------------------------
             |   Coef.   Std. Err.     z    P>|z|  [95% Conf. Interval]
-------------+---------------------------------------------------------
hurdle       |
         z_i |   0.691      0.101    6.84   0.000     0.493       0.889
       _cons |  -0.270      0.061   -4.42   0.000    -0.390      -0.150
-------------+---------------------------------------------------------
above        |
        x_it |   0.297      0.016   18.25   0.000     0.265       0.329
       _cons |   3.888      0.105   37.01   0.000     3.682       4.094
-------------+---------------------------------------------------------
sigma_u      |
       _cons |   3.249      0.094   34.49   0.000     3.065       3.434
-------------+---------------------------------------------------------
sigma_e      |
       _cons |   0.992      0.012   80.58   0.000     0.968       1.016
-------------+---------------------------------------------------------
transforme~o |
       _cons |  -0.921      0.073  -12.61   0.000    -1.064      -0.778
-----------------------------------------------------------------------

 generate estimate of correlation in error terms, with confidence interval


         rho:  tanh([transformed_rho]_cons)

-----------------------------------------------------------------------
      |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
------+----------------------------------------------------------------
  rho |     -0.726      0.035   -21.05   0.000       -0.794      -0.659
-----------------------------------------------------------------------

 separate Wald tests for joint significance of all explanatory variables

 note

 if you use factor variables, i.e. the i., c., # and ## notation, you must run
 the Wald test by hand. For detail see help file

 estimates of joint significance

chi square hurdle equation = 46.823269
p hurdle equation = 7.769e-12
chi square above equation = 333.06556
p above equation = 2.066e-74
chi square overall = 376.42225
p overall = 1.824e-82
```

用 `bootdreg` 命令进行双栏模型估计结果如下：

```stata
. bootdhreg y_it x_it, hd(z_i)  cluster(id) capt

(output omitted)

Tobit regression                        Number of obs     =  10,000
                                           Uncensored     =   4,158
Limits: lower = 0                          Left-censored  =   5,842
        upper = +inf                       Right-censored =       0

                                        LR chi2(1)        =   94.08
                                        Prob > chi2       =  0.0000
Log likelihood = -15304.577             Pseudo R2         =  0.0031

-------------------------------------------------------------------
   y_it |   Coef.   Std. Err.      t    P>|t|  [95% Conf. Interval]
--------+----------------------------------------------------------
   x_it |   0.289      0.030     9.70   0.000     0.230       0.347
  _cons |  -0.719      0.055   -12.97   0.000    -0.827      -0.610
--------+----------------------------------------------------------
 /sigma |   4.027      0.051                      3.928       4.126
-------------------------------------------------------------------

 estimation assuming independence--------------------------------
maximum likelihood estimates of double hurdle model

N = 10000
log likelihood = -14962
chi square hurdle equation = 140.17438
p hurdle equation = 2.438e-32
chi square main equation = 140.17438
p main equation = 2.438e-32
chi square overall = 442.19897
p overall = 9.500e-97
bootstrap results

------------------------------------------------------------------------------
            |      coef     se   p     lowciz      upciz     lowcip      upcip
------------+-----------------------------------------------------------------
hurdle      |                                                                 
        z_i |  1.002614   .122   0   .7634344   1.241794   .7598894   1.346414
      _cons | -.4531903   .072   0  -.5948118  -.3115688  -.6363495  -.2646514
main        |                    0                                            
       x_it |  .3388443   .052   0   .2370221   .4406664   .2289405   .4781399
      _cons |  2.279919   .132   0   2.020481   2.539356   1.868922   2.511813
sigma       |                                                                 
      _cons |  2.583072   .095   0   2.396594    2.76955   2.401081   2.808727
------------------------------------------------------------------------------

```
从回归结果可以看出，`xtdhreg` 和 `bootdhreg` 对样本的 $x_i$ 系数估计值 (0.297 和 0.339) 非常接近 $x_i$ 真实系数 (0.3)，且均在 1% 水平上显著。


## 4. 参考文献

以下是更新后的完整引文信息，加入了 [Google] 链接：

1. Bruno García, 2013. **Implementation of a Double-Hurdle Model**. *Stata Journal*, 13(4), 776–794. [Link](https://journals.sagepub.com/doi/pdf/10.1177/1536867X1301300406), [PDF](https://journals.sagepub.com/doi/pdf/10.1177/1536867X1301300406), [Google](https://scholar.google.com/scholar?q=Implementation+of+a+Double-Hurdle+Model+Stata+Journal).

2. Christoph Engel, Peter G. Moffatt, 2014. **Dhreg, Xtdhreg, and Bootdhreg: Commands to Implement Double-Hurdle Regression**. *Stata Journal*, 14(4), 778–797. [Link](https://journals.sagepub.com/doi/pdf/10.1177/1536867X1401400405), [PDF](https://journals.sagepub.com/doi/pdf/10.1177/1536867X1401400405), [Google](https://scholar.google.com/scholar?q=Dhreg,+Xtdhreg,+and+Bootdhreg:+Commands+to+Implement+Double-Hurdle+Regression+Stata+Journal).

3. Dong, Diansheng, and H. M. Kaiser, 2008. **Studying Household Purchasing and Nonpurchasing Behaviour for a Frequently Consumed Commodity: Two Models**. *Applied Economics*, 40(15), 1941-1951. [Link](https://www.tandfonline.com/doi/pdf/10.1080/00036840600949272?needAccess=true), [PDF](https://www.tandfonline.com/doi/pdf/10.1080/00036840600949272?needAccess=true), [Google](https://scholar.google.com/scholar?q=Studying+Household+Purchasing+and+Nonpurchasing+Behaviour+for+a+Frequently+Consumed+Commodity:+Two+Models+Applied+Economics).

4. Engel, C., Moffatt, P. G., 2014. **Dhreg, Xtdhreg, and Bootdhreg: Commands to Implement Double-Hurdle Regression**. *Stata Journal*, 14(4), 778–797. [Link](https://journals.sagepub.com/doi/pdf/10.1177/1536867X1401400405), [PDF](https://journals.sagepub.com/doi/pdf/10.1177/1536867X1401400405), [Google](https://scholar.google.com/scholar?q=Dhreg,+Xtdhreg,+and+Bootdhreg:+Commands+to+Implement+Double-Hurdle+Regression+Stata+Journal).

&emsp; 

## 5. 相关推文

> Note：产生如下推文列表的 Stata 命令为：   
> &emsp; `lianxh tobit 两部 自选择 heckman, m`  
> 安装最新版 `lianxh` 命令：    
> &emsp; `ssc install lianxh, replace` 

- [刘潍嘉](https://www.lianxh.cn/search.html?s=刘潍嘉), 2024, [偏态分布数据的回归模型选择](https://www.lianxh.cn/details/1405.html), 连享会 No.1405.
- [匡宇驰](https://www.lianxh.cn/search.html?s=匡宇驰), 2024, [log-0 问题：零值太多如何取对数？](https://www.lianxh.cn/details/1455.html), 连享会 No.1455.
- [吴煜铭](https://www.lianxh.cn/search.html?s=吴煜铭), [郑浩文](https://www.lianxh.cn/search.html?s=郑浩文), 2021, [内生性！内生性！解决方法大集合](https://www.lianxh.cn/details/579.html), 连享会 No.579.
- [安超](https://www.lianxh.cn/search.html?s=安超), 2024, [论文推介：考虑样本自选择偏误的内生性随机前沿分析模型](https://www.lianxh.cn/details/1464.html), 连享会 No.1464.
- [张少鹏](https://www.lianxh.cn/search.html?s=张少鹏), 2021, [Stata：两部模型实现命令-twopm](https://www.lianxh.cn/details/742.html), 连享会 No.742.
- [张少鹏](https://www.lianxh.cn/search.html?s=张少鹏), 2021, [Stata：样本选择偏误与两部模型-twopm-L121](https://www.lianxh.cn/details/714.html), 连享会 No.714.
- [张蛟蛟](https://www.lianxh.cn/search.html?s=张蛟蛟), 2022, [Stata：无需IV的自选择模型-egregsel](https://www.lianxh.cn/details/143.html), 连享会 No.143.
- [张蛟蛟](https://www.lianxh.cn/search.html?s=张蛟蛟), 2024, [fqreg：在零处扎堆的分位数回归](https://www.lianxh.cn/details/1461.html), 连享会 No.1461.
- [徐云娇](https://www.lianxh.cn/search.html?s=徐云娇), [甘徐沁](https://www.lianxh.cn/search.html?s=甘徐沁), 2020, [Stata：分位数回归中的样本自选择问题](https://www.lianxh.cn/details/469.html), 连享会 No.469.
- [徐婷](https://www.lianxh.cn/search.html?s=徐婷), 2020, [多层级Tobit模型及Stata应用](https://www.lianxh.cn/details/421.html), 连享会 No.421.
- [李琼琼](https://www.lianxh.cn/search.html?s=李琼琼), 2020, [Stata: 一文读懂 Tobit 模型](https://www.lianxh.cn/details/12.html), 连享会 No.12.
- [李琼琼](https://www.lianxh.cn/search.html?s=李琼琼), 2020, [Stata：双栏模型简介-(Double-hurdle-model)](https://www.lianxh.cn/details/380.html), 连享会 No.380.
- [李琼琼](https://www.lianxh.cn/search.html?s=李琼琼), 2021, [Stata：自选择偏误之双栏模型简介-(Double-hurdle-model)](https://www.lianxh.cn/details/803.html), 连享会 No.803.
- [牛坤在](https://www.lianxh.cn/search.html?s=牛坤在), 2021, [xtheckmanfe：面板Heckman模型的固定效应估计](https://www.lianxh.cn/details/688.html), 连享会 No.688.
- [王恩泽](https://www.lianxh.cn/search.html?s=王恩泽), 2023, [Stata：一文读懂两部模型-twopm](https://www.lianxh.cn/details/1170.html), 连享会 No.1170.
- [秦利宾](https://www.lianxh.cn/search.html?s=秦利宾), 2020, [Heckman 模型：你用对了吗？](https://www.lianxh.cn/details/153.html), 连享会 No.153.
- [章青慈](https://www.lianxh.cn/search.html?s=章青慈), 2022, [Stata：广义Heckman两步法-gtsheckman](https://www.lianxh.cn/details/1082.html), 连享会 No.1082.
- [连享会](https://www.lianxh.cn/search.html?s=连享会), 2021, [FAQs答疑-2021寒假-Stata高级班-Day2-连玉君-面板门槛-Heckman-Tobit](https://www.lianxh.cn/details/537.html), 连享会 No.537.
- [连玉君](https://www.lianxh.cn/search.html?s=连玉君), 2024, [antrho与Fisher转换：heckman和treareg等命令中参数含义](https://www.lianxh.cn/details/1358.html), 连享会 No.1358.
- [连玉君](https://www.lianxh.cn/search.html?s=连玉君), 2024, [antrho与Fisher转换：heckman和treareg等命令中参数含义](https://www.lianxh.cn/details/1361.html), 连享会 No.1361.
- [郭佳佳](https://www.lianxh.cn/search.html?s=郭佳佳), 2023, [内生性之应对（上）：原理篇--遗漏变量-反向因果-测量误差-自选择](https://www.lianxh.cn/details/1264.html), 连享会 No.1264.
- [郭佳佳](https://www.lianxh.cn/search.html?s=郭佳佳), 2023, [内生性之应对（下）：方法篇--遗漏变量-反向因果-测量误差-自选择](https://www.lianxh.cn/details/1266.html), 连享会 No.1266.
