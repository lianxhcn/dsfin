



我再提供一些有关 Limited dependent variable 的笔记，主要包括 tobit，heckman，two－part model等。你帮我做个系统的规划，主要涉及如下问题：

1. 这类模型统一放在我的书稿中的 Part V：受限因变量模型
2. 这一部分要包含几个章节？
3. 我的想法是每一章包含三个文件：
   - 01_xxx_lec.qmd   主要介绍原理和理论，配合一些图形和表格，最好有 2-3 个具体的实例 (可以用一个模拟数据，另外两个用真实数据-这些真实数据主要是金融、公司金融领域的，你可以告诉我大致的选题，我来收集数据，我可以使用 akshare，baostock 等 pakcage，也可以通过 CSMAR 的网页端下载)
   - 02_xxx_codes.ipynb  用于生成 '01_xxx_lec.qmd' 文档中的图片和结构示意图等
   - 03_xxx_case.ipynb  用于展示一个完整的 case，介绍本章中讲解的模型的 Python 实现。要形成一个有案例背景、从数据导入到模型估计、可视化、结果分析的 完整链条