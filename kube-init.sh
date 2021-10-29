#!/bin/bash
kubeadm init --pod-network-cidr=192.168.0.0/16 --kubernetes-version=v1.22.2 --apiserver-advertise-address=172.16.238.136
