## ConfigMap
参考 https://www.jianshu.com/p/b1d516f02ecd
* 让镜像与配置文件解耦，提高镜像的可移植性和可复用性。
* Pod仅在创建时加载一次ConfigMap中的值，运行时修改cm不影响Pod
* Pod只能使用同一个命名空间的ConfigMap

### 1. ConfigMap创建
config/test1.txt
```
value1
```
config/test2.txt
```
value2
```
env.txt
```
key1=value1
key2=value2
```

* 通过文件或目录创建### `--from-file`  
`kubectl create configmap my-config --from-file=key1=test1.txt --from-file=key2=test2.txt` or
`kubectl create configmap dir-config --from-file=config/`
* 通过文本创建`--from-literal`  
`kubectl create configmap literal-config --from-literal=key1=hello --from-literal=key2=world`
* 通过环境变量文件 `--from-env-file`  
`kubectl create configmap myconfigmap --from-env-file=env.txt`
* 通过yaml文件创建  
`kubectl create -f config.yaml`

### 2. ConfigMap的使用

Pod可以通过三种方式来使用ConfigMap，分别为：

* 将ConfigMap中的数据设置为环境变量
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-cm-1
  namespace: default
  labels:
     app: myapp
     tier: frontend
  annotations:
     test.com/created-by: “cluster admin”
spec:
  containers:
  -  name: myapp
     image: ikubernetes/myapp:v1
     ports:
     -   name: http
         containerPort:80
**     env:
     - name: NGINX_SERVER_PORT
       valueFrom:
         configMapKeyRef:
            name: nginx-config
            key: nginx_port
     -  name:NGINX_SERVER_NAME
        valueFrom:
          configMapKeyRef:
            name: nginx-config
            key: server_name**
```
* 将ConfigMap中的数据设置为命令行参数
* 使用Volume将ConfigMap作为文件或目录挂载
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-cm-2
  namespace: default
  labels:
    app: myapp
    tier: frontend
  annotations:
    test.com/created-by: “cluster admin”
spec:
 containers:
 - name: myapp
   image: ikubernetes/myapp:v1
   ports:
   - name: http
     containerPort: 80
   volumeMounts:
   - name: nginxconf
     mountPath: /etc/nginx/config.d/   #挂载点不存在,Pod会自动创建.
     readOnly: true       #不能让容器修改配置的内容。
volumes:
-  name: nginxconf        #定义存储卷的名字为nginxconf
   configMap:
     name: nginx-config   #要挂载nginx-config这个configMap
```

