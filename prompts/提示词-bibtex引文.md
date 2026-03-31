
### Round 1
python 中有没有 package 可以根据 {DOI} 生成 bibtex 引文信息


### Round 2
我正在写一个讲义，使用 VS Code + Quarto render 编译。
项目结构如下：

dsfin
--[lecture]
   --[Heckman]
   - [PanelData]
--[Appendix]
- [Reference]
   - get-refs.ipynb   # 根据 {DOI} 获取参考文献的 .bibtex 文本
   - .bibtex   # 汇集所有参考文献条目

你觉得我该如何规划，以便各章节可以共用一些常用的引文，章节之间也可以交叉引用文献