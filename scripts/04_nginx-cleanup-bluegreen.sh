#!/bin/bash

# set script working directory
cd "$(dirname "$0")"

kubectl delete -f ../blue-deployment/nginx-persistentvolume.yaml
kubectl delete -f ../blue-deployment/nginx-persistentvolumeclaim.yaml
kubectl delete -f ../blue-deployment/nginx-deployment.yaml
kubectl delete -f ../blue-deployment/nginx-service.yaml

kubectl delete -f ../green-deployment/vnext-nginx-persistentvolume.yaml
kubectl delete -f ../green-deployment/vnext-nginx-persistentvolumeclaim.yaml
kubectl delete -f ../green-deployment/vnext-nginx-deployment.yaml

