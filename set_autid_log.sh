#!/bin/bash
while read line;do  
    eval "$line"  
done < $K8S_SCRIPTS_DIR/config/config


mkdir -p /var/log/kubernetes/apiserver/
kube-apiserver --audit-log-path=/var/log/kubernetes/apiserver/audit.log \
                --audit-policy-file=$K8S_SCRIPTS_DIR/host_configs/audit.yaml

kubectl apply -f $K8S_SCRIPTS_DIR/host_configs/audit.yaml