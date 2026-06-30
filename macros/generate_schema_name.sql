-- Override dbt's default generate_schema_name macro.
-- Seeds go to <default_schema>_seed (e.g. dbt_hands_on_john_seed).
-- All models go to <default_schema> (e.g. dbt_hands_on_john).
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if node.resource_type == 'seed' -%}
        {{ default_schema }}_seed
    {%- else -%}
        {{ default_schema }}
    {%- endif -%}
{%- endmacro %}
