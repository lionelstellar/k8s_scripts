# Kubernetes行为

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