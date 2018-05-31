#!/bin/bash

kubectl create -f ./nginx-all.yaml

echo kubectl get pods -l app=nginx-pod -l version=1
kubectl get pods -l app=nginx-pod -l version=1
