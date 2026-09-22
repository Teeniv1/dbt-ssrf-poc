{{ log("SSH_CONFIG_PATH=/tmp/jobs/" ~ env_var('DBT_CLOUD_RUN_ID', 'UNKNOWN') ~ "/.ssh/config", info=True) }}
{{ log("PROFILES_PATH=/tmp/jobs/" ~ env_var('DBT_CLOUD_RUN_ID', 'UNKNOWN') ~ "/.dbt/profiles.yml", info=True) }}

{# Check if builtins module is accessible #}
{% if modules.builtins is defined %}
{{ log("BUILTINS_AVAILABLE=yes", info=True) }}
{% else %}
{{ log("BUILTINS_NOT_AVAILABLE", info=True) }}
{% endif %}

{# Try adapter methods #}
{% if adapter is defined %}
{{ log("ADAPTER_TYPE=" ~ adapter.type() if adapter.type is defined else 'no_type_method', info=True) }}
{% endif %}

{# Check execute flag #}
{{ log("EXECUTE_FLAG=" ~ execute, info=True) }}

{% if execute %}
{{ log("EXECUTE_IS_TRUE_RUNNING_QUERY", info=True) }}
{# Try to make a network call via BigQuery adapter #}
{% set q = run_query("SELECT 1 as probe") %}
{{ log("QUERY_RESULT=" ~ q, info=True) }}
{% else %}
{{ log("EXECUTE_IS_FALSE_NO_QUERY", info=True) }}
{% endif %}

SELECT 1 as id
