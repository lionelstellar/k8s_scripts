## 开启k8s audit log
参考链接：
https://dev.bitolog.com/implement-audits-webhook/
https://kubernetes.io/docs/tasks/debug-application-cluster/audit/

audit后端可以以日志方式写入文件系统，也可以以webhook的方式发送到server端。

首先需要根据个人cluster情况修改host_config目录下的几个配置文件：

[1. audit.yaml](../host_configs/audit.yaml ':include :type=code')
将audit.yaml中的内容定制化修改后拷贝到/etc/kubernetes/pki/audit-policy.yaml 

[2. kube-apiserver-log.yaml](../host_configs/kube-apiserver-log.yaml ':include :type=code')
将kube-apiserver-log.yaml中的内容定制化修改后拷贝到/etc/kubernetes/pki/kube-apiserver.yaml 

[3. kube-apiserver-webhook.yaml](../host_configs/kube-apiserver-webhook.yaml ':include :type=code')
将kube-apiserver-webhook.yaml中的内容定制化修改后拷贝到/etc/kubernetes/pki/kube-apiserver.yaml 


### step 1 设置事件收集策略 [audit.yaml](../host_configs/audit.yaml ':include :type=code')
`vi /etc/kubernetes/pki/audit-policy.yaml   # 创建audit收集事件的策略文件`

```
apiVersion: audit.k8s.io/v1 # This is required.
kind: Policy
# Don't generate audit events for all requests in RequestReceived stage.
omitStages:
  - "RequestReceived"
rules:
  # Log pod changes at RequestResponse level
  - level: RequestResponse
    resources:
    - group: ""
      # Resource "pods" doesn't match requests to any subresource of pods,
      # which is consistent with the RBAC policy.
      resources: ["pods"]
  # Log "pods/log", "pods/status" at Metadata level
  - level: Metadata
    resources:
    - group: ""
      resources: ["pods/log", "pods/status"]

  # Don't log requests to a configmap called "controller-leader"
  - level: None
    resources:
    - group: ""
      resources: ["configmaps"]
      resourceNames: ["controller-leader"]

  # Don't log watch requests by the "system:kube-proxy" on endpoints or services
  - level: None
    users: ["system:kube-proxy"]
    verbs: ["watch"]
    resources:
    - group: "" # core API group
      resources: ["endpoints", "services"]

  # Don't log authenticated requests to certain non-resource URL paths.
  - level: None
    userGroups: ["system:authenticated"]
    nonResourceURLs:
    - "/api*" # Wildcard matching.
    - "/version"

  # Log the request body of configmap changes in kube-system.
  - level: Request
    resources:
    - group: "" # core API group
      resources: ["configmaps"]
    # This rule only applies to resources in the "kube-system" namespace.
    # The empty string "" can be used to select non-namespaced resources.
    namespaces: ["kube-system"]

  # Log configmap and secret changes in all other namespaces at the Metadata level.
  - level: Metadata
    resources:
    - group: "" # core API group
      resources: ["secrets", "configmaps"]

  # Log all other resources in core and extensions at the Request level.
  - level: Request
    resources:
    - group: "" # core API group
    - group: "extensions" # Version of group should NOT be included.

  # A catch-all rule to log all other requests at the Metadata level.
  - level: Metadata
    # Long-running requests like watches that fall under this rule will not
    # generate an audit event in RequestReceived.
    omitStages:
      - "RequestReceived"
```
### step 2 设置log后端参考文件 [kube-apiserver.yaml](../host_configs/kube-apiserver-log.yaml ':include :type=code')
`vi /etc/kubernetes/manifests/kube-apiserver.yaml   # 修改apiserver的pod配置文件`

```
    - --audit-policy-file=/etc/kubernetes/pki/audit-policy.yaml
    - --audit-log-path=/var/log/pods.audit
    - --audit-log-maxage=7
    - --audit-log-maxbackup=4
    - --audit-log-maxsize=10

    ...

    volumeMounts:
    - mountPath: /etc/kubernetes/pki/audit-policy.yaml
      name: audit
      readOnly: true
    - mountPath: /var/log/pods.audit
      name: audit-log
      readOnly: false

    ...

  - hostPath:
      path: /etc/kubernetes/pki/audit-policy.yaml
      type: File
    name: audit
  - hostPath:
      path: /var/log/pods.audit
      type: FileOrCreate
    name: audit-log
```

`cat /var/log/pods.audit    #修改完后自动生效, 查看日志文件, 如果没有, 执行debug_kubelet.sh查看原因`

### step 3 设置webhook后端参考文件 [kube-apiserver-webhook.yaml](../host_configs/kube-apiserver-webhook.yaml ':include :type=code')
```
    - --audit-policy-file=/etc/kubernetes/pki/audit-policy.yaml
    - --audit-webhook-config-file=/etc/kubernetes/pki/audit-webhook.yaml
```



### 自动化部署脚本:
[enable_audit_log.sh](../setup/enable_audit_log.sh)  
[enable_audit_webhook.sh](../setup/enable_audit_webhook.sh)
