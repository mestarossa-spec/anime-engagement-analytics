import re
import sys
from pathlib import Path

import pandas as pd

RAW = Path(sys.argv[1])
OUT = Path("data/clean")
DOCS = Path("docs")
OUT.mkdir(parents=True, exist_ok=True)
DOCS.mkdir(exist_ok=True)

log = []


def record(check, value):
    log.append({"check": check, "value": value})
    print(f"{check}: {value}")


df = pd.read_csv(RAW)
record("rows_raw", len(df))

# --- 1. Remove exact duplicate rows (keep first) ---
n_dupes = int(df.duplicated().sum())
df = df.drop_duplicates(keep="first")
record("exact_duplicates_removed", n_dupes)
record("rows_after_dedup", len(df))

# Stop if ids are still not unique, so we decide the rule together
dup_ids = df["id"].duplicated(keep=False)
if dup_ids.any():
    print(df[dup_ids].sort_values("id")[["id", "name", "score", "scored_by"]].head(20).to_string())
    sys.exit(f"STOP: {int(dup_ids.sum())} rows share an id after dedup. Share this output.")

# --- 2. Trim whitespace in short text columns ---
for col in ["name", "type", "status", "rating"]:
    df[col] = df[col].str.strip()

# --- 3. Parse dates ---
def parse_dates(series):
    parsed = pd.to_datetime(series, errors="coerce", utc=True)
    unparseable = int((parsed.isna() & series.notna()).sum())
    return parsed.dt.tz_localize(None).dt.normalize(), unparseable


df["aired_from"], bad_from = parse_dates(df["aired_from"])
df["aired_to"], bad_to = parse_dates(df["aired_to"])
record("aired_from_unparseable", bad_from)
record("aired_to_unparseable", bad_to)
record("aired_to_before_aired_from", int((df["aired_to"] < df["aired_from"]).sum()))
df["release_year"] = df["aired_from"].dt.year.astype("Int64")

# --- 4. Parse duration text into minutes per episode ---
def parse_minutes(text):
    if pd.isna(text):
        return float("nan")
    t = text.lower()
    h = re.search(r"(\d+)\s*hr", t)
    m = re.search(r"(\d+)\s*min", t)
    s = re.search(r"(\d+)\s*sec", t)
    if not (h or m or s):
        return float("nan")
    return (
        (int(h.group(1)) * 60 if h else 0)
        + (int(m.group(1)) if m else 0)
        + (int(s.group(1)) / 60 if s else 0)
    )


df["duration_min_per_ep"] = df["duration_per_ep"].apply(parse_minutes).round(1)
unparsed = df[df["duration_min_per_ep"].isna() & df["duration_per_ep"].notna()]
record("duration_unparsed_to_null", len(unparsed))
if len(unparsed):
    print("Top unparsed duration values:")
    print(unparsed["duration_per_ep"].value_counts().head(5).to_string())

# --- 5. Flags (nothing is imputed) ---
df["has_score"] = df["score"].notna()
df["has_rank"] = df["rank"].notna()
record("titles_with_score", int(df["has_score"].sum()))
record("titles_without_score", int((~df["has_score"]).sum()))
record("rank_equals_zero_left_as_is", int((df["rank"] == 0).sum()))

# --- 6. Dimension + bridge tables for multi-value columns ---
def build_dim_and_bridge(frame, col, name_col, id_col):
    s = frame[["id", col]].copy()
    s[col] = s[col].fillna("Unknown")
    # Split on commas, except when the next word is "Inc." so names like
    # "Yamamura Animation, Inc." stay whole.
    s[name_col] = s[col].str.split(r",(?!\s*Inc\.)", regex=True)
    s = s.explode(name_col)
    s[name_col] = s[name_col].str.strip()
    s = s[s[name_col] != ""].drop_duplicates(["id", name_col])
    dim = pd.DataFrame({name_col: sorted(s[name_col].unique())})
    dim[id_col] = range(1, len(dim) + 1)
    bridge = s.merge(dim, on=name_col)[["id", id_col]].rename(columns={"id": "anime_id"})
    return dim[[id_col, name_col]], bridge


dim_genre, bridge_genre = build_dim_and_bridge(df, "genres", "genre_name", "genre_id")
dim_studio, bridge_studio = build_dim_and_bridge(df, "studios", "studio_name", "studio_id")
record("distinct_genres", len(dim_genre))
record("distinct_studios", len(dim_studio))

# --- 7. Build the fact table (heavy/unused text columns left out) ---
fct = df.rename(columns={"id": "anime_id"})[
    [
        "anime_id", "name", "type", "episodes", "status",
        "aired_from", "aired_to", "release_year", "duration_min_per_ep",
        "score", "scored_by", "rank", "rating", "has_score", "has_rank",
    ]
].copy()
fct["episodes"] = fct["episodes"].astype("Int64")
fct["scored_by"] = fct["scored_by"].astype("Int64")

# --- 8. Integrity checks ---
assert fct["anime_id"].is_unique, "anime_id not unique"
assert bridge_genre["anime_id"].isin(fct["anime_id"]).all(), "orphan genre bridge rows"
assert bridge_studio["anime_id"].isin(fct["anime_id"]).all(), "orphan studio bridge rows"
assert fct["anime_id"].nunique() == bridge_genre["anime_id"].nunique(), "anime missing from genre bridge"
assert "Inc." not in set(dim_studio["studio_name"]), "Inc. fragment still present"
record("fct_rows", len(fct))
record("bridge_genre_rows", len(bridge_genre))
record("bridge_studio_rows", len(bridge_studio))

# --- 9. Write outputs ---
fct.to_csv(OUT / "fct_anime.csv", index=False, encoding="utf-8-sig")
dim_genre.to_csv(OUT / "dim_genre.csv", index=False, encoding="utf-8-sig")
bridge_genre.to_csv(OUT / "bridge_anime_genre.csv", index=False)
dim_studio.to_csv(OUT / "dim_studio.csv", index=False, encoding="utf-8-sig")
bridge_studio.to_csv(OUT / "bridge_anime_studio.csv", index=False)
pd.DataFrame(log).to_csv(DOCS / "data_quality_log.csv", index=False)
print("\nDone. Files written to data/clean/ and docs/data_quality_log.csv")