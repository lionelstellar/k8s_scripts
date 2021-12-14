#!/bin/bash

cp $K8S_SCRIPTS_DIR/host_configs/audit_all.yaml  /etc/kubernetes/pki/audit-policy.yaml
cp $K8S_SCRIPTS_DIR/host_configs/kube-apiserver-log.yaml  /etc/kubernetes/manifests/kube-apiserver.yaml

