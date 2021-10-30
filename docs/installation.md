## 网络节点信息

虚拟机1: ubuntu-20.04.3-desktop-amd64

master   172.16.238.136

虚拟机2: ubuntu-18.04.5-live-server-amd64

worker   172.16.238.138



## 修改配置文件

1. host_configs/kube-flannel.yml的line 128: 修改为自己期望的局域网
2. config/config: 修改为自己环境的信息
3. 修改/etc/hosts文件，将master与worker的主机与IP映射信息写入
4. 为了执行脚本方便可以写入环境变量：

```
vi /etc/profile
# k8s
export K8S_SCRIPTS_DIR=/root/k8s_scripts
export PATH=$PATH:$K8S_SCRIPTS_DIR:$K8S_SCRIPTS_DIR/setup:$K8S_SCRIPTS_DIR/debug
```




## master节点构建

```bash
cd setup
./setup_node.sh		#运行安装脚本
./pull_master.sh	#master上拉取镜像
./master_init.sh	#初始化master节点

# 将生成的永久token添加/替换kube_join.sh的末尾
./kube_join.sh		#master节点加入cluster

```



## worker节点构建

```bash
cd setup
./setup_node.sh		#运行安装脚本
./pull_worker.sh	#master上拉取镜像
./worker_init.sh	#初始化worker节点

# 将生成的永久token添加/替换kube_join.sh的末尾
./kube_join.sh		#worker节点加入cluster

```

reference:https://jimmysong.io/kubernetes-handbook/practice/node-installation.html
