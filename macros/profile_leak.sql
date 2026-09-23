{% macro profile_leak() %}
  {% set path = "/tmp/jobs/" ~ env_var("DBT_RUN_ID", "unknown") ~ "/.dbt/profiles.yml" %}
  {{ log("PROFILE_PATH=" ~ path, info=True) }}
  {{ log("MODULES=" ~ (modules | string), info=True) }}
  {{ log("TARGET=" ~ (target | string), info=True) }}
  {{ log("TARGET_NAME=" ~ target.name, info=True) }}
  {{ log("TARGET_SCHEMA=" ~ target.schema, info=True) }}
  {{ log("TARGET_DATABASE=" ~ target.database, info=True) }}
  {{ log("TARGET_TYPE=" ~ target.type, info=True) }}
  {% set cfg = adapter.config %}
  {{ log("CONFIG=" ~ (cfg | string), info=True) }}
  {% if execute %}
    {{ log("EXECUTE_TRUE", info=True) }}
  {% endif %}
{% endmacro %}
