#!/usr/bin/env python3
import requests

payload = '{"hello": "world"}'
url = "http://127.0.0.1:8080"
# url = "http://10.78.119.237:8080"
r = requests.post(url, data=payload)
print(r.status_code)
print(r.content.decode("UTF-8"))