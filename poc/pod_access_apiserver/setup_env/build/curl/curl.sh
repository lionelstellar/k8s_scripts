#!/bin/bash
curl https://172.16.238.136:6443/api/v1/namespaces/default/pods \
    -vvvvv \
    --cacert ca_real.crt \
    --cert apiserver-kubelet-client.crt \
    --key apiserver-kubelet-client.key 
