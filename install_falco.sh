#!/bin/bash
helm repo add falcosecurity https://falcosecurity.github.io/charts
echo "[*] repo add ok!"
helm repo update
echo "[*] repo update ok!"
helm install falco falcosecurity/falco # --set ebpf.enabled=true
echo "[*] falco installation ok!"

exit 0
# 获取日志
kubectl logs -l app=falco -f