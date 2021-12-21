#!/bin/bash

check_fst-manage_ns(){
    fst_ns=`kubectl get namespaces | grep fst-manage | awk '{print $1}'`
    if [ "$fst_ns" == "fst-manage" ]; then
        echo "[*] fst-manage NS already exists"
    else
        echo "[*] creating fst-manage NS..."
        kubectl create namespace fst-manage
    fi
}

check_fst-manage_ns
