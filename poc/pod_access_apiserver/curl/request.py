#!/usr/bin/env python3
import requests
master_ip="172.16.238.136"
url = "https://%:6443/api/v1/nodes/unis6".format(master_ip)
try:
res = requests.get(url, verify="ca.pem",cert=("/etc/kubernetes/ssl/admin.pem","/etc/kubernetes/ssl/admin-key.pem"),timeout=15)
except Exception as e: 
       print(e)
else:

  print("ok")