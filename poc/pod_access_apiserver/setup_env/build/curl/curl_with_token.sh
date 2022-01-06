#!/bin/bash

SECRET='admin-token-rhszn'
#SECRET='default-token-mckv5'
APISERVER=$(kubectl config view |grep server|cut -f 2- -d ":" | tr -d " ")
TOKEN=$(kubectl describe secret $SECRET | grep -E '^token' | cut -f2 -d":"|tr -d '\t' | tr -d ' ')


echo $TOKEN
echo $APISERVER
exit 0
curl -H "Authorization: Bearer $TOKEN" $APISERVER/api  --insecure
