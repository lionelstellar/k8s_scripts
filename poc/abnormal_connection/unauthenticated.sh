#!/bin/bash
APISERVER=$(kubectl config view |grep server|cut -f 2- -d ":" | tr -d " ")
curl -H "Authorization: Bearer 123456" $APISERVER/api/v1/namespaces/default/pods  --insecure
