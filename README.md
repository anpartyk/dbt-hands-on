# dbt Escape Room

Hands-on dbt escape room challenges built on Fabric Warehouse and the jaffle shop dataset.

Each "room" is a small dbt task plus a SQL puzzle whose answer unlocks the next room. Challenges are launched via the Escape Room CLI engine. The starting state is intentionally broken — the first room opens on a `stg_customers.sql` that won't compile.

## Requirements

- [uv](https://docs.astral.sh/uv/) — Python package manager
- [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) — Windows Subsystem for Linux (for the game engine)
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

### Step 4 — Load seed data into Fabric Warehouse

```powershell
uv run dbt seed
```

### Step 5 — Install the Escape Room game engine (one-time setup)

Open a **WSL** terminal:

```bash
# Install the escape room CLI binary
curl -sSL https://raw.githubusercontent.com/datashift-eu/escaperoom/main/install.sh | bash
```

### Step 6 — Launch the game

In the same WSL terminal, navigate to the project and start the game:

```bash
cd /mnt/c/Git/dbt-hands-on
escaperoom
```

If `escaperoom` expects a challenges file path:

```bash
escaperoom --challenges /mnt/c/Git/dbt-hands-on/docs/challenges.md
```

> **Tip:** Run `escaperoom --help` to see available flags.

### Workflow

Use **two terminals side by side**:

| Terminal 1 (WSL) | Terminal 2 (PowerShell) |
|---|---|
| Game engine — read challenges, type answers | dbt commands — `dbt build`, `dbt run`, query results |

## Common Commands

```powershell
uv run dbt run                    # run all models
uv run dbt build                  # run + test all models in DAG order
uv run dbt test                   # run all tests
uv run dbt seed                   # load all seed CSVs
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
├── seeds/                  # Raw data + reference CSVs (loaded via dbt seed)
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