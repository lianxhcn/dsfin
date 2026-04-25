---
marp: true
size: 16:9        
paginate: true  
#header: '[连享会](https://www.lianxh.cn/news/46917f1076104.html)'
footer: '[lianxh.cn](https://www.lianxh.cn)&ensp;|&ensp;[Books](https://www.lianxh.cn/Books.html)'
---

<style>
/*一级标题局中*/
section.lead h1 {
  text-align: center; /*其他参数：left, right*/
}
section {
  font-size: 24px;      /* 正文字号 */
}
h1 {
  color: blackyellow;   /* 标题的颜色 */
  /*font-size: 28px; */ /* 标题的字号, 其它标题也可以这样修改 */
}
h2 {
  color: green;
}
h3 {
  color: darkblue;
}
h4 {
  color: brown;
}
/* 右下角添加页码 */
section::after {
  content: attr(data-marpit-pagination) '/' attr(data-marpit-pagination-total); 
}
header,
footer {
  position: absolute;
  left: 50px;
  right: 50px;
  height: 25px;
}
/* 调整图片与文本之间的间距 */
section img {
  margin-right: 10px;   /* 设置图片右侧的间距 */
  margin-left: 10px;   /* 设置图片左侧的间距 */
}

/* 设置正文区域的边距，确保文本能更紧凑地放置 */
section {
  #padding-right: 20px;  /* 设置右侧边距 */
  #padding-left: 20px;  /* 设置左侧边距 */
}

/* ====== 新增：设置代码块字号 ====== */

/* 默认代码块字号 */
pre {
  font-size: 22px;
}

/* 可选类：小字号代码块 */
.small-code pre {
  font-size: 12px;
}

/* 可选类：大字号代码块 */
.large-code pre {
  font-size: 20px;
}

/* 5:5 等宽双栏 */
.columns { display: flex; gap: 24px; align-items: flex-start; }
.col-5 { flex: 5 1 0; }   /* 左右各 5 */
</style>

<!--顶部文字-->


<!--封面图片-->


![bg right:55% w:500 brightness:. sepia:50%](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20260425115532.png)




<!--幻灯片标题-->

## 专业硕士的数据分析如何教？
- “数据分析与经济决策”
- “金融数据分析与建模”

<br>
<br>

<!--作者信息-->
[连玉君](https://www.lianxh.cn) (中山大学)
arlionn@163.com

<br>

> **课程主页**：
> <https://lianxhcn.github.io/dsfin>   

> **Github 仓库**：
> <https://github.com/lianxhcn/dsfin>

<!-- backgroundColor: #FFFFF9 -->


--- - --
<!-- backgroundColor: white -->

&emsp; &emsp; &emsp; &emsp; &emsp; ![w:1200](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20250828000841.png)

--- - --

## 要点

- 整体感受
- 课程内容
- 教什么？
- 如何教？
- 讨论


---

# 整体感受

- 敬畏之心：和学生一起学习 
  - Stata/R &rarr; Python；LLM；GenAI；Agent
  - 课前准备：确定主题、摸底、与相关课程老师沟通

- 让学生卷起来
  - 作业设计、课堂讨论、私下讨论 (线人)

- 思路转变
  - 钓鱼
  - 推理和拆解 

---

![w:1400](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20250828003453.png)

---

![w:880](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20260425105132.png)

---

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20260425105504.png)

---
<!-- backgroundColor: #cdf27eff -->

# 课前摸底

> 学生人数：55 人；age：24-49 岁

1. 你会用哪些软件？（多选题）
2. 你了解以下哪些方法?（多选题）
3. 你期望学习哪方面的内容？（多选）
4. 你经常使用哪些 AI 工具？
5. 你更喜欢哪种授课方式？

--- - --
<!-- backgroundColor: white -->

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20250820170751.png)

--- - --


![h:600](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20250820171019.png)

---

![20250820170253](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20250820170253.png)

---

![h:600](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20250820171303.png)

---

## 教学模式选择

### 9-1 模式

  - 90% 以上由老师讲授，学生课后完成作业

### 6-4 模式

  1. 老师讲授核心概念和原理、数据分析流程等
  2. **小组作业**：一个小型的数据处理和分析项目
  3. 课堂上留出大概 2/5 的时间，由学生报告，并与同学和老师做详细的讨论。

![bg right:45% w:600](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20250820171611.png)

---

## 学生背景

![bg right:55% w:700](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20250821183906.png)

**制造与实业**: 21 人
- 中国联合网络通信集团
- 广东裁成律师事务所
- 广州安迅经济发展有限公司
- 广东天禾农资股份有限公司

**政府与事业单位**: 11 人
- 广州市烟草专卖局
- 佛山市商务局
- 萍乡市发展和改革委员会
- 广州市荔湾区财政局
  
**其它**：……


---

<!-- backgroundColor: #cdf27eff -->

# 教什么？

- 数据分析的目标、流程、工具
- 做个专业人士
- 学会沟通和协作/写作

--- - --
<!-- backgroundColor: white -->

- 数据分析的 **流程**
  - 目标 &rarr; 数据 &rarr; 方法 &rarr; 结果 &rarr; 决策 
- 数据分析的 **工具**
  - VS Code + AI 工具 + Python + Jupyter Notebook
- **特色**：提供大量的提示词
  - 分析流程 | 代码生成 | 避坑指南
  - 提示词 &rarr; Skills &rarr; 思维方式 &rarr; Agents
---

## 主要内容

- 数据的获取：本地、**在线**、**爬虫** 
- 数据管理：Pandas DataFrame、SQLite、关联数据库 (与业界对接)
- 数据清洗：原则 + 经验
- 数据可视化：强调信息的有效传达 + 审美
- 常用统计和计量模型
  - **入手**：数据类型和分布特征 (MLE 是主角)
  - 机器学习方法：原理 + 应用场景 + 案例





---

<!-- backgroundColor: #d1f5f7ff -->

# 如何教？

--- - --
<!-- backgroundColor: white -->
## 如何教？整体思路

&#x1F34E; **搭好戏台** &rarr; **缺啥补啥** &rarr; **先让代码跑起来**

- AI 辅助教学
- 原理 + 流程 + 规范
- 统计软件和工具的选择
  - Python + Jupyter Notebook
  - Github + GitHub Copilot + Github Desktop
- 协作、写作和沟通
  - &#x1F34F; 一定要多写：想不清楚的东西一定写不清楚
  - **作业提交**：
    - Github 仓库 + Github Desktop
    - **SLides**：Markdown + Marp
    - **Website**：quarto book + GitHub Pages

---

## 如何教？手写板书

![w:980](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20260425112132.png)

---

## 如何教？作业 (真刀实枪，不要玩具)

- 个人作业：每周一次 (2-3 小时)
  - [ex_P01.md](https://github.com/lianxhcn/dsfin/blob/main/homework/ex_P01.md)&emsp;|&emsp;[ex_P02.md](https://github.com/lianxhcn/dsfin/blob/main/homework/ex_P02_get_clean_fin_data.md) &emsp;|&emsp;[ex_P03.md](https://github.com/lianxhcn/dsfin/blob/main/homework/ex_P03_Panel-capital_strucuture.md)

- 小组作业：2-3 个 (每组 4-5 人)
  - 根据兴趣选择案例 (最好能提供多个 [备选主题](https://github.com/lianxhcn/dsfin/tree/main/homework/Topics_01))
  - 展示和讨论 (2-3 个小组做同一个案例) 
    - [Team01-API+SQLite](https://github.com/lianxhcn/dsfin/blob/main/homework/Topics_01/T10-%E6%95%B0%E6%8D%AE%E8%8E%B7%E5%8F%96%E8%BF%9B%E9%98%B6%EF%BC%9AAPI%E8%B0%83%E7%94%A8%E4%B8%8ESQLite%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AE%A1%E7%90%86.md) &emsp; | &emsp; [Team02-投资组合](https://chaoyian.github.io/teamworkquartobook/)[Team03-ML]()

- 老师：设计作业 v.s. 布置作业
  - ChatGPT + Claude code


---

## 如何教？教材和讲义

- 讲义：根据学生的背景和需求，**量身定制**，而不是照搬现成的教材。
  - [2  课程简介和资源](https://lianxhcn.github.io/dsfin/Lecture/00_intro.html)

- AI 辅助生成 Online-book，参见：[金融数据分析课程主页](https://lianxhcn.github.io/dsfin/)&emsp;|&emsp;[github 仓库](https://github.com/lianxhcn/dsfin)
  - 关键：学会写提示词 - 结构、逻辑

- Github 仓库：[7000+ 仓库](https://github.com/search?q=data+science+python&type=repositories)

- 在线讲义：Quarto + GitHub Pages
  - 连玉君，[Quarto Book](https://lianxhcn.github.io/quarto_book/)&emsp;|&emsp;[Marp Book](https://lianxhcn.github.io/marp-book/) 
  - [用 Quarto book 写的书](https://lianxhcn.github.io/quarto_book/body/05_references.html#%E7%94%A8-quarto-book-%E5%86%99%E7%9A%84%E4%B9%A6)


---

<!-- backgroundColor: #d1f5f7ff -->

# 讨论

---
<!-- backgroundColor: #FFFFF9 -->

## 讨论 1：彼此的优势

### 老师

- 理论基础
- 工具地图和分析流程
- 前沿工具

### 学生

- 实践经验 &rarr; 应用场景 (提问)
- 案例分析能力
- 内卷的潜力：对新工具的适应能力

---

## 讨论 2：教学模式 (1)

- 环境配置：让代码跑起来 (信心)

- 学生没有能力或者需要花很多时间才能理解的内容
  - 线性回归 &rarr; 非参数估计 (KNN, 核密度函数图, 随机森林) 
  - 条件期望 + 条件概率 &rarr; GLM (广义线性模型) &rarr; Logit/Duration
- 分析流程和规范 (经验)
  - EDA &rarr; 可视化 &rarr; 回归分析 &rarr; 机器学习
  - 离群值
  - 非结构化数据 &rarr; 结构化数据
- 阅读和检索能力 &rarr; 知道周围在发生什么 &rarr; 趋势敏感性

---
<!-- backgroundColor: #FFFFF9 -->

## 讨论 2：教学模式 (2)

- 思路一：教方法和模型 &rarr; 学生自行选择案例分析对象
- 思路二：案例导向 &rarr; 学生根据自己的需要来学习


---

## 讨论 3：案例库 &#x1F34F;

- MBA 教学经验：[中欧案例库](https://www.chinacases.org/anon/casehelp/anon_casehelp_category/anonCasehelpCategory.do?method=view&fdId=17862da992a3f9f0d0322164cf0ae791&s_css=default&mainFdId=18e2bf77b4949fae1a9fd6f4132a5d2b&vido2=true&lang=zh-CN)
  - 岭院的师资培训：MIT Sloan 管理学院 (5 个月) + 中欧案例培训
  - MBA 教学经验：[MBA-CF](https://gitee.com/arlionn/MBA-CF/wikis/%E8%AF%BE%E7%A8%8B%E5%A4%A7%E7%BA%B2/0.%20%E4%BA%A4%E4%BD%9C%E4%B8%9A%E5%85%A5%E5%8F%A3)
- Kaggle 数据平台 (https://www.kaggle.com/datasets)
  - 深度不够、案例背景资料缺乏
- 学生的资源
  - 案例报告 / 小组作业
  - 毕业论文
  - 校企合作
- 年度案例大赛或案例征集

---

<center>

<https://lianxhcn.github.com/dsfin>

</center>