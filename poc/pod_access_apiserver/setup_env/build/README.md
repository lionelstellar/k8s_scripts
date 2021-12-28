## 制作镜像并开启本地registry

1.制作镜像：
`./build.sh`得到`ubuntu:k8s_test`镜像
如果仓库里有<none>镜像可以用delete_none_images.sh删除

2.开启本地仓
https://www.cnblogs.com/wotoufahaiduo/p/11229857.html

3.master和worker上配置docker
修改/etc/docker/daemon.json文件，加上一条配置，我的masterIP为172.16.238.136所以添加如下：
`"insecure-registries":["172.16.238.136:5000"]`
```
systemctl daemon-reload
service docker restart
```

4.推送到本地仓，之后worker上起pod时能够拉取镜像
```
docker tag ubuntu:k8s_test 172.16.238.136:5000/ubuntu:k8s_test
docker push 172.16.238.136:5000/ubuntu:k8s_test
```

worker上拉取：
```
docker pull 172.16.238.136:5000/ubuntu:k8s_test
```