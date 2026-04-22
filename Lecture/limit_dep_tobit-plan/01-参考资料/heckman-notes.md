## 文献综述和实操指南

Bendig, D., & Hoke, J. (2022). Correcting Selection Bias in Innovation and Entrepreneurship Research: A Practical Guide to Applying the Heckman Two-Stage Estimation. SSRN Electronic Journal. [Link](https://doi.org/10.2139/ssrn.4105207), [-PDF-](https://download.ssrn.com/22/05/12/ssrn_id4105207_code5233967.pdf), [Google](<https://scholar.google.com/scholar?q=Correcting Selection Bias in Innovation and Entrepreneurship Research: A Practical Guide to Applying the Heckman Two-Stage Estimation>).

- 列示了管理学中使用该模型的几十篇论文的具体做法
- 绘制了一张流程图，呈现 Heckman 选择模型的实操步骤

## 公司金融中的应用及表述

- `Treat_Faccio_2016.pdf` 文中对此有详细的应用


## Heckman 使用不当的例子

Liang, Q., Ling, L., Tang, J., Zeng, H., & Zhuang, M. (2019). Managerial overconfidence, firm transparency, and stock price crash risk. China Finance Review International, 10(3), 271–296. [Link](https://doi.org/10.1108/CFRI-01-2019-0007), [PDF](http://sci-hub.ren/10.1108/CFRI-01-2019-0007), [Google](<https://scholar.google.com/scholar?q=Managerial overconfidence, firm transparency, and stock price crash risk>).

研究了 CEO 过度自信 ($X$) 对股价崩盘风险 ($Y$) 的影响。

内生性来源：作者认为股价崩盘风险高的公司更可能聘请过度自信的 CEO，因此，OLS 回归会存在自选择偏误。

- 应对方法 1：
  - `Logit X w` &rarr; 得到 IMR
  - `reg Y X IMR`
  - Note: **作者应该用错了**，此时不应该放入 IMR，而应该放入 Hazard ratio (HR)。

- 应对方法 2：
  - `Logit X w` &rarr; 得到 X_hat
  - `ivreg Y (X = X_hat)`
  - 文中没有说这个方法的依据是什么，感觉也有点奇怪

![20251203092321](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20251203092321.png)

![20251203092352](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20251203092352.png)