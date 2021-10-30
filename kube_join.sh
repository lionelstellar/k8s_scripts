#!/bin/bash
if [ "$1" == "master" ]; then
	ip=172.16.238.136
else
	ip=172.16.238.138
fi

echo $ip

kubeadm join $ip:6443 --token cy0p6q.tl48zr12c8im4tk1 --discovery-token-ca-cert-hash sha256:77eb7566ccb504800819baef228e461a8b63e5a488f89578bcb46353571f093e
