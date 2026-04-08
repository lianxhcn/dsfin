

# 第2章 统计推断的基本逻辑：从样本到总体

> *管中窥豹，可见一斑；一叶知秋，可知全局。*
> *——统计学的本质，正是基于有限信息推断一般性规律的科学。*

---

## 2.1 引言：我们为什么需要统计推断？

### 2.1.1 一个金融分析师的日常困境

假设你是一位分析师，需要回答以下问题：

- 某只股票未来一年的预期收益率是多少？
- 某家公司发行的债券违约概率有多大？
- 一项新的监管政策是否真的降低了市场操纵行为？

这些问题有一个共同特征：**我们永远无法观测到全部的信息**。我们无法穿越到未来观察所有可能的收益率；无法观察所有企业在所有经济环境下的违约情况；也无法同时观察一个市场在"实施政策"和"未实施政策"两种状态下的表现。

我们能做的，只是收集**有限的数据**——历史收益率、已有的违约记录、政策实施前后的市场数据——然后试图从这些有限的信息中，推断出一般性的结论或规律。

这，就是**统计推断**（Statistical Inference）的本质。

### 2.1.2 从经验直觉到科学推断

事实上，"基于有限信息做推断"并非统计学的专利，而是人类认知世界的基本方式。中国古人早就有类似的智慧：

- **管中窥豹，可见一斑**：通过管子看到豹身上的一个斑点，就能推测这是一只豹子。
- **一叶知秋**：看到一片叶子落下，就知道秋天将至。

这些成语蕴含的逻辑与统计推断高度一致：我们观察到的是**局部**（一个斑点、一片落叶），但我们希望推断的是**整体**（这是一只豹、秋天来了）。统计学所做的，不过是将这种直觉推断**系统化、形式化、精确化**。

但古人的智慧也暗含着一个危险。"管中窥豹"之所以能成功，是因为"斑点"是豹子的**典型特征**——如果你恰好看到的是豹子腹部的白色皮毛呢？你可能会误以为这是一只白色的动物。同样，"一叶知秋"能成功，依赖于你看到的那片落叶确实是因为季节变化而非虫蛀或疾病而落下。

换言之，**你的推断能否成功，关键取决于你观察到的"局部"是否能够代表"整体"**。这正是统计学的核心关切之一——**样本的代表性**。

### 2.1.3 本章的目标与结构

本章旨在帮助你建立**基于抽样的统计推断思维框架**，为后续学习金融数据分析和建模奠定基础。我们将依次讨论以下内容：

- **总体、样本与抽样**（第2.2节）：什么是总体？什么是样本？抽样过程如何影响我们的推断？
- **分布：统计学的核心语言**（第2.3节）：为什么我们需要"分布"这个概念？它在不同情境下扮演着怎样的角色？
- **描述分布的统计量**（第2.4节）：如何用几个关键数字刻画一个分布的主要特征？
- **从理论分布到参数族**（第2.5节）：为什么我们可以用少数几个参数来描述一个分布？常见的参数分布有哪些？
- **样本选择偏差与抽样设计**（第2.6节）：当样本不具有代表性时，会产生怎样的后果？我们如何应对？
- **统计推断的逻辑链条**（第2.7节）：将上述内容串联起来，建立从总体到样本、从样本到推断的完整框架。

---

## 2.2 总体、样本与抽样

### 2.2.1 总体：我们真正关心的对象

**总体**（Population）是我们研究兴趣所在的全部对象的集合。需要强调的是，总体的定义取决于**研究问题**，而非某个固定的实体。

| 研究问题                       | 总体                                                         |
| ------------------------------ | ------------------------------------------------------------ |
| 中国A股市场的平均收益率        | 所有A股上市公司在所有时间点上的收益率                        |
| 某监管政策对企业违规行为的影响 | 所有可能受该政策影响的企业（包括过去的、现在的、甚至未来的） |
| 家庭资产配置的决定因素         | 中国所有家庭在所有时间点上的资产配置状况                     |

注意几个要点：

**第一，总体通常是无法完全观测的。** 即使我们能获得所有A股上市公司过去20年的收益率数据，我们关心的总体可能还包括未来的收益率——这在原则上是不可观测的。总体既包含已经实现但我们可能未观测到的部分，也包含尚未实现、原则上无法观测的部分。

**第二，总体可以是有限的，也可以是无限的。** 如果我们只关心"2024年12月31日中国A股市场所有上市公司的总市值"，那么总体是有限的。但如果我们关心的是"股票日收益率的一般性分布规律"，那么总体在概念上是无限的。

**第三，总体的定义往往隐含着条件。** 当我们说"中国A股市场的平均收益率"时，我们实际上隐含了许多条件：我们讨论的是中国的市场、A股（而非港股或美股）、上市公司（而非所有企业）。这些条件界定了总体的边界，也暗示了我们的推断范围。

> **给读者的提醒**：在开始任何数据分析之前，请先明确你的总体是什么。这看似简单，实则是许多研究中被忽视的关键步骤。总体的定义不明确，后续所有的统计推断都将失去根基。

### 2.2.2 样本：我们实际观察到的数据

**样本**（Sample）是从总体中抽取的一个子集，是我们实际拥有和分析的数据。

沿用前面的例子：

| 总体                                  | 可能的样本                                               |
| ------------------------------------- | -------------------------------------------------------- |
| 所有A股上市公司在所有时间点上的收益率 | 沪深300成分股2010-2023年的月度收益率                     |
| 所有可能受某政策影响的企业            | 2015-2020年间在A股上市且属于特定行业的企业               |
| 中国所有家庭的资产配置状况            | 中国家庭金融调查（CHFS）2019年调查数据中的约40,000户家庭 |

样本与总体之间的关系可以用如下简单的框架来概括：

$$
\text{总体} \xrightarrow{\text{抽样过程}} \text{样本} \xrightarrow{\text{统计分析}} \text{关于总体的推断}
$$

这个链条看似简单，却蕴含着统计推断的全部精髓：我们**从样本出发**，利用统计方法**逆向推断**总体的特征。推断的质量，关键取决于抽样过程的性质。

### 2.2.3 抽样：连接总体与样本的桥梁

抽样（Sampling）是从总体中选取样本的过程。理想情况下，我们希望进行**简单随机抽样**（Simple Random Sampling, SRS），即总体中的每个个体都有相同的概率被选入样本。但在金融研究的实践中，我们获得的样本几乎从来不是简单随机抽取的。

#### 随机抽样

在随机抽样中，每个总体成员被选入样本的概率是已知的（虽然不必相等）。这是统计推断的理想基础，因为它保证了样本的**代表性**——在大样本条件下，样本的统计特征会趋近于总体的真实特征。

然而，即使是随机抽样，也常常是**有条件的**。例如：

- **分层抽样**：先将总体按某个变量（如行业、地区、规模）分组，再在每组内进行随机抽样。CHFS 的调查设计就采用了分层多阶段抽样。
  - 适用场景：当总体具有明显的异质性时 (比如，不同行业的企业规模差异较大)，分层抽样可以确保样本在关键特征上与总体保持一致，控制混杂变量。
- **系统抽样**：按照一定的间隔（如每隔10个企业抽取一个）进行抽样。这种方法简单易行，但需要确保总体没有周期性结构，否则可能引入偏差。
- **聚类抽样**：先随机抽取若干"群组"（如省份、社区），再对选中的群组进行全面调查或进一步抽样。

这意味着，即使在随机抽样的框架下，我们也需要理解**条件分布**（Conditional Distribution）的概念——我们观察到的数据，往往是在特定条件下产生的。

此外，随机抽样还涉及**样本量**（Sample Size）的问题。10个观测值和10,000个观测值所能提供的推断精度显然不同。大数定律和中心极限定理为我们理解样本量与推断精度之间的关系提供了理论基础（我们将在本章后续部分讨论）。

#### 非随机抽样与样本选择偏差

在金融研究中，更常见的情况是**非随机抽样**。数据的获取过程本身就引入了系统性的偏差：

- **存活偏差**（Survivorship Bias）：如果我们只研究当前仍在上市的公司，就会忽略那些已经退市的公司。而退市公司往往业绩较差，因此我们的样本会系统性地高估上市公司的平均业绩。
- **自选择偏差**（Self-selection Bias）：企业是否选择发行绿色债券，与其自身的环境绩效相关。如果我们只比较发行了绿色债券的企业和未发行的企业，差异可能不是绿色债券本身的效果，而是这两类企业本身就不同。
- **数据可得性偏差**：我们能获得的数据往往限于特定的数据库。例如，CSMAR数据库主要覆盖上市公司，WIND主要覆盖金融市场数据。这些数据库的覆盖范围决定了我们样本的边界。
- **截断与删失**：在信用风险研究中，我们可能只观察到违约的贷款（截断），或者只知道某笔贷款在观察期结束时尚未违约，但不知道它最终是否会违约（删失）。

这些非随机因素使得样本不再是总体的"缩影"，从而可能导致统计推断的偏误。后续章节将介绍的许多计量方法——工具变量（IV）、双重差分（DiD）、断点回归（RDD）、Heckman 两步法等——本质上都是为了**应对非随机抽样带来的偏误**。

### 2.2.4 鱼塘的故事：理解抽样偏差

让我们通过一个具体的例子来直观地理解抽样偏差。

> **情境设定**：某个鱼塘中有 $N=1000$ 条鱼。假设鱼的长度（单位：厘米）在总体中服从正态分布，均值 $\mu = 25$ cm，标准差 $\sigma = 5$ cm。但鱼在鱼塘中的分布并不均匀：小鱼倾向于聚集在靠近岸边的浅水区，大鱼倾向于栖息在鱼塘中央的深水区。

现在，我们要从鱼塘中捞 10 条鱼，通过这 10 条鱼的平均长度来估计总体的平均鱼长。我们有三种捞鱼策略：

- **策略A——岸边捞鱼**：只在鱼塘四周的岸边浅水区捞鱼。
- **策略B——中央捞鱼**：只在鱼塘中央的深水区捞鱼。
- **策略C——随机捞鱼**：在整个鱼塘中随机位置捞鱼。

```python
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec

np.random.seed(42)

# ========================================
# 总体设定
# ========================================
N = 1000
mu_population = 25
sigma_population = 5

# 生成总体鱼长
fish_lengths = np.random.normal(mu_population, sigma_population, N)
fish_lengths = np.clip(fish_lengths, 5, 45)  # 限制在合理范围内

# 为每条鱼分配位置（距离鱼塘中心的距离）
# 关键假设：鱼越大，越倾向于待在中央
# 通过让位置与鱼长负相关来实现
fish_distance_from_center = np.random.beta(2, 2, N) * 50  # 0-50米（鱼塘半径50米）
# 调整：大鱼更靠近中心
sorting_idx = np.argsort(fish_lengths)
distance_sorted = np.sort(fish_distance_from_center)[::-1]  # 大鱼距离小
fish_distance_from_center[sorting_idx] = distance_sorted
# 加入一些随机扰动，避免完美相关
fish_distance_from_center += np.random.normal(0, 8, N)
fish_distance_from_center = np.clip(fish_distance_from_center, 0, 50)

# ========================================
# 三种抽样策略
# ========================================
n_sample = 10
n_simulations = 2000

# 定义区域
shore_mask = fish_distance_from_center > 35       # 岸边区域：距中心 > 35米
center_mask = fish_distance_from_center < 15      # 中央区域：距中心 < 15米

shore_indices = np.where(shore_mask)[0]
center_indices = np.where(center_mask)[0]
all_indices = np.arange(N)

# 进行多次模拟
means_shore = []
means_center = []
means_random = []

for _ in range(n_simulations):
    # 策略A：岸边捞鱼
    sample_a = np.random.choice(shore_indices, n_sample, replace=False)
    means_shore.append(fish_lengths[sample_a].mean())
    
    # 策略B：中央捞鱼
    sample_b = np.random.choice(center_indices, n_sample, replace=False)
    means_center.append(fish_lengths[sample_b].mean())
    
    # 策略C：随机捞鱼
    sample_c = np.random.choice(all_indices, n_sample, replace=False)
    means_random.append(fish_lengths[sample_c].mean())

means_shore = np.array(means_shore)
means_center = np.array(means_center)
means_random = np.array(means_random)

# ========================================
# 可视化
# ========================================
fig = plt.figure(figsize=(16, 12))
gs = gridspec.GridSpec(2, 2, hspace=0.35, wspace=0.3)

# --- 图1：鱼塘示意图 ---
ax1 = fig.add_subplot(gs[0, 0])
# 生成鱼的 x,y 坐标（极坐标转笛卡尔坐标）
angles = np.random.uniform(0, 2*np.pi, N)
fish_x = fish_distance_from_center * np.cos(angles)
fish_y = fish_distance_from_center * np.sin(angles)

scatter = ax1.scatter(fish_x, fish_y, c=fish_lengths, cmap='coolwarm', 
                      s=fish_lengths*1.5, alpha=0.4, edgecolors='none')
circle_shore = plt.Circle((0, 0), 35, fill=False, color='green', 
                           linestyle='--', linewidth=2, label='Shore boundary')
circle_pond = plt.Circle((0, 0), 50, fill=False, color='black', 
                          linewidth=2, label='Pond boundary')
circle_center = plt.Circle((0, 0), 15, fill=False, color='red', 
                            linestyle='--', linewidth=2, label='Center region')
ax1.add_patch(circle_pond)
ax1.add_patch(circle_shore)
ax1.add_patch(circle_center)
ax1.set_xlim(-60, 60)
ax1.set_ylim(-60, 60)
ax1.set_aspect('equal')
ax1.set_title('Fish Pond: Size & Location', fontsize=13, fontweight='bold')
ax1.set_xlabel('x (meters)')
ax1.set_ylabel('y (meters)')
cbar = plt.colorbar(scatter, ax=ax1, shrink=0.8)
cbar.set_label('Fish length (cm)')
ax1.legend(loc='upper right', fontsize=8)

# --- 图2：三个区域的鱼长分布 ---
ax2 = fig.add_subplot(gs[0, 1])
ax2.hist(fish_lengths[shore_mask], bins=25, alpha=0.5, color='green', 
         label=f'Shore (n={shore_mask.sum()}, mean={fish_lengths[shore_mask].mean():.1f})', density=True)
ax2.hist(fish_lengths[center_mask], bins=25, alpha=0.5, color='red', 
         label=f'Center (n={center_mask.sum()}, mean={fish_lengths[center_mask].mean():.1f})', density=True)
ax2.hist(fish_lengths, bins=30, alpha=0.3, color='gray', 
         label=f'Population (N={N}, mean={fish_lengths.mean():.1f})', density=True)
ax2.axvline(mu_population, color='black', linestyle='-', linewidth=2, label=f'True μ = {mu_population}')
ax2.set_title('Fish Length Distribution by Region', fontsize=13, fontweight='bold')
ax2.set_xlabel('Fish length (cm)')
ax2.set_ylabel('Density')
ax2.legend(fontsize=8)

# --- 图3：三种策略的样本均值抽样分布 ---
ax3 = fig.add_subplot(gs[1, :])
ax3.hist(means_shore, bins=40, alpha=0.5, color='green', density=True, 
         label=f'Strategy A: Shore (mean={means_shore.mean():.2f}, sd={means_shore.std():.2f})')
ax3.hist(means_center, bins=40, alpha=0.5, color='red', density=True, 
         label=f'Strategy B: Center (mean={means_center.mean():.2f}, sd={means_center.std():.2f})')
ax3.hist(means_random, bins=40, alpha=0.5, color='steelblue', density=True, 
         label=f'Strategy C: Random (mean={means_random.mean():.2f}, sd={means_random.std():.2f})')
ax3.axvline(mu_population, color='black', linestyle='-', linewidth=2.5, label=f'True μ = {mu_population}')
ax3.set_title(f'Sampling Distribution of Sample Mean (n={n_sample}, {n_simulations} simulations)', 
              fontsize=13, fontweight='bold')
ax3.set_xlabel('Sample mean of fish length (cm)')
ax3.set_ylabel('Density')
ax3.legend(fontsize=9)

plt.savefig('fish_pond_sampling.png', dpi=150, bbox_inches='tight')
plt.show()

# ========================================
# 打印统计结果
# ========================================
print("=" * 65)
print("鱼塘抽样实验结果")
print("=" * 65)
print(f"总体真实均值: {fish_lengths.mean():.2f} cm")
print(f"总体真实标准差: {fish_lengths.std():.2f} cm")
print("-" * 65)
print(f"{'策略':<20} {'样本均值的均值':>15} {'样本均值的标准差':>18} {'偏差':>10}")
print("-" * 65)
print(f"{'A: 岸边捞鱼':<18} {means_shore.mean():>13.2f} {means_shore.std():>16.2f} {means_shore.mean()-fish_lengths.mean():>10.2f}")
print(f"{'B: 中央捞鱼':<18} {means_center.mean():>13.2f} {means_center.std():>16.2f} {means_center.mean()-fish_lengths.mean():>10.2f}")
print(f"{'C: 随机捞鱼':<18} {means_random.mean():>13.2f} {means_random.std():>16.2f} {means_random.mean()-fish_lengths.mean():>10.2f}")
print("=" * 65)
```

上面的模拟结果清晰地展示了三个关键发现：

1. **策略A（岸边捞鱼）** 系统性地**低估**了总体平均鱼长，因为岸边以小鱼为主。
2. **策略B（中央捞鱼）** 系统性地**高估**了总体平均鱼长，因为中央区域以大鱼为主。
3. **策略C（随机捞鱼）** 的样本均值分布**以总体真实均值为中心**，没有系统性偏差。

策略A和B的偏差并不是因为样本量不够大（增加样本量并不能消除这种偏差），而是因为抽样过程本身引入了**系统性的选择效应**。这正是**样本选择偏差**（Sample Selection Bias）的核心问题。

> **与金融研究的类比**：
> - 只研究存活至今的基金（岸边捞鱼）→ 高估基金的平均业绩（存活偏差）
> - 只研究自愿披露ESG报告的企业（中央捞鱼）→ 高估ESG的普及程度和效果（自选择偏差）
> - 使用合理的研究设计确保样本代表性（随机捞鱼）→ 更可靠的推断

### 2.2.5 三个层次的数据：总体、理论样本与经验样本

在进一步讨论之前，让我们明确三个层次的概念，它们在后续的学习中会反复出现：

$$
\text{总体 (Population)} \xrightarrow{\text{抽样机制}} \text{理论样本 (Theoretical Sample)} \xrightarrow{\text{实际观测}} \text{经验样本 (Empirical Sample)}
$$

- **总体**（Population）：我们研究兴趣所在的全部对象，通常是无法完全观测的。总体具有某些固定但未知的特征（即**参数**，如均值 $\mu$、方差 $\sigma^2$）。

- **理论样本**（Theoretical Sample，也称 Random Sample）：这是一个**概念上的**对象。我们假设样本中的每个观测值 $X_1, X_2, \ldots, X_n$ 是从总体分布中独立抽取的随机变量。在数据被实际观测之前，它们的具体取值是未知的——我们只知道它们的分布特征。理论样本是连接总体与统计理论的桥梁。

- **经验样本**（Empirical Sample，也称 Realized Sample）：这就是我们手头的**实际数据** $x_1, x_2, \ldots, x_n$——一组具体的数值。它是理论样本的一次**实现**（realization）。

为什么要区分这三个层次？因为统计推断的逻辑依赖于这种区分：

- 我们从**经验样本**（手头的数据）出发；
- 借助**理论样本**的概率框架（假设数据是如何生成的）；
- 最终对**总体**的未知参数做出推断。

> **一个有助于理解的类比**：假设你在掷一枚硬币。
> - **总体**：这枚硬币的真实正面概率 $p$（一个固定但你不知道的数）。
> - **理论样本**：你计划掷 100 次，在掷之前，每次的结果 $X_i$ 是一个随机变量（你只知道它服从参数为 $p$ 的伯努利分布）。
> - **经验样本**：你实际掷了 100 次，得到了 58 次正面，42 次反面。这就是你的数据 $x_1, x_2, \ldots, x_{100}$。

---

## 2.3 分布：统计学的核心语言

### 2.3.1 为什么需要"分布"这个概念？

在上一节中，我们看到了一个重要的现象：即使是采用策略C（随机捞鱼），每次捞到的 10 条鱼的平均长度也并不完全相同。有时略高于真实均值，有时略低。这种**变异性**（variability）是随机抽样的本质特征。

这里有一个关键问题：如果我只捞了一次鱼（得到一个样本均值），我怎么知道这个均值离真实值有多远？我怎么量化自己的不确定性？

**分布**（Distribution）正是为回答这类问题而生的概念工具。通过分布，我们可以：

1. **描述随机性的结构**：不仅知道"结果是不确定的"，还知道"各种可能的结果出现的可能性有多大"。
2. **量化不确定性**：基于分布，我们可以计算置信区间、$p$ 值等，为推断提供精确的概率陈述。
3. **连接样本与总体**：分布是从样本统计量到总体参数进行推断的桥梁。

### 2.3.2 分布的本质：位置与概率

"分布"（Distribution）这个词本身就蕴含着它的核心含义。让我们从一个日常用语开始：

> **"中国的人口分布"**

当我们说这句话时，我们关心两件事：
1. **位置**（Location）：人口分布在哪些地方？——沿海地区、内陆地区、东北、西南……
2. **多寡**（Frequency/Density）：每个地方有多少人？——东部沿海人口密集，西部高原人口稀少。

"分布"这个概念的威力在于：它用一个统一的框架同时回答了"在哪里"和"有多少"这两个问题。

**统计学中的分布完全类似。** 对于一个随机变量 $X$，其分布描述了：
1. $X$ 可能取哪些值（**取值范围**或**支撑集**，Support）；
2. $X$ 取每个值的可能性有多大（**概率**或**概率密度**）。

下面是一个简单的对比：

| 日常用语               | 统计学对应                 |
| ---------------------- | -------------------------- |
| 中国人口的地理分布     | 随机变量 $X$ 的概率分布    |
| 地理位置（省份、城市） | $X$ 的可能取值             |
| 各地区人口数量         | 各取值对应的概率/密度      |
| 人口密度地图           | 概率密度函数 $f(x)$ 的图形 |

### 2.3.3 一个金融直觉：收益率分布

让我们将"分布"的概念与金融直觉建立连接。

假设你正在考虑投资两只基金 A 和 B，它们过去一年的月度收益率如下：

```python
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

np.random.seed(2024)

# 基金A：低收益、低波动
fund_A = np.random.normal(loc=0.005, scale=0.02, size=120)  # 月均0.5%，标准差2%
# 基金B：高收益、高波动
fund_B = np.random.normal(loc=0.008, scale=0.06, size=120)  # 月均0.8%，标准差6%

fig, axes = plt.subplots(1, 3, figsize=(18, 5))

# --- 图1：时间序列 ---
months = np.arange(1, 121)
axes[0].plot(months, fund_A * 100, color='steelblue', alpha=0.7, label='Fund A')
axes[0].plot(months, fund_B * 100, color='coral', alpha=0.7, label='Fund B')
axes[0].axhline(0, color='gray', linestyle='--', linewidth=0.8)
axes[0].set_xlabel('Month')
axes[0].set_ylabel('Monthly Return (%)')
axes[0].set_title('Time Series of Monthly Returns', fontweight='bold')
axes[0].legend()

# --- 图2：直方图（经验分布） ---
axes[1].hist(fund_A * 100, bins=20, alpha=0.5, color='steelblue', density=True, label='Fund A')
axes[1].hist(fund_B * 100, bins=20, alpha=0.5, color='coral', density=True, label='Fund B')
# 叠加理论密度曲线
x_range = np.linspace(-20, 25, 300)
axes[1].plot(x_range, stats.norm.pdf(x_range, 0.5, 2), color='steelblue', linewidth=2)
axes[1].plot(x_range, stats.norm.pdf(x_range, 0.8, 6), color='coral', linewidth=2)
axes[1].set_xlabel('Monthly Return (%)')
axes[1].set_ylabel('Density')
axes[1].set_title('Distribution of Monthly Returns', fontweight='bold')
axes[1].legend()

# --- 图3：累积分布函数 ---
axes[2].plot(np.sort(fund_A * 100), np.linspace(0, 1, 120), color='steelblue', linewidth=2, label='Fund A')
axes[2].plot(np.sort(fund_B * 100), np.linspace(0, 1, 120), color='coral', linewidth=2, label='Fund B')
axes[2].axhline(0.05, color='gray', linestyle=':', linewidth=1)
axes[2].axhline(0.95, color='gray', linestyle=':', linewidth=1)
axes[2].set_xlabel('Monthly Return (%)')
axes[2].set_ylabel('Cumulative Probability')
axes[2].set_title('Empirical CDF', fontweight='bold')
axes[2].legend()

plt.tight_layout()
plt.savefig('fund_comparison.png', dpi=150, bbox_inches='tight')
plt.show()

print(f"Fund A: mean = {fund_A.mean()*100:.2f}%, std = {fund_A.std()*100:.2f}%, "
      f"min = {fund_A.min()*100:.2f}%, max = {fund_A.max()*100:.2f}%")
print(f"Fund B: mean = {fund_B.mean()*100:.2f}%, std = {fund_B.std()*100:.2f}%, "
      f"min = {fund_B.min()*100:.2f}%, max = {fund_B.max()*100:.2f}%")
```

仅看均值（"位置"信息），基金 B 似乎更优。但当我们看到完整的分布时，我们发现基金 B 的收益率波动远大于基金 A——它有更高的可能性获得很高的收益，但也有更高的可能性遭受严重的亏损。

这正是"分布"这个概念的威力：**均值只告诉你"中心在哪里"，而分布告诉你"全貌是什么样的"**。在金融中，一个投资产品的风险与收益不是两个独立的概念，而是其收益率分布的不同侧面。

### 2.3.4 广州男士在波士顿买衬衫：分布的相对性

一位身高 175cm、体重 75kg 的中国男子，在广州的商场买衬衫时可能会挑选 **L** 码。但当他出差到波士顿，走进一家美国商场时，他可能会惊讶地发现自己更适合 **M** 码。

这并不是因为他在跨越太平洋的飞行中缩小了——而是因为**尺码的定义取决于参考人群的体型分布**。

- 在中国，成年男子的平均身高约为 170cm。175cm 的身高在中国男性中处于偏高位置，对应 L 码。
- 在美国，成年男子的平均身高约为 178cm。175cm 在美国男性中处于中等位置，对应 M 码。

```python
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

fig, ax = plt.subplots(figsize=(12, 6))

# 身高分布（近似）
x = np.linspace(150, 200, 500)
china_dist = stats.norm(170, 6)   # 中国男性：均值170，标准差6
us_dist = stats.norm(178, 7)      # 美国男性：均值178，标准差7

ax.plot(x, china_dist.pdf(x), color='crimson', linewidth=2.5, label='Chinese males (μ=170, σ=6)')
ax.plot(x, us_dist.pdf(x), color='steelblue', linewidth=2.5, label='US males (μ=178, σ=7)')
ax.axvline(175, color='darkgreen', linestyle='--', linewidth=2, label='Our gentleman (175cm)')

# 标注百分位数
china_pct = china_dist.cdf(175) * 100
us_pct = us_dist.cdf(175) * 100

ax.annotate(f'In China: top {100-china_pct:.0f}% → L', 
            xy=(175, china_dist.pdf(175)), xytext=(183, china_dist.pdf(175)+0.005),
            fontsize=11, color='crimson', fontweight='bold',
            arrowprops=dict(arrowstyle='->', color='crimson'))
ax.annotate(f'In US: bottom {us_pct:.0f}% → M', 
            xy=(175, us_dist.pdf(175)), xytext=(158, us_dist.pdf(175)+0.01),
            fontsize=11, color='steelblue', fontweight='bold',
            arrowprops=dict(arrowstyle='->', color='steelblue'))

ax.fill_between(x, china_dist.pdf(x), where=(x >= 175), alpha=0.15, color='crimson')
ax.fill_between(x, us_dist.pdf(x), where=(x <= 175), alpha=0.15, color='steelblue')

ax.set_xlabel('Height (cm)', fontsize=12)
ax.set_ylabel('Probability Density', fontsize=12)
ax.set_title('Why Your Shirt Size Changes When You Fly from Guangzhou to Boston', 
             fontsize=14, fontweight='bold')
ax.legend(fontsize=11)
ax.set_xlim(150, 200)

plt.tight_layout()
plt.savefig('shirt_size.png', dpi=150, bbox_inches='tight')
plt.show()

print(f"175cm 在中国男性中的百分位数: {china_pct:.1f}%")
print(f"175cm 在美国男性中的百分位数: {us_pct:.1f}%")
```

这个例子给我们的启示是：

**同一个数值在不同分布中的"位置"（相对位置）是不同的。** 175cm 这个身高本身没有变化，但它相对于不同参考分布的位置发生了变化。在统计学中，我们经常需要将数据放在合适的参考分布中来理解它的含义。这正是 $z$-分数（标准化分数）的核心思想：

$$
z = \frac{x - \mu}{\sigma}
$$

它告诉我们一个观测值相对于其参考分布的均值偏离了多少个标准差——这是一个**与分布无关**（distribution-free）的相对位置度量。

> **金融中的应用**：在因子投资中，我们经常将个股的某些指标（如市盈率、动量等）在横截面上进行标准化或排序分组，本质上就是在参考横截面分布来确定每只股票的"相对位置"。

### 2.3.5 分布在统计学中的三种角色

在后续的学习中，你将反复遇到"分布"这个概念，但它在不同场景中扮演着不同的角色。现在让我们提前做一个梳理，为后续章节打下基础。

#### 角色一：总体分布（Population Distribution）

总体分布描述的是总体中个体特征的分布规律。例如：

- A股市场所有个股日收益率的分布
- 中国所有上市公司资产负债率的分布
- 中国所有家庭年收入的分布

总体分布通常由某个概率分布 $F(\cdot; \theta)$ 来描述，其中 $\theta$ 是未知参数。比如，我们可能假设某只股票的日收益率服从正态分布 $N(\mu, \sigma^2)$，这里的 $\mu$ 和 $\sigma^2$ 就是我们想要估计的总体参数。

总体分布是**我们想要了解的对象**，但通常是不可直接观测的。

#### 角色二：样本分布 / 抽样分布（Sampling Distribution）

这是统计推断中**最重要也最容易被混淆**的概念。

假设我们从总体中随机抽取 $n$ 个观测值，计算一个统计量（如样本均值 $\bar{X}$）。如果我们重复这个抽样过程很多次，每次都得到一个不同的 $\bar{X}$，那么所有这些 $\bar{X}$ 值构成的分布，就是**样本均值的抽样分布**（Sampling Distribution of the Sample Mean）。

在鱼塘实验的图3中，我们已经直观地看到了抽样分布：蓝色直方图展示的就是在 2000 次随机抽样中，样本均值的分布。

抽样分布的核心意义在于：**它量化了统计量的不确定性**。抽样分布越窄，意味着不同样本给出的估计越一致，我们的估计越精确。

**中心极限定理**（Central Limit Theorem, CLT）告诉我们一个重要的结果：无论总体分布的形状如何，只要样本量 $n$ 足够大，样本均值 $\bar{X}$ 的抽样分布都近似服从正态分布：

$$
\bar{X} \dot{\sim} N\left(\mu, \frac{\sigma^2}{n}\right)
$$

其中 $\mu$ 和 $\sigma^2$ 是总体的均值和方差。这个定理是现代统计推断的基石之一。

#### 角色三：参数的（后验）分布——贝叶斯视角

在经典（频率学派）统计学中，总体参数 $\theta$ 是一个**固定但未知的常数**。我们通过样本来估计它，并用置信区间来描述估计的不确定性。

但在**贝叶斯统计学**中，参数 $\theta$ 本身被视为一个**随机变量**，它有自己的分布。贝叶斯方法的核心逻辑是：

$$
\underbrace{p(\theta | \text{data})}_{\text{后验分布}} \propto \underbrace{p(\text{data} | \theta)}_{\text{似然函数}} \times \underbrace{p(\theta)}_{\text{先验分布}}
$$

- **先验分布** $p(\theta)$：在看到数据之前，我们对参数的信念（可能基于经验、理论或主观判断）。
- **似然函数** $p(\text{data} | \theta)$：给定参数值，数据出现的可能性。
- **后验分布** $p(\theta | \text{data})$：在看到数据之后，我们对参数的更新信念。

后验分布是贝叶斯统计的核心产出——它完整地描述了我们关于参数的不确定性。我们将在后续章节中详细讨论贝叶斯方法。

#### 角色四：误差项的分布（Distribution of the Error Term）

在回归分析和计量经济学中，我们通常假设模型的误差项 $\varepsilon$ 服从某种分布。例如：

- **线性回归**：$y_i = \mathbf{x}_i'\boldsymbol{\beta} + \varepsilon_i$，通常假设 $\varepsilon_i \sim N(0, \sigma^2)$（高斯-马尔可夫框架）。
- **Logit 模型**：隐含假设误差项服从 Logistic 分布。
- **Probit 模型**：隐含假设误差项服从正态分布。
- **Tobit 模型**：处理截断数据时，同样基于正态分布假设。

误差项分布的假设直接决定了模型的形式和估计方法。例如，Logit 和 Probit 模型之间的唯一区别就在于它们对误差项分布的不同假设。在后续讨论离散选择模型时，你将深刻体会到这一点。

> **小结**：分布在统计学中无处不在，但在不同语境下指代的对象不同：
> | 分布类型 | 描述的对象 | 核心作用 |
> |---------|-----------|---------|
> | 总体分布 | 总体中个体的特征 | 我们的推断目标 |
> | 抽样分布 | 样本统计量的随机变异 | 量化估计的不确定性 |
> | 后验分布 | 参数的不确定性（贝叶斯） | 融合先验与数据进行推断 |
> | 误差项分布 | 模型未解释的随机成分 | 决定模型形式与估计方法 |

---

## 2.4 描述分布的统计量

了解了分布的重要性之后，一个自然的问题是：我们如何用简洁的方式来描述一个分布？虽然概率密度函数 $f(x)$ 或累积分布函数 $F(x)$ 包含了分布的全部信息，但在实践中，我们通常使用几个关键的**统计量**（Statistics）来概括分布的主要特征。

### 2.4.1 位置的度量：均值与中位数

#### 均值（Mean）

总体均值：
$$
\mu = E[X] = \int_{-\infty}^{\infty} x \, f(x) \, dx
$$

样本均值：
$$
\bar{x} = \frac{1}{n} \sum_{i=1}^{n} x_i
$$

均值是分布的"重心"——如果你把概率密度函数想象成一块薄板，均值就是能让这块薄板在一根针上平衡的位置。

#### 中位数（Median）

中位数 $m$ 满足 $P(X \leq m) = 0.5$，即恰好有一半的概率落在中位数的左边，一半落在右边。

**均值 vs. 中位数：** 对于对称分布（如正态分布），两者相等。但对于偏斜分布，两者可能有显著差异。例如，收入分布通常是右偏的（少数高收入者拉高了均值），此时中位数比均值更能代表"典型"水平。

> **金融直觉**：对冲基金报告业绩时，常常同时报告均值和中位数收益率。如果均值显著高于中位数，说明收益率分布是右偏的——可能有少数几个月的异常高收益拉高了平均表现。投资者需要判断这种异常高收益是否可持续。

### 2.4.2 离散程度的度量：方差与标准差

#### 方差（Variance）

总体方差：
$$
\sigma^2 = \text{Var}(X) = E[(X - \mu)^2] = E[X^2] - (E[X])^2
$$

样本方差（无偏估计）：
$$
s^2 = \frac{1}{n-1} \sum_{i=1}^{n} (x_i - \bar{x})^2
$$

方差度量的是数据**偏离均值的平均平方距离**。分母使用 $n-1$ 而非 $n$，是为了校正样本方差对总体方差的低估（即所谓的 Bessel 校正），使之成为总体方差的**无偏估计量**。

#### 标准差（Standard Deviation）

$$
\sigma = \sqrt{\sigma^2}, \quad s = \sqrt{s^2}
$$

标准差与原始数据具有相同的量纲（如 %、元、cm），因此在实际中比方差更容易解释。

> **金融中的核心应用**：在投资组合理论中，收益率的标准差（波动率）是衡量风险的基本指标。Markowitz 均值-方差模型直接以均值（收益）和方差（风险）作为优化目标。

### 2.4.3 形状的度量：偏度与峰度

均值和方差描述了分布的位置和宽度，但分布的**形状**同样重要。偏度和峰度提供了关于分布形状的额外信息。

#### 偏度（Skewness）

$$
\text{Skew}(X) = E\left[\left(\frac{X - \mu}{\sigma}\right)^3\right]
$$

偏度度量分布的**不对称性**：
- **偏度 = 0**：分布关于均值对称（如正态分布）。
- **偏度 > 0**（正偏/右偏）：分布的右尾更长，均值 > 中位数。
- **偏度 < 0**（负偏/左偏）：分布的左尾更长，均值 < 中位数。

> **金融直觉**：大多数投资者偏好正偏度——他们宁愿承受小幅但频繁的亏损，也希望有机会获得偶尔的大额盈利（如购买彩票的心理）。相反，保险公司的承保业务通常具有负偏度——大部分时间收取稳定的保费，但偶尔需要赔付巨额损失。

#### 峰度（Kurtosis）

$$
\text{Kurt}(X) = E\left[\left(\frac{X - \mu}{\sigma}\right)^4\right]
$$

正态分布的峰度为 3。为了更直观地理解，我们通常使用**超额峰度**（Excess Kurtosis）：
$$
\text{Excess Kurt}(X) = \text{Kurt}(X) - 3
$$

超额峰度度量分布相对于正态分布的**尾部厚度**：
- **超额峰度 = 0**：与正态分布的尾部厚度相同。
- **超额峰度 > 0**（尖峰厚尾，Leptokurtic）：尾部比正态分布更厚，极端值出现的概率更高。
- **超额峰度 < 0**（平峰薄尾，Platykurtic）：尾部比正态分布更薄。

> **金融中的关键意义**：金融收益率的分布几乎普遍具有**正的超额峰度**——也就是说，极端收益（无论是暴涨还是暴跌）出现的概率远高于正态分布的预测。这就是所谓的"厚尾"（fat tails）现象。忽视厚尾会导致严重低估风险。2008年的全球金融危机中，许多风险模型的失败正是因为它们假设收益率服从正态分布，从而低估了极端事件的发生概率。

### 2.4.4 数值示例：用 Python 模拟与可视化

让我们通过一个完整的数值示例来直观理解这四个统计量。

```python
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

np.random.seed(42)
n = 5000

# 生成四种不同形状的分布
data_normal = np.random.normal(0, 1, n)                          # 正态分布
data_right_skew = np.random.exponential(1, n) - 1                # 右偏分布
data_left_skew = -np.random.exponential(1, n) + 1                # 左偏分布
data_fat_tail = np.random.standard_t(df=3, size=n)               # 厚尾分布（t分布，自由度3）

distributions = {
    'Normal\n(symmetric, thin tails)': data_normal,
    'Right-skewed\n(exponential shifted)': data_right_skew,
    'Left-skewed\n(neg. exponential shifted)': data_left_skew,
    'Fat-tailed\n(t-distribution, df=3)': data_fat_tail
}

fig, axes = plt.subplots(2, 2, figsize=(14, 10))
axes = axes.flatten()

for idx, (name, data) in enumerate(distributions.items()):
    ax = axes[idx]
    
    # 直方图
    ax.hist(data, bins=60, density=True, alpha=0.6, color='steelblue', edgecolor='white')
    
    # 核密度估计
    kde_x = np.linspace(data.min(), data.max(), 500)
    kde = stats.gaussian_kde(data)
    ax.plot(kde_x, kde(kde_x), color='darkred', linewidth=2)
    
    # 均值和中位数
    mean_val = np.mean(data)
    median_val = np.median(data)
    ax.axvline(mean_val, color='red', linestyle='-', linewidth=2, label=f'Mean = {mean_val:.3f}')
    ax.axvline(median_val, color='green', linestyle='--', linewidth=2, label=f'Median = {median_val:.3f}')
    
    # 计算统计量
    std_val = np.std(data, ddof=1)
    skew_val = stats.skew(data)
    kurt_val = stats.kurtosis(data)  # scipy 默认计算超额峰度
    
    # 文本框
    textstr = f'Std = {std_val:.3f}\nSkewness = {skew_val:.3f}\nExcess Kurt = {kurt_val:.3f}'
    props = dict(boxstyle='round', facecolor='wheat', alpha=0.8)
    ax.text(0.97, 0.97, textstr, transform=ax.transAxes, fontsize=10,
            verticalalignment='top', horizontalalignment='right', bbox=props)
    
    ax.set_title(name, fontsize=12, fontweight='bold')
    ax.legend(fontsize=9, loc='upper left')
    ax.set_ylabel('Density')

plt.suptitle('Four Distributions: Location, Spread, Skewness, and Kurtosis', 
             fontsize=14, fontweight='bold', y=1.02)
plt.tight_layout()
plt.savefig('four_distributions.png', dpi=150, bbox_inches='tight')
plt.show()
```

从图中可以清楚地看到：

1. **正态分布**：均值 ≈ 中位数，偏度 ≈ 0，超额峰度 ≈ 0。这是"标准"的对称薄尾分布。
2. **右偏分布**：均值 > 中位数（被右尾的极端值拉高），偏度 > 0。
3. **左偏分布**：均值 < 中位数（被左尾的极端值拉低），偏度 < 0。
4. **厚尾分布**：均值 ≈ 中位数，偏度 ≈ 0（对称），但超额峰度 >> 0——注意它的中心更尖、尾部更厚。

### 2.4.5 一个实际案例：A股收益率的分布特征

让我们用模拟数据来检验 A 股收益率是否真的具有我们所说的"厚尾"特征。

```python
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

np.random.seed(123)

# 模拟A股日收益率的典型特征
# 使用混合分布模拟：大部分时间温和波动，偶尔剧烈波动
n_days = 2500  # 约10年交易日

# 模拟方法：90% 来自低波动状态，10% 来自高波动状态
regime = np.random.binomial(1, 0.1, n_days)
returns = np.where(regime == 0,
                   np.random.normal(0.0003, 0.012, n_days),   # 低波动状态
                   np.random.normal(-0.001, 0.035, n_days))    # 高波动状态

# 计算统计量
mean_r = np.mean(returns)
std_r = np.std(returns, ddof=1)
skew_r = stats.skew(returns)
kurt_r = stats.kurtosis(returns)

# 正态分布参考
normal_returns = np.random.normal(mean_r, std_r, n_days)

fig, axes = plt.subplots(1, 3, figsize=(18, 5))

# --- 图1：直方图对比 ---
bins = np.linspace(-0.10, 0.10, 80)
axes[0].hist(returns * 100, bins=bins * 100, density=True, alpha=0.6, 
             color='steelblue', label='Simulated A-share returns')
x_norm = np.linspace(-10, 10, 500)
axes[0].plot(x_norm, stats.norm.pdf(x_norm, mean_r*100, std_r*100), 
             'r-', linewidth=2, label='Fitted normal')
axes[0].set_xlabel('Daily Return (%)')
axes[0].set_ylabel('Density')
axes[0].set_title('Histogram vs. Normal', fontweight='bold')
axes[0].legend()

# --- 图2：QQ图 ---
stats.probplot(returns, dist="norm", plot=axes[1])
axes[1].set_title('Q-Q Plot (vs. Normal)', fontweight='bold')
axes[1].get_lines()[0].set_markersize(3)
axes[1].get_lines()[0].set_markerfacecolor('steelblue')

# --- 图3：对数尺度下的尾部对比 ---
sorted_abs_returns = np.sort(np.abs(returns))[::-1]
rank = np.arange(1, len(sorted_abs_returns) + 1)
prob = rank / len(sorted_abs_returns)

# 正态分布的理论对应
normal_quantiles = stats.norm.isf(prob) * std_r

axes[2].scatter(sorted_abs_returns * 100, prob, s=5, alpha=0.5, 
                color='steelblue', label='Simulated data')
axes[2].scatter(np.abs(normal_quantiles) * 100, prob, s=5, alpha=0.5, 
                color='red', label='Normal reference')
axes[2].set_xscale('log')
axes[2].set_yscale('log')
axes[2].set_xlabel('|Daily Return| (%, log scale)')
axes[2].set_ylabel('P(|R| > x) (log scale)')
axes[2].set_title('Tail Comparison (Log-Log Scale)', fontweight='bold')
axes[2].legend()

plt.suptitle('A-Share Daily Returns: Fat Tails and Non-Normality', 
             fontsize=14, fontweight='bold', y=1.02)
plt.tight_layout()
plt.savefig('astock_returns.png', dpi=150, bbox_inches='tight')
plt.show()

print(f"{'统计量':<20} {'A股模拟收益率':>15} {'正态分布理论值':>15}")
print("-" * 52)
print(f"{'均值 (日)':<18} {mean_r*100:>14.4f}% {0:>14.4f}%")
print(f"{'标准差 (日)':<18} {std_r*100:>14.4f}% {'-':>15}")
print(f"{'偏度':<18} {skew_r:>15.4f} {0:>15.4f}")
print(f"{'超额峰度':<18} {kurt_r:>15.4f} {0:>15.4f}")
print(f"{'|R|>3σ 的天数':<18} {np.sum(np.abs(returns) > 3*std_r):>15d} {n_days*0.0027:>15.1f}")
print(f"{'|R|>4σ 的天数':<18} {np.sum(np.abs(returns) > 4*std_r):>15d} {n_days*0.0001:>15.1f}")
```

QQ 图是检验数据是否服从正态分布的有力工具。如果数据完全服从正态分布，QQ 图上的点应该落在 45 度对角线上。A 股收益率的 QQ 图在两端明显偏离对角线，说明尾部比正态分布更厚——即极端收益（无论涨跌）出现的概率远高于正态假设下的预测。

---

## 2.5 从理论分布到参数族

### 2.5.1 参数分布：用少数参数描述整个分布

一个令人欣慰的事实是：许多现实世界中的数据分布，可以用已知的数学形式——**参数分布族**——来很好地近似。每种参数分布都由少数几个**参数**（parameters）完全确定。

这意味着，**估计一个分布**的问题可以简化为**估计少数几个参数**的问题。

| 分布                                      | 参数                              | 典型应用                 |
| ----------------------------------------- | --------------------------------- | ------------------------ |
| 正态分布 $N(\mu, \sigma^2)$               | $\mu$（均值）, $\sigma^2$（方差） | 股票收益率、测量误差     |
| 对数正态分布 $\text{LogN}(\mu, \sigma^2)$ | $\mu, \sigma^2$                   | 股票价格、收入、公司市值 |
| 伯努利分布 $\text{Bernoulli}(p)$          | $p$（成功概率）                   | 违约/不违约、涨/跌       |
| 二项分布 $B(n, p)$                        | $n$（试验次数）, $p$（成功概率）  | $n$ 只债券中的违约数     |
| 泊松分布 $\text{Poisson}(\lambda)$        | $\lambda$（平均发生次数）         | 一年内收到问询函的次数   |
| 指数分布 $\text{Exp}(\lambda)$            | $\lambda$（速率参数）             | 相邻违约事件的时间间隔   |
| $t$ 分布 $t_{\nu}$                        | $\nu$（自由度）                   | 小样本推断、厚尾建模     |

### 2.5.2 推断的逻辑链条

现在，让我们将本章的核心概念串联起来，建立一个完整的推断链条：

$$
\boxed{\text{总体}} \xrightarrow[\text{由分布 } F(\cdot; \theta_0) \text{ 描述}]{\text{特征：参数 } \theta_0} \text{ } \xrightarrow{\text{随机抽样}} \text{ } \boxed{\text{样本 } x_1, \ldots, x_n} \xrightarrow{\text{统计方法}} \boxed{\hat{\theta}} \xrightarrow{\text{推断}} \boxed{\theta_0}
$$

具体而言：

1. **总体**具有某种分布 $F(\cdot; \theta_0)$，其中 $\theta_0$ 是真实但未知的参数。
2. 我们从总体中**抽取样本** $x_1, x_2, \ldots, x_n$。
3. 基于样本，我们使用**估计方法**（如最大似然估计、矩估计等）计算参数的**估计值** $\hat{\theta}$。
4. 利用**抽样分布理论**，我们可以评估 $\hat{\theta}$ 与 $\theta_0$ 之间可能的偏差范围（置信区间），或检验关于 $\theta_0$ 的假设（假设检验）。

### 2.5.3 一个完整的例子：泊松分布与监管问询函

假设你正在研究上市公司收到监管问询函的频率。一个自然的起点是假设每家公司一年内收到问询函的次数 $X$ 服从**泊松分布** $\text{Poisson}(\lambda)$，其中 $\lambda$ 是平均每年收到问询函的次数。

泊松分布的概率质量函数为：

$$
P(X = k) = \frac{\lambda^k e^{-\lambda}}{k!}, \quad k = 0, 1, 2, \ldots
$$

```python
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

np.random.seed(2024)

# 假设真实参数
lambda_true = 1.5  # 平均每年 1.5 次问询函

# "总体"：假设有 5000 家上市公司
N_population = 5000
population = np.random.poisson(lambda_true, N_population)

# 抽取不同大小的样本并估计 lambda
sample_sizes = [10, 30, 100, 500]
n_simulations = 3000

fig, axes = plt.subplots(2, 2, figsize=(14, 10))
axes = axes.flatten()

for idx, n in enumerate(sample_sizes):
    ax = axes[idx]
    
    # 多次抽样，记录每次的 lambda_hat
    lambda_hats = []
    for _ in range(n_simulations):
        sample = np.random.choice(population, n, replace=False)
        lambda_hats.append(sample.mean())  # MLE of Poisson lambda = sample mean
    
    lambda_hats = np.array(lambda_hats)
    
    # 直方图
    ax.hist(lambda_hats, bins=40, density=True, alpha=0.6, color='steelblue', 
            edgecolor='white')
    
    # 理论抽样分布（CLT近似）
    x = np.linspace(lambda_hats.min(), lambda_hats.max(), 200)
    theoretical_std = np.sqrt(lambda_true / n)
    ax.plot(x, stats.norm.pdf(x, lambda_true, theoretical_std), 'r-', linewidth=2,
            label=f'CLT: N({lambda_true}, {lambda_true/n:.4f})')
    
    ax.axvline(lambda_true, color='black', linestyle='--', linewidth=2, label=f'True λ = {lambda_true}')
    
    ax.set_title(f'n = {n}', fontsize=13, fontweight='bold')
    ax.set_xlabel('$\\hat{\\lambda}$ (sample mean)')
    ax.set_ylabel('Density')
    
    textstr = f'Mean of $\\hat{{\\lambda}}$ = {lambda_hats.mean():.3f}\nStd of $\\hat{{\\lambda}}$ = {lambda_hats.std():.3f}'
    props = dict(boxstyle='round', facecolor='lightyellow', alpha=0.8)
    ax.text(0.97, 0.75, textstr, transform=ax.transAxes, fontsize=10,
            verticalalignment='top', horizontalalignment='right', bbox=props)
    ax.legend(fontsize=8)

plt.suptitle('Sampling Distribution of $\\hat{\\lambda}$ for Different Sample Sizes\n'
             '(Poisson Distribution: Inquiry Letter Frequency)',
             fontsize=14, fontweight='bold')
plt.tight_layout()
plt.savefig('poisson_sampling.png', dpi=150, bbox_inches='tight')
plt.show()
```

这个模拟清楚地展示了几个重要事实：

1. **无偏性**：无论样本量大小，$\hat{\lambda}$ 的抽样分布都以真实值 $\lambda_0 = 1.5$ 为中心。
2. **一致性**：随着样本量增大，$\hat{\lambda}$ 的抽样分布越来越窄（方差递减），即估计越来越精确。
3. **渐近正态性**：当 $n$ 较大时，$\hat{\lambda}$ 的抽样分布很好地符合正态分布（中心极限定理）。
4. **标准误**：$\hat{\lambda}$ 的标准差（即标准误）大约为 $\sqrt{\lambda / n}$，这为我们构建置信区间提供了基础。

---

## 2.6 条件分布与条件思维

### 2.6.1 为什么条件很重要？

在金融数据分析中，我们几乎从来不是在无条件地分析数据。相反，我们总是在特定的**条件**下进行分析和推断。

考虑以下几个场景：

- 我们说"A股的平均收益率"时，隐含了"在中国A股市场"这个条件。
- 当我们研究"公司规模对股票收益率的影响"时，我们实际上是在比较不同规模**条件下**收益率分布的差异。
- 在信用风险模型中，我们关心的是**给定**企业的财务特征，其违约概率是多少。

**条件分布**（Conditional Distribution）描述的是：在某个变量取特定值（或满足特定条件）的前提下，另一个变量的分布。

$$
f(y|x) = \frac{f(x, y)}{f(x)}
$$

### 2.6.2 条件思维的金融应用

#### 回归分析的本质

线性回归 $E[Y|X] = \alpha + \beta X$ 估计的正是 $Y$ 的**条件均值**——给定 $X$ 的值，$Y$ 的平均取值是多少。

#### 离散选择模型

Logit 模型估计的是：

$$
P(Y=1 | \mathbf{X}) = \frac{\exp(\mathbf{X}'\boldsymbol{\beta})}{1 + \exp(\mathbf{X}'\boldsymbol{\beta})}
$$

即给定解释变量 $\mathbf{X}$ 的条件下，事件发生的概率。

#### 条件异方差

在金融时间序列中，波动率不是常数，而是随时间变化的。GARCH 模型刻画的正是收益率的**条件方差**：

$$
\sigma_t^2 = \text{Var}(r_t | \mathcal{F}_{t-1})
$$

其中 $\mathcal{F}_{t-1}$ 表示截至 $t-1$ 时刻的所有可用信息。

> **本质**：从"无条件分布"到"条件分布"的转变，反映了我们对数据生成过程的更精细理解。无条件分布回答的是"总体上 $Y$ 是怎样的"，而条件分布回答的是"在特定情况下 $Y$ 是怎样的"。后者对于预测和决策通常更有价值。

---

## 2.7 大数定律与中心极限定理：抽样推断的理论基石

### 2.7.1 大数定律（Law of Large Numbers）

大数定律告诉我们，当样本量足够大时，样本均值会"收敛"到总体均值：

$$
\bar{X}_n = \frac{1}{n}\sum_{i=1}^{n} X_i \xrightarrow{P} \mu \quad \text{as } n \to \infty
$$

这为"我们可以用样本来推断总体"提供了最基本的理论保证。

### 2.7.2 中心极限定理（Central Limit Theorem）

中心极限定理进一步告诉我们**样本均值的分布形状**：

$$
\frac{\bar{X}_n - \mu}{\sigma / \sqrt{n}} \xrightarrow{d} N(0, 1) \quad \text{as } n \to \infty
$$

或等价地：
$$
\bar{X}_n \dot{\sim} N\left(\mu, \frac{\sigma^2}{n}\right) \quad \text{for large } n
$$

这意味着：
1. 样本均值的抽样分布近似**正态**，无论总体分布是什么形状。
2. 这个正态分布的均值是总体均值 $\mu$（无偏性的体现）。
3. 这个正态分布的方差是 $\sigma^2/n$，随样本量增大而减小（精度随 $n$ 提高）。

```python
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

np.random.seed(42)

# 从一个高度非正态的总体（指数分布）出发
# 指数分布的参数 lambda = 1，均值 = 1，方差 = 1
population_dist = stats.expon(scale=1)
mu_true = 1.0
var_true = 1.0

sample_sizes = [1, 2, 5, 10, 30, 100]
n_simulations = 10000

fig, axes = plt.subplots(2, 3, figsize=(16, 10))
axes = axes.flatten()

for idx, n in enumerate(sample_sizes):
    ax = axes[idx]
    
    # 模拟
    sample_means = np.array([np.random.exponential(1, n).mean() for _ in range(n_simulations)])
    
    # 直方图
    ax.hist(sample_means, bins=50, density=True, alpha=0.6, color='steelblue', 
            edgecolor='white')
    
    # 正态近似
    x_range = np.linspace(sample_means.min(), sample_means.max(), 300)
    normal_approx = stats.norm.pdf(x_range, mu_true, np.sqrt(var_true/n))
    ax.plot(x_range, normal_approx, 'r-', linewidth=2, label='CLT normal approx.')
    
    ax.axvline(mu_true, color='black', linestyle='--', linewidth=1.5)
    ax.set_title(f'n = {n}', fontsize=13, fontweight='bold')
    ax.set_xlabel('$\\bar{X}$')
    ax.set_ylabel('Density')
    if idx == 0:
        ax.legend(fontsize=9)

plt.suptitle('Central Limit Theorem in Action\n'
             '(Population: Exponential Distribution, μ=1)',
             fontsize=14, fontweight='bold')
plt.tight_layout()
plt.savefig('clt_demonstration.png', dpi=150, bbox_inches='tight')
plt.show()
```

这个图直观地展示了中心极限定理的魔力：

- 当 $n=1$ 时，样本"均值"就是单个观测值，其分布就是总体的指数分布——高度右偏。
- 当 $n=2$ 时，分布开始变得不那么偏斜了。
- 当 $n=5$ 时，分布已经开始呈现钟形轮廓。
- 当 $n=30$ 时，正态近似已经非常好了。
- 当 $n=100$ 时，抽样分布几乎完美地符合正态分布。

> **实践意义**：中心极限定理是"为什么我们可以用 $z$ 检验和 $t$ 检验"的根本原因。即使总体分布不是正态的，只要样本量足够大，基于正态近似的统计推断方法依然是有效的。

---

## 2.8 似然函数：从数据到参数的桥梁

在本章的最后，我们简要介绍**似然函数**（Likelihood Function）的概念，它将在后续章节的许多模型中扮演核心角色。

### 2.8.1 从"正向"到"逆向"

让我们回顾概率与似然的区别：

- **概率**（Probability）：给定参数 $\theta$，观察到数据 $x$ 的可能性。 
  $$P(\text{data} = x \mid \theta) \quad \text{——从参数到数据}$$
  
- **似然**（Likelihood）：给定观测到的数据 $x$，参数 $\theta$ 取各种值的"合理程度"。
  $$\mathcal{L}(\theta \mid x) = P(\text{data} = x \mid \theta) \quad \text{——从数据到参数}$$

数学表达式虽然相同，但**思考方向**完全不同。概率是"固定参数，看数据"；似然是"固定数据，看参数"。

### 2.8.2 最大似然估计的直觉

**最大似然估计**（Maximum Likelihood Estimation, MLE）的思路异常直观：选择那个使得观测到的数据最有可能出现的参数值。

对于独立同分布的样本 $x_1, x_2, \ldots, x_n$，似然函数为：

$$
\mathcal{L}(\theta) = \prod_{i=1}^{n} f(x_i; \theta)
$$

取对数（方便计算且不改变最大值点）：

$$
\ell(\theta) = \sum_{i=1}^{n} \log f(x_i; \theta)
$$

MLE 就是令 $\ell(\theta)$ 最大的 $\theta$ 值：

$$
\hat{\theta}_{\text{MLE}} = \arg\max_{\theta} \ell(\theta)
$$

> **为什么这很重要？** 在后续章节中，Logit、Probit、Tobit 等模型都是通过最大似然估计来拟合的。这些模型的差异本质上就是似然函数形式的差异，而似然函数的形式又取决于我们对数据生成过程（即分布）的假设。

---

## 2.9 本章小结与前瞻

### 2.9.1 本章的核心要点

1. **统计推断的本质**是基于有限的样本信息推断总体的特征。推断的质量取决于样本的代表性。

2. **分布**是统计学的核心语言，它同时描述了一个变量"可能取哪些值"和"每个值出现的可能性"。分布在不同场景中扮演不同角色：总体分布、抽样分布、后验分布、误差项分布。

3. 每种分布可以由**少数参数**完全刻画，这使得"估计分布"简化为"估计参数"，极大地降低了推断的复杂度。

4. **描述性统计量**（均值、方差、偏度、峰度）提供了分布的简洁摘要。金融收益率通常具有厚尾和非正态特征。

5. **大数定律**保证了样本均值趋近于总体均值；**中心极限定理**说明了样本均值的抽样分布趋近于正态分布。两者共同构成了统计推断的理论基石。

6. **样本选择偏差**是金融研究中普遍存在的问题，需要通过合理的研究设计和计量方法来应对。

### 2.9.2 为后续章节做的铺垫

本章建立的概念框架将在后续章节中以不同方式出现：

| 后续主题                     | 与本章的联系                                                                                         |
| ---------------------------- | ---------------------------------------------------------------------------------------------------- |
| **Logit/Probit/Tobit 模型**  | 这些模型的差异核心在于对误差项分布的不同假设（Logistic 分布 vs. 正态分布），并通过最大似然估计来拟合 |
| **因果推断（DiD, RDD, IV）** | 本质上是解决非随机"抽样"（非随机处理分配）带来的偏差问题                                             |
| **Heckman 两步法**           | 直接处理样本选择偏差——正是我们鱼塘故事中非随机捞鱼的计量应对方案                                     |
| **机器学习**                 | 训练集/测试集划分就是一种抽样过程；过拟合本质上是对样本分布（而非总体分布）的过度拟合                |
| **贝叶斯方法**               | 将参数视为随机变量，赋予其先验分布，通过数据更新为后验分布——分布的概念贯穿始终                       |

---

## 2.10 练习与思考

**概念题**

1. 请用自己的语言解释"总体"、"理论样本"和"经验样本"三者的区别，并各举一个金融研究中的例子。

2. 在鱼塘捞鱼的例子中，如果我们知道大鱼倾向于在中央、小鱼倾向于在岸边，我们能否设计一种抽样策略，使得即使不在整个鱼塘随机捞鱼，也能得到无偏的总体均值估计？（提示：思考分层抽样和加权估计。）

3. 举出两个金融研究中存活偏差（Survivorship Bias）的例子，并讨论这种偏差会如何影响研究结论的方向（高估或低估）。

**计算题**

4. 某只股票过去 250 个交易日的日收益率数据表明：样本均值 $\bar{r} = 0.05\%$，样本标准差 $s = 1.8\%$，偏度 $= -0.3$，超额峰度 $= 4.2$。
   - (a) 基于这些统计量，描述该股票收益率分布的主要特征。
   - (b) 如果收益率服从正态分布，日亏损超过 3.6%（即 $2s$）的概率是多少？
   - (c) 根据超额峰度的信息，你认为实际亏损超过 3.6% 的概率会高于还是低于 (b) 的答案？为什么？

**编程题**

5. 使用 Python 模拟中心极限定理：从均匀分布 $U(0, 1)$ 中抽样，分别令 $n = 5, 20, 100, 500$，每种样本量模拟 10,000 次，绘制样本均值的抽样分布，并与对应的正态近似曲线对比。观察 CLT 的收敛速度。

6. 修改鱼塘抽样模拟代码，加入第四种策略："分层抽样"——先确定岸边和中央各有多少鱼，然后按比例在两个区域分别随机捞鱼。比较分层抽样与简单随机抽样的估计精度。

---

## 附录 2A：概率分布速查表

### 离散分布

**伯努利分布** $X \sim \text{Bernoulli}(p)$
$$P(X=1) = p, \quad P(X=0) = 1-p$$
$$E[X] = p, \quad \text{Var}(X) = p(1-p)$$

**二项分布** $X \sim B(n, p)$
$$P(X=k) = \binom{n}{k} p^k (1-p)^{n-k}, \quad k=0,1,\ldots,n$$
$$E[X] = np, \quad \text{Var}(X) = np(1-p)$$

**泊松分布** $X \sim \text{Poisson}(\lambda)$
$$P(X=k) = \frac{\lambda^k e^{-\lambda}}{k!}, \quad k=0,1,2,\ldots$$
$$E[X] = \lambda, \quad \text{Var}(X) = \lambda$$

### 连续分布

**正态分布** $X \sim N(\mu, \sigma^2)$
$$f(x) = \frac{1}{\sqrt{2\pi}\sigma} \exp\left(-\frac{(x-\mu)^2}{2\sigma^2}\right)$$
$$E[X] = \mu, \quad \text{Var}(X) = \sigma^2, \quad \text{Skew}=0, \quad \text{Excess Kurt}=0$$

**对数正态分布** $X \sim \text{LogN}(\mu, \sigma^2)$（即 $\ln X \sim N(\mu, \sigma^2)$）
$$E[X] = e^{\mu + \sigma^2/2}, \quad \text{Var}(X) = (e^{\sigma^2}-1)e^{2\mu+\sigma^2}$$

**$t$ 分布** $X \sim t_\nu$
$$E[X] = 0 \ (\nu>1), \quad \text{Var}(X) = \frac{\nu}{\nu-2} \ (\nu>2), \quad \text{Excess Kurt} = \frac{6}{\nu-4} \ (\nu>4)$$

**指数分布** $X \sim \text{Exp}(\lambda)$
$$f(x) = \lambda e^{-\lambda x}, \quad x \geq 0$$
$$E[X] = 1/\lambda, \quad \text{Var}(X) = 1/\lambda^2$$

---

> **下一章预告**：在建立了统计推断的基本框架之后，第3章将进入线性回归模型——统计学与计量经济学最基本也最重要的工具。我们将看到，回归模型如何利用"条件分布"的概念，从数据中提取变量之间的系统性关系。