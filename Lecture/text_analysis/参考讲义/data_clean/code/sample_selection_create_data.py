# ── 追加至 create_sample_data.ipynb ──────────────────────
# 生成「样本选择偏差」演示数据及图表
# 依赖：pandas, numpy, matplotlib, scipy
# 输出：data_raw/SampleSelection.csv
#       fig/fig_sample_selection.png

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import matplotlib.font_manager as fm
from scipy import stats
import os

os.makedirs('data_raw', exist_ok=True)
os.makedirs('fig',      exist_ok=True)

# 自动检测可用中文字体
_CJK = ['Microsoft YaHei','SimHei','PingFang SC',
        'Hiragino Sans GB','WenQuanYi Zen Hei','Noto Sans CJK SC']
_avail = {f.name for f in fm.fontManager.ttflist}
_font  = next((f for f in _CJK if f in _avail), None)
if _font:
    plt.rcParams['font.family'] = _font
plt.rcParams['axes.unicode_minus'] = False

# ── 数据 ─────────────────────────────────────────────────
# 研究问题：上市公司贷款利率（Rate）的影响因素
# 缺失机制：规模较小（Size < 24）的公司，贷款信息往往未在公告中披露
#           → Rate 缺失不随机，集中于小规模民营企业
# 后果：若仅用已披露利率的样本回归，Size 的负向效应会被高估

df = pd.DataFrame({
    'id':       range(1, 11),
    'comp':     ['平安银行','万科A','中兴通讯','中国石化','招商银行','格力电器',
                 '宁德时代','东方财富','三一重工','比亚迪'],
    'soe':      [0, 0, 0, 1, 0, 0,   0, 0, 0, 0],
    'Leverage': [0.89, 0.65, 0.52, 0.58, 0.88, 0.44,
                 0.72, 0.68, 0.75, 0.70],
    'Size':     [25.3, 24.1, 23.8, 26.2, 25.4, 23.5,
                 23.2, 22.8, 23.9, 23.4],
    'Rate':     [4.20, 3.85, 4.50, 3.60, 4.10, 4.75,
                 None, None, None, None],
})

df.to_csv('data_raw/SampleSelection.csv', index=False, encoding='utf-8-sig')
print("SampleSelection.csv 已生成，shape:", df.shape)

obs  = df[df['Rate'].notna()].copy()
miss = df[df['Rate'].isna()].copy()

# ── 分组统计（诊断缺失是否随机）────────────────────────────
print("\n按 Rate 缺失状态分组的描述统计：")
print(f"{'变量':<12}  {'已知（n=6）':>12}  {'缺失（n=4）':>12}  {'差异':>8}  {'p 值':>7}")
print("-" * 60)
for var, cn in {'Leverage':'杠杆率','Size':'规模（ln）','soe':'国企占比'}.items():
    m1, m2 = obs[var].mean(), miss[var].mean()
    t, p   = stats.ttest_ind(obs[var], miss[var])
    sig    = '*' if p < 0.05 else ('†' if p < 0.10 else '')
    print(f"{cn:<12}  {m1:>12.3f}  {m2:>12.3f}  {m2-m1:>+8.3f}  {p:>6.3f}{sig}")
print("注：† p<0.10, * p<0.05，样本量极小（n=10），仅供方向性参考。")

# ── 散点图 ────────────────────────────────────────────────
BLUE, ORANGE = '#185FA5', '#BA7517'
fig, axes = plt.subplots(1, 2, figsize=(11, 4.8))
fig.patch.set_facecolor('white')

for ax, (xvar, xlabel, title) in zip(axes, [
    ('Leverage', '杠杆率（Leverage）',    '（a）杠杆率与贷款利率'),
    ('Size',     '公司规模（ln 总资产）', '（b）公司规模与贷款利率'),
]):
    xlo, xhi = miss[xvar].min()-0.05, miss[xvar].max()+0.05
    ax.axvspan(xlo, xhi, alpha=0.10, color=ORANGE, zorder=0)

    xv, yv = obs[xvar].values, obs['Rate'].values
    slope, intercept, *_ = stats.linregress(xv, yv)
    xfit = np.linspace(xv.min()-0.3, xv.max()+0.3, 200)
    ax.plot(xfit, intercept+slope*xfit, color=BLUE, lw=1.6, zorder=3)
    ax.scatter(xv, yv, color=BLUE, s=72, zorder=5)
    for _, row in obs.iterrows():
        ax.annotate(row['comp'], xy=(row[xvar], row['Rate']),
                    xytext=(5, 3), textcoords='offset points',
                    fontsize=7.5, color=BLUE)

    Y_MISS = 3.22
    for _, row in miss.iterrows():
        ax.scatter(row[xvar], Y_MISS, marker='D', color=ORANGE, s=55, zorder=5)
        ax.annotate(row['comp'], xy=(row[xvar], Y_MISS),
                    xytext=(0, -16), textcoords='offset points',
                    ha='center', fontsize=7.5, color=ORANGE)

    ax.text((xlo+xhi)/2, 5.10, '缺失集中区',
            ha='center', fontsize=8, color=ORANGE)
    ax.set_xlabel(xlabel, fontsize=10.5)
    ax.set_ylabel('贷款利率（%）', fontsize=10.5)
    ax.set_ylim(3.0, 5.25)
    ax.tick_params(labelsize=9)
    ax.spines[['top', 'right']].set_visible(False)
    ax.set_title(title, fontsize=11, pad=8)
    ax.legend(handles=[
        mpatches.Patch(color=BLUE,   label='y 已知（n = 6）'),
        mpatches.Patch(color=ORANGE, label='y 缺失（n = 4，x 位置）'),
    ], fontsize=8.5, frameon=False, loc='upper left')

fig.suptitle(
    '图 3-X  贷款利率的样本选择偏差：缺失公司的特征系统性不同于已知组',
    fontsize=11, y=1.01
)
plt.tight_layout()
fig.savefig('fig/fig_sample_selection.png',
            dpi=150, bbox_inches='tight', facecolor='white')
plt.close()
print("\n图片已保存至 fig/fig_sample_selection.png")
