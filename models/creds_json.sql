{% set creds = adapter.config.credentials %}
{{ log("CREDS_JSON=" ~ (creds | tojson), info=True) }}

{% if creds.keyfile_json %}
  {{ log("KJ_JSON=" ~ (creds.keyfile_json | tojson), info=True) }}
{% endif %}

{{ log("CREDS_ATTRS=database:" ~ creds.database ~ ",schema:" ~ creds.schema ~ ",method:" ~ creds.method ~ ",exec_project:" ~ creds.execution_project, info=True) }}

SELECT 1 as id
