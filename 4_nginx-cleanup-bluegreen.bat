@echo off

kubectl delete -f .\vnext-nginx-all.yaml
kubectl delete -f .\nginx-all.yaml
