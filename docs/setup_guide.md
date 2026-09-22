# Setup Guide — dbt Escape Room (Fabric Edition)

Complete setup instructions for participants who are new to VS Code, Git, and dbt.

---

## Prerequisites (install BEFORE the workshop)

### 1. Software to Install

| # | Tool | What it is | Download link |
|---|------|-----------|---------------|
| 1 | **VS Code** | Code editor | https://code.visualstudio.com/download |
| 2 | **Git** | Version control | https://git-scm.com/download/win |
| 3 | **Python 3.11+** | Programming language | https://www.python.org/downloads/ (check "Add to PATH" during install) |
| 4 | **uv** | Python package manager | Open PowerShell and run: `irm https://astral.sh/uv/install.ps1 \| iex` |
| 5 | **ODBC Driver 18 for SQL Server** | Database driver for Fabric | https://learn.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server |
| 6 | **Azure CLI** | Authentication to Fabric | https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows |

### 2. Accounts & Access

| # | Requirement | How to verify |
|---|-------------|---------------|
| 1 | **Microsoft / Entra ID account** | You can sign in to https://portal.azure.com |
| 2 | **Access to the Fabric Warehouse** | You can see the warehouse in https://app.fabric.microsoft.com |
| 3 | **GitHub account** (optional) | Only needed if cloning via SSH; HTTPS works without |

### 3. VS Code Extensions (recommended)

Open VS Code → Extensions panel (`Ctrl+Shift+X`) → search and install:

| Extension | Purpose |
|-----------|---------|
| Python (Microsoft) | Python language support |
| dbt Power User | dbt syntax highlighting, lineage |
| Even Better TOML | pyproject.toml support |
| YAML (Red Hat) | YAML validation for dbt configs |

---

## Step-by-Step Setup

### Step 1 — Clone the repository

Open PowerShell:

```powershell
cd C:\Git
git clone https://github.com/anpartyk/dbt-hands-on.git
cd dbt-hands-on
```

### Step 2 — Install Python dependencies

```powershell
uv sync --all-groups
```

This creates a `.venv` folder and installs everything (dbt, linters, etc.).

### Step 3 — Install dbt packages

```powershell
uv run dbt deps
```

### Step 4 — Authenticate to Azure

```powershell
az login
```

A browser window opens — sign in with your company account.

### Step 5 — Set environment variables

Set these in the current PowerShell session (replace the Fabric placeholders
with your Warehouse SQL endpoint and database name if different):

```powershell
$env:DBT_PROFILES_DIR = "path to this repo"
$env:FABRIC_SERVER = "provided on training"
$env:FABRIC_DATABASE = "WH_Training"
```

These only last for the current PowerShell session — run them again (or add
them to your PowerShell profile) each time you open a new terminal.

### Step 6 — Verify connection

```powershell
uv run dbt debug
```

You should see `All checks passed!` at the bottom. If not, check:
- Is `az login` still valid? (tokens expire after ~1 hour of inactivity)
- Is ODBC Driver 18 installed?
- Can you reach the Fabric endpoint from your network?

### Step 7 — Verify everything works

```powershell
uv run dbt build
```

---

## Common Issues & Fixes

| Problem | Fix |
|---------|-----|
| `Env var required but not provided: 'FABRIC_SERVER'` | Set `$env:FABRIC_SERVER`, `$env:FABRIC_DATABASE`, and `$env:DBT_PROFILES_DIR` in the current PowerShell session (see Step 5) |
| `Login timeout expired` | Run `az login` again — your token expired |
| `ODBC Driver 18 for SQL Server not found` | Install the ODBC driver from the link above, restart terminal |
| `uv: command not found` | Close and reopen PowerShell after installing uv |
| `dbt: command not found` | Use `uv run dbt` instead of plain `dbt` |
| `Permission denied on schema` | Ask the workshop organizer to grant you access to create schemas in the Fabric Warehouse |

---

## Quick Reference — Daily Commands

```powershell
# Always start with (if token expired):
az login

# Run models:
uv run dbt run

# Run models + tests:
uv run dbt build

# Run a specific model:
uv run dbt run --select stg_customers

# Run tests only:
uv run dbt test

# See what depends on a model:
uv run dbt ls --select stg_customers+
```

---

## Project Overview

```
C:\Git\dbt-hands-on\
├── models/           ← Your SQL models go here
│   ├── staging/      ← 1:1 with sources (views)
│   ├── intermediate/ ← Business logic (views)
│   └── marts/        ← Final tables for analysts
├── seeds/            ← CSV data loaded into Fabric
├── macros/           ← Reusable SQL snippets
├── tests/            ← Custom data tests
├── docs/             ← Challenge descriptions
├── profiles.yml      ← Fabric connection config
└── dbt_project.yml   ← Project settings
```

**Schema layout in Fabric:**
- `dbt_seed_<your_username>` — your personal schema for seeded raw data
- `dbt_<your_username>` — your personal schema for models
