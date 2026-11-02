# Anime Engagement Analytics



An analytics project for exploring [anime engagement](https://www.kaggle.com/datasets/tanishksharma9905/top-popular-anime?resource=download) data from Kaggle.

<img width="1411" height="809" alt="image" src="https://github.com/user-attachments/assets/d0680471-4eae-486e-8794-855e4b6ade6a" />
<img width="1412" height="807" alt="image" src="https://github.com/user-attachments/assets/a8d8c63e-b0cd-4206-8206-3e5f527a2eaf" />
<img width="1414" height="807" alt="image" src="https://github.com/user-attachments/assets/f784754d-8974-4d1e-a460-7dc36222c51e" />


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


