@echo off

kubectl create -f ..\blue-deployment\nginx-persistentvolume.yaml
kubectl create -f ..\blue-deployment\nginx-persistentvolumeclaim.yaml
kubectl create -f ..\blue-deployment\nginx-deployment.yaml
kubectl create -f ..\blue-deployment\nginx-service.yaml

kubectl create -f ..\green-deployment\vnext-nginx-persistentvolume.yaml
kubectl create -f ..\green-deployment\vnext-nginx-persistentvolumeclaim.yaml
kubectl create -f ..\green-deployment\vnext-nginx-deployment.yaml


