#!/bin/bash

while read line;do  
    eval "$line"  
done < ../config/config




# 将当前的UTC时间写入硬件时钟
timedatectl set-timezone Asia/Shanghai
timedatectl set-local-rtc 0
# 重启依赖于系统时间的服务
systemctl restart rsyslog;
systemctl restart crond
echo "[*] timezone set OK!"

# 安装依赖
apt install -y golang-go apt-transport-https ca-certificates curl software-properties-common
echo "[*] dependency install OK!"

# 安装docker
sudo apt-get remove docker docker-engine docker.io
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-get -y update
sudo apt-get -y install docker-ce

# 修改docker的cgroup驱动，必须和k8s保持一致
sudo tee /etc/docker/daemon.json <<-'EOF'
{
     "exec-opts": ["native.cgroupdriver=systemd"],
     "log-driver": "json-file",
     "log-opts": {
         "max-size": "100m"
     },
     "storage-driver": "overlay2",
     "registry-mirrors": ["https://irnlfwui.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload
service docker restart
echo "[*] docker cgroupdriver set OK!"



# 关闭swap
swapoff -a
sed -i '/swap/s/^\/swap/#\/swap/' /etc/fstab 
echo "[*] turn off swap OK!"



# k8s三件套
sudo curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
sudo tee /etc/apt/sources.list.d/kubernetes.list <<-EOF
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
sudo apt-get update

# apt-get install -y kubectl kubelet kubeadm
sudo apt install -y kubelet=1.22.3 kubeadm=1.22.3 kubectl=1.22.3