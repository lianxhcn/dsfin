import pandas as pd
import numpy as np
from scipy import stats
import statsmodels.api as sm


def extract_event_window(series, event_date, left=5, right=5):
    if event_date not in series.index:
        return None
    loc = series.index.get_loc(event_date)
    if isinstance(loc, slice) or isinstance(loc, np.ndarray):
        return None
    start = loc - left
    end = loc + right
    if start < 0 or end >= len(series.index):
        return None
    window = series.iloc[start : end + 1].copy()
    window.index = range(-left, right + 1)
    return window


def estimation_window_mean(series, event_date, est_left=30, est_right=6):
    if event_date not in series.index:
        return np.nan
    loc = series.index.get_loc(event_date)
    start = loc - est_left
    end = loc - est_right
    if start < 0 or end < 0 or start > end:
        return np.nan
    estimation = series.iloc[start : end + 1].dropna()
    if len(estimation) < 10:
        return np.nan
    return estimation.mean()


def compute_event_ar_car(series, event_date, left=5, right=5, est_left=30, est_right=6):
    expected_return = estimation_window_mean(series, event_date, est_left=est_left, est_right=est_right)
    if pd.isna(expected_return):
        return None
    event_window = extract_event_window(series, event_date, left=left, right=right)
    if event_window is None or event_window.isna().any():
        return None
    ar = event_window - expected_return
    car = ar.cumsum()
    result = pd.DataFrame({
        "event_day": ar.index,
        "return": event_window.values,
        "expected_return": expected_return,
        "ar": ar.values,
        "car": car.values,
    })
    return result


def build_market_event_panel(returns_df, events_df, market_key, left=5, right=5, est_left=30, est_right=6):
    records = []
    series = returns_df[market_key].dropna()
    event_date_col = f"{market_key}_event_date"
    for _, event in events_df.iterrows():
        mapped_date = event.get(event_date_col)
        if pd.isna(mapped_date):
            continue
        event_result = compute_event_ar_car(
            series,
            pd.Timestamp(mapped_date),
            left=left,
            right=right,
            est_left=est_left,
            est_right=est_right,
        )
        if event_result is None:
            continue
        event_result["event_id"] = event["event_id"]
        event_result["policy_date"] = event["date"]
        event_result["market_key"] = market_key
        event_result["change_bp"] = event["change_bp"]
        event_result["type"] = event["type"]
        records.append(event_result)
    if not records:
        return pd.DataFrame()
    return pd.concat(records, ignore_index=True)


def average_car_by_type(panel_df):
    if panel_df.empty:
        return pd.DataFrame()
    grouped = panel_df.groupby(["market_key", "type", "event_day"]).agg(
        avg_ar=("ar", "mean"),
        avg_car=("car", "mean"),
        events=("event_id", "nunique"),
    )
    return grouped.reset_index()


def final_car_ttest(panel_df):
    if panel_df.empty:
        return pd.DataFrame()
    final_car = panel_df[panel_df["event_day"] == panel_df["event_day"].max()].copy()
    results = []
    for (market_key, event_type), subdf in final_car.groupby(["market_key", "type"]):
        t_stat, p_value = stats.ttest_1samp(subdf["car"], 0.0, nan_policy="omit")
        results.append({
            "market_key": market_key,
            "type": event_type,
            "mean_car": subdf["car"].mean(),
            "std_car": subdf["car"].std(),
            "n_events": subdf["event_id"].nunique(),
            "t_stat": t_stat,
            "p_value": p_value,
        })
    return pd.DataFrame(results)


def regression_on_event_day(returns_df, events_df, market_key):
    event_date_col = f"{market_key}_event_date"
    series = returns_df[market_key].dropna()
    records = []
    for _, event in events_df.iterrows():
        mapped_date = event.get(event_date_col)
        if pd.isna(mapped_date) or mapped_date not in series.index:
            continue
        records.append({
            "event_day_return": series.loc[mapped_date],
            "change_bp": event["change_bp"],
            "type": event["type"],
            "policy_date": event["date"],
        })
    reg_df = pd.DataFrame(records)
    if reg_df.empty or reg_df["change_bp"].nunique() < 2:
        return None, reg_df

    X = sm.add_constant(reg_df["change_bp"])
    y = reg_df["event_day_return"]
    model = sm.OLS(y, X).fit()
    summary = {
        "market_key": market_key,
        "alpha": model.params.get("const", np.nan),
        "beta": model.params.get("change_bp", np.nan),
        "alpha_pvalue": model.pvalues.get("const", np.nan),
        "beta_pvalue": model.pvalues.get("change_bp", np.nan),
        "r_squared": model.rsquared,
        "n_obs": int(model.nobs),
    }
    return summary, reg_df


def rolling_correlation_matrix(returns_df, window=60):
    clean = returns_df.dropna(how="all")
    result = {}
    for i, col_i in enumerate(clean.columns):
        for col_j in clean.columns[i + 1 :]:
            pair_name = f"{col_i}_{col_j}"
            pair_df = clean[[col_i, col_j]].dropna()
            result[pair_name] = pair_df[col_i].rolling(window).corr(pair_df[col_j])
    return pd.DataFrame(result)


def average_corr_by_period(returns_df, start_date, end_date):
    period_df = returns_df.loc[start_date:end_date].dropna(how="any")
    return period_df.corr()


def asymmetry_test(final_car_df, market_key):
    sub = final_car_df[final_car_df["market_key"] == market_key].copy()
    hikes = sub[sub["type"] == "hike"]["car"]
    cuts = sub[sub["type"] == "cut"]["car"]
    if len(hikes) < 2 or len(cuts) < 2:
        return None
    t_stat, p_value = stats.ttest_ind(np.abs(hikes), np.abs(cuts), equal_var=False, nan_policy="omit")
    return {
        "market_key": market_key,
        "mean_abs_hike_car": np.abs(hikes).mean(),
        "mean_abs_cut_car": np.abs(cuts).mean(),
        "t_stat": t_stat,
        "p_value": p_value,
    }
