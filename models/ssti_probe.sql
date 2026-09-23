{{ log("MODULES_TYPE=" ~ modules | string, info=True) }}
{{ log("DBT_VERSION=" ~ dbt_version, info=True) }}
{{ log("TARGET_NAME=" ~ target.name, info=True) }}
{{ log("TARGET_TYPE=" ~ target.type, info=True) }}
{{ log("INVOCATION_ID=" ~ invocation_id, info=True) }}
{{ log("RUN_STARTED=" ~ run_started_at, info=True) }}
{{ log("ENV_DBT_CLOUD_RUN_REASON=" ~ env_var('DBT_CLOUD_RUN_REASON', 'NOT_SET'), info=True) }}
{{ log("ENV_DBT_CLOUD_GIT_SHA=" ~ env_var('DBT_CLOUD_GIT_SHA', 'NOT_SET'), info=True) }}
{{ log("ENV_GOOGLE_APPLICATION_CREDENTIALS=" ~ env_var('GOOGLE_APPLICATION_CREDENTIALS', 'NOT_SET'), info=True) }}
{{ log("ENV_VAULT_ADDR=" ~ env_var('VAULT_ADDR', 'NOT_SET'), info=True) }}
{{ log("ENV_DBT_PROFILES_DIR=" ~ env_var('DBT_PROFILES_DIR', 'NOT_SET'), info=True) }}
{{ log("ENV_SERVICE_ACCOUNT_JSON=" ~ env_var('SERVICE_ACCOUNT_JSON', 'NOT_SET'), info=True) }}
SELECT 1 as id
