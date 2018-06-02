#!/bin/bash

# set script working directory
cd "$(dirname "$0")"

kubectl create -f ../green-deployment/vnext-nginx-all.yaml


echo kubectl get pods -l app=nginx-pod -l version=2
kubectl get pods -l app=nginx-pod -l version=2