#!/bin/bash

NEW_NS="fst-manage"

check_new_ns(){
    fst_ns=`kubectl get namespaces | grep $NEW_NS | awk '{print $1}'`
    if [ "$fst_ns" == $NEW_NS ]; then
        echo "[*] $NEW_NS NS already exists"
    else
        echo "[*] creating $NEW_NS NS..."
        kubectl create namespace $NEW_NS
    fi
}

check_new_ns
