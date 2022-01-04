创建role
```
kubectl create role pods-reader --verb=get,list,watch --resource=pods --namespace=test
```

创建rolebinding
```
kubectl apply -f role_binding.yaml
```