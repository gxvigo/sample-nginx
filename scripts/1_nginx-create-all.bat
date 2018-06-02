@echo off
cls
kubectl create -f ..\blue-deployment\nginx-persistentvolume.yaml
kubectl create -f ..\blue-deployment\nginx-persistentvolumeclaim.yaml
kubectl create -f ..\blue-deployment\nginx-deployment.yaml
kubectl create -f ..\blue-deployment\nginx-service.yaml

REM all yaml file could have been aggregated to a single one and we 
REM could have run a single kubectl command, but this ways it's cleaner 
REM what we execute

echo kubectl get pods -l app=nginx-pod -l version=1
kubectl get pods -l app=nginx-pod -l version=1