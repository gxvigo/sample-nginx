#!/bin/bash

kubectl apply -f ./vnext-nginx-service.yaml

echo kubectl get pods -l app=nginx-pod 
kubectl get pods -l app=nginx-pod 
