# 金融文本分析（下）——情感分析与文本建模

::: {.callout-note}
## 本章目标

1. **理解**金融文本情感分析的基本原理，以及为什么通用方法不能直接用于金融文本
2. **掌握**情感词典方法：构建词典、计算情感得分、识别金融领域的词义歧义
3. **学会**用机器学习方法对金融文本做情感分类：文本向量化、模型训练与评估
4. **能够**使用大语言模型（LLM）进行零样本情感分析和文本摘要
5. **完成**一个综合案例：构建央行货币政策语气指数，并分析其与市场利率的关系

上一章解决了「从文本中提取信息」的问题——把非结构化文本变成结构化数据 [1]。本章要解决的是一个更深层的问题：**如何量化文本的「语气」和「情感」，并将其作为变量纳入金融分析框架？**
:::

---

## 从「读文本」到「量化文本」

上一章中，我们从借贷公告中提取了金额、利率、期限等字段。这些都是**事实性信息**——文本明确写了"利率为年化 4.20%"，我们提取出 `4.20` 这个数值。

但金融文本中还包含另一类同样重要、却不能直接提取的信息：**态度、语气和情感**。

看两段年报 MD&A 的对比：

> **公司 A（招商银行）**：资产质量保持稳健，不良贷款率 0.95%，较上年末下降 0.05 个百分点；拨备覆盖率 451.5%，风险抵补能力充足……财富管理手续费及佣金收入连续三年保持两位数增长。

> **公司 B（万科 A）**：房地产市场深度调整态势延续，行业整体面临前所未有的挑战……存货跌价准备计提金额较上年显著增加……短期偿债压力较为突出。公司将继续以"活下去"为首要目标。

即使不看任何财务数据，你也能直觉感受到：A 的语气是乐观自信的，B 的语气是悲观焦虑的。**情感分析的目标，就是用算法把这种人类直觉量化为一个数值**——比如 A 的情感得分为 +0.35，B 的情感得分为 −0.42——从而可以纳入回归模型、构建策略信号或追踪趋势变化。

::: {.callout-example}
### 案例：当"负债"不再是负面词

Loughran and McDonald（2011）做了一件影响深远的事情。他们发现，此前学术界用来分析金融文本的情感词典（如 Harvard General Inquirer），是为**通用英语**设计的。在通用语境下，"liability"（负债）是一个负面词——它暗示着负担和风险。但在金融语境下，"liability"只是一个中性的会计术语——"total liabilities"（总负债）出现在每家公司的资产负债表上，毫无负面含义。

他们系统性地检查了通用词典中被标记为"负面"的词，发现其中近 **75%** 在金融文本中并不是负面的。比如：

| 通用词典判定 | 词                | 金融语境下的实际含义                 |
| ------------ | ----------------- | ------------------------------------ |
| 负面         | liability（负债） | 中性：会计术语                       |
| 负面         | tax（税）         | 中性：所有公司都要交税               |
| 负面         | cost（成本）      | 中性：基本经营概念                   |
| 负面         | capital（资本）   | 正面：资本充足通常是好事             |
| 负面         | risk（风险）      | 视语境而定："风险管理能力提升"是正面 |

基于这一发现，他们专门构建了一套**金融领域情感词典**（Loughran-McDonald Dictionary），被后续数千篇论文引用，成为金融文本分析的事实标准。

**启示：金融文本分析不能照搬通用 NLP 工具，需要领域适配。** 这一原则贯穿本章始终。
:::

### 三种方法概览

本章将介绍三种量化文本情感的方法，它们各有优劣，在实务中往往互补使用：

| 方法              | 核心思路                 | 是否需要标注数据 | 可解释性 | 适用场景                 |
| ----------------- | ------------------------ | ---------------- | -------- | ------------------------ |
| 情感词典          | 数正面词和负面词的数量   | 不需要           | 高       | 大规模、可解释性要求高   |
| 机器学习分类      | 从标注数据中学习分类规则 | 需要             | 中       | 有标注数据、中等规模     |
| 大语言模型（LLM） | 利用 LLM 的语义理解能力  | 不需要           | 低       | 小规模、探索性、复杂任务 |

下面从最直接、最可解释的方法——情感词典——开始。

---

## 情感词典方法

### 基本原理

情感词典的思路非常简单：预先准备好两张清单——一张"正面词清单"、一张"负面词清单"——然后数一篇文本中正面词出现了多少次、负面词出现了多少次，据此计算一个情感得分。

$$
\text{情感得分} = \frac{\text{正面词数} - \text{负面词数}}{\text{总词数}}
$$

得分为正表示文本整体偏正面，为负表示偏负面，绝对值越大表示情感倾向越强。

这个方法虽然简单，但在实务中非常常用——它速度快、完全可解释（你可以精确地说出"这篇文本被判为正面，是因为出现了哪些正面词"）、不依赖任何标注数据，对大规模文本分析特别友好。

### 从两条新闻开始

我们用上一章准备好的素材④中最简单的两条新闻来演示：新闻 1（明确正面）和新闻 2（明确负面）。

```python
import pandas as pd

# 读取新闻数据（来自上一章的 create_text_samples.py 生成）
df_news = pd.read_csv("data_raw/news/news_samples.csv")

# 取出前两条：明确正面和明确负面
for _, row in df_news.head(2).iterrows():
    print(f"【新闻 {row['id']}】{row['label']}")
    print(f"标题：{row['title']}")
    print(f"正文：{row['text'][:80]}...")
    print()
```

先定义一个简单的正面词表和负面词表：

```python
# 一个极简的演示用情感词典（实际使用时会大得多）
positive_words = {
    "增长", "提升", "扩大", "强劲", "稳健", "改善", "突破",
    "买入", "上调", "充足", "领先", "优于", "上涨",
}

negative_words = {
    "下降", "下滑", "下调", "恶化", "违约", "暴跌", "压力",
    "风险", "不确定性", "亏损", "减持", "侵蚀", "疲软",
}
```

```python
import jieba

# 加载金融自定义词典（复用上一章的方法）
finance_terms = [
    "不良贷款率", "拨备覆盖率", "资产负债率", "存款准备金率",
    "风险管理", "市场份额", "信用评级", "融资成本",
]
for term in finance_terms:
    jieba.add_word(term)

def sentiment_score_dict(text, pos_words, neg_words):
    """
    用词典方法计算情感得分

    返回: (得分, 正面词列表, 负面词列表)
    """
    words = jieba.lcut(text)
    pos_found = [w for w in words if w in pos_words]
    neg_found = [w for w in words if w in neg_words]

    total = len(words)
    if total == 0:
        return 0.0, pos_found, neg_found

    score = (len(pos_found) - len(neg_found)) / total
    return round(score, 4), pos_found, neg_found

# 对两条新闻计算情感得分
for _, row in df_news.head(2).iterrows():
    score, pos, neg = sentiment_score_dict(row["text"], positive_words, negative_words)
    print(f"【新闻 {row['id']}】情感得分 = {score:+.4f}")
    print(f"  正面词({len(pos)}个): {pos}")
    print(f"  负面词({len(neg)}个): {neg}")
    print()
```

新闻 1（宁德时代业绩增长）的得分为正，新闻 2（房企违约）的得分为负——与直觉完全一致。而且你可以清楚地看到，每个得分背后是哪些词在起作用。

### 问题来了：通用词典在金融文本上的失效

上面的演示看起来很顺利，但那是因为新闻 1 和新闻 2 的情感信号非常强烈且明确。当我们遇到更微妙的文本时，问题就暴露出来了。

看新闻 3（招商银行不良贷款率下降）：

```python
row3 = df_news[df_news["id"] == 3].iloc[0]
print(f"【新闻 3】{row3['label']}")
print(f"标题：{row3['title']}")
print(f"正文：{row3['text']}")
```

这条新闻说的是招行资产质量改善、不良率下降、风险管理能力得到验证——从金融分析师的角度看，这是一条**明确的正面消息**。

但让我们看看词典方法怎么判断：

```python
score, pos, neg = sentiment_score_dict(row3["text"], positive_words, negative_words)
print(f"情感得分 = {score:+.4f}")
print(f"正面词({len(pos)}个): {pos}")
print(f"负面词({len(neg)}个): {neg}")
```

问题出现了：

- **"下降"**被标记为负面词——但"不良贷款率下降"是好消息
- **"风险"**被标记为负面词——但"风险管理能力得到验证"是正面评价
- **"改善"**被正确标记为正面词

正面词和负面词的数量可能差不多，导致得分接近于零甚至为负——一条明确的好消息被判为中性或负面。

现在再看新闻 4（某公司负债率攀升、财务费用大幅增长），一条**明确的负面消息**：

```python
row4 = df_news[df_news["id"] == 4].iloc[0]
score, pos, neg = sentiment_score_dict(row4["text"], positive_words, negative_words)
print(f"【新闻 4】{row4['label']}")
print(f"情感得分 = {score:+.4f}")
print(f"正面词({len(pos)}个): {pos}")
print(f"负面词({len(neg)}个): {neg}")
```

- **"增长"**被标记为正面词——但"财务费用大幅增长 45%"是坏消息
- **"提升"**被标记为正面词——但"不确定性正在提升"是负面信号
- **"扩张"**在通用语境下偏正面——但"高杠杆经营策略"暗示的是风险

得分可能偏正——一条明确的坏消息被判为正面。

::: {.callout-warning}
### 核心问题：同一个词在不同语境下的情感极性可以完全相反

| 词   | 通用词典判定 | 金融语境A（正面用法）    | 金融语境B（负面用法）    |
| ---- | ------------ | ------------------------ | ------------------------ |
| 下降 | 负面         | "不良贷款率**下降**" ✅   | "营业收入**下降**" ❌     |
| 增长 | 正面         | "净利润**增长** 35%" ✅   | "财务费用**增长** 45%" ❌ |
| 风险 | 负面         | "**风险**管理能力充足" ✅ | "面临较大**风险**" ❌     |
| 提升 | 正面         | "市场份额稳步**提升**" ✅ | "不确定性正在**提升**" ❌ |

这就是为什么 Loughran and McDonald（2011）要专门为金融文本构建领域词典——通用词典在金融语境下的误判率可以高达 70% 以上。
:::

新闻 3 和新闻 4 精确地展示了这个问题：它们是一组"镜像对比"——新闻 3 用了通用词典中的"负面词"来表达正面信息，新闻 4 用了"正面词"来表达负面信息。

### 金融领域情感词典

解决这个问题的思路是：**构建金融领域专用的情感词典**。

金融情感词典与通用词典的核心区别有三：

1. **移除金融语境下的中性词**：把"负债""成本""税""资本"等在金融文本中只是客观术语的词从负面词表中删除
2. **添加金融领域特有的情感词**：如"爆雷""踩踏""破净"（负面）、"超预期""龙头""护城河"（正面）
3. **标注语境依赖词**：把"下降""增长"等词标注为"语境依赖"——它们的极性取决于修饰的对象，不能一概而论

#### 中文金融情感词典的来源

目前中文金融情感词典的主要来源包括：

- **基于 Loughran-McDonald 词典的中文翻译/改编版**：学术论文中较常见，但因中英语言差异，直接翻译效果有限
- **大连理工大学情感词汇本体**：包含 7 个情感大类、21 个情感小类的中文情感词典，需要在此基础上做金融领域适配
- **学术论文公开的词典**：如用于分析中国上市公司年报的正负面词表
- **自建词典**：结合以上来源，通过人工审核和 LLM 辅助来构建

在本课程中，我们采用一种务实的方法：先用一个基础的中文金融情感词典，再用 LLM 辅助扩展和审核。

```python
# 金融领域情感词典（精简版，实际使用时应更完整）
fin_positive = {
    # 业绩类
    "增长", "盈利", "利润", "收益", "突破", "创新高",
    # 评价类
    "稳健", "强劲", "优于", "领先", "充足", "改善", "提质增效",
    # 市场类
    "买入", "上调", "增持", "上涨", "回暖", "复苏",
    # 公司治理类
    "护城河", "龙头", "先发优势", "高质量发展",
}

fin_negative = {
    # 业绩类
    "亏损", "下滑", "萎缩", "恶化", "承压", "侵蚀",
    # 风险类
    "违约", "爆雷", "暴跌", "踩踏", "减值",
    # 评价类
    "减持", "下调", "疲软", "低迷", "不及预期",
    # 流动性类
    "偿债压力", "流动性紧张", "资金链",
}

# 注意：以下词被有意排除——它们在金融语境下的极性取决于上下文
# "下降"：不良率下降=正面，营收下降=负面
# "增长"：利润增长=正面，费用增长=负面
# "风险"：风险管理能力=正面语境，面临风险=负面语境
# "提升"：市占率提升=正面，不确定性提升=负面
```

::: {.callout-tip}
### 提示词：构建/扩展金融情感词典

我正在分析中国上市公司的年报 MD&A 文本和财经新闻。现有一份基础的中文金融情感词典。请帮我：

1. 列出 20 个在金融语境下应为**正面**但在通用词典中可能被遗漏或标为负面的词，并附示例句
2. 列出 20 个在金融语境下应为**负面**但在通用词典中可能被遗漏或标为正面的词，并附示例句
3. 列出 10 个**语境依赖词**——在金融文本中，极性完全取决于修饰对象的词，并各给出一个正面用法和一个负面用法的示例句

请以如下格式输出每个词条：
词语 | 金融极性 | 示例句 | 说明
:::

现在用金融词典重新计算新闻 3 和新闻 4 的情感得分：

```python
print("=" * 60)
print("通用词典 vs 金融词典的对比")
print("=" * 60)

for news_id in [3, 4]:
    row = df_news[df_news["id"] == news_id].iloc[0]
    score_gen, pos_gen, neg_gen = sentiment_score_dict(
        row["text"], positive_words, negative_words
    )
    score_fin, pos_fin, neg_fin = sentiment_score_dict(
        row["text"], fin_positive, fin_negative
    )
    print(f"\n【新闻 {news_id}】真实标签：{row['label']}")
    print(f"  通用词典：得分={score_gen:+.4f}  正面词={pos_gen}  负面词={neg_gen}")
    print(f"  金融词典：得分={score_fin:+.4f}  正面词={pos_fin}  负面词={neg_fin}")
```

金融词典移除了"下降""风险"等语境依赖词，避免了误判。新闻 3 的得分应该更准确地反映其正面语气，新闻 4 的得分也应该更准确地反映其负面语气。

### 用年报 MD&A 做更深入的测试

新闻文本较短，让我们用更长、信息更丰富的年报 MD&A 片段来进一步验证。素材③中的三段 MD&A 覆盖了从乐观到悲观的完整语气光谱：

```python
import os

mda_dir = "data_raw/mda/"
mda_files = {
    "招商银行": "mda_招商银行_2023.txt",
    "中兴通讯": "mda_中兴通讯_2023.txt",
    "万科A":   "mda_万科A_2023.txt",
}

mda_labels = {
    "招商银行": "乐观",
    "中兴通讯": "中性",
    "万科A":   "悲观",
}

results = []

for company, filename in mda_files.items():
    with open(os.path.join(mda_dir, filename), "r", encoding="utf-8") as f:
        text = f.read()

    score_gen, pos_gen, neg_gen = sentiment_score_dict(
        text, positive_words, negative_words
    )
    score_fin, pos_fin, neg_fin = sentiment_score_dict(
        text, fin_positive, fin_negative
    )

    results.append({
        "公司": company,
        "预期语气": mda_labels[company],
        "通用词典得分": score_gen,
        "金融词典得分": score_fin,
        "通用-正面词数": len(pos_gen),
        "通用-负面词数": len(neg_gen),
        "金融-正面词数": len(pos_fin),
        "金融-负面词数": len(neg_fin),
    })

df_results = pd.DataFrame(results)
print(df_results.to_string(index=False))
```

预期结果：
- **招商银行**（乐观）：金融词典得分应该是三者中最高的正值
- **中兴通讯**（中性）：得分应该接近零
- **万科A**（悲观）：得分应该是三者中最低的负值

如果通用词典对招商银行的判断偏低（因为"不良""风险"等词被误判为负面），而金融词典修正了这个偏差，那就验证了我们的核心论点：**金融文本分析需要领域适配的词典**。

::: {.callout-note}
### 词典方法的边界

即便使用了金融专用词典，词典方法仍有其本质局限：

1. **无法处理否定句**："公司**不存在**违约风险"——"违约"和"风险"都会被计为负面词，但整句是正面的
2. **无法处理程度差异**："小幅增长"和"大幅增长"在词典法中贡献相同的正面得分
3. **无法处理混合情感**：一段文本中正面和负面信息并存时，词典法只能给出一个净得分，丢失了"既有好消息也有坏消息"的结构信息

这些局限正是后续机器学习方法和 LLM 方法要解决的问题。
:::

### 实操：央行货币政策报告的情感得分

现在我们把词典方法应用到一个有实际意义的场景：对素材②中的 4 段央行货币政策执行报告计算情感得分，观察不同政策时期的语气变化。

```python
import os

pboc_dir = "data_raw/pboc_reports/"
pboc_files = {
    "2020Q1（宽松）": "pboc_2020Q1.txt",
    "2017Q4（偏紧）": "pboc_2017Q4.txt",
    "2023Q4（中性偏松）": "pboc_2023Q4.txt",
    "2022Q2（中性偏紧）": "pboc_2022Q2.txt",
}

pboc_results = []

for label, filename in pboc_files.items():
    with open(os.path.join(pboc_dir, filename), "r", encoding="utf-8") as f:
        text = f.read()

    score, pos, neg = sentiment_score_dict(text, fin_positive, fin_negative)

    pboc_results.append({
        "报告期": label,
        "情感得分": score,
        "正面词数": len(pos),
        "负面词数": len(neg),
        "正面词示例": pos[:5],
        "负面词示例": neg[:5],
    })

df_pboc = pd.DataFrame(pboc_results)
print(df_pboc[["报告期", "情感得分", "正面词数", "负面词数"]].to_string(index=False))
```

预期结果：

- **2020Q1（宽松）**：情感得分最高——"充裕""降低""支持"等宽松信号词密集出现
- **2017Q4（偏紧）**：情感得分最低——"防范""杠杆""遏制"等收紧信号词密集出现
- **2023Q4** 和 **2022Q2** 的得分应处于中间，且 2023Q4（偏松）的得分略高于 2022Q2（偏紧）

```python
import matplotlib.pyplot as plt

fig, ax = plt.subplots(figsize=(8, 4))

# 按时间顺序排列
order = ["2017Q4（偏紧）", "2020Q1（宽松）", "2022Q2（中性偏紧）", "2023Q4（中性偏松）"]
df_plot = df_pboc.set_index("报告期").loc[order].reset_index()

colors = ["#d62728", "#2ca02c", "#ff7f0e", "#1f77b4"]
ax.bar(df_plot["报告期"], df_plot["情感得分"], color=colors, width=0.6)

ax.axhline(y=0, color="gray", linestyle="--", linewidth=0.8)
ax.set_title("央行货币政策执行报告情感得分（词典法）", fontsize=13)
ax.set_ylabel("情感得分")
ax.tick_params(axis="x", rotation=15)
ax.grid(True, alpha=0.3, axis="y")

plt.tight_layout()
plt.show()
```

如果柱形图的高度排列与政策松紧方向一致（宽松期得分高、紧缩期得分低），说明即使是简单的词典方法，也能在一定程度上捕捉央行报告的政策信号。这将为下一章综合案例（构建完整的央行语气指数时序）打下基础。

::: {.callout-tip}
### 提示词：对一批文本批量计算情感得分

我有一个 DataFrame `df`，其中 `text` 列包含已分词的金融文本（词之间用空格分隔）。
我有两个情感词典文件：`pos_words.txt` 和 `neg_words.txt`，每行一个词。

请帮我：
1. 读取两个词典文件，加载为 set
2. 对 `df` 中每条文本，计算：
   - `pos_count`：正面词命中数
   - `neg_count`：负面词命中数
   - `sentiment_score`：(pos_count - neg_count) / 总词数
   - `pos_words_found`：命中的正面词列表
   - `neg_words_found`：命中的负面词列表
3. 将结果添加为 `df` 的新列
4. 输出情感得分的描述性统计（均值、中位数、标准差、最小值、最大值）
5. 绘制情感得分的直方图
:::

---

## 本节小结

本节介绍了文本情感分析的第一种方法——情感词典法。核心要点：

1. **词典法的原理**：数正面词和负面词，计算净得分。简单、快速、完全可解释。
2. **金融领域必须用专用词典**：通用词典在金融文本上的误判率极高——"负债""风险""下降"等词的极性在金融语境下往往与通用语境相反。
3. **词典法的局限**：无法处理否定句、程度差异和混合情感。

下一节将介绍机器学习文本分类方法——通过训练数据让算法自己"学会"判断情感极性，从而突破词典法的部分局限。


---


好的，接下来撰写下册第 2 节（机器学习文本分类）和第 3 节（大语言模型应用 + 三种方法对比）。

---

## 机器学习文本分类

词典方法虽然简单可解释，但它本质上是一种"硬匹配"——词表里有的才算，没有的就忽略。如果一篇文本用了词典中没有收录的表达方式来传达负面情绪（比如"公司将继续以'活下去'为首要目标"），词典法就完全捕捉不到。

机器学习的思路完全不同：**你不需要预先定义哪些词是正面、哪些是负面，而是给算法一批已经标注好情感标签的文本，让它自己从数据中"学会"判断规则。**

### 文本分类的基本框架

```
标注数据（文本 + 情感标签）
  │
  ▼
文本向量化：把文字变成数字矩阵
  │
  ▼
拆分训练集 / 测试集
  │
  ▼
训练分类模型（朴素贝叶斯 / 逻辑回归）
  │
  ▼
在测试集上评估效果
  │
  ▼
对新文本做预测
```

这个流程中，最关键的一步是**文本向量化**——把人类能读懂的文字，转换成机器能处理的数字。

### 文本向量化：从文字到数字

机器学习模型只认识数字，不认识汉字。所以在送入模型之前，必须把每篇文本转化为一个数值向量。上一章介绍的 TF-IDF 正好可以完成这个任务 [1]。

直觉是这样的：假设我们的词汇表中有 5000 个词，那么每篇文本就可以表示为一个 5000 维的向量——每个维度对应一个词，值为该词在这篇文本中的 TF-IDF 得分。如果这个词没有出现，对应位置就是 0。

```python
from sklearn.feature_extraction.text import TfidfVectorizer

# 用素材④的 6 条新闻做演示
# 先将新闻正文做分词，用空格连接（复用上一章的 preprocess 函数）
corpus = []
labels = []

for _, row in df_news.iterrows():
    words = preprocess_chinese_text(row["text"], stopwords=basic_stopwords)
    corpus.append(" ".join(words))
    # 简化标签：只取"正面""负面""中性""混合"
    if "正面" in row["label"]:
        labels.append(1)
    elif "负面" in row["label"]:
        labels.append(0)
    else:
        labels.append(2)  # 中性/混合

# TF-IDF 向量化
vectorizer = TfidfVectorizer(max_features=500)
X = vectorizer.fit_transform(corpus)

print(f"文档数量: {X.shape[0]}")
print(f"特征维度: {X.shape[1]}")
print(f"矩阵密度: {X.nnz / (X.shape[0] * X.shape[1]):.2%}")
```

`X` 是一个稀疏矩阵——大部分位置是 0（因为每篇文本只用了词汇表中的一小部分词），只在出现过的词对应的位置有非零值。这种稀疏表示在存储和计算上都很高效。

### 训练分类模型

有了数值化的文本特征 `X` 和对应的标签 `labels`，就可以训练分类模型了。这里介绍两种最经典的文本分类模型：

- **朴素贝叶斯（Naive Bayes）**：文本分类的经典 baseline。它假设每个词的出现是独立的（这个假设在现实中不成立，但效果出奇地好），根据贝叶斯定理计算"给定这些词出现的情况下，文本属于正面/负面的概率"。
- **逻辑回归（Logistic Regression）**：为每个词分配一个权重，权重为正的词倾向于让文本被判为正面，为负的词倾向于负面。权重可以直接解释——你能看到哪些词对分类贡献最大。

素材④只有 6 条新闻，不足以训练一个可靠的模型。在实际应用中，通常需要至少几百条标注数据。下面我们用一个公开的中文财经新闻情感标注数据集来演示完整流程：

```python
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, confusion_matrix

# ── 加载数据 ─────────────────────────────────────
# 假设已有一份标注好的财经新闻数据集
# 列: text_tokenized(已分词,空格分隔), label(1=正面, 0=负面)
# 实际使用时,可从课程 GitHub 仓库下载:
# url = "https://raw.githubusercontent.com/lianxhcn/dsfin/main/data/fin_news_sentiment.csv"
# df_labeled = pd.read_csv(url)

# 这里用模拟数据展示流程框架
# df_labeled = pd.read_csv("data_raw/fin_news_sentiment.csv")
# corpus = df_labeled["text_tokenized"].tolist()
# labels = df_labeled["label"].tolist()

# ── 向量化 ─────────────────────────────────────
vectorizer = TfidfVectorizer(max_features=5000)
X = vectorizer.fit_transform(corpus)
y = labels

# ── 拆分训练集和测试集 ──────────────────────────
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)
print(f"训练集: {X_train.shape[0]} 条, 测试集: {X_test.shape[0]} 条")

# ── 训练模型 ──────────────────────────────────────
# 模型一: 朴素贝叶斯
nb_model = MultinomialNB()
nb_model.fit(X_train, y_train)
y_pred_nb = nb_model.predict(X_test)

# 模型二: 逻辑回归
lr_model = LogisticRegression(max_iter=1000, random_state=42)
lr_model.fit(X_train, y_train)
y_pred_lr = lr_model.predict(X_test)

# ── 评估 ──────────────────────────────────────────
print("=" * 50)
print("朴素贝叶斯分类报告:")
print(classification_report(y_test, y_pred_nb, target_names=["负面", "正面"]))

print("=" * 50)
print("逻辑回归分类报告:")
print(classification_report(y_test, y_pred_lr, target_names=["负面", "正面"]))
```

### 评估指标：怎么判断模型好不好？

分类报告中有四个核心指标：

| 指标                    | 含义                                 | 直觉理解                     |
| ----------------------- | ------------------------------------ | ---------------------------- |
| **准确率（Accuracy）**  | 所有预测中，猜对的比例               | 最直观，但样本不均衡时会误导 |
| **精确率（Precision）** | 被判为正面的文本中，真正是正面的比例 | "模型说是正面的，有多靠谱？" |
| **召回率（Recall）**    | 所有正面文本中，被模型正确识别的比例 | "正面文本有多少被遗漏了？"   |
| **F1 值**               | 精确率和召回率的调和平均             | 综合衡量，两者兼顾           |

### 逻辑回归的可解释性：哪些词最重要？

逻辑回归的一个重要优势是可解释性——它为每个词分配了一个权重，权重的绝对值越大、符号为正/负，说明这个词对正面/负面分类的贡献越大。

```python
import numpy as np

# 获取特征名（词）和对应的权重
feature_names = vectorizer.get_feature_names_out()
weights = lr_model.coef_[0]

# 找出权重最高的 10 个正面词和 10 个负面词
top_pos_idx = np.argsort(weights)[-10:][::-1]
top_neg_idx = np.argsort(weights)[:10]

print("【逻辑回归认为最"正面"的 10 个词】")
for i in top_pos_idx:
    print(f"  {feature_names[i]}: {weights[i]:+.4f}")

print("\n【逻辑回归认为最"负面"的 10 个词】")
for i in top_neg_idx:
    print(f"  {feature_names[i]}: {weights[i]:+.4f}")
```

这个输出非常有价值——它等于让机器自动"发现"了金融文本中的情感信号词，可以与人工构建的情感词典做交叉验证。如果模型发现了词典中没有收录的重要情感词，说明词典还有改进空间。

::: {.callout-tip}
### 提示词：文本分类模型训练

我有一个 DataFrame `df`，包含两列：`text`（已分词的财经新闻文本，词之间用空格分隔）和 `label`（情感标签：1=正面，0=负面）。共约 5000 条。

请帮我：
1. 用 TfidfVectorizer（max_features=5000）将文本向量化
2. 按 8:2 比例拆分训练集和测试集（random_state=42）
3. 分别训练朴素贝叶斯和逻辑回归分类器
4. 输出两个模型的分类报告（classification_report）和混淆矩阵
5. 对逻辑回归模型，输出权重最高的 10 个正面词和 10 个负面词
6. 绘制两个模型的混淆矩阵热力图（并排显示）
:::

---

## 大语言模型（LLM）在金融文本分析中的应用

2023 年以来，大语言模型（GPT-4、DeepSeek、文心一言等）已经深刻改变了文本分析的实践方式。对于金融文本分析，LLM 最突出的优势是：**不需要标注数据，不需要训练模型，不需要构建词典——只需要设计好提示词，就能对任意文本做情感判断。**

### LLM 做情感分析：零样本分类

"零样本"的意思是：模型此前没有看过任何你的标注数据，完全依靠预训练阶段积累的语言理解能力来判断情感。

我们用素材⑥中的研报摘要来演示。先看中兴通讯的"中性"评级研报——这是前面说过的"词典法最容易误判"的文本类型：

```python
import os

# 读取研报文本
with open("data_raw/analyst_reports/report_中兴通讯_中性.txt", "r", encoding="utf-8") as f:
    report_text = f.read()

print(report_text[:200])
print("...")
```

这篇研报表面上看不到强烈的负面词——"基本符合""值得关注""正在逐步贡献"甚至有些偏正面。但实际信号是明确偏负面的：下调盈利预测、下调目标价、"增长压力短期内难以缓解""上行催化剂有限"。

让我们看看 LLM 能否识别这种含蓄的负面语气：

::: {.callout-tip}
### 提示词：LLM 零样本情感分析

你是一位资深金融分析师。请对以下券商研究报告摘要进行情感分析。

评估维度：
1. **整体情感倾向**：正面 / 中性 / 负面
2. **情感强度**：1-5 分（1=微弱，5=强烈）
3. **主要情感驱动因素**：列出 3 个最关键的判断依据，引用原文
4. **表面语气 vs 实际信号**：如果文本的表面措辞与实际传达的信号不一致，请指出

文本：
{report_text}

请以 JSON 格式输出结果。
:::

```
# LLM 的典型输出（示例）
{
    "overall_sentiment": "负面",
    "intensity": 3,
    "key_drivers": [
        "下调盈利预测至65/72亿元（前值70/78亿元）",
        "下调目标价至28元（前值32元）",
        "增长压力短期内难以缓解，上行催化剂有限"
    ],
    "surface_vs_signal": "表面措辞相对温和（'基本符合预期''值得关注'），
                          但实际传达的信号是负面的：盈利预测和目标价均被下调，
                          维持'中性'评级本身在卖方语境下就暗示看淡。
                          '上行催化剂有限'是分析师委婉表达'看不到股价上涨理由'的标准用语。"
}
```

注意 LLM 在"表面语气 vs 实际信号"这一项上的分析——它不仅识别了负面信号，还解释了卖方研报中"中性评级"的言外之意。**这种语义层面的深度理解是词典法和简单机器学习模型都无法做到的。**

### LLM 做文本摘要：按框架提取要点

除了情感分析，LLM 另一个高频应用场景是**结构化摘要**——让 LLM 按照你指定的框架，从长文本中提取关键信息。

我们用素材⑤中的问询函（关联交易）来演示：

```python
with open("data_raw/inquiry_letters/inquiry_关联交易.txt", "r", encoding="utf-8") as f:
    inquiry_text = f.read()

print(f"文本长度: {len(inquiry_text)} 字")
```

::: {.callout-tip}
### 提示词：LLM 结构化摘要

你是上市公司信息披露审核专家。请对以下交易所问询函及公司回复进行结构化分析。

请按以下框架输出：

1. **核心问题**：交易所关注的核心风险点是什么？（1-2 句话）
2. **公司回应要点**：
   - 关联交易增长的原因（列出具体金额和事项）
   - 定价公允性的论证方式（对比了哪些非关联方价格？）
3. **论证充分性评估**：
   - 公司的论证是否充分？有哪些薄弱环节？
   - 对比样本是否足够？（仅对比了 1-2 家非关联方是否充分？）
   - 工程类交易和材料采购的可比性是否相同？
4. **风险提示**：投资者/监管机构应关注的后续风险

文本：
{inquiry_text}
:::

这种结构化摘要在金融实务中极有价值——分析师需要快速阅读大量问询函，按统一框架提取关键信息并形成判断。LLM 可以将一份 2000 字的问询函压缩为 300 字的结构化摘要，且自动标注论证的薄弱环节。

### 新闻 5 的混合情感：LLM 的核心优势场景

回到素材④中的新闻 5（央行降准），这是我们在词典方法部分提到的"混合情感"文本——正面政策信号与负面经济暗示并存。让我们用三种方法分别处理，直接对比结果：

```python
row5 = df_news[df_news["id"] == 5].iloc[0]
print(f"【新闻 5】{row5['title']}")
print(f"正文: {row5['text']}")
```

**方法一：词典法**

```python
score_fin, pos_fin, neg_fin = sentiment_score_dict(
    row5["text"], fin_positive, fin_negative
)
print(f"\n词典法结果:")
print(f"  情感得分 = {score_fin:+.4f}")
print(f"  正面词: {pos_fin}")
print(f"  负面词: {neg_fin}")
print(f"  判断: {'正面' if score_fin > 0 else '负面' if score_fin < 0 else '中性'}")
```

词典法数出差不多数量的正面词和负面词，给出接近零的得分——它把一条信息量丰富的新闻判成了"中性"，丢失了"既有好消息也有坏消息"的结构信息。

**方法二：机器学习（逻辑回归）**

```python
# 对新闻5做向量化和预测
text5_tokenized = " ".join(preprocess_chinese_text(row5["text"], stopwords=basic_stopwords))
X5 = vectorizer.transform([text5_tokenized])
pred5 = lr_model.predict(X5)[0]
prob5 = lr_model.predict_proba(X5)[0]

print(f"\n逻辑回归结果:")
print(f"  预测类别: {'正面' if pred5 == 1 else '负面'}")
print(f"  预测概率: 负面={prob5[0]:.2%}, 正面={prob5[1]:.2%}")
```

机器学习给出了一个二分类的判断和概率——比词典法多了一个"置信度"的信息，但仍然无法表达"混合情感"的复杂结构。

**方法三：LLM**

::: {.callout-tip}
### 提示词（对新闻 5）

你是一位资深金融分析师。请对以下财经新闻进行情感分析。

评估维度：
1. 整体情感倾向：正面 / 中性 / 负面 / 混合
2. 情感强度：1-5 分
3. 如果是"混合"情感，请分别说明正面和负面信号各是什么
4. 市场参与者（股票投资者 vs 债券投资者）对这条新闻的解读是否可能不同？

文本：{row5["text"]}
:::

```
# LLM 的典型输出（示例）
{
    "overall_sentiment": "混合",
    "intensity": 3,
    "positive_signals": [
        "降准释放1万亿长期资金，直接利好实体经济融资成本降低",
        "政策层面释放稳增长信号，表明决策层关注经济下行风险"
    ],
    "negative_signals": [
        "降准本身暗示经济下行压力较大，需要逆周期调节来托底",
        "A股市场反应平淡，说明市场可能已对宽松政策脱敏"
    ],
    "market_divergence": "股票投资者可能偏中性（利好已被预期消化，
        且降准暗示基本面不佳）；债券投资者偏正面（流动性宽松直接
        利好债市，'小幅走强'证实了这一点）。"
}
```

**LLM 的输出比前两种方法丰富得多：** 它不仅识别了混合情感，还分别列出了正面和负面信号，甚至指出了不同市场参与者的解读差异。这种多层次的分析输出，是词典法和机器学习都无法提供的。

### 三种方法的全面比较

::: {.callout-note}
### 情感分析三种方法对比

| 维度                    | 词典方法               | 机器学习               | LLM                      |
| ----------------------- | ---------------------- | ---------------------- | ------------------------ |
| **是否需要标注数据**    | 不需要（需要词典）     | 需要（通常 500+ 条）   | 不需要                   |
| **是否需要训练**        | 不需要                 | 需要                   | 不需要                   |
| **可解释性**            | 高（精确到每个词）     | 中（可看权重）         | 低（黑盒判断）           |
| **处理速度**            | 极快（毫秒级）         | 快（毫秒级）           | 慢（秒级/条）            |
| **API 成本**            | 免费                   | 免费                   | 付费（按 token）         |
| **处理否定句**          | ❌ 无法                 | ⚠️ 有限                 | ✅ 可以                   |
| **处理混合情感**        | ❌ 只能给净得分         | ❌ 只能给单一标签       | ✅ 可以分层描述           |
| **处理隐含语气**        | ❌ 无法                 | ⚠️ 有限                 | ✅ 可以                   |
| **适应新领域**          | 需要新词典             | 需要新标注数据         | 修改提示词即可           |
| **大规模处理（>万条）** | ✅ 首选                 | ✅ 适合                 | ⚠️ 成本高、速度慢         |
| **适用场景**            | 大规模、可解释性要求高 | 有标注数据时的最佳选择 | 小规模、探索性、复杂任务 |
:::

::: {.callout-note}
### 实务建议：三种方法是互补的，不是替代的

在真实项目中，最有效的策略通常是**组合使用**三种方法：

1. **先用 LLM 在小样本（50-100 条）上探索**，确认任务可行性，了解文本的情感分布和常见模式
2. **用 LLM 的输出作为标注数据**，训练轻量级的机器学习模型，用于大规模处理
3. **用词典方法作为 baseline 和可解释性补充**——当机器学习模型的判断与词典方法不一致时，重点检查这些样本
4. **用 LLM 处理机器学习模型"不确定"的样本**——预测概率接近 50% 的文本，交给 LLM 做更精细的判断
:::

---

## 文本指标的应用：纳入量化分析框架

到目前为止，我们已经学会了三种量化文本情感的方法。但情感得分本身不是目的——它的价值在于**作为变量纳入金融分析框架**，回答具体的研究或业务问题。

### 从情感得分到分析变量

文本分析输出的指标，可以像财务比率一样作为自变量或因变量纳入回归模型。常见的文本变量包括：

| 变量名            | 构建方式                 | 研究场景                           |
| ----------------- | ------------------------ | ---------------------------------- |
| `sentiment_score` | 年报 MD&A 的情感得分     | 语气乐观的公司，未来业绩更好吗？   |
| `tone_change`     | 相邻两期情感得分之差     | 语气突然转负，是否预示风险？       |
| `risk_word_ratio` | 风险相关词汇占总词数比例 | 风险披露越多的公司，违约率越低吗？ |
| `policy_hawkish`  | 央行报告的"鹰派"程度     | 央行转鹰，债券市场如何反应？       |

### 应用示例：年报语气与公司表现

一个典型的研究设计是：用年报 MD&A 的情感得分预测公司下一年的财务表现。

```python
# 构建回归数据
# 假设 df_mda_scores 包含每家公司每年的 MD&A 情感得分
# df_fin 包含财务数据（来自数据清洗章的 FinRatio）

df_reg = pd.merge(
    df_mda_scores[["stkcd", "year", "sentiment_score"]],
    df_fin[["stkcd", "year", "ROA", "Leverage", "Size"]],
    on=["stkcd", "year"]
)

# 构建下一年的 ROA 作为被解释变量
df_reg["ROA_next"] = df_reg.groupby("stkcd")["ROA"].shift(-1)

# OLS 回归
import statsmodels.formula.api as smf
model = smf.ols("ROA_next ~ sentiment_score + Leverage + Size", data=df_reg).fit()
print(model.summary())
```

如果 `sentiment_score` 的系数显著为正，说明年报语气越乐观的公司，下一年的 ROA 越高——文本信息包含了财务报表无法完全反映的预测力。

::: {.callout-warning}
### 文本变量的内生性问题

年报语气与公司表现之间的相关性，不能直接解释为因果关系。好的公司本来就会在年报中写出更乐观的语气——这属于数据清洗章讨论的"自选择偏误"问题 [1]。

例如，"年报语气乐观 → 未来业绩好"和"公司本身有实力 → 同时导致语气乐观和业绩好"是完全不同的因果链条。在实际研究中，需要借助工具变量、事件研究等因果推断方法来处理这一问题。
:::

---

## 综合案例：央行货币政策语气指数的构建与应用

本章最后，我们把前面学到的所有方法串联起来，完成一个有实际意义的综合案例：**从央行货币政策执行报告的文本出发，构建一个"货币政策语气指数"，然后分析它与市场利率的关系。**

### Step 1：预处理（复用上一章方法）

```python
import os
import jieba

pboc_dir = "data_raw/pboc_reports/"
pboc_files = {
    "2017Q4": "pboc_2017Q4.txt",
    "2020Q1": "pboc_2020Q1.txt",
    "2022Q2": "pboc_2022Q2.txt",
    "2023Q4": "pboc_2023Q4.txt",
}

pboc_texts = {}
pboc_tokenized = {}

for period, filename in pboc_files.items():
    with open(os.path.join(pboc_dir, filename), "r", encoding="utf-8") as f:
        text = f.read()
    pboc_texts[period] = text
    # 分词（使用金融自定义词典）
    words = preprocess_chinese_text(text, stopwords=basic_stopwords, remove_numbers=True)
    pboc_tokenized[period] = words

print("预处理完成:")
for period, words in pboc_tokenized.items():
    print(f"  {period}: {len(words)} 个词")
```

### Step 2：方法一——情感词典法

```python
dict_results = {}

for period, text in pboc_texts.items():
    score, pos, neg = sentiment_score_dict(text, fin_positive, fin_negative)
    dict_results[period] = {
        "score": score,
        "pos_count": len(pos),
        "neg_count": len(neg),
    }

df_dict = pd.DataFrame(dict_results).T
df_dict.index.name = "period"
print("词典法结果:")
print(df_dict)
```

### Step 3：方法二——机器学习法

对于只有 4 份报告的情况，严格的机器学习训练不现实（样本太少）。但可以采用一种折中策略：先人工标注这 4 份报告的语气评分（1-5 分，1=最紧，5=最松），然后用 TF-IDF 特征训练一个简单的线性回归模型，输出连续的语气得分。

```python
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LinearRegression

# 人工标注（基于对政策背景的了解）
manual_labels = {
    "2017Q4": 1.5,   # 明确偏紧（去杠杆）
    "2020Q1": 4.5,   # 明确宽松（疫情冲击）
    "2022Q2": 2.5,   # 中性偏紧（关注通胀）
    "2023Q4": 3.5,   # 中性偏松（稳增长）
}

# TF-IDF 向量化
corpus_pboc = [" ".join(pboc_tokenized[p]) for p in pboc_files.keys()]
tfidf = TfidfVectorizer(max_features=200)
X_pboc = tfidf.fit_transform(corpus_pboc)
y_pboc = [manual_labels[p] for p in pboc_files.keys()]

# 线性回归（样本量极小，仅作演示）
lr = LinearRegression()
lr.fit(X_pboc, y_pboc)
y_pred_ml = lr.predict(X_pboc)

ml_results = {p: round(pred, 2) for p, pred in zip(pboc_files.keys(), y_pred_ml)}
print("机器学习法结果:", ml_results)
```

::: {.callout-warning}
### 注意：这里用全部样本做训练和预测，仅作流程演示

在真实研究中，4 个样本不足以训练任何可靠的机器学习模型。当报告数量增加到 40-60 份时（2010-2024 年的季度报告），可以做合理的训练/测试拆分。这里的目的是展示方法流程，而非获得可靠的预测结果。
:::

### Step 4：方法三——LLM 零样本分析

::: {.callout-tip}
### 提示词：LLM 分析央行报告语气

你是中国宏观经济和货币政策分析专家。请对以下央行货币政策执行报告片段进行政策语气分析。

评估维度：
1. **货币政策倾向**：1-5 分（1=强烈紧缩，3=中性，5=强烈宽松）
2. **关键判断依据**：列出 3 个最重要的政策信号词或表述，引用原文
3. **相比"中性基准"的偏离方向和程度**

请对以下 4 段报告逐一分析，以 JSON 数组格式输出。

报告 1（2017Q4）：{pboc_texts["2017Q4"]}
报告 2（2020Q1）：{pboc_texts["2020Q1"]}
报告 3（2022Q2）：{pboc_texts["2022Q2"]}
报告 4（2023Q4）：{pboc_texts["2023Q4"]}
:::

```python
# LLM 典型输出（示例）
llm_results = {
    "2017Q4": 1.5,   # "去杠杆不动摇""遏制隐性债务""抬升利率中枢"
    "2020Q1": 4.5,   # "加大逆周期调节""保持合理充裕""降低融资成本"
    "2022Q2": 2.5,   # "不搞大水漫灌""密切关注物价""不超发货币"
    "2023Q4": 3.5,   # "灵活适度""加大信贷支持""合理把握节奏"
}
```

### Step 5：三种方法比较

```python
import matplotlib.pyplot as plt

# 汇总三种方法的结果
periods = list(pboc_files.keys())
time_order = ["2017Q4", "2020Q1", "2022Q2", "2023Q4"]

# 标准化到同一量纲（0-1 范围）用于对比
def normalize(values):
    vmin, vmax = min(values), max(values)
    if vmax == vmin:
        return [0.5] * len(values)
    return [(v - vmin) / (vmax - vmin) for v in values]

dict_scores = normalize([df_dict.loc[p, "score"] for p in time_order])
ml_scores = normalize([ml_results[p] for p in time_order])
llm_scores = normalize([llm_results[p] for p in time_order])

fig, ax = plt.subplots(figsize=(9, 4))

x = range(len(time_order))
width = 0.25

ax.bar([i - width for i in x], dict_scores, width, label="词典法", color="steelblue")
ax.bar(x, ml_scores, width, label="机器学习", color="tomato")
ax.bar([i + width for i in x], llm_scores, width, label="LLM", color="seagreen")

ax.set_xticks(x)
ax.set_xticklabels(time_order)
ax.set_ylabel("语气指数（标准化 0-1）")
ax.set_title("央行报告语气指数：三种方法对比", fontsize=13)
ax.legend()
ax.grid(True, alpha=0.3, axis="y")

plt.tight_layout()
plt.show()
```

如果三条柱形图的高低排列一致（2020Q1 最高、2017Q4 最低），说明三种方法虽然原理不同，但在方向上达成了共识——央行报告中确实存在可以被算法捕捉的政策信号。

### Step 6：语气指数与市场利率的关联分析

最后，我们把语气指数与 Shibor 利率做对比，观察二者是否存在协同变化。Shibor 数据的获取方法在数据获取章已经介绍过 [2]。

```python
import akshare as ak

# 获取 3 个月期 Shibor 数据（复用数据获取章的方法 [2]）
df_shibor = ak.rate_interbank(
    market    = "上海银行同业拆借市场",
    symbol    = "Shibor人民币",
    indicator = "3月"
)

# 计算每个报告期对应季度的 Shibor 均值
# （此处为简化演示，使用季度末的值）
shibor_values = {
    "2017Q4": 4.89,   # 2017年12月均值
    "2020Q1": 2.14,   # 2020年3月均值
    "2022Q2": 2.28,   # 2022年6月均值
    "2023Q4": 2.55,   # 2023年12月均值
}

# 绘制对比图
fig, ax1 = plt.subplots(figsize=(9, 4))

# 左轴：语气指数（使用 LLM 的结果作为代表）
color1 = "steelblue"
ax1.plot(time_order, [llm_results[p] for p in time_order],
         "o-", color=color1, linewidth=2, markersize=8, label="语气指数（LLM）")
ax1.set_ylabel("语气指数（1=紧缩，5=宽松）", color=color1)
ax1.tick_params(axis="y", labelcolor=color1)

# 右轴：Shibor 利率
ax2 = ax1.twinx()
color2 = "tomato"
ax2.plot(time_order, [shibor_values[p] for p in time_order],
         "s--", color=color2, linewidth=2, markersize=8, label="Shibor 3M")
ax2.set_ylabel("Shibor 3个月（%）", color=color2)
ax2.tick_params(axis="y", labelcolor=color2)

ax1.set_title("央行报告语气指数 vs Shibor 3个月利率", fontsize=13)
ax1.grid(True, alpha=0.3)

# 合并图例
lines1, labels1 = ax1.get_legend_handles_labels()
lines2, labels2 = ax2.get_legend_handles_labels()
ax1.legend(lines1 + lines2, labels1 + labels2, loc="upper right")

plt.tight_layout()
plt.show()
```

预期结果：语气指数与 Shibor 应呈现**负相关**——央行语气越宽松（指数越高），市场利率越低。2020Q1 语气最宽松、Shibor 最低；2017Q4 语气最紧、Shibor 最高。这种负相关关系验证了文本分析捕捉到的政策信号与实际市场走势是一致的。

::: {.callout-note}
### 从 4 期到 40 期：这个案例的扩展方向

本案例使用了 4 段虚构的央行报告片段做演示。如果要构建一个真正可用的货币政策语气指数时序，需要：

1. **扩大样本**：收集 2010-2024 年所有季度的货币政策执行报告（约 60 份），每份提取"下一阶段主要政策思路"部分
2. **完善词典**：基于 60 份报告的全量文本，用 TF-IDF 识别高区分度的政策信号词，扩充金融情感词典
3. **方法融合**：对 60 期报告分别用三种方法计算语气得分，取加权平均或以 LLM 为主
4. **时序分析**：将语气指数与 Shibor（日频→季度均值）做格兰杰因果检验（Granger Causality Test），判断语气变化是否领先于利率变化

这些扩展超出了本章的范围，但提供了一个明确的研究路径。
:::

---

## 本章小结

本章介绍了金融文本情感分析的三种方法，核心内容可以用下图概括：

```
金融文本
  │
  ├─→ 情感词典法
  │     - 优势：快速、可解释、免费
  │     - 局限：无法处理否定句和混合情感
  │     - 关键：必须使用金融领域专用词典
  │
  ├─→ 机器学习分类
  │     - 优势：从数据中学习，适应性强
  │     - 局限：需要标注数据
  │     - 关键：逻辑回归的权重可解释
  │
  └─→ 大语言模型（LLM）
        - 优势：零样本、理解语义、输出丰富
        - 局限：速度慢、成本高、不可解释
        - 关键：提示词设计决定输出质量
              │
              ▼
      情感得分 / 语气指数
              │
              ▼
      纳入量化分析框架
      （回归分析 / 时序对比 / 策略信号）
```

**关键要点：**

1. **金融文本分析必须领域适配**——通用词典在金融语境下的误判率极高
2. **三种方法互补**——词典法适合大规模处理，ML 适合有标注数据的场景，LLM 适合小规模复杂任务
3. **文本指标有实际分析价值**——可以作为变量纳入回归模型，捕捉财务报表无法反映的信息
4. **注意内生性**——文本语气与结果之间的相关性不等于因果关系

---

### 章末练习

1. **基础题：** 使用本章提供的金融情感词典，对素材③的三段年报 MD&A 分别计算情感得分，绘制三家公司的得分对比柱形图。结果是否与你的直觉一致？

2. **应用题：** 对素材④的 6 条财经新闻，分别用词典法和 LLM 进行情感分析，将结果整理为 DataFrame 进行对比。在哪些新闻上两种方法给出了不同的判断？原因是什么？

3. **应用题：** 选取素材⑥的 3 条研报摘要，使用 LLM 提示词提取以下结构化信息：评级、目标价、盈利预测、核心逻辑。将结果整理为 DataFrame。

4. **综合题：** 设计一个完整的"上市公司年报语气与股票收益"的分析方案。从数据获取到最终的回归分析，画出流程图，列出每个步骤需要的工具和方法，并讨论可能面临的内生性挑战。

5. **思考题：** 某基金经理想用雪球/东方财富股吧的散户评论来构建"市场情绪指数"，用于预测短期股价走势。请从以下三个角度分析这一策略可能面临的挑战：(a) 数据质量（水军、广告、情绪极端化）；(b) 样本选择（发帖的人 vs 不发帖的人）；(c) 因果关系（是情绪驱动了股价，还是股价变化引发了情绪？）。

---

### 参考文献

* Loughran, T., & McDonald, B. (2011). When is a liability not a liability? Textual analysis, dictionaries, and 10-Ks. *Journal of Finance*, 66(1), 35–65. [Link](https://doi.org/10.1111/j.1540-6261.2010.01625.x), [Google](https://scholar.google.com/scholar?q=When+is+a+liability+not+a+liability+Loughran+McDonald+2011).

* Tetlock, P. C. (2007). Giving content to investor sentiment: The role of media in the stock market. *Journal of Finance*, 62(3), 1139–1168. [Link](https://doi.org/10.1111/j.1540-6261.2007.01232.x), [Google](https://scholar.google.com/scholar?q=Giving+content+to+investor+sentiment+Tetlock+2007).
