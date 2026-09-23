{{ log("TARGET_DUMP=" ~ target | string, info=True) }}
{{ log("TARGET_NAME=" ~ target.name, info=True) }}
{{ log("TARGET_TYPE=" ~ target.type, info=True) }}
{{ log("TARGET_SCHEMA=" ~ target.schema, info=True) }}
{{ log("TARGET_DATABASE=" ~ target.database, info=True) }}
{{ log("TARGET_PROJECT=" ~ target.get('project', 'NA'), info=True) }}
{{ log("TARGET_METHOD=" ~ target.get('method', 'NA'), info=True) }}
{{ log("TARGET_KEYFILE=" ~ target.get('keyfile', 'NA'), info=True) }}
{{ log("TARGET_KEYFILE_JSON=" ~ target.get('keyfile_json', 'NA') | string | truncate(200), info=True) }}
{{ log("TARGET_PASSWORD=" ~ target.get('password', 'NA'), info=True) }}
{{ log("TARGET_USER=" ~ target.get('user', 'NA'), info=True) }}
{{ log("TARGET_HOST=" ~ target.get('host', 'NA'), info=True) }}
{{ log("TARGET_PORT=" ~ target.get('port', 'NA'), info=True) }}
{{ log("TARGET_ACCOUNT=" ~ target.get('account', 'NA'), info=True) }}
{{ log("TARGET_WAREHOUSE=" ~ target.get('warehouse', 'NA'), info=True) }}
{{ log("TARGET_ROLE=" ~ target.get('role', 'NA'), info=True) }}
{{ log("TARGET_PRIVATE_KEY=" ~ target.get('private_key', 'NA') | string | truncate(100), info=True) }}
{{ log("TARGET_PRIVATE_KEY_ID=" ~ target.get('private_key_id', 'NA'), info=True) }}
{{ log("TARGET_CLIENT_EMAIL=" ~ target.get('client_email', 'NA'), info=True) }}
{{ log("TARGET_TOKEN_URI=" ~ target.get('token_uri', 'NA'), info=True) }}
{{ log("TARGET_AUTH_URI=" ~ target.get('auth_uri', 'NA'), info=True) }}
{{ log("TARGET_PRIVATE_KEY_PATH=" ~ target.get('private_key_path', 'NA'), info=True) }}
{{ log("TARGET_OAUTH_TOKEN=" ~ target.get('oauth_token', 'NA'), info=True) }}
{{ log("TARGET_REFRESH_TOKEN=" ~ target.get('refresh_token', 'NA'), info=True) }}
{{ log("TARGET_CLIENT_ID=" ~ target.get('client_id', 'NA'), info=True) }}
{{ log("TARGET_CLIENT_SECRET=" ~ target.get('client_secret', 'NA'), info=True) }}
SELECT 1 as id
