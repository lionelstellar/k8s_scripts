#!/bin/bash

SECRET=$(kubectl get secrets | grep api-explorer | awk '{print $1}')
APISERVER=$(kubectl config view |grep server|cut -f 2- -d ":" | tr -d " ")
TOKEN=$(kubectl describe secret $SECRET | grep -E '^token' | cut -f2 -d":"|tr -d '\t' | tr -d ' ')

URL="api/v1/namespaces/default/secrets"
#URL="api"

# echo $TOKEN
echo $APISERVER
#exit 0
curl -H "Authorization: Bearer $TOKEN" $APISERVER/$URL  --insecure
