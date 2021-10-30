#!/bin/bash
mkdir -p /etc/cni/net.d/ 
scp -r root@master:/etc/cni/net.d/* /etc/cni/net.d/