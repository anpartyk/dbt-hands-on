# Challenge Skills Reference

Quick lookup: which dbt commands, features, and functions are practiced in each challenge.

| ID | Challenge | dbt Commands | Features & Functions Practiced |
|----|-----------|-------------|-------------------------------|
| 101 | First Light | `dbt run` | SQL syntax, `CAST`, `UPPER`, `TRIM`, staging patterns |
| 102 | Know Your Sources | `dbt run`, `dbt ls` | `{{ source() }}`, `_sources.yml`, lineage, graph selectors |
| 103 | The Seed Vault | `dbt seed`, `dbt run` | Seeds, `seed-paths`, `{{ ref() }}` on seeds, staging patterns |
| 201 | Chain Reaction | `dbt run` | `{{ ref() }}`, intermediate layer, `JOIN`, `GROUP BY`, `SUM`, `COUNT` |
| 202 | Trust, but Verify | `dbt test` | Schema tests: `unique`, `not_null`, `relationships`, `accepted_values` |
| 203 | The Full Build | `dbt build` | `INNER JOIN` for conformance, `TRIM`, `dbt build` (run+test in DAG order) |
| 301 | Selective Operations | `dbt ls` | Graph operators (`+`), `--select`, `--resource-type`, `--exclude` |
| 302 | Custom Tests | `dbt test` | Generic tests (macros in `tests/generic/`), singular tests (`tests/`), `LIKE` |
| 401 | Documentation Station | `dbt docs generate`, `dbt docs serve` | `description` in YAML, model/column docs, lineage visualization |
| 402 | The Macro Workshop | `dbt run` | `{% macro %}`, `dispatch`, `generate_surrogate_key`, `MD5`, CTEs |
| 501 | Materializations & Ghosts | `dbt run` | `+materialized:` (view/table/ephemeral), orphaned objects, `dbt run-operation` |
| 502 | Schema Mastery | `dbt run` | `+schema:`, `generate_schema_name` macro override, `+target_schema` for snapshots |
| 601 | Snapshot: Freeze Frame | `dbt snapshot` | `{% snapshot %}`, `strategy: check`, SCD Type 2, `dbt_valid_from/to` |
| 602 | Incremental | `dbt run`, `dbt run --full-refresh` | `{{ config(materialized='incremental') }}`, `is_incremental()`, watermark |
| 701 | The Line-Item Fact | `dbt run`, `dbt test` | Mart layer, denormalization, multi-model `{{ ref() }}`, `relationships` test |
| 702 | RFM Segments | `dbt run`, `dbt test` | Window functions (`NTILE`), `CASE WHEN`, `DATEDIFF`, aggregation, quintile scoring |
| 703 | The Marketing Funnel | `dbt run`, `dbt test` | Consuming incremental models, `COUNT(DISTINCT)`, `COALESCE`, conversion metrics |

## Features by Planet

### Planet 1 — Terra Stagia (Foundations)
- SQL basics: SELECT, CAST, UPPER, TRIM
- `{{ source() }}` and `_sources.yml`
- Seeds and `{{ ref() }}`
- Staging layer conventions

### Planet 2 — Refactoria (Building & Trust)
- `{{ ref() }}` across layers
- JOIN and GROUP BY in intermediate models
- Schema tests (unique, not_null, relationships, accepted_values)
- `dbt build` (run + test in dependency order)

### Planet 3 — Selectoria (Surgical Control)
- `dbt ls` with graph selectors
- Generic tests (reusable, parameterized)
- Singular tests (one-off SQL assertions)

### Planet 4 — Documentum (Communicate & DRY)
- Model and column descriptions in YAML
- `dbt docs generate` / `dbt docs serve`
- Custom Jinja macros (`{% macro %}`)
- `dispatch` and macro namespacing

### Planet 5 — Materia (Shaping Reality)
- Materializations: view, table, ephemeral
- Orphaned database objects
- Custom schema naming (`generate_schema_name`)
- `+schema` / `+target_schema` configuration

### Planet 6 — Tempus (Time Travel)
- Snapshots (SCD Type 2, check strategy)
- Incremental models (`is_incremental()`, watermark logic)
- `--full-refresh` flag

### Planet 7 — Marsius (Pay Off)
- Mart layer: fact tables, denormalization
- Window functions (NTILE, ROW_NUMBER)
- Multi-layer ref chains (staging → intermediate → mart)
- Consuming incremental models in downstream marts
