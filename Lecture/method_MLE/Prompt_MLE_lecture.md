# MLE：最大似然估计 

导言……

参考视频：

- YouTube, 2025. [Maximum Likelihood Estimation ... MADE EASY!!!](https://www.youtube.com/watch?v=66FqSpf1trA)

## MLE简介

> Source: DataCamp, blog, 2025. [What is Maximum Likelihood Estimation (MLE)?](https://www.datacamp.com/tutorial/maximum-likelihood-estimation-mle)

Estimating parameters is a fundamental step in statistical analysis and machine learning. Among the various methods available, Maximum Likelihood Estimation (MLE) is one of the most widely used approaches due to its intuitive nature, mathematical rigor, and broad applicability across different types of data and models. 

In this article, you'll learn what MLE is, explore its mathematical foundations through detailed derivations and examples, and discover practical computational methods for implementing MLE effectively.

### What is Maximum Likelihood Estimation (MLE)?

Maximum likelihood estimation (MLE) is an important statistical method used to estimate the parameters of a probability distribution by maximizing the likelihood function.

![Flowchart showing observed data, statistical models, and parameter estimation methods including MLE](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20260415095426.png)

In terms of where MLE fits in [statistical inference](https://www.datacamp.com/tracks/statistical-inference-with-r), it is one of the most common methods we have to estimate parameters.

However, here you might have another question. What is a likelihood function? Let's discuss this further.

### What is the Likelihood Function?

We can think of the likelihood function as a way to measure how well a particular set of parameters explains the data you have observed.

In other words, it answers the question: "Given these parameter values, how likely is it that I would see this data?" But there is a common misconception here between Probability and Likelihood:

-   Probability is about predicting data from parameters
-   Likelihood measures how plausible different parameter values are, given the observed data. It's a function of parameters for fixed data. In contrast, probability is a function of data for fixed parameters.

Thus, to summarize, the likelihood function takes the parameters of your model as input and gives you a number that represents how plausible those parameters are, given your data.

The higher the value of the likelihood function, the better those parameters explain your data.

To put it even more simply, the likelihood function helps us "score" different parameter choices, so we can pick the ones that make our observed data most probable.

Now that we have understood the difference between Probability and Likelihood, as well as what MLE is used for, let's proceed to the underlying mathematics.

![Diagram showing that probability predicts data from parameters, while likelihood infers parameters from data.](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20260415095643.png)


### Likelihood VS probability and probability density (another one)

To begin, let's start with a fundamental question: what is the difference between likelihood and probability? The data $x$ are connected to the possible models $\theta$ by means of a probability $P(x, \theta)$ or a probability density function (pdf) $p(x, \theta)$.

In short, A pdf gives the probabilities of occurrence of different possible values. The pdf describes the infinitely small probability of any given value. We'll stick with the pdf notation here. For any given set of parameters $\theta, p(x, \theta)$ is intended to be the probability density function of x .

The likelihood $p(x, \theta)$ is defined as the joint density of the observed data as a function of model parameters. That means, for any given x , $p(x=$ fixed, $\theta)$ can be viewed as a function of $\theta$. Thus, the likelihood function is a function of the parameters $\theta$ only, with the data held as a fixed constant.



## 一个简单的例子

假设某城市的居民只有两种出行方式：步行 ($y_i=1$) 和 开车 ($y_i=0$)，二者发生的概率 $p_i$ 分别为 $\theta$ 和 $1-\theta$。随机询问五个人，结果为 $\{1,0,0,1,1\}$。如何采用 MLE 估计出 $\hat{\theta}$ 呢？

$$
\begin{array}{l|ccccc} %lllll
\hline y_{i} \quad&\quad 1      & \quad 0        & \quad 0        & \quad 1      & \quad 1 \quad \\
\hline p_{i} \quad&\quad \theta & \quad 1-\theta & \quad 1-\theta & \quad \theta & \quad \theta \quad \\
\hline
\end{array}
$$

我们可以根据 (@eq-prob-basic-02) 式定义似然函数如下： 

$$
L(\theta) = \prod_{i=1}^{5}p_i 
              = \theta \cdot(1-\theta) \cdot(1-\theta) \cdot \theta \cdot \theta = \theta^{3}(1-\theta)^{2}
$$ {#eq-MLE-eg-travel-01}

 接下来，只需要找出使 $L(\theta)$ 最大时的 $\theta$ 即可。为了便于求解，采用对数似然函数更为方便： 

$$\ln L(\theta)=3 \ln \theta+2 \ln (1-\theta)$$ {#eq-MLE-eg-travel-02}

 相应的一阶条件为： 

$$
\frac{d \ln L(\theta)}{d \theta}=\frac{3}{\theta}-\frac{2}{1-\theta}=0 \quad \Longrightarrow \quad \hat{\theta}=\frac{3}{5}
$$

 各位可能会哑然失笑，这里得到的 $\hat{\theta}=3/5$ 不就是 $y_i$ 的样本均值 $\bar{y} = 3/5$ 吗？确实如此，这在第 @sec-prob-basic-CPF01 小节末尾处已经提及过：当 $y$ 是 0/1 变量时，$\mathrm{E}\left(y_{i}\,|\,\mathbf{x}_{i}\right)=P\left(y_{i}=1\,|\,\mathbf{x}_{i}\right)$。那么，如何确认 $\hat{\theta}=3/5$ 是 $\ln L(\theta)$ 的极大值解呢？我们可以求取 $\ln L(\theta)$ 的二阶导数，看其是否小于零：${d\ln^{2}L(\theta)}/{d \theta^{2}}=-3 {\theta^{-2}}-2{(1-\theta)^{-2}}<0$。

![似然函数 $L(\theta)$ 与对数似然函数 $\mathrm{ln} L(\theta)$ 对比](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/B1_GLM_MLE_eg_01.png){#fig-B1_GLM_MLE_eg_01 width="100%"}


我们也可以采用数值方法求解参数 $\theta$。由图 @fig-B1_GLM_MLE_eg_01 可知，由于参数 $\theta \in (0,1)$，我们只需要在此范围内进行网格搜索，进而找出 $\mathrm{ln} L(\theta)$ 取最大值时对应的 $\theta$ 值即可。下面的代码演示了是实现过程：[^13]

```stata
  clear 
  set obs 10
  gen theta = .
  gen   lnL = .   // log(likelihood)
  gen     L = .   //     likelihood
  local i=1
  foreach theta of numlist 0.2 0.4 0.5 0.56 0.58 0.6 0.62 0.64 0.7 0.8{
      replace theta = `theta' in `i'
      replace   lnL = 3*ln(`theta') + 2*ln(1-`theta') in `i'
      replace     L = exp(lnL) in `i++'   
  } 
  
  qui sum lnL
  gen str1 max = "*" if lnL==r(max)   
  list, clean 
```

结果如下：

```stata
.   list, clean 

       theta      lnL        L   max  
  1.    0.20   -5.275   0.0051        
  2.    0.40   -3.771   0.0230        
  3.    0.50   -3.466   0.0313        
  4.    0.56   -3.381   0.0340        
  5.    0.58   -3.369   0.0344        
  6.    0.60   -3.365   0.0346     *  
  7.    0.62   -3.369   0.0344        
  8.    0.64   -3.382   0.0340        
  9.    0.70   -3.478   0.0309        
 1.     0.80   -3.888   0.0205        
```

从上述结果也可以看出，在进行数值求解过程中，以对数似然函数 $\mathrm{ln} L(\theta)$ 为目标函数相对更好一些。这是因为，似然函数 $L(\theta)$ 本质上是一系列概率密度或概率值的乘积，其取值通常都非常小，而 $\mathrm{ln} L(\theta)$ 的取值范围则宽泛的多。

#### 小结

此例虽简单，但呈现了 MLE 的基本思想：

第一步，设定随机变量 $y_i$ 的分布函数，本例中为「非此即彼」的伯努利分布；

第二步，写出样本中所有观察值的联合概率函数 $L(\theta)$ 以及对数似然函数 $\mathrm{ln}L(\theta)$；

第三步，极大化 $\mathrm{ln}L(\theta)$，从而得到参数 $\theta$ 的估计值。

作为扩展，可以对参数 $\theta$ 进行异质性设定，如 $\theta(x) = G(x'\beta)$。




## How to Derive the MLE Formula

Before we jump into specific examples, let's see how the maximum likelihood estimator (MLE) is derived in general. We will go through each step and also explain the reasoning behind it.

### Step 1: Define probability model

Let's suppose we have a dataset: x₁, x₂, ..., xₙ. We believe these data points are generated from a probability distribution that depends on some unknown parameter $\theta$. Our main goal is to estimate $\theta$. 

For example, if our dataset were about coin flips, $\theta$ could be the probability of heads. If the dataset were continuous, like the heights of students in the class, $\theta$ could be the mean of a normal distribution.

### Step 2: Writing the likelihood function

The likelihood function measures how likely it is to observe your data for different values of $\theta$. It is defined as:

$$
L(\theta)=P(\text { data } \mid \theta)=P\left(x_1, x_2, \ldots, x_n \mid \theta\right)
$$


Intuitively, we are asking, given that the parameter $\theta$ takes a specific value, what is the probability of observing this particular dataset?

This dataset is represented as the joint probability of observing the individual data points $\left(x_1, x_2, \ldots, x_n\right)$, assuming they were generated under the model parameterized by $\theta$.

Using the chain rule of probability, we can expand the above equation into this:

$$
L(\theta)=P\left(x_1, x_2, \ldots, x_n \mid \theta\right)=P\left(x_1 \mid \theta\right) \cdot P\left(x_2 \mid x_1, \theta\right) \cdots P\left(x_n \mid x_1, \ldots, x_{n-1}, \theta\right)
$$


However, this is quite a complicated equation! So we make the assumption that the data points are independent - more specifically, conditionally independent.

By doing so, we can get the joint probability to be the product of individual probabilities:

$$
L(\theta)=P\left(x_1 \mid \theta\right) \cdot P\left(x_2 \mid \theta\right) \cdots P\left(x_n \mid \theta\right)=\prod_{i=1}^n P\left(x_i \mid \theta\right)
$$


Since our observed data points are conditionally independent on $\theta$, we know the following equation is true:

$$
P\left(x_1 \mid x_2, \theta\right)=P\left(x_1 \mid \theta\right)
$$


This is because we have assumed that once we know the value of $\theta$, the data points $\mathrm{X}_1$ and $\mathrm{x}_2$ are conditionally independent.

Step 3: Find the value of $\boldsymbol{\theta}$ that maximizes likelihood
We are in the position where we have to find the values of $\theta$ which maximizes the likelihood function(i.e, it makes the observed data most likely):

$$
\hat{\theta}=\underset{\theta}{\arg \max } L(\theta)
$$


However, recall that our likelihood function contains a product. Working with products can get messy, especially with lots of data points. To simplify, we take the logarithm of the likelihood function since this converts the product into a summation.

$$
\log L(\theta)=\log \left(\prod_{i=1}^n P\left(x_i \mid \theta\right)\right)=\sum_{i=1}^n \log P\left(x_i \mid \theta\right)
$$


This gives us the log-likelihood, which has some beneficial properties:

- The log turns products into sums, which are much easier to work with, especially when differentiating.
- The log function is monotonic, so maximizing the log-likelihood gives the same $\theta$ as maximizing the likelihood.

![Graph showing the log(x) function](https://media.datacamp.com/cms/ad_4nxezy5c9hqzvlxcapbfdmrfrn8bvqllf5bbr3itoxzx8tyymcq0hkmlhy_eb12pzcnh-p-jx8n2bzl0mzrwuh1dmmuy3zns6er7dhuxm4vknohbiq3cxbkng7rdr6kwzg77a_9bm9w.png)

### Step 4: Finding the optimal value

We are now at a place where we can differentiate, however in machine learning, we tend to want our loss functions to be minimized. Luckily, this is quite an easy fix. 

By including a minus symbol (i.e., multiplying by -1) at the start of our function, we now need to minimize our loss function, which is now called the Negative Log-Likelihood Loss Function.

![Graph showing the -log(x) function](https://media.datacamp.com/cms/ad_4nxdcefxrqinbabsvcymr2hls9omf3zcirkny5h39nqm9jxjuaou9eg79cdsdjitqm9h0gjffavdx4datimovwg5vmy589ilb8ygwu-ufoorqvzprhdy0tworqknlaqtvx9p6rns6.png)

Now, we can use calculus to obtain the value of θ. By taking the derivative of the log-likelihood with respect to θ, setting it to zero, and solving for θ. This is because the minimum of a function occurs where its derivative is zero (and the second derivative is positive).

Therefore, the final equation for MLE is:

$$
\hat{\theta}=\arg \min _\theta\left[-\sum_{i=1}^n \log P\left(x_i \mid \theta\right)\right]
$$

::: {.callout-tip}
### Terminology alert!

In everyday conversation, "probability" and "likelihood" mean the same thing. However, in Stats-Land, "likelihood" specifically refers to this situation we've covered here; where you are trying to find the optimal value for the mean or standard deviation for a distribution given a bunch of observed measurements.
:::

## Heights example

'''Prompt：修改思路

这个例子的修改思路：这个例子中的数据太少，直方图不够明显了。可以预先生成 20 个观察值，假设它们来自一个均值为 170 的正态分布。然后，创建一个动画，展示当 $\mu$ 从 160 变化到 180 时，似然函数的形状如何变化。动画中可以突出显示当 $\mu$ 接近 170 时，似然函数达到最大值的情况。

按如下图形的思路优先展示整体思路：

![20260415113726](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20260415113726.png)

红色的密度函数图不需要五条，只需要三个就行，一个位于左侧（比如 $\mu=160$），一个位于中间（比如 $\mu=170$），一个位于右侧（比如 $\mu=180$，$\sigma^2$ 的取值也不合适，偏大）。图形展示的重点是：合适的参数刚好可以给「data」穿上最合适的外衣。

### Anther eaxample 

先确定 $\mu$：

![20260415114742](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20260415114742.png){width="90%"}

再确定 $\sigma^2$：

![20260415115053](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20260415115053.png){width="90%"}

![20260415115155](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20260415115155.png){width="90%"}

>Source: YouTube, 2018. [Maximum Likelihood, clearly explained!!!](https://www.youtube.com/watch?v=XepXtl9YKwc)

'''

Maximum Likelihood Estimation (MLE) is simply a common principled method with which we can derive good estimators, hence, picking θθ such that it fits the data.

To disentangle this concept, let's observe the formula in the most intuitive form:






Let's now look at a continuous example - estimating the mean of a normal (Gaussian) distribution.

Lets suppose we have a dataset of the heights of 5 people: $160,165,170,175,180$ (in cm). We will also assume these are drawn from a normal distribution with unknown mean $\mu(\mathrm{mu})$ and known variance $\sigma 2$ (let's say $\sigma 2=25$ for simplicity).
- Parameter ( $\mu$ ): The value you want to estimate (the average height)
- Data ( $\mathrm{x}_1, \mathrm{x}_2, \ldots, \mathrm{x}_5$ ): The observed heights

The likelihood function for the normal distribution (with known variance) is.

$$
L(\mu)=\prod\left[\left(\frac{1}{\sqrt{2 \pi \sigma^2}}\right) \times \exp \left(-\frac{\left(x_i-\mu\right)^2}{2 \sigma^2}\right)\right]
$$

This is very complicated but taking the negative log makes things easier. Hopefully, you can now see the power of using the log function in our equation. The equation we obtain is this:

$$
-\ln L(\mu)=\frac{1}{2 \sigma^2} \sum_{i=1}^n\left(x_i-\mu\right)^2+\frac{n}{2} \ln \left(2 \pi \sigma^2\right)
$$


We obtain two terms here, but note how the second term can be disregarded when we proceed with differentiation, since we are differentiating with respect to $\mu$, and the second term does not contain $\mu$.

$$
\begin{aligned}
\frac{\partial}{\partial \mu}[-\ln L(\mu)] & =\frac{\partial}{\partial \mu}\left[\frac{1}{2 \sigma^2} \sum_{i=1}^n\left(x_i-\mu\right)^2\right] \\
& =\frac{1}{2 \sigma^2} \sum_{i=1}^n 2\left(x_i-\mu\right) \cdot(-1) \\
& =-\frac{1}{\sigma^2} \sum_{i=1}^n\left(x_i-\mu\right)=0
\end{aligned}
$$


We are almost there, but take a look at $\mu$ in the brackets.

Since it is a constant, we can simply multiply it by $n$, since adding $\mu n$-times, will simply be $\mathrm{n}^* \mu$.

$$
\begin{aligned}
\sum_{i=1}^n x_i-n \mu & =0 \\
n \mu & =\sum_{i=1}^n x_i \\
\mu & =\frac{1}{n} \sum_{i=1}^n x_i
\end{aligned}
$$


The final answer we have obtained should make intuitive sense, since it is mathematically stated to sum all values of x and divide by n (which is the number of observations we have), and this is also the mean's definition!

Thus, by putting in our data values to this equation, we can obtain the mean to be 170 cm .

To make this more visual, here is an animation showing how the likelihood changes as we change $\mu$ :

{这个图形需要重新做，原图是从网上找的，版权不清楚，且质量不太好。自己作图时，可以预先生成 20 个观察值，假设它们来自一个均值为 170 的正态分布。然后，创建一个动画，展示当 $\mu$ 从 160 变化到 180 时，似然函数的形状如何变化。动画中可以突出显示当 $\mu$ 接近 170 时，似然函数达到最大值的情况。}

![Animation shows how changing the mean of a Gaussian Distribution influence the log likelihood. The log-likelihood is highest when the probability of observing that data is highest.](https://media.datacamp.com/cms/ad_4nxd6ol5pgmd5kdjyc6av1_txlrt7xxaiv5s8gac8grwlhi3wanmwysmkwfpewpejrhdbre7jpksshhjv7hpfbq2qphsu_a52fdlxz0aqt_giuq4brzcawoajn6zau05bwmd4k4ux2q.gif)



In both examples, using MLE gave us the parameter value that made our observed data most probable under the chosen model. Obviously, MLE can work with giving us multiple parameter values as well, although the calculation would be slightly longer!

### Coding MLE


Now that we have understood the underlying structure of MLE, let's see how to code this in Python. We will be coding the previous example (heights) solution. 

```python
# Importing libraries
import numpy as np # used for handling arrays and mathematical operations.
from scipy.optimize import minimize # function that minimizes another function

# This is our sample data
data = np.array([160, 165, 170, 175, 180])

# This was the variance we had assumed before
sigma_squared = 25

# Negative Log-Likelihood function
def negative_log_likelihood(mu):
    n = len(data) # Number of data points
    return 0.5 * n * np.log(2 * np.pi * sigma_squared) +\
           np.sum((data - mu)**2) / (2 * sigma_squared) # The NLL is for the Univariate Gaussian Distribution

# Optimizing the NLL
result = minimize(negative_log_likelihood, x0=170)  # initial guess

# Our final estimated mean
estimated_mu = result.x[0]
print(f"MLE estimate of mu: {estimated_mu}")`

```

## 常见问题

- 极大化似然函数时，为什么要使用对数似然函数？
  - 因为似然函数通常是一个乘积，尤其是在处理大量数据时，乘积的值可能非常小，导致数值不稳定。对数函数将乘积转换为求和，使得计算更稳定且更容易进行微分。

- MLE 是否总是存在？
  - 不一定。MLE 的存在取决于数据和模型的特性。在某些情况下，似然函数可能没有最大值，或者最大值可能在参数空间的边界上。

- MLE 是否总是唯一？
  - 不一定。某些模型可能存在多个参数值使得似然函数达到相同的最大值，这种情况称为多重极大值。

- 迭代次数和收敛判据
  - 在使用数值优化方法求解 MLE 时，迭代次数和收敛判据的选择会影响结果的准确性和计算效率。过多的迭代可能导致过拟合，而过少的迭代可能导致未找到全局最大值。

- 离群值
  - 离群值可能会对 MLE 产生显著影响，因为它们可能会极大地改变似然函数的形状，从而导致参数估计不准确。

- 变量很多且包含大量虚拟变量的情形
  - 当模型中包含大量变量，尤其是虚拟变量时，MLE 可能会面临维度灾难问题，导致计算复杂度增加，收敛速度变慢，甚至可能无法收敛。

- ……

## Properties of MLE


From our examples and calculations, it is clear that MLE is useful. Formally speaking, MLE has the following properties: 

1.  Consistency: As the sample size increases, the MLE converges to the true value of the parameter.
2.  Asymptotic Normality: For large samples, the distribution of the MLE becomes approximately normal (bell-shaped) around the true parameter value. This is the basis for constructing confidence intervals.
3.  Efficiency: Among all unbiased estimators, the MLE achieves the lowest possible variance (it reaches the Cramér-Rao lower bound, at least asymptotically).
4.  Invariance: If θ̂ is the MLE for θ, then for any function g, g(θ̂) is the MLE for g(θ). In other words, MLEs are preserved under transformations.

However, there are scenarios where using MLE might not be the best option:

1.  Small samples: MLE can be biased when the sample size is small. For example, the MLE for variance (σ̂²) tends to underestimate the true variance (σ²).
2.  Robustness: MLE is sensitive to outliers and model misspecification. Alternatives like M-estimators can provide more robust estimates.
3.  Bayesian alternative: Maximum a posteriori (MAP) estimation combines prior information with the likelihood, offering a Bayesian perspective and sometimes more stable estimates, especially with limited data.

## Applications Across Statistical Modeling

In this section, let's explore where MLE is actually used in Machine Learning and AI.

### Regression and classification

One of the most important places MLE appears is in [logistic regression](https://www.datacamp.com/tutorial/understanding-logistic-regression-python). Here, we are estimating the probability that an outcome belongs to a certain class (such as customer churn) and we do this by fitting parameters to maximize the likelihood of the observed outcomes.

Even in [linear regression](https://www.datacamp.com/tutorial/simple-linear-regression), if we assume normally distributed errors, then the least squares solution actually turns out to be the MLE too. 

### Hypothesis testing and model selection

MLE can also be used to compare models. 

For example, the likelihood ratio test (LRT) helps us check if adding extra variables to a model significantly improves its performance. It works by comparing the likelihoods of two models: one simpler (null), one more complex (alternative).

We also have the Akaike Information Criterion (AIC), which penalizes complexity to avoid overfitting. These tools are widely used in fields like finance, medicine, and marketing.

If you're interested in further exploring ways to measure differences between probability distributions beyond likelihood alone, check out my tutorial: [KL-Divergence Explained](https://www.datacamp.com/tutorial/kl-divergence).

## Limitations and Alternatives to MLE

Although it is powerful, it does have its drawbacks. Let's quickly go over where it struggles, and what we can use instead.

### Key limitations of MLE

-   Sensitive to model misspecification: If our model is wrong (e.g., using a normal distribution for skewed data), MLE will give us misleading results.
-   Outlier sensitivity: A few bad data points can completely throw off your estimates.
-   Computational cost: For large models, especially with many parameters or constraints, optimizing the likelihood can be slow or unstable.
-   Multiple solutions: Sometimes the likelihood surface has several peaks (local maxima), which makes finding the best solution tricky.

### Alternatives to maximum likelihood estimation

When MLE doesn't work well, here are some options:

-   MAP (Maximum a Posteriori): Like MLE, but adds a prior belief. This can help stabilize estimates when data is limited.
-   Method of Moments: Matches sample moments (like the mean or variance) with theoretical ones. It's less precise than MLE but very easy to compute.
-   Least Squares: In cases like linear regression with Gaussian errors, least squares and MLE are the same. But least squares can still be useful when MLE is too complex.

Different methods work better in different situations. MLE might not always be the answer, but it's often a great starting point.

## Conclusion

Maximum Likelihood Estimation is one of the most natural and widely used methods for parameter estimation. It is the idea of making the observed data as probable as possible, and thus can be used in many different scenarios, such as coin flips, Gaussian heights, etc. 

MLE can adapt across models and scale with data, offering both mathematical elegance and practical power. Although it does have its own drawbacks, especially in small or messy datasets, it remains a foundational tool when learning Machine Learning and AI. 

If you're on your machine learning journey, be sure to check out our [Machine Learning Scientist in Python career track](https://www.datacamp.com/tracks/machine-learning-scientist-with-python), which explores supervised, unsupervised, and deep learning. 

Ready to deepen your understanding of Maximum Likelihood Estimation with practical exercises? These resources can help you apply your knowledge and gain hands-on experience:

-   [Maximizing Likelihood, Part 1 (Python)](https://campus.datacamp.com/courses/introduction-to-linear-modeling-in-python/estimating-model-parameters?ex=7): Compute and visualize log-likelihoods to clearly see how parameter estimates are determined in practice.
-   [OLS Regression: The Key Ideas Explained](https://www.datacamp.com/tutorial/ols-regression): Explore the connection between Ordinary Least Squares regression and MLE when assuming Gaussian errors, reinforcing core statistical concepts.
-   [Understanding Logistic Regression in Python](https://www.datacamp.com/tutorial/understanding-logistic-regression-python): Delve into how logistic regression leverages MLE for effective classification and parameter estimation.

## Python Packages

- `pymle`: 
  - Kirkby, J. L., Nguyen, D. H., Nguyen, D., & Nguyen, N. (2025). pymle: A Python Package for Maximum Likelihood Estimation and Simulation of Stochastic Differential Equations. Journal of Statistical Software, 113(4). [Link](https://doi.org/10.18637/jss.v113.i04) (rep), [PDF](https://www.jstatsoft.org/index.php/jss/article/view/v113i04/4721), [Google](<https://scholar.google.com/scholar?q=pymle: A Python Package for Maximum Likelihood Estimation and Simulation of Stochastic Differential Equations>). [Replication](https://www.jstatsoft.org/index.php/jss/article/view/v113i04/4723).
  - 主要应用于金融领域的随机微分方程（SDE）建模和参数估计，但也适用于其他领域的连续时间动态系统建模。
  - 提供了多种预定义的SDE模型，用户也可以自定义



## 参考资料

- Medium, Blog. 2024. [Maximum Likelihood Estimation — Parameter Estimation Technique — Machine Learning with Python Code](https://medium.com/@amannagrawall002/maximum-likelihood-estimation-parameter-estimation-technique-machine-learning-f7acb3b6ca89)