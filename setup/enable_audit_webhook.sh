#!/bin/bash
sudo cp $K8S_SCRIPTS_DIR/host_configs/audit.yaml  /etc/kubernetes/pki/audit-policy.yaml

id foyjog
if [ $? == 0 ]; then
    echo "on foyjog's server"
    sudo cp $K8S_SCRIPTS_DIR/host_configs/audit-webhook-foyjog.yaml /etc/kubernetes/pki/audit-webhook.yaml
    sudo cp $K8S_SCRIPTS_DIR/host_configs/kube-apiserver-webhook-foyjog.yaml  /etc/kubernetes/manifests/kube-apiserver.yaml

else
    echo "not on foyjog's server"
    sudo cp $K8S_SCRIPTS_DIR/host_configs/audit-webhook.yaml /etc/kubernetes/pki/audit-webhook.yaml
    sudo cp $K8S_SCRIPTS_DIR/host_configs/kube-apiserver-webhook.yaml  /etc/kubernetes/manifests/kube-apiserver.yaml

fi