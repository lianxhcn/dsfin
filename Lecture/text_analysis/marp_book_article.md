
> **作者：** 连小白 (连享会)    
> **邮箱：** <lianxhcn@163.com> 


> **作者：** 连玉君  
> **资源：** [在线版](https://lianxhcn.github.io/marp-book/) | [PDF](https://lianxhcn.github.io/marp-book/Marp-book.pdf) | [GitHub](https://github.com/lianxhcn/marp-book)

&emsp; 

- **Title**: Marp 幻灯片指南：用 AI 提示词替代 PowerPoint
- **Keywords**: 

&emsp; 

---

## 你还在用 PowerPoint 吗？

每次做幻灯片，大量时间都花在了调格式上：字号对不齐、图片位置跑偏、换一台电脑字体又变了……

其实，做幻灯片有更轻松的方式——**Marp**。

**Marp** 是一个用 Markdown 写幻灯片的工具。你只需在 VS Code 里写几行文字，它自动排成幻灯片，导出 PDF 或 HTML，格式始终一致，再也不用拖图拖框。

更重要的是：**Marp + AI，是目前效率最高的幻灯片制作方式。**

---

## 为什么说 Marp 天生适合 AI 时代？

PowerPoint 是图形界面工具，AI 很难直接操作它的像素和图形布局。

Marp 不一样——它的文件本质上是**纯文本**（Markdown + YAML + CSS），AI 完全看得懂、写得出。这意味着：

- 把一篇论文发给 AI，让它直接输出 Marp 幻灯片
- 把现有模板发给 AI，让它按风格填充内容
- 遇到排版问题，把代码贴给 AI，让它修好再发回来

**一个典型的工作流：**

```
论文/报告 → 发给 AI（附模板）→ AI 输出 .md 文件 → VS Code 预览 → 导出 PDF
```

整个过程，格式问题几乎为零。

---

## 这本书讲什么？

[《Marp 幻灯片指南》](https://lianxhcn.github.io/marp-book/)是一本轻量的入门书，不是技术手册，不追求大而全，只讲**最高频、最实用**的内容。

全书分为正文和附录两部分：

**正文（6 章）**

| 章节 | 内容 |
|------|------|
| 第 1 章 | 10 分钟做出第一份幻灯片 |
| 第 2 章 | 最常用的基础设定（主题、页码、页眉页脚） |
| 第 3 章 | 内容呈现（公式、图片、代码块、双栏排版） |
| 第 4 章 | 图片管理与导出（本地图片 + PDF 方案） |
| 第 5 章 | **用 AI 生成幻灯片**（核心章节） |
| 第 6 章 | 8 个开箱即用的幻灯片模板 |

**附录（8 个）**

按「我想实现什么效果」分类，每个条目都附有**可直接使用的提示词**，覆盖文字效果、分页、图片、代码展示、版式、导出、AI 辅助等常见场景。

---

## 核心亮点：用提示词解决格式问题

本书最大的特色，是把**AI 提示词**作为解决格式问题的主要工具。

比如，你想把一张幻灯片改成双栏布局，不需要自己研究 CSS，直接告诉 AI：

> 我有一张 Marp 幻灯片，内容如下：
>
> [粘贴幻灯片内容]
>
> 请帮我改成双栏布局，左边放文字要点，右边放图片（路径 `./Figs/chart.png`）。用 `<style scoped>`，只返回这张幻灯片的完整代码。

AI 给你代码，复制进去，搞定。

书里提供了覆盖常见需求的**提示词模板**，包括：

- 生成基础模板
- 按论文生成完整幻灯片（先大纲，再正文）
- 调整字号和配色
- 生成双栏页面
- 处理图片排版
- 遇到报错时如何求助 AI

---

## 8 个即用模板，覆盖常见场景

书中的 `template/` 文件夹提供了 8 个由浅入深的模板：

| 模板 | 适合场景 |
|------|---------|
| `marp01_simple` | 第一次练习，验证环境 |
| `marp02_basic` | 日常课程讲义、组会汇报 |
| `marp03_styled` | 需要公式、提示框、小字注释 |
| `marp04_twocol` | 代码演示、双栏对比 |
| `marp05_paper` | 学术论文汇报、会议展示 |
| `marp06_data` | 数据分析报告、图表展示 |
| `marp07_teaching` | 课程教学、板书风格、逐步推导 |
| `marp08_report` | 政策报告、工作汇报 |

每个模板都可以直接复制，改改内容就能用。遇到想扩展的效果，把模板发给 AI，描述需求，AI 帮你改。

---

## 快速上手

**第一步：安装**

1. 安装 [VS Code](https://code.visualstudio.com/)
2. 在扩展市场搜索 `Marp`，安装 **Marp for VS Code**

**第二步：新建文件**

新建 `slides.md`，写入：

```markdown
---
marp: true
---

# 我的第一张幻灯片

内容写在这里。

---

## 第二张

- 要点一
- 要点二
```

**第三步：预览和导出**

点击右上角 Marp 图标预览，按 `Ctrl+Shift+P` → `Marp: Export Slide Deck` 导出 PDF。

就这三步，10 分钟以内。

---

## 资源

- 📖 **在线阅读**：[https://lianxhcn.github.io/marp-book/](https://lianxhcn.github.io/marp-book/)
- 📄 **PDF 下载**：[Marp-book.pdf](https://lianxhcn.github.io/marp-book/Marp-book.pdf)
- 💻 **GitHub**：[lianxhcn/marp-book](https://github.com/lianxhcn/marp-book)

欢迎 Fork、提 Issue，或通过 Pull Request 提交修改建议。

---

> **相关推文：**
> - [Quarto Book：用 Markdown 写书并发布到网上](https://lianxhcn.github.io/quarto_book/)
> - [连享会 · Markdown-LaTeX 专题](https://www.lianxh.cn/blogs/30.html)
