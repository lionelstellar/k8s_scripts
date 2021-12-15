#!/bin/bash

while read line;do  
    eval "$line"  
done < $K8S_SCRIPTS_DIR/config/config

# 根据实际情况修改, 默认唯一master
worker_ip=${MASTER_IP_LIST[0]}
echo "[*] worker ip is"$worker_ip

sudo kubectl apply -f $K8S_SCRIPTS_DIR/host_configs/kube-flannel.yml

# 把master的配置拷贝到worker
mkdir -p /etc/cni/net.d/ 
scp -r root@master:/etc/cni/net.d/* /etc/cni/net.d/
