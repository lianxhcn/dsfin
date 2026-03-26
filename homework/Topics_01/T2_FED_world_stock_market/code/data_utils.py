import pandas as pd
import numpy as np
import akshare as ak
import yfinance as yf
import time
from pathlib import Path


MARKET_CONFIG = {
    "GSPC": {"label": "标普500", "ticker": "^GSPC", "source": "yfinance", "market": "US"},
    "HS300": {"label": "沪深300", "ticker": "000300", "source": "akshare", "market": "CN", "fallback_ticker": "000300.SS"},
    "N225": {"label": "日经225", "ticker": "^N225", "source": "yfinance", "market": "JP"},
    "FTSE": {"label": "富时100", "ticker": "^FTSE", "source": "yfinance", "market": "UK"},
    "DAX": {"label": "DAX", "ticker": "^GDAXI", "source": "yfinance", "market": "DE"},
    "HSI": {"label": "恒生指数", "ticker": "^HSI", "source": "yfinance", "market": "HK"},
}


def ensure_directory(path):
    Path(path).mkdir(parents=True, exist_ok=True)


def download_fed_rate(start_date="2000-01-01"):
    """Download federal funds target upper rate series and derive rate change events."""
    akshare_candidates = [
        "macro_usa_federal_fund_rate",
        "macro_usa_interest_rate",
        "macro_usa_ff_rate",
    ]
    fed = None

    for func_name in akshare_candidates:
        func = getattr(ak, func_name, None)
        if func is None:
            continue
        try:
            raw = func()
            if raw is None or raw.empty:
                continue
            date_col = "日期" if "日期" in raw.columns else raw.columns[0]
            value_col = "今值" if "今值" in raw.columns else raw.columns[-1]
            fed = raw[[date_col, value_col]].copy()
            fed.columns = ["date", "rate_after"]
            fed["date"] = pd.to_datetime(fed["date"])
            fed["rate_after"] = pd.to_numeric(fed["rate_after"], errors="coerce")
            fed = fed.dropna().sort_values("date")
            break
        except Exception:
            continue

    if fed is None:
        fred_url = "https://fred.stlouisfed.org/graph/fredgraph.csv?id=DFEDTARU"
        try:
            raw = pd.read_csv(fred_url)
            raw.columns = ["date", "rate_after"]
            raw["date"] = pd.to_datetime(raw["date"])
            raw["rate_after"] = pd.to_numeric(raw["rate_after"], errors="coerce")
            fed = raw.dropna().sort_values("date")
        except Exception as exc:
            raise RuntimeError(f"Failed to download Fed rate data from akshare and FRED: {exc}") from exc

    fed = fed[fed["date"] >= pd.Timestamp(start_date)].reset_index(drop=True)

    fed["rate_before"] = fed["rate_after"].shift(1)
    fed["change_bp"] = ((fed["rate_after"] - fed["rate_before"]) * 100).round(0)
    fed.loc[fed["rate_before"].isna(), "change_bp"] = np.nan
    fed["type"] = np.select(
        [fed["change_bp"] > 0, fed["change_bp"] < 0, fed["change_bp"] == 0],
        ["hike", "cut", "hold"],
        default=None,
    )
    fed["year"] = fed["date"].dt.year
    fed["event_id"] = np.arange(1, len(fed) + 1)
    return fed


def build_fed_events(fed_rate_df):
    events = fed_rate_df.dropna(subset=["change_bp"]).copy()
    events["change_bp"] = events["change_bp"].astype(int)
    events = events[events["change_bp"] != 0].copy()
    events["type_cn"] = events["type"].map({"hike": "加息", "cut": "降息"})
    return events.reset_index(drop=True)


def download_single_market_price(market_key, start_date="2000-01-01", end_date=None):
    config = MARKET_CONFIG[market_key]
    if config["source"] == "yfinance":
        data = yf.download(
            config["ticker"],
            start=start_date,
            end=end_date,
            auto_adjust=True,
            progress=False,
        )
        if data.empty:
            raise RuntimeError(f"No data returned for {market_key}")
        if isinstance(data.columns, pd.MultiIndex):
            if "Close" in data.columns.get_level_values(0):
                close_data = data.xs("Close", axis=1, level=0)
            else:
                close_data = data.iloc[:, [0]]
        else:
            close_data = data[["Close"]] if "Close" in data.columns else data.iloc[:, [0]]

        if isinstance(close_data, pd.Series):
            prices = close_data.to_frame(name=market_key)
        else:
            if close_data.shape[1] > 1:
                close_data = close_data.iloc[:, [0]]
            prices = close_data.copy()
            prices.columns = [market_key]
    else:
        if end_date is None:
            end_date = pd.Timestamp.today().strftime("%Y%m%d")
        else:
            end_date = pd.Timestamp(end_date).strftime("%Y%m%d")
        start_fmt = pd.Timestamp(start_date).strftime("%Y%m%d")
        last_error = None
        prices = None
        for _ in range(3):
            try:
                data = ak.index_zh_a_hist(symbol=config["ticker"], period="daily", start_date=start_fmt, end_date=end_date)
                if data is not None and not data.empty:
                    prices = data[["日期", "收盘"]].copy()
                    prices.columns = ["Date", market_key]
                    prices["Date"] = pd.to_datetime(prices["Date"])
                    prices = prices.set_index("Date")
                    break
            except Exception as exc:
                last_error = exc
                time.sleep(1)

        if prices is None:
            fallback_ticker = config.get("fallback_ticker")
            if fallback_ticker:
                fallback = yf.download(
                    fallback_ticker,
                    start=start_date,
                    end=None if end_date is None else pd.Timestamp(end_date).strftime("%Y-%m-%d"),
                    auto_adjust=True,
                    progress=False,
                )
                if fallback is not None and not fallback.empty:
                    if isinstance(fallback.columns, pd.MultiIndex):
                        close_data = fallback.xs("Close", axis=1, level=0) if "Close" in fallback.columns.get_level_values(0) else fallback.iloc[:, [0]]
                    else:
                        close_data = fallback[["Close"]] if "Close" in fallback.columns else fallback.iloc[:, [0]]
                    if isinstance(close_data, pd.Series):
                        prices = close_data.to_frame(name=market_key)
                    else:
                        if close_data.shape[1] > 1:
                            close_data = close_data.iloc[:, [0]]
                        prices = close_data.copy()
                        prices.columns = [market_key]

        if prices is None:
            raise RuntimeError(f"No data returned for {market_key}; last error: {last_error}")

    prices.index = pd.to_datetime(prices.index)
    prices = prices.sort_index()
    prices[market_key] = pd.to_numeric(prices[market_key], errors="coerce")
    return prices.dropna()


def download_global_market_prices(start_date="2000-01-01", end_date=None):
    frames = []
    for market_key in MARKET_CONFIG:
        market_prices = download_single_market_price(market_key, start_date=start_date, end_date=end_date)
        frames.append(market_prices)
    price_df = pd.concat(frames, axis=1).sort_index()
    return price_df


def compute_log_returns(price_df):
    returns = np.log(price_df / price_df.shift(1))
    return returns.dropna(how="all")


def align_event_to_trading_day(event_date, market_returns_index):
    """Map event date to first available trading day on or after the event date."""
    event_date = pd.Timestamp(event_date)
    future_dates = market_returns_index[market_returns_index >= event_date]
    if len(future_dates) == 0:
        return None
    return future_dates[0]


def align_events_for_all_markets(events_df, returns_df):
    aligned_records = []
    for _, row in events_df.iterrows():
        record = row.to_dict()
        for market_key in MARKET_CONFIG:
            mapped_date = align_event_to_trading_day(row["date"], returns_df[market_key].dropna().index)
            record[f"{market_key}_event_date"] = mapped_date
        aligned_records.append(record)
    return pd.DataFrame(aligned_records)


def summarize_event_counts(events_df):
    summary = events_df.groupby("type").agg(
        count=("event_id", "count"),
        avg_change_bp=("change_bp", "mean"),
        min_date=("date", "min"),
        max_date=("date", "max"),
    )
    return summary.reset_index()
