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

## 2. 集群配置被篡改([ConfigMap](../docs/k8s_features/configmap.md ':include :type=code')变更导致)
ConfigMap是用于保存配置数据的键值对，可以用来保存单个属性，也可以保存配置文件，从而提高镜像的可移植性和可复用性。  
pod仅在创建时加载一次ConfigMap中的值，运行时修改cm不影响pod。  


判定：
```
event.ObjectRef.Resource == "configmaps"
event.ObjectRef.Name == $NAME   #要监控的cm名
event.Verb == "create" or event.Verb == "delete" or event.Verb == "patch" \
or event.Verb == "update"  #分别对应创建、删除、更新
```

## 3. 集群凭证批量查询([Secret](../docs/k8s_features/secret.md ':include :type=code') List)
对于非敏感数据，均可使用明文存储的configMap来做，若涉及到密码，私钥等数据时，则要使用secret类型.
* generic: 通用类型，通常用于存储密码数据。  
* tls：此类型仅用于存储私钥和证书。  
* docker-registry: 若要保存docker仓库的认证信息的话，就必须使用此种类型来创建。  

判定：
```
event.ObjectRef.Resource == "secrets" &&
event.Verb == "list"
```

## 4. 集群定时任务变更([Cronjob](../docs/k8s_features/cronjob.md ':include :type=code')变更)

判定：
```
event.ObjectRef.Resource == "cronjobs" &&
event.Verb == "patch"	
```

## 5. 集群高权限凭证变更([Service Account/Role/ClusterRole/RoleBinding/ClusterRoleBinding](../docs/k8s_features/RBAC.md ':include :type=code') CRUD事件)

* 修改：
`kubectl replace -f xxx.yaml`对应`verb:update` 
`kubectl apply -f xxx.yaml`对应`verb:patch`   
* 很多CRUD动作会伴随着get、list动作

### 5.1 Service Account
判定：
```
strings.Split(event.UserAgent, "/")[0] == "kubectl" &&
event.ObjectRef.Resource == "serviceaccounts" &&
event.Verb == "create" or event.Verb == "delete" or event.Verb == "update" \
or event.Verb == "list"  or event.Verb == "get" #分别对应创建、删除、更新、列举、读取
```

### 5.2 Role
判定：
```
strings.Split(event.UserAgent, "/")[0] == "kubectl" &&
event.ObjectRef.Resource == "roles" &&
event.Verb == "create" or event.Verb == "delete" or event.Verb == "update" \
or event.Verb == "patch" or event.Verb == "list"  or event.Verb == "get" #分别对应创建、删除、更新、列举、读取
```

### 5.3 ClusterRole
判定：
```
strings.Split(event.UserAgent, "/")[0] == "kubectl" &&
event.ObjectRef.Resource == "clusterroles" &&
event.Verb == "create" or event.Verb == "delete" or event.Verb == "update" \
or event.Verb == "patch" or event.Verb == "list"  or event.Verb == "get" #分别对应创建、删除、更新、列举、读取
```

### 5.4 RoleBinding
判定：
```
strings.Split(event.UserAgent, "/")[0] == "kubectl" &&
event.ObjectRef.Resource == "rolebindings" &&
event.Verb == "create" or event.Verb == "delete" or event.Verb == "update" \
or event.Verb == "patch" or event.Verb == "list"  or event.Verb == "get" #分别对应创建、删除、更新、列举、读取
```

### 5.5 ClusterRoleBinding
判定：
```
strings.Split(event.UserAgent, "/")[0] == "kubectl" &&
event.ObjectRef.Resource == "clusterrolebindings" &&
event.Verb == "create" or event.Verb == "delete" or event.Verb == "update" \
or event.Verb == "patch" or event.Verb == "list"  or event.Verb == "get" #分别对应创建、删除、更新、列举、读取
```

## 6. 集群准入控制器变更
### 6.1 PodSecurityPolicy准入控制器
https://kubernetes.io/zh/docs/concepts/policy/pod-security-policy/  
判定：
```
strings.Split(event.UserAgent, "/")[0] == "kubectl" &&
event.ObjectRef.Resource == "podsecuritypolicies" &&
event.Verb == "create" or event.Verb == "delete" or event.Verb == "update" \
or event.Verb == "patch"  #分别对应创建、删除、更新
```

### 6.2 其他类型的准入控制器
待补充





## 7. 集群管理组件被业务容器直接访问




## 8. 集群管理组件被异常连接