#!/bin/bash
while read line;do  
    eval "$line"  
done < ../config/config

# 根据实际情况修改, 默认唯一master
master_ip=${MASTER_IP_LIST[0]}
echo $master_ip


kubectl apply -f $K8S_SCRIPTS_DIR/kube-flannel.yml
