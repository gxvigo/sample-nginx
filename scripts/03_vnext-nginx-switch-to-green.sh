#!/bin/bash

# set script working directory
cd "$(dirname "$0")"

kubectl apply -f ../green-deployment/vnext-nginx-service.yaml

echo kubectl get pods -l app=nginx-pod 
kubectl get pods -l app=nginx-pod 
