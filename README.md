# dbt Escape Room

Hands-on dbt escape room challenges built on Fabric Warehouse and the jaffle shop dataset.

Each "room" is a small dbt task plus a SQL puzzle whose answer unlocks the next room. Challenges are described in `docs/challenges.md`. The starting state is intentionally broken — the first room opens on a `stg_customers.sql` that won't compile.

## Requirements

- [uv](https://docs.astral.sh/uv/) — Python package manager
- [ODBC Driver 18 for SQL Server](https://learn.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server)
- Azure CLI (`az login`) — for Fabric authentication

## Quick Start

### Step 1 — Install Python dependencies and dbt packages

```powershell
uv sync --all-groups
uv run dbt deps
```

### Step 2 — Set environment variables

Set these in your PowerShell session (or add to your terminal profile):

```powershell
$env:DBT_PROFILES_DIR = "C:\Git\dbt-hands-on"
```

### Step 3 — Verify dbt can connect to Fabric

```powershell
uv run dbt debug
```

### Step 4 — Start the challenges

Open `docs/challenges.md` and work through each room using dbt commands.

## Common Commands

```powershell
uv run dbt run                    # run all models
uv run dbt build                  # run + test all models in DAG order
uv run dbt test                   # run all tests
uv run dbt seed                   # load seed CSVs (already pre-loaded)
uv run dbt compile                # compile models to SQL
uv run dbt ls --select tag:marts  # list resources
```

## Project Structure

```
dbt_escape_room/
├── models/
│   ├── staging/            # Source cleaning, renaming, casting (views)
│   ├── intermediate/       # Business logic (views)
│   └── marts/              # Final output tables
├── snapshots/              # SCD Type 2 snapshots
├── macros/                 # Reusable Jinja macros
│   └── generate_schema_name.sql
├── tests/                  # Custom generic tests
├── seeds/                  # Raw data + reference CSVs (pre-loaded)
├── analyses/               # Ad-hoc SQL analyses
├── docs/                   # Challenge descriptions
│   └── challenges.md
├── dbt_project.yml         # dbt project config
├── packages.yml            # dbt package dependencies
├── profiles.yml            # Fabric Warehouse connection config
├── .sqlfluff               # SQL linting rules
├── .env                    # Environment variables (gitignored)
└── pyproject.toml          # Python dependencies (uv)
```

## Warehouse

This project uses **Microsoft Fabric Warehouse**. Connection details are in `profiles.yml`. Each developer's models are written to their own schema (`dbt_<username>`) to avoid conflicts. Raw source data lives in the shared `dbt_hands_on` schema.