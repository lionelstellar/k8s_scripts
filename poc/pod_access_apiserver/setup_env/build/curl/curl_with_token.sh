#!/bin/bash

TOKEN="your SA token!"
curl -H "Authorization: Bearer $TOKEN" https://172.16.238.136:6443/api/v1/namespaces/default/pods  --insecure
