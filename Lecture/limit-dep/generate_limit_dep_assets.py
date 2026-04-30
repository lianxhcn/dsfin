# ============================================================
# 生成 limit-dep 模块 v2/v3 的模拟数据和图片
# ============================================================

import os
from pathlib import Path
import warnings
warnings.filterwarnings("ignore")

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import matplotlib.font_manager as fm
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch
from matplotlib.lines import Line2D
from scipy import stats
from scipy.special import expit
from scipy.optimize import minimize
import statsmodels.api as sm
from statsmodels.discrete.discrete_model import Logit, Probit

BASE = Path(__file__).resolve().parent
FIG_DIR = BASE / "figs"
DATA_DIR = BASE / "data"
FIG_DIR.mkdir(exist_ok=True)
DATA_DIR.mkdir(exist_ok=True)

# ------------------------------------------------------------
# 字体设置：优先使用 Noto Sans CJK，避免中文乱码
# ------------------------------------------------------------
def setup_chinese_font():
    font_paths = [
        "/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc",
        "/usr/share/fonts/opentype/noto/NotoSerifCJK-Regular.ttc",
        "C:/Windows/Fonts/simhei.ttf",
        "C:/Windows/Fonts/msyh.ttc",
    ]
    for fp in font_paths:
        if os.path.exists(fp):
            fm.fontManager.addfont(fp)
            prop = fm.FontProperties(fname=fp)
            plt.rcParams["font.family"] = prop.get_name()
            break
    plt.rcParams["axes.unicode_minus"] = False
    plt.rcParams.update({
        "font.size": 11,
        "axes.spines.top": False,
        "axes.spines.right": False,
        "axes.grid": True,
        "grid.alpha": 0.25,
        "figure.dpi": 150,
        "savefig.dpi": 300,
    })

setup_chinese_font()
rng = np.random.default_rng(20260429)

# ------------------------------------------------------------
# 通用保存函数
# ------------------------------------------------------------
def savefig(fig, name):
    fig.savefig(FIG_DIR / f"{name}.png", bbox_inches="tight", dpi=300)
    fig.savefig(FIG_DIR / f"{name}.svg", bbox_inches="tight")
    plt.close(fig)

# ------------------------------------------------------------
# 04 Tobit：模拟企业净借款需求数据
# ------------------------------------------------------------
def simulate_tobit_credit(n=3000, seed=20260429):
    """
    生成 Tobit 章节使用的企业信贷数据。
    B_star 是潜在净借款需求，不是实际贷款金额。
    当 B_star <= 0 时，实际银行贷款金额被记录为 0。
    """
    r = np.random.default_rng(seed)
    opportunity = r.normal(0, 1, n)
    collateral_raw = r.beta(2.2, 2.0, n)
    cash_raw = r.beta(2.0, 4.5, n)
    risk = r.normal(0, 1, n)
    size = r.normal(0, 1, n)

    collateral = (collateral_raw - collateral_raw.mean()) / collateral_raw.std()
    cash = (cash_raw - cash_raw.mean()) / cash_raw.std()

    u = r.normal(0, 0.85, n)
    b_star = -0.30 + 0.95 * opportunity + 1.10 * collateral - 0.70 * cash + 0.25 * size - 0.25 * risk + u
    loan_amt = np.maximum(0, b_star) * 80.0  # 单位可理解为百万元
    loan_pos = (loan_amt > 0).astype(int)

    df = pd.DataFrame({
        "firm_id": np.arange(1, n + 1),
        "opportunity": opportunity,
        "collateral": collateral,
        "cash": cash,
        "risk": risk,
        "size": size,
        "B_star": b_star,
        "loan_amt": loan_amt,
        "loan_pos": loan_pos,
    })
    return df

df_tobit = simulate_tobit_credit()
df_tobit.to_csv(DATA_DIR / "tobit_credit_sim.csv", index=False, encoding="utf-8-sig")

# 图 04-01：潜在净借款需求到观测贷款金额
x = np.linspace(-3, 4, 300)
y = np.maximum(0, x)
fig, ax = plt.subplots(figsize=(7.2, 4.2))
ax.plot(x, y, lw=2.5, label=r"$B=\max(0,B^*)$")
ax.axvline(0, ls="--", lw=1.2, color="0.3")
ax.axhline(0, lw=1.0, color="0.3")
ax.fill_between(x[x <= 0], 0, 0.12, alpha=0.18)
ax.text(-2.8, 0.35, "潜在净借款需求为负\n观测贷款金额归并为 0", fontsize=11)
ax.text(1.1, 2.7, "潜在净借款需求为正\n观测到正贷款金额", fontsize=11)
ax.set_xlabel(r"潜在净借款需求 $B^*$")
ax.set_ylabel(r"观测银行贷款金额 $B$")
ax.set_title("Tobit 机制：潜在净借款需求被归并到 0")
ax.legend(frameon=False)
savefig(fig, "limit_dep_tobit_fig01_latent_to_observed")

# 图 04-02：B* 与 B 的分布
fig, ax = plt.subplots(figsize=(7.4, 4.3))
ax.hist(df_tobit["B_star"], bins=45, alpha=0.50, density=True, label=r"潜在净借款需求 $B^*$")
ax.hist(df_tobit["loan_amt"] / 80.0, bins=45, alpha=0.45, density=True, label=r"观测贷款金额 $B/80$")
ax.axvline(0, ls="--", color="0.3", lw=1.1)
ax.set_xlabel("标准化金额")
ax.set_ylabel("密度")
ax.set_title("归并后，0 点附近出现大量堆积")
ax.legend(frameon=False)
savefig(fig, "limit_dep_tobit_fig02_latent_observed_distribution")

# 图 04-03：投资机会和抵押能力如何改变潜在净借款需求
grid = np.linspace(-2.5, 2.5, 120)
fig, ax = plt.subplots(figsize=(7.4, 4.3))
for cval, label in [(-1.0, "抵押能力较低"), (0.0, "抵押能力中等"), (1.0, "抵押能力较高")]:
    xb = -0.30 + 0.95 * grid + 1.10 * cval
    ax.plot(grid, xb, lw=2.1, label=label)
ax.axhline(0, ls="--", color="0.3", lw=1.1)
ax.set_xlabel("投资机会 opportunity")
ax.set_ylabel(r"潜在净借款需求 $E(B^*|x)$")
ax.set_title("同一组 x 同时影响是否为 0 与正值大小")
ax.legend(frameon=False)
savefig(fig, "limit_dep_tobit_fig03_x_to_latent_demand")

# Tobit MLE 函数
def fit_tobit_left0(y, X):
    """
    估计左归并点为 0 的 Tobit 模型。
    参数向量最后一项为 log(sigma)。
    """
    y = np.asarray(y, dtype=float)
    X = np.asarray(X, dtype=float)

    def nll(params):
        beta = params[:-1]
        sigma = np.exp(params[-1])
        xb = X @ beta
        z0 = (0 - xb) / sigma
        is_zero = y <= 1e-12
        ll = np.empty_like(y)
        ll[is_zero] = stats.norm.logcdf(z0[is_zero])
        ll[~is_zero] = stats.norm.logpdf((y[~is_zero] - xb[~is_zero]) / sigma) - np.log(sigma)
        return -np.sum(ll)

    ols_res = sm.OLS(y, X).fit()
    start = np.r_[ols_res.params, np.log(np.std(ols_res.resid) + 1e-6)]
    res = minimize(nll, start, method="BFGS", options={"maxiter": 2000})
    return res

# 使用未乘以 80 的 loan_scaled 估计，便于数值稳定
y_scaled = df_tobit["loan_amt"].to_numpy() / 80.0
X_tobit = sm.add_constant(df_tobit[["opportunity", "collateral", "cash"]])
tobit_res = fit_tobit_left0(y_scaled, X_tobit)
beta_hat = tobit_res.x[:-1]
sigma_hat = np.exp(tobit_res.x[-1])
pd.DataFrame({
    "term": X_tobit.columns,
    "estimate": beta_hat
}).assign(sigma=sigma_hat).to_csv(DATA_DIR / "tobit_credit_estimates.csv", index=False, encoding="utf-8-sig")

# 图 04-04：三类边际效应随 opportunity 的变化
grid = np.linspace(-2.5, 2.5, 150)
collateral0 = 0.0
cash0 = 0.0
Xg = np.column_stack([np.ones_like(grid), grid, np.full_like(grid, collateral0), np.full_like(grid, cash0)])
xb = Xg @ beta_hat
z = xb / sigma_hat
phi = stats.norm.pdf(z)
Phi = stats.norm.cdf(z)
lam = phi / np.maximum(Phi, 1e-10)
j = list(X_tobit.columns).index("opportunity")
b_j = beta_hat[j]
me_prob = phi * b_j / sigma_hat
me_uncond = Phi * b_j
me_cond = b_j * (1 - lam * (z + lam))

fig, ax = plt.subplots(figsize=(7.4, 4.3))
ax.plot(grid, me_uncond, lw=2.2, label="对非条件期望的边际效应")
ax.plot(grid, me_prob, lw=2.0, ls="--", label="对正贷款概率的边际效应")
ax.plot(grid, me_cond, lw=2.0, ls=":", label="对正值条件均值的边际效应")
ax.set_xlabel("投资机会 opportunity")
ax.set_ylabel("边际效应")
ax.set_title("Tobit 的边际效应不是只有一种")
ax.legend(frameon=False)
savefig(fig, "limit_dep_tobit_fig04_marginal_effects")

# ------------------------------------------------------------
# 05 Two-part/Hurdle/ZI/FRM：模拟信贷数据
# ------------------------------------------------------------
def simulate_credit_alt(n=3500, seed=20260430):
    """
    生成 Two-part、Hurdle、Zero-inflated 和 FRM 章节使用的数据。
    主线变量围绕企业信贷展开。
    """
    r = np.random.default_rng(seed)
    opportunity = r.normal(0, 1, n)
    collateral = (r.beta(2.2, 2.0, n) - 0.52) / 0.22
    bank_access = r.normal(0, 1, n)
    risk = r.normal(0, 1, n)
    size = r.normal(0, 1, n)

    # Two-part：是否贷款
    eta_d = -0.35 + 1.10 * collateral + 0.95 * bank_access - 0.35 * risk
    p_loan = expit(eta_d)
    D = r.binomial(1, p_loan, n)

    # Two-part：正贷款金额，log link
    eps = r.normal(0, 0.55, n)
    log_loan_pos = 2.20 + 0.42 * collateral + 0.38 * opportunity + 0.18 * size + eps
    loan_pos_amt = np.exp(log_loan_pos)
    loan_amt = D * loan_pos_amt

    # Hurdle：贷款笔数，先是否跨过门槛，再正计数
    eta_h = -0.60 + 1.0 * collateral + 0.7 * bank_access + 0.4 * opportunity
    p_h = expit(eta_h)
    H = r.binomial(1, p_h, n)
    lam_h = np.exp(0.65 + 0.35 * collateral + 0.30 * opportunity)
    count_h = np.zeros(n, dtype=int)
    for i in range(n):
        if H[i] == 1:
            val = 0
            while val == 0:
                val = r.poisson(lam_h[i])
            count_h[i] = val

    # Zero-inflated：结构性 0 + 常规泊松过程
    pi = expit(0.15 - 0.95 * bank_access - 0.75 * collateral)
    structural_zero = r.binomial(1, pi, n)
    lam_zi = np.exp(0.45 + 0.45 * opportunity + 0.35 * collateral)
    count_zi = np.where(structural_zero == 1, 0, r.poisson(lam_zi))

    # FRM：银行贷款占总负债比例
    mu_share = expit(-0.20 + 0.75 * collateral + 0.45 * bank_access - 0.55 * risk + 0.25 * opportunity)
    precision = 18
    a = np.clip(mu_share * precision, 0.5, None)
    b = np.clip((1 - mu_share) * precision, 0.5, None)
    loan_share = r.beta(a, b)

    return pd.DataFrame({
        "firm_id": np.arange(1, n + 1),
        "opportunity": opportunity,
        "collateral": collateral,
        "bank_access": bank_access,
        "risk": risk,
        "size": size,
        "p_loan_true": p_loan,
        "D": D,
        "loan_amt": loan_amt,
        "log_loan_pos": np.where(D == 1, np.log(np.maximum(loan_amt, 1e-9)), np.nan),
        "loan_count_hurdle": count_h,
        "loan_count_zi": count_zi,
        "structural_zero": structural_zero,
        "loan_share": loan_share,
    })

df_alt = simulate_credit_alt()
df_alt.to_csv(DATA_DIR / "limitdep_credit_alt_sim.csv", index=False, encoding="utf-8-sig")

# 图 05-01：模型地图
def draw_box(ax, xy, text, fc, ec, w=None, h=None, dashed=False, fontsize=12):
    x, y = xy
    lines = text.split("\n")
    if w is None:
        w = max(1.35, 0.12 * max(len(s) for s in lines) + 0.55)
    if h is None:
        h = 0.35 + 0.27 * len(lines)
    box = FancyBboxPatch(
        (x - w / 2, y - h / 2), w, h,
        boxstyle="round,pad=0.08,rounding_size=0.08",
        fc=fc, ec=ec, lw=1.3,
        linestyle="--" if dashed else "-"
    )
    ax.add_patch(box)
    ax.text(x, y, text, ha="center", va="center", fontsize=fontsize)
    return {"x": x, "y": y, "w": w, "h": h}

def edge_point(box, direction):
    if direction == "right":
        return (box["x"] + box["w"]/2, box["y"])
    if direction == "left":
        return (box["x"] - box["w"]/2, box["y"])
    if direction == "top":
        return (box["x"], box["y"] + box["h"]/2)
    if direction == "bottom":
        return (box["x"], box["y"] - box["h"]/2)

def arrow_between(ax, b1, side1, b2, side2, rad=0.0):
    p1 = edge_point(b1, side1)
    p2 = edge_point(b2, side2)
    arr = FancyArrowPatch(
        p1, p2, arrowstyle="-|>", mutation_scale=12,
        lw=1.15, color="0.25",
        shrinkA=8, shrinkB=8,
        connectionstyle=f"arc3,rad={rad}"
    )
    ax.add_patch(arr)

fig, ax = plt.subplots(figsize=(11.5, 6.3))
ax.set_xlim(0, 11.5); ax.set_ylim(0, 6.3); ax.axis("off")
colors = {
    "blue": ("#D7EAFB", "#5B8FC6"),
    "yellow": ("#FFF1C9", "#D5A537"),
    "green": ("#DFF0D8", "#6BA35D"),
    "red": ("#FADBD8", "#B7645C"),
    "purple": ("#E8DAEF", "#8E6AA7"),
    "orange": ("#FDEBD0", "#D49A45"),
    "teal": ("#D5F5E3", "#4E9A73"),
    "gray": ("#F2F3F4", "#8A8A8A"),
}
b0 = draw_box(ax, (1.35, 5.55), "因变量受限\n或有大量 0", *colors["blue"], fontsize=12)
b1 = draw_box(ax, (3.65, 5.55), "样本是否\n仍在数据中？", *colors["yellow"], fontsize=12)
b2 = draw_box(ax, (6.10, 5.55), "否：样本被截断\nTruncated regression", *colors["red"], fontsize=12)
b3 = draw_box(ax, (3.65, 4.25), "是：0 或 missing\n如何产生？", *colors["green"], fontsize=12)
b4 = draw_box(ax, (1.65, 3.05), "边界外取值被归并\nTobit", *colors["purple"], fontsize=12)
b5 = draw_box(ax, (3.65, 3.05), "0 是真实选择\nTwo-part model", *colors["blue"], fontsize=12)
b6 = draw_box(ax, (6.10, 3.05), "结果是计数\nHurdle / Zero-inflated", *colors["orange"], fontsize=12)
b7 = draw_box(ax, (8.85, 3.05), "结果是比例\nFractional response", *colors["teal"], fontsize=12)
b8 = draw_box(ax, (3.65, 1.35), "结果变量只在\n被选择样本中可观测\nHeckman selection (Chap. 06)", *colors["gray"], dashed=True, fontsize=12)
arrow_between(ax, b0, "right", b1, "left")
arrow_between(ax, b1, "right", b2, "left")
arrow_between(ax, b1, "bottom", b3, "top")
arrow_between(ax, b3, "bottom", b4, "top", rad=0.06)
arrow_between(ax, b3, "bottom", b5, "top")
arrow_between(ax, b5, "right", b6, "left")
arrow_between(ax, b6, "right", b7, "left")
arrow_between(ax, b3, "bottom", b8, "top", rad=-0.05)
ax.text(0.25, 0.25, "注：灰色虚线框为下一章样本选择模型的入口，本章不展开。", fontsize=10, color="0.35")
savefig(fig, "limit_dep_alt_fig01_model_map")

# 图 05-02：Two-part 机制
fig, ax = plt.subplots(figsize=(8.4, 4.7))
ax.axis("off"); ax.set_xlim(0, 8.4); ax.set_ylim(0, 4.7)
b1 = draw_box(ax, (1.4, 3.2), "抵押能力\ncollateral", "#E8F6F3", "#45B39D", fontsize=12)
b2 = draw_box(ax, (1.4, 1.7), "银行可得性\nbank_access", "#FEF9E7", "#D4AC0D", fontsize=12)
b3 = draw_box(ax, (1.4, 0.45), "投资机会\nopportunity", "#FDEDEC", "#CD6155", fontsize=12)
c1 = draw_box(ax, (4.2, 2.55), "第一部分\n是否获得贷款\nPr(D=1|z)", "#D6EAF8", "#5DADE2", fontsize=12)
c2 = draw_box(ax, (4.2, 0.95), "第二部分\n获贷后贷多少\nE(B|B>0,x)", "#EBDEF0", "#AF7AC5", fontsize=12)
out = draw_box(ax, (7.0, 1.75), "非条件期望\nE(B|z,x)=p·μ+", "#D5F5E3", "#58D68D", fontsize=12)
arrow_between(ax, b1, "right", c1, "left"); arrow_between(ax, b1, "right", c2, "left")
arrow_between(ax, b2, "right", c1, "left")
arrow_between(ax, b3, "right", c2, "left")
arrow_between(ax, c1, "right", out, "left"); arrow_between(ax, c2, "right", out, "left")
ax.set_title("Two-part model：概率渠道与强度渠道", fontsize=14, pad=6)
savefig(fig, "limit_dep_alt_fig02_two_part_mechanism")

# 图 05-03：Tobit 与 Two-part 对比
opp_grid = np.linspace(-2.5, 2.5, 160)
# Tobit: same latent process
xb_tobit = -0.2 + 0.9 * opp_grid
p_tobit = stats.norm.cdf(xb_tobit / 0.9)
ey_tobit = p_tobit * xb_tobit + 0.9 * stats.norm.pdf(xb_tobit / 0.9)
# TPM: opportunity only affects positive amount in this simplified curve
p_tpm = expit(-0.2 + 0.8 * np.zeros_like(opp_grid))
mu_tpm = np.exp(1.0 + 0.38 * opp_grid)
ey_tpm = p_tpm * mu_tpm / np.mean(mu_tpm) * np.max(ey_tobit)
fig, ax = plt.subplots(figsize=(7.5, 4.3))
ax.plot(opp_grid, ey_tobit, lw=2.2, label="Tobit：同一潜在机制")
ax.plot(opp_grid, ey_tpm, lw=2.2, ls="--", label="Two-part：概率与强度可分开")
ax.set_xlabel("投资机会 opportunity")
ax.set_ylabel("预测贷款金额")
ax.set_title("同一个贷款背景，可以对应不同数据生成机制")
ax.legend(frameon=False)
savefig(fig, "limit_dep_alt_fig03_tobit_vs_twopart")

# 图 05-04：Hurdle 机制
fig, ax = plt.subplots(figsize=(7.6, 4.3))
vals = df_alt["loan_count_hurdle"]
counts = pd.Series(vals).value_counts().sort_index()
ax.bar(counts.index, counts.values / counts.values.sum(), width=0.75, alpha=0.75)
ax.axvline(0.5, color="0.35", ls="--", lw=1.2)
ax.text(0.62, ax.get_ylim()[1]*0.80, "跨过 0 的门槛后\n正计数来自零截断分布", fontsize=11)
ax.set_xlabel("贷款笔数")
ax.set_ylabel("样本占比")
ax.set_title("Hurdle model：先决定是否跨过 0，再决定正计数")
savefig(fig, "limit_dep_alt_fig04_hurdle_mechanism")

# 图 05-05：Zero-inflated 机制
fig, ax = plt.subplots(figsize=(7.6, 4.3))
vals = df_alt["loan_count_zi"]
counts = pd.Series(vals).value_counts().sort_index().loc[:8]
ax.bar(counts.index, counts.values / len(vals), width=0.75, alpha=0.75)
zero_share = (vals == 0).mean()
struct_share = ((df_alt["loan_count_zi"] == 0) & (df_alt["structural_zero"] == 1)).mean()
ax.text(1.1, ax.get_ylim()[1]*0.85, f"0 的总比例约为 {zero_share:.1%}\n其中一部分是结构性 0", fontsize=11)
ax.set_xlabel("贷款笔数")
ax.set_ylabel("样本占比")
ax.set_title("Zero-inflated model：0 可以来自两个来源")
savefig(fig, "limit_dep_alt_fig05_zero_inflated")

# 图 05-06：FRM vs OLS
X = sm.add_constant(df_alt[["collateral", "bank_access", "risk"]])
ols_frm = sm.OLS(df_alt["loan_share"], X).fit()
glm_frm = sm.GLM(df_alt["loan_share"], X, family=sm.families.Binomial()).fit()
pred_ols = ols_frm.predict(X)
pred_glm = glm_frm.predict(X)

fig, ax = plt.subplots(figsize=(7.6, 4.3))
ax.scatter(df_alt["collateral"], pred_ols, s=10, alpha=0.22, label="OLS 预测值")
ax.scatter(df_alt["collateral"], pred_glm, s=10, alpha=0.22, label="FRM 预测值")
ax.axhline(0, color="0.3", ls="--", lw=1.0)
ax.axhline(1, color="0.3", ls="--", lw=1.0)
ax.set_xlabel("抵押能力 collateral")
ax.set_ylabel("预测贷款比例")
ax.set_title("Fractional response：预测值自然落在 [0,1]")
ax.legend(frameon=False)
savefig(fig, "limit_dep_alt_fig06_frm_vs_ols")

# 输出 two-part 估计和 AME
def fit_two_part(df, z_vars, x_vars, y_col="loan_amt"):
    D = (df[y_col] > 0).astype(int)
    Z = sm.add_constant(df[z_vars])
    X_pos = sm.add_constant(df.loc[D == 1, x_vars])
    log_y = np.log(df.loc[D == 1, y_col])
    part1 = sm.Logit(D, Z).fit(disp=False)
    part2 = sm.OLS(log_y, X_pos).fit()
    smear = np.exp(part2.resid).mean()
    return {"part1": part1, "part2": part2, "smear": smear, "z_vars": z_vars, "x_vars": x_vars}

def predict_two_part(models, df):
    Z = sm.add_constant(df[models["z_vars"]])
    X = sm.add_constant(df[models["x_vars"]])
    p = models["part1"].predict(Z)
    mu = np.exp(models["part2"].predict(X)) * models["smear"]
    return pd.DataFrame({"p_hat": p, "mu_hat": mu, "ey_hat": p * mu})

def ame_two_part(models, df, varname):
    pred = predict_two_part(models, df)
    p = pred["p_hat"].to_numpy()
    mu = pred["mu_hat"].to_numpy()
    gamma = models["part1"].params.get(varname, 0.0)
    beta = models["part2"].params.get(varname, 0.0)
    prob_channel = p * (1 - p) * gamma * mu
    intensity_channel = p * mu * beta
    return {
        "varname": varname,
        "probability_channel": prob_channel.mean(),
        "intensity_channel": intensity_channel.mean(),
        "total_ame": (prob_channel + intensity_channel).mean(),
    }

models_tpm = fit_two_part(df_alt, ["collateral", "bank_access"], ["collateral", "opportunity"])
pred_tpm = predict_two_part(models_tpm, df_alt)
ame_rows = [ame_two_part(models_tpm, df_alt, v) for v in ["collateral", "bank_access", "opportunity"]]
pd.DataFrame(ame_rows).to_csv(DATA_DIR / "two_part_ame.csv", index=False, encoding="utf-8-sig")
pd.concat([df_alt[["firm_id", "loan_amt", "D"]], pred_tpm], axis=1).to_csv(DATA_DIR / "two_part_predictions.csv", index=False, encoding="utf-8-sig")

# ------------------------------------------------------------
# 06 Heckman：模拟选择性观测的贷款利率数据
# ------------------------------------------------------------
def simulate_heckman_credit(n=3200, seed=20260501):
    """
    生成 Heckman 章节使用的数据。
    loan_rate 只在获得贷款的企业中可观测。
    """
    r = np.random.default_rng(seed)
    collateral = (r.beta(2.2, 2.0, n) - 0.52) / 0.22
    bank_access = r.normal(0, 1, n)
    risk = r.normal(0, 1, n)
    opportunity = r.normal(0, 1, n)
    size = r.normal(0, 1, n)

    rho = 0.55
    e1 = r.normal(0, 1, n)
    e2 = r.normal(0, 1, n)
    v = e1
    u = rho * e1 + np.sqrt(1 - rho ** 2) * e2

    s_star = -0.20 + 1.00 * collateral + 1.05 * bank_access - 0.75 * risk + 0.20 * opportunity + v
    D = (s_star > 0).astype(int)
    rate_star = 5.80 - 0.45 * collateral + 0.85 * risk - 0.20 * size + 0.55 * u
    rate = np.where(D == 1, rate_star, np.nan)

    return pd.DataFrame({
        "firm_id": np.arange(1, n + 1),
        "collateral": collateral,
        "bank_access": bank_access,
        "risk": risk,
        "opportunity": opportunity,
        "size": size,
        "s_star": s_star,
        "D": D,
        "loan_rate": rate,
        "rate_star": rate_star,
        "u": u,
        "v": v,
    })

df_h = simulate_heckman_credit()
df_h.to_csv(DATA_DIR / "heckman_credit_sim.csv", index=False, encoding="utf-8-sig")

# 图 06-01：选择性观测机制
fig, ax = plt.subplots(figsize=(8.4, 4.6))
ax.axis("off"); ax.set_xlim(0, 8.4); ax.set_ylim(0, 4.6)
b1 = draw_box(ax, (1.25, 3.2), "抵押能力\ncollateral", "#E8F6F3", "#45B39D", fontsize=12)
b2 = draw_box(ax, (1.25, 2.0), "银行可得性\nbank_access", "#FEF9E7", "#D4AC0D", fontsize=12)
b3 = draw_box(ax, (1.25, 0.8), "企业风险\nrisk", "#FDEDEC", "#CD6155", fontsize=12)
sel = draw_box(ax, (4.05, 2.65), "选择方程\n是否获得贷款\nD=1(S*>0)", "#D6EAF8", "#5DADE2", fontsize=12)
out = draw_box(ax, (4.05, 1.05), "结果方程\n贷款利率 rate\n仅 D=1 可观测", "#EBDEF0", "#AF7AC5", fontsize=12)
obs = draw_box(ax, (7.0, 1.85), "观测样本\nrate 不是 0\n而是 missing 或可见", "#D5F5E3", "#58D68D", fontsize=12)
arrow_between(ax, b1, "right", sel, "left")
arrow_between(ax, b1, "right", out, "left")
arrow_between(ax, b2, "right", sel, "left")
arrow_between(ax, b3, "right", sel, "left")
arrow_between(ax, b3, "right", out, "left")
arrow_between(ax, sel, "right", obs, "left")
arrow_between(ax, out, "right", obs, "left")
ax.set_title("Heckman selection：贷款利率只在获得贷款样本中可观测", fontsize=14, pad=8)
savefig(fig, "limit_dep_heckman_fig01_selection_mechanism")

# 图 06-02：选择样本与总体潜在利率
fig, ax = plt.subplots(figsize=(7.6, 4.3))
ax.hist(df_h["rate_star"], bins=45, alpha=0.45, density=True, label="潜在贷款利率 (总体)")
ax.hist(df_h.loc[df_h["D"] == 1, "loan_rate"], bins=45, alpha=0.55, density=True, label="观测贷款利率 (D=1)")
ax.set_xlabel("贷款利率")
ax.set_ylabel("密度")
ax.set_title("只在获得贷款企业中观察利率，会改变样本分布")
ax.legend(frameon=False)
savefig(fig, "limit_dep_heckman_fig02_observed_rate_sample")

# 图 06-03：IMR 校正直觉
Z = sm.add_constant(df_h[["collateral", "bank_access", "risk"]])
probit = sm.Probit(df_h["D"], Z).fit(disp=False)
xb = probit.predict(Z, linear=True)
imr = stats.norm.pdf(xb) / np.maximum(stats.norm.cdf(xb), 1e-12)
df_h["imr"] = imr
sel = df_h["D"] == 1
X_naive = sm.add_constant(df_h.loc[sel, ["collateral", "risk"]])
naive = sm.OLS(df_h.loc[sel, "loan_rate"], X_naive).fit()
X_heck = sm.add_constant(df_h.loc[sel, ["collateral", "risk", "imr"]])
heck = sm.OLS(df_h.loc[sel, "loan_rate"], X_heck).fit()

fig, ax = plt.subplots(figsize=(7.6, 4.3))
ax.scatter(df_h.loc[sel, "imr"], df_h.loc[sel, "loan_rate"], s=13, alpha=0.24)
coef = np.polyfit(df_h.loc[sel, "imr"], df_h.loc[sel, "loan_rate"], 1)
xline = np.linspace(df_h.loc[sel, "imr"].min(), df_h.loc[sel, "imr"].max(), 100)
ax.plot(xline, coef[0] * xline + coef[1], lw=2.2)
ax.set_xlabel("inverse Mills ratio")
ax.set_ylabel("观测贷款利率")
ax.set_title("IMR 捕捉被选择样本中的非随机成分")
savefig(fig, "limit_dep_heckman_fig03_imr_correction")

summary_rows = [
    {"model": "Naive OLS", "collateral": naive.params["collateral"], "risk": naive.params["risk"], "imr": np.nan},
    {"model": "Heckman two-step", "collateral": heck.params["collateral"], "risk": heck.params["risk"], "imr": heck.params["imr"]},
]
pd.DataFrame(summary_rows).to_csv(DATA_DIR / "heckman_two_step_summary.csv", index=False, encoding="utf-8-sig")

print("Assets generated in:", BASE)
