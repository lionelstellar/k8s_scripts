## helm安装falco
```
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

helm install falco falcosecurity/falco --set ebpf.enabled=true

# 获取日志
kubectl logs -l app=falco -f
```

