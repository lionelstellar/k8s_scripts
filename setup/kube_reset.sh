#!/bin/bash
if [ -d $HOME/.kube ]; then
    rm -rf $HOME/.kube
fi
   
kubeadm reset