-- Override dbt's default generate_schema_name macro.
-- Schema is derived from the OS username, not target.schema, so it's
-- consistent regardless of how DBT_SCHEMA is set in a developer's .env.
-- Seeds go to dbt_seed_<username> (e.g. dbt_seed_john).
-- All models go to dbt_<username> (e.g. dbt_john).
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set username = env_var('USERNAME', 'dev') -%}
    {%- if node.resource_type == 'seed' -%}
        dbt_seed_{{ username }}
    {%- else -%}
        dbt_{{ username }}
    {%- endif -%}
{%- endmacro %}
