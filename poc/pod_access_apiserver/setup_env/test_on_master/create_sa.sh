#!/bin/bash

kubectl create serviceaccount api-explorer


# 创建ClusterRole,给与pod及其日志的get/watch/list权限

cat <<EOF | kubectl create -f -
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: log-reader
rules:
- apiGroups: [""] 
  resources: ["pods", "pods/log"]
  verbs: ["get", "watch", "list"]
EOF


# 将ClusterRole绑定到default命名空间中的ServiceAccount

kubectl create rolebinding api-explorer:log-reader --clusterrole log-reader --serviceaccount default:api-explorer

# 查询该SA的TOKEN与证书：  

SERVICE_ACCOUNT=api-explorer
 
# Get the ServiceAccount's token Secret's name
SECRET=$(kubectl get serviceaccount ${SERVICE_ACCOUNT} -o json | jq -Mr '.secrets[].name | select(contains("token"))')
 
# Extract the Bearer token from the Secret and decode
TOKEN=$(kubectl get secret ${SECRET} -o json | jq -Mr '.data.token' | base64 -d)
 
# Extract, decode and write the ca.crt to a temporary location
kubectl get secret ${SECRET} -o json | jq -Mr '.data["ca.crt"]' | base64 -d > ${SERVICE_ACCOUNT}_ca.crt
 
# Get the API Server location
APISERVER=https://$(kubectl -n default get endpoints kubernetes --no-headers | awk '{ print $2 }')

echo "SECRET: "$SECRET
echo "TOKEN: "$TOKEN
echo "APISERVER: "$APISERVER
echo "cert: "`cat $(SERVICE_ACCOUNT)_ca.crt`