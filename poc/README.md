# Kubernetes异常行为

poc目录下用于模拟异常行为以产生k8s audit event,由此归纳所需的日志信息以及判定规则。

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

## 2. ConfigMap变更导致配置被篡改
ConfigMap是用于保存配置数据的键值对，可以用来保存单个属性，也可以保存配置文件，从而提高镜像的可移植性和可复用性。  
pod仅在创建时加载一次ConfigMap中的值，运行时修改cm不影响pod。


判定：
```
event.ObjectRef.Resource == "configmaps"
event.ObjectRef.Name == $NAME   #要监控的cm名
event.Verb == "create" or event.Verb == "delete" or event.Verb == "patch"   #分别对应创建、删除、更新
```

## 3. 集群凭证批量查询(Secret List)
