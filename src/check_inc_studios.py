import sys

import pandas as pd

sys.stdout.reconfigure(encoding="utf-8", errors="replace")

df = pd.read_csv(sys.argv[1]).drop_duplicates()
s = df["studios"].dropna()
hits = s[s.str.contains(r"(?:^|, )Inc\.(?:,|$)", regex=True)]

print("rows with an 'Inc.' fragment:", len(hits))
print()
print(hits.value_counts().to_string())