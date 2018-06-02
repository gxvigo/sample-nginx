#!/bin/bash

# set script working directory
cd "$(dirname "$0")"

kubectl delete -f ../blue-deployment/nginx-all.yaml

kubectl delete -f ../green-deployment/vnext-nginx-all.yaml


