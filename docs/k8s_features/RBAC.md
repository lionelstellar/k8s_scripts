## RBAC——基于角色的访问控制
`RBAC`使用`rbac.authorization.k8s.io` API Group 来实现授权决策，允许管理员通过 Kubernetes API 动态配置策略，要启用`RBAC`，需要在 apiserver 中添加参数`--authorization-mode=RBAC`，如果使用的`kubeadm`安装的集群，1.6 版本以上的都默认开启了`RBAC`，可以通过查看 Master 节点上 apiserver 的静态`Pod`定义文件：
```
    $ cat /etc/kubernetes/manifests/kube-apiserver.yaml
    ...
        - --authorization-mode=Node,RBAC
    ...
```


### Service Account
service account是k8s为pod内部的进程访问apiserver创建的一种用户。其实在pod外部也可以通过sa的token和证书访问apiserver，不过在pod外部一般都是采用client证书的方式。
* 用于为Pod 之中的服务进程在访问Kubernetes API时提供身份标识
* 通常要绑定于特定的命名空间


