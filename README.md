---
# Kubernetes NGINX deployment
---



Sample deployment of nginx based web application with hostPath persistent volume (pv), persistent volume claim (pvc) and service (nodePort)


In the **worker nodes** create a directory as follow:

```
$ sudo mkdir -p /aStorage/nginx
$ sudo chmod 777 -R /aStorage/
```

and create a simple html page

```
$ echo "<html><body><h1>Blue is awesome></h1></body></html>" > /aStorage/nginx/index.html
```


To deploy the application to a kubernetes cluster run the command below. 
All resource files are listed and explained at the end of this file.

``` 
kubectl create -f .\nginx-all.yaml
```

It create all the resources necessary to run the application.
In the Service the nodePort has been set to 30000, to test the application just open a browser and point to the Proxy or Master node (depending on the the Cluster topology) port 30000


EG: http://192.168.225.11:30000/index.html




---

## Blue green deployment


In the **worker nodes** create a directory as follow:

```
$ sudo mkdir -p /aStorage/nginx-vnext
$ sudo chmod 777 -R /aStorage/
```

and create a simple html page

```
$ echo "<html><body><h1>...but Green is better></h1></body></html>" > /aStorage/nginx-vnext/index.html
```

Create a second deployment with a different persistent volume and persistent volume claim (does NOT create a different Service)

```
kubectl create -f vnext-nginx-all.yaml
```

At this stage 3 new Pods are running. This Pods have the same label name (nginx-pod) but a different label version number (2)

To switch the workload to the new version, apply the modified Service (same object created at the beginning with a different Selector)

```
kubectl apply -f .\vnext-nginx-service.yaml
```

Reload the browser (or open an incognito window to avoid caching), the new html is displayed.


## Workflow script

To run the first deployment and the BlueGreen deployment 4 script files have been created. Run sequentially:

```
01_nginx-create-all.sh   Create Blue deployment
```
Test in the browser

```
02_vnext-nginx-create-all.sh
```
```
03_vnext-nginx-switch-to-green.sh
```
Test in the browser

```
04_nginx-cleanup-bluegreen.sh
```

---
## Resource files

---

```
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nginx-persistentvolume
  resourceVersion: '63509'
  finalizers:
  - kubernetes.io/pv-protection
spec:
  capacity:
    storage: 10Mi
  hostPath:
    path: "/aStorage/nginx"
    type: ''
  accessModes:
  - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
```

```
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: nginx-persistentvolumeclaim
  namespace: default
spec:
  resources:
    requests:
      storage: 10Mi
  accessModes:
  - ReadWriteMany
```

```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx-deployment 
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-pod
  template:
    metadata:
      labels:
        app: nginx-pod
    spec:
      containers:
      - name: nginx
        image: nginx:1.13.1
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        ports:
          - containerPort: 80
        volumeMounts:
        - mountPath: "/usr/share/nginx/html"
          name: nginxvol
      volumes:
        - name: nginxvol
          persistentVolumeClaim:
            claimName: nginx-persistentvolumeclaim  
```


```
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  labels:
    app: nginx-service
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    # nodePort: 31320
  selector:
    app: nginx-pod
    
```    