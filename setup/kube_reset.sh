#!/bin/bash
if [ -d $HOME/.kube ]; then
    rm -rf $HOME/.kube
fi
sudo rm /var/log/pods.audit
sudo kubeadm reset