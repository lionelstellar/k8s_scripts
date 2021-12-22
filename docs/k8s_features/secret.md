## Secret
对于非敏感数据，均可使用明文存储的configMap来做，若涉及到口令，token，密钥等数据时,一定要使用secret类型。
* generic: 通用类型，通常用于存储密码数据。  
* tls：此类型仅用于存储私钥和证书。  
* docker-registry: 若要保存docker仓库的认证信息的话，就必须使用此种类型来创建。
用户可以创建自己的secret，系统也会有自己的secret。

### 1. Secret创建
* 通过文本创建`--from-literal`  
`kubectl create secret generic mysql-root-password --from-literal=password=MyP@ss.8*9`
* 通过文件或目录创建`--from-file`  
`kubectl create secret generic db-user-pass --from-file=./username.txt --from-file=./password.txt`
* 通过yaml文件创建  
`kubectl create -f secret.yaml`
```yaml
# secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
data:
  username: YWRtaW4=
  password: MWYyZDFlMmU2N2Rm
```


### 2. Secret使用
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-secret-1
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
     -  name: http
        containerPort:80
     env:
     -  name: MYSQL_ROOT_PASSWORD   #它是Pod启动成功后,Pod中容器的环境变量名.
        valueFrom:
          secretKeyRef:
            name: mysql-root-password  #这是secret的对象名
            key: password      #它是secret中的key名
```