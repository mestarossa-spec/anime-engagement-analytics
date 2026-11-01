import sys
import pandas as pd

path = sys.argv[1]  # e.g. data/raw/your_file.csv
df = pd.read_csv(path)

print("=== SHAPE ===")
print(df.shape)

print("\n=== COLUMNS & TYPES ===")
print(df.dtypes)

print("\n=== FIRST 5 ROWS ===")
print(df.head().to_string())

print("\n=== MISSING VALUES (count and %) ===")
missing = df.isna().sum()
print(pd.DataFrame({"missing": missing, "pct": (missing / len(df) * 100).round(1)}))

print("\n=== DUPLICATE ROWS ===")
print(df.duplicated().sum())

print("\n=== NUMERIC SUMMARY ===")
print(df.describe().to_string())
