{% macro adapter_probe() %}
  {{ log("ADAPTER_TYPE=" ~ (adapter | string), info=True) }}
  {{ log("ADAPTER_DIR=" ~ (adapter | list | join(",")), info=True) }}
  
  {% set cfg = adapter.config %}
  {{ log("CONFIG_TYPE=" ~ (cfg | string), info=True) }}
  
  {% set creds = cfg.credentials %}
  {{ log("CREDS_TYPE=" ~ (creds.__class__.__name__), info=True) }}
  
  {% set conn_mgr = adapter.connections %}
  {{ log("CONN_MGR=" ~ (conn_mgr | string), info=True) }}
  
  {% set exc = exceptions %}
  {{ log("EXCEPTIONS=" ~ (exc | string), info=True) }}
  
  {% if execute %}
    {% set results = run_query("SELECT 1 as test") %}
    {{ log("QUERY_RESULT=" ~ (results | string), info=True) }}
    {{ log("QUERY_COLUMNS=" ~ (results.column_names | join(",")), info=True) }}
  {% endif %}
  
  {{ log("API=" ~ (api | string), info=True) }}
  {{ log("GRAPH_KEYS=" ~ (graph | list | join(",")), info=True) }}
  {{ log("FLAGS=" ~ (flags | string), info=True) }}
{% endmacro %}
