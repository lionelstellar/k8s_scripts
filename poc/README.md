# Kubernetes异常行为

## 1.集群管理组件实例变更
解释：cluster中重要的组件常常会放在kube-system(NAMESPACE)下面，etcd、coredns、apiserver等集群管理组件一般不会发生变更。
```
master# kubectl get pods --all-namespaces
NAMESPACE     NAME                             READY   STATUS    RESTARTS        AGE
kube-system   coredns-78fcd69978-247ll         1/1     Running   0               5d19h
kube-system   coredns-78fcd69978-bbnvf         1/1     Running   0               5d19h
kube-system   etcd-master                      1/1     Running   29              5d19h
kube-system   kube-apiserver-master            1/1     Running   0               4d21h
kube-system   kube-controller-manager-master   1/1     Running   57 (4d6h ago)   5d19h
kube-system   kube-flannel-ds-j6dxs            1/1     Running   0               5d19h
kube-system   kube-proxy-cpf7r                 1/1     Running   0               5d19h
kube-system   kube-scheduler-master            1/1     Running   58              5d19h
```

判定：
```
event.ObjectRef.Resource == "pods"
event.ObjectRef.Namespace == "kube-system" (或者为定制化的NS)
event.Verb == "create" or event.Verb == "delete"
```

## 2. ConfigMap变更


## ConfigMap与Secret
让镜像与配置文件解耦，提高镜像的可移植性和可复用性。

### configmap创建
* 通过文件或目录创建
`kubectl create configmap my-config --from-file=key1=test1.txt --from-file=key2=test2.txt` or
`kubectl create configmap dir-config --from-file=config/`
* 通过文本创建
`kubectl create configmap literal-config --from-literal=key1=hello --from-literal=key2=world`
* 通过yaml文件创建
`kubectl create -f config.yaml`

pod仅在创建时加载一次configmap中的值，运行时修改cm不影响pod