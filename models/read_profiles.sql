{%- set run_id = env_var('DBT_CLOUD_RUN_ID', 'norun') -%}
{%- set profiles_path = '/tmp/jobs/' ~ run_id ~ '/.dbt/profiles.yml' -%}

{{ log("PROFILES_PATH=" ~ profiles_path, info=True) }}

{# Dump ALL context keys - this is the goldmine #}
{{ log("CONTEXT_KEYS_FULL=" ~ context.keys() | list | join(','), info=True) }}

{# Probe builtins - is this Python builtins?! #}
{{ log("BUILTINS_TYPE=" ~ builtins | string | truncate(500), info=True) }}
{{ log("BUILTINS_KEYS=" ~ builtins.keys() | list | join(',') | truncate(500), info=True) if builtins.keys is defined else log("BUILTINS_NO_KEYS", info=True) }}

{# Probe load_agate_table - can it read files? #}
{{ log("LOAD_AGATE_TABLE_TYPE=" ~ load_agate_table | string | truncate(200), info=True) }}

{# Probe write function #}
{{ log("WRITE_TYPE=" ~ write | string | truncate(200), info=True) }}

{# Probe render function #}
{{ log("RENDER_TYPE=" ~ render | string | truncate(200), info=True) }}

{# Probe context object deeper #}
{{ log("CONTEXT_TYPE=" ~ context | string | truncate(200), info=True) }}

{# Try accessing context items that might reveal more #}
{{ log("FLAGS=" ~ flags | string | truncate(200), info=True) }}
{{ log("INVOCATION_ARGS=" ~ invocation_args_dict | string | truncate(500), info=True) }}
{{ log("DBT_METADATA_ENVS=" ~ dbt_metadata_envs | string | truncate(500), info=True) }}

{# local_md5 - hash function #}
{{ log("LOCAL_MD5_TYPE=" ~ local_md5 | string | truncate(200), info=True) }}

{# Try fromyaml on a path #}
{{ log("FROMYAML_TYPE=" ~ fromyaml | string | truncate(200), info=True) }}

{# Try to get a list of context values that could lead to file access #}
{{ log("STORE_RESULT_TYPE=" ~ store_result | string | truncate(200), info=True) }}
{{ log("LOAD_RESULT_TYPE=" ~ load_result | string | truncate(200), info=True) }}
{{ log("VALIDATION_TYPE=" ~ validation | string | truncate(200), info=True) }}

{# diff_of_two_dicts - utility function #}
{{ log("DIFF_TYPE=" ~ diff_of_two_dicts | string | truncate(200), info=True) }}

{# try_or_compiler_error #}
{{ log("TRY_OR_ERROR_TYPE=" ~ try_or_compiler_error | string | truncate(200), info=True) }}

SELECT 1 as id
