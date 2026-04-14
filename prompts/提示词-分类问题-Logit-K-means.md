# 分类模型 (Classification Models)

## 简介

前文介绍的线性回归模型主要适用于定量响应变量 $Y$ 的情况，但在许多实际问题中，响应变量是定性的。例如，企业在下一个年度是否会违约 (0/1)；是否发行债券 (0/1)；企业的债券评级如何变化 (-1, 0, 1)，

在本章中，我们将研究预测定性响应的方法，这个过程被称为分类。对于一个观测值预测一个定性响应可以被称为对该观测值进行分类，因为它涉及将观测值分配到一个类别或类中。另一方面，通常用于分类的方法首先预测观测值属于每个类别的概率，作为进行分类的基础。从这个意义上说，它们也表现得像回归方法。



The linear regression model discussed in Chapter 3 assumes that the response variable $Y$ is quantitative. But in many situations, the response variable is instead qualitative. For example, eye color is qualitative. Often qualitative variables are referred to as categorical; we will use these terms interchangeably. In this chapter, we study approaches for predicting qualitative responses, a process that is known as classification. Predicting a qualitative response for an observation can be referred to as classifying that observation, since it involves assigning the observation to a category, or class. On the other hand, often the methods used for classification first predict the probability that the observation belongs to each of the categories of a qualitative variable, as the basis for making the classification. In this sense they also behave like regression methods.

There are many possible classification techniques, or classifiers, that one might use to predict a qualitative response. We touched on some of these in Sections 2.1.5 and 2.2.3. In this chapter we discuss some widely-used classifiers: logistic regression, linear discriminant analysis, quadratic discriminant analysis, naive Bayes, and $K$-nearest neighbors. The discussion of logistic regression is used as a jumping-off point for a discussion of generalized linear models, and in particular, Poisson regression. We discuss more computer-intensive classification methods in later chapters: these include generalized additive models (Chapter 7); trees, random forests, and boosting (Chapter 8); and support vector machines (Chapter 9).


## 分类问题概述 (An Overview of Classification)

经济和金融中的常见分类问题包括：

- 信用评分：根据客户的财务历史和行为数据，预测他们是否会违约。
- 客户细分：根据客户的购买行为和偏好，将他们分成不同的群体，以便进行有针对性的营销。
- 欺诈检测：识别异常交易或行为，以防止欺诈活动。
- 金融监管：根据公司的财务数据和行为，预测他们是否会违反监管规定。
- 投资组合管理：根据资产的特征和历史表现，将它们分类为不同的风险类别，以便进行投资决策。

多数情况下，线性回归模型并不适用于这些分类问题，因为它可能会预测出不合理的概率值（例如，负数或大于1的值）。因此，我们需要使用专门的分类方法来处理这些问题。

- Y 的取值和编号问题：对于二分类问题，通常将类别编码为 0 和 1，这样可以直接解释为概率。对于多分类问题，可以使用独热编码 (one-hot encoding) 或其他编码方式来表示类别。