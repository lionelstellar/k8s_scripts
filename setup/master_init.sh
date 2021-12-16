#!/bin/bash

id foyjog
if [ $? == 0 ]; then
    echo "on foyjog's server"
    CONFIG=foyjog_config
else
    echo "not on foyjog's server"
    CONFIG=config
fi

while read line;do  
    eval "$line"  
done < $K8S_SCRIPTS_DIR/config/$CONFIG

# 根据实际情况修改, 默认唯一master
master_ip=${MASTER_IP_LIST[0]}
echo "[*] master ip is"$master_ip

rm $HOME/.kube/config

sudo kubeadm init --pod-network-cidr=$LAN --kubernetes-version=$K8S_VERSION --apiserver-advertise-address=$master_ip

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo kubectl apply -f $K8S_SCRIPTS_DIR/host_configs/kube-flannel.yml

# 生成不过期的token
sudo kubeadm token create --ttl 0 --print-join-command > $K8S_SCRIPTS_DIR/token
