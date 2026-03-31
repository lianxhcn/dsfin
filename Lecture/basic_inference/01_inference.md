# 统计推断

@gelman2007data

## 简介

>Source: @gelman2007data, Section 2.2 Statistical inference

Sampling and measurement error models
Statistical inference is used to learn from incomplete or imperfect data. There are two standard paradigms for inference:

- In the sampling model, we are interested in learning some characteristics of a population (for example, the mean and standard deviation of the heights of all women in the United States), which we must estimate from a sample, or subset, of that population.
- In the measurement error model, we are interested in learning aspects of some underlying pattern or law (for example, the parameters $a$ and $b$ in the model $y=a+b x)$, but the data are measured with error (most simply, $y=a+b x+\epsilon$, although one can also consider models with measurement error in $x$ ).

These two paradigms are different: the sampling model makes no reference to measurements, and the measurement model can apply even when complete data are observed. In practice, however, we often combine the two approaches when creating a statistical model.

For example, consider a regression model predicting students' grades from pretest scores and other background variables. There is typically a sampling aspect to such a study, which is performed on some set of students with the goal of generalizing to a larger population. The model also includes measurement error, at least implicitly, because a student's test score is only an imperfect measure of his or her abilities.

This book follows the usual approach of setting up regression models in the measurement-error framework ( $y=a+b x+\epsilon$ ), with the sampling interpretation implicit in that the errors $\epsilon_i, \ldots, \epsilon_n$ can be considered as a random sample from a distribution (for example, $\mathrm{N}\left(0, \sigma^2\right)$ ) that represents a hypothetical "superpopulation." We consider these issues in more detail in Chapter 21; at this point, we raise this issue only to clarify the connection between probability distributions (which are typically modeled as draws from an urn, or distribution, as described at the beginning of Section 2.1) and the measurement error models used in regression.