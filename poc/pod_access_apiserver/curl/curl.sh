#!/bin/bash
curl https://172.16.238.136:6443/ --cacert ca.crt \
    --cert apiserver-kubelet-client.crt \
    --key apiserver-kubelet-client.key \
    -vvvvv

