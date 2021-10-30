#!/bin/bash
kubeadm init --pod-network-cidr=192.168.0.0/16 --kubernetes-version=v1.22.2 --apiserver-advertise-address=172.16.238.136

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f $K8S_SCRIPTS_DIR/kube-flannel.yml
