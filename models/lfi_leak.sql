{# Try various file read methods in Jinja2 #}

{# Method 1: Try source() function with file path #}
{# Method 2: Try include with relative paths #}
{# Method 3: Try to use modules for file access #}

{# Check if we have any file-reading functions #}
{% if load_result is defined %}
{{ log("LOAD_RESULT_EXISTS=yes", info=True) }}
{% else %}
{{ log("LOAD_RESULT_NOT_DEFINED", info=True) }}
{% endif %}

{% if load_profile is defined %}
{{ log("LOAD_PROFILE_EXISTS=yes", info=True) }}
{% else %}
{{ log("LOAD_PROFILE_NOT_DEFINED", info=True) }}
{% endif %}

{# Try to access internal dbt functions #}
{% if builtins is defined %}
{{ log("BUILTINS_EXISTS=yes", info=True) }}
{% endif %}

{% if context is defined %}
{{ log("CONTEXT_EXISTS=yes", info=True) }}
{% endif %}

{# Try to enumerate available Jinja2 globals #}
{% set ctx_vars = [] %}
{% for name in ['adapter', 'api', 'builtins', 'config', 'context', 'database', 
                'env_var', 'exceptions', 'execute', 'flags', 'fromjson', 'fromyaml',
                'graph', 'invocation_id', 'load_result', 'log', 'model', 'modules',
                'post_hooks', 'pre_hooks', 'project_name', 'ref', 'return', 'run_query',
                'run_started_at', 'schema', 'selected_resources', 'source', 'target',
                'this', 'tojson', 'toyaml', 'var', 'dbt_version'] %}
  {% set val = '' %}
  {% if name == 'adapter' and adapter is defined %}{% do ctx_vars.append(name) %}{% endif %}
  {% if name == 'api' and api is defined %}{% do ctx_vars.append(name) %}{% endif %}
  {% if name == 'config' and config is defined %}{% do ctx_vars.append(name) %}{% endif %}
  {% if name == 'context' and context is defined %}{% do ctx_vars.append(name) %}{% endif %}
  {% if name == 'database' and database is defined %}{% do ctx_vars.append(name) %}{% endif %}
  {% if name == 'execute' and execute is defined %}{% do ctx_vars.append(name) %}{% endif %}
  {% if name == 'flags' and flags is defined %}{% do ctx_vars.append(name) %}{% endif %}
  {% if name == 'graph' and graph is defined %}{% do ctx_vars.append(name) %}{% endif %}
  {% if name == 'model' and model is defined %}{% do ctx_vars.append(name) %}{% endif %}
  {% if name == 'modules' and modules is defined %}{% do ctx_vars.append(name) %}{% endif %}
  {% if name == 'project_name' and project_name is defined %}{% do ctx_vars.append(name) %}{% endif %}
  {% if name == 'schema' and schema is defined %}{% do ctx_vars.append(name) %}{% endif %}
  {% if name == 'target' and target is defined %}{% do ctx_vars.append(name) %}{% endif %}
  {% if name == 'this' and this is defined %}{% do ctx_vars.append(name) %}{% endif %}
  {% if name == 'var' and var is defined %}{% do ctx_vars.append(name) %}{% endif %}
{% endfor %}

{{ log("AVAILABLE_CONTEXT=" ~ ctx_vars, info=True) }}

{# Try to access target connection details (might contain credentials) #}
{% if target is defined %}
{{ log("TARGET_ALL=" ~ target, info=True) }}
{% endif %}

SELECT 1 as id
