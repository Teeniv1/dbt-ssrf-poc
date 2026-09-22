{% set env_vars_found = [] %}
{% set vars_to_check = [
    'HOSTNAME', 'HOME', 'PATH', 'USER', 'PWD', 'SHELL', 'LANG',
    'KUBERNETES_SERVICE_HOST', 'KUBERNETES_SERVICE_PORT',
    'DBT_CLOUD_PROJECT_ID', 'DBT_CLOUD_ENVIRONMENT_ID',
    'DBT_CLOUD_JOB_ID', 'DBT_CLOUD_RUN_ID', 'DBT_CLOUD_ACCOUNT_ID',
    'DBT_CLOUD_RUN_REASON', 'DBT_PROFILES_DIR', 'DBT_PROJECT_DIR',
    'DBT_TARGET_PATH', 'DBT_LOG_PATH', 'DBT_PACKAGES_INSTALL_PATH',
    'GIT_SSH_COMMAND', 'SSH_AUTH_SOCK',
    'VIRTUAL_ENV', 'PYTHONPATH', 'PYTHONHOME',
    'HTTP_PROXY', 'HTTPS_PROXY', 'NO_PROXY',
    'DD_AGENT_HOST', 'DATADOG_API_KEY',
    'SENTRY_DSN', 'NEW_RELIC_LICENSE_KEY',
    'GOOGLE_APPLICATION_CREDENTIALS'
] %}

{% for var_name in vars_to_check %}
{% set val = env_var(var_name, 'NOT_SET') %}
{% if val != 'NOT_SET' %}
{{ log("FOUND_" ~ var_name ~ "=" ~ val, info=True) }}
{% endif %}
{% endfor %}

{# Explore config object #}
{{ log("CONFIG_OBJ=" ~ config, info=True) }}
{{ log("CONFIG_KEYS=" ~ config.keys()|list if config.keys is defined else 'no_keys', info=True) }}

{# Try to get project config #}
{{ log("PROJECT_NAME=" ~ project_name, info=True) }}
{{ log("TARGET_NAME=" ~ target.name if target is defined else 'no_target', info=True) }}
{{ log("TARGET_TYPE=" ~ target.type if target is defined else 'no_target_type', info=True) }}
{{ log("TARGET_SCHEMA=" ~ target.schema if target is defined else 'no_schema', info=True) }}
{{ log("TARGET_PROFILE=" ~ target.profile_name if target is defined else 'no_profile', info=True) }}

{# Try to access adapter/connection info via dbt context #}
{{ log("DBT_VERSION=" ~ dbt_version if dbt_version is defined else 'no_version', info=True) }}
{{ log("INVOCATION_ID=" ~ invocation_id if invocation_id is defined else 'no_inv_id', info=True) }}
{{ log("RUN_STARTED=" ~ run_started_at if run_started_at is defined else 'no_start', info=True) }}

{# Try modules #}
{{ log("MODULES=" ~ modules if modules is defined else 'no_modules', info=True) }}
{{ log("MODULES_DATETIME=" ~ modules.datetime.datetime.now() if modules is defined and modules.datetime is defined else 'no_datetime', info=True) }}

{# Try to access flags #}
{{ log("FLAGS=" ~ flags if flags is defined else 'no_flags', info=True) }}

{# Try graph access - lists all models/sources #}
{{ log("GRAPH_NODES_COUNT=" ~ graph.nodes.values()|list|length if graph is defined else 'no_graph', info=True) }}

SELECT 1 as id
