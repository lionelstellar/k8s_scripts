#!/bin/bash
while read line;do  
    eval "$line"  
done < ../config/config

# 根据实际情况修改, 默认唯一master
master_ip=${MASTER_IP_LIST[0]}
echo $master_ip


kubeadm join $master_ip:6443 --token nqyjiy.xauu6yaocpxxf7pt --discovery-token-ca-cert-hash sha256:367c047e332649a348f70d6ff08a4497953d56d5d1f82622d9c52293aa3c72aa 