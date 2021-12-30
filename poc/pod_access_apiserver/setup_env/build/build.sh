#!/bin/bash
docker build -t ubuntu:k8s_test .
docker image prune

docker tag ubuntu:k8s_test 172.16.238.136:5000/ubuntu:k8s_test
docker push 172.16.238.136:5000/ubuntu:k8s_test