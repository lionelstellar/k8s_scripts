set -o errexit
set -o nounset
set -o pipefail

##这里定义版本，按照上面得到的列表自己改一下版本号

KUBE_VERSION=v1.22.2
KUBE_PAUSE_VERSION=3.5
ETCD_VERSION=3.5.0-0
DNS_VERSION=1.8.4

##这是原始仓库名，最后需要改名成这个
GCR_URL=k8s.gcr.io

##这里就是写你要使用的仓库
DOCKERHUB_URL=gotok8s

##这里是镜像列表，新版本要把coredns改成coredns/coredns
images=(
kube-proxy:${KUBE_VERSION}
kube-scheduler:${KUBE_VERSION}
kube-controller-manager:${KUBE_VERSION}
kube-apiserver:${KUBE_VERSION}
pause:${KUBE_PAUSE_VERSION}
#etcd:${ETCD_VERSION}
#coredns:${DNS_VERSION}
)

##这里是拉取和改名的循环语句
for imageName in ${images[@]} ; do
  docker pull $DOCKERHUB_URL/$imageName
  docker tag $DOCKERHUB_URL/$imageName $GCR_URL/$imageName
  docker rmi $DOCKERHUB_URL/$imageName
done

## 这里只需要留下还需要下载的组件的版本号
#ETCD_VERSION=3.4.3-0
DNS_VERSION=1.8.4

GCR_URL=k8s.gcr.io
## 这里写新的仓库地址
DOCKERHUB_URL=corelab

## 这里也只留下需要下载的镜像
images=(
#etcd:${ETCD_VERSION}
coredns:${DNS_VERSION}
)

for imageName in ${images[@]} ; do
  docker pull $DOCKERHUB_URL/$imageName
  docker tag $DOCKERHUB_URL/$imageName $GCR_URL/$imageName
  docker rmi $DOCKERHUB_URL/$imageName
done
