#!/bin/bash
docker build -t ubuntu:k8s_test .
docker image prune