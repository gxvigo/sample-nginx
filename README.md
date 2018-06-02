---
# Kubernetes NGINX deployment
---

<br>

Sample deployment of nginx based web application with hostPath persistent volume (pv), persistent volume claim (pvc), service (ClusterIP) and Ingress (nginx).

Role of the components:

* **deployment** - where Pods and ReplicaSet are defined
* **persistent volume** - the *driver* to connect to the storage
* **persistent volume claim** - the glue between the application (Pod) and the storage (persistent volume)
* **service** - how to expose a set of Pods to other entities
* **ingress** - how to expose a Service to external (to kubernetes clusters) consumers

Each one is explained in more details at the end of this file  

  
---
<br>
## Setup


In each **worker nodes** create a directory as follow:

```
$ sudo mkdir -p /aStorage/nginx
$ sudo chmod 777 -R /aStorage/
```

create a simple html page

```
$ echo "<html><body><h1>Blue is awesome></h1></body></html>" > /aStorage/nginx/index.html
```
and add in the *dns* or *hosts* file of the machine where you will test the web application the line:

```
<kubernetesProxyIP> nginxhost
```  
  
To deploy the application to a kubernetes cluster run the command below. 
All resource files are listed and explained at the end of this file.

``` 
kubectl create -f ./blue-deployment/nginx-all.yaml
```

It create all the resources necessary to run the application.
To test the application just open a browser and point to the hostname defined in the Ingress


[http://nginxhost/index.html] (http://nginxhost/index.html)  




---
<br>
## Blue Green deployment

We can now do something a little more sophisticated, deploying an updated version of our application and rolling out without client outage.


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
kubectl create -f ./green-deployment/vnext-nginx-all.yaml
```

At this stage, 3 new Pods are running. These Pods have the same label name (nginx-pod) but a different label version number (2)

To switch the workload to the new version (new set of Pods), apply the modified Service (same object created at the beginning with a different Selector)

```
kubectl apply -f ./green-deployment/vnext-nginx-service.yaml
```

Reload the browser (or open an incognito window to avoid caching), the new html is displayed.

[http://nginxhost/index.html] (http://nginxhost/index.html)  

---
<br>
## Workflow script

To run the first deployment and the BlueGreen deployment 4 script files have been created. 
From the project root directory, run sequentially:

```
./scripts/01_nginx-create-all.sh   Create Blue deployment and Service
```
Test in the browser - [http://nginxhost/index.html] (http://nginxhost/index.html)  


```
./scripts/02_vnext-nginx-create-all.sh   Create Green deployment
```
```
./scripts/03_vnext-nginx-switch-to-green.sh    Switch Service to new Pods
```
Test in the browser (open an incognito window to avoid caching) - [http://nginxhost/index.html] (http://nginxhost/index.html)  


```
./scripts/04_nginx-cleanup-bluegreen.sh     Remove all the resources previously created
```

---
<br>
## Resource files

<br>

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