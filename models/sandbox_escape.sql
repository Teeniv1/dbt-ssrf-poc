{# dbt context exploration - what methods/attrs are available #}

{# Try adapter operations #}
{{ log("ADAPTER=" ~ adapter if adapter is defined else 'no_adapter', info=True) }}

{# Try to list all available context variables #}
{# In dbt, 'this' refers to the current model's relation #}
{{ log("THIS=" ~ this if this is defined else 'no_this', info=True) }}

{# Try exceptions module #}
{{ log("EXCEPTIONS=" ~ exceptions if exceptions is defined else 'no_exceptions', info=True) }}

{# Try selected_resources #}
{{ log("SELECTED=" ~ selected_resources if selected_resources is defined else 'no_selected', info=True) }}

{# Try model context #}
{{ log("MODEL=" ~ model if model is defined else 'no_model', info=True) }}

{# Try execute flag - if True, we can run queries #}
{{ log("EXECUTE=" ~ execute if execute is defined else 'no_execute', info=True) }}

{# Try run_query if execute is True #}
{% if execute %}
{{ log("EXECUTE_IS_TRUE", info=True) }}
{% else %}
{{ log("EXECUTE_IS_FALSE_COMPILE_ONLY", info=True) }}
{% endif %}

{# Try to use run_query during compile (will probably fail but info on error msg) #}
{% set test_query = run_query("SELECT 1 as test") %}
{{ log("QUERY_RESULT=" ~ test_query, info=True) }}

{# Try fromjson / tojson #}
{{ log("TOJSON_TEST=" ~ tojson({"key":"val"}), info=True) }}

{# Try env_var with some dbt internal prefixes #}
{{ log("DBT_CLOUD_GIT_SHA=" ~ env_var('DBT_CLOUD_GIT_SHA', 'NOT_SET'), info=True) }}
{{ log("DBT_CLOUD_GIT_BRANCH=" ~ env_var('DBT_CLOUD_GIT_BRANCH', 'NOT_SET'), info=True) }}
{{ log("DBT_CLOUD_ENVIRONMENT_TYPE=" ~ env_var('DBT_CLOUD_ENVIRONMENT_TYPE', 'NOT_SET'), info=True) }}
{{ log("DBT_CLOUD_URL=" ~ env_var('DBT_CLOUD_URL', 'NOT_SET'), info=True) }}
{{ log("ORCHESTRATOR_PATH=" ~ env_var('ORCHESTRATOR_PATH', 'NOT_SET'), info=True) }}

SELECT 1 as id
