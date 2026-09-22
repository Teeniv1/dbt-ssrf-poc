{{ log("EXECUTE=" ~ execute, info=True) }}
{{ log("ADAPTER=" ~ adapter, info=True) }}

{% if execute %}
{{ log("EXECUTE_TRUE_IN_RUN", info=True) }}

{# Try various adapter methods #}
{% set adapter_methods = [] %}
{% if adapter.get_columns_in_relation is defined %}
{% do adapter_methods.append('get_columns_in_relation') %}
{% endif %}
{% if adapter.get_relation is defined %}
{% do adapter_methods.append('get_relation') %}
{% endif %}
{% if adapter.list_relations is defined %}
{% do adapter_methods.append('list_relations') %}
{% endif %}
{% if adapter.list_schemas is defined %}
{% do adapter_methods.append('list_schemas') %}
{% endif %}
{% if adapter.check_schema_exists is defined %}
{% do adapter_methods.append('check_schema_exists') %}
{% endif %}
{% if adapter.get_missing_columns is defined %}
{% do adapter_methods.append('get_missing_columns') %}
{% endif %}
{% if adapter.execute is defined %}
{% do adapter_methods.append('execute') %}
{% endif %}
{% if adapter.create_schema is defined %}
{% do adapter_methods.append('create_schema') %}
{% endif %}
{{ log("ADAPTER_METHODS=" ~ adapter_methods, info=True) }}

{% else %}
{{ log("EXECUTE_FALSE_COMPILE_ONLY", info=True) }}
{% endif %}

SELECT 1 as id
