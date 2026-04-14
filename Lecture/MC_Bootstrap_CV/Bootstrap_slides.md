---
marp: true
size: 16:9
paginate: true
---

<!-- Global style -->
<style>
h1 {
  color: darkyellow;
}
h2 {
  color: darkblue;
}
h3 {
  color: green;
}
</style>

<!--封面图片-->
![bg right:50% brightness:. sepia:50% w:500](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20221127233319.png)



<!--底部链接-->
<!-- footer: 连享会 · [推文](https://www.lianxh.cn) &nbsp;  | &nbsp;  lianxh.cn &nbsp; | &nbsp; [Bilibili](https://space.bilibili.com/546535876) &nbsp;| &nbsp; [课程](https://www.lianxh.cn/news/46917f1076104.html)-->

<!--顶部文字-->
#### [${\color{blue}{连享会·课程}}$](https://www.lianxh.cn/news/46917f1076104.html)



<!--幻灯片标题-->
# 再抽样方法 
> ### Resampling methods

<br>

- Bootstrap
- Jackknife 
- Permutation

参考：[What is Bootstrapping in Statistics? A Deep Dive](https://www.datacamp.com/tutorial/bootstrapping)

<br>

<!--作者信息-->
#### [连玉君](https://www.lianxh.cn) (中山大学)
arlionn@163.com

<br>

---

## 参考资料
- Hansen, B.E., Slides, [Bootstrap](https://www.ssc.wisc.edu/~bhansen/706/boot.pdf)
- Wikipedia, [Resampling (statistics)](https://en.wikipedia.org/wiki/Resampling_(statistics))
- Wikipedia, [Bootstrapping (statistics)](https://en.wikipedia.org/wiki/Bootstrapping_(statistics))
- Wikipedia, [Empirical distribution function](https://en.wikipedia.org/wiki/Empirical_distribution_function)
- Wikipedia, [Frequency (statistics)](https://en.wikipedia.org/wiki/Frequency_(statistics))
- [BOOTSTRAP IN NONSTATIONARY AUTOREGRESSION](https://dml.cz/bitstream/handle/10338.dmlcz/135473/Kybernetika_38-2002-4_1.pdf)

---
<!-- backgroundColor: white -->
### 提纲 1

- 基本概念
  - 总体，抽样样本，经验样本
  - 标准差与标准误
  - 分布函数、分位数
- Bootstrap 基本原理
  - Bootstrap 标准误
  - Bootstrap 置信区间
  - Bootstrap 经验 p 值

--- - --
### 提纲 2

- Bootstrap 方法
  - Pair Bootstrap
  - Pamameter Bootstrap
  - Residuals Bootstrap
  - Wild Bootstrap
  - Block Bootstrap

--- - --

## Bootstrap 简史
The bootstrap was 
- published by [Bradley Efron](https://en.wikipedia.org/wiki/Bradley_Efron) in "Bootstrap methods: another look at the jackknife" (1979),[[5\]](https://en.wikipedia.org/wiki/Bootstrapping_(statistics)#cite_note-5)[[6\]](https://en.wikipedia.org/wiki/Bootstrapping_(statistics)#cite_note-6)[[7\]](https://en.wikipedia.org/wiki/Bootstrapping_(statistics)#cite_note-7) inspired by earlier work on the [jackknife](https://en.wikipedia.org/wiki/Jackknife_resampling).[[8\]](https://en.wikipedia.org/wiki/Bootstrapping_(statistics)#cite_note-Quenouille1949-8)[[9\]](https://en.wikipedia.org/wiki/Bootstrapping_(statistics)#cite_note-Tukey1958-9)[[10\]](https://en.wikipedia.org/wiki/Bootstrapping_(statistics)#cite_note-Jaeckel1972-10) 
- Improved estimates of the variance were developed later.[[11\]](https://en.wikipedia.org/wiki/Bootstrapping_(statistics)#cite_note-Bickel1981-11)[[12\]](https://en.wikipedia.org/wiki/Bootstrapping_(statistics)#cite_note-Singh1981-12) 
- A Bayesian extension was developed in 1981.[[13\]](https://en.wikipedia.org/wiki/Bootstrapping_(statistics)#cite_note-Rubin1981-13) 
- The bias-corrected and accelerated (BCa) bootstrap was developed by Efron in 1987,[[14\]](https://en.wikipedia.org/wiki/Bootstrapping_(statistics)#cite_note-BCa-14). 
- The ABC procedure in 1992.[[15\]](https://en.wikipedia.org/wiki/Bootstrapping_(statistics)#cite_note-Diciccio1992-15)

> Source: Wikipedia, [Bootstrapping (statistics)](https://en.wikipedia.org/wiki/Bootstrapping_(statistics))

--- - --

![BS-02-assum-normal](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/BS-02-assum-normal.png)
--- - --

![BS-01-population](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/BS-01-population.png)



--- - --

![BS-03-pop-sample-bsample](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/BS-03-pop-sample-bsample.png)


--- - --

![w:950 BS-Bootstrap-resampling-method-001](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/BS-Bootstrap-resampling-method-002.png)

<!-- > Source: [resampling - Bootstrap](https://analystprep.com/cfa-level-1-exam/quantitative-methods/resampling/) -->

--- - --


![20241215000654](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20241215000654.png)

> Source: <https://datasciencebook.ca/inference.html#bootstrapping>


--- - --


### 参考文献
- Rubin, D. B. (1981). "The Bayesian bootstrap". *Annals of Statistics*, 9, 130.






---


# Bootstrap and Subsampling

- Author: C.Conlon
- Institute: Applied Econometrics II
- Source: <https://github.com/chrisconlon/applied_metrics/tree/master/Lecture%204-%20Delta%20Method%20and%20Bootstrap>

---

$$
\begin{aligned}
y_{i t} & =\mathbf{1}\left(z_{1 i t}^{\prime} \beta_z+\beta_2 x_{i t}+u_{1 i t}>0\right) \\
& \equiv \mathbf{1}\left(\varphi_t^{\prime} \psi+\mathfrak{z}_{i t}^{\prime} \beta_1+\beta_2 x_{i t}+u_{1 i t}>0\right) \equiv \mathbf{1}\left(\psi_t+\mathfrak{z}_{i t}^{\prime} \beta_1+\beta_2 x_{i t}+u_{1 i t}>0\right),
\end{aligned}
$$

---

## Bootstrap

- Bootstrap takes a different approach.
  - Instead of estimating $\hat{\theta}$ and then using a first-order Taylor Approximation...
  - What if we directly tried to construct the **sampling distribution** of $\hat{\theta}$?
- Our data $(X_1,\ldots,X_n) \sim P$ are drawn from some measure $P$
  - We can form a **nonparametric estimate** $\hat{P}$ by just assuming that each $X_i$ has weight $\frac{1}{n}$.
  - We can then simulate a new sample $X^{*} = (X_1^{*},\ldots X_n^{*}) \sim \hat{P}$.
    - Easy: we take our data and construct $n$ observations by **sampling with replacement** 
  - Compute whatever statistic of $X^{*}$, $S(X^*)$ we would like.
    - Could be the OLS coefficients $\beta_1^{*},\ldots, \beta_k^{*}$.
    - Or some function $\beta_1^{*}/\beta_2^{*}$.
    - Or something really complicated: estimate parameters of a game $\hat{\theta}^*$ and now find Nash Equilibrium of the game $S(X^{*},\hat{\theta^*})$ changes.
  - Do this $B$ times and calculate at $Var(S_b)$ or $CI(S_1,\ldots, S_b)$.

---

## Bootstrap: Bias Correction

The main idea is that $\hat{\theta}^{1*},\ldots, \hat{\theta}^{B*}$ approximates the **sampling distribution** of $\hat{\theta}$. There are lots of things we can do now:

- We already saw how to calculate $Var(\hat{\theta}^{1*},\ldots, \hat{\theta}^{B*})$.

  $$\frac{1}{B-1} \sum_{b=1}^B (\hat{\theta}_{(b)}^* - \overline{\theta^{*}})^2$$

- Calculate $E(\hat{\theta}^{*}_{(1)},\ldots, \hat{\theta}^{*}_{(B)}) = \overline{\theta^{*}} = \frac{1}{B} \sum_{b=1}^B \hat{\theta}_{(b)}^*$.

---

## Bootstrap: Bias Correction

- We can use the estimated bias to **bias correct** our estimates

  $$
  \begin{align*}
  Bias(\hat{\theta}) & = E[\hat{\theta}] - \theta \\
  Bias_{bs}(\hat{\theta}) &=\overline{\theta^{*}} -\hat{\theta}
  \end{align*}
  $$

  Recall $\theta = E[\hat{\theta}] - Bias[\hat{\theta}]$:

  $$
  \hat{\theta}- Bias_{bs}(\hat{\theta}) = \hat{\theta}-(\overline{\theta^{*}}-\hat{\theta}) = 2 \hat{\theta} - \overline{\theta^{*}}
  $$

- Correcting bias isn't for free - variance tradeoff!
- Linear models are (hopefully) unbiased, but most nonlinear models are **consistent but biased**.

---

## Bootstrap: Confidence Intervals

There are actually three ways to construct bootstrap CI's:

1. Obvious way: sort  $\hat{\theta}^{*}$ then take $CI: [\hat{\theta}^{*}_{\alpha/2},\hat{\theta}^{*}_{1-\alpha/2}]$.

2. Asymptotic Normal:  $CI: \hat{\theta} \pm 1.96 \sqrt{V(\hat{\theta}^{*})}$. (CLT).

3. Better Way: let $W= \hat{\theta} -\theta$. If we knew the distribution of $W$ then: $Pr(w_{1-\alpha/2} \leq W \leq w_{\alpha/2})$:

   $$CI: [\hat{\theta} -w_{1-\alpha/2}, \hat{\theta} -w_{\alpha/2}]$$

   We can estimate with $W^{*} = \hat{\theta}^{*} - \hat{\theta}$.

   $$CI: [\hat{\theta} -w^*_{1-\alpha/2}, \hat{\theta} -w^*_{\alpha/2}] = [2 \hat{\theta} -\theta^*_{1-\alpha/2}, 2 \hat{\theta} -\theta^*_{\alpha/2}]$$

   Why is this preferred? Bias Correction!

---

## Bootstrap: Why do people like it?

- Econometricians like the bootstrap because under certain conditions it is **higher order efficient** for the confidence interval construction (but not the standard errors).
  - Intuition: because it is non-parametric it is able to deal with more than just the first term in the Taylor Expansion (actually an **Edgeworth Expansion**).
  - Higher-order asymptotic theory is best left for real econometricians!
- Practitioner's like the bootstrap because it is easy.
  - If you can estimate your model once in a reasonable amount of time, then you can construct confidence intervals for most parameters and model predictions.

---

## Bootstrap: When Does It Fail?

- Bootstrap isn't magic. If you are constructing standard errors for something that isn't asymptotically normal, don't expect it to work!
- The Bootstrap exploits the notion that your sample is IID (by sampling with replacement). If IID does not hold, the bootstrap may fail (but we can sometimes fix it!).
- Bootstrap depends on asymptotic theory. In small samples weird things can happen. We need $\hat{P}$ to be a good approximation to the true $P$ (nothing missing).

---

## Bootstrap: Variants

The bootstrap I have presented is sometimes known as the **nonparametric bootstrap** and is the most common one.

- **Parametric Bootstrap**: ex: if $Y_i = \beta_0 + \beta_1 X_i + \epsilon_i$ then we can estimate $(\hat{\beta}_0,\hat{\beta}_1)$ via OLS. Now we can generate a bootstrap sample by drawing an $x_i$ at random with replacement $\hat{\beta}_0 + \hat{\beta}_1$ and then drawing **independently** from the distribution of estimated residuals $\hat{\epsilon}_i$.

- **Wild Bootstrap**: Similar to parametric bootstrap but we rescale $\epsilon_i$ to allow for **heteroskedasticity**

- **Block Bootstrap**: For correlated data (e.g.: time series). Blocks can be overlapping or not.  

---

## Bootstrap vs Delta Method

- Delta Method works best when working out Jacobian $D(\theta)$ is easy and statistic is well approximated with a linear function (not too curvy).
- I would almost always advise Bootstrap unless:
  - Delta method is trivial e.g.: $\beta_1 / \beta_2$ in linear regression.
  - Computing model takes many days so that 10,000 repetitions would be impossible.
- Worst case scenario: rent time on Amazon EC2!
  - I "bought" over \$1,000 of standard errors recently.
- But neither is magic and both can fail!

---

## Subsampling

The bootstrap has a close cousin **subsampling**.

- In practice it looks similar, but the underlying theory is quite different.
- It relies on weaker assumptions and works even in some cases where the bootstrap fails.
- Again "fails" means that the 95% confidence interval has coverage that isn't very close to 95%.

---

## Subsampling: How does it work?

1. Draw a **smaller** sample $X^*=(X_1^*,\ldots,X_{a_n}^*)$ **without replacement** of size $a_n$ where as $n \rightarrow \infty$ we have $a_n \rightarrow \infty$ and $\frac{a_n}{n} \rightarrow 0$.
   - e.g. $a_n = \log n$ or $a_n = \sqrt{n}$. Note that $a_n / 10$ doesn't work.

2. Compute the relevant statistic $\theta(X^*)$ or $g(\theta(X^*))$.

3. Repeat this $B$ times and construct the CDF:

   $$L_n(t) = \frac{1}{B} \sum_{b=1}^B \mathbf{I} \left( \sqrt{a_n}(\widehat{\theta}_b - \widehat{\theta}_n  )  \leq t \right)$$

4. Calculate the quantiles of the CDF and CI:

   $$
   \begin{align*}
   \hat{t}_{\alpha / 2}&=L_{n}^{-1}(\alpha / 2), \quad \hat{t}_{1-\alpha / 2}=L_{n}^{-1}(1-\alpha / 2)\\
   C_{n}&=\left[\hat{\theta}_{n}-\frac{\hat{t}_{1-\alpha / 2}}{\sqrt{n}}, \hat{\theta}_{n}-\frac{\hat{t}_{\alpha / 2}}{\sqrt{n}}\right]
   \end{align*}
   $$

---

## Subsampling: Caveats

- The proof for **why** subsampling works is complicated. See [https://web.stanford.edu/~doubleh/lecturenotes/lecture13.pdf](https://web.stanford.edu/~doubleh/lecturenotes/lecture13.pdf).

- Downsides:
  - Subsampling really leans on $n \rightarrow \infty$ more than bootstrap. People often use bootstrap to understand finite sample performance (is this a good idea though?).
  - Choice of $a_n$ is difficult. Calculating the optimal value can be quite complicated and there aren't great rules of thumb.

- But if you're in a weird case where bootstrap fails (parameter on the boundary, etc.) try subsampling and see!

---

## Thanks!