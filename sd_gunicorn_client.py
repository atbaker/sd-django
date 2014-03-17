#!/usr/bin/python
from datetime import datetime, timedelta
from urllib2 import Request, urlopen

import subprocess


# Get the docker0 interface IP address
result = subprocess.check_output("ip route show", shell=True)
docker_ip = result.split()[2]

# Get the most recent activity from the gunicorn access log
f = open('/var/log/gunicorn/access.log')
log_entries = f.readlines()
last_entry = log_entries[-1]
response_timestamp = last_entry.split()[3].strip('[]')
last_activity = datetime.strptime(response_timestamp, '%d/%b/%Y:%H:%M:%S')

# If last activity was less than 10 mins ago, container is active
if (datetime.now() - last_activity) < timedelta(minutes=10):
    active = '1'
else:
    active = '0'

# POST the active connections to the spin-docker client
req = Request('http://%s/v1/check-in' % docker_ip, data='active=%s' % active)
try:
    resp = urlopen(req)
except Exception:
    pass
