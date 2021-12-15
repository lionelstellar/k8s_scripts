#!/bin/bash
sudo helm repo add falcosecurity https://falcosecurity.github.io/charts
echo "[*] repo add ok!"
sudo helm repo update
echo "[*] repo update ok!"
sudo helm install falco falcosecurity/falco # --set ebpf.enabled=true
echo "[*] falco installation ok!"

exit 0
# 获取日志
sudo kubectl logs -l app=falco -f