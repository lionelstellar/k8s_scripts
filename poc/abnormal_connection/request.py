#!/usr/bin/env python3
import requests

payload = '{"kind":"Event","apiVersion":"audit.k8s.io/v1","level":"Metadata","auditID":"bf7f0c74-55bf-4527-8e87-0072aa177bca","stage":"ResponseComplete","requestURI":"/apis/storage.k8s.io/v1/storageclasses?allowWatchBookmarks=true\u0026resourceVersion=830\u0026timeout=6m4s\u0026timeoutSeconds=364\u0026watch=true","verb":"watch","user":{"username":"system:apiserver","uid":"a15b8ac3-1da8-468a-accf-b28632533756","groups":["system:masters"]},"sourceIPs":["::1"],"userAgent":"kube-apiserver/v1.22.2 (linux/amd64) kubernetes/8b5a191","objectRef":{"resource":"storageclasses","apiGroup":"storage.k8s.io","apiVersion":"v1"},"responseStatus":{"metadata":{},"status":"Success","message":"Connection closed early","code":200},"requestReceivedTimestamp":"2021-12-15T08:34:41.094861Z","stageTimestamp":"2021-12-15T08:36:46.355361Z","annotations":{"authorization.k8s.io/decision":"allow","authorization.k8s.io/reason":""}}'
#url = "http://127.0.0.1:6443"
url = "http://172.16.238.136:6443"
r = requests.post(url, data=payload)
print(r.status_code)
print(r.content.decode("UTF-8"))