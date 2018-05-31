#!/bin/bash

kubectl create -f ./vnext-nginx-all.yaml

echo kubectl get pods -l app=nginx-pod -l version=2
kubectl get pods -l app=nginx-pod -l version=2