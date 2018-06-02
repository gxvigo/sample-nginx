@echo off

kubectl create -f ..\green-deployment\vnext-nginx-persistentvolume.yaml
kubectl create -f ..\green-deployment\vnext-nginx-persistentvolumeclaim.yaml
kubectl create -f ..\green-deployment\vnext-nginx-deployment.yaml

echo kubectl get pods -l app=nginx-pod -l version=2
kubectl get pods -l app=nginx-pod -l version=2