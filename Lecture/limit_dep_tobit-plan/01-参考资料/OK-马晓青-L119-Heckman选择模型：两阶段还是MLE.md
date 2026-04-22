# L119-Heckman选择模型：共线性问题、两阶段还是MLE

这个是实证分析里边非常重要的一个问题。这边推文的主要任务是推介下面这篇论文的核心结论。由于这篇论文发表的比较早是2000年，所以可以稍微追踪一下后续引用这篇文章的文章，看看他们怎么样表述这篇文章的观点，也简单的介绍一下，后续引用的这些文章大致做了哪些话题。




> Puhani, Patrick. 2000. “The Heckman Correction for Sample Selection and Its Critique.” Journal of Economic Surveys 14 (1): 53–68. [-Link-](https://academic.microsoft.com/paper/2031811990), [-PDF-](http://sci-hub.ren/10.1111/1467-6419.00104)

**Abstract.** This paper gives a short overview of Monte Carlo studies on the
usefulness of Heckman's (1976, 1979) two-step estimator for estimating selection
models. Such models occur frequently in empirical work, especially in
microeconometrics when estimating wage equations or consumer expenditures.
It is shown that exploratory work to check for collinearity problems is strongly
recommended before deciding on which estimator to apply. 

重点介绍如下两个结论：
- In the absence of collinearity problems, the full-information maximum likelihood estimator is preferable to the limited-information two-step method of Heckman, although the latter also gives reasonable results. 
- If, however, collinearity problems prevail, subsample OLS (or the Two-Part Model) is the most robust amongst the simpleto-calculate estimators.

## Stata 实操

找合适的例子演示上述模型的估计方法。看一看后续引用这篇文章的文献，有没有做蒙特卡罗模拟分析的同时也到 github 上去搜一下，他们有没有提供用来实现模拟分析的数据和代码。