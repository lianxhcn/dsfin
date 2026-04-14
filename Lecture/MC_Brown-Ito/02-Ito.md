# 从布朗运动到 Ito 引理：如何“微分”一个随机过程？

那我就顺着刚才的布朗运动，往下讲最关键的“桥梁”：**Ito 引理**，以及它在金融中的一个直接应用——**对数价格和几何布朗运动的关系**。这一步走通了，后面 Black–Scholes 期权定价就基本水到渠成了。

## 1. 为什么需要 Ito 引理？

在普通微积分里，如果有一个确定性函数

$$y = f(t,x)$$

而且你知道 $x$ 随时间的变化是

$$\frac{dx}{dt} = g(t,x)$$

那么通过链式法则可以写出

$$\frac{dy}{dt} = f_t(t,x) + f_x(t,x)g(t,x)$$

金融里的问题是：现在 $x$ 不再是光滑函数，而是一个随机过程，比如

$$X_t = \mu t + \sigma W_t$$

这里 $W_t$ 是布朗运动。

我们关心的往往是某个函数

$$Y_t = f(t,X_t)$$

比如：

* $X_t$ 是对数价格，$Y_t = e^{X_t}$ 是价格；
* 或者 $X_t$ 是某个利率过程，$Y_t$ 是它的某种函数。

问题来了：**$X_t$ 的路径处处不可导**，传统链式法则不能直接用。那 $Y_t$ 的“微小变化”应该怎么写？

Ito 引理就是回答这个问题的工具：

> 当 $X_t$ 是布朗运动驱动的随机过程时，函数 $Y_t = f(t,X_t)$ 的微分形式该怎么写？

---

## 2. Ito 引理的单变量形式

先看最常用的一维版本。

假设随机过程 $X_t$ 满足随机微分方程

$$dX_t = a(t,X_t) dt + b(t,X_t) dW_t$$

其中：

* $a(t,x)$ 是“漂移”项；
* $b(t,x)$ 是“波动”项；
* $W_t$ 是一维标准布朗运动。

令

$$Y_t = f(t,X_t)$$

其中 $f$ 对 $t$ 和 $x$ 都足够光滑。

**Ito 引理**告诉我们：

$$
\begin{aligned}
dY_t
&= f_t(t,X_t) dt
* f_x(t,X_t) dX_t
* \tfrac{1}{2} f_{xx}(t,X_t) (dX_t)^2 \
  &= \Big[f_t + a f_x + \tfrac{1}{2} b^2 f_{xx}\Big](t,X_t) dt
* b(t,X_t) f_x(t,X_t) dW_t
  \end{aligned}
$$

关键点在于：

* 在这个随机框架下，$dX_t$ 里有 $dW_t$，而 $dW_t^2$ 的“数量级”是 $dt$；
* 所以展开 $(dX_t)^2$ 时，会出现 $b^2 (dW_t)^2 \approx b^2 dt$ 的额外项；
* 这就是为什么比普通链式法则多出一个 $\tfrac{1}{2} b^2 f_{xx}$。

可以粗略记忆成一句话：

> **Ito 引理 = 普通链式法则 + 二阶项修正**。

---

## 3. 一个经典例子：对数价格与几何布朗运动

在金融里，最常见的是几何布朗运动：

$$dS_t = \mu S_t,dt + \sigma S_t,dW_t$$

其中：

* $S_t$ 是资产价格；
* $\mu$ 是漂移率；
* $\sigma$ 是波动率。

我们知道 $S_t$ 永远为正，且它的对数价格 $X_t = \ln S_t$ 更适合分析收益。

### 3.1 用 Ito 引理求 $d(\ln S_t)$

令
$$X_t = \ln S_t$$
把 $f(s) = \ln s$ 视为函数，套用 Ito 引理。

先算导数：

* $f_s(s) = 1/s$
* $f_{ss}(s) = -1/s^2$

注意这里 $f$ 不显含 $t$，所以 $f_t = 0$。

Ito 引理的一般形式（这里 $S_t$ 不显含 $t$，写成单变量版本）是：

$$
dX_t = f_s(S_t),dS_t + \tfrac{1}{2} f_{ss}(S_t),(dS_t)^2
$$

把 $dS_t = \mu S_t dt + \sigma S_t dW_t$ 代入，先看 $dS_t$ 的平方：

$$
(dS_t)^2 = (\mu S_t dt + \sigma S_t dW_t)^2
\approx \sigma^2 S_t^2 (dW_t)^2
\approx \sigma^2 S_t^2 dt
$$

于是：

$$
\begin{aligned}
dX_t
&= \frac{1}{S_t} dS_t

* \frac{1}{2}\Big(-\frac{1}{S_t^2}\Big)(dS_t)^2\
  &= \frac{1}{S_t}(\mu S_t dt + \sigma S_t dW_t)

- \frac{1}{2}\frac{1}{S_t^2}(\sigma^2 S_t^2 dt)\
  &= \mu dt + \sigma dW_t - \frac{1}{2}\sigma^2 dt\
  &= \big(\mu - \tfrac{1}{2}\sigma^2\big)dt + \sigma dW_t
  \end{aligned}
  $$

这就是对数价格的动态：

$$d(\ln S_t) = \big(\mu - \tfrac{1}{2}\sigma^2\big)dt + \sigma dW_t$$

这一步非常重要：

* 它告诉我们，对数收益不是简单的 $\mu dt + \sigma dW_t$，而是多了一个 $-\tfrac{1}{2}\sigma^2 dt$ 的修正项；
* 这个修正项正是 Ito 引理中那一项 $\tfrac{1}{2} f_{ss} b^2$ 的体现。

### 3.2 对数价格的显式解

对上面的随机微分方程积分，可以得到

$$
\ln S_t = \ln S_0 + \big(\mu - \tfrac{1}{2}\sigma^2\big)t + \sigma W_t
$$

于是：

$$
S_t = S_0 \exp\Big(\big(\mu - \tfrac{1}{2}\sigma^2\big)t + \sigma W_t\Big)
$$

这就是前面提到的几何布朗运动的闭式解。

---

## 4. 直观再解释一次：为什么会冒出 $-\tfrac{1}{2}\sigma^2$？

如果没有学过 Ito 引理，很多人会简单地想：

> 既然 $dS_t = \mu S_t dt + \sigma S_t dW_t$，
> 那 $d(\ln S_t)$ 只要用普通链式法则，
> 大概就是 $\frac{1}{S_t}dS_t = \mu dt + \sigma dW_t$ 吧？

Ito 引理告诉你：**这少了一项**。原因是：

* 在随机微积分中，$dW_t^2$ 的“量级”是 $dt$，不能随便忽略；
* 当你把 $S_t$ 展开成微小增量时，二阶项的贡献不会消失，反而在极限中变成确定的修正项；
* 对 $\ln S_t$ 来说，这个修正项恰好是 $-\tfrac{1}{2}\sigma^2 dt$。

直观上可以这么理解：

* 如果你只看平均的价格增长 $\mu$，那是线性的；
* 但当你把价格转换成对数，波动会对平均有“负向拖累”，导致对数收益的平均变成 $\mu - \tfrac{1}{2}\sigma^2$；
* 波动越大，这个拖累越明显。

在期权定价中，这个修正项是很多公式中“看起来神奇”的 $-\tfrac{1}{2}\sigma^2$ 的根源。

---

## 5. 一个简单的“期望计算”例子

有了上面的显式解：

$$
\ln S_t = \ln S_0 + \big(\mu - \tfrac{1}{2}\sigma^2\big)t + \sigma W_t
$$

由于 $W_t \sim N(0,t)$，所以 $\ln S_t$ 服从正态分布：

$$
\ln S_t \sim N\Big(\ln S_0 + \big(\mu - \tfrac{1}{2}\sigma^2\big)t,\ \sigma^2 t\Big)
$$

从而 $S_t$ 服从对数正态分布。

对数正态分布的期望是：

$$
\mathbb{E}[S_t] = S_0 e^{\mu t}
$$

你可以看到：

* **在价格层面，平均增长率是 $\mu$**；
* **在对数价格层面，平均增长率是 $\mu - \tfrac{1}{2}\sigma^2$**。

这再次强调了：**不同变量变换下，“平均”的含义会发生微妙变化，Ito 引理就是用来精确处理这种变化的工具。**

---

## 6. Stata 模拟：验证 $\ln S_t$ 的正态性

下面给一段 Stata 代码，演示：

1. 对几何布朗运动模拟大量样本；
2. 取固定时间点 $t$ 的 $S_t$；
3. 看看 $\ln S_t$ 是否接近正态分布，以及它的均值是否接近 $\ln S_0 + (\mu - 0.5\sigma^2)t$。

### 6.1 Stata 代码示例（附中文注释）

```stata
*======================================================
* 模拟几何布朗运动，并检验 ln S_T 的分布
*======================================================

clear all
set more off

*-----------------------------
* 1. 设定参数
*-----------------------------
local S0    = 100      // 初始价格 S_0
local mu    = 0.08     // 漂移率 μ
local sigma = 0.2      // 波动率 σ
local T     = 1        // 模拟总时间长度 T=1 年
local Nstep = 252      // 每年 252 个交易日
local Npath = 5000     // 模拟路径条数

local dt = `T'/`Nstep'

*-----------------------------
* 2. 生成“面板”数据：路径 × 时间
*-----------------------------
set obs `Npath'
gen id = _n                         // 路径编号

expand `=`Nstep'+1''
bysort id: gen t_index = _n - 1     // 0,...,Nstep
gen t = t_index*`dt'                // 对应的时间

*-----------------------------
* 3. 为每个小时间段生成增量 dW
*-----------------------------
set seed 123456
gen dW = rnormal(0, sqrt(`dt'))

* 每条路径在 t=0 时，增量置为 0（方便递推）
bysort id (t): replace dW = 0 if t_index == 0

*-----------------------------
* 4. 递推求出价格 S_t
*-----------------------------
gen S = .

* 初始点：S_0 = S0
bysort id (t): replace S = `S0' if t_index == 0

* 循环更新：S_{t+dt} = S_t * exp( (μ - 0.5σ^2)dt + σ dW )
forvalues k = 1/`Nstep' {
    quietly replace S = S[_n-1]* ///
        exp((`mu' - 0.5*`sigma'^2)*`dt' ///
            + `sigma'*dW) ///
        if t_index == `k'
}

*-----------------------------
* 5. 取终点 T 时刻的 ln S_T
*-----------------------------
preserve
keep if t_index == `Nstep'

gen lnS = ln(S)

* 计算理论均值和方差
local mean_theory = ln(`S0') + (`mu' - 0.5*`sigma'^2)*`T'
local var_theory  = `sigma'^2*`T'

display "理论均值 (ln S_T): " `mean_theory'
display "理论方差 (ln S_T): " `var_theory'

*-----------------------------
* 6. 查看 ln S_T 的经验分布
*-----------------------------
sum lnS

* 画直方图并叠加正态密度曲线
histogram lnS, ///
    normal ///
    title("ln S_T 的直方图与正态拟合") ///
    xtitle("ln S_T") ///
    ytitle("频数")

restore
```

你可以观察：

* `sum lnS` 给出的样本均值、方差，与理论值是否接近；
* `histogram lnS, normal` 下直方图与正态曲线的拟合程度。

这是一种非常好的教学方式：
先用理论推导出“应该是正态 + 指定均值方差”，再用模拟去验证，把布朗运动、Ito 引理和几何布朗运动之间的关系真正“落在图和数字上”。

---

## 7. 小结与下一步预告

这一节我们完成了三件事：

1. 解释了为什么在“布朗运动驱动”的世界里需要 Ito 引理；
2. 给出了 Ito 引理的一维形式，并用它推导了几何布朗运动中 $S_t$ 与 $\ln S_t$ 的关系；
3. 用 Stata 模拟验证了 $\ln S_T$ 的正态性以及均值、方差的理论公式。

顺着这条线，**下一个自然的主题**就是：

* 在风险中性测度下，把 $dS_t$ 改写成 $dS_t = r S_t dt + \sigma S_t dW_t^*；
* 利用几何布朗运动的解形式，计算 $\mathbb{E}^{*}[(S_T - K)^+ \mid \mathcal{F}_t]$；
* 推导出欧式看涨期权的 Black–Scholes 公式。

如果你愿意，我下一步就从“风险中性世界的几何布朗运动”讲起，一步步把 Black–Scholes 的推导走完。
