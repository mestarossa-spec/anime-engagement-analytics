import sqlite3
from pathlib import Path

import pandas as pd

CLEAN = Path("data/clean")
DB = Path("data/anime.db")

tables = {
    "fct_anime": {"dtype": {"episodes": "Int64", "scored_by": "Int64", "release_year": "Int64"}},
    "dim_genre": {},
    "bridge_anime_genre": {},
    "dim_studio": {},
    "bridge_anime_studio": {},
}

# bridge_anime_studio is 30,041 after the "Inc." name fix (was 30,075)
expected = {"fct_anime": 28607, "bridge_anime_genre": 48413, "bridge_anime_studio": 30041}

conn = sqlite3.connect(DB)
for name, opts in tables.items():
    df = pd.read_csv(CLEAN / f"{name}.csv", **opts)
    df.to_sql(name, conn, if_exists="replace", index=False)
    print(f"{name}: {len(df)} rows loaded")

conn.executescript("""
CREATE INDEX IF NOT EXISTS ix_fct_anime_id ON fct_anime(anime_id);
CREATE INDEX IF NOT EXISTS ix_bag_anime ON bridge_anime_genre(anime_id);
CREATE INDEX IF NOT EXISTS ix_bag_genre ON bridge_anime_genre(genre_id);
CREATE INDEX IF NOT EXISTS ix_bas_anime ON bridge_anime_studio(anime_id);
CREATE INDEX IF NOT EXISTS ix_bas_studio ON bridge_anime_studio(studio_id);
""")

for name, n in expected.items():
    actual = conn.execute(f"SELECT COUNT(*) FROM {name}").fetchone()[0]
    assert actual == n, f"{name}: expected {n}, got {actual}"
print("Row counts reconcile with the cleaning log.")
conn.close()