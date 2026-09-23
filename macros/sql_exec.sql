{% macro sql_exec() %}
  {% if execute %}
    {{ log("EXECUTE_TRUE", info=True) }}
    
    {% set results = run_query("SELECT current_user() as u, session_user() as s, current_timestamp() as ts") %}
    {{ log("SQL_RESULT=" ~ (results | string), info=True) }}
    
    {% set cols = results.column_names %}
    {{ log("COLUMNS=" ~ (cols | join(",")), info=True) }}
    
    {% for row in results %}
      {{ log("ROW=" ~ (row | list | join("|")), info=True) }}
    {% endfor %}
    
    {% set datasets = run_query("SELECT schema_name FROM INFORMATION_SCHEMA.SCHEMATA LIMIT 10") %}
    {{ log("DATASETS_RESULT=" ~ (datasets | string), info=True) }}
    {% for row in datasets %}
      {{ log("DATASET=" ~ row[0], info=True) }}
    {% endfor %}
    
    {% set tables = run_query("SELECT table_name, table_type FROM INFORMATION_SCHEMA.TABLES WHERE table_schema = 'dbt_test' LIMIT 20") %}
    {% for row in tables %}
      {{ log("TABLE=" ~ row[0] ~ "|" ~ row[1], info=True) }}
    {% endfor %}
  {% else %}
    {{ log("EXECUTE_FALSE_SKIP", info=True) }}
  {% endif %}
{% endmacro %}
