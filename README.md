# Anime Engagement Analytics

An analytics project for exploring anime engagement data from Kaggle.

## Project layout

- `data/raw/` — original source CSVs; do not edit these files.
- `data/clean/` — cleaned datasets produced in the next step.
- `notebooks/` — exploratory analysis notebooks.
- `sql/` — SQLite queries and database assets.
- `src/` — reusable Python scripts.
- `powerbi/` — Power BI reports and supporting files.
- `docs/` — project notes and documentation.

## Step 1: Set up Python

From this project folder in PowerShell:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install pandas
```

If PowerShell blocks the activation script, run the commands in Command Prompt instead:

```bat
.venv\Scripts\activate.bat
python -m pip install pandas
```

## Step 1: Profile the raw CSV

1. Place the downloaded Kaggle CSV in `data/raw/` without changing it.
2. Activate the virtual environment.
3. Run:

```powershell
python src/profile_data.py
```

The script lists CSV files in `data/raw/`, then reports row and column counts, data types, missing values, duplicate rows, sample records, and basic numeric summaries. It does not alter any data.

## SQL layer

SQLite is the default because it requires no server installation. SQL queries can be added under `sql/` once the raw data has been profiled.
