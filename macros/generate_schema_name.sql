-- Override dbt's default generate_schema_name macro.
-- Seeds always go to their configured schema (dbt_hands_on) so all devs share raw data.
-- Models in dev get prefixed with the developer's personal schema (e.g. dbt_john_staging).
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}
        {{ default_schema }}
    {%- elif node.resource_type == 'seed' -%}
        {{ custom_schema_name | trim }}
    {%- elif target.name == 'dev' -%}
        {{ default_schema }}_{{ custom_schema_name | trim }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
