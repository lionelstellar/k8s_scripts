## enable apiserver
使能k8s audit log作为falco的事件源，具体操作见https://kubernetes.io/docs/tasks/debug-application-cluster/audit/的Log backend部分

自动化脚本:
$K8S_SCRIPTS_DIR/setup/enable_audit.sh

### step 1
`vi /etc/kubernetes/pki/audit-policy.yaml   # 创建audit收集时间的策略文件`

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
### step 2
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

### step 3
`cat /var/log/pods.audit    #修改完后自动生效, 查看日志文件, 如果没有, 执行debug_kubelet.sh查看原因`
