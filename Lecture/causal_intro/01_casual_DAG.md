[搬书匠-3570-Causal Inference in Python-2023-英文版.pdf, Chap 4](https://github.com/matheusfacure/causal-inference-in-python-code/blob/main/causal-inference-in-python/03-Graphical-Models.ipynb)

```python
g_risk = gr.Digraph(graph_attr={"rankdir":"LR"})

g_risk.edge("Risk", "X")
g_risk.edge("X", "Credit Limit")
g_risk.edge("X", "Default")
g_risk.edge("Credit Limit", "Default")

g_risk
```

![20260409214038](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/20260409214038.png){width="90%"}