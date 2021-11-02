## 创建POD（master侧）

https://leehao.me/k8s-%E9%83%A8%E7%BD%B2-nginx-%E5%85%A5%E9%97%A8/#%E5%88%9B%E5%BB%BA-pod

```
# master上创建nginx pod
kubectl apply -f $K8S_SCRIPTS_DIR/pod/pod1.yml

# 查看pod信息，得知pod的IP为192.168.1.3
kubectl get pods nginx -o wide

# 查看详细信息
kubectl describe pods nginx

# 进入pod
kubectl exec -it nginx -- /bin/sh

# worker侧测试
curl 192.168.1.3:80

# 删除pod
kubectl delete -f pod1.yml

```

