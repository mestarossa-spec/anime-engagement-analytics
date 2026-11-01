import sqlite3
import sys

import pandas as pd


# Windows consoles default to cp1252, which can't print some anime titles
sys.stdout.reconfigure(encoding="utf-8", errors="replace")

pd.set_option("display.width", 200)
pd.set_option("display.max_rows", 200)

conn = sqlite3.connect("data/anime.db")
with open(sys.argv[1], encoding="utf-8") as f:
    sql = f.read()
print(pd.read_sql_query(sql, conn).to_string(index=False))
conn.close()
