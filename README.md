# NGINX deployment

Sample deployment of nginx with hostPath persistent volume (pv), persistent volume claim (pvc) and service (nodePort)


In the **worker node** create a directory as follow:

```
$ sudo mkdir -p /aStorage/nginx
$ sudo chmod 777 -R /aStorage/
```

and create a simple html page

```
$ echo "<html><body><h1>Blue is awesome!</h1></body></html>" > /aStorage/nginx/index1.html
```


To deploy the application to a kubernetes cluster run the following command:

``` 
kubectl create -f .\nginx-all.yaml
```

It create all the resources necessary to run the application.
To identified the port exposed by nodePort run the command:

``` 
$  kubectl describe service nginx-service
```

The property 'NodePort:' gives the value of the TCP Port to use with the cluster (Proxy or Master IP addres).
EG: http://192.168.225.11:32106/index.html


To cleanup the environment (delete all the resources) run:

``` 
kubectl delete -f .\nginx-all.yaml
```
