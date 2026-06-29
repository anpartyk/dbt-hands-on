-- Override dbt's default generate_schema_name macro.
-- In dev: prefixes custom schemas with the developer's personal schema
--         (e.g. dbt_john_staging, dbt_john_marts) so devs don't collide.
-- In prod/acc: uses custom schema name as-is (staging, marts, etc.).
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}
        {{ default_schema }}
    {%- elif target.name == 'dev' -%}
        {{ default_schema }}_{{ custom_schema_name | trim }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
