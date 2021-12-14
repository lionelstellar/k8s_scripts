#!/bin/bash

while read line;do  
    eval "$line"  
done < $K8S_SCRIPTS_DIR/config/config

# 根据实际情况修改, 默认唯一master
master_ip=${MASTER_IP_LIST[0]}
echo "[*] master ip is"$master_ip

rm $HOME/.kube/config

kubeadm init --pod-network-cidr=$LAN --kubernetes-version=$K8S_VERSION --apiserver-advertise-address=$master_ip

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f $K8S_SCRIPTS_DIR/host_configs/kube-flannel.yml

# 生成不过期的token
# kubeadm token create --ttl 0 --print-join-command > $K8S_SCRIPTS_DIR/token/token
