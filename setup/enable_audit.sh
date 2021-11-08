#!/bin/bash

cp $K8S_SCRIPTS_DIR/host_configs/audit.yaml  /etc/kubernetes/pki/audit-policy.yaml
cp $K8S_SCRIPTS_DIR/host_configs/kube-apiserver.yaml  /etc/kubernetes/manifests/kube-apiserver.yaml
