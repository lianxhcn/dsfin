我来用 str_replace 方式列出所有修改，你在本地执行后另存为 v3 即可。

---

## 修改清单（共 9 处）

---

### 修改 1：Part 0 开头增加全局约束

**定位**：找到 `### 0.1 本章在课程中的定位` 之前，在 `---` 之后插入：

```markdown
### 0.0 全局执行约束（agent 必读）

在开始任何写作之前，请先阅读并严格遵守以下约束：

**优先级标签说明**：本任务书所有要求均标注优先级：
- 🔴 **必须**：核心内容，不可省略
- 🟡 **建议**：有教学价值，酌情完成
- 🟢 **可选**：扩展内容，时间/篇幅不足时可跳过

**篇幅上限**：
- `GMM_lec.qmd` 正文控制在 **10000-13000 字**（不含代码块和 callout 内部文字）
- 主讲义引用图形**不超过 6 张**
- 每节只有一个主线问题，其他内容服务于主线，不独立成新的分支
- 不在多个小节反复重述同一句总纲式表述

**技术表述准确性护栏**（agent 须主动避免以下过度简化）：

1. 不要把「2SLS 等权处理所有工具变量」说得过实。准确说法：2SLS 对应 GMM 的一个特定权重矩阵 $W=(Z^\top Z/n)^{-1}$，不是字面意义上的「简单平均」。
2. 不要把「GMM 给更可信的矩条件更大权重」说成「GMM 能识别哪个工具变量更外生」。准确说法：权重矩阵给方差更小、协方差结构更稳定的矩条件更高权重，但它**不能替你识别无效工具变量**。
3. 不要写「Euler 方程这类场景连 MLE 都无能为力」。准确说法：在无法或不愿完整指定联合分布时，MLE 并不自然或难以实施，GMM 更有优势。
4. 不要写「异方差下 2SLS 的标准误一定有问题」。准确区分：**非稳健** 2SLS 标准误在异方差下有问题；使用 `robust` 选项的 2SLS 推断仍然成立。GMM 的优势主要在有效性（效率）和统一框架，而不只是「纠正标准误」。

**行文风格约束**：
- 先直觉，后公式，再解释公式在做什么
- 正文像教材，不像备课笔记；避免「教师说明书」口吻
- 减少以下词汇的使用密度：「核心洞察」「精髓」「根本优势」「本章最关键」「独特价值」——偶尔用一次可以，反复出现会显得用力过猛
- 第 4 节（2SLS vs. GMM 差异）重点是**权重机制的差异**（思路层面）；第 5 节（OLS/IV/2SLS 是特例）重点是**统一框架表**（结构层面）。两节不得重复彼此的核心内容。
```

---

### 修改 2：导言开篇情境替换

**定位**：找到并替换从 `**A. 开篇情境**（不以定义开头）` 到 `紧接着，提出 GMM 的核心洞察：你不需要知道完整的分布……` 的全段：

```markdown
**A. 开篇情境**（不以定义开头）🔴

先从一个所有学过线性回归的读者都熟悉的场景出发。OLS 之所以能一致地估计 $\beta$，依赖一个核心假设：解释变量与误差项不相关，即 $E(x_i \varepsilon_i) = 0$。当 $x_i$ 是内生变量、这个假设不再成立时，我们需要寻找工具变量 $z_i$，并依赖新的正交条件 $E(z_i \varepsilon_i) = 0$ 来识别参数。

这两个表达式——$E(x_i \varepsilon_i) = 0$ 和 $E(z_i \varepsilon_i) = 0$——有一个共同的名字：**矩条件**（moment conditions）。它们都在说同一件事：如果模型设定正确、参数取真值，那么某个函数的期望值应当等于零。换句话说，你在学 OLS 和 IV 的时候，其实已经在用矩条件了，只是当时没有用这个名字。

当矩条件数量恰好等于参数数量时（**恰好识别**），可以直接令样本矩条件等于零求解，这是普通矩估计（Method of Moments, MM）。当矩条件数量多于参数数量时（**过度识别**），没有参数能让所有矩条件同时精确为零，只能找到「最接近满足全部矩条件」的解——这就是 GMM 要做的事。GMM 进一步通过权重矩阵 $W$ 给「更稳定的矩条件」更大的权重，这是它优于 2SLS 的核心所在。

还有一个值得预告的洞察：OLS、IV、2SLS 其实都是 GMM 在特定矩条件和特定权重矩阵下的特例。理解了 GMM，就理解了这些方法共同的骨架。在后续应用场景一节中，我们还会看到 GMM 如何处理更复杂的非线性约束——比如消费-资产定价的 Euler 方程，这类场景在无法指定完整分布时 MLE 并不自然，而 GMM 更有优势。
```

**同时**，删除导言中原有的 Euler 方程 callout 块（从 `'''` 到 `'''` 的整段内容）。

---

### 修改 3：补充矩条件符号约定

**定位**：在 `### 0.3 数学深度原则（选项 B）` 末尾追加：

```markdown
**矩条件的符号约定**：

- **导言和直觉性叙述**：使用标量形式 $E(x_i \varepsilon_i) = 0$，不加粗，不加转置，下标 $i$ 强调「对每个观测成立」，便于与 $E(z_i \varepsilon_i) = 0$ 并排对比。
- **第 2 节起引入向量形式**：$E(\mathbf{x}_i \varepsilon_i) = \mathbf{0}$，其中 $\mathbf{x}_i$ 是 $k \times 1$ 列向量。引入时须加文字：「这里 $\mathbf{x}_i$ 包含所有解释变量，这一个向量方程等价于 $k$ 个标量方程」。
- **矩阵形式** $E(\mathbf{X}'\boldsymbol{\varepsilon}) = \mathbf{0}$ 只在推导部分出现，不用于直觉性叙述。

全章保持这三个层次的一致性，不在同一段落内混用不同层次的符号。
```

---

### 修改 4：各节增加优先级标签

**定位**：在每节的 `**写作目标**` 前，按以下对应关系添加标签：

| 节                             | 标签             |
| ------------------------------ | ---------------- |
| 第 1 节：为什么需要 GMM？      | 🔴 必须           |
| 第 2 节：矩条件                | 🔴 必须           |
| 第 3 节：从矩条件到 GMM 估计量 | 🔴 必须           |
| 第 4 节：2SLS 与 GMM           | 🔴 必须           |
| 第 5 节：OLS/IV/2SLS 特例      | 🔴 必须           |
| 第 6 节：最优权重矩阵          | 🔴 必须           |
| 第 7 节：Sargan/Hansen/Wald    | 🔴 必须           |
| 第 8 节：应用场景 整体         | —                |
| 第 8.1 节                      | 🔴 必须           |
| 第 8.2 节（Euler 方程）        | 🟡 建议           |
| 第 8.3 节（多方程）            | 🟢 可选           |
| 第 8.4 节（Erickson-Whited）   | 🟡 建议（压缩版） |
| 第 9 节：常见问题              | 🔴 必须           |
| 第 10 节：小结                 | 🔴 必须           |

格式示例（在对应节的写作目标前插入一行）：

```markdown
> 🔴 **必须完成**
```

---

### 修改 5：Euler 方程例子移入第 8.2 节

**定位**：找到 `**B. 8.2 Euler 方程：非线性 GMM**`，在现有内容开头插入：

```markdown
在进入这一节之前，先描述一个金融研究者可能面临的真实困境：

> 你在研究投资者的跨期消费决策是否符合理性预期。理论模型告诉你，均衡时效用函数的一阶条件必须成立——这是一个关于消费增长率和资产收益率的非线性方程。你想用数据估计效用函数的参数（贴现因子 $\beta$ 和风险厌恶系数 $\gamma$），但你不知道消费增长率服从什么分布，更不知道它与收益率的联合分布。在无法指定完整联合分布时，MLE 并不自然——你做不到。怎么办？

答案是：你不需要知道完整的分布，只需要知道一件事——如果模型成立，Euler 方程的期望值应当等于零。这就是一个矩条件，GMM 的工作就是找到使样本数据最符合这个理论预期的参数。

```

---

### 修改 6：第 8.4 节 Erickson-Whited 替换为压缩版

**定位**：找到 `**D. 8.4 高阶矩与测量误差：Erickson-Whited 方法**`，将整节内容替换为：

```markdown
**D. 8.4 高阶矩与测量误差：Erickson-Whited 方法** 🟡

> 本节为压缩版介绍，重点是适用场景与软件命令，不展开方法推导。有兴趣深入的读者可参考末尾文献。

**适用场景**：当研究者面临「有内生性或测量误差，但找不到合适外部工具变量」的困境时。典型场景是企业投资-Q 关系研究中，Tobin's Q 作为投资机会的代理变量存在严重的经典测量误差（classical measurement error），而外部工具变量难以找到。

**核心思路**（只讲思想，不给推导）：若真实变量 $x^*$ 存在经典测量误差 $x = x^* + \nu$（$\nu$ 与 $x^*$ 独立），则 $x^*$ 的**高阶矩**（三阶矩、四阶矩）与误差项之间存在天然的正交性条件。这些正交性可以构造额外的矩条件，从而在**不需要外部工具变量**的情况下识别参数。关键假设：测量误差 $\nu$ 与真实变量 $x^*$ 相互独立（经典测量误差假设）。

**局限性**（1-2 句）：高阶矩对非正态性和厚尾分布较敏感；矩阶数越高，有限样本偏误越大。建议作为稳健性检验而非主要估计方法。

**软件命令**：

*Stata*：`ewreg` 命令（Erickson-Whited regression），可从 SSC 安装：

```stata
ssc install ewreg
ewreg y x_mismeasured controls, order(3)   // order() 指定矩条件阶数
```

*Python*：目前无成熟现成包。可借助 `scipy.optimize.minimize` 手动构造高阶矩条件求解 GMM 目标函数；亦可参考 Erickson et al. (2014, JE) 附录代码。

**参考文献**（用 `.callout-note` 呈现）：

```
::: {.callout-note}
### 参考文献
- Erickson, T., & Whited, T. M. (2000). Measurement error and the relationship between investment and q. *Journal of Political Economy*, 108(5), 1027–1057.
- Erickson, T., Jiang, C. H., & Whited, T. M. (2014). Minimum distance estimation of the errors-in-variables model using linear cumulant equations. *Journal of Econometrics*, 183(2), 211–221.
- Whited, T. M. (2001). Is it inefficient investment that causes the diversification discount? *Journal of Finance*, 56(5), 1667–1691.（应用示例）
:::
```
```

---

### 修改 7：第 7 节删除 fig06，替换为文字说明 + 文献

**定位**：找到图形规格中 `#### 图 06：method_GMM_fig06_sargan_hansen.png` 的整节，替换为：

```markdown
#### ~~图 06~~：已删除

> `fig06`（Sargan vs. Hansen 的 Monte Carlo 尺寸对比图）已从必须图形中移除。
> 相关内容在 `GMM_lec.qmd` 第 7 节通过**对照表 + 经验法则 + 文献引用**的方式处理，无需 MC 模拟图支撑。
```

**同时**，在 `1.10 第 7 节` 的 Sargan vs. Hansen 对照表之后，追加以下内容：

```markdown
**C. 经验法则与文献依据**

关于如何在实践中选用检验统计量，以下几条经验法则有文献依据：

- 凡使用异方差稳健标准误（`robust`），**必须配套 Hansen J**，Sargan 统计量在此场景下失去意义（Baum, Schaffer & Stillman, 2003）。
- 矩条件数量过多时，Hansen J 检验力会显著下降，即使某些矩条件不成立也难以拒绝。Roodman (2009) 给出的经验规则是：工具变量数量不应超过截面个体数（动态面板场景）。
- Difference-in-Sargan（C 检验）可用于检验**额外矩条件子集**的有效性，其统计量 $D = J_{\text{限制}} - J_{\text{非限制}} \sim \chi^2(r)$。
- 若 Sargan 和 Hansen J 给出截然相反的结论，通常意味着误差项存在异方差，应以 Hansen J 为准（Baum et al., 2003）。

**参考文献**（用 `.callout-note` 呈现）：

```
::: {.callout-note}
### 参考文献：Sargan/Hansen 检验的实践指南
- Baum, C. F., Schaffer, M. E., & Stillman, S. (2003). Instrumental variables and GMM: Estimation and testing. *Stata Journal*, 3(1), 1–31.
- Roodman, D. (2009). A note on the theme of too many instruments. *Oxford Bulletin of Economics and Statistics*, 71(1), 135–158.
- Hayashi, F. (2000). *Econometrics*. Princeton University Press. Ch. 3.（Hansen J 的理论推导）
:::
```
```

---

### 修改 8：Case 2a 代码步骤细化

**定位**：找到 `### 3.4 Case 2a：Euler 方程 GMM——模拟数据版` 下的「代码步骤」部分，替换为：

```markdown
**代码步骤**（🔴 必须，代码规格如下）：

**Step 1**：读入数据，绘制消费增长率 `dc` 和资产收益率 `R` 的时序图，计算基本统计量。

**Step 2**：构造矩条件函数。矩条件为 $g_t(\theta) = [\beta (c_{t+1}/c_t)^{-\gamma} R_{t+1} - 1] \cdot z_t$，其中工具变量向量 $z_t = (1, \Delta c_{t-1}/c_{t-1}, R_{t-1}, \Delta c_{t-2}/c_{t-2}, R_{t-2})$（5 个工具变量，生成 5 个矩条件，参数 2 个，过度识别度 = 3）。

函数签名要求：
```python
def moment_conditions(params, dc, R, instruments):
    """
    params: [beta, gamma]
    dc: 消费增长率数组，形状 (T,)
    R:  资产收益率数组，形状 (T,)
    instruments: 工具变量矩阵，形状 (T, q)，q=5
    返回: g_bar，形状 (q,)，即样本矩条件均值向量
    """
    beta, gamma = params
    residual = beta * dc**(-gamma) * R - 1        # 形状 (T,)
    g = instruments * residual[:, np.newaxis]      # 形状 (T, q)
    return g.mean(axis=0)                          # 形状 (q,)
```

**Step 3**：两步 GMM 实现。

```python
# 第一步：W = I，最小化 g_bar' g_bar
def gmm_objective_step1(params, dc, R, instruments):
    g = moment_conditions(params, dc, R, instruments)
    return g @ g

result1 = minimize(gmm_objective_step1, x0=[0.95, 1.5],
                   args=(dc, R, instruments),
                   method='Nelder-Mead',
                   options={'maxiter': 10000, 'xatol': 1e-8, 'fatol': 1e-10})
theta1 = result1.x

# 估计 S_hat（异方差稳健）
def compute_S_hat(params, dc, R, instruments):
    beta, gamma = params
    residual = beta * dc**(-gamma) * R - 1
    g_each = instruments * residual[:, np.newaxis]   # 形状 (T, q)
    g_each_demeaned = g_each - g_each.mean(axis=0)
    return g_each_demeaned.T @ g_each_demeaned / len(dc)

S_hat = compute_S_hat(theta1, dc, R, instruments)
W2 = np.linalg.inv(S_hat)

# 第二步：W = S_hat^{-1}，最小化 g_bar' W g_bar
def gmm_objective_step2(params, dc, R, instruments, W):
    g = moment_conditions(params, dc, R, instruments)
    return g @ W @ g

result2 = minimize(gmm_objective_step2, x0=theta1,
                   args=(dc, R, instruments, W2),
                   method='Nelder-Mead',
                   options={'maxiter': 10000, 'xatol': 1e-8, 'fatol': 1e-10})
theta2 = result2.x
```

**Step 4**：计算 Hansen J 统计量并做 $\chi^2(q-k) = \chi^2(3)$ 检验。

```python
T = len(dc)
g_hat = moment_conditions(theta2, dc, R, instruments)
J_stat = T * g_hat @ W2 @ g_hat
J_pval = 1 - stats.chi2.cdf(J_stat, df=5-2)
print(f'Hansen J = {J_stat:.4f}, p-value = {J_pval:.4f}')
```

**Step 5**：展示参数估计结果 vs. 真实值（$\beta=0.98$，$\gamma=2.0$）。

**Step 6**（🟡 建议）：绘制目标函数在参数空间的热力图——固定 $\beta=0.98$，展示 $Q(\beta_0, \gamma)$ 关于 $\gamma$ 的轮廓曲线；再固定 $\gamma=2.0$，展示关于 $\beta$ 的轮廓曲线。说明参数识别情况。
```

---

### 修改 9：Case 3 标记为可选，质量检查清单分层

**定位 1**：在 `### 3.6 Case 3` 标题下方插入：

```markdown
> 🟢 **可选模块**：本 Case 教学价值较高，但实现成本也较高，在时间或篇幅不足时可降级为「讲义中文字描述 + 指向参考文献」，不强求完整代码实现。
```

**定位 2**：找到 `## Part 4：质量检查清单`，在其开头插入：

```markdown
> 检查项分为两层：**🔴 硬性项**（必须满足，否则视为执行不合格）和 **🟡 加分项**（有则更好，时间不足时可跳过）。
```

然后在 `### 4.1 GMM_lec.qmd 检查项` 中，将以下项目标注为 🟡：

- `[ ] 全章包含不少于 5 个「提示词」callout`  →  改为 `[ ] 🟡 全章包含不少于 3 个「提示词」callout（建议 5 个）`
- `[ ] 第 8.3 节包含 Fama-MacBeth vs. GMM 的对比`  →  改为 `[ ] 🟢 第 8.3 节（可选）包含 Fama-MacBeth vs. GMM 的对比`
- `[ ] 第 8.4 节包含 Erickson-Whited 方法的简介和 Stata/Python 命令`  →  改为 `[ ] 🟡 第 8.4 节包含 Erickson-Whited 的压缩版介绍、软件命令和文献`

在 `### 4.3 GMM_case.ipynb 检查项` 中：
- `[ ] Case 2a 包含参数空间热力图（目标函数轮廓）`  →  改为 `[ ] 🟡 Case 2a 包含参数空间热力图（目标函数轮廓）`
- `[ ] Case 3 包含 Fama-MacBeth vs. GMM 的对比`  →  改为 `[ ] 🟢 Case 3（可选）包含 Fama-MacBeth vs. GMM 的对比`

---

## 执行说明

以上 9 处修改在本地按顺序执行后另存为 `Task-guide-GMM-v3.md` 即可。如果你希望我验证某处修改的上下文定位是否准确，可以把原文对应段落贴出来，我来确认替换字符串。