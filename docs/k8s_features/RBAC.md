## RBAC——基于角色(Role)的访问控制
`RBAC`使用`rbac.authorization.k8s.io` API Group 来实现授权决策，允许管理员通过 Kubernetes API 动态配置策略，要启用`RBAC`，需要在 apiserver 中添加参数`--authorization-mode=RBAC`，如果使用的`kubeadm`安装的集群，1.6 版本以上的都默认开启了`RBAC`，可以通过查看 Master 节点上 apiserver 的静态`Pod`定义文件：
```
    $ cat /etc/kubernetes/manifests/kube-apiserver.yaml
    ...
        - --authorization-mode=Node,RBAC
    ...
```


### Service Account
service account是k8s为pod内部的进程访问apiserver创建的一种用户。其实在pod外部也可以通过sa的token和证书访问apiserver，不过在pod外部一般都是采用client证书的方式。
* 用于为Pod之中的服务进程在访问Kubernetes API时提供身份标识(在pod的yaml文件中与对应的SA绑定)
* 通常要绑定于特定的命名空间

### Role
包含一组权限的规则，白名单叠加形式，**只作用于所在的Namespace**，例如：  

```
PolicyRule:
  Resources               Non-Resource URLs  Resource Names  Verbs
  pods                    []                 []              [get list watch create update patch delete]
```

### ClusterRole
包含一组权限的规则，白名单叠加形式，**作用于整个集群**，例如：  
```
Name:         secret-reader
Labels:       <none>
Annotations:  <none>
PolicyRule:
  Resources  Non-Resource URLs  Resource Names  Verbs
  ---------  -----------------  --------------  -----
  secrets    []                 []              [get watch list]
```

### RoleBinding
将Role或者ClusterRole绑定到User，Group或者ServiceAccount，**只作用于所在的Namespace**，例如：
```
apiVersion: rbac.authorization.k8s.io/v1
# 此角色绑定允许 "jane" 读取 "default" 名字空间中的 Pods
kind: RoleBinding
metadata:
  name: read-pods
  namespace: default
subjects:
# 你可以指定不止一个“subject（主体）”
- kind: User
  name: jane # "name" 是区分大小写的
  apiGroup: rbac.authorization.k8s.io
roleRef:
  # "roleRef" 指定与某 Role 或 ClusterRole 的绑定关系
  kind: Role # 此字段必须是 Role 或 ClusterRole
  name: pod-reader     # 此字段必须与你要绑定的 Role 或 ClusterRole 的名称匹配
  apiGroup: rbac.authorization.k8s.io
```

### ClusterRoleBinding
将Role或者ClusterRole绑定到User，Group或者ServiceAccount，**作用于整个集群**，例如：
```
apiVersion: rbac.authorization.k8s.io/v1
# 此集群角色绑定允许 “manager” 组中的任何人访问任何名字空间中的 secrets
kind: ClusterRoleBinding
metadata:
  name: read-secrets-global
subjects:
- kind: Group
  name: manager # 'name' 是区分大小写的
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: secret-reader
  apiGroup: rbac.authorization.k8s.io
```

创建了绑定之后，你不能再修改绑定对象所引用的 Role 或 ClusterRole。试图改变绑定对象的`roleRef`将导致合法性检查错误。如果你想要改变现有绑定对象中`roleRef`字段的内容，必须删除重新创建绑定对象。


参考：
https://kubernetes.io/zh/docs/reference/access-authn-authz/rbac/