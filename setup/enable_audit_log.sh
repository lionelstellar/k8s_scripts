#!/bin/bash
sudo cp $K8S_SCRIPTS_DIR/host_configs/audit.yaml  /etc/kubernetes/pki/audit-policy.yaml

id foyjog
if [ $? == 0 ]; then
    echo "on foyjog's server"
    sudo cp $K8S_SCRIPTS_DIR/host_configs/kube-apiserver-log.yaml  /etc/kubernetes/manifests/kube-apiserver.yaml
else
    echo "not on foyjog's server"
    sudo cp $K8S_SCRIPTS_DIR/host_configs/kube-apiserver-log-foyjog.yaml  /etc/kubernetes/manifests/kube-apiserver.yaml
fi




