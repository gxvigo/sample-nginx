#!/bin/bash

# set script working directory
cd "$(dirname "$0")"

kubectl create -f ../blue-deployment/nginx-all.yaml


echo kubectl get pods -l app=nginx-pod -l version=1
kubectl get pods -l app=nginx-pod -l version=1
