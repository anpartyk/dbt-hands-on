set dotenv-load := true
set positional-arguments := true

# List all commands
default:
    @just --list

# -- Setup ---------------------------------
install:
    uv sync --all-groups

deps:
    uv run dbt deps

setup: install deps
    @echo "Project ready! Make sure FABRIC_SERVER and FABRIC_DATABASE env vars are set."

# -- dbt -----------------------------------
# Every dbt wrapper forwards extra args through to dbt, so any dbt flag works:
#   just run --select stg_customers
#   just build --select tag:marts --target pro
#   just test --select stg_customers
#   just full-refresh --select stg_payments_incremental
#   just seed --target acc
# Default target is `dev` (set in profiles.yml via DBT_TARGET env var).

compile *args:
    uv run dbt compile "$@"

run *args:
    uv run dbt run "$@"

build *args:
    uv run dbt build "$@"

test *args:
    uv run dbt test "$@"

seed *args:
    uv run dbt seed "$@"

snapshot *args:
    uv run dbt snapshot "$@"

debug *args:
    uv run dbt debug "$@"

# Generic dbt passthrough — use this for any dbt subcommand not wrapped above.
# Examples:
#   just dbt ls --quiet
#   just dbt ls --quiet --select +int_payment_totals_by_order
#   just dbt parse
#   just dbt run-operation drop_orphaned_objects
dbt *args:
    uv run dbt "$@"

# Check source freshness — surfaces stale sources defined with freshness configs.
# Example: just source-freshness --select source:jaffle_shop.raw_web_events
source-freshness *args:
    uv run dbt source freshness "$@"

full-refresh *args:
    uv run dbt run --full-refresh "$@"

docs *args:
    uv run dbt docs generate "$@"
    uv run dbt docs serve

# Propagate column descriptions from upstream to downstream YAML files.
# Run after updating descriptions in staging models to keep docs in sync.
osmosis *args:
    uv run dbt-osmosis yaml refactor "$@"

# -- Linting -------------------------------
lint:
    uv run sqlfluff lint models snapshots

fix:
    uv run sqlfluff fix models snapshots

lint-py:
    uv run ruff check .

format-py:
    uv run ruff format .

lint-all: lint lint-py

# -- Verify -------------------------------
verify *args:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "Verifying project setup..."
    echo ""
    echo "Checking required environment variables..."
    : "${FABRIC_SERVER:?Set FABRIC_SERVER to your Fabric SQL endpoint}"
    : "${FABRIC_DATABASE:?Set FABRIC_DATABASE to your Fabric Warehouse name}"
    echo "OK: FABRIC_SERVER=$FABRIC_SERVER"
    echo "OK: FABRIC_DATABASE=$FABRIC_DATABASE"
    echo ""
    echo "Checking dbt connection..."
    uv run dbt debug "$@" 2>&1 | tail -20
    echo ""
    echo "Compiling dbt project..."
    uv run dbt compile "$@"
    echo ""
    echo "All checks passed!"

# -- Data Loading --------------------------
# Load raw tables into Fabric Warehouse from CSV exports.
# Requires FABRIC_SERVER and FABRIC_DATABASE env vars.
load-data:
    uv run --group scripts python scripts/load_starter_data.py

# Regenerate starter CSV files from scratch using Faker (maintainers only).
generate-csv:
    uv run --group scripts python scripts/generate_starter_csv.py

# -- CI ------------------------------------
ci: deps lint-all build
