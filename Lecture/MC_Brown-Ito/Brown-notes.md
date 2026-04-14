

当 $\Delta t \rightarrow 0$ 时，会把＂极小时间内的增量＂记成 $d W_t$。这常见于 SDE 中的写法：

$$d X_t=\mu_t d t+\sigma_t d W_t \tag{1}$$

其中，$d W_t$ 就是＂在极小时间内的布朗运动增量＂的符号化记法。即 $d W_t$ 服从均值为 $0$，方差为 $d t$ 的正态分布。

改用 $\Delta$ 符号表示时，更符合我们对随机过程的直观理解：

$$\Delta W_t = W_{t+\Delta t} - W_t \sim N(0,\Delta t)$$

使用 $\Delta$ 符号表示 (1) 式时，可以写成：

$$\Delta X_t = \mu_t \Delta t + \sigma_t \Delta W_t \tag{2}$$

注意，此处的 $\Delta W_t$ 和 $d W_t$ 是同一个东西，只是符号不同而已。


--- 

补充一些各个领域使用随机微分方程的经典公式：

## 二、收益率曲线建模


### Nelson－Siegel 模型

Nelson and Siegel（1987）提出的 Nelson－Siegel 模型（后文简称 N－S 模型）通过引入三个关键因子一一水平项、斜率项和曲率项，以捕捉收益率曲线的动态特征。其 $\tau$ 时刻的瞬时远期利率函数为公式（1）所示：

$$
f(\tau)=\beta_0+\beta_1 e^{-\lambda \tau}+\beta_2 \lambda \tau e^{-\lambda \tau}
$$


对上式做积分处理可得到连续复利下 $\tau$ 时刻的到期收益率，见公式（2）：

$$
R(\tau)=\frac{\int_0^t f(\tau) d \tau}{t}=\beta_0+\beta_1 \frac{1-e^{-\lambda \tau}}{\lambda \tau}+\beta_2\left(\frac{1-e^{-\lambda \tau}}{\lambda \tau}-e^{-\lambda \tau}\right)
$$


其中，待估参数 $\beta_0 、 \beta_1 、 \beta_2$ 分别控制收益率曲线的长期水平、短期斜率及中期曲度，$\lambda$为因子载荷的衰减速度参数。随着到期期限的增加，斜率项和曲率项对收益率的影响逐步减弱，长期利率水平由 $\beta_0$ 所主导。该模型可灵活拟合不同形态的收益率曲线，具备良好的拟合能力与经济解释力。

Nelson ⋅ and ⋅ Siegel（1987） 在提出 N－S 模型时，采用最小化到期收益率差的平方和作为拟合目标。胡志强和王婷（2009）在研究中国市场的国债数据时，同样指出该拟合方法在问题描述和参数估计上具有直观性和可操作性。假设存在 $N$ 只债券，第 $i$ 只债券对应的市场到期收益率为 $R_i^{\text {market }}$ ，模型拟合值为 $R_i^{N S}$ ，则对应的目标函数如公式（2）所示：

$$
\min H\left(\beta_0, \beta_1, \beta_2, \lambda\right)=\sum_{i=1}^N\left(R_i^{\text {market }}-R_i^{N S}\right)^2
$$


本文在拟合参数时，分别使用 Python 中 SciPy 库中 optimize 模块的 Powell、BFGS、L－ BFGS－B 方法，即可求出令上式最小时的参数，再带入 N－S 模型的表达式拟合得到收益率曲线。


（二）双因子 Vasicek 模型
Vasicek 短期利率模型由 Vasicek（1977）提出，以随机微分方程的形式描述了短期利率 $r_t$的随机运动，模型如公式（3）所示：

$$
d r_t=k\left(m-r_t\right) d t+\sigma d W_t
$$


其中 $r_t$ 表示短期利率；$k$ 为均值回归速度，决定利率回归长期均值 $m$ 的快慢；$m$ 为利率的长期均值，表示利率长期趋近的水平；$\sigma$ 为利率波动率；$W_t$ 为布朗运动项，刻画了短期利率的随机波动特征。根据 Vasicek 模型公式，可以求出将来短期利率 $r_t$ 的解析解，见公式（4）：

$$
r_t=e^{-k t} r_0+m\left(1-e^{-k t}\right)+\int_0^t \sigma e^{-k(t-u)} d W_u
$$


然而，单因子 Vasicek 模型只能描述短期利率的动态变化，并假设整个利率曲线的形态仅由短期利率因子决定。这也代表模型无法有效地模拟现实市场利率曲线可能经历的的非平行移动，且曲线的短期与长期对经济因素的反应不同。

Hull and White（1990）最早提出包含双因子的 Vasicek 模型，旨在更好地描述利率曲线的动态行为。该模型允许短期利率和长期利率分别由不同的随机过程驱动，具体形式如公式（5）与（6）：

$$
\begin{aligned}
&d r_t=\left(k_r m+\epsilon_t-k_r r_t\right) d t+\sigma_r d W_{1 t}\\
&d \epsilon_t=-k_\epsilon \epsilon_t d t+\sigma_\epsilon \rho d W_{1 t}+\sigma_\epsilon \sqrt{1-\rho^2} d W_{2 t}
\end{aligned}
$$

模型中各参数含义如下：$r_t$ 为短期利率；$\epsilon_t$ 表示均值为 0 的均值回归过程，代表当前短期利率长期水平对短期利率平均水平的偏离；$\sigma_r$ 为短期利率过程 $r_t$ 的波动率；$\sigma_\epsilon$ 为利率过程 $\epsilon_t$ 的波动率；$\rho$ 是短期利率过程 $r_t$ 与利率过程 $\epsilon_t$ 之间的相关系数；$m$ 为短期利率 $r_t$ 的长期均值水平；$k_r$ 为短期利率过程 $r_t$ 的均值回复速度；$k_\epsilon$ 为利率过程 $\epsilon_t$ 的运动速度。

在短期利率服从双因子 Vasicek 模型时可得出零息债券价格，见公式（7）：

$$
P(r, t, T)=\exp \left\{-a(T-t)-b_1(T-t) r_t-b_2(T-t) \epsilon_t\right\}
$$


等式简单变形后可以得到零息债券的到期收益率：

$$
r(t, T)=a+b_1 r_t+b_2 \epsilon_t
$$


其中：

$$
\begin{aligned}
b_1(\tau)= & \frac{1}{k_r}\left(1-e^{-k_r \tau}\right) \\
b_2(\tau)= & \frac{1}{\kappa_r\left[\kappa_r-\kappa_{\varepsilon}\right]} e^{-\kappa_r \tau}-\frac{1}{\kappa_{\varepsilon}\left[\kappa_r-\kappa_{\varepsilon}\right]} e^{-\kappa_{\varepsilon} \tau}+\frac{1}{\kappa_{\varepsilon} \kappa_r} \\
a(\tau)= & \frac{k_r m}{\kappa_r}\left(\tau-b_1(\tau)\right) \\
& -\frac{1}{\kappa_r^2}\left(\frac{1}{2} \sigma_r^2-\frac{\rho \sigma_r \sigma_{\varepsilon}}{\kappa_r-\kappa_{\varepsilon}}+\frac{\sigma_{\varepsilon}^2}{2\left(\kappa_r-\kappa_\tau\right)^2}\right)\left(\tau-b_1(\tau)-\frac{1}{2} \kappa_r b_1(\tau)^2\right) \\
& -\frac{\sigma_{\varepsilon}^2}{4 \kappa_{\varepsilon}^3\left(\kappa_r-\kappa_{\varepsilon}\right)^2}\left(2 \tau \kappa_{\varepsilon}-3+4 e^{-\kappa_{\varepsilon} \tau}-e^{-2 \kappa_{\varepsilon} \tau}\right) \\
& -\frac{\rho^{\sigma_r \sigma_{\varepsilon}}}{\kappa_r \kappa_{\varepsilon}\left(\kappa_r-\kappa_{\varepsilon}\right)^2}\left(\tau-b_1(\tau)-\frac{1-e^{-\kappa_{\varepsilon} \tau}}{\kappa_{\varepsilon}}+\frac{1-e^{-\left(\kappa_\tau+\kappa_{\varepsilon}\right) \tau}}{\kappa_r+\kappa_{\varepsilon}}\right)
\end{aligned}
$$


在对双因子 Vasicek 模型进行参数拟合时，同样利用样本中已知的国债剩余期限与到期收益率之间的关系，针对模型中的参数 $k_{r 、} k_{\epsilon 、} m 、 \sigma_{r 、} \sigma_{\epsilon 、} r_{t 、} \epsilon_t$ 进行估计。在每个截面上，要求 $N$ 只债券的真实到期率与各自使用双因子 Vasicek 模型估计出的到期收益率的离差平方和最小，即如公式（12）所示：

$$
\min H\left(k_r, k_\epsilon, m, \rho, \sigma_r, \sigma_\epsilon, r_t, \epsilon_t, \tau\right)=\sum_{i=1}^N\left(R_i^{\text {market }}-R_i^{\text {Vasicek }}\right)^2
$$


由于模型中参数较多，在实际拟合值可能需要使用两阶段拟合的方法。