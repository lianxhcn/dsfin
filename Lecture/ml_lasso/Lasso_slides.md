---
### ------------------- 幻灯片还是普通网页
marp: true
#marp: false

### ------------------- 幻灯片尺寸，宽版：4:3
size: 16:9
#size: 4:3

### ------------------- 是否显示页码
paginate: true  
#paginate: false

### ------------------- 页眉 (备选的用 '#' 注释掉)
# header: lianxh.cn
#header: '[连享会](https://www.lianxh.cn)'
#header: '[lianxh.cn](https://www.lianxh.cn/news/46917f1076104.html)'

### ------------------- 页脚 (备选的用 '#' 注释掉)
#footer: 'lianx.cn Marp 模板'
footer: '连享会&nbsp;|&nbsp;[lianxh.cn](https://www.lianxh.cn)&nbsp;|&nbsp;[Bilibili](https://space.bilibili.com/546535876)'
#footer: '![20230202003318](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20230202003318.png)'
---

<!-- 
Notes: 
1. 选中一段文本，按快捷键 'Ctrl+/' 可以将其注释掉；再次操作可以解除 
2. header, footer 后面的文本需要用单引号引起来，否则会有语法错误
3. '#size: 16:9' 不能写为 'size:16:9'，即 'size:' 后要有一个空格
-->



<!-- Global style: 设置标题字号、颜色 -->
<!-- Global style: 正文字号、颜色 -->
<style>
/*一级标题局中*/
section.lead h1 {
  text-align: center; /*其他参数：left, right*/
  /*使用方法：
  <!-- _class: lead -->
  */
}
section {
  font-size: 24px; 
}
h1 {
  color: blackyellow;
}
h2 {
  color: green;
}
h3 {
  color: darkblue;
}
h4 {
  color: brown;
  /*font-size: 22px; */
}
/* 右下角添加页码 */
section::after {
  /*font-weight: bold; */
  /*text-shadow: 1px 1px 0 #fff; */
/*  content: 'Page ' attr(data-marpit-pagination) ' / ' attr(data-marpit-pagination-total); */
  content: attr(data-marpit-pagination) '/' attr(data-marpit-pagination-total); 
}
header,
footer {
  position: absolute;
  left: 50px;
  right: 50px;
  height: 25px;
}
</style>

<!--顶部文字-->
[lianxh.cn](https://www.lianxh.cn/news/46917f1076104.html) 

<br>

<!--封面图片-->
![bg right:50% w:400 brightness:. sepia:50%](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20220722114227.png) 

<!--幻灯片标题-->
# 基于 Lasso 的因果推断 


<br>
<br>
<br>
<br>

<!--作者信息-->
[连玉君](https://www.lianxh.cn) (中山大学)
arlionn@163.com

<br>



--- - --
<!-- backgroundColor: #C1CDCD -->

## 1. 何谓 Lasso ?

- 稀疏性
- 过拟合问题
- 预测偏差 v.s 预测方差


--- - --
<!-- backgroundColor: white -->
### 何谓 Lasso ?
- **Lasso：** Least Absolute Shrinkage and Selection Operator，Tibshirani (1996)
- **用途：** 预测、模型筛选
- **核心思想：** 对传统回归模型施加约束 (惩罚项), 滤除次要变量, 选出精简模型
  - 配合交叉验证等手段来选择参数, Lasso 出的模型样本外预测能力 (泛化能力)

- 以 Lasso 为首的一系列方法 被通称为 “惩罚回归" (Penalized Regressions)。

--- - --
<!-- backgroundColor: white -->
### 稀疏性和近似稀疏性

> Source: Abadie et al. ([2010](https://web.stanford.edu/~jhain/Paper/JASA2010.pdf), JASA), 加州禁烟的政策效果，Figure 1

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Abadie-2010-Fig01-02.png)

--- - --

> Source:   
> Abadie et al. ([2010](https://web.stanford.edu/~jhain/Paper/JASA2010.pdf), JASA)

![bg left:50% w:550](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20220726235042.png)


--- - --

### 过拟合问题: 例 1

![w:900](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Fig-Lasso-overfit.png)

--- - --

### 过拟合问题：例 2

![w:800](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Abadie10-Fig09-place-time.png)

--- - --

### 过拟合问题：例 2

![w:800](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/RCM-pred_pboTime1985-good.png)

--- - --

```stata
use "smoking_wide.dta", clear

*-Lasso
lasso linear cig0 cig1-cig39 lny1-lny39  ///
          if year<=1984, select(cv, fold(10)) 

*-回归控制法
rcm cig $xx, trunit(3) trperiod(1989) ///
             method(lasso)  ///
             criterion(cv) fold(10)   ///  // 10-fold CV  
             placebo(period(1985))
```

--- - --
<!-- backgroundColor: #FFFFF9 -->
## 预测偏差 v.s 预测方差


--- - --
<!-- backgroundColor: white -->

<center>

![w:900](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/function_addline_06a.png)


--- - --

### 预测「偏差-方差」的权衡
**均方误差** (mean-square error, MSE)：
$$
\operatorname{MSE}(\hat{\theta})==\mathrm{E}\left(\hat{\theta}-\theta_{0}\right)^{2}
$$
- 待估参数为 $\theta$, 其真实值为 $\theta_{0}$, 估计值为 $\hat{\theta}$, 

估计量的 **方差**：
$$
\operatorname{Var}(\hat{\theta})=\mathrm{E}[\hat{\theta}-\mathrm{E}(\hat{\theta})]^{2}
$$
估计量的 **偏差**：
$$
\operatorname{Bias}(\hat{\theta})=\mathrm{E}(\hat{\theta})-\theta_{0}
$$
权衡关系：
$$
\operatorname{MSE}(\hat{\theta})=\operatorname{Bias}(\hat{\theta})^{2}+\operatorname{Var}(\hat{\theta})
$$
--- - --
### 预测「偏差-方差」的权衡

<br>
 
<center>

![w:700](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Fig-Lasso-Bias-variance-tradeoff-02.png)



--- - --

<center>

![w:700](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20220727001122.png)



--- - --
<!-- backgroundColor: #C1CDCD -->
## 2. 惩罚回归：核心思想
- 损失函数
- 范数与距离
- 惩罚回归


--- - --
<!-- backgroundColor: white -->

### 损失函数
考虑线性模型:&emsp; &emsp; $y_{i}=\mathbf{x}_{i}^{\prime} \boldsymbol{\beta}+e_{i}, \quad i=1,2, \cdots, n$
- $y_{i}$ 是被解释变量 (在机器学习或统计学习中常被称为 “标签"), 
- $\mathbf{x}_{i}$ 是一组解释变量构成的向量, $\boldsymbol{\beta}$ 为系数向量。

若采用 OLS，则可以通过极小化残差平方和来估计参数,
$$
\operatorname{RSS}(\beta)=\sum_{i=1}^{n}\left(y_{i}-\mathbf{x}_{i}^{\prime} \boldsymbol{\beta}\right)^{2}=\sum_{i=1}^{n} e_{i}^{2} 
$$
在机器学习中, 上式被称为「**损失函数**」(loss function) 或「**代价函数**」(cost function)。


--- - --

### 范数与距离：引入
采用矩阵方式, 线性回归模型通常写做: &emsp;  $\mathbf{y}=\mathbf{X} \boldsymbol{\beta}+\mathbf{e}$
其中, $\mathbf{e}=\left(e_{1}, e_{2}, \cdots, e_{n}\right)^{\prime}$ 为干扰项向量。损失函数可以表示为：
$$
L(\beta)=\frac{1}{2 n} \sum_{i=1}^{n} e_{i}^{2} \quad \Longleftrightarrow \quad  L(\beta)=\frac{1}{2 n}\|\mathbf{e}\|_{2}^{2}
$$
或
$$
L(\beta)=\frac{1}{2 n} \sum_{i=1}^{n}\left(y_{i}-\mathbf{x}_{i}^{\prime} \boldsymbol{\beta}\right)^{2} \quad \Longleftrightarrow \quad L(\beta)=\frac{1}{2 n}\|\mathbf{y}-\mathbf{X} \boldsymbol{\beta}\|_{2}^{2}
$$

定义：
$$
\|\mathbf{e}\|_{2}^{2}=e_{1}^{2}+e_{2}^{2}+\cdots+e_{n}^{2}
$$

--- - --

### 范数与距离：

给定向量 $\mathbf{x}$, 其范数的通用定义公式如下:
$$
\|\mathbf{x}\|_{p}=\left(\left|x_{1}\right|^{p}+\ldots+\left|x_{n}\right|^{p}\right)^{\frac{1}{p}} \quad p \geq 1, x \in \mathbb{R}^{n}
$$ 

- $\ell_{1}$ 范数 ($p=1$)：$\|\mathbf{x}\|_{1}=\sum_{i=1}^{N}\left|x_{i}\right|$。
  - 即向量各个元素的绝对值之和，又称为「曼哈顿距离」
  - 使用 $\ell_{1}$ 范数可以度量两个向量间的差异 (绝对误差和)。
 
- $\ell_{2}$ 范数 ($p=2$)：$\|\mathbf{x}\|_{2}=\sqrt{\sum_{i=1}^{N} x_{i}^{2}}$，
  - 亦称 Euclid范数 (欧几里得范数)。
  - 即向量各元素的平方和再开方，也可以表示向量的长度 (模) 或两个向量之间的距离，又称为「欧氏距离」。



--- - --

### 征罚回归：回顾 AIC 和 BIC

$$\small
\begin{aligned}
&\mathrm{AIC}=n \ln (R S S / n)+2 k \\
&\mathrm{BIC}=n \ln (R S S / n)+k \ln (n)
\end{aligned}
$$
- 其中，$n$ 为观察值个数，$\small RSS$ 为残差平方和。

AIC 和 BIC 都试图在「拟合程度」和「模型复杂度」之间进行权衡，通用表达式为：
  $$
  IC = {\color{blue}{n \ln (R S S / n)}} + {\color{red}{c(n, K)}}  
  $$
- 拟合程度：用 $n \ln (R S S / n)$ 来衡量，值越小越好 (拟合的好) 
- 模型复杂度：用 (正数项) 来衡量，差别在于惩罚力度不同。
  - $\mathrm{AlC}$：$c=2 K$
  - $\mathrm{BIC}$：$c=K \log (n)$
- 对于一笔相同的数据，$\small IC$ 值越小的模型越佳。

--- - --

### 征罚回归的目标函数

让损失函数 (Loss) 最小化不是最终目标, 需要加人描述模型复杂度的惩罚项，极小化：
$$
\operatorname{Loss}+\lambda \Omega(f)
$$
- $\operatorname{Loss}$ 为损失函数；$\Omega(f)$ 称为「正则化项」, $\lambda$ 为调节参数。
- 所谓正则化项, 描述的其实是模型的复杂度，它越高, 过拟合的风险也就越大。

<br>
<br>

> :cat: 在很多情况下，无偏性并不是我们关注的重点，但需要兼顾


--- - --
<!-- backgroundColor: #C1CDCD -->
## 3. Lasso 回归
- Lasso 的目标函数
- Lasso 的直观解释
- Lasso 估计与求解

--- - --
<!-- backgroundColor: white -->

## 3.1 Lasso：目标函数
$$
\min _{\beta_{0}, \beta}\left\{\frac{1}{2 N} \sum_{i=1}^{N}\left(y_{i}-\beta_{0}-\sum_{j=1}^{p} x_{i j} \beta_{j}\right)^{2}\right\}
$$
$$\text{subject to } \sum_{j=1}^{p}\left|\beta_{j}\right| \leq \tau$$

约束条件 $\sum_{j=1}^{p}\left|\beta_{j}\right| \leq \tau$ 可以用 $\ell_{1}$ 范数表示为: $\|\boldsymbol{\beta}\|_{1} \leq \tau$。矩阵形式:
$$
\begin{gathered}
\min _{\beta_{0}, \beta}\left\{\frac{1}{2 N}\left\|\mathbf{y}-\beta_{0} \mathbf{1}-\mathbf{X} \beta\right\|_{2}^{2}\right\} \\
\text { subject to }\|\boldsymbol{\beta}\|_{1} \leq \tau,
\end{gathered} \qquad (1)
$$

--- - --

### Lasso：目标函数

将 (1) 式写成如下拉格朗日 (Lagrangian) 形式更易于求解：
$$
\min _{\beta}\left\{\frac{1}{2 N}\|\mathbf{y}-\mathbf{X} \beta\|_{2}^{2}+\lambda\left(\sum_{j=1}^{p}\left|\beta_{j}\right|-\tau\right)\right\} \qquad (2)
$$
- 其中, $\lambda \geq 0$, 通常称为 “调节参数”。
- 由于 $\lambda$ 与 $\tau$ 的乘积 $\lambda \tau$ 是一个常数, 因此, (1) 与 (2) 的极小化问题是等价的,

$$
\min _{\beta}\left\{\frac{1}{2 N}\|\mathbf{y}-\mathbf{X} \beta\|_{2}^{2}+\lambda\|\boldsymbol{\beta}\|_{1}\right\}  \qquad (3)
$$



--- - --
<!-- backgroundColor: #e6e6fa -->
##  3.2 Lasso 的直观解释



--- - --
<!-- backgroundColor: white -->
#### OLS 系数与 RSS
![bg left:50% w:600](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Fig-OLS-RSS-3D-Hansen2021-Fig3-2-b.png)

![w:600](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Fig-OLS-RSS-3D-Hansen2021-Fig3-2-c.png)

--- - --

![w:700](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Fig-Lasso-Lassopath-lian.png)

--- - --

![w:1000](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/lasso-stata-regular01.png)

--- - --

![w:700](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Fig-Lasso-3D-HTW2015front.png)


--- - --
<!-- backgroundColor: #e6e6fa -->
## 3.3 Lasso：估计

--- - --
<!-- backgroundColor: white -->

### Lasso 的估计
多数情况下, 必须通过数值方法求解 Lasso, 如最小角回归法 (LARS), 坐标下降法等。
Lasso 估计可以通过极小化如下目标函数得到:
$$
\min _{\beta} \operatorname{RSS}_{1}(\boldsymbol{\beta}, \lambda)=\left\{\frac{1}{2 N} \sum_{i=1}^{N}\left(y_{i}-\mathbf{x}_{1} \beta_{1} \cdots-\mathbf{x}_{p} \beta_{p}\right)^{2}+\lambda \sum_{\substack{j=1}}^{p}\left|\beta_{j}\right|\right\}
$$
一阶条件为:
$$
\frac{\partial \operatorname{RSS}_{1}(\boldsymbol{\beta}, \lambda)}{\partial \beta_{j}}=\boldsymbol{X}_{j}^{\prime}(\mathbf{y}-\boldsymbol{X} \boldsymbol{\beta})+\lambda \operatorname{sgn}\left(\beta_{j}\right)=0
$$
其中, $\mathbf{X}=\left(\mathbf{x}_{1}, \mathbf{x}_{2}, \cdots, \mathbf{x}_{k}\right), \boldsymbol{\beta}=\left(\beta_{1}, \beta_{2}, \cdots, \beta_{p}\right)^{\prime}$ 。 


--- - --
$$
\frac{\partial \operatorname{RSS}_{1}(\boldsymbol{\beta}, \lambda)}{\partial \beta_{j}}=\boldsymbol{X}_{j}^{\prime}(\mathbf{y}-\boldsymbol{X} \boldsymbol{\beta})+\lambda \operatorname{sgn}\left(\beta_{j}\right)=0
$$

$\operatorname{sgn}()$ 为 “符号函数", 用于记录变量 $z$ 的符号:
$$
\operatorname{sgn}(z)=\left\{\begin{array}{cc}
-1 & z<0 \\
+1 & z>0 \\
0 & z=0
\end{array}\right.
$$


--- - --

### 次导数
- $f(x)=|x|$ 在 $x=0$ 处的次导数不再是一个特定的数值, 
- 而是一个非空闭区间: $[-1,+1]$, 
- 取值范围由 $f(x)$ 在 $x=0$ 左侧和右侧的偏导数确定。

![w:900](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20220727010328.png)

--- - --

### 次导数

这从次导数的标记符号可以看出： $\partial f(x)=\{\nabla f(x)\}$ 。 

同时, 在 $x=0$ 两侧, 都满足 $f(x) \geq f(0)$ 。
基于上述介绍可知：
$$
\lambda \frac{\partial\left|\beta_{j}\right|}{\partial \beta_{j}}=\lambda \operatorname{sgn}\left(\beta_{j}\right)= \begin{cases}-\lambda & \beta_{j}<0 \\ {[-\lambda, \lambda]} & \beta_{j}=0 \\ \lambda & \beta_{j}>0\end{cases}
$$
由此可以看出调节参数 $\lambda$ 的作用, 它可以控制右图的开合状态, 从而决定当 $\beta_{j}=0$ 时惩罚的力度。


--- - --

### 特例：Lasso 的解析解
若变换 $\mathbf{X}$ 矩阵使所有解释变量都彼此正交, 即 $\boldsymbol{X}^{\prime} \boldsymbol{X}=\boldsymbol{I}_{p}$, 则 Lasso 存在解析解。

此时, 一阶条件可以简化为:
$$
\widehat{\beta}_{\mathrm{Lasso}, j}-\widehat{\beta}_{\mathrm{ols}, j}+\lambda \operatorname{sgn}\left(\widehat{\beta}_{\mathrm{Lasso}, j}\right)=0
$$
由此解得 (这里省略了下标 ${ }_{j}$ )：
$$
\widehat{\beta}_{\mathrm{Lasso}, j}=\left\{\begin{array}{cc}
\widehat{\beta}_{\mathrm{OLS}}-\lambda & \widehat{\beta}_{\mathrm{OLS}}>\lambda \\
0 & \left|\widehat{\beta}_{\mathrm{OLS}}\right| \leq \lambda \\
\widehat{\beta}_{\mathrm{OLS}}+\lambda & \widehat{\beta}_{\mathrm{OLS}}<-\lambda
\end{array}\right.
$$
可见, Lasso 估计是 OLS 估计的连续函数。当 OLS 系数 的绝对值小于 $\lambda$ 时, Lasso 估计值被强制设定为 0 (这就是所谓的变量筛选功能), 而其它系数则被统一向零收缩 $\lambda$ 。


--- - --

![w:900](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Fig-Lasso-hard-bestsub-ols-01.png)



--- - --
<!-- backgroundColor: #C1CDCD -->
## 4. 岭回归 (Ridge Regression)


--- - --
<!-- backgroundColor: white -->

###  4.1 岭回归：目标函数
岭回归是在 OLS 基础上对系数施以 $\ell_{2}$ 范数的约束得到的, 目标函数为:
$$
\underset{\beta_{0}, \beta}{\operatorname{minimize}}\left\{\frac{1}{2 N} \sum_{i=1}^{N}\left(y_{i}-\beta_{0}-\sum_{j=1}^{p} x_{i j} \beta_{j}\right)^{2}\right\}
$$
$$\text{subject to} \quad \sum_{j=1}^{p} \beta_{j}^{2} \leq \tau^{2}$$
其中, $\tau>0$ 是收缩参数。用矩阵表示如下：
$$
\min _{\beta}\left\{\frac{1}{2 N}\|\mathbf{y}-\mathbf{X} \beta\|_{2}^{2}+\lambda\|\boldsymbol{\beta}\|_{2}^{2}\right\},
$$

--- - --

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Fig-Lasso-Ridge-figure-Hansen2021.png)


--- - --

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/lasso-stata-regular02.png)

--- - --
### 4.2 OLS，Lasso 和岭回归的系数关系

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Fig-Lasso-hard-ridge-ols-02.png)


--- - --

### Lasso /岭回归系数 与 调节参数 ($\lambda$) 之间的关系
![w:900](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Fig-Lasso-Ridge-shink.png)

--- - --

### 4.3 岭回归如何降低共线性?
$$
\min _{\beta}\left\{\frac{1}{2 N}\|\mathbf{y}-\mathbf{X} \beta\|_{2}^{2}+\lambda\|\boldsymbol{\beta}\|_{2}^{2}\right\},
$$
上式的一阶条件为：$\qquad\qquad \small
-2 \boldsymbol{X}^{\prime}(\mathbf{y}-\boldsymbol{X} \beta)+2 \lambda \beta=0$
可推导出岭回归的估计量 $\widehat{\beta}_{\text {ridge }}$ 为:
$$\small
\widehat{\beta}_{\text {ridge }}=\left(\boldsymbol{X}^{\prime} \boldsymbol{X}+\lambda \boldsymbol{I}_{p}\right)^{-1} \boldsymbol{X}^{\prime} \mathbf{y}
$$
- 当 $p$ 很大时, $\small \boldsymbol{X}^{\prime} \boldsymbol{X}$ 为病态矩阵, 致使 $\small \mathrm{OLS}$ 估计在数值上很不可靠。但上式则不同：即使 $p>n$, 岭回归估计量仍然有唯一解。
- 具体而言, $\ell_{2}$ 范数惩罚项的加人可以让 $\left(X^{T} X+\lambda I\right)$ 满秩, 保证了可逆。
- 坏处：系数估计有偏, 即 $E[\widehat{\beta}_{\text {ridge }}] \neq \beta$ 。因此, 岭回归以放弃无偏性、 降低精度为代价来解决病态矩阵问题。
- 单位矩阵 $I$ 的对角线上全是 1 , 像一条山岭一 样, “岭回归" 也因此得名。

--- - --
<!-- backgroundColor: #C1CDCD -->
## 5. 调节参数 $\lambda$ 的选择

- 基本规则和流程
- 基于信息准则
- 基于交叉验证
- 基于经验法则


--- - --
<!-- backgroundColor: white -->

## 5.1 调节参数 $\lambda$ 的选择：基本经验规则和流程
在惩罚回归中, 系数估计和变量筛选 (模型设定) 都取决于调节参数 $\lambda$。

确定最优值 $\lambda^{*}$ 的方法主要分为三类：

1. **信息准则 (IC)**：选择最小化信息准则 $\mathrm{AIC}, \mathrm{AlCc}, \mathrm{BIC}$ 或 $\mathrm{EBIC}$ 的 $\lambda$ 的值。

2. **交叉验证 (CV)**：它属于数据驱动方法, 更为关注模型的 样本外预测能力, 所需的假设条件较为宽松, 在样本量较大时尤为适用。
3. **理论推演 (plugin)**：在一些常规的假设条件下, 推导出 理论上的 $\lambda^{*}$ 值, 因此不必再执行 $\mathrm{CV}$ 和 IC 方法的搜索 过程, 颇为省时。此法更倾向于选出精简的模型。它是 Stata 中 Lasso 系列命令的标配, 也被外部命令 rlasso 所采用 (Arhens et al., 2020)。


--- - --

###  选择依据

- 以样本外预测为目标时, 应选择以交叉验证为基础的方法, 
  
  - 如下文介绍的 **CV** 和 **adaptive-CV**; 
  - 适用场景举例：时间安慰剂检验、违约率预测等

* 以变量筛选为目标时, 可以选择理论推演值（plugin) 或信息准则 (如 BIC),
  
  * 前者速度极快, 后者在稀疏性较强的情况下表现稳定。
  * 适用场景举例：Controls 筛选；IVs 筛选



--- - --
<!-- backgroundColor: #e6e6fa -->
##  5.2 $\lambda^{*}$ 的选择：基于 BIC 准则

--- - --
<!-- backgroundColor: white -->

###  $\lambda^{*}$ 的选择流程：基于 BIC 准则 —— 以岭回归为例
这里先以形式相对简单的岭回归估计量为例
$$\small
\widehat{\beta}_{\text {ridge }}=\left(\boldsymbol{X}^{\prime} \boldsymbol{X}+\lambda \boldsymbol{I}_{p}\right)^{-1} \boldsymbol{X}^{\prime} \mathbf{y} \quad (1)
$$
采用 **BIC** 准则作为模型评估标准, 确定 $\lambda^{*}$ 的基本流程：
- **Step 1：** 预设未知参数 $\lambda$ 的取值范围，如 $\lambda_{j} \in\{0.01,0.02, \cdots, 8\}$, 相应的 $j$ 标记为 $j=1,2 \cdots J$。
- **Step 2：** 然后依次将 $\lambda_{j}$ 带人 (1) 式, 计算出 $\mathrm{BIC}_{j}$, 最终, $\left\{\mathrm{BIC}_{j}\right\}$ 的最小值对应的 $\lambda$ 便是其最优值 $\lambda^{*}$ 。

> Note: 也可以用 AIC 等其他准则


--- - --

### 信息准则 (1)：AIC 和 BIC
简要回顾一下 AIC, BIC, HQIC 等信息准则的计算公式：
- AIC (Akaike Information Criterion)：赤池信息准则
$$\small
\mathrm{AIC}=-2 \ln (L)+2 k
$$
- BIC (Bayesian Information Criterion)：贝叶斯信息准则
$$\small
\mathrm{BIC}=-2 \ln (L)+\ln (n) k
$$

- 其中, $\ln (L)$ 是模型的对数似然函数值, $n$ 是样本数, $k$ 是模型的参数个数。
- 上述 $IC$ 其实都是在 $\ln (L)$ 基础上施加惩罚后得到的。当 $n>8$ 时, $\ln (n)>2$, 因此, 多数情况下 BIC 对模型参数的惩罚都比 AIC 大, 更倾向于选择精简模型。

--- - --

### 信息准则 (2)：Lasso 情景下的 AIC 和 BIC 

在 Lasso 情境中, AIC 和 BIC 可表示为:
$$
\begin{aligned}
&\operatorname{AIC}(\lambda)=n \ln \widehat{\sigma}^{2}(\lambda)+2 \operatorname{df}(\lambda) \\
&\mathrm{BIC}(\lambda)=n \ln \widehat{\sigma}^{2}(\lambda)+\mathrm{df}(\lambda) \ln (n)
\end{aligned}
$$
- 其中, $\widehat{\sigma}^{2}(\lambda)=n^{-1} \sum_{i=1}^{n} \widehat{\varepsilon}_{i}^{2}\left(\widehat{\varepsilon}_{i}\right.$ 是残差), 
- $\operatorname{df}(\lambda)$ 是有效自由度, 用以衡量模型复杂程度, 可以用模型中非零系数的个数来代替
- $\mathrm{AlC}$ 和 $\mathrm{BIC}$ 都不太适合 “大 $p$ 小 $N$ " 型设定, 因为它们倾向于保留太多的变量。 
- $\mathrm{AIC}_{c}$ 有助于克服 $\mathrm{AIC}$ 存在的小样本偏差, 因此, 在 $n$ 很小或具有高维数据时, 应该优先使用 (Sugiura, 1978; Hurvich and Tsai, 1989)。
$$
\operatorname{AIC}_{c}(\lambda)=n \ln \widehat{\sigma}^{2}(\lambda)+2 \operatorname{df}(\lambda) \frac{n}{n-\operatorname{df}(\lambda)}
$$

--- - --

### 信息准则 (3)：EBIC
- **BIC** 假设每个模型出现的概率相同。在我们对模型设定没有任何先验知识时, 该假设有其合理性, 但在高维情境下, **BIC** 也倾向于选人太多变量 (over-select)。
- 为此, Chen and Chen (2008) 提出了 **EBIC** (Extended BIC), 它对参数数量施加了更为严格的惩罚, 选出的模型更为精简, 当 $p>n$ 时效果更为明显。
  $$
  \operatorname{EBIC}_{\xi}(\lambda)=n \ln \widehat{\sigma}^{2}(\lambda)+\mathrm{df}(\lambda) \ln (n)+2 \xi \mathrm{df}(\lambda) \ln (p)
  $$
  - 其中, 参数 $\xi \in[0,1]$ 用于控制惩罚力度。
  - Chen and Chen $(2008$, p.768) 设定为 $\xi=$ $1-\ln (n) /\{2 \ln (p)\}$ 。

--- - --

<!-- backgroundColor: #e6e6fa -->
##  5.3 $\lambda^{*}$ 的选择：K 折交叉验证法 (k-fold CV) —— 以岭回归为例


![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Fig-Lasso-CV01.png)
--- - --
<!-- backgroundColor: white -->

$$\small
\widehat{\beta}_{\text {ridge }}=\left(\boldsymbol{X}^{\prime} \boldsymbol{X}+\lambda \boldsymbol{I}_{p}\right)^{-1} \boldsymbol{X}^{\prime} \mathbf{y} \quad (1)
$$
- **Step 1：** 预设未知参数 $\lambda$ 的取值范围，如 $\lambda_{j} \in\{0.01,0.02, \cdots, 8\}$, 标记为 $\{\lambda_{1},\lambda_{2} \cdots \lambda_{J}\}$。
- **Step 2：** 针对 $\lambda_{1} (j=1)$，计算 $\small\mathrm{CV}_{K}(\lambda_1)$
  - **2a.** 将样本随机等分为 $\small K$ 份 (如, 5 份)
  - **2b.** 用其中 $\small K-1$ 份做岭回归, 剩下的第 $k$ 份做样本外预测, 计算均方误差：
  $$\mathrm{MSE}_{k}=\frac{1}{n_k}\sum_{i \in G_{k}}\left(y_{i}-\widehat{y}_{i}\right)^{2}$$
  - **2c.** 针对 $k=2 \cdots K$，重复进行 **2b**，得到 $\small\left\{\mathrm{MSE}_{k}\right\}\, (k=1,2,\cdots,K)$, 以及它们的均值 $\small\overline{\mathrm{MSE}}\left(\lambda_{1}\right)$ 。
  $$
  \mathrm{CV}_{K}(\lambda_1)=\overline{\mathrm{MSE}}\left(\lambda_{1}\right)=\sum_{k=1}^{K} \frac{n_{k}}{N} \mathrm{MSE}_{k}
  $$

--- - --

- **Step 1：** 预设未知参数 $\lambda$ 的取值范围，如 $\lambda_{j} \in\{0.01,0.02, \cdots, 8\}$, 标记为 $\{\lambda_{1},\lambda_{2} \cdots \lambda_{J}\}$。
- **Step 2：** 针对 $\lambda_{1} (j=1)$，计算 $\small\mathrm{CV}_{K}(\lambda_1)$
- **Step 3：** 针对每一个 $\lambda_{j}$，重复进行 **Step 2**，得到 $\mathrm{CV}_{K}(\lambda_j) (j=1,2,\cdots,J)$。

最终，所有 $\mathrm{CV}_{K}(\lambda_j) (j=1,2,\cdots,J)$ 的最小值对应的 $\lambda$ 即为 $\lambda^{*}$。

>**说明：**
- 假设 $J=100$，$K=5$，则上述过程需要经历 500 次运算。
- 实操中，$K=10$ 折最常用；
- 上述 CV 过程，也适用于 Lasso 等其他模型 

--- - --

### 10 fold CV 程序思路 
```stata
forvalues lambda = 0(0.01)1{
    use data, clear
    gen Gk = group(5)
    forvalues k = 1/5{
        ridgereg y x if Gk ~= `k'
        predict resid(res) if Gk==`k'
        calculate MSE_k_lamada_j
    }
    calculate Mean(MSE_k_lamada_j)
}
sort Mean(MSE_k_lamada_j)
dis lambda in 1/1
```

--- - --

### 10 fold CV: Stata 实例演示 
```stata
. sysuse "auto.dta", clear
. lasso linear price wei len mpg

10-fold cross-validation with 100 lambdas ...
Grid value 1:     lambda = 1577.862   no. of nonzero coef. =       0
Folds: 1...5....10   CVF =  8985154
Grid value 2:     lambda = 1437.689   no. of nonzero coef. =       1
Folds: 1...5....10   CVF =  8825419
... ...
Grid value 28:    lambda = 127.9852   no. of nonzero coef. =       2
Folds: 1...5....10   CVF =  7218420
Grid value 29:    lambda = 116.6154   no. of nonzero coef. =       3
Folds: 1...5....10   CVF =  7260448
... cross-validation complete ... minimum found
```

--- - --

### 10 fold CV: Stata 实例演示 (cont.)

```stata
Lasso linear model                          No. of obs        =         74
                                            No. of covariates =          3
Selection: Cross-validation                 No. of CV folds   =         10
--------------------------------------------------------------------------
         |                                No. of      Out-of-      CV mean
         |                               nonzero       sample   prediction
      ID |     Description      lambda     coef.    R-squared        error
---------+----------------------------------------------------------------
       1 |    first lambda    1577.862         0      -0.0470      8985154
      25 |   lambda before    169.1889         2       0.1673      7146156
    * 26 | selected lambda    154.1587         2       0.1677      7142522
      27 |    lambda after    140.4636         2       0.1643      7171650
      29 |     last lambda    116.6154         3       0.1540      7260448
--------------------------------------------------------------------------
* lambda selected by cross-validation.
```

--- - --

<!-- backgroundColor: #e6e6fa -->
## 5.4 $\lambda^{*}$ 的选择：理论推演值-plugin

--- - --
<!-- backgroundColor: white -->

- plugin 是基于理论分析来确定 $\lambda^{*}$ 的, 
  - 参见 Belloni and Chernozhukov (2011), Belloni et al. (2012), and Belloni, Chernozhukov, and Wei (2016)。
- 相对于 CV 和 BIC, plugin 选出的变量都更少, 因此模型更精简。
- 若主要目标是模型筛选 (如后文介绍的 Lasso-IV, 或 Double Selection), plugin 是 非常有效的方法。
- 最重要的是, 当样本较小时, 基于 $\mathrm{CV}$ 的方法会对随机分组非常敏感, 且经常因为无法找出合适的 $\lambda$ 而导致程序中止。此时, plugin 就会非常奏效, 因为它给出的 $\lambda^{*}$ 是从理论上直接推到出来的, 无需执行任何搜索程序。


--- - --
<!-- backgroundColor: #C1CDCD -->
## 6. Lasso 扩展模型

- 弹性网
- 平方根 Lasso
- 自适应 Lasso 


--- - --
<!-- backgroundColor: #e6e6fa -->
## 6.1 弹性网

--- - --
<!-- backgroundColor: white -->

### 为何要用弹性网？
- 岭回归：压缩系数, 有效避免高度共线性导致的系数估计不稳定
  - 局限：没有变量筛选能力 
  
- Lasso：压缩系数 + 变量筛选 —— 稀疏性假设 &rarr; 将部分变量的系数设为零
  - 局限：若模型中包含一组高度相关的变量, 则 Lasso 只能随机地选择其中的一个或几个, 而无法整体选入/删去。
- 弹性网 = 岭回归 + Lasso 
  - 优点：一组高度相关的变量 —— 整体选入或剔除


--- - --
### 弹性网：模型设定，Zou and Hastie (2005)

$$
\underset{\left(\beta_{0}, \beta\right)}{\operatorname{minimize}}\left\{\frac{1}{2} \sum_{i=1}^{N}\left(y_{i}-\beta_{0}-x_{i}^{\prime} \beta\right)^{2}+\lambda\left[\frac{1}{2}(1-\alpha)\|\beta\|_{2}^{2}+\alpha\|\beta\|_{1}\right]\right\}
$$
- 其中, $\alpha \in[0,1]$ 是一个可变参数。
- 显然, Lasso 和岭回归都是弹性网 (ENet) 的特例: 
  - 当 $\alpha=1$ 时, ENet 退化成 Lasso; 
  - 当 $\alpha=0$ 时, 则变成了岭回归。

- 模型中的参数 $\alpha$ 和 $\beta$ 可以采用 ${K}$ 折交叉验证法来确定调节参数的最佳取值
- 求解过程与 Lasso 相似, 多用循环坐标下降法。

--- - --

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Fig-Lasso-enet-HTW2015-Fig4-1.png)


--- - --
<!-- backgroundColor: #e6e6fa -->
## 6.2 平方根 Lasso

- 简称 sqrt-Lasso
- Belloni, Chernozhukov and Wang (2011) 提出


--- - --
<!-- backgroundColor: white -->

### 目标函数

  $$\small \text{普通 Lasso：\quad }
  \frac{1}{2 N}\left(\mathbf{y}-\mathbf{X} \boldsymbol{\beta}^{\prime}\right)^{\prime}\left(\mathbf{y}-\mathbf{X} \boldsymbol{\beta}^{\prime}\right)+\lambda \sum_{j=1}^{p}\left|\beta_{j}\right|
  $$

  $$\small \text{sqrt-Lasso：\quad }
  \sqrt{\frac{1}{N}\left(\mathbf{y}-\mathbf{X} \boldsymbol{\beta}^{\prime}\right)^{\prime}\left(\mathbf{y}-\mathbf{X} \boldsymbol{\beta}^{\prime}\right)}+\frac{\lambda}{N} \sum_{j=1}^{p}\left|\beta_{j}\right|
  $$

- 这种设定可以让扰动项的标准差成为一个常数, 易于求解 $\lambda$ 的理论最优值 $\lambda^{*}$。
  
- 该值可以为双重 Lasso (double-selection)、偏出 Lasso (partialing-out methods) 等需要多次 Lasso 估计的方法提供 $\lambda$ 的初始值, 提高求解效率。
- 因此, sqrtLasso 通常用于确定其他模型中的 $\lambda^{*}$, 很少单独使用。


--- - --
<!-- backgroundColor: #e6e6fa -->
## 6.3 自适应 Lasso 

- Adaptive Lasso, 简称 ALasso
- Zou (2006)
--- - --
<!-- backgroundColor: white -->

### ALasso 简介
- 适用：比传统 Lasso 更稀疏的模型。
- 方法：
  - 在传统 Lasso 估计的基础上做二次/多次惩罚处理，大力惩罚较小的系数
  - ALasso 选出的模型比传统 Lasso 更为精简。

--- - --

ALasso 的目标函数为:
$$
\begin{gathered}
\underset{\beta \in \mathbb{R}^{p}}{\operatorname{minimize}}\left\{\frac{1}{2}\|\mathbf{y}-\mathbf{X} \beta\|_{2}^{2}+\lambda \sum_{j=1}^{p} w_{j}\left|\beta_{j}\right|\right\} \\
w_{j}=1 /\left|\widetilde{\beta}_{j}\right|^{\theta}
\end{gathered}
$$
- $w_{j}$ 为二次惩罚因子, $\widetilde{\beta}_{j}$ 是基于 Lasso 或 OLS (或单变量 OLS) 得到的初始估计值
- 显然, 对于变量 $j$, 初始系数 $\widetilde{\beta}_{j}$ 越小, 其二次惩罚权重 $w_{j}$ 就越大, 在后续筛选中被删去的可能性越大。
- 初始参数 $\widetilde{\beta}_{j}$ 的获取方法：
  - 若 $p<N$, 则可以用 OLS 获取；
  - 若 $p \geq N$, 可以用传统 Lasso, 或单变量 OLS 估计。



--- - --
<!-- backgroundColor: #C1CDCD -->
## 7. Lasso 在经济金融中的应用

- **Post-Lasso**
- **Lasso IV**
- Double Selection Lasso (**DSL**)
- Partialing-out Lasso (**PO-Lasso**)
- Double/Debiased Machine Learning (**DML**)

--- - --
<!-- backgroundColor: white -->

### 简介
- Lasso 的优势是预测，而非模型筛选, 但可以借助其预测能力辅助因果推断, 如：
  - 估计反事实结果
  - 克服冗余工具变量问题

- 多数研究中, 我们感兴趣的变量都很明确, 通常只有 1-2 个。但为了排除混淆因素的影响, 还需要在模型中设置很多控制变量 / 工具变量, 此时便可用 Lasso 处理如下两种情况:
  - 选择控制变量, 以解决遗漏变量偏误。
  - 选择工具变量, 以解决冗余工具变量引起的弱工具变量问题。


--- - --
<!-- backgroundColor: #e6e6fa -->
## 7.1 Post-Lasso

--- - --
<!-- backgroundColor: white -->

### 
Lasso 估计量 $\widehat{\beta}_{\text {Lasso }}$ 在筛选变量的同时也对系数进行了收缩 (惩罚)。收缩会引人偏差。

Post-Lasso 估计：先用 Lasso 筛选变量, 进而对选出的变量集执行 OLS 估计。

- **第一步**, 用 Lasso 估计如下模型，筛选出的具有非零系数的变量集记为 $X_{S}$：
$$
Y=X^{\prime} \beta+e
$$

- **第二步**, 用被解释变量 $Y$ 对 $X_{S}$ 执行 OLS 估计, 得到系数估计值,
$$
\widehat{\beta}_{S}=\left(\boldsymbol{X}_{S}^{\prime} \boldsymbol{X}_{S}\right)^{-1}\left(\boldsymbol{X}_{S}^{\prime} \boldsymbol{Y}\right)
$$

可以看出, 所谓的 Post-Lasso, 本质上是借助 Lasso 进行变量筛选, 进而用 OLS 对选出的变量执行传统的线性回归。关键在于第一步的筛选过程是否能挑选出正确的模型。
> Note: 根据需要，第一步可以换用弹性网或自适应 Lasso 等方法, 以便保证变量筛选的一致性。

--- - --

需要特别强调的是, Post-Lasso 这种估计思想的价值远比其自身的应用价值要高。若单独使用该方法进行因果推断或回归分析, 需要非常谨慎。原因有二： 
- 其一, Post-Lasso 是两步估计法, 第一阶段的 Lasso 过程存在随机性 ($\lambda$ 的选择具有随机性), 这种 "sample-to-sample variability" 导致的偏误需要在第二阶段的 OLS 回归中予以考虑, 比如, 采用纠偏后的标准误, 然而, 这并非易事。
- 其二, Lasso 会删去很多 “不重要 (系数较小)” 的变量, 或者在一组高度相关的变 量中随机删除其中的一部分。
  - 若研究目的是预测, 这些处理不会产 生太大的影响, 甚至是必须的, 
  - 但对于模型筛选而言, 则会导致遗漏变量偏误。

--- - --
<!-- backgroundColor: #e6e6fa -->
## 7.2 Lasso IV



--- - --
<!-- backgroundColor: white -->
### 冗余工具变量问题
- 多数情况下, 我们都很难找到工具变量
- 但有时情况恰好相反：我们有很多潜在的工具变量, 但它们具有稀疏性
  - 只有一小部分与内生变量存在较强的相关性, 其它的则都是 “弱工 具变量”。
- e.g., 在动态面板估计中, 若 $T$ 较大, 比如 $T>40$, 
  - 则在使用 SYS-GMM 且不对工具变量的取舍做任何限制时, 往往会导致在一个只有 $N T=30 \times 40=1200$ 个观察值的样本中, 被 Stata 的 xtabond2 或 xtdpdsys 自动选人的工具变量数超过 300 个。
  - 这会导致严重的自由度损耗, 也会导致后续的过度识别检验和序列相关检验无法通过 (意 味着这些工具变量不全是 “干净” 的 IV)。
  - 为了应对这种情形, 我们会人为地限制工具 变量个数, 但这又导致工具变量的主观选择, 致使实证结果存在一定的人为操控嫌疑。


--- - --
<!-- backgroundColor: white -->
###  Lasso-IV 估计量
Belloni, et al. (2012) 利用 Lasso 的变量筛选功能剔除冗余 IVs。

考虑如下基本的 IV 模型设定：
$$
\begin{aligned}
&Y=X^{\prime} \beta+e, \quad \mathbf{E}[e \mid Z]=0 \\
&X=\Gamma^{\prime} Z+U, \quad \mathbf{E}[U \mid Z]=0
\end{aligned}
$$
- 其中, $\beta$ 为 $k \times 1$ (固定), 而 $\Gamma$ 为 $p \times n$ 。
- 关键：$p$ 可以很大。
  - 如果 $p>n$, 则 $2 \mathrm{SLS}$ 估计量与 $\mathrm{OLS}$ 估计等价。
  - 如果 $p<n$ 但较大, 则 $2 \mathrm{SLS}$ 估计量存在 “冗余工具变量" 问题。
  - 此时, 可以用 Lasso：Belloni et al. (2012) 建议用 Lasso 或 Post-Lasso 估计 $\Gamma$ 。


--- - --
<!-- backgroundColor: white -->
### 多个内生变量的情形
- 如果 $X$ 中包含多个内生变量, 则可以依次执行 Lasso 筛选, 即让它们分别对 $Z$ 进 行 Lasso 回归。设第 $j$ 个内生变量与工具变量之间的回归方程为：
$$
X_{j}=\gamma_{j}^{\prime} Z+U_{j}
$$

Lasso 后的系数估计值为 $\widehat{\gamma}_{j}(j=1,2, \cdots, J)$。将这 $J$ 个系数统一放置在矩阵 $\widehat{\Gamma}_{\text {Lasso }}$ 中, 从而得到 $X$ 的预测值 (类似于 $2 \mathrm{SLS}$ 中第一阶段得到的拟合值):
$$
\widehat{\boldsymbol{X}}_{\text {Lasso }}=\boldsymbol{Z} \widehat{\Gamma}_{\text {Lasso }}
$$
最终, Lasso-IV 估计量可以表示为：
$$
\widehat{\beta}_{\text {Lasso-IV }}=\left(\widehat{\boldsymbol{X}}_{\text {Lasso }}^{\prime} \boldsymbol{X}\right)^{-1}\left(\widehat{\boldsymbol{X}}_{\text {Lasso }}^{\prime} \boldsymbol{Y}\right) .
$$

--- - --
### Lasso IV小结
- Lasso-IV 其实就是在传统的 2SLS 基础上增加了一个基于 Lasso 的变量筛选环节。
- 但这个看似简单的步骤却可以很好地解决困扰大家已久的「弱工具变 量」问题。
  
- 例如, Belloni, Chernozhukov and Hansen ([2014](https://doi.org/10.1257/jep.28.2.29)) 使用 Lasso-IV 方法重新估 计了 Chen and Yeh (2012) 的模型后, 发现虽然备选工具变量有 144 个, 但采用 Lasso 篮选后真正有用的 IV 其实只有一个。
- 考虑到原文的样本中只有 185 个观察值, 将 IV 个数从 144 减少为 1 个, 估计值的有效性将大幅提高。


--- - --
<!-- backgroundColor: #e6e6fa -->
## 7.3 Double Selection Lasso (**DSL**)

- Belloni, Chernozhukov, and Hansen (2014b, RES)

--- - --
<!-- backgroundColor: white -->
###  Post-Lasso / Lasso-OLS 的局限
前面介绍的 Post-Lasso (或曰 Lasso-OLS 两步估计法) 虽然可以筛选变量, 但当模型筞选目的是因果推断时, 该方法存在严重的缺陷。考虑如下模型：
$$
Y=D \theta+X_{1}^{\prime} \beta_{1}+X_{2}^{\prime} \beta_{2}+e, \quad 
\mathrm{E}\left[e \mid D, X_{1}, X_{2}\right]=0
$$
- 变量 $D$ 是重点关注的政策虚拟变量
- 控制变量集为 $X=\left(X_{1}, X_{2}\right)$, 其数量可能很庞大, 甚至超过样本数
- 假设采用 Lasso 对控制变量 $X$ 进行筛选, 最终得到系数非零的变量集为 $X_{1}$

在第二阶段的 OLS 回归中, 估计如下模型 (Post-Lasso):
$$
Y=D \widetilde{\theta}+X_{1}^{\prime} \gamma_{1}+u, \quad u=X_{2}^{\prime} \beta_{2}+e
$$
- 显然, 这里很可能存在遗漏变量偏误。因为, 如果 $\operatorname{corr}\left(D, X_{2}\right) \neq 0$, 则意味着 $\operatorname{corr}(D, u) \neq$ 0 , 并进而导致 $\tilde{\theta}$ 的 OLS 估计不再是 $\theta$ 的无偏估计。


--- - --
### Double Selection Lasso (**DSL**)

$$
Y=D \theta+X_{1}^{\prime} \beta_{1}+X_{2}^{\prime} \beta_{2}+e, \quad  X=\left(X_{1}, X_{2}\right)
$$

- 基本思想：分别用 $Y$ 和 $D$ 对 $X$ 执行 Lasso 回归, 并将两次筛选出的变量的 **并集** 作为最终的控制变量集 $X_{D S}$。
- 最终, 用 $Y$ 对 $D$ 和 $X_{D S}$ 执行 OLS 回归即可。

Belloni et al. (2014b) 的理论分析表明, 
- 若 $Y, D$ 与 $X$ 之间都满足近似稀疏性假设 (模型可以用数量有限的一组变量来很好地近似), 则 Double-Selection Lasso 估计量 及其 $t$ 值都渐进地服从正态分布。因此, 常规的统计推断方法仍然适用。
- 需要注意的是, 这些结论都是以 $N \rightarrow \infty$ 为前提的, 在有限样本下仍然可能存在较大的偏差。


--- - --
<!-- backgroundColor: white -->
###  DS-Lasso 估计过程：详解

考虑如下回归模型: Stata 手册 [**[LASSO]** dsregress](https://www.stata.com/manuals/lassodsregress.pdf) (p.6)
$$
\mathbf{E}[y \mid \mathbf{d}, \mathbf{x}]=\mathbf{d} \boldsymbol{\alpha}^{\prime}+\beta_{0}+\mathbf{x} \boldsymbol{\beta}^{\prime}
$$
其中, 
- $\mathbf{d}$ 中包含 $J$ 个我们要重点研究的变量 (多数情况下 $J=1$ 或只有 2-3 个)。 
- $\mathbf{x}$ 中 包含 $p$ 个控制变量, $p$ 可以很大, 其至超过样本数 $(p \gg n)$ 或可以随着样本数的增加而增加。
- 数据必须满足稀疏性或近似稀疏性假设, 即 $\boldsymbol{\beta}$ 中系数非零的变量数目非常有限。



--- - --
<!-- backgroundColor: white -->
### DS-Lasso 的实现过程: 详解
1. 用 $y$ 对 $\mathbf{x}$ 执行线性 Lasso 估计 (`lasso linear y x*`), 将选出的变 量集记为 $\widetilde{\mathbf{x}}_{y}$ 。
2. 对 $\mathbf{d}$ 中的每个变量 $d_{j}(j=1, \ldots, J)$ 依次执行 Lasso 变量筛选, 即, 用 $d_{j}$ 对 $\mathbf{x}$ 进 行 Lasso 回归, 选出的变量集记为 $\widetilde{\mathbf{x}}_{j}$ 。
3. 将第一步和第二步中筛选出来的所有变量集取并集, 得到最终的控制变量集, 即 $\widehat{\mathbf{x}}=\left\{\widetilde{\mathbf{x}}_{1} \cup \widetilde{\mathbf{x}}_{1} \cdots \widetilde{\mathbf{x}}_{J} \cup \widetilde{\mathbf{x}}_{y}\right\}$
4. 用 $y$ 对 $\mathbf{d}$ 和 $\widehat{\mathbf{x}}$ 执行线性回归, 对应的系数估计估计值记为 $\widehat{\boldsymbol{\alpha}}$ 和 $\widehat{\boldsymbol{\beta}}$ 。Stata 中默认 计算稳健性标准误, 即 reg y d x_hat, vce(robust)。


**Note：** 第 3 步之所以「取并集」, 是为了避免遗漏变量偏误。换言之, 无论是对 $y$ 还是对 $d_{j}$ 有影响的变量都应保留。这是 DS-Lasso 用以克服 Post-Lasso 局限的主要 手段。


--- - --
<!-- backgroundColor: #e6e6fa -->
## 7.4 Partialing-out Lasso (PO-Lasso)

--- - --
### Partial out 与 FWL 定理 
<!-- backgroundColor: #FFFFF9 -->

- FWL 定理由 Frisch and Waugh (1933) 和 Lovell (1963) 提出
  - 它阐释了 OLS 回归的一个重要性质，为理解多元回归的系数含义，高效地估计高维固定效应提供了一个重要的理论基础。
  - Davidson and MacKinnon ([1993](http://qed.econ.queensu.ca/pub/dm-book/EIE-davidson-mackinnon-2021.pdf), 19-24) 以及 Davidson and MacKinnon ([2004](http://qed.econ.queensu.ca/pub/faculty/mackinnon/econ850/), [PDF](http://qed.econ.queensu.ca/ETM/ETM-davidson-mackinnon-2021.pdf), pp. 62–75, [Slides](http://qed.econ.queensu.ca/pub/faculty/mackinnon/econ850/slides/econ850-slides-h03.pdf)) 对此进行非常细致的介绍。
- **应用：**
  - 在 Stata 中，`reghdfe` 等处理高维固定效应的命令基本原理便是 FWL 定理
  - 在 `ivreg2`, `lasso2` 等命令中经常出现的 `partial()` 选项也基于 FWL 定理
  - 用于可视化展示多元回归结果的部分回归图命令 `avplot`, `reganat`, `avciplot`, `avciplots`, `binscatter` 等也都基于 FWL 定理。

--- - --

- **Stata 实操**
  - Filoso, V., **2013**, Regression Anatomy, **Stata Journal**, 13(1): 92–106. [-PDF-](https://journals.sagepub.com/doi/pdf/10.1177/1536867X1301300107)
  - [图示线性回归系数：Frisch-Waugh定理与部分回归图](https://www.lianxh.cn/news/e346db1a68211.html)
  - [多元回归系数：我们都解释错了？](https://www.lianxh.cn/news/22f1f266f5868.html)

--- - --

<!-- backgroundColor: white -->

![bg left:40% w:400](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/OLS-venn-01.png)

![w:400](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/OLS-venn-02.png)

--- - --

$\small Y=X_1 {\color{red}{\beta_1}} + X_2 \beta_2 + u$ $\ \ \Leftrightarrow$ $\ \ \small \tilde{Y}= \tilde{X}_1 {\color{red}{\beta_1}} + v$

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Lianxh_装饰黄线.png)

`reg Y X2` 
`predict eY, res` &rarr; $\small\ \ \ \tilde{Y} = A + {\color{blue}{B}}$

`reg X1 X2` 
`predict eX1, res` &rarr; $\small \tilde{X}_1 = F + {\color{blue}{B}}$
![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Lianxh_装饰黄线.png)

`reg eY eX1` &rarr; `dis _b[eX1]` = $\small{\color{red}{\widehat{\beta}_1}}$ &rarr; ${\color{blue}{B}}$

![bg left:40% w:400](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/OLS-venn-01.png)



--- - --

$$\small Y=X_1 {\color{red}{\beta_1}} + X_2 \beta_2 + u \ \ {\color{blue}{\Leftrightarrow}} \ \ \small Y= \tilde{X}_1 {\color{red}{\beta_1}} + v$$

- 事实上，只需从 $X_1$ 中去除  (partial out) $X_2$ 的影响，得到 $\tilde{X}_1$，进而用 $Y$ 对 $\tilde{X}_1$ 进行回归即可。即，如下回归都是等价的：
  
  - `reg` $\small \tilde{Y}$ on $\small\tilde{X}_1$
  - `reg` $\small {Y}$ on $\small\tilde{X}_1$
  - `reg` $\small {Y}$ on $\small{X}_1, {X}_2$

![bg left:40% w:400](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/OLS-venn-01.png)


--- - --
### 回顾与对比
> **DS-Lasso:**
1. 用 $Y$ 对 $X$ 执行 Lasso 回归, 筛选出变量集 $\widetilde{X}_{1}$;
2. 用 $D$ 对 $X$ 执行 Lasso 回归, 筛选出变量集 $\widetilde{X}_{2}$；
3. 最终的控制变量集 $\widetilde{X}_{D S}=\widetilde{X}_{1} \cup \widetilde{X}_{2}$;
4. 用 $Y$ 对 $D$ 和 $\widetilde{X}_{D S}$ 执行 $\mathrm{OLS}$ 回归。变量 $D$ 的系数 $\widehat{\theta}_{D S}$ 是 $\theta$ 的一致估计。

<br>

> **PO-Lasso:** (NEW)
1. 用 $Y$ 对 $X$ 执行 Lasso 选出 $\widetilde{X}_{1}$，进而用 $Y$ 对 $\widetilde{X}_{1}$ 执行 OLS 回归, 得到残差 $\widehat{E}_{Y}$;
2. 用 $D$ 对 $X$ 执行相同操作, 得到残差 $\widehat{E}_{D}$;
3. 用 $\widehat{E}_{Y}$ 对 $\widehat{E}_{D}$ 执行 $\mathrm{OLS}$ ，则 $\widehat{E}_{D}$ 的系数 $\widehat{\theta}$ 是 $\theta$ 的一致估计



--- - --
<!-- backgroundColor: #e6e6fa -->
## 7.5 Double/Debiased Machine Learning (**DDML**)

--- - --
<!-- backgroundColor: white -->

### DS-Lasso 和 PO-Lasso 的局限
- DS-Lasso 和 PO-Lasso 本质上都是 **两阶段估计**: 
  - 第一阶段通过 Lasso 筛选变量 (模型筛选), 
  - 第二阶段执行 OLS 或 IV 估计。

- **局限：**
  - 如果第一阶段的估计存在较大的偏差 (e.g. 有些重要变量末被选中), 这些偏差会进入第二阶段
  - 后果：第二阶段的估计结果存在较大的偏差或方差。

- **解决办法：**
  - DML：引入了交叉验证的思想 —— 最终的估计结果是 K 折估计的加权平均。
  - 可以视为：“模型均化” (Model Averaging) 


--- - --

我们要研究的目标模型与 DS-Lasso 以及 PO-Lasso 相同：
$$
\begin{array}{r}
Y=D \theta+X \beta+e \\
\mathrm{E}[e \mid D, X]=0 
\end{array} \quad (1)
$$
相比于 PO-Lasso, DML 的主要改进在于：
- 增加了“样本拆分" (samplesplitting) 环节, 这可以降低 DS-Lasso 和 PO-Lasso 中两次 Lasso 之间的相关性,
- 防止第一阶段的偏误 **污染** 第二阶段的估计结果

--- - --
### 模型设定
$$
\begin{array}{r}
Y=D \theta+X \beta+e \\
\mathrm{E}[e \mid D, X]=0 
\end{array} \quad (1)
$$
为了便于说明其估计流程, 这里先增加一个辅助方程:
$$
D=X^{\prime} \gamma+V, \quad \mathrm{E}[V \mid X] =0 \quad (2)
$$
把 (2) 带人 (1), 可得:
$$
Y=X^{\prime} \eta+U, \quad \mathrm{E}[U \mid X]=0 \quad (3)
$$
其中, $\eta=\beta+\gamma \theta,\quad  U=e+V \theta$ 。

DML 引人了交叉验证的思想, 进行了所谓的 “K-折切分" (K-fold partitioning), 估计流程如下：

--- - --
### “K-折切分" 估计
$$\small
D=X^{\prime} \gamma+V, \quad \mathrm{E}[V \mid X] =0 \quad (2)
$$
$$\small
Y=X^{\prime} \eta+U, \quad \mathrm{E}[U \mid X]=0 \quad (3)
$$
- **S1：** 去一折法 + Lasso，得到 $\small\widehat{\boldsymbol{U}}$ 和 $\small\widehat{\boldsymbol{V}}$
- **S2：** 用 $\small\widehat{\boldsymbol{U}}$ 对 $\small\widehat{\boldsymbol{V}}$ 执行 OLS 估计, 得到  
  $$\small Y=D \theta+X \beta+e \quad (1)$$ 
  中 $\theta$ 的一致估计, 即为 $\widehat{\theta}_{\mathrm{DML}}$
- **S3：** 计算 $\widehat{\theta}_{\mathrm{DML}}$ 的异方差稳健标准误，进行统计推断，与传统回归分析无异。
![bg left:45% w:500](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20220730230305.png)

--- - --
<!-- backgroundColor: white -->
### DML 的局限和建议
- **局限：** $K$ 折分组是随机的 &rarr; 最终估计值随机 &rarr; 将 $K$ 设置成较大的数值。问题：
  - 增加计算成本
  - N 不大时，过多的分组会导致参数估计的方差变大。
- **建议：** 
  - DML 比较适合 $N$ 较大的场景。
  - 测试不同 K 值下的结果，不应对 K 的选取敏感
  - 可行思路：循环交叉验证 —— 执行多次 (如 100 次) DML，取均值
- 上述过程也适用于 Logit, Poisson, IV 等估计方法

--- - --
<!-- backgroundColor: white -->
### Stata 实操
DML 相关命令均以 `xpo` 开头, 包括: 
- `xporegress` (线性回归), [**[LASSO]** xporegress](https://www.stata.com/manuals/lassoxporegress.pdf)
- `xpologit` (Logit 模型), [**[LASSO]** xpologit](https://www.stata.com/manuals/lassoxpologit.pdf) 
- `xpopoisson` (泊松模型), [**[LASSO]** xpopoisson](https://www.stata.com/manuals/lassoxpopoisson.pdf) 
- `xpoivregress` (IV 估计)，[**[LASSO]** xpoivregress](https://www.stata.com/manuals/lassoxpoivregress.pdf) 


--- - --
<!-- backgroundColor: pink -->

<center>

## 实操和应用：参见 dofile 


<br>
<br>

建议/纠错：<arlionn@163.com>

