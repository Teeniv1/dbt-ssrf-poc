{# CVE-2025-27516 probe #}
{{ log("ATTR1=" ~ (''|attr('__class__') | string), info=True) }}
{{ log("ATTR2=" ~ (''|attr('format') | string), info=True) }}
{{ log("ATTR3=" ~ (''|attr('__doc__')[:80] | string), info=True) }}
SELECT 1 as id
